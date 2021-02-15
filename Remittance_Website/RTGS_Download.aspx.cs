using System;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OfficeOpenXml;
using System.Data;


public partial class RTGS_Download : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();

        if (TrustControl1.isRole("RTGS_EXPORT") || TrustControl1.isRole("ADMIN"))
        {
            if (string.Format("{0}", Request.QueryString["view"]).Length == 0)
                ExportXlsx();
            else
            {
                lblTitle.Text = string.Format("RTGS Export Batch # {0}", Request.QueryString["batch"]);
                this.Title = string.Format("RTGS # {0}", Request.QueryString["batch"]);
                GridView1.Visible = true;
                lblStatus.Visible = true;
            }
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
                ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("Sheet1");
                int StartRow = 1;

                //Adding Title Row
                worksheet.Cells["A" + StartRow].Value = "dbtrName";
                worksheet.Cells["B" + StartRow].Value = "dbtrAccountno";
                worksheet.Cells["C" + StartRow].Value = "dbtrAddress";
                worksheet.Cells["D" + StartRow].Value = "dbtrStreet";
                worksheet.Cells["E" + StartRow].Value = "dbtrTown";
                worksheet.Cells["F" + StartRow].Value = "currency";
                worksheet.Cells["G" + StartRow].Value = "amount";
                worksheet.Cells["H" + StartRow].Value = "dbtrCountry";
                worksheet.Cells["I" + StartRow].Value = "cdtrAccountno";
                worksheet.Cells["J" + StartRow].Value = "cdtrName";
                worksheet.Cells["K" + StartRow].Value = "cdtrAddress";
                worksheet.Cells["L" + StartRow].Value = "cdtrStreet";
                worksheet.Cells["M" + StartRow].Value = "cdtrTown";
                worksheet.Cells["N" + StartRow].Value = "cdtrCountry";
                worksheet.Cells["O" + StartRow].Value = "toRoutingno";
                worksheet.Cells["P" + StartRow].Value = "toSwiftCode";
                worksheet.Cells["Q" + StartRow].Value = "Remarks";
                int R = 0;

                for (int r = 0; r < DV.Table.Rows.Count; r++)
                {
                    R = StartRow + r + 1;

                    //worksheet.Cells[R, 1].Value = DV.Table.Rows[r]["Reference"].ToString();
                    worksheet.Cells["A" + R].Value = DV.Table.Rows[r]["dbtrName"].ToString();
                    worksheet.Cells["B" + R].Value = DV.Table.Rows[r]["dbtrAccountno"].ToString();
                    worksheet.Cells["C" + R].Value = DV.Table.Rows[r]["dbtrAddress"].ToString();
                    worksheet.Cells["D" + R].Value = DV.Table.Rows[r]["dbtrStreet"].ToString();
                    worksheet.Cells["E" + R].Value = DV.Table.Rows[r]["dbtrTown"].ToString();
                    worksheet.Cells["F" + R].Value = DV.Table.Rows[r]["currency"].ToString();
                    worksheet.Cells["G" + R].Value = DV.Table.Rows[r]["amount"];
                    worksheet.Cells["G" + R].Style.Numberformat.Format = "#,##0.00";
                    worksheet.Cells["H" + R].Value = DV.Table.Rows[r]["dbtrCountry"].ToString();
                    worksheet.Cells["I" + R].Value = DV.Table.Rows[r]["cdtrAccountno"].ToString();
                    worksheet.Cells["I" + R].Style.Numberformat.Format = "@";
                    worksheet.Cells["J" + R].Value = DV.Table.Rows[r]["cdtrName"].ToString();
                    worksheet.Cells["K" + R].Value = DV.Table.Rows[r]["cdtrAddress"].ToString();
                    worksheet.Cells["L" + R].Value = DV.Table.Rows[r]["cdtrStreet"].ToString();
                    worksheet.Cells["M" + R].Value = DV.Table.Rows[r]["cdtrTown"].ToString();
                    worksheet.Cells["N" + R].Value = DV.Table.Rows[r]["cdtrCountry"].ToString();
                    worksheet.Cells["O" + R].Value = DV.Table.Rows[r]["toRoutingno"].ToString();
                    worksheet.Cells["O" + R].Style.Numberformat.Format = "@";
                    worksheet.Cells["P" + R].Value = DV.Table.Rows[r]["toSwiftCode"].ToString();
                    worksheet.Cells["P" + R].Style.Numberformat.Format = "@";
                    worksheet.Cells["Q" + R].Value = DV.Table.Rows[r]["PaymentDescription"].ToString();

                    //if (DV.Table.Rows[r]["CBS_ID"] != DBNull.Value)
                    //    worksheet.Cells[R, 2].Value = DV.Table.Rows[r]["CBS_ID"].ToString();

                    //if (DV.Table.Rows[r]["ExHouseCode"] != DBNull.Value)
                    //    worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["ExHouseCode"].ToString();

                    //if (DV.Table.Rows[r]["RemitterAccount"] != DBNull.Value)
                    //{
                    //    worksheet.Cells[R, 4].Style.Numberformat.Format = "@";
                    //    worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["ExHouseAccNo"];
                    //}

                    //if (DV.Table.Rows[r]["RemitterAccType"] != DBNull.Value)
                    //    worksheet.Cells[R, 5].Value = DV.Table.Rows[r]["RemitterAccType"].ToString();

                    //if (DV.Table.Rows[r]["BeneficiaryName"] != DBNull.Value)
                    //    worksheet.Cells[R, 6].Value = DV.Table.Rows[r]["BeneficiaryName"].ToString();

                    //if (DV.Table.Rows[r]["Account"] != DBNull.Value)
                    //{
                    //    worksheet.Cells[R, 7].Style.Numberformat.Format = "@";
                    //    worksheet.Cells[R, 7].Value = DV.Table.Rows[r]["Account"].ToString();
                    //}

                    //if (DV.Table.Rows[r]["AccountType"] != DBNull.Value)
                    //    worksheet.Cells[R, 8].Value = DV.Table.Rows[r]["AccountType"].ToString();

                    //if (DV.Table.Rows[r]["RoutingNumber"] != DBNull.Value)
                    //{
                    //    worksheet.Cells[R, 9].Style.Numberformat.Format = "@";
                    //    worksheet.Cells[R, 9].Value = string.Format("{0}", DV.Table.Rows[r]["RoutingNumber"]);
                    //}

                    //if (DV.Table.Rows[r]["Currency"] != DBNull.Value)
                    //    worksheet.Cells[R, 10].Value = DV.Table.Rows[r]["Currency"].ToString();

                    //if (DV.Table.Rows[r]["Amount"] != DBNull.Value)
                    //{
                    //    worksheet.Cells[R, 11].Value = DV.Table.Rows[r]["Amount"];
                    //    worksheet.Cells[R, 11].Style.Numberformat.Format = "#,##0.00";
                    //}

                    //worksheet.Cells[R, 12].Value = DV.Table.Rows[r]["PaymentDescription"].ToString();

                }

                worksheet.Cells["A1:Q1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                //worksheet.Cells["A1:A"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                worksheet.Cells["F2:F" + R].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                worksheet.Cells["H2:H" + R].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                worksheet.Cells["N2:N" + R].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                worksheet.Cells["O2:O" + R].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                worksheet.Cells["P2:Q" + R].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                
                worksheet.Cells["A1:Z1"].Style.Font.Bold = true;

                //worksheet.Column(2).BestFit = true;
                worksheet.Cells.AutoFitColumns();

                //Adding Properties
                xlPackage.Workbook.Properties.Title = "RTGS";
                xlPackage.Workbook.Properties.Author = string.Format("{0}", Session["EMPNAME"]);
                xlPackage.Workbook.Properties.Company = "Trust Bank Limited";
                xlPackage.Workbook.Properties.LastModifiedBy = string.Format("{0}", Session["EMPNAME"]);

                xlPackage.Save();
            }


            //Reading File Content
            byte[] content = File.ReadAllBytes(FileName);
            File.Delete(FileName);

            string ExportFileName = string.Format("RTGS-{0}-{1:ddMMyyyy}-{2}.xlsx",
                Batch,
                DateTime.Now.Date,
                BEFTN_Code);

            //Downloading File
            Response.Clear();
            Response.ClearContent();
            Response.ClearHeaders();
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;filename=" + ExportFileName);
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.BinaryWrite(content);
            Response.End();
        }
        catch (Exception ex)
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
