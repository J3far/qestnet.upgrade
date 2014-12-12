namespace Spectra.QESTNET.Upgrade.ScriptWriter.UI
{
    partial class ScriptWriterForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.progressBar = new System.Windows.Forms.ProgressBar();
            this.buttonWrite = new System.Windows.Forms.Button();
            this.txtOutputFile = new System.Windows.Forms.TextBox();
            this.labOutputFile = new System.Windows.Forms.Label();
            this.labelConnectionString = new System.Windows.Forms.Label();
            this.txtConnectionString = new System.Windows.Forms.TextBox();
            this.buttonOutputPath = new System.Windows.Forms.Button();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.scriptsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.tablesToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.fksToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.qestObjectsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.txtOutput = new System.Windows.Forms.TextBox();
            this.buttonQestlabQes = new System.Windows.Forms.Button();
            this.labelQestlabQes = new System.Windows.Forms.Label();
            this.txtQestlabQesPath = new System.Windows.Forms.TextBox();
            this.menuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // progressBar
            // 
            this.progressBar.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.progressBar.Location = new System.Drawing.Point(12, 105);
            this.progressBar.Name = "progressBar";
            this.progressBar.Size = new System.Drawing.Size(557, 27);
            this.progressBar.TabIndex = 0;
            // 
            // buttonWrite
            // 
            this.buttonWrite.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.buttonWrite.Location = new System.Drawing.Point(575, 105);
            this.buttonWrite.Name = "buttonWrite";
            this.buttonWrite.Size = new System.Drawing.Size(75, 29);
            this.buttonWrite.TabIndex = 1;
            this.buttonWrite.Text = "Write";
            this.buttonWrite.UseVisualStyleBackColor = true;
            this.buttonWrite.Click += new System.EventHandler(this.buttonWrite_Click);
            // 
            // txtOutputFile
            // 
            this.txtOutputFile.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtOutputFile.Location = new System.Drawing.Point(109, 80);
            this.txtOutputFile.Name = "txtOutputFile";
            this.txtOutputFile.ReadOnly = true;
            this.txtOutputFile.Size = new System.Drawing.Size(460, 20);
            this.txtOutputFile.TabIndex = 3;
            // 
            // labOutputFile
            // 
            this.labOutputFile.AutoSize = true;
            this.labOutputFile.Location = new System.Drawing.Point(9, 83);
            this.labOutputFile.Name = "labOutputFile";
            this.labOutputFile.Size = new System.Drawing.Size(82, 13);
            this.labOutputFile.TabIndex = 4;
            this.labOutputFile.Text = "Output location:";
            // 
            // labelConnectionString
            // 
            this.labelConnectionString.AutoSize = true;
            this.labelConnectionString.Location = new System.Drawing.Point(9, 30);
            this.labelConnectionString.Name = "labelConnectionString";
            this.labelConnectionString.Size = new System.Drawing.Size(92, 13);
            this.labelConnectionString.TabIndex = 6;
            this.labelConnectionString.Text = "Connection string:";
            // 
            // txtConnectionString
            // 
            this.txtConnectionString.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtConnectionString.Location = new System.Drawing.Point(109, 27);
            this.txtConnectionString.Name = "txtConnectionString";
            this.txtConnectionString.ReadOnly = true;
            this.txtConnectionString.Size = new System.Drawing.Size(541, 20);
            this.txtConnectionString.TabIndex = 5;
            // 
            // buttonOutputPath
            // 
            this.buttonOutputPath.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.buttonOutputPath.Location = new System.Drawing.Point(575, 78);
            this.buttonOutputPath.Name = "buttonOutputPath";
            this.buttonOutputPath.Size = new System.Drawing.Size(75, 23);
            this.buttonOutputPath.TabIndex = 7;
            this.buttonOutputPath.Text = "Browse...";
            this.buttonOutputPath.UseVisualStyleBackColor = true;
            this.buttonOutputPath.Click += new System.EventHandler(this.buttonOutputPath_Click);
            // 
            // menuStrip1
            // 
            this.menuStrip1.BackColor = System.Drawing.SystemColors.Control;
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.scriptsToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(662, 24);
            this.menuStrip1.TabIndex = 8;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // scriptsToolStripMenuItem
            // 
            this.scriptsToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.tablesToolStripMenuItem,
            this.fksToolStripMenuItem,
            this.qestObjectsToolStripMenuItem});
            this.scriptsToolStripMenuItem.Name = "scriptsToolStripMenuItem";
            this.scriptsToolStripMenuItem.Size = new System.Drawing.Size(54, 20);
            this.scriptsToolStripMenuItem.Text = "Scripts";
            // 
            // tablesToolStripMenuItem
            // 
            this.tablesToolStripMenuItem.Checked = true;
            this.tablesToolStripMenuItem.CheckOnClick = true;
            this.tablesToolStripMenuItem.CheckState = System.Windows.Forms.CheckState.Checked;
            this.tablesToolStripMenuItem.Name = "tablesToolStripMenuItem";
            this.tablesToolStripMenuItem.Size = new System.Drawing.Size(141, 22);
            this.tablesToolStripMenuItem.Text = "Tables";
            // 
            // fksToolStripMenuItem
            // 
            this.fksToolStripMenuItem.Checked = true;
            this.fksToolStripMenuItem.CheckOnClick = true;
            this.fksToolStripMenuItem.CheckState = System.Windows.Forms.CheckState.Checked;
            this.fksToolStripMenuItem.Name = "fksToolStripMenuItem";
            this.fksToolStripMenuItem.Size = new System.Drawing.Size(141, 22);
            this.fksToolStripMenuItem.Text = "Foreign Keys";
            // 
            // qestObjectsToolStripMenuItem
            // 
            this.qestObjectsToolStripMenuItem.Checked = true;
            this.qestObjectsToolStripMenuItem.CheckOnClick = true;
            this.qestObjectsToolStripMenuItem.CheckState = System.Windows.Forms.CheckState.Checked;
            this.qestObjectsToolStripMenuItem.Name = "qestObjectsToolStripMenuItem";
            this.qestObjectsToolStripMenuItem.Size = new System.Drawing.Size(141, 22);
            this.qestObjectsToolStripMenuItem.Text = "Qest Objects";
            // 
            // txtOutput
            // 
            this.txtOutput.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtOutput.BackColor = System.Drawing.SystemColors.Window;
            this.txtOutput.Location = new System.Drawing.Point(12, 141);
            this.txtOutput.Multiline = true;
            this.txtOutput.Name = "txtOutput";
            this.txtOutput.ReadOnly = true;
            this.txtOutput.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.txtOutput.Size = new System.Drawing.Size(635, 290);
            this.txtOutput.TabIndex = 15;
            // 
            // buttonQestlabQes
            // 
            this.buttonQestlabQes.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.buttonQestlabQes.Location = new System.Drawing.Point(575, 51);
            this.buttonQestlabQes.Name = "buttonQestlabQes";
            this.buttonQestlabQes.Size = new System.Drawing.Size(75, 23);
            this.buttonQestlabQes.TabIndex = 18;
            this.buttonQestlabQes.Text = "Browse...";
            this.buttonQestlabQes.UseVisualStyleBackColor = true;
            this.buttonQestlabQes.Click += new System.EventHandler(this.buttonQestlabQes_Click);
            // 
            // labelQestlabQes
            // 
            this.labelQestlabQes.AutoSize = true;
            this.labelQestlabQes.Location = new System.Drawing.Point(9, 56);
            this.labelQestlabQes.Name = "labelQestlabQes";
            this.labelQestlabQes.Size = new System.Drawing.Size(77, 13);
            this.labelQestlabQes.TabIndex = 17;
            this.labelQestlabQes.Text = "QESTLab.qes:";
            // 
            // txtQestlabQesPath
            // 
            this.txtQestlabQesPath.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtQestlabQesPath.Location = new System.Drawing.Point(109, 53);
            this.txtQestlabQesPath.Name = "txtQestlabQesPath";
            this.txtQestlabQesPath.ReadOnly = true;
            this.txtQestlabQesPath.Size = new System.Drawing.Size(460, 20);
            this.txtQestlabQesPath.TabIndex = 16;
            // 
            // ScriptWriterForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(662, 443);
            this.Controls.Add(this.buttonQestlabQes);
            this.Controls.Add(this.labelQestlabQes);
            this.Controls.Add(this.txtQestlabQesPath);
            this.Controls.Add(this.txtOutput);
            this.Controls.Add(this.buttonOutputPath);
            this.Controls.Add(this.labelConnectionString);
            this.Controls.Add(this.txtConnectionString);
            this.Controls.Add(this.labOutputFile);
            this.Controls.Add(this.txtOutputFile);
            this.Controls.Add(this.buttonWrite);
            this.Controls.Add(this.progressBar);
            this.Controls.Add(this.menuStrip1);
            this.MainMenuStrip = this.menuStrip1;
            this.MinimumSize = new System.Drawing.Size(16, 155);
            this.Name = "ScriptWriterForm";
            this.Text = "ScriptWriter";
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ProgressBar progressBar;
        private System.Windows.Forms.Button buttonWrite;
        private System.Windows.Forms.TextBox txtOutputFile;
        private System.Windows.Forms.Label labOutputFile;
        private System.Windows.Forms.Label labelConnectionString;
        private System.Windows.Forms.TextBox txtConnectionString;
        private System.Windows.Forms.Button buttonOutputPath;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem scriptsToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem tablesToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem fksToolStripMenuItem;
        private System.Windows.Forms.TextBox txtOutput;
        private System.Windows.Forms.ToolStripMenuItem qestObjectsToolStripMenuItem;
        private System.Windows.Forms.Button buttonQestlabQes;
        private System.Windows.Forms.Label labelQestlabQes;
        private System.Windows.Forms.TextBox txtQestlabQesPath;
    }
}

