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

namespace Spectra.QESTNET.Upgrade
{
    public static class QestlabDatabaseHelper
    {   
        public static string GetSystemValue(string connectionString, string name)
        {
            using (var conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (var cmd = new SqlCommand(
                    @"IF EXISTS(SELECT * FROM information_schema.tables WHERE table_schema = 'dbo' AND table_name = 'qestSystemValues')
                        SELECT ISNULL([Value], N'') FROM qestSystemValues WHERE Name = @name
                      ELSE
                        SELECT N''"
                , conn))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.Add(new SqlParameter("name", name));
                    return (string)cmd.ExecuteScalar();
                }
            }
        }

        public static void SetSystemValue(string connectionString, string name, string value)
        {
            using (var conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (var cmd = new SqlCommand(
                    @"IF NOT EXISTS(SELECT 1 FROM qestSystemValues WHERE Name = @name)
                    BEGIN
                        INSERT INTO qestSystemValues (Name, Value) VALUES (@name, @value)
                    END ELSE BEGIN
                        UPDATE qestSystemValues SET Value = @value WHERE Name = @name
                    END"
                , conn))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.Add(new SqlParameter("name", name));
                    cmd.Parameters.Add(new SqlParameter("value", value));
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }


}
