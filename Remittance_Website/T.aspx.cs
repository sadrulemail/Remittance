using System;

public partial class T : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();

        string s = "";
        s = string.Format("{0}", Session["EMPID"]);
        s += "<br>" + string.Format("{0}", Session["DESIGNATION"]);
        s += "<br>" + string.Format("{0}", Session["BRANCHNAME"]);
        Label1.Text = s + ".";
    }
}