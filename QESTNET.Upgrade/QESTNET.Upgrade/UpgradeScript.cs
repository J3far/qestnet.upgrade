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

    public class UpgradeScript
    {
        // Regex which detects lines with only contain GO
        private readonly Regex regexSplitOnGo = new Regex(@"^\s*GO\s*$", RegexOptions.IgnoreCase | RegexOptions.Multiline | RegexOptions.Compiled);

        FileInfo file;
        SqlConnection connection;
        string[] queries;

        public Action<string> Message;

        public UpgradeScript(FileInfo file, SqlConnection connection)
        {
            if (file == null) throw new ArgumentNullException("file");
            if (connection == null) throw new ArgumentNullException("connection");

            this.file = file;
            this.connection = connection;
            var script = File.ReadAllText(this.file.FullName, Encoding.GetEncoding(1252)); // Default Windows ANSI code page (allows cubed etc).
            this.queries = this.regexSplitOnGo.Split(script).Where(q => !string.IsNullOrWhiteSpace(q)).ToArray(); 
        }

        public Task ExecuteAsync(CancellationToken cancellationToken)
        {
            var task = new Task(() =>
                {
                    for (int i = 0; i < queries.Length; i++)
                    {
                        this.Message(string.Format("   Executing command {0} of {1} ...", i + 1, queries.Length));

                        using (var cmd = new SqlCommand(queries[i], this.connection))
                        {
                            cmd.CommandTimeout = Convert.ToInt32(new TimeSpan(10, 0, 0).TotalSeconds); // 10 hour timeout (due to PSI document upgrades taking a long time)
                            cmd.CommandType = CommandType.Text;

                            try
                            {
                                var asy = cmd.BeginExecuteNonQuery();
                                asy.AsyncWaitHandle.WaitOne();
                                cmd.EndExecuteNonQuery(asy);
                            }
                            catch (SqlException e)
                            {
                                throw new UpgradeScriptException(this.file.Name, this.queries[i], e);
                            }
                            catch (InvalidOperationException e)
                            {
                                //this can occur when there is a transaction timeout -- I don't know if there is a better way of determining the
                                //underlying cause, but it's the best I could come up with (and the default error message is somewhat obtuse)...
                                if (e.Message.Contains("The transaction associated with the current connection has completed but has not been disposed."))
                                    throw new UpgradeScriptException(this.file.Name, this.queries[i], "Transaction timeout elapsed.", e);
                                else
                                    throw new UpgradeScriptException(this.file.Name, this.queries[i], e.Message + " (possibly a transaction timeout)", e);
                            }
                        }

                        if (cancellationToken.IsCancellationRequested)
                        {
                            this.Message("   File execution cancelled.");
                            return;
                        }                           
                    }
                }
            );

            return task;
        }

    }

   

}
