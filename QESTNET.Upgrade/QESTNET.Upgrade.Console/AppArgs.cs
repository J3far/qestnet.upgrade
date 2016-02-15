using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Spectra.QESTNET.Upgrade
{

    class AppArgs
    {
        public string ManifestPath { get; set; }
        public bool Repair { get; set; }
        public string ConnectionName { get; set; }

        public string DatabaseServer { get; set; }
        public string DatabaseName { get; set; }
        public string DatabaseUser { get; set; }
        public string DatabasePassword { get; set; }

        public string DSN { get; set; }

        public bool DisableTransactionScope { get; set; }
        public string TransactionTimeoutText { get; set; }

        public IEnumerable<ConnectionStringSettings> ConnectionStrings { get; set; }

        public TimeSpan? TransactionTimeout
        {
            get
            {
                if (string.IsNullOrEmpty(TransactionTimeoutText))
                    return null;
                return
                    TimeSpan.Parse(TransactionTimeoutText);
            }
        }

        public string GetConnectionString()
        {
            if (!string.IsNullOrEmpty(DatabaseServer) && !string.IsNullOrEmpty(DatabaseName))
            {
                var connectionStringBuilder = new SqlConnectionStringBuilder();
                connectionStringBuilder.DataSource = DatabaseServer;
                connectionStringBuilder.InitialCatalog = DatabaseName;
                if (string.IsNullOrEmpty(DatabaseUser))
                {
                    connectionStringBuilder.IntegratedSecurity = true;
                }
                else
                {
                    connectionStringBuilder.IntegratedSecurity = false;
                    connectionStringBuilder.UserID = DatabaseUser;
                    connectionStringBuilder.Password = DatabasePassword;
                }
                connectionStringBuilder.ConnectTimeout = 5;
                return connectionStringBuilder.ToString();
            }

            if (DSN != null)
            {
                var connectionStringBuilder = new SqlConnectionStringBuilder();
                var odbcConnectionStringBuilder = new System.Data.Odbc.OdbcConnectionStringBuilder("DSN=" + DSN);
                connectionStringBuilder.AsynchronousProcessing = true;
                connectionStringBuilder.ConnectTimeout = 5;
                connectionStringBuilder.DataSource = (string)odbcConnectionStringBuilder["Server"];
                connectionStringBuilder.InitialCatalog = (string)odbcConnectionStringBuilder["Database"];
                connectionStringBuilder.MultipleActiveResultSets = true;
                connectionStringBuilder.ApplicationName = System.Reflection.Assembly.GetEntryAssembly().GetName().Name;
                connectionStringBuilder.IntegratedSecurity = true;
                return connectionStringBuilder.ToString();
            }

            if (ConnectionStrings != null && !(string.IsNullOrEmpty(ConnectionName)))
            {
                var connectionStringSetting = ConnectionStrings.SingleOrDefault(x => x.Name == ConnectionName);
                if (connectionStringSetting == null) throw new ArgumentException(string.Format("Cannot find a connection string named \"{0}\"", ConnectionName), "ConnectionName");
                return connectionStringSetting.ConnectionString;
            }

            return null;
        }
    }
}
