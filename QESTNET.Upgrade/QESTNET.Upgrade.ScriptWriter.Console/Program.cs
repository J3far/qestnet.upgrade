using Fclp;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Spectra.QESTNET.Upgrade.ScriptWriter
{
    class Program
    {
        static void Main(string[] args)
        {
            var config = ConfigurationManager.OpenExeConfiguration(null);

            var p = new FluentCommandLineParser<ApplicationArgs>();
            //output options
            p.Setup(o => o.WriteTableStructure)
                .As('t', "tables")
                .SetDefault(false)
                .WithDescription("Write table structure script (from template database)");;;
            p.Setup(o => o.WriteForeignKeys)
                .As('k', "foreign-keys")
                .SetDefault(false)
                .WithDescription("Write foreign-keys script (from template database)");;
            p.Setup(o => o.WriteQestObjects)
                .As('q', "qestobjects")
                .SetDefault(false)
                .WithDescription("Write qestobjects script (from qestlab.qes)");

            //Source database
            p.Setup(o => o.DatabaseServer)
                .As('S', "db-server")
                .WithDescription("Server name for template database");;
            p.Setup(o => o.DatabaseName)
                .As('D', "db-database")
                .WithDescription("Database name for template database");
            p.Setup(o => o.DatabaseUser)
                .As('U', "db-username")
                .WithDescription("Username for SQL authentication (if omitted, windows authentication is used)");
            p.Setup(o => o.DatabasePassword)
                .As('P', "db-password")
                .WithDescription("Password for SQL authentication");

            p.Setup(o => o.Silent)
                .As('s', "silent")
                .WithDescription("Silent mode (no progress updates displayed).");

            //dest folder
            p.Setup(o => o.ScriptFolder)
                .As('d', "dest-folder")
                .SetDefault((config.AppSettings.Settings["upgradeScriptPath"] ?? new KeyValueConfigurationElement("upgradeScriptPath", null)).Value)
                .WithDescription("Output folder for database scripts");
            
            //qestlab qes folder
            p.Setup(o => o.QestlabQesPath)
                .As('Q', "qestlab-qes")
                .SetDefault((config.AppSettings.Settings["qestlabQesPath"] ?? new KeyValueConfigurationElement("qestlabQesPath", null)).Value)
                .WithDescription("QESTLab qes path");
            
            p.SetupHelp("?", "help")
                .WithCustomFormatter(new CustomOptionFormatter())
                .Callback(text => Console.WriteLine(text))
                .UseForEmptyArgs();

            var result = p.Parse(args);
            if (result.EmptyArgs) return;
            
            //Default connection string
            p.Object.DefaultConnectionString = config.ConnectionStrings.ConnectionStrings["Template Database"].ConnectionString;

            if (result.HasErrors )
            {
                Console.Error.WriteLine(result.ErrorText);
                return;
            }

            //validate args
            try
            {
                ValidateArgs(p.Object);
            }
            catch (Exception e)
            {
                Console.Error.WriteLine(e.Message);
                var innerException = e.InnerException;
                while (innerException != null)
                {
                    Console.Error.WriteLine("  " + innerException.Message);
                    innerException = innerException.InnerException;
                }
                return;
            }

            //Write the scripts!
            Console.CancelKeyPress += CancelScriptWrite;

            WriteScripts(p.Object);


            //wait for scripts to finish
            while (Tasks.Any(x => !x.IsCompleted))
            {
                System.Threading.Thread.Sleep(20);
            }
        }

        private static CancellationTokenSource CancelWrite;
        private static List<Task> Tasks { get; set; }

        private static void WriteScripts(ApplicationArgs args)
        {
            var writers = new List<ScriptWriterBase>();

            if (args.WriteTableStructure)
                writers.Add(new TableStructureScriptWriter(args.ConnectionString, Path.Combine(args.ScriptFolder, @"structure\structure.tables.qn.sql")));

            if (args.WriteForeignKeys)
                writers.Add(new ForeignKeysScriptWriter(args.ConnectionString, Path.Combine(args.ScriptFolder, @"structure\structure.foreignkeys.qn.sql")));

            if (args.WriteQestObjects)
                writers.Add(new QestObjectsScriptWriter(args.QestlabQesPath,  Path.Combine(args.ScriptFolder, @"data\data.object_types.qn.sql"), Path.Combine(Path.GetDirectoryName(args.QestlabQesPath), "QESTLabObjects.sql")));

            if (writers.Count() == 0)
                return;

            if (!args.Silent)
            {
                foreach (var w in writers)
                    w.ProgressWrite += WriteProgress;
            }

            CancelWrite = new CancellationTokenSource();

            Tasks = writers.Select(w => w.WriteToFileAsync(CancelWrite.Token)).ToList();          
            
            foreach (var t in Tasks)
                t.ContinueWith(WriteComplete);

            Tasks.First().Start();
        }

        private static void WriteComplete(Task task)
        {
            if (task.IsFaulted)
            {
                Console.Error.WriteLine(task.Exception.ToString());
            }
            else
            {
                // Move into the next task if there is one
                Tasks.Remove(task);
                
                if (Tasks.Any())
                {
                    Tasks.First().Start();
                    return;
                }


                if (CancelWrite != null)
                {
                    if (CancelWrite.IsCancellationRequested)
                        Console.Out.WriteLine("Script write cancelled. WARNING: Script is incomplete.");
                    else
                        Console.Out.WriteLine("Script write complete.");
                }
            }

            CancelWrite = null;
        }

        private static void CancelScriptWrite(object sender, ConsoleCancelEventArgs e)
        {
            if (CancelWrite != null && !CancelWrite.IsCancellationRequested)
            {
                Console.Out.WriteLine("Cancellation requested...");
                CancelWrite.Cancel();
                e.Cancel = true;
            }
            return;
        }

        private static void WriteProgress(object sender, ScriptWriteProgressEventArgs e)
        {
            Console.Out.WriteLine(string.Format("{0,5:##0.0}% {1}", e.PercentProgress, e.ProgressText));
        }


        static void ValidateArgs(ApplicationArgs args)
        {
            try
            {
                using (var cn = new SqlConnection(args.ConnectionString))
                {
                    cn.Open();
                    cn.Close();
                }
            }
            catch (Exception)
            {
                Console.Error.WriteLine(string.Format("Connection String: {0}", args.ConnectionString));
                throw;
            }

            if (!File.Exists(args.QestlabQesPath))
            {
                throw new FileNotFoundException("File 'qestlab.qes' could not be found", args.QestlabQesPath);
            }

            if (!Directory.Exists(args.ScriptFolder))
            {
                throw new FileNotFoundException("Script folder could not be found", args.ScriptFolder);
            }

            if (!(args.WriteTableStructure || args.WriteForeignKeys || args.WriteQestObjects))
            {
                throw new ArgumentException("Nothing to write");
            }
        }
    }
}
