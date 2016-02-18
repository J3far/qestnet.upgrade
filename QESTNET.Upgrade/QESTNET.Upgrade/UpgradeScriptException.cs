using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Spectra.QESTNET.Upgrade
{
    public class UpgradeScriptException : Exception
    {
        public UpgradeScriptException(string scriptFile, string sqlStatement, SqlException innerException)
            : this(scriptFile, sqlStatement, innerException.Message, innerException)
        { 
        }

        public UpgradeScriptException(string scriptFile, string sqlStatement, string message, Exception innerException)
            : base(string.Format("Error in {1}{0}SQL Statement:{0}{2}{0}{3}", System.Environment.NewLine, scriptFile, sqlStatement, message), innerException)
        {
        }
    }
}
