using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Remittance
{
    public partial class Flora_Export : System.Web.UI.Page
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
            this.Title = "Export to Flora";
            //PanelStatusMarkPaid.Visible = true;
            //lblStatusMarkPaid.Text = string.Format("Total Paid Marked: {0} <br>Batch No: {1}<br><br><a href='Flora_Download.aspx?batch={1}&format=xlsx' target='_blank' class='Button'>Download as xlsx</a><br><br><a href='Flora_Download.aspx?batch={1}&format=txt' target='_blank' class='Button'>Download as txt</a><br><br><a href='Flora_Download.aspx?batch={1}&format=view' target='_blank' class='Button'>View Data</a>"
            //    ,123,23);
            if (IsPostBack)
            {
                TotalPendingRefresh();
            }
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

        private void PanelExportRefresh()
        {
            PanelExport.Visible =
               (R > 0 || I > 0) &&
               cboBranch.SelectedItem.Value == string.Format("{0}", Session["BRANCHID"]) &&
               TrustControl1.isRole("FLORA_EXPORT");
        }

        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("{0:N0}", e.AffectedRows);
            //cmdMarkPaid.Visible = (
            //    e.AffectedRows > 0 &&
            //    cboBranch.SelectedItem.Value == string.Format("{0}", Session["BRANCHID"]) &&
            //    TrustControl1.isRole("FLORA_EXPORT")
            //    );
            TotalPendingRefresh();
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
                GridView1.DataBind();
                GridView2.DataBind();
                GridView3.DataBind();

                PanelStatusMarkPaid.Visible = true;
                lblStatusMarkPaid.Text = string.Format("Total Paid Marked: {0} <br>Batch No: {1}<br><br><a href='Flora_Download.aspx?batch={1}&PaymentType={2}&format=xlsx' target='_blank' class='Link'>Download as xlsx</a><br><a href='Flora_Download.aspx?batch={1}&PaymentType={2}&format=txt' target='_blank' class='Link'>Download as txt</a><br><a href='Flora_Download.aspx?batch={1}&PaymentType={2}&format=view' target='_blank' class='Link'>View Data</a>"
                    , e.Command.Parameters["@Total"].Value
                    , e.Command.Parameters["@BatchNo"].Value
                    , cboPaymentType.SelectedItem.Value);
            }
        }
        protected void radioCurrency_DataBound(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                radioCurrency.SelectedIndex = 0;
            }
        }

        protected void SqlDataSource3_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatusIncentive.Text = string.Format("{0:N0}", e.AffectedRows);
            //cmdMarkPaid.Visible = (
            //    e.AffectedRows > 0 &&
            //    cboBranch.SelectedItem.Value == string.Format("{0}", Session["BRANCHID"]) &&
            //    TrustControl1.isRole("FLORA_EXPORT")
            //    );
            TotalPendingRefresh();
        }
    }
}