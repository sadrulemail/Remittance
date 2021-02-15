using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OfficeOpenXml;
using System.Data;
using System.Text;

namespace Remittance
{
    public partial class Flora_Download : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            TrustControl1.getUserRoles();

            if (TrustControl1.isRole("FLORA_EXPORT") || TrustControl1.isRole("ADMIN"))
            {
                string Format = string.Format("{0}", Request.QueryString["format"]).ToUpper();
                if (Format == "TXT")
                    ExportFloraTxt();
                else if (Format == "XLSX")
                    ExportXlsx();
                else if (Format == "VIEW")
                {
                    lblTitle.Text = string.Format("Flora Export Batch # {0}", Request.QueryString["batch"]);
                    this.Title = string.Format("FLORA # {0}", Request.QueryString["batch"]);
                    GridView1.Visible = true;
                    //lblStatus.Visible = true;
                }
            }

            //TrustControl1.LoadEmpToSession(false);

            //if (TrustControl1.isRole("FLORA_EXPORT") || TrustControl1.isRole("ADMIN"))
            //{

            //}

            //this.Title = string.Format("FLORA # {0}", Request.QueryString["batch"]);
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
                DataView DV = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);

                string FilePath = Server.MapPath("~/Upload");
                string FileName = Path.Combine(FilePath, Session.SessionID + "_Flora_" + Batch + ".xlsx");
                if (File.Exists(FileName)) File.Delete(FileName);
                FileInfo FI = new FileInfo(FileName);
                using (ExcelPackage xlPackage = new ExcelPackage(FI))
                {
                    ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("FLORA");
                    int StartRow = 1;

                    //Adding Title Row
                    worksheet.Cells[StartRow, 1].Value = "RID";
                    worksheet.Cells[StartRow, 2].Value = "Ex-House";
                    worksheet.Cells[StartRow, 3].Value = "Beneficiary Name";
                    worksheet.Cells[StartRow, 4].Value = "Account";
                    worksheet.Cells[StartRow, 5].Value = "Amount";
                    worksheet.Cells[StartRow, 6].Value = "Currency";
                    worksheet.Cells[StartRow, 7].Value = "RefOrderReceipt";

                    worksheet.Column(1).Width = 10;
                    worksheet.Column(2).Width = 17;
                    worksheet.Column(3).Width = 45;
                    worksheet.Column(4).Width = 20;
                    worksheet.Column(5).Width = 15;
                    worksheet.Column(6).Width = 10;
                    worksheet.Column(7).Width = 30;

                    for (int r = 0; r < DV.Table.Rows.Count; r++)
                    {
                        int R = StartRow + r + 1;

                        worksheet.Cells[R, 1].Value = DV.Table.Rows[r]["ID"];
                        worksheet.Cells[R, 2].Value = DV.Table.Rows[r]["ExHouseCode"].ToString();
                        worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["BeneficiaryName"];
                        worksheet.Cells[R, 5].Value = DV.Table.Rows[r]["Amount"];
                        worksheet.Cells[R, 5].Style.Numberformat.Format = "#,##0.00";
                        worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["Account"].ToString();
                        worksheet.Cells[R, 6].Value = DV.Table.Rows[r]["Currency"].ToString();
                        worksheet.Cells[R, 7].Value = DV.Table.Rows[r]["RefOrderReceipt"].ToString();
                    }


                    worksheet.Cells["A1:A"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["F1:G"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["D1:D"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["A1:G1"].Style.Font.Bold = true;



                    //Adding Properties
                    xlPackage.Workbook.Properties.Title = "Flora Export";
                    xlPackage.Workbook.Properties.Author = string.Format("{0}", Session["EMPNAME"]);
                    xlPackage.Workbook.Properties.Company = "Trust Bank Limited";
                    xlPackage.Workbook.Properties.LastModifiedBy = string.Format("{0}", Session["EMPNAME"]);

                    xlPackage.Save();
                }


                //Reading File Content
                byte[] content = File.ReadAllBytes(FileName);
                File.Delete(FileName);

                string ExportFileName = string.Format("Flora_Export_{0}.xlsx",
                    Batch);

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
            catch (Exception ex)
            {
                Response.Write("Error: " + ex.Message);
            }
        }

        private void ExportFloraTxt()
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
                DateTime SentDT = (DateTime)DV2.Table.Rows[0]["DT"];
                string AccountNo = DV2.Table.Rows[0]["AccountNo"].ToString();
                string BranchID = DV2.Table.Rows[0]["BranchID"].ToString();
                BranchID = BranchID.PadLeft(4, '0');
                double TotalAmount = 0;

                DataView DV = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);


                string FilePath = Server.MapPath("~/Upload");
                string FileName = Path.Combine(FilePath, Session.SessionID + "_" + Batch + ".txt");
                if (File.Exists(FileName)) File.Delete(FileName);
                FileInfo FI = new FileInfo(FileName);



                StringBuilder sb = new StringBuilder();
                for (int r = 0; r < DV.Table.Rows.Count; r++)
                {
                    string Account = string.Format("{0}", DV.Table.Rows[r]["Account"]);
                    double Amount = double.Parse(DV.Table.Rows[r]["Amount"].ToString());

                    string AmountString = (string.Format("{0:N2}", Amount)).Replace(",", "");
                    string Line = string.Format("{0},{1},CR,{2}"
                        , Account
                        , AmountString
                        , BranchID);
                    sb.AppendLine(Line);
                    TotalAmount += Amount;
                }

                string TotalAmountString = (string.Format("{0:N2}", TotalAmount)).Replace(",", "");
                File.AppendAllText(FileName, "Accountno,Amount_tk,Dr_Cr,Trn_br_code" + Environment.NewLine);
                File.AppendAllText(FileName, (string.Format("{0},{1},DR,{2}", AccountNo, TotalAmountString, BranchID) + Environment.NewLine));
                File.AppendAllText(FileName, sb.ToString());

                //Reading File Content
                byte[] content = File.ReadAllBytes(FileName);
                File.Delete(FileName);

                string ExportFileName = string.Format("OFS{0:yyyyMMddhhmm}.txt",
                    SentDT);

                //Downloading File
                Response.Clear();
                Response.ClearContent();
                Response.ClearHeaders();
                Response.ContentType = "text/plain";
                Response.AddHeader("Content-Disposition", "attachment;filename=" + ExportFileName);
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.BinaryWrite(content);
                Response.End();
            }
            catch (Exception)
            {
                //  Response.Write("Error: " + ex.Message);
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