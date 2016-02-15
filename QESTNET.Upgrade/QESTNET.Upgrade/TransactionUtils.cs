using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Transactions;

namespace Spectra.QESTNET.Upgrade
{
    public static class TransactionUtils
    {
        /// <summary>
        /// Create a new transaction scope using best-practice defaults for database transactions.
        /// </summary>
        /// <returns>the transaction scope</returns>
        public static TransactionScope CreateTransactionScope()
        {
            var transactionOptions = new TransactionOptions();
            transactionOptions.IsolationLevel = IsolationLevel.ReadCommitted;
            transactionOptions.Timeout = TransactionManager.MaximumTimeout;
            return new TransactionScope(TransactionScopeOption.Required, transactionOptions);
        }

        private static void ConfigureMaximumTransactionTimeout(TimeSpan value)
        {
            //initializing internal stuff
            // ReSharper disable once NotAccessedVariable
            var timespan = TransactionManager.MaximumTimeout;

            //initializing it again to be sure
            // ReSharper disable once RedundantAssignment
            timespan = TransactionManager.MaximumTimeout;

            SetTransactionManagerField("_cachedMaxTimeout", true);
            SetTransactionManagerField("_maximumTimeout", value);
        }

        private static void SetTransactionManagerField(string fieldName, object value)
        {
            var cacheField = typeof(TransactionManager).GetField(fieldName, System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Static);
            cacheField.SetValue(null, value);
        }

        /// <summary>
        /// The transaction scope has a maximum timeout that comes from the machine configuration file:
        /// %windir%\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config
        ///
        /// You should generally not modify this value in the file itself, since it affects the entire
        /// cvomputer.  Instead, if you are running with FULL TRUST, you can work around it by hacking in
        /// a replacement value using reflection.
        /// </summary>
        public static TimeSpan MaximumTransactionTimeout
        {
            get { return TransactionManager.MaximumTimeout; }
            set { ConfigureMaximumTransactionTimeout(value); }
        }
    }
}
