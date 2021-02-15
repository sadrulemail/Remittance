using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


    public partial class BEFTN : System.Web.UI.UserControl
    {
        string _TextFormat = "";

        public string TextFormat
        {
            set { _TextFormat = value; }
            get { return _TextFormat; }
        }

        public string Code
        {
            set
            {
                lblBEFTN.Text = string.Format("{0}", value);
                HoverMenuExtenderlblBEFTN.DynamicContextKey = value;

                try
                {
                    lblBEFTN_Pre.Text = _TextFormat.Substring(0, _TextFormat.IndexOf("{0}"));
                }
                catch (Exception) { }
                try
                {
                    lblBEFTN_Post.Text = _TextFormat.Substring(_TextFormat.IndexOf("{0}") + 3);
                }
                catch (Exception) { }

                if (value.Length == 0)
                {
                    lblBEFTN_Pre.Text = "";
                    lblBEFTN_Post.Text = "";
                }
            }
            get
            {
                return lblBEFTN.Text.Trim().Replace("&nbsp;", "");
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }

