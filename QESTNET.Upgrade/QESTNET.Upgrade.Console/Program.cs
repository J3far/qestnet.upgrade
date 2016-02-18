using Fclp;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;

namespace Spectra.QESTNET.Upgrade
{   
    class Program
    {
        static CancellationTokenSource CancelUpgrade = null;
        static List<Task> Tasks = new List<Task>();

        static void Main(string[] args)
        {
            Console.CancelKeyPress += Console_CancelKeyPress;

            var config = ConfigurationManager.OpenExeConfiguration(null);

            var p = new FluentCommandLineParser<AppArgs>();

            p.Setup(o => o.ManifestPath)
                .As('m', "manifest")
                .SetDefault((config.AppSettings.Settings["manifestPath"] ?? new KeyValueConfigurationElement("manifestPath", null)).Value)
                .WithDescription("Upgrade manifest file");

            var connectionStringNames = config.ConnectionStrings.ConnectionStrings.OfType<ConnectionStringSettings>().Select(x => x.Name);
            p.Setup(o => o.ConnectionName)
                .As('c', "connection-name")
                .WithDescription("Name of a connection string (defined in config file): " + string.Join("; ", connectionStringNames));

            p.Setup(o => o.Repair)
                .As("repair")
                .WithDescription("Repair flag (I don't know what this does...)");

            //QESTLab database to update
            p.Setup(o => o.DatabaseServer)
                .As('S', "db-server")
                .WithDescription("Server name for target QESTLab database"); ;
            p.Setup(o => o.DatabaseName)
                .As('D', "db-database")
                .WithDescription("Database name for target QESTLab database");
            p.Setup(o => o.DatabaseUser)
                .As('U', "db-username")
                .WithDescription("Username for SQL authentication (if omitted, windows authentication is used)");
            p.Setup(o => o.DatabasePassword)
                .As('P', "db-password")
                .WithDescription("Password for SQL authentication");

            p.Setup(o => o.DisableTransactionScope)
                .As("disable-transaction-scope")
                .SetDefault(false)
                .WithDescription("Disable use of a transaction-scope per-script.  This will result in partial upgrade scripts being run on your database.  Never recommended.");

            p.Setup(o => o.TransactionTimeoutText)
                .As("override-transaction-timeout")
                .SetDefault(string.Empty)
                .WithDescription("Override the maximum transaction timeout configured in machine.config.  This requires full trust, and should only be used when absolutely neccessary.");

            p.SetupHelp("?", "help")
                .Callback(text => Console.WriteLine(text))
                .WithCustomFormatter(new CustomOptionFormatter())
                .UseForEmptyArgs();

            var result = p.Parse(args);
            p.Object.ConnectionStrings = config.ConnectionStrings.ConnectionStrings.OfType<ConnectionStringSettings>();

            if (result.EmptyArgs)
            {
                return;
            }
            
            
            if (result.HasErrors)
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

            BeginDatabaseUpgrade(p.Object);

            //wait for scripts to finish
            while (Tasks.Any(x => !x.IsCompleted))
            {
                System.Threading.Thread.Sleep(20);
            }

        }

        static void Console_CancelKeyPress(object sender, ConsoleCancelEventArgs e)
        {
            if (CancelUpgrade != null && !CancelUpgrade.IsCancellationRequested)
            {
                Console.WriteLine("Requesting cancellation ...");
                CancelUpgrade.Cancel();
                e.Cancel = true;
                return;
            }
        }

        private static void UpgradeComplete(Task task)
        {
            CancelUpgrade = null;
        }

        private static IEnumerable<Regex> _supressMessageExpressions = new List<Regex>() {
            new Regex("Executing command [0-9]*[^0] of [3-9][0-9]+ ...", RegexOptions.IgnoreCase),
            new Regex("Executing command [0-9]*[^0] of [1-9][0-9][0-9]+ ...", RegexOptions.IgnoreCase),
            new Regex("Executing command [0-9]*[^0]0 of [2-9][0-9][0-9] ...", RegexOptions.IgnoreCase),
            new Regex("Executing command [0-9]*[^0]0 of [1-9][0-9][0-9][0-9]+ ...", RegexOptions.IgnoreCase)
        };

        private static void PrintMessage(string message)
        {
            message = message.Trim();
            if (_supressMessageExpressions.Any(rex => rex.Match(message).Success))
            {
                Console.Write('.');
                return;
            }
            if (message.EndsWith(" ..."))
            {
                message = message.Substring(0, message.Length - 4);
            }
            Console.WriteLine();
            Console.Write(message);
        }

        private static void BeginDatabaseUpgrade(AppArgs args)
        {
            var manifest = new UpgradeManifest(new FileInfo(args.ManifestPath));
            //manifest.Message += Console.WriteLine;

            if (args.TransactionTimeout.HasValue)
            {
                Console.WriteLine("Setting transaction timeout to {0}", args.TransactionTimeout);
                TransactionUtils.MaximumTransactionTimeout = args.TransactionTimeout.Value;
            }

            var dbu = new DatabaseUpgrade(manifest, args.GetConnectionString())
            {
                OptionRepair = args.Repair,
                DisableTransactionScope = args.DisableTransactionScope
            };
            dbu.Message += PrintMessage;

            CancelUpgrade = new CancellationTokenSource();

            var upgrade = dbu.ExecuteAsync(CancelUpgrade.Token);
            upgrade.ContinueWith(UpgradeComplete);
            upgrade.Start();

            Tasks.Add(upgrade);
        }


        private static void ValidateArgs(AppArgs args)
        {
            try
            {
                using (var cn = new SqlConnection(args.GetConnectionString()))
                {
                    cn.Open();
                    cn.Close();
                }
            }
            catch (Exception)
            {
                Console.Error.WriteLine(string.Format("Connection String: {0}", args.GetConnectionString()));
                throw;
            }

            if (!File.Exists(args.ManifestPath))
            {
                throw new FileNotFoundException("Manifest file could not be found", args.ManifestPath);
            }

            if (args.TransactionTimeout.HasValue)
            {
                var MIN_TRANSACTION_TIMEOUT = TimeSpan.FromMinutes(1);
                if (args.TransactionTimeout.Value < MIN_TRANSACTION_TIMEOUT)
                    throw new ArgumentOutOfRangeException(string.Format("Transaction timeout must be at least {0}", MIN_TRANSACTION_TIMEOUT));
            }
        }
    }
}
