using Fclp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Spectra.QESTNET.Upgrade
{
    class CustomOptionFormatter : ICommandLineOptionFormatter
    {
        public string Format(IEnumerable<Fclp.Internals.ICommandLineOption> options)
        {
            var sb = new StringBuilder();
            var indentLength = 4;
            var shortNameLength = options.Max(x => x.HasShortName ? x.ShortName.Length : 0) + 2;
            var longNameLength = options.Max(x => x.HasLongName ? x.LongName.Length : 0) + 4;
            var descriptionIndent = (indentLength + shortNameLength + longNameLength);
            var descriptionLength = Console.BufferWidth - descriptionIndent;
            if (descriptionLength < 40)
            {
                descriptionLength = 40;
                descriptionLength = 40;
            }
            foreach (var option in options)
            {
                sb.AppendLine();
                sb.Append(new string(' ', indentLength));
                if (option.HasShortName)
                {
                    sb.Append(option.ShortName);
                    sb.Append(new string(' ', shortNameLength - option.ShortName.Length));
                }
                else
                {
                    sb.Append(new string(' ', shortNameLength));
                }

                if (option.HasLongName)
                {
                    sb.Append(option.LongName);
                    sb.Append(new string(' ', longNameLength - option.LongName.Length));
                }
                else
                {
                    sb.Append(new string(' ', longNameLength));
                }
                int i = 0;
                while (i < option.Description.Length)
                {
                    var r = i + descriptionLength;
                    if (r > option.Description.Length) r = option.Description.Length;
                    sb.Append(option.Description.Substring(i, r - i));
                    if (r < option.Description.Length)
                        sb.AppendLine(new string(' ', descriptionIndent));
                    i = r;
                }
            }
            return sb.ToString();
        }
    }
}
