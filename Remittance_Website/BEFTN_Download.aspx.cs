using System;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OfficeOpenXml;
using System.Data;

namespace Remittance
{
    public partial class BEFTN_Download : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            TrustControl1.getUserRoles();

            if (TrustControl1.isRole("BEFTN_EXPORT") || TrustControl1.isRole("ADMIN"))
            {
                if (string.Format("{0}", Request.QueryString["view"]).Length == 0)
                    //ExportXlsx();
                    ExportXlsxFlora();
                else
                {
                    lblTitle.Text = string.Format("BEFTN Export Batch # {0}", Request.QueryString["batch"]);
                    this.Title = string.Format("BEFTN # {0}", Request.QueryString["batch"]);
                    GridView1.Visible = true;
                    lblStatus.Visible = true;
                }
            }
        }

        private void ExportXlsxFlora()
        {
            if (!Directory.Exists(Server.MapPath("Upload")))
            {
                Directory.CreateDirectory(Server.MapPath("Upload"));
            }

            string Batch = string.Format("{0}", Request.QueryString["batch"]);
            if (Batch == string.Empty) Response.End();

            try
            {
                DataView DV2 = (DataView)SqlDataSource2.Select(DataSourceSelectArguments.Empty);
                string BEFTN_Code = string.Format("{0}", DV2.Table.Rows[0]["beftn_code"]);
                DataView DV = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);


                string FilePath = Server.MapPath("~/Upload");
                string FileName = Path.Combine(FilePath, Session.SessionID + "_" + Batch + ".xlsx");
                if (File.Exists(FileName)) File.Delete(FileName);
                FileInfo FI = new FileInfo(FileName);
                using (ExcelPackage xlPackage = new ExcelPackage(FI))
                {
                    ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("BEFTN");
                    int StartRow = 1;

                    //Adding Title Row
                    worksheet.Cells[StartRow, 1].Value = "Message_Type";
                    worksheet.Cells[StartRow, 2].Value = "Send_Accountno";
                    worksheet.Cells[StartRow, 3].Value = "Description";
                    worksheet.Cells[StartRow, 4].Value = "Trn_Code";
                    worksheet.Cells[StartRow, 5].Value = "Recv_Bank_Rt";
                    worksheet.Cells[StartRow, 6].Value = "Recv_Accountno";
                    worksheet.Cells[StartRow, 7].Value = "Amount";
                    worksheet.Cells[StartRow, 8].Value = "Recv_Name";
                    worksheet.Cells[StartRow, 9].Value = "Recv_IDno";

                    worksheet.Column(1).Width = 12;
                    worksheet.Column(2).Width = 20;
                    worksheet.Column(3).Width = 20;
                    worksheet.Column(4).Width = 10;
                    worksheet.Column(5).Width = 20;
                    worksheet.Column(6).Width = 20;
                    worksheet.Column(7).Width = 15;
                    worksheet.Column(8).Width = 30;
                    worksheet.Column(9).Width = 10;

                    for (int r = 0; r < DV.Table.Rows.Count; r++)
                    {
                        int R = StartRow + r + 1;

                        worksheet.Cells[R, 1].Value = DV.Table.Rows[r]["Message_Type"].ToString();

                        if (DV.Table.Rows[r]["RemitterAccount"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 2].Style.Numberformat.Format = "@";
                            worksheet.Cells[R, 2].Value = DV.Table.Rows[r]["ExHouseAccNo"];
                        }

                        worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["Reference"].ToString();
                        worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["Trn_Code"].ToString();

                        if (DV.Table.Rows[r]["RoutingNumber"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 5].Style.Numberformat.Format = "@";
                            worksheet.Cells[R, 5].Value = string.Format("{0}", DV.Table.Rows[r]["RoutingNumber"]);
                        }

                        if (DV.Table.Rows[r]["Account"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 6].Style.Numberformat.Format = "@";
                            worksheet.Cells[R, 6].Value = DV.Table.Rows[r]["Account"].ToString();
                        }

                        if (DV.Table.Rows[r]["Amount"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 7].Value = DV.Table.Rows[r]["Amount"];
                            worksheet.Cells[R, 7].Style.Numberformat.Format = "#,##0.00";
                        }

                        if (DV.Table.Rows[r]["BeneficiaryName"] != DBNull.Value)
                            worksheet.Cells[R, 8].Value = DV.Table.Rows[r]["BeneficiaryName"].ToString();

                        if (DV.Table.Rows[r]["PaymentDescription"] != DBNull.Value)
                            worksheet.Cells[R, 9].Value = DV.Table.Rows[r]["PaymentDescription"].ToString();



                    }

                    worksheet.Cells["A1:I1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["A1:I1"].Style.Font.Bold = true;



                    //Adding Properties
                    xlPackage.Workbook.Properties.Title = "BEFTN";
                    xlPackage.Workbook.Properties.Author = string.Format("{0}", Session["EMPNAME"]);
                    xlPackage.Workbook.Properties.Company = "Trust Bank Limited";
                    xlPackage.Workbook.Properties.LastModifiedBy = string.Format("{0}", Session["EMPNAME"]);

                    xlPackage.Save();
                }


                //Reading File Content
                byte[] content = File.ReadAllBytes(FileName);
                File.Delete(FileName);

                string ExportFileName = string.Format("EFTN{1:yyyyMMdd}{0}.xlsx",
                    Batch,
                    DateTime.Now.Date,
                    BEFTN_Code);

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

        private void ExportXlsx()
        {
            if (!Directory.Exists(Server.MapPath("Upload")))
            {
                Directory.CreateDirectory(Server.MapPath("Upload"));
            }

            string Batch = string.Format("{0}", Request.QueryString["batch"]);
            if (Batch == string.Empty) Response.End();

            try
            {
                DataView DV2 = (DataView)SqlDataSource2.Select(DataSourceSelectArguments.Empty);
                string BEFTN_Code = string.Format("{0}", DV2.Table.Rows[0]["beftn_code"]);
                DataView DV = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);


                string FilePath = Server.MapPath("~/Upload");
                string FileName = Path.Combine(FilePath, Session.SessionID + "_" + Batch + ".xlsx");
                if (File.Exists(FileName)) File.Delete(FileName);
                FileInfo FI = new FileInfo(FileName);
                using (ExcelPackage xlPackage = new ExcelPackage(FI))
                {
                    ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("BEFTN");
                    int StartRow = 1;

                    //Adding Title Row
                    worksheet.Cells[StartRow, 1].Value = "Reference No";
                    worksheet.Cells[StartRow, 2].Value = "Remitter CBS ID/Customer No";
                    worksheet.Cells[StartRow, 3].Value = "Remitter Name";
                    worksheet.Cells[StartRow, 4].Value = "Remitter A/C No";
                    worksheet.Cells[StartRow, 5].Value = "Remitter A/C Type";
                    worksheet.Cells[StartRow, 6].Value = "Beneficiary Name";
                    worksheet.Cells[StartRow, 7].Value = "Beneficiary A/C No";
                    worksheet.Cells[StartRow, 8].Value = "Beneficiary A/C Type";
                    worksheet.Cells[StartRow, 9].Value = "Beneficiary Routing No";
                    worksheet.Cells[StartRow, 10].Value = "Currency Code";
                    worksheet.Cells[StartRow, 11].Value = "Amount";
                    worksheet.Cells[StartRow, 12].Value = "Payment Description";

                    worksheet.Column(1).Width = 15;
                    worksheet.Column(2).Width = 30;
                    worksheet.Column(3).Width = 30;
                    worksheet.Column(4).Width = 20;
                    worksheet.Column(5).Width = 20;
                    worksheet.Column(6).Width = 30;
                    worksheet.Column(7).Width = 20;
                    worksheet.Column(8).Width = 20;
                    worksheet.Column(9).Width = 22;
                    worksheet.Column(10).Width = 15;
                    worksheet.Column(11).Width = 15;
                    worksheet.Column(12).Width = 20;



                    for (int r = 0; r < DV.Table.Rows.Count; r++)
                    {
                        int R = StartRow + r + 1;

                        worksheet.Cells[R, 1].Value = DV.Table.Rows[r]["Reference"].ToString();

                        if (DV.Table.Rows[r]["CBS_ID"] != DBNull.Value)
                            worksheet.Cells[R, 2].Value = DV.Table.Rows[r]["CBS_ID"].ToString();

                        if (DV.Table.Rows[r]["ExHouseCode"] != DBNull.Value)
                            worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["ExHouseCode"].ToString();

                        if (DV.Table.Rows[r]["RemitterAccount"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 4].Style.Numberformat.Format = "@";
                            worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["ExHouseAccNo"];
                        }

                        if (DV.Table.Rows[r]["RemitterAccType"] != DBNull.Value)
                            worksheet.Cells[R, 5].Value = DV.Table.Rows[r]["RemitterAccType"].ToString();

                        if (DV.Table.Rows[r]["BeneficiaryName"] != DBNull.Value)
                            worksheet.Cells[R, 6].Value = DV.Table.Rows[r]["BeneficiaryName"].ToString();

                        if (DV.Table.Rows[r]["Account"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 7].Style.Numberformat.Format = "@";
                            worksheet.Cells[R, 7].Value = DV.Table.Rows[r]["Account"].ToString();
                        }

                        if (DV.Table.Rows[r]["AccountType"] != DBNull.Value)
                            worksheet.Cells[R, 8].Value = DV.Table.Rows[r]["AccountType"].ToString();

                        if (DV.Table.Rows[r]["RoutingNumber"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 9].Style.Numberformat.Format = "@";
                            worksheet.Cells[R, 9].Value = string.Format("{0}", DV.Table.Rows[r]["RoutingNumber"]);
                        }

                        if (DV.Table.Rows[r]["Currency"] != DBNull.Value)
                            worksheet.Cells[R, 10].Value = DV.Table.Rows[r]["Currency"].ToString();

                        if (DV.Table.Rows[r]["Amount"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 11].Value = DV.Table.Rows[r]["Amount"];
                            worksheet.Cells[R, 11].Style.Numberformat.Format = "#,##0.00";
                        }

                        worksheet.Cells[R, 12].Value = DV.Table.Rows[r]["PaymentDescription"].ToString();

                    }

                    worksheet.Cells["A1:L1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["A1:A"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["B1:B"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["D1:D"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["E1:E"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["G1:G"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["H1:H"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["I1:I"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["J1:J"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["L1:L"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["A1:L1"].Style.Font.Bold = true;



                    //Adding Properties
                    xlPackage.Workbook.Properties.Title = "BEFTN";
                    xlPackage.Workbook.Properties.Author = string.Format("{0}", Session["EMPNAME"]);
                    xlPackage.Workbook.Properties.Company = "Trust Bank Limited";
                    xlPackage.Workbook.Properties.LastModifiedBy = string.Format("{0}", Session["EMPNAME"]);

                    xlPackage.Save();
                }


                //Reading File Content
                byte[] content = File.ReadAllBytes(FileName);
                File.Delete(FileName);

                string ExportFileName = string.Format("EFT-B{0}-{1:ddMMyyyy}-{2}.xlsx",
                    Batch,
                    DateTime.Now.Date,
                    BEFTN_Code);

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
        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total Paid Marked: <b>{0:N0}</b>", e.AffectedRows);
        }
        protected void SqlDataSourceCanceled_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatusUnpaid.Text = string.Format("Total Unpaid Marked: <b>{0:N0}</b>", e.AffectedRows);
            PanelUnpaid.Visible = e.AffectedRows > 0;
        }
    }
}