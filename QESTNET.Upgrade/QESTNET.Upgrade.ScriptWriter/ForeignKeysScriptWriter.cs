using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using Microsoft.SqlServer.Management.Smo;
using Microsoft.SqlServer.Management.Common;

namespace Spectra.QESTNET.Upgrade.ScriptWriter
{

    internal class ForeignKeyConstraint
    {
        private readonly string constraintName;
        private readonly string tableName;
        private readonly string primaryTableName;
        private readonly string updateRule;
        private readonly string deleteRule;
        private readonly List<string> columnNames;
        private readonly List<string> primaryColumnNames;

        public string ConstraintName
        {
            get { return this.constraintName; }
        }

        public string TableName
        {
            get { return this.tableName; }
        }

        public string PrimaryTableName
        {
            get { return this.primaryTableName; }
        }

        public string UpdateRule
        {
            get { return this.updateRule; }
        }

        public string DeleteRule
        {
            get { return this.deleteRule; }
        }

        public List<string> ColumnNames
        {
            get { return this.columnNames; }
        }

        public List<string> PrimaryColumnNames
        {
            get { return this.primaryColumnNames; }
        }

        public ForeignKeyConstraint(string constraintName, string tableName, string primaryTableName, string updateRule, string deleteRule)
        {
            if (string.IsNullOrEmpty(constraintName))
                throw new ArgumentNullException(constraintName); 
            
            if (string.IsNullOrEmpty(tableName))
                throw new ArgumentNullException(tableName);

            if (string.IsNullOrEmpty(primaryTableName))
                throw new ArgumentNullException(primaryTableName);

            if (string.IsNullOrEmpty(updateRule))
                throw new ArgumentNullException(updateRule);

            if (string.IsNullOrEmpty(deleteRule))
                throw new ArgumentNullException(deleteRule);

            this.tableName = tableName;
            this.primaryTableName = primaryTableName; 
            this.constraintName = constraintName;
            this.updateRule = updateRule;
            this.deleteRule = deleteRule;
            this.columnNames = new List<string>();
            this.primaryColumnNames = new List<string>();
        }

    }

    public class ForeignKeysScriptWriter : ScriptWriterBase
    {
        public ForeignKeysScriptWriter(string connectionString, string fileName)
            : base(connectionString, fileName)
        { }

        protected override void WriteToFile(CancellationToken cancelToken)
        {
            if (cancelToken.IsCancellationRequested)
                return;

            var s = new SqlConnection(this.connectionString);
            Server srv = new Server(s.DataSource);
            var db = srv.Databases[s.Database];

            using (StreamWriter fs = System.IO.File.CreateText(fileName))
            {
                var dsForeignKeys = db.ExecuteWithResults(string.Format(@"
                    SELECT FK.CONSTRAINT_NAME, FK.TABLE_NAME, PK.TABLE_NAME AS PRIMARY_TABLE_NAME, C.UPDATE_RULE, C.DELETE_RULE
                    FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
                    INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
                    INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
                    ORDER BY FK.TABLE_NAME, FK.CONSTRAINT_NAME"));

                var rowCount = dsForeignKeys.Tables[0].Rows.Count;

                for(var i=0; i<rowCount; i++)
                {
                    var row = dsForeignKeys.Tables[0].Rows[i];

                    var fkc = new ForeignKeyConstraint(
                        row.Field<string>("CONSTRAINT_NAME"),
                        row.Field<string>("TABLE_NAME"),
                        row.Field<string>("PRIMARY_TABLE_NAME"),
                        row.Field<string>("UPDATE_RULE"),
                        row.Field<string>("DELETE_RULE")
                    );

                    var dsColumns = db.ExecuteWithResults(string.Format(@"
                        SELECT C.CONSTRAINT_NAME, FK.TABLE_NAME, PK.TABLE_NAME, CFK.COLUMN_NAME, CPK.COLUMN_NAME AS PRIMARY_COLUMN_NAME
                        FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
                        INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
                        INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
                        INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CFK ON C.CONSTRAINT_NAME = CFK.CONSTRAINT_NAME
                        INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CPK ON C.UNIQUE_CONSTRAINT_NAME = CPK.CONSTRAINT_NAME AND CFK.ORDINAL_POSITION = CPK.ORDINAL_POSITION
                        WHERE C.CONSTRAINT_NAME = '{0}'
                        ORDER BY FK.TABLE_NAME, FK.CONSTRAINT_NAME, CFK.ORDINAL_POSITION
                        ", fkc.ConstraintName));

                    foreach (DataRow r in dsColumns.Tables[0].Rows)
                    {
                        fkc.ColumnNames.Add(r.Field<string>("COLUMN_NAME"));
                        fkc.PrimaryColumnNames.Add(r.Field<string>("PRIMARY_COLUMN_NAME"));
                    }

                    fs.Write(string.Format("IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME = '{0}')\r\n", fkc.ConstraintName));
                    fs.Write("BEGIN\r\n");
                    fs.Write(string.Format("\tALTER TABLE [dbo].[{0}] WITH CHECK ADD CONSTRAINT [{1}] FOREIGN KEY([{2}]) REFERENCES [dbo].[{3}] ([{4}]) ON UPDATE {5} ON DELETE {6}\r\n",
                        fkc.TableName,
                        fkc.ConstraintName,
                        string.Join("],[", fkc.ColumnNames),
                        fkc.PrimaryTableName,
                        string.Join("],[", fkc.PrimaryColumnNames),
                        fkc.UpdateRule,
                        fkc.DeleteRule
                    ));
                    fs.Write("END\r\n");
                    fs.Write("GO\r\n\r\n");
                    fs.Flush();

                    this.RaiseProgress(fkc.ConstraintName, (i * 100f) / rowCount);

                    if (cancelToken.IsCancellationRequested)
                        return;
                }
                fs.Close();
            }
        }

    }
}
