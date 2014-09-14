using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Spectra.QESTNET.Upgrade.ScriptWriter
{
    public class ScriptWriteProgressEventArgs : EventArgs
    {
        public string ProgressText { get; set; }
        public float PercentProgress { get; set; }
    }

    public abstract class ScriptWriterBase
    {
        public event EventHandler<ScriptWriteProgressEventArgs> ProgressWrite;

        protected readonly string connectionString;
        protected readonly string fileName;

        public ScriptWriterBase(string connectionString, string fileName)
        {
            if (string.IsNullOrEmpty(connectionString))
                throw new ArgumentNullException("connectionString");

            if (string.IsNullOrEmpty(fileName))
                throw new ArgumentNullException("filePath");

            this.connectionString = connectionString;
            this.fileName = fileName;
        }

        public Task WriteToFileAsync(CancellationToken cancelToken)
        {
            return new Task(() => this.WriteToFile(cancelToken));
        }

        protected void RaiseProgress(string progressText, float percentProgress)
        {
            if (this.ProgressWrite != null)
            {
                this.ProgressWrite(this, new ScriptWriteProgressEventArgs()
                {
                    ProgressText = progressText,
                    PercentProgress = percentProgress
                });
            }
        }

        protected abstract void WriteToFile(CancellationToken cancelToken);
    }
}
