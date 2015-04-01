using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Transactions;
using System.Threading;

namespace Spectra.QESTNET.Upgrade
{

    public class DatabaseUpgrade
    {
        private readonly string systemValueName = "QestnetDatabaseVersion";

        private readonly string connectionString;
        private readonly UpgradeManifest manifest;
        private readonly Version currentVersion;

        public bool OptionRepair
        {
            get;
            set;
        }

        public Action<string> Message;

        public DatabaseUpgrade(UpgradeManifest manifest, string connectionString)
        {
            if (manifest == null)
                throw new ArgumentNullException("manifest");

            if (string.IsNullOrEmpty(connectionString))
                throw new ArgumentOutOfRangeException("connectionString");

            this.manifest = manifest;
            this.connectionString = connectionString;

            // Load current version number
            var currentVersionString = QestlabDatabaseHelper.GetSystemValue(this.connectionString, "QestnetDatabaseVersion");
            if (!string.IsNullOrEmpty(currentVersionString))
            {
                if (!Version.TryParse(currentVersionString, out this.currentVersion))
                    throw new Exception("The current QestnetDatabaseVersion in qestSystemValues is not a valid version number.");
            }

            this.CheckVersion();
        }

        public Task ExecuteAsync(CancellationToken cancellationToken)
        {
            var task = new Task(() =>
                {
                    this.Message("Commencing database upgrade...");
                    this.Message(string.Format("Current database version: {0}", this.currentVersion == default(Version) ? "none" : this.currentVersion.ToString()));

                    // Set the repair option unless it is a brand new database in which case option cannot be set
                    if (this.currentVersion != default(Version))
                        this.SetOption("Repair", this.OptionRepair ? "True" : "False");

                    // Execute the files
                    for (int i = 0; i < this.manifest.ScriptFiles.Length; i++)
                    {
                        this.Message(string.Format("Executing file '{0}' ({1} of {2}) ...", this.manifest.ScriptFiles[i].Name, i + 1, this.manifest.ScriptFiles.Length));

                        try
                        {
                            // Transaction scope only supports maximum 10 minutes - PSI individual scripts take longer than that
                            //using (var ts = new TransactionScope(TransactionScopeOption.Required, new TimeSpan(1, 0, 0)))
                            //{
                                using (var conn = new SqlConnection(connectionString))
                                {
                                    conn.InfoMessage += this.PrintInfoMessage;
                                    conn.Open();

                                    var script = new UpgradeScript(this.manifest.ScriptFiles[i], conn);
                                    script.Message = this.Message;
                                    var scriptTask = script.ExecuteAsync(cancellationToken);
                                    scriptTask.Start();
                                    try
                                    {
                                        scriptTask.Wait(); // wait for script to finish
                                    }
                                    catch (Exception e)
                                    {
                                        this.Message(e.ToString());
                                        if (scriptTask.Exception != null)
                                        {
                                            this.Message(scriptTask.Exception.ToString());
                                        }
                                        throw;
                                    }
                                    if (cancellationToken.IsCancellationRequested)
                                    {
                                        this.Message("Database upgrade cancelled.  Completed files have been committed.");
                                        return;
                                    }
                                }

                            //    ts.Complete();
                            //}
                        }
                        catch (Exception e)
                        {
                            this.Message(e.ToString());
                            var innerException = e.InnerException;
                            while (innerException != null)
                            {
                                this.Message(innerException.ToString());
                                innerException = innerException.InnerException;
                            }
                            this.Message(string.Format("File '{0}' aborted due to an unhandled exception.  No changes were committed for this file.", this.manifest.ScriptFiles[i].Name));
                            this.SetOption("Repair", "False");
                            this.Message("Database upgrade aborted.");
                            return;
                        }

                    }

                    this.Message(string.Format("Writing new database version: {0}", this.manifest.UpgradeVersion.ToString()));
                    QestlabDatabaseHelper.SetSystemValue(this.connectionString, systemValueName, this.manifest.UpgradeVersion.ToString());
                    this.SetOption("Repair", "False");
                    this.Message("Database upgrade complete.");
                }
            );

            return task;
        }

        // fixme: parameterise etc
        protected void SetOption(string name, string value)
        {
            QestlabDatabaseHelper.SetSystemValue(this.connectionString, "QestnetUpgradeOption_" + name, value);
            this.Message(string.Format("Set upgrade option '{0}' = '{1}',", "QestnetUpgradeOption_" + name, value));
        }

        protected void CheckVersion()
        {
            if (this.manifest.UpgradeVersion == default(Version))
                throw new Exception("No upgrade version is set for the upgrade manifest.");

            // If current version is not set then any upgrade version is allowed
            if (this.currentVersion != default(Version))
            {
                if (this.manifest.UpgradeVersion < this.currentVersion)
                    throw new Exception("The requested QESTNET upgrade version is older than the database QESTNET version.");

                // Just allow re-run for now
                //if (this.manifest.UpgradeVersion == this.currentVersion)
                //    throw new Exception("The requested QESTNET upgrade version is the same as the database QESTNET version.");
            }
        }

        protected void PrintInfoMessage(object sender, SqlInfoMessageEventArgs e)
        {
            foreach (SqlError error in e.Errors)
            {
                this.Message(string.Format("{0}", error.Message));
            }
        }

    }

}
