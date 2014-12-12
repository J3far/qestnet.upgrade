using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Text.RegularExpressions;

namespace Spectra.QESTNET.Upgrade.ScriptWriter
{

    public class QestObjectsScriptWriter : ScriptWriterBase
    {
        private class QestlabObjectType
        {
            public int QestID { get; set; }
            public string Name
            {
                get
                {
                    string value;
                    if (Properties.TryGetValue("name", out value))
                        return value;
                    else
                        return "<null>";
                }
            }
            public int StartLineNumber { get; set; }
            public IDictionary<string, string> Properties { get; private set; }

            public QestlabObjectType(int qestID, int startLineNumber)
            {
                QestID = qestID;
                StartLineNumber = startLineNumber;
                Properties = new Dictionary<string, string>(StringComparer.InvariantCultureIgnoreCase);
            }

            public override string ToString()
            {
                return string.Format("{0}: {1}", QestID, Name);
            }
        }

        protected string inputFilename;
        protected string additionalFilename;

        private const string headerScriptContent = @"
-- Stored procedure for adding Qest Object Properties
CREATE PROC qest_AddObjectProperty @QestID int, @QestActive bit, @QestExtra bit, @Property nvarchar(32), @Value nvarchar(4000) AS 
INSERT INTO dbo.qestObjects(QestID,QestActive,QestExtra,[Property],[Value]) VALUES(@QestID,@QestActive,@QestExtra,@Property,@Value)
GO

--Delete all the current entries except user documents and test stages
DELETE FROM qestObjects WHERE not (QestID >= 19000 and QestID < 20000) and not (QestID >= 55000 and QestID <= 60000) and not (QestID > 2000000)
GO

-- Add QESTLab object properties
";
        private const string footerScriptContent = @"
-- Remove stored procedure
DROP PROCEDURE qest_AddObjectProperty
GO
";

        public QestObjectsScriptWriter(string inputFilename, string outputFilename, string additionalOutputFilename)
            : base("NONE", outputFilename)
        {
            if (string.IsNullOrEmpty(inputFilename))
            {
                throw new ArgumentNullException(inputFilename);
            }
            if (!File.Exists(inputFilename))
            {
                throw new FileNotFoundException(string.Format("File \"qestlab.qes\" not found at path \"{0}\"", inputFilename), inputFilename);
            }
            this.inputFilename = inputFilename;
            this.additionalFilename = additionalOutputFilename;
        }

        private enum QestlabQesParserState
        {
            Default = 0,
            Object
        }

        private enum QestlabQesLineType
        {
            Comment,
            Whitespace,
            StartOfObject,
            ObjectProperty,
            EndOfObject,
            SyntaxError
        }

        private readonly Regex regexComment = new Regex(@"^\s*['#].*$");
        private readonly Regex regexStartOfObject = new Regex(@"^\s*START[[]OBJECT([0-9]+)]\s*$");
        private readonly Regex regexEndOfObject = new Regex(@"^\s*END[[]OBJECT([0-9]{1,10})]\s*$");
        private readonly Regex regexObjectProperty = new Regex(@"^\s*(.*?)\s*[=]\s*(.*?)\s*$");

        private QestlabQesLineType GetLineType(string input, out Match match)
        {
            if (string.IsNullOrWhiteSpace(input))
            {
                match = null;
                return QestlabQesLineType.Whitespace;
            }

            match = regexComment.Match(input);
            if (match.Success) return QestlabQesLineType.Comment;

            match = regexStartOfObject.Match(input);
            if (match.Success) return QestlabQesLineType.StartOfObject;

            match = regexEndOfObject.Match(input);
            if (match.Success) return QestlabQesLineType.EndOfObject;

            match = regexObjectProperty.Match(input);
            if (match.Success) return QestlabQesLineType.ObjectProperty;

            match = null;
            return QestlabQesLineType.SyntaxError;
        }

        protected override void WriteToFile(System.Threading.CancellationToken cancelToken)
        {
            var lineNumber = 0;

            var objectTypes = new Dictionary<int, QestlabObjectType>();

            var validationWarnings = new List<string>();

            var tempFile = System.IO.Path.GetTempFileName();
            try 
            {
                using (var reader = new StreamReader(inputFilename, Encoding.GetEncoding(1252))) // Default Windows ANSI code page (allows cubed etc).
                {
                    using (var writer = new StreamWriter(tempFile, false, Encoding.GetEncoding(1252))) // Default Windows ANSI code page (allows cubed etc).
                    {
                        writer.Write(headerScriptContent);

                        var parserState = QestlabQesParserState.Default;
                        QestlabObjectType currentObjectType = null;

                        while (!reader.EndOfStream)
                        {
                            //now, read the input file, one line at a time.
                            lineNumber++;
                            var inputLine = reader.ReadLine();
                            Match match;
                            var lineType = GetLineType(inputLine, out match);

                            if (lineType == QestlabQesLineType.Whitespace || lineType == QestlabQesLineType.Comment)
                            {
                                //ignore it
                            }
                            else if (lineType == QestlabQesLineType.SyntaxError)
                            {
                                validationWarnings.Add(string.Format("Invalid syntax in qestlab.qes on line {0}{1}{2}", lineNumber, System.Environment.NewLine, inputLine));
                            }
                            else if (parserState == QestlabQesParserState.Default)
                            {
                                //We are currently at the start of the file, or are between object types.
                                //We are expecting a 'start of object' line.  Any non-comment/non-whitespace line other START[OBJECTxxx] line is invalid at this time.
                                if (lineType == QestlabQesLineType.StartOfObject)
                                {
                                    var qestID = int.Parse(match.Groups[1].Value);
                                    currentObjectType = new QestlabObjectType(qestID, lineNumber);
                                    if (objectTypes.ContainsKey(qestID))
                                    {
                                        validationWarnings.Add(string.Format("Duplicate object types detected on lines {0} and {1}, QestID {3}", objectTypes[qestID].StartLineNumber, lineNumber, qestID));
                                    }
                                    else
                                    {
                                        objectTypes.Add(currentObjectType.QestID, currentObjectType);
                                    }
                                    parserState = QestlabQesParserState.Object;
                                }
                                else
                                {
                                    validationWarnings.Add(string.Format("Missing START of object in qestlab.qes at line {0}.{1}{2}", lineNumber, System.Environment.NewLine, inputLine));
                                }
                            }
                            else if (parserState == QestlabQesParserState.Object)
                            {
                                //We are currently inside a START[OBJECTxxx] ... END[OBJECTxxx] block.
                                //We are expecting either a property for the current object, or an 'end of object' line.
                                //Any other non-comment/non-whitespace line is invalid at this time (in particular, the start of another object type).

                                if (lineType == QestlabQesLineType.EndOfObject)
                                {
                                    //We've reached the end of the object block.  Double-check that the START/END object ids match, and then switch the parser state back to 'default' (between object types)
                                    var qestID = int.Parse(match.Groups[1].Value);
                                    if (qestID != currentObjectType.QestID)
                                    {
                                        validationWarnings.Add(string.Format("Mismatching START/END QestIDs in qestlab.qes on lines {0} and {1}. Values {3}, {4}", currentObjectType.StartLineNumber, lineNumber, currentObjectType.QestID, qestID));
                                    }

                                    writer.WriteLine("GO");

                                    //99.5% because we want to leave the very last bit for handling of copying/moving files around once we're done.
                                    RaiseProgress(currentObjectType.ToString(), (float)99.5 * Convert.ToSingle(reader.BaseStream.Position) / Convert.ToSingle(reader.BaseStream.Length));

                                    currentObjectType = null;
                                    parserState = QestlabQesParserState.Default;
                                }
                                else if (lineType == QestlabQesLineType.ObjectProperty)
                                {
                                    //Property for the current object type
                                    var key = match.Groups[1].Value;
                                    var value = match.Groups[2].Value;
                                    
                                    //check for duplicates (within the same object type) - these aren't ever a good idea.
                                    if (currentObjectType.Properties.ContainsKey(key))
                                    {
                                        validationWarnings.Add(string.Format("Duplicate property detected for object {3} in qestlab.qes on line {0}.{1}{2}", lineNumber, System.Environment.NewLine, inputLine, currentObjectType));
                                    }
                                    else
                                    {
                                        //
                                        if (!IsValidObjectTypeProperty(key, value))
                                        {
                                            validationWarnings.Add(string.Format("Invalid property/value detected for object {3} in qestlab.qes on line {0}.{1}{2}", lineNumber, System.Environment.NewLine, inputLine, currentObjectType));
                                        }

                                        currentObjectType.Properties.Add(key, value);

                                        if (!string.IsNullOrEmpty(value))
                                        {
                                            writer.WriteLine("EXEC qest_AddObjectProperty @QestID={0}, @QestActive=1, @QestExtra=0, @Property={1}, @Value ={2}", currentObjectType.QestID, SqlEscape(key), SqlEscape(value));
                                        }
                                    }
                                }
                                else
                                {
                                    validationWarnings.Add(string.Format("Unexpected content found for object {3} in qestlab.qes at line {0}.{1}{2}", lineNumber, System.Environment.NewLine, inputLine, currentObjectType));
                                }
                            }

                            if (cancelToken.IsCancellationRequested)
                            {
                                //we're done here.
                                RaiseProgress("Cancelled", 0);
                                return;
                            }
                        }

                        writer.Write(footerScriptContent);
                    }
                }
                if (validationWarnings.Any())
                {
                    RaiseProgress("The following warnings were generated:", 99.5f);
                    foreach (var validationWarning in validationWarnings)
                    {
                        RaiseProgress(validationWarning, 100);
                    }
                    return;
                }
                RaiseProgress("Script generation complete.", 99.5f);

                
                //Replace the current file with the temp file that we just generated
                CreateTemporaryBackup(fileName);
                File.Move(tempFile, fileName);
                DeleteTemporaryBackup(fileName);

                //And do the same for the 'additional file'
                if (!string.IsNullOrEmpty(additionalFilename))
                {
                    CreateTemporaryBackup(additionalFilename);
                    File.Copy(fileName, additionalFilename);
                    DeleteTemporaryBackup(additionalFilename);
                }

                base.RaiseProgress("qestlab.qes", 100f);
            }
            finally
            {
                //delete the temp file if it's still there (presumably this means we cancelled...)
                if (File.Exists(tempFile))
                {
                    File.Delete(tempFile);
                }
            }

        }

        private void RemoveReadOnlyAttribute(string filename)
        {
            var attr = File.GetAttributes(filename);
            if (attr.HasFlag(FileAttributes.ReadOnly))
            {
                File.SetAttributes(filename, attr & ~FileAttributes.ReadOnly);
            }
        }
        private void CreateTemporaryBackup(string filename)
        {
            var backupFilename = filename + ".bak";
            if (File.Exists(filename))
            {
                if (File.Exists(backupFilename))
                {
                    RemoveReadOnlyAttribute(backupFilename);
                    File.Delete(backupFilename);
                }
                File.Move(filename, backupFilename);
            }
        }

        private void DeleteTemporaryBackup(string filename)
        {
            var backupFilename = filename + ".bak";
            if (File.Exists(backupFilename))
            {
                RemoveReadOnlyAttribute(backupFilename);
                File.Delete(backupFilename);
            }
        }

        private bool IsValidObjectTypeProperty(string key, string value)
        {
            //TODO: Validation warnings for properties
            //
            //1. Check that the key is valid (against a list)
            //
            //2. Check that the value is valid for the key (most properties are fine as any string, but some properties really should 
            //   be a boolean, and others a number.  Some also should meet other syntax requirements ... but validation is probably 
            //   more effort than it's worth for lists/reporting fields/etc).
            //
            return true;
        }

        private string SqlEscape(string text)
        {
            return "'" + text.Replace("'", "''") + "'";
        }

    }
}
