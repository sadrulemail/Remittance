using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


    public partial class EMP : System.Web.UI.UserControl
    {
        public string Username
        {
            set
            {
                lblUserID.Text = string.Format("{0}", value);
                HoverMenuExtenderlblUserID.DynamicContextKey = value;
            }
            get
            {
                return lblUserID.Text.Trim().Replace("&nbsp;", "");
            }
        }

        public string Position
        {
            set
            {
                try
                {
                    if (value.ToString().ToUpper() == "LEFT")
                        HoverMenuExtenderlblUserID.PopupPosition = AjaxControlToolkit.HoverMenuPopupPosition.Left;
                }
                catch (Exception)
                {
                    HoverMenuExtenderlblUserID.PopupPosition = AjaxControlToolkit.HoverMenuPopupPosition.Right;
                    UserInfo.Width = Unit.Empty;
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
