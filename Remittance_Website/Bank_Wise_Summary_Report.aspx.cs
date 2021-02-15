using System;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OfficeOpenXml;
using System.Data;

public partial class Bank_Wise_Summary_Report : System.Web.UI.Page
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

        if (IsPostBack)
        {
            GridView1.Visible = true;
        }
        else
        {
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);
        }

        this.Title = "Bank wise Summary";
    }

    protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        lblStatus.Text = string.Format("Total: <b>{0:N0}</b>", e.AffectedRows);

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

    protected void cmdExport_Click(object sender, EventArgs e)
    {
        try
        {
            string FileName = Path.GetTempFileName();
            if (File.Exists(FileName)) File.Delete(FileName);
            FileInfo FI = new FileInfo(FileName);
            using (ExcelPackage xlPackage = new ExcelPackage(FI))
            {
                ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("Paid Grid");
                int StartRow = 1;

                //Adding Title Row
                worksheet.Cells[StartRow, 1].Value = "Bank Code";
                worksheet.Cells[StartRow, 2].Value = "Bank Name";
                worksheet.Cells[StartRow, 3].Value = "Total";
                worksheet.Cells[StartRow, 4].Value = "Amount";

                worksheet.Column(1).Width = 12;
                worksheet.Column(2).Width = 40;
                worksheet.Column(3).Width = 12;
                worksheet.Column(4).Width = 20;

                DataView DV = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);
                for (int r = 0; r < DV.Table.Rows.Count; r++)
                {
                    int R = StartRow + r + 1;
                    //worksheet.Cells[R, 1].Value = r + 1;

                    if (DV.Table.Rows[r]["Bank_Code"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 1].Value = DV.Table.Rows[r]["Bank_Code"].ToString();
                        //worksheet.Cells[R, 1].Style.Numberformat.Format = "MM/dd/yyyy";
                    }

                    if (DV.Table.Rows[r]["Bank_Name"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 2].Value = DV.Table.Rows[r]["Bank_Name"].ToString();
                        //worksheet.Cells[R, 2].Style.Numberformat.Format = "#,##0.00";
                    }

                    if (DV.Table.Rows[r]["Total"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["Total"];
                        worksheet.Cells[R, 3].Style.Numberformat.Format = "#,##0";
                    }

                    if (DV.Table.Rows[r]["TotalAmount"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["TotalAmount"];
                        worksheet.Cells[R, 4].Style.Numberformat.Format = "#,##0.00";
                    }

                }

                worksheet.Cells["A1:D1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                worksheet.Cells["A1:D1"].Style.Font.Bold = true;



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
            Response.AddHeader("Content-Disposition", "attachment;filename=" +
                "Bank_Wise_Summary.xlsx"
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

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Amount += Convert.ToDouble(DataBinder.Eval(e.Row.DataItem, "TotalAmount"));
                Total += Convert.ToDouble(DataBinder.Eval(e.Row.DataItem, "Total"));
            }

            if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells[2].Text = string.Format(TrustControl1.Bangla, "{0:N0}", Total);
                e.Row.Cells[3].Text = string.Format(TrustControl1.Bangla, "{0:N2}", Amount);
            }
        }
        catch (Exception) { }
    }

    protected void SqlDataSource2_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
    {
        e.Command.CommandTimeout = 0;
    }
}
