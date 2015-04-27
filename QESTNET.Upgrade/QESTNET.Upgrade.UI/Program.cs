using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Spectra.QESTNET.Upgrade.UI
{
    static class Program
    {

        INTENTIONAL SCREWUP TO TEST TEAMCITY NOTIFIER

        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new DbUpgradeUI());
        }
    }
}
