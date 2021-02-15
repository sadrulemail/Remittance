using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Remittance
{
    public partial class App_Users : System.Web.UI.Page
    {
        string branch;

        protected void Page_Load(object sender, EventArgs e)
        {
            TrustControl1.getUserRoles();
            Page.Title = "App Users";
            hidAppCode.Value = TrustControl1.getValueOfKey("ApplicationID");
        }
        protected void SqlDataSourceUsers_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total: <b>{0}</b>", e.AffectedRows);
        }
        protected void SqlDataSourceUsers1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblEmptyBranch.Text = string.Format("Total Empty Branch: <b>{0}</b>", e.AffectedRows);
        }
        protected void SqlDataSourceApp_Branchwise_Emp_Count_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblApp_Branchwise_Emp_Count.Text = string.Format("Total Branch: <b>{0}</b>", e.AffectedRows);
        }
        protected void GridView4_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            //TrustControl1.ClientMsg(e.CommandArgument.ToString());
            foreach (ListItem li in dboBranch.Items)
            {
                li.Selected = false;
                if (li.Value == e.CommandArgument.ToString())
                    li.Selected = true;
            }
            dboDept.SelectedIndex = 0;
            dboActive.SelectedIndex = 0;
            TabContainer1.ActiveTabIndex = 0;
        }
    }
}