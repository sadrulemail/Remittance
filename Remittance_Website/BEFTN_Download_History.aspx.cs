using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Remittance
{
    public partial class BEFTN_Download_History : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");
            if (TrustControl1.getUserRoles() == "")
            {
                Response.End();
            }
            if (!IsPostBack)
            {
                txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Today.AddDays(1 - DateTime.Today.Day));
                txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);
            }
            this.Title = "BEFTN Export History";
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
                //cboBranch.Enabled = false;
            }
        }
        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total: <b>{0}</b>", e.AffectedRows);
        }
        protected void cmdPreviousDay_Click(object sender, EventArgs e)
        {
            try
            {
                DateTime DT = DateTime.Parse(txtDateFrom.Text).AddMonths(-1);
                DateTime FirstDate = DT.AddDays(1 - DT.Day);
                txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", FirstDate);
                txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", FirstDate.AddMonths(1).AddDays(-1));
            }
            catch (Exception) { }
        }

        protected void cmdNextDay_Click(object sender, EventArgs e)
        {
            try
            {
                DateTime DT = DateTime.Parse(txtDateFrom.Text).AddMonths(1);
                DateTime FirstDate = DT.AddDays(1 - DT.Day);
                txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", FirstDate);
                txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", FirstDate.AddMonths(1).AddDays(-1));
            }
            catch (Exception) { }
        }
    }
}