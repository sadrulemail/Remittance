using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OfficeOpenXml;
using System.Data;

namespace Remittance
{
    public partial class SummaryHO : System.Web.UI.Page
    {
        double Total = 0;
        double Amount = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");

            if (TrustControl1.getUserRoles() == "")
            {
                Response.End();
            }

            if (Session["BRANCHID"].ToString() != "1")    //Not IT & Cards
            {
                Response.Write("No Permission.<br><br><a href=''>Home</a>");
                Response.End();
            }

            if (!IsPostBack)
            {
                txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
                txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
                GridView1.DataBind();
            }

            if (Session["BRANCHID"].ToString() != "1")
            {
                //cboRoutingBank.Visible = false;
                //lblRoutingBank.Visible = false;
                //cboBranch.Enabled = false;
            }
            this.Title = "Summary HO";
        }

        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total: <b>{0:N0}</b>", e.AffectedRows);
            cmdExport.Visible = (e.AffectedRows > 0);

        }
        protected void cboPaid_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.EditIndex = -1;
        }
        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {

        }
        protected void GridView1_DataBound(object sender, EventArgs e)
        {

        }
        protected void cboBranch_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.EditIndex = -1;
        }
        protected void txtFilter_TextChanged(object sender, EventArgs e)
        {
            GridView1.EditIndex = -1;
        }
        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {

        }
        protected void GridView1_RowUpdated(object sender, GridViewUpdatedEventArgs e)
        {
            if (hidRoutingMsg.Value != "")
            {
                e.KeepInEditMode = true;
                TrustControl1.ClientMsg(hidRoutingMsg.Value);
            }
        }
        protected void SqlDataSource1_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            hidRoutingMsg.Value = Msg;
        }
        protected void cmdExport_Click(object sender, EventArgs e)
        {
            try
            {
                string FilePath = Server.MapPath("~/Upload");
                string FileName = Path.Combine(FilePath, Session.SessionID + ".xlsx");
                if (File.Exists(FileName)) File.Delete(FileName);
                FileInfo FI = new FileInfo(FileName);
                using (ExcelPackage xlPackage = new ExcelPackage(FI))
                {
                    ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("Remittance");
                    int StartRow = 1;

                    //Adding Title Row
                    worksheet.Cells[StartRow, 1].Value = "Paid Branch Name";
                    worksheet.Cells[StartRow, 2].Value = "Paid Branch";
                    worksheet.Cells[StartRow, 3].Value = "Currency";
                    worksheet.Cells[StartRow, 4].Value = "Total";
                    worksheet.Cells[StartRow, 5].Value = "Amount";
                    worksheet.Cells[StartRow, 6].Value = "Status";

                    worksheet.Column(1).Width = 20;
                    worksheet.Column(2).Width = 12;
                    worksheet.Column(3).Width = 12;
                    worksheet.Column(4).Width = 10;
                    worksheet.Column(5).Width = 15;


                    DataView DV = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);
                    for (int r = 0; r < DV.Table.Rows.Count; r++)
                    {
                        int R = StartRow + r + 1;
                        //worksheet.Cells[R, 1].Value = r + 1;

                        if (DV.Table.Rows[r]["BranchName"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 1].Value = DV.Table.Rows[r]["BranchName"].ToString();
                            //worksheet.Cells[R, 1].Style.Numberformat.Format = "MM/dd/yyyy";
                        }


                        if (DV.Table.Rows[r]["PaidBranch"] != DBNull.Value)
                            worksheet.Cells[R, 2].Value = DV.Table.Rows[r]["PaidBranch"].ToString();

                        if (DV.Table.Rows[r]["Currency"] != DBNull.Value)
                            worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["Currency"].ToString();

                        if (DV.Table.Rows[r]["Total"] != DBNull.Value)
                            worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["Total"];


                        if (DV.Table.Rows[r]["Amount"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 5].Value = DV.Table.Rows[r]["Amount"];
                            worksheet.Cells[R, 5].Style.Numberformat.Format = "#,##0.00";
                        }

                        if (DV.Table.Rows[r]["Status"] != DBNull.Value)
                            worksheet.Cells[R, 6].Value = DV.Table.Rows[r]["Status"].ToString();

                    }

                    worksheet.Cells["A1:F1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["A1:F1"].Style.Font.Bold = true;



                    //Adding Properties
                    xlPackage.Workbook.Properties.Title = "Remittance";
                    xlPackage.Workbook.Properties.Author = string.Format("{0}", Session["EMPNAME"]);
                    xlPackage.Workbook.Properties.Company = "Trust Bank Limited";
                    xlPackage.Workbook.Properties.LastModifiedBy = string.Format("{0}", Session["EMPNAME"]);

                    xlPackage.Save();
                }


                //Reading File Content
                byte[] content = File.ReadAllBytes(FileName);
                File.Delete(FileName);

                //Downloading File
                Response.Clear();
                Response.ClearContent();
                Response.ClearHeaders();
                Response.ContentType = "application/xlsx";
                Response.AddHeader("Content-Disposition", "attachment;filename=" + string.Format(
                    "Remittance_Payment_Summary_{0}.xlsx",
                    //txtDateFrom.Text.Replace("/","_"),
                    cboExHouse.SelectedItem.Value.Replace(" ", "_")
                    )
                    );
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.BinaryWrite(content);
                Response.End();
            }
            catch (Exception ex)
            {
                lblStatus.Text = ex.Message;
            }
        }
        protected void GridView1_DataBound1(object sender, EventArgs e)
        {
            //double Total = 0;
            //double Amount = 0;
            //if (GridView1.Rows.Count > 1)
            //{
            //    for (int i = 0; i < GridView1.Rows.Count; i++)
            //    {
            //        Total += double.Parse(GridView1.Rows[i].Cells[3].Text);
            //        Amount += double.Parse(GridView1.Rows[i].Cells[4].Text);
            //    }
            //    GridView1.FooterRow.Cells[3].Text = string.Format("{0:N0}", Total);
            //    GridView1.FooterRow.Cells[3].HorizontalAlign = HorizontalAlign.Center;

            //    GridView1.FooterRow.Cells[4].Text = string.Format("{0:N2}", Amount);
            //}
        }
        protected void DropDownListStatus_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        protected void cboExHouse_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        protected void cboPaymentMethod_DataBound(object sender, EventArgs e)
        {
            for (int i = 0; i < cboPaymentMethod.Items.Count; i++)
            {
                if (i > 0)
                {
                    cboPaymentMethod.Items[i].Attributes.Add("title", cboPaymentMethod.Items[i].Text);
                    cboPaymentMethod.Items[i].Text = cboPaymentMethod.Items[i].Value;
                }
            }
        }
        protected void cmdPreviousDay_Click(object sender, EventArgs e)
        {
            DateTime DT = DateTime.Parse(txtDateFrom.Text);
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
        }
        protected void cmdNextDay_Click(object sender, EventArgs e)
        {
            DateTime DT = DateTime.Parse(txtDateFrom.Text);
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(1));
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(1));
        }
        protected void radioCurrency_DataBound(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                radioCurrency.SelectedIndex = 0;
            }
        }
        public string getLink(object PaidBranch, object Currency, object PaymentMethod, object ExHouseCode, object Status, object SDate, object EDate)
        {
            return string.Format("<a href='SummaryHO_View.aspx?PaidBranch={0}&Currency={1}&PaymentMethod={2}&ExHouseCode={3}&Status={4}&SDate={5}&EDate={6}' target='_blank'><img src='Images/open.png' width='16' height='16' border='0' title='View' /></a>",
                PaidBranch, Currency, PaymentMethod, ExHouseCode, Status, SDate, EDate);

        }

        protected void GridView1_RowDataBound1(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Amount += Convert.ToDouble(DataBinder.Eval(e.Row.DataItem, "Amount"));
                Total += Convert.ToDouble(DataBinder.Eval(e.Row.DataItem, "Total"));
            }

            if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells[3].Text = string.Format(TrustControl1.Bangla, "{0:N0}", Total);
                e.Row.Cells[3].HorizontalAlign = HorizontalAlign.Center;

                e.Row.Cells[4].Text = string.Format(TrustControl1.Bangla, "{0:N2}", Amount);
            }
        }
    }
}