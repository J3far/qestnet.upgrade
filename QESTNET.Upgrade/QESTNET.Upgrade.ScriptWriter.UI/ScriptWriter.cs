﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Configuration;
using Spectra.QESTNET.Upgrade.ScriptWriter;

namespace Spectra.QESTNET.Upgrade.ScriptWriter.UI
{
    public partial class ScriptWriterForm : Form
    {
        private readonly string connectionString;
        private string filePath;
        private CancellationTokenSource cancelWrite;
        private Configuration config;
        private List<Task> tasks;

        public ScriptWriterForm()
        {
            InitializeComponent();

            this.config = ConfigurationManager.OpenExeConfiguration(null);

            this.connectionString = this.config.ConnectionStrings.ConnectionStrings["Template Database"].ConnectionString;
            txtConnectionString.Text = this.connectionString;

            var utsp = this.config.AppSettings.Settings["upgradeScriptPath"];
            this.SetOutputPath(utsp == null? null : utsp.Value);
        }

        private void buttonWrite_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(this.filePath))
                return;

            if (this.cancelWrite != null)
            {
                this.FeedbackSetText("Cancellation requested...");
                this.cancelWrite.Cancel();
                return;
            }

            var writers = new List<ScriptWriterBase>();

            if (tablesToolStripMenuItem.Checked)
                writers.Add(new TableStructureScriptWriter(this.connectionString, this.filePath + "\\structure\\structure.tables.qn.sql"));

            if (fksToolStripMenuItem.Checked)
                writers.Add(new ForeignKeysScriptWriter(this.connectionString, this.filePath + "\\structure\\structure.foreignkeys.qn.sql"));

            if (writers.Count() == 0)
                return;

            this.cancelWrite = new CancellationTokenSource();
            foreach (var w in writers)
                w.ProgressWrite += sw_ProgressWrite;

            this.tasks = writers.Select(w => w.WriteToFileAsync(this.cancelWrite.Token)).ToList();          
            foreach (var t in this.tasks)
                t.ContinueWith(this.WriteComplete);

            tasks[0].Start();
            this.ButtonSetText("Cancel");
        }

        private void WriteComplete(Task task)
        {
            // Move into the next task if there is one
            this.tasks.Remove(task);
            if (this.tasks.Count > 0)
            {
                this.tasks[0].Start();
                return;
            }

            this.FeedbackSetProgress(0);
            if (this.cancelWrite.IsCancellationRequested)
                this.FeedbackSetText("Script write cancelled. WARNING: Script is incomplete.");
            else
                this.FeedbackSetText("Script write complete.");

            this.cancelWrite = null;
            this.ButtonSetText("Write");
        }

        protected void sw_ProgressWrite(object sender, ScriptWriteProgressEventArgs e)
        {
            this.FeedbackSetProgress((int)e.PercentProgress);
            this.FeedbackSetText("Writing: " + e.ProgressText);
        }

        private void FeedbackSetText(string text)
        {
            if (this.labelFeedback.InvokeRequired)
            {
                this.Invoke(new Action<string>(this.FeedbackSetText), text);
                return;
            }

            this.labelFeedback.Text = text;
            this.labelFeedback.Update();
        }

        private void FeedbackSetProgress(int progress)
        {
            if (this.progressBar.InvokeRequired)
            {
                this.Invoke(new Action<int>(this.FeedbackSetProgress), progress);
                return;
            }

            this.progressBar.Value = progress;
            this.labelFeedback.Update();
        }

        private void ButtonSetText(string text)
        {
            if (this.buttonWrite.InvokeRequired)
            {
                this.Invoke(new Action<string>(this.ButtonSetText), text);
                return;
            }

            this.buttonWrite.Text = text;
            this.buttonWrite.Update();
        }

        private void SetOutputPath(string path)
        {
            this.filePath = path;
            txtOutputFile.Text = path;

            // Save path to config
            this.config.AppSettings.Settings.Remove("upgradeScriptPath");
            this.config.AppSettings.Settings.Add("upgradeScriptPath", this.filePath);
            this.config.Save();
        }

        private void buttonOutputPath_Click(object sender, EventArgs e)
        {
            var fbd = new FolderBrowserDialog()
            {
                Description = "Select Script Output Location",
                SelectedPath = this.filePath,
            };

            if (fbd.ShowDialog() == DialogResult.Cancel)
                return;

            this.SetOutputPath(fbd.SelectedPath);
        }

        private void qestObjectsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            var ofd = new OpenFileDialog()
            {
                Title = "Select QESTLab Objects Script",
                Filter = "QESTLab Objects Script (QESTLabObjects.sql)|QESTLabObjects.sql"
            };

            if (ofd.ShowDialog() == DialogResult.Cancel)
                return;

            string cmd = string.Format(@"/C copy ""{0}"" ""{1}\data\data.object_types.qn.sql""", ofd.FileName, this.filePath);
            System.Diagnostics.Process.Start("cmd.exe", cmd);
            this.FeedbackSetText("Written: data\\data.object_types.qn.sql");
        }

    }
}
