using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Xml.Linq;

//namespace Remittance
//{
    public partial class MasterPage : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["EMPID"] != null)
            {
                lblLoginUser.Text = Session["EMPID"].ToString();
                //LoginView1.Visible = true;
                hypLogin.Text = "Log out";
                hypLogin.NavigateUrl = "~/Logout.aspx";
            }
            else
            {
                lblLoginUser.Text = string.Empty;
                //LoginView1.Visible = false;
            }
        }
        protected void MainMenu_MenuItemClick(object sender, MenuEventArgs e)
        {
            //if (MainMenu.SelectedValue == "Add New Customer")
            //{
            //    Session.Remove("TODO");
            //    Response.Redirect("~/CustomerAdd.aspx", true);
            //}
        }
        protected void lblRole_Load(object sender, EventArgs e)
        {
            //if (lblRole.Text != "ADMIN")
            //    MainMenu.FindItem("Admin").Enabled = false;
        }

        protected void Page_PreInit(object sender, EventArgs e)
        {
            // This is necessary because Safari and Chrome browsers don't display the Menu control correctly.
            // All webpages displaying an ASP.NET menu control must inherit this class.
            if (Request.ServerVariables["http_user_agent"].IndexOf("Safari", StringComparison.CurrentCultureIgnoreCase) != -1)
                Page.ClientTarget = "uplevel";
        }

        protected override void AddedControl(Control control, int index)
        {
            // This is necessary because Safari and Chrome browsers don't display the Menu control correctly.
            // Add this to the code in your master page.
            if (Request.ServerVariables["http_user_agent"].IndexOf("Safari", StringComparison.CurrentCultureIgnoreCase) != -1)
                this.Page.ClientTarget = "uplevel";
            base.AddedControl(control, index);
        }

        protected void TreeView1_TreeNodeDataBound(object sender, TreeNodeEventArgs e)
        {

        }

        protected void MainMenu_DataBound(object sender, EventArgs e)
        {

        }

        //private void RemoveTreeNode(MenuEventArgs e)
        //{
        //    System.Web.UI.WebControls.MenuItem parent = e.Item.Parent;
        //    //if (parent != null)
        //    {            
        //        //parent.ChildItems.Remove(e.Item);
        //        e.Item.Enabled = false;
        //    }
        //}

        protected void MainMenu_MenuItemDataBound(object sender, MenuEventArgs e)
        {
            string[] Roles = Session["ROLES"].ToString().Split(',');
            SiteMapNode node = e.Item.DataItem as SiteMapNode;

            if (e.Item.Text == "")
            {
                RemoveMenuNode(e);
                return;
            }

            if (!string.IsNullOrEmpty(node["target"]))
                e.Item.Target = node["target"];

            //Check Branch
            if (!string.IsNullOrEmpty(node["branch"]))
            {
                string[] branches = node["branch"].ToString().Split(',');
                for (int i = 0; i < branches.Length; i++)
                    if (branches[i] == Session["BRANCHID"].ToString()
                        || branches[i] == "*") return;
                RemoveMenuNode(e);
                return;
            }



            //Check Role
            for (int i = 0; i < node.Roles.Count; i++)
                foreach (string Role in Roles)
                    if (node.Roles[i].ToString() == Role
                        || node.Roles[0].ToString() == "*"
                        )
                        return;
            RemoveMenuNode(e);
        }

        private void RemoveMenuNode(MenuEventArgs e)
        {
            try
            {
                if (e.Item.Parent == null)
                    MainMenu.Items.Remove(e.Item);
                else
                    e.Item.Parent.ChildItems.Remove(e.Item);
            }
            catch (Exception) { }
        }
    }
//}