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

    internal class IndexDetails
    {
        private readonly string tableName;
        private readonly string indexName;
        private readonly List<string> ordinalColumnNames;
        private readonly List<string> includeColumnNames;

        public string TableName 
        { 
            get { return this.tableName; } 
        }

        public string IndexName 
        { 
            get { return this.indexName; } 
        }

        public bool IsUnique { get; set; }

        public bool IsPrimaryKey { get; set; }

        public bool IsClustered { get; set; }

        public List<string> OrdinalColumns
        {
            get { return this.ordinalColumnNames; }
        }

        public List<string> IncludeColumns
        {
            get { return this.includeColumnNames; }
        }

        public IndexDetails(string tableName, string indexName)
        {
            if (string.IsNullOrEmpty(tableName))
                throw new ArgumentNullException(tableName);

            if (string.IsNullOrEmpty(indexName))
                throw new ArgumentNullException(indexName);

            this.tableName = tableName;
            this.indexName = indexName;
            this.ordinalColumnNames = new List<string>();
            this.includeColumnNames = new List<string>();
        }
    }

    public class TableStructureScriptWriter : ScriptWriterBase
    {
        public TableStructureScriptWriter(string connectionString, string fileName)
            : base(connectionString, fileName)
        { }

        protected override void WriteToFile(CancellationToken cancelToken)
        {
            if (cancelToken.IsCancellationRequested)
                return;

            var s = new SqlConnection(this.connectionString);
            Server srv = new Server(s.DataSource);
            var db = srv.Databases[s.Database];

            int tableCount = db.Tables.Count;

            using (StreamWriter fs = System.IO.File.CreateText(fileName))
            {
                for (int i = 0; i < tableCount; i++)
                {
                    var table = db.Tables[i];

                    // Simplest way to do this an avoid messing up progress indcation as only a couple occur
                    if (table.IsSystemObject)
                        continue;

                    fs.Write(string.Format("-- TABLE: {0}\r\n", table.Name));
                    fs.Write(string.Format("IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_NAME = '{0}')\r\n", table.Name));
                    fs.Write("BEGIN\r\n\r\n");
                    this.WriteUpdateTable(fs, db, table.Name);
                    fs.Write("\r\n\r\nEND ELSE BEGIN\r\n\r\n");
                    this.WriteCreateTable(fs, db, table.Name);
                    fs.Write("\r\nEND\r\nGO\r\n\r\n\r\n");
                    fs.Flush();

                    this.RaiseProgress(table.Name, (i * 100f) / tableCount);

                    if (cancelToken.IsCancellationRequested)
                        return;
                }
                fs.Close();
            }
        }

        private void WriteCreateTable(StreamWriter fs, Database db, string tableName)
        {
            var result = db.Tables[tableName].Script(new ScriptingOptions()
            {
                Default = true,
                Indexes = true,
                FullTextIndexes = true,
                ClusteredIndexes = true,
                NonClusteredIndexes = true,
                NoCollation = true,
                DriChecks = true,
                DriClustered = true,
                DriDefaults = true,
                DriForeignKeys = false,
                DriIncludeSystemNames = true,
                DriIndexes = true,
                DriNonClustered = true,
                DriPrimaryKey = true,
                DriUniqueKeys = true,
                DriWithNoCheck = true
            });

            foreach (var str in result)
            {
                fs.Write(str);
                fs.Write(Environment.NewLine);
            }

            fs.Write(string.Format("PRINT 'Table created: {0}'", tableName));
        }

        private void WriteUpdateTable(StreamWriter fs, Database db, string tableName)
        {
            // COLUMNS
            var dsColumns = db.ExecuteWithResults(string.Format(@"
                SELECT
                T.TABLE_NAME,
                C.COLUMN_NAME,
                C.DATA_TYPE,
                C.CHARACTER_MAXIMUM_LENGTH,
                C.IS_NULLABLE,
                C.COLUMN_DEFAULT
                FROM INFORMATION_SCHEMA.TABLES T
                INNER JOIN INFORMATION_SCHEMA.COLUMNS C ON T.TABLE_NAME = C.TABLE_NAME
                WHERE T.TABLE_TYPE = 'BASE TABLE' 
                AND T.TABLE_NAME = '{0}'", tableName));

            foreach (DataRow row in dsColumns.Tables[0].Rows)
            {
                var length = row.Field<int?>("CHARACTER_MAXIMUM_LENGTH");

                fs.Write(string.Format("EXEC [dbo].[qest_InsertUpdateColumn] '{0}', '{1}', '{2}', {3}, '{4}', {5}\r\n",
                    row.Field<string>("TABLE_NAME"),
                    row.Field<string>("COLUMN_NAME"),
                    row.Field<string>("DATA_TYPE"),
                    length.GetValueOrDefault(10000) < 10000 ? Convert.ToString(length) : "NULL",
                    row.Field<string>("IS_NULLABLE"),
                    this.sqlFormatString(row.Field<string>("COLUMN_DEFAULT"))
                ));
            }

            // INDEXES
            var dsIndexes = db.ExecuteWithResults(string.Format(@"
                SELECT 
	            T.[name] AS TableName, 
	            I.[name] AS IndexName, 
	            I.[type_desc] As IndexType,
                I.[is_unique_constraint] As IsUnique,
                I.[is_primary_key] AS IsPrimaryKey
	            FROM sys.tables T 
	            INNER JOIN sys.indexes I ON I.[object_id] = T.[object_id] 
	            WHERE I.[type_desc] IN ('CLUSTERED','NONCLUSTERED') AND T.[name] = '{0}'
	            ORDER BY T.[name], I.[type_desc], I.[name]", tableName));

            foreach (DataRow row in dsIndexes.Tables[0].Rows)
            {
                var idx = new IndexDetails(row.Field<string>("TableName"), row.Field<string>("IndexName"))
                {
                    IsUnique = row.Field<bool>("IsUnique"),
                    IsPrimaryKey = row.Field<bool>("IsPrimaryKey"),
                    IsClustered = row.Field<string>("IndexType") == "CLUSTERED" // not used currently??
                };

                var dsIndexColumns = db.ExecuteWithResults(string.Format(@"
                    SELECT
	                C.[name] AS ColumnName, 
                    I.[name] AS ColumnName,
	                IC.[index_column_id] As IndexColID, 
	                IC.[key_ordinal] AS Ordinal, 
	                IC.[is_included_column] As Included
	                FROM sys.tables T 
	                INNER JOIN sys.indexes I ON I.[object_id] = T.[object_id] 
	                INNER JOIN sys.index_columns IC ON IC.[object_id] = T.[object_id] AND IC.[index_id] = I.[index_id]
	                INNER JOIN sys.columns C ON C.[object_id] = T.[object_id] AND C.[column_id] = IC.[column_id]
	                WHERE T.[name] = '{0}' AND I.[name] = '{1}'
	                ORDER BY Included, Ordinal", idx.TableName, idx.IndexName));

                foreach (DataRow rowCol in dsIndexColumns.Tables[0].Rows)
                {
                    if (rowCol.Field<bool>("Included"))
                        idx.IncludeColumns.Add(rowCol.Field<string>("ColumnName"));
                    else
                        idx.OrdinalColumns.Add(rowCol.Field<string>("ColumnName"));
                }

                if (idx.IsPrimaryKey)
                {
                    fs.Write(string.Format("EXEC [dbo].[qest_SetPrimaryKey] '{0}', '{1}', '{2}'\r\n",
                        idx.TableName,
                        idx.IndexName,
                        string.Join(",", idx.OrdinalColumns)
                    ));
                }
                else if (idx.IsUnique)
                {
                    fs.Write(string.Format("IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = '{0}' AND CONSTRAINT_TYPE = 'UNIQUE')\r\n", idx.IndexName));
                    fs.Write("BEGIN\r\n");
                    fs.Write(string.Format("\tEXEC qest_DropIndex '{0}', '{1}'\r\n", idx.TableName, idx.IndexName));
                    fs.Write(string.Format("\tALTER TABLE {0} ADD CONSTRAINT {1} UNIQUE ({2})\r\n",
                        idx.TableName,
                        idx.IndexName,
                        string.Join(",", idx.OrdinalColumns)
                    ));
                    fs.Write("END\r\n");
                }
                else
                {
                    fs.Write(string.Format("EXEC [dbo].[qest_SetIndex] '{0}', '{1}', '{2}', {3}\r\n",
                        idx.TableName,
                        idx.IndexName,
                        string.Join(",", idx.OrdinalColumns),
                        (idx.IncludeColumns.Count > 0) ? "'" + string.Join(",", idx.IncludeColumns) + "'" : "NULL"
                    ));
                }
             
            }

            fs.Write(string.Format("PRINT 'Table updated: {0}'", tableName));
        }

        private string sqlFormatString(string str)
        {
            if (str == null)
                return "NULL";

            return string.Format("'{0}'", str.Replace("'", "''"));
        }
    }
}
