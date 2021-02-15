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
    public partial class Upload_Log : System.Web.UI.Page
    {
        int TotalCount = 0;
        int TotalRows = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");
            if (TrustControl1.getUserRoles() == "")
            {
                Response.End();
            }

            if (IsPostBack)
            {
                //GridView1.DataBind();
            }
            else
            {
                txtDateFrom.Text = string.Format("{0:dd/MM/yyy}", DateTime.Now.Date);
                txtDateTo.Text = string.Format("{0:dd/MM/yyy}", DateTime.Now.Date);
            }

            this.Title = "Upload Data Log";
        }
        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            TotalRows = e.AffectedRows;
            if (TotalRows > 0)
                cmdDownload.Visible = true;
            else
                cmdDownload.Visible = false;

        }
        public string getBgColor(object DT, string Color)
        {
            return Color;
        }
        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //if (Convert.ToDateTime(DataBinder.Eval(e.Row.DataItem, "DT")).Date == DateTime.Now.Date)
                //{
                //    e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFFF88");
                //    e.Row.ForeColor = System.Drawing.Color.Black;
                //    TotalCount++;
                //}
                if (Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "Published")) == false)
                {
                    //e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#EEEEEE");
                    e.Row.ForeColor = System.Drawing.Color.Gray;
                    TotalCount++;
                }
            }
            //lblStatus.Text = string.Format("Total Batch: <b>{0}</b>, Totay: <b>{1}</b>", TotalRows, TotalCount);
        }
        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            //lblStatus.Text = string.Format("Total Batch: <b>{0}</b><br />Totay's Total Batch: <b>{1}</b>", TotalRows, TotalCount);
            lblStatus.Text = string.Format("Total Batch Uploaded: <b>{0}</b>", TotalRows);
            GridView1.SelectedIndex = -1;
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

        protected void SqlDataSource1_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            GridView1.DataBind();
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Select")
            {
                modal.Show();
                GridView2.DataBind();
            }
        }

        protected void GridView1_PageIndexChanged(object sender, EventArgs e)
        {
            GridView1.SelectedIndex = -1;
        }

        protected void cmdFilter_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtBatch.Text) || string.IsNullOrEmpty(txtBatch.Text))
            {
                GridView1.DataBind();
            }
            else
            {
                txtDateFrom.Text = "";
                txtDateTo.Text = "";
                txtPublishedBy.Text = "";
                txtUploadBy.Text = "";
                cboExHouse.SelectedIndex = 0;
                dboPublished.SelectedIndex = 0;
                GridView1.DataBind();
            }
        }



        protected void cmdDownload_Click(object sender, EventArgs e)
        {
            if (!Directory.Exists(Server.MapPath("Upload")))
            {
                Directory.CreateDirectory(Server.MapPath("Upload"));         
            } 

            try
            {

                DataView DV = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);


                string FilePath = Server.MapPath("~/Upload");
                string FileName = Path.Combine(FilePath, Session.SessionID + "_Remittance_Log" + ".xlsx");
                if (File.Exists(FileName)) File.Delete(FileName);
                FileInfo FI = new FileInfo(FileName);
                using (ExcelPackage xlPackage = new ExcelPackage(FI))
                {
                    ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("BEFTN");
                    int StartRow = 1;

                    //Adding Title Row
                    worksheet.Cells[StartRow, 1].Value = "Batch";
                    
                    worksheet.Cells[StartRow, 2].Value = "Total Items";
                    worksheet.Cells[StartRow, 3].Value = "Test Number";
                    worksheet.Cells[StartRow, 4].Value = "Payment Currency";
                    worksheet.Cells[StartRow, 5].Value = "Total Amount";
                    worksheet.Cells[StartRow, 6].Value = "Ex House";
                    worksheet.Cells[StartRow, 7].Value = "Cover Fund Currency";
                    worksheet.Cells[StartRow, 8].Value = "Cover Fund Currency Rate";
                    worksheet.Cells[StartRow, 9].Value = "Upload By";
                    worksheet.Cells[StartRow, 10].Value = "Upload Date";
                    worksheet.Cells[StartRow, 11].Value = "Publish By";
                    worksheet.Cells[StartRow, 12].Value = "Publish Date";

                    worksheet.Column(1).Width = 10;
                    worksheet.Column(2).Width = 10;
                    worksheet.Column(3).Width = 15;
                    worksheet.Column(4).Width = 10;
                    worksheet.Column(5).Width = 17;
                    worksheet.Column(6).Width = 30;
                    worksheet.Column(7).Width = 10;
                    worksheet.Column(8).Width = 10;
                    worksheet.Column(9).Width = 10;
                    worksheet.Column(10).Width = 10;
                    worksheet.Column(11).Width = 10;
                    worksheet.Column(12).Width = 10;

                    worksheet.Cells[1, 1].Style.WrapText = true;
                    worksheet.Cells[1, 2].Style.WrapText = true;
                    worksheet.Cells[1, 3].Style.WrapText = true;
                    worksheet.Cells[1, 4].Style.WrapText = true;
                    worksheet.Cells[1, 5].Style.WrapText = true;
                    worksheet.Cells[1, 6].Style.WrapText = true;
                    worksheet.Cells[1, 7].Style.WrapText = true;
                    worksheet.Cells[1, 8].Style.WrapText = true;
                    worksheet.Cells[1, 9].Style.WrapText = true;
                    worksheet.Cells[1, 10].Style.WrapText = true;
                    worksheet.Cells[1, 11].Style.WrapText = true;
                    worksheet.Cells[1, 12].Style.WrapText = true;


                    for (int r = 0; r < DV.Table.Rows.Count; r++)
                    {
                        int R = StartRow + r + 1;

                        worksheet.Cells[R, 1].Value = DV.Table.Rows[r]["Batch"];

                        if (DV.Table.Rows[r]["Total"] != DBNull.Value)
                            worksheet.Cells[R, 2].Value = DV.Table.Rows[r]["Total"];

                        if (DV.Table.Rows[r]["TestNumber"] != DBNull.Value)
                            worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["TestNumber"].ToString();

                        if (DV.Table.Rows[r]["Currency"] != DBNull.Value)
                        {

                            worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["Currency"];
                        }

                        if (DV.Table.Rows[r]["TotalAmount"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 5].Value = DV.Table.Rows[r]["TotalAmount"];
                            worksheet.Cells[R, 5].Style.Numberformat.Format = "#,##0.00";
                        }
                        if (DV.Table.Rows[r]["ExHouse"] != DBNull.Value)
                            worksheet.Cells[R, 6].Value = DV.Table.Rows[r]["ExHouse"].ToString();

                        if (DV.Table.Rows[r]["CoverFundCurrency"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 7].Value = DV.Table.Rows[r]["CoverFundCurrency"].ToString();
                        }

                        if (DV.Table.Rows[r]["CoverFundCurrencyRate"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 8].Value = DV.Table.Rows[r]["CoverFundCurrencyRate"];
                            worksheet.Cells[R, 8].Style.Numberformat.Format = "#,##0.00";
                        }

                        if (DV.Table.Rows[r]["EmpID"] != DBNull.Value)
                        {
                           
                            worksheet.Cells[R, 9].Value = string.Format("{0}", DV.Table.Rows[r]["EmpID"].ToString());
                        }

                        if (DV.Table.Rows[r]["DT"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 10].Value = DV.Table.Rows[r]["DT"];
                            worksheet.Cells[R, 10].Style.Numberformat.Format = "d-MMM-yy";
                        }

                        if (DV.Table.Rows[r]["PublishedBy"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 11].Value = DV.Table.Rows[r]["PublishedBy"];
                            //worksheet.Cells[R, 11].Style.Numberformat.Format = "#,##0.00";
                        }

                        worksheet.Cells[R, 12].Value = DV.Table.Rows[r]["PublishedDT"];
                        worksheet.Cells[R, 12].Style.Numberformat.Format = "d-MMM-yy";

                    }

                    worksheet.Cells["A1:L1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["A1:A"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["B1:B"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["D1:D"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    //worksheet.Cells["E1:E"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["G1:G"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    //worksheet.Cells["H1:H"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["I1:I"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["J1:J"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["L1:L"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["A1:L1"].Style.Font.Bold = true;



                    //Adding Properties
                    xlPackage.Workbook.Properties.Title = "Remittance Upload Log";
                    xlPackage.Workbook.Properties.Author = string.Format("{0}", Session["EMPNAME"]);
                    xlPackage.Workbook.Properties.Company = "Trust Bank Limited";
                    xlPackage.Workbook.Properties.LastModifiedBy = string.Format("{0}", Session["EMPNAME"]);

                    xlPackage.Save();
                }


                //Reading File Content
                byte[] content = File.ReadAllBytes(FileName);
                File.Delete(FileName);

                string ExportFileName = string.Format("Remittance_Upload_Log-{0:ddMMyyyy}.xlsx",                  
                    DateTime.Now.Date);

                //Downloading File
                Response.Clear();
                Response.ClearContent();
                Response.ClearHeaders();
                Response.ContentType = "application/xlsx";
                Response.AddHeader("Content-Disposition", "attachment;filename=" + ExportFileName);
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.BinaryWrite(content);
                Response.End();
            }
            catch (Exception)
            {
                //Response.Write("Error: " + ex.Message);
            }
        }
    }
}