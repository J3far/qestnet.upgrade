namespace Spectra.QESTNET.Upgrade.UI
{
    partial class DbUpgradeUI
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
            this.components = new System.ComponentModel.Container();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.txtDatabaseVersion = new System.Windows.Forms.TextBox();
            this.labDatabaseVersion = new System.Windows.Forms.Label();
            this.chkRepair = new System.Windows.Forms.CheckBox();
            this.listViewFiles = new System.Windows.Forms.ListView();
            this.listViewFilesColumnName = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.listViewFilesColumnFullName = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.butEditManifest = new System.Windows.Forms.Button();
            this.cmbConnectionString = new System.Windows.Forms.ComboBox();
            this.txtUpgradeVersion = new System.Windows.Forms.TextBox();
            this.labUpgradeVersion = new System.Windows.Forms.Label();
            this.butOpenManifest = new System.Windows.Forms.Button();
            this.labUpgradeFiles = new System.Windows.Forms.Label();
            this.labConnectionString = new System.Windows.Forms.Label();
            this.labManifest = new System.Windows.Forms.Label();
            this.txtUpdateManifest = new System.Windows.Forms.TextBox();
            this.txtConnectionString = new System.Windows.Forms.TextBox();
            this.butExecute = new System.Windows.Forms.Button();
            this.labMessages = new System.Windows.Forms.Label();
            this.txtOutput = new System.Windows.Forms.TextBox();
            this.cmsFiles = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.mainMenu = new System.Windows.Forms.MenuStrip();
            this.toolsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.refreshToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.generateStructureScriptsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            this.mainMenu.SuspendLayout();
            this.SuspendLayout();
            // 
            // splitContainer1
            // 
            this.splitContainer1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.splitContainer1.BackColor = System.Drawing.SystemColors.ControlLight;
            this.splitContainer1.Location = new System.Drawing.Point(2, 27);
            this.splitContainer1.Name = "splitContainer1";
            this.splitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.BackColor = System.Drawing.SystemColors.Control;
            this.splitContainer1.Panel1.Controls.Add(this.txtDatabaseVersion);
            this.splitContainer1.Panel1.Controls.Add(this.labDatabaseVersion);
            this.splitContainer1.Panel1.Controls.Add(this.chkRepair);
            this.splitContainer1.Panel1.Controls.Add(this.listViewFiles);
            this.splitContainer1.Panel1.Controls.Add(this.butEditManifest);
            this.splitContainer1.Panel1.Controls.Add(this.cmbConnectionString);
            this.splitContainer1.Panel1.Controls.Add(this.txtUpgradeVersion);
            this.splitContainer1.Panel1.Controls.Add(this.labUpgradeVersion);
            this.splitContainer1.Panel1.Controls.Add(this.butOpenManifest);
            this.splitContainer1.Panel1.Controls.Add(this.labUpgradeFiles);
            this.splitContainer1.Panel1.Controls.Add(this.labConnectionString);
            this.splitContainer1.Panel1.Controls.Add(this.labManifest);
            this.splitContainer1.Panel1.Controls.Add(this.txtUpdateManifest);
            this.splitContainer1.Panel1.Controls.Add(this.txtConnectionString);
            this.splitContainer1.Panel1.Controls.Add(this.butExecute);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.BackColor = System.Drawing.SystemColors.Control;
            this.splitContainer1.Panel2.Controls.Add(this.labMessages);
            this.splitContainer1.Panel2.Controls.Add(this.txtOutput);
            this.splitContainer1.Size = new System.Drawing.Size(949, 424);
            this.splitContainer1.SplitterDistance = 210;
            this.splitContainer1.TabIndex = 10;
            // 
            // txtDatabaseVersion
            // 
            this.txtDatabaseVersion.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.txtDatabaseVersion.Location = new System.Drawing.Point(592, 159);
            this.txtDatabaseVersion.Name = "txtDatabaseVersion";
            this.txtDatabaseVersion.ReadOnly = true;
            this.txtDatabaseVersion.Size = new System.Drawing.Size(110, 20);
            this.txtDatabaseVersion.TabIndex = 25;
            // 
            // labDatabaseVersion
            // 
            this.labDatabaseVersion.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.labDatabaseVersion.AutoSize = true;
            this.labDatabaseVersion.Location = new System.Drawing.Point(493, 163);
            this.labDatabaseVersion.Name = "labDatabaseVersion";
            this.labDatabaseVersion.Size = new System.Drawing.Size(93, 13);
            this.labDatabaseVersion.TabIndex = 24;
            this.labDatabaseVersion.Text = "Database version:";
            // 
            // chkRepair
            // 
            this.chkRepair.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.chkRepair.AutoSize = true;
            this.chkRepair.Location = new System.Drawing.Point(711, 161);
            this.chkRepair.Name = "chkRepair";
            this.chkRepair.Size = new System.Drawing.Size(94, 17);
            this.chkRepair.TabIndex = 23;
            this.chkRepair.Text = "Option: Repair";
            this.chkRepair.UseVisualStyleBackColor = true;
            // 
            // listViewFiles
            // 
            this.listViewFiles.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.listViewFiles.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.listViewFilesColumnName,
            this.listViewFilesColumnFullName});
            this.listViewFiles.Location = new System.Drawing.Point(14, 63);
            this.listViewFiles.Name = "listViewFiles";
            this.listViewFiles.Size = new System.Drawing.Size(927, 89);
            this.listViewFiles.TabIndex = 22;
            this.listViewFiles.UseCompatibleStateImageBehavior = false;
            this.listViewFiles.View = System.Windows.Forms.View.Details;
            this.listViewFiles.DoubleClick += new System.EventHandler(this.listViewFiles_DoubleClick);
            // 
            // listViewFilesColumnName
            // 
            this.listViewFilesColumnName.Text = "Name";
            this.listViewFilesColumnName.Width = 233;
            // 
            // listViewFilesColumnFullName
            // 
            this.listViewFilesColumnFullName.Text = "Full Name";
            this.listViewFilesColumnFullName.Width = 700;
            // 
            // butEditManifest
            // 
            this.butEditManifest.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.butEditManifest.Location = new System.Drawing.Point(852, 3);
            this.butEditManifest.Name = "butEditManifest";
            this.butEditManifest.Size = new System.Drawing.Size(88, 23);
            this.butEditManifest.TabIndex = 21;
            this.butEditManifest.Text = "Edit Manifest";
            this.butEditManifest.UseVisualStyleBackColor = true;
            this.butEditManifest.Click += new System.EventHandler(this.butEditManifest_Click);
            // 
            // cmbConnectionString
            // 
            this.cmbConnectionString.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.cmbConnectionString.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbConnectionString.FormattingEnabled = true;
            this.cmbConnectionString.Location = new System.Drawing.Point(106, 158);
            this.cmbConnectionString.Name = "cmbConnectionString";
            this.cmbConnectionString.Size = new System.Drawing.Size(368, 21);
            this.cmbConnectionString.TabIndex = 20;
            this.cmbConnectionString.SelectedIndexChanged += new System.EventHandler(this.cmbConnectionString_SelectedIndexChanged);
            // 
            // txtUpgradeVersion
            // 
            this.txtUpgradeVersion.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.txtUpgradeVersion.Location = new System.Drawing.Point(830, 37);
            this.txtUpgradeVersion.Name = "txtUpgradeVersion";
            this.txtUpgradeVersion.ReadOnly = true;
            this.txtUpgradeVersion.Size = new System.Drawing.Size(110, 20);
            this.txtUpgradeVersion.TabIndex = 19;
            // 
            // labUpgradeVersion
            // 
            this.labUpgradeVersion.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.labUpgradeVersion.AutoSize = true;
            this.labUpgradeVersion.Location = new System.Drawing.Point(736, 40);
            this.labUpgradeVersion.Name = "labUpgradeVersion";
            this.labUpgradeVersion.Size = new System.Drawing.Size(88, 13);
            this.labUpgradeVersion.TabIndex = 18;
            this.labUpgradeVersion.Text = "Upgrade version:";
            // 
            // butOpenManifest
            // 
            this.butOpenManifest.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.butOpenManifest.Location = new System.Drawing.Point(756, 3);
            this.butOpenManifest.Name = "butOpenManifest";
            this.butOpenManifest.Size = new System.Drawing.Size(90, 23);
            this.butOpenManifest.TabIndex = 17;
            this.butOpenManifest.Text = "Open Manifest";
            this.butOpenManifest.UseVisualStyleBackColor = true;
            this.butOpenManifest.Click += new System.EventHandler(this.butOpenManifest_Click);
            // 
            // labUpgradeFiles
            // 
            this.labUpgradeFiles.AutoSize = true;
            this.labUpgradeFiles.Location = new System.Drawing.Point(11, 40);
            this.labUpgradeFiles.Name = "labUpgradeFiles";
            this.labUpgradeFiles.Size = new System.Drawing.Size(31, 13);
            this.labUpgradeFiles.TabIndex = 16;
            this.labUpgradeFiles.Text = "Files:";
            // 
            // labConnectionString
            // 
            this.labConnectionString.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.labConnectionString.AutoSize = true;
            this.labConnectionString.Location = new System.Drawing.Point(11, 161);
            this.labConnectionString.Name = "labConnectionString";
            this.labConnectionString.Size = new System.Drawing.Size(92, 13);
            this.labConnectionString.TabIndex = 15;
            this.labConnectionString.Text = "Connection string:";
            // 
            // labManifest
            // 
            this.labManifest.AutoSize = true;
            this.labManifest.Location = new System.Drawing.Point(11, 8);
            this.labManifest.Name = "labManifest";
            this.labManifest.Size = new System.Drawing.Size(93, 13);
            this.labManifest.TabIndex = 14;
            this.labManifest.Text = "Upgrade manifest:";
            // 
            // txtUpdateManifest
            // 
            this.txtUpdateManifest.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtUpdateManifest.Enabled = false;
            this.txtUpdateManifest.Location = new System.Drawing.Point(106, 5);
            this.txtUpdateManifest.Name = "txtUpdateManifest";
            this.txtUpdateManifest.Size = new System.Drawing.Size(644, 20);
            this.txtUpdateManifest.TabIndex = 13;
            // 
            // txtConnectionString
            // 
            this.txtConnectionString.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtConnectionString.Location = new System.Drawing.Point(14, 185);
            this.txtConnectionString.Name = "txtConnectionString";
            this.txtConnectionString.ReadOnly = true;
            this.txtConnectionString.Size = new System.Drawing.Size(810, 20);
            this.txtConnectionString.TabIndex = 12;
            // 
            // butExecute
            // 
            this.butExecute.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.butExecute.Location = new System.Drawing.Point(831, 158);
            this.butExecute.Name = "butExecute";
            this.butExecute.Size = new System.Drawing.Size(110, 47);
            this.butExecute.TabIndex = 11;
            this.butExecute.Text = "Start / Stop";
            this.butExecute.UseVisualStyleBackColor = true;
            this.butExecute.Click += new System.EventHandler(this.butExecute_Click);
            // 
            // labMessages
            // 
            this.labMessages.AutoSize = true;
            this.labMessages.Location = new System.Drawing.Point(8, 8);
            this.labMessages.Name = "labMessages";
            this.labMessages.Size = new System.Drawing.Size(58, 13);
            this.labMessages.TabIndex = 15;
            this.labMessages.Text = "Messages:";
            // 
            // txtOutput
            // 
            this.txtOutput.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtOutput.BackColor = System.Drawing.SystemColors.Window;
            this.txtOutput.Location = new System.Drawing.Point(11, 24);
            this.txtOutput.Multiline = true;
            this.txtOutput.Name = "txtOutput";
            this.txtOutput.ReadOnly = true;
            this.txtOutput.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.txtOutput.Size = new System.Drawing.Size(930, 178);
            this.txtOutput.TabIndex = 14;
            // 
            // cmsFiles
            // 
            this.cmsFiles.Name = "cmsFiles";
            this.cmsFiles.Size = new System.Drawing.Size(61, 4);
            this.cmsFiles.ItemClicked += new System.Windows.Forms.ToolStripItemClickedEventHandler(this.cmsFiles_ItemClicked);
            // 
            // mainMenu
            // 
            this.mainMenu.Dock = System.Windows.Forms.DockStyle.None;
            this.mainMenu.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolsToolStripMenuItem});
            this.mainMenu.Location = new System.Drawing.Point(2, 2);
            this.mainMenu.Name = "mainMenu";
            this.mainMenu.Size = new System.Drawing.Size(58, 24);
            this.mainMenu.TabIndex = 22;
            this.mainMenu.Text = "menuStrip1";
            // 
            // toolsToolStripMenuItem
            // 
            this.toolsToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.refreshToolStripMenuItem,
            this.generateStructureScriptsToolStripMenuItem});
            this.toolsToolStripMenuItem.Name = "toolsToolStripMenuItem";
            this.toolsToolStripMenuItem.Size = new System.Drawing.Size(50, 20);
            this.toolsToolStripMenuItem.Text = "Menu";
            // 
            // refreshToolStripMenuItem
            // 
            this.refreshToolStripMenuItem.Name = "refreshToolStripMenuItem";
            this.refreshToolStripMenuItem.ShortcutKeys = System.Windows.Forms.Keys.F5;
            this.refreshToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.refreshToolStripMenuItem.Text = "Refresh";
            this.refreshToolStripMenuItem.Click += new System.EventHandler(this.refreshToolStripMenuItem_Click);
            // 
            // generateStructureScriptsToolStripMenuItem
            // 
            this.generateStructureScriptsToolStripMenuItem.Name = "generateStructureScriptsToolStripMenuItem";
            this.generateStructureScriptsToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.generateStructureScriptsToolStripMenuItem.Text = "Script Writer";
            this.generateStructureScriptsToolStripMenuItem.Click += new System.EventHandler(this.generateStructureScriptsToolStripMenuItem_Click);
            // 
            // DbUpgradeUI
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.ControlLight;
            this.ClientSize = new System.Drawing.Size(954, 454);
            this.Controls.Add(this.mainMenu);
            this.Controls.Add(this.splitContainer1);
            this.MainMenuStrip = this.mainMenu;
            this.MinimumSize = new System.Drawing.Size(970, 350);
            this.Name = "DbUpgradeUI";
            this.Text = "QESTNET Upgrade";
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel1.PerformLayout();
            this.splitContainer1.Panel2.ResumeLayout(false);
            this.splitContainer1.Panel2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
            this.splitContainer1.ResumeLayout(false);
            this.mainMenu.ResumeLayout(false);
            this.mainMenu.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.SplitContainer splitContainer1;
        private System.Windows.Forms.Label labUpgradeFiles;
        private System.Windows.Forms.Label labConnectionString;
        private System.Windows.Forms.Label labManifest;
        private System.Windows.Forms.TextBox txtUpdateManifest;
        private System.Windows.Forms.TextBox txtConnectionString;
        private System.Windows.Forms.Button butExecute;
        private System.Windows.Forms.Label labMessages;
        private System.Windows.Forms.TextBox txtOutput;
        private System.Windows.Forms.Button butOpenManifest;
        private System.Windows.Forms.TextBox txtUpgradeVersion;
        private System.Windows.Forms.Label labUpgradeVersion;
        private System.Windows.Forms.ComboBox cmbConnectionString;
        private System.Windows.Forms.Button butEditManifest;
        private System.Windows.Forms.ContextMenuStrip cmsFiles;
        private System.Windows.Forms.MenuStrip mainMenu;
        private System.Windows.Forms.ToolStripMenuItem toolsToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem generateStructureScriptsToolStripMenuItem;
        private System.Windows.Forms.ListView listViewFiles;
        private System.Windows.Forms.ColumnHeader listViewFilesColumnName;
        private System.Windows.Forms.ColumnHeader listViewFilesColumnFullName;
        private System.Windows.Forms.ToolStripMenuItem refreshToolStripMenuItem;
        private System.Windows.Forms.CheckBox chkRepair;
        private System.Windows.Forms.TextBox txtDatabaseVersion;
        private System.Windows.Forms.Label labDatabaseVersion;
    }
}

