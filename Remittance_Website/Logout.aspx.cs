using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

namespace Remittance
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string ApplicationID = System.Configuration.ConfigurationManager.AppSettings["ApplicationID"].ToString();
                string CookieName = "Login_" + ApplicationID;
                try
                {
                    HttpCookie cookie = new HttpCookie(CookieName);
                    cookie.Values.Add("ID", "");
                    cookie.Values.Add("Password", "");
                    cookie.Expires = DateTime.Now.AddYears(-20);
                    Response.Cookies.Add(cookie);
                }
                catch (Exception) { }
            }
            catch (Exception) { }

            Session.Abandon();
            Response.Redirect("~/Default.aspx", true);
        }
    }
}