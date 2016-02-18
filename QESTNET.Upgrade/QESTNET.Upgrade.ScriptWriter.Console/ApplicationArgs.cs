using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Spectra.QESTNET.Upgrade.ScriptWriter
{
    class ApplicationArgs
    {
        public string DefaultConnectionString { get; set; }

        public bool WriteTableStructure { get; set; }
        public bool WriteForeignKeys { get; set; }
        public bool WriteQestObjects { get; set; }

        public string DatabaseServer { get; set; }
        public string DatabaseName { get; set; }
        public string DatabaseUser { get; set; }
        public string DatabasePassword { get; set; }

        public string ScriptFolder { get; set; }
        public string QestlabQesPath { get; set; }

        public bool Silent { get; set; }

        public string ConnectionString
        {
            get
            {
                if (!string.IsNullOrEmpty(DatabaseServer) && !string.IsNullOrEmpty(DatabaseName))
                {
                    //build a connection string
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
                else
                {
                    var connectionStringBuilder = new SqlConnectionStringBuilder(DefaultConnectionString);
                    if (string.IsNullOrEmpty(connectionStringBuilder.UserID))
                    {
                        connectionStringBuilder.IntegratedSecurity = true;
                    }
                    connectionStringBuilder.ConnectTimeout = 5;
                    return connectionStringBuilder.ToString();
                }
            }
        }
    }


}
