using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Remittance
{
    public partial class BEFTN_Export : System.Web.UI.Page
    {
        long R = 0;
        long I = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");
            if (TrustControl1.getUserRoles() == "")
            {
                Response.End();
            }
            this.Title = "Export to " + Request.QueryString["type"].ToString();
            litType.Text = "Export to " + Request.QueryString["type"].ToString();
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
        private void PanelExportRefresh()
        {
            PanelExport.Visible =
               (R > 0 || I > 0) &&
               cboBranch.SelectedItem.Value == string.Format("{0}", Session["BRANCHID"]) &&
               TrustControl1.isRole("BEFTN_EXPORT");
        }
        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("{0:N0}", e.AffectedRows);
            TotalPendingRefresh();        
        }
        protected void SqlDataSource2_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatusIncentive.Text = string.Format("{0:N0}", e.AffectedRows);
            TotalPendingRefresh();
            
        }
        protected void TotalPendingRefresh()
        {            
            try
            {
                R = long.Parse(lblStatus.Text.Replace(",", ""));
            }
            catch (Exception) { }
            try
            {
                I = long.Parse(lblStatusIncentive.Text.Replace(",", ""));
            }
            catch (Exception) { }
            lblTotal.Text = string.Format("{0:N0}", R + I);

            PanelExportRefresh();
        }
        protected void SqlDataSource1_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {

        }
        protected void cmdMarkPaid_Click(object sender, EventArgs e)
        {
            TotalPendingRefresh();
            if (cboPaymentType.SelectedItem.Value == "R" && R > 0)
                SqlDataSource1.Update();
            else if (cboPaymentType.SelectedItem.Value == "I" && I > 0)
                SqlDataSource1.Update();
            else
                TrustControl1.ClientMsg("Nothing to Export.");
        }
        protected void SqlDataSource1_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            if (e.Command.Parameters["@Msg"].Value.ToString().Trim().Length > 0)
            {
                TrustControl1.ClientMsg(string.Format("{0}", e.Command.Parameters["@Msg"].Value));
            }
            else
            {
                string ExpType = string.Format("{0}", Request.QueryString["type"]);

                PanelExport.Visible = false;
                GridView1.DataBind();
                GridView2.DataBind();

                if (ExpType.ToUpper() == "BEFTN")
                {
                    PanelStatusMarkPaid.Visible = true;
                    lblStatusMarkPaid.Text = string.Format("Total Paid Marked: {0} <br>Batch No: <a href='BEFTN_Download.aspx?batch={1}&PaymentType={2}&view=yes' target='_blank' class='Link'>{1}</a><br><br><a href='BEFTN_Download.aspx?batch={1}&PaymentType={2}' target='_blank' class='Link'>Download as BEFTN xlsx</a>"
                        , e.Command.Parameters["@Total"].Value
                        , e.Command.Parameters["@BatchNo"].Value
                        , cboPaymentType.SelectedItem.Value);
                }
                else if (ExpType.ToUpper() == "RTGS")
                {
                    PanelStatusMarkPaid.Visible = true;
                    lblStatusMarkPaid.Text = string.Format("Total Paid Marked: {0} <br>Batch No: <a href='RTGS_Download.aspx?batch={1}&PaymentType={2}&view=yes' target='_blank' class='Link'>{1}</a><br><br><a href='RTGS_Download.aspx?batch={1}&PaymentType={2}' target='_blank' class='Link'>Download as RTGS xlsx</a>"
                        , e.Command.Parameters["@Total"].Value
                        , e.Command.Parameters["@BatchNo"].Value
                        , cboPaymentType.SelectedItem.Value);
                }
            }
        }
    }
}