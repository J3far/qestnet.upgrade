using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Configuration;
using System.Drawing;
using System.Linq;
using System.Text;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using Spectra.QESTNET.Upgrade;

namespace Spectra.QESTNET.Upgrade.UI
{
    
    public partial class DbUpgradeUI : Form
    {
        UpgradeManifest manifest;
        CancellationTokenSource cancelUpgrade;
        ConnectionStringSettingsCollection csSettings;
        FileSystemWatcher fileWatcher;
        Configuration config;
        FileInfo exeScriptWriter;

        public DbUpgradeUI()
        {
            InitializeComponent();

            this.config = ConfigurationManager.OpenExeConfiguration(null);

            cmbConnectionString.DataSource = this.config.ConnectionStrings.ConnectionStrings.OfType<ConnectionStringSettings>()
                .Where(c => c.Name != "LocalSqlServer").ToList();
            cmbConnectionString.DisplayMember = "Name";

            var mp = this.config.AppSettings.Settings["manifestPath"];
            this.OpenManifest(mp != null ? mp.Value : null);

            // Show ScriptWriter link when exe is side-by-side
            this.exeScriptWriter = new DirectoryInfo(Directory.GetCurrentDirectory()).GetFiles("QESTNET.Upgrade.ScriptWriter.UI.exe").SingleOrDefault();
            generateStructureScriptsToolStripMenuItem.Visible = this.exeScriptWriter != null;
        }


        private void RefreshControls()
        {
            this.SetButtonExecuteText(this.cancelUpgrade == null ? "Start" : "Stop");
            this.SetCheckboxRepairEnabled(this.cancelUpgrade == null);
            this.RefreshDatabaseVerison();
        }

        private void SetCheckboxRepairEnabled(bool enabled)
        {
            if (this.chkRepair.InvokeRequired)
            {
                this.Invoke(new Action<bool>(SetCheckboxRepairEnabled), enabled);
                return;
            }

            chkRepair.Enabled = enabled;
        }

        private void SetButtonExecuteText(string text)
        {
            if (this.butExecute.InvokeRequired)
            {
                this.Invoke(new Action<string>(SetButtonExecuteText), text);
                return;
            }

            butExecute.Text = text;
        }

        private void SetDatabaseVersion(string text)
        {
            if (this.txtDatabaseVersion.InvokeRequired)
            {
                this.Invoke(new Action<string>(SetDatabaseVersion), text);
                return;
            }

            txtDatabaseVersion.Text = text;
        }

        private void MessagesWriteLine(string text)
        {
            if (this.txtOutput.InvokeRequired)
            {
                this.Invoke(new Action<string>(MessagesWriteLine), text );
                return;
            }

            this.txtOutput.AppendText(string.Format("[{0}] {1}\r\n", DateTime.Now.ToString(), text));
            //this.txtOutput.SelectionStart = this.txtOutput.Text.Length;
            //this.txtOutput.ScrollToCaret();
        }

        private void OpenManifest(string manifestPath)
        {
            if (this.txtUpdateManifest.InvokeRequired || this.listViewFiles.InvokeRequired)
            {
                this.Invoke(new Action<string>(OpenManifest), manifestPath);
                return;
            }

            this.fileWatcher = null;
            this.manifest = null;

            txtUpgradeVersion.Text = null;
            listViewFiles.Items.Clear();

            try
            {
                this.manifest = new UpgradeManifest(new FileInfo(manifestPath));
                
                foreach (var script in manifest.ScriptFiles)
                {
                    var lvi = new ListViewItem(script.Name);
                    lvi.SubItems.Add(script.FullName);
                    listViewFiles.Items.Add(lvi);
                }

                txtUpdateManifest.Text = manifestPath;
                txtUpgradeVersion.Text = (this.manifest.UpgradeVersion != null) ? this.manifest.UpgradeVersion.ToString() : "???";

                this.fileWatcher = new FileSystemWatcher(this.manifest.ManifestFile.DirectoryName);
                this.fileWatcher.Changed += fileWatcher_Changed;
                this.fileWatcher.EnableRaisingEvents = true;

                // Save path to config
                this.config.AppSettings.Settings.Remove("manifestPath");
                this.config.AppSettings.Settings.Add("manifestPath", manifestPath);
                this.config.Save();

                this.MessagesWriteLine(string.Empty);
                this.MessagesWriteLine(string.Format("Opened manifest: {0} [config saved]", manifestPath));
            }
            catch (Exception ex)
            {
                this.MessagesWriteLine(ex.ToString());
            }

            this.butEditManifest.Enabled = (this.manifest != null);
            this.butExecute.Enabled = (this.manifest != null);
        }

        void fileWatcher_Changed(object sender, FileSystemEventArgs e)
        {
            if (e.ChangeType == WatcherChangeTypes.Changed)
            {
                // re-open the changed manifest
                if (e.FullPath == this.manifest.ManifestFile.FullName)
                {
                    this.fileWatcher.EnableRaisingEvents = false;
                    this.OpenManifest(e.FullPath);
                }
            }
        }

        private void butExecute_Click(object sender, EventArgs e)
        {
            // Cancel
            if (this.cancelUpgrade != null)
            {
                this.MessagesWriteLine("Requesting cancellation ...");
                this.cancelUpgrade.Cancel();
                return;
            }

            // Execute
            try
            {
                this.MessagesWriteLine(string.Empty);
                var dbu = new DatabaseUpgrade(this.manifest, this.txtConnectionString.Text)
                {
                    OptionRepair = chkRepair.Checked
                };
                dbu.Message += this.MessagesWriteLine;

                this.cancelUpgrade = new CancellationTokenSource();
                this.RefreshControls();

                var upgrade = dbu.ExecuteAsync(this.cancelUpgrade.Token);
                upgrade.ContinueWith(this.UpgradeComplete);
                upgrade.Start();
            }
            catch (Exception ex)
            {
                this.MessagesWriteLine(ex.ToString());
            }
        }

        private void UpgradeComplete(Task task)
        {
            this.cancelUpgrade = null;
            this.RefreshControls();
        }

        private void butOpenManifest_Click(object sender, EventArgs e)
        {
            var ofd = new OpenFileDialog()
            {
                Title = "Select Manifest File",
                Filter = "Upgrade Manifest (*.qn.manifest)|*.qn.manifest"
            };

            if (ofd.ShowDialog() == DialogResult.Cancel)
                return;

            this.OpenManifest(ofd.FileName);
        }

        private void butEditManifest_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Process.Start(this.manifest.ManifestFile.FullName); 
        }

        private void cmbConnectionString_SelectedIndexChanged(object sender, EventArgs e)
        {
            this.txtConnectionString.Text = ((ConnectionStringSettings)cmbConnectionString.SelectedValue).ConnectionString;
            this.RefreshDatabaseVerison();
        }

        private void RefreshDatabaseVerison()
        {
            this.SetDatabaseVersion(QestlabDatabaseHelper.GetSystemValue(txtConnectionString.Text, "QestnetDatabaseVersion"));
        }

        private void cmsFiles_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {
            // TODO
        }

        private void generateStructureScriptsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Process.Start(this.exeScriptWriter.FullName); 
        }

        private void listViewFiles_DoubleClick(object sender, EventArgs e)
        {
            var fullName = this.listViewFiles.SelectedItems[0].SubItems[1].Text;
            System.Diagnostics.Process.Start(fullName); 
        }

        private void refreshToolStripMenuItem_Click(object sender, EventArgs e)
        {
            // Re-open the manifest to refresh (only when not running)
            if (this.cancelUpgrade == null)
                this.OpenManifest(this.manifest.ManifestFile.FullName);
        }
    }
}
