using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Remittance
{
    public partial class MM_Export : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");
            if (TrustControl1.getUserRoles() == "")
            {
                Response.End();
            }
            this.Title = "Export to Mobile Money";
        }
        protected void cboBranch_DataBound(object sender, EventArgs e)
        {
            foreach (ListItem i in cboBranch.Items)
                i.Selected = false;


            if (Session["BRANCHID"].ToString() != "1")
            {
                foreach (ListItem ii in cboBranch.Items)
                {
                    if (ii.Value == Session["BRANCHID"].ToString())
                        ii.Selected = true;
                    else
                        ii.Enabled = false;
                }
                GridView1.DataBind();
                //cboBranch.Enabled = false;
            }
        }
        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total: <b>{0:N0}</b>", e.AffectedRows);
            cmdMarkPaid.Visible = (
                e.AffectedRows > 0 &&
                cboBranch.SelectedItem.Value == string.Format("{0}", Session["BRANCHID"]) &&
                TrustControl1.isRole("MM_EXPORT")
                );
        }
        protected void SqlDataSource1_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {

        }
        protected void cmdMarkPaid_Click(object sender, EventArgs e)
        {
            SqlDataSource1.Update();
        }
        protected void SqlDataSource1_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            if (e.Command.Parameters["@Msg"].Value.ToString().Trim().Length > 0)
            {
                TrustControl1.ClientMsg(string.Format("{0}", e.Command.Parameters["@Msg"].Value));
            }
            else
            {
                PanelStatusMarkPaid.Visible = true;
                lblStatusMarkPaid.Text = string.Format("Total Paid Marked: {0} <br>Batch No: {1}<br><br><a href='MM_Download.aspx?batch={1}' target='_blank' class='Button'>Download as Mobile Money xlsx</a>"
                    , e.Command.Parameters["@Total"].Value
                    , e.Command.Parameters["@BatchNo"].Value);
            }
        }
    }
}