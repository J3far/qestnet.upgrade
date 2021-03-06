﻿using System;
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
            var script = File.ReadAllText(this.file.FullName);
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
                            cmd.CommandTimeout = Convert.ToInt32(new TimeSpan(1, 0, 0).TotalSeconds); // hour timeout
                            cmd.CommandType = CommandType.Text;
                            var queryTask = cmd.ExecuteNonQueryAsync();

                            try
                            {
                                queryTask.Wait(cancellationToken); // run only one query at a time
                            }
                            catch (OperationCanceledException e)
                            {
                                this.Message("   File execution cancelled.");
                                return;
                            }
                            catch (Exception e)
                            {
                                throw;
                            }
                        }
                    }
                }
            );

            return task;
        }
    }

   

}
