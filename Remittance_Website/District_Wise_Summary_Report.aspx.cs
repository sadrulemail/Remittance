using System;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using OfficeOpenXml;


public partial class District_Wise_Summary_Report : System.Web.UI.Page
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

        this.Title = "District Wise Summary Report";
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
            btn_xlsx.Visible = false;
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
                ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("District Wise Summary Report");
                int StartRow = 1;

                //Adding Title Row
                worksheet.Column(1).Width = 8;
                worksheet.Column(2).Width = 20;
                worksheet.Column(3).Width = 10;
                worksheet.Column(4).Width = 15;
                worksheet.Column(5).Width = 15;

                //Adding Title Row
                worksheet.Cells[StartRow, 1].Value = "SL";
                worksheet.Cells[StartRow, 2].Value = "District";
                worksheet.Cells[StartRow, 3].Value = "Currenct";
                worksheet.Cells[StartRow, 4].Value = "AMOUNT FCY";
                worksheet.Cells[StartRow, 5].Value = "AMOUNT";

                DataView DV = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);
                int R = 0;
                for (int r = 0; r < DV.Table.Rows.Count; r++)
                {
                    R = StartRow + r + 1;
                    if (DV.Table.Rows[r]["SL"] != DBNull.Value)
                        worksheet.Cells[R, 1].Value = DV.Table.Rows[r]["SL"].ToString();
                    if (DV.Table.Rows[r]["RIT_Dist_Name"] != DBNull.Value)
                        worksheet.Cells[R, 2].Value = DV.Table.Rows[r]["RIT_Dist_Name"].ToString();
                    if (DV.Table.Rows[r]["CoverFundCurrency"] != DBNull.Value)
                        worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["CoverFundCurrency"].ToString();
                    if (DV.Table.Rows[r]["Amount_FCY"] != DBNull.Value)
                        worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["Amount_FCY"].ToString();
                    if (DV.Table.Rows[r]["Amount"] != DBNull.Value)
                        worksheet.Cells[R, 5].Value = DV.Table.Rows[r]["Amount"].ToString();
                }

                //worksheet.Cells["A1:C" + R].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;


                //Adding Properties
                xlPackage.Workbook.Properties.Title = "District Wise Summary Report";
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
            Response.AddHeader("Content-Disposition", "attachment;filename=" + "District_Wise_Summary_Report" + ".xlsx");
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
        try
        {
            double Total = 0;
            for (int i = 0; i < GridView1.Rows.Count; i++)
            {
                Total += double.Parse(GridView1.Rows[i].Cells[4].Text);
            }
            //GridView1.FooterRow.Cells[2].Text = Total.ToString();

            for (int i = 0; i < GridView1.Rows.Count; i++)
            {
                Panel p1 = new Panel();
                p1.BackColor = System.Drawing.Color.White;
                p1.BorderColor = System.Drawing.Color.Gray;
                p1.BorderStyle = BorderStyle.Solid;
                p1.BorderWidth = Unit.Pixel(1);
                Panel pn = new Panel();
                double percentage = (100 * double.Parse(GridView1.Rows[i].Cells[4].Text)) / Total;
                pn.Width = Unit.Percentage(percentage);
                GridView1.Rows[i].Cells[5].ToolTip = string.Format("{0:N2}%", percentage);
                pn.BackColor = System.Drawing.Color.Gray;
                pn.Controls.Add(new LiteralControl("&nbsp;"));
                p1.Controls.Add(pn);
                pn.Style.Add("margin", "1px");
                GridView1.Rows[i].Cells[5].Controls.Add(p1);
            }
        }
        catch (Exception) { }
    }

    protected void SqlDataSource1_Inserting(object sender, SqlDataSourceCommandEventArgs e)
    {
        
    }

    protected void SqlDataSource1_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
    {
        string s = "";
        foreach (ListItem LI in cboExHouse.Items)
            if (LI.Selected)
                s += LI.Value + ",";
        hidExHouses.Value = s;

        SqlDataSource1.SelectParameters["ExHouses"].DefaultValue = s;
    }
}