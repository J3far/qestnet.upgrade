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

    public class UpgradeManifest
    {        
        FileInfo manifestFile;
        FileInfo[] scriptFiles;
        Version version;

        public Action<string> Message;

        public FileInfo ManifestFile
        {
            get { return this.manifestFile; }
        }

        public FileInfo[] ScriptFiles
        {
            get { return this.scriptFiles; }
        }

        public Version UpgradeVersion
        {
            get { return this.version; }
        }

        public UpgradeManifest(FileInfo updateManifest)
        {
            this.OpenManifest(updateManifest);
        }

        private void OpenManifest(FileInfo updateManifest)
        {
            if (updateManifest == null)
                throw new ArgumentNullException("updateManifest");

            if (!updateManifest.Exists)
                throw new Exception("The given update manifest file cannot be found.");

            this.manifestFile = updateManifest;

            // Comment regex
            var regexCommentBlock = new Regex(@"/\*[\S\s]*?\*/");
            var regexCommentLine = new Regex(@"//.*$", RegexOptions.Multiline);

            var manifest = File.ReadAllText(updateManifest.FullName);

            // Strip out comments
            manifest = regexCommentBlock.Replace(manifest, string.Empty);
            manifest = regexCommentLine.Replace(manifest, string.Empty);

            var validLines = manifest.Split(new string[] { "\r\n", "\r", "\n" }, StringSplitOptions.None)
                .Select(l => l.Trim()).Where(l => !string.IsNullOrWhiteSpace(l)).ToArray();

            this.version = validLines
                .Where(l => l.StartsWith("#"))
                .Select(l => new Version(l.Substring(1)))
                .FirstOrDefault();

            if (this.version == null)
                throw new Exception("No upgrade version was defined in the manifest file.");

            var fileNames = validLines
                .Where(l => !l.StartsWith("#") && l.EndsWith(".qn.sql"))
                .Select(l => string.Format(@"{0}\{1}", updateManifest.DirectoryName, l))
                .ToArray();

            // Detect missing files
            var missing = fileNames.Where(n => !File.Exists(n)).ToArray();
            if (missing.Length > 0)
                throw new Exception(
                    string.Format("The following files listed in the update manifest cannot be found: {0}", string.Join(", ", missing))
                );

            this.scriptFiles = fileNames.Select(n => new FileInfo(n)).ToArray();
        }
    }

}
