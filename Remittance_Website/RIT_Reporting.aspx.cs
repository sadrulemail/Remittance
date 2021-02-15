using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using OfficeOpenXml;
using System.Net;

namespace Remittance
{
    public partial class RIT_Reporting : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");
            if (TrustControl1.getUserRoles() == "")
            {
                Response.End();
            }

            if (IsPostBack)
            {
                GridView1.Visible = true;
            }
            else
            {
                txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.AddDays(-1));
                txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.AddDays(-1));
                Cache["RITCacheKey"] = DateTime.Now;
            }

            this.Title = "RIT Reporting";
        }

        protected void cboBranch_DataBound(object sender, EventArgs e)
        {
            //foreach (ListItem i in cboBranch.Items)
            //    i.Selected = false;


            //if (Session["BRANCHID"].ToString() != "1")
            //{
            //    foreach (ListItem ii in cboBranch.Items)
            //    {
            //        if (ii.Value == Session["BRANCHID"].ToString())
            //        {
            //            ii.Selected = true;
            //            cboBranch.Enabled = false;
            //        }
            //    }
            //}
        }
        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total: <b>{0:N0}</b>", e.AffectedRows);
            if (e.AffectedRows > 0)
                btn_xlsx.Visible = true;
            else
                btn_xlsx.Visible =false ;
        }

        protected void cboBranch_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }
        protected void txtFilter_TextChanged(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }
        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            GridView1.DataBind();
        }

        protected void cboStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }
        protected void cmdFilter_Click(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }
        protected void Timer1_Tick(object sender, EventArgs e)
        {
            //System.Threading.Thread.Sleep(5000);
            GridView1.DataBind();
        }
        protected void cboPaymentMethod_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }

        protected void cmdPreviousDay_Click(object sender, EventArgs e)
        {
            try
            {
                DateTime DT = DateTime.Parse(txtDateFrom.Text);
                txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
                txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
            }
            catch (Exception) { }
        }

        protected void cmdNextDay_Click(object sender, EventArgs e)
        {
            try
            {
                DateTime DT = DateTime.Parse(txtDateFrom.Text);
                txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(1));
                txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(1));
            }
            catch (Exception) { }
        }

        protected void btn_xlsx_Click(object sender, EventArgs e)
        {
            try
            {
                string FileName = Path.GetTempFileName();
                //string BatchID = Request.QueryString["batch"].ToString();
                //string CardType = Request.QueryString["CardType"].ToString();
                //FileName = "C:\\1.xlsx";
                FileInfo FI = new FileInfo(FileName);
                if (File.Exists(FileName)) File.Delete(FileName);

                using (ExcelPackage xlPackage = new ExcelPackage(FI))
                {
                    ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("RIT Reporting");
                    int StartRow = 1;

                    //Adding Title Row
                    worksheet.Column(1).Width = 15;
                    worksheet.Column(2).Width = 20;
                    worksheet.Column(3).Width = 10;
                    worksheet.Column(4).Width = 15;
                    worksheet.Column(5).Width = 20;
                    worksheet.Column(6).Width = 20;
                    worksheet.Column(7).Width = 15;
                    worksheet.Column(8).Width = 8;
                    worksheet.Column(9).Width = 15;
                    worksheet.Column(10).Width = 20;
                    worksheet.Column(11).Width = 25;
                    worksheet.Column(12).Width = 10;
                    worksheet.Column(13).Width = 10;
                    worksheet.Column(14).Width = 15;

                    //worksheet.Cells["A1:C1"].Style.Font.Bold = true;

                    //Adding Title Row
                    worksheet.Cells[StartRow, 1].Value = "DATED";
                    worksheet.Cells[StartRow, 2].Value = "FI NAME";
                    worksheet.Cells[StartRow, 3].Value = "SERIAL NO";
                    worksheet.Cells[StartRow, 4].Value = "AD FI BRANCH";
                    worksheet.Cells[StartRow, 5].Value = "REPORT TYPE";
                    worksheet.Cells[StartRow, 6].Value = "SCHEDULE CODE";
                    worksheet.Cells[StartRow, 7].Value = "TYPE CODE";
                    worksheet.Cells[StartRow, 8].Value = "PURPOSE CODE";
                    worksheet.Cells[StartRow, 9].Value = "CURRENCY";
                    worksheet.Cells[StartRow, 10].Value = "COUNTRY";
                    worksheet.Cells[StartRow, 11].Value = "DISTRICT";
                    worksheet.Cells[StartRow, 12].Value = "NID";
                    worksheet.Cells[StartRow, 13].Value = "PASSPORT";
                    worksheet.Cells[StartRow, 14].Value = "AMOUNT FCY";


                    DataView DV = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);
                    int R = 0;
                    for (int r = 0; r < DV.Table.Rows.Count; r++)
                    {
                        R = StartRow + r + 1;
                        if (DV.Table.Rows[r]["PaidDate"] != DBNull.Value)
                            worksheet.Cells[R, 1].Value =Convert.ToDateTime(DV.Table.Rows[r]["PaidDate"].ToString()).ToString("dd-MMM-yyyy");
                        if (DV.Table.Rows[r]["FI_Name"] != DBNull.Value)
                            worksheet.Cells[R, 2].Value = DV.Table.Rows[r]["FI_Name"].ToString();
                        if (DV.Table.Rows[r]["SL"] != DBNull.Value)
                            worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["SL"].ToString();
                        if (DV.Table.Rows[r]["FIBranchCode"] != DBNull.Value)
                            worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["FIBranchCode"].ToString();
                        if (DV.Table.Rows[r]["REPORT_TYPE"] != DBNull.Value)
                            worksheet.Cells[R, 5].Value = DV.Table.Rows[r]["REPORT_TYPE"].ToString();

                        if (DV.Table.Rows[r]["SCHEDULE_CODE"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 6].Value = DV.Table.Rows[r]["SCHEDULE_CODE"];
                        }

                        if (DV.Table.Rows[r]["Type_Code"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 7].Value = DV.Table.Rows[r]["Type_Code"];
                            //worksheet.Cells[R, 7].Style.Numberformat.Format = "dd-MMM-yyyy";
                        }

                        if (DV.Table.Rows[r]["Purpose_code"] != DBNull.Value)
                            worksheet.Cells[R, 8].Value = DV.Table.Rows[r]["Purpose_code"].ToString();
                        if (DV.Table.Rows[r]["CoverFundCurrency"] != DBNull.Value)
                            worksheet.Cells[R, 9].Value = DV.Table.Rows[r]["CoverFundCurrency"].ToString();
                        if (DV.Table.Rows[r]["CoverFund_CountryName"] != DBNull.Value)
                            worksheet.Cells[R, 10].Value = DV.Table.Rows[r]["CoverFund_CountryName"].ToString();
                        if (DV.Table.Rows[r]["RIT_Dist_Name"] != DBNull.Value)
                            worksheet.Cells[R, 11].Value = DV.Table.Rows[r]["RIT_Dist_Name"].ToString();
                        if (DV.Table.Rows[r]["NID"] != DBNull.Value)
                            worksheet.Cells[R, 12].Value = DV.Table.Rows[r]["NID"];
                        if (DV.Table.Rows[r]["Passport"] != DBNull.Value)
                            worksheet.Cells[R, 13].Value = DV.Table.Rows[r]["Passport"];
                        if (DV.Table.Rows[r]["CoverFundCurrencyRate"] != DBNull.Value)
                            worksheet.Cells[R, 14].Value = DV.Table.Rows[r]["CoverFundCurrencyRate"];
                       
                    }

                    //worksheet.Cells["A1:C" + R].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;


                    //Adding Properties
                    xlPackage.Workbook.Properties.Title = "RIT Reporting";
                    xlPackage.Workbook.Properties.Author = "Ashik Iqbal (www.ashik.info)";
                    xlPackage.Workbook.Properties.Company = "Trust Bank Limited";
                    xlPackage.Workbook.Properties.LastModifiedBy = string.Format("{0} ({1})", Session["FULLNAME"], Session["EMAIL"]);

                    xlPackage.Save();
                }


                //Reading File Content
                byte[] content = File.ReadAllBytes(FileName);
                File.Delete(FileName);

                //Downloading File
                Response.Clear();
                Response.ClearContent();
                Response.ClearHeaders();
                Response.ContentType = "application/ms-excel";
                Response.AddHeader("Content-Disposition", "attachment;filename=" + "RIT_Reporting"+".xlsx");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.BinaryWrite(content);
                Response.End();

            }
            catch (Exception ex)
            {
                TrustControl1.ClientMsg(ex.Message);
            }
        }

        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            //Cache["RITCacheKey"] = DateTime.Now;
        }
    }
}