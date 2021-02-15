using System;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using OfficeOpenXml;
using System.Text;
using InfoSoftGlobal;

namespace Remittance
{
    public partial class Country_Wise_Summary_Report : System.Web.UI.Page
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
                GridView1.DataBind();
                
            }
            else
            {
                txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.AddDays(-1));
                txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.AddDays(-1));
                //Cache["RITCacheKey"] = DateTime.Now;
                
            }
            this.Title = "Country Wise Summary Report";
        }
        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total: <b>{0:N0}</b>", e.AffectedRows);
            if (e.AffectedRows > 0)
                btn_xlsx.Visible = true;
            else
                btn_xlsx.Visible = false;
        }
        protected void Timer1_Tick(object sender, EventArgs e)
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
                    ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("Country Wise Summary Report");
                    int StartRow = 1;

                    //Adding Title Row
                    worksheet.Column(1).Width = 8;
                    worksheet.Column(2).Width = 20;
                    worksheet.Column(3).Width = 10;
                    worksheet.Column(4).Width = 15;


                    //Adding Title Row
                    worksheet.Cells[StartRow, 1].Value = "SL";
                    worksheet.Cells[StartRow, 2].Value = "Country";
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
                        if (DV.Table.Rows[r]["CoverFund_CountryName"] != DBNull.Value)
                            worksheet.Cells[R, 2].Value = DV.Table.Rows[r]["CoverFund_CountryName"].ToString();
                        if (DV.Table.Rows[r]["CoverFundCurrency"] != DBNull.Value)
                            worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["CoverFundCurrency"].ToString();
                        if (DV.Table.Rows[r]["Amount_FCY"] != DBNull.Value)
                            worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["Amount_FCY"].ToString();
                        if (DV.Table.Rows[r]["Amount"] != DBNull.Value)
                            worksheet.Cells[R, 5].Value = DV.Table.Rows[r]["Amount"].ToString();
                    }

                    //worksheet.Cells["A1:C" + R].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;


                    //Adding Properties
                    xlPackage.Workbook.Properties.Title = "Country Wise Summary Report";
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
                Response.AddHeader("Content-Disposition", "attachment;filename=" + "Country_Wise_Summary_Report" + ".xlsx");
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
            LoadChart();
        }

        protected void LoadChart()
        {
            DataView dv = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);
            object[,] arrData = new object[dv.Table.Rows.Count, 4];

            for (int r = 0; r < dv.Table.Rows.Count; r++)
            {
                arrData[r, 0] = string.Format("{0}", dv.Table.Rows[r]["CoverFund_CountryName"]);
                arrData[r, 1] = string.Format("{0}", dv.Table.Rows[r]["CoverFundCurrency"]);
                //arrData[r, 2] = string.Format("{0:h:mm tt} ({1})", Entry, dv.Table.Rows[r]["CoverFundCurrency"]).Replace(".", "").ToUpper();
                arrData[r, 2] = string.Format("{0:N2}", dv.Table.Rows[r]["Amount"]).Replace(",", "").ToUpper();
                arrData[r, 3] = string.Format("{0:N2}", dv.Table.Rows[r]["Amount_FCY"]).Replace(",", "").ToUpper();
            }

            StringBuilder xmlData = new StringBuilder();
            xmlData.Append("<chart caption='Country wise Summary Report' numberPrefix='' setAdaptiveYMin='1' palette='1' >");

            for (int i = 0; i < arrData.GetLength(0); i++)
            {
                xmlData.AppendFormat("<set label='{0} ({1})' "
                    + "displayValue='{2:N0} Tk'"
                    + " tooltext='{0} {3:N0} {1}'"
                    + " value='{2}' />"
                    , arrData[i, 0]
                    , arrData[i, 1]
                    , double.Parse(arrData[i, 2].ToString())
                    , double.Parse(arrData[i, 3].ToString())
                    );
            }

            //xmlData.Append("<styles><definition><style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' /></definition></styles>");
            xmlData.Append("</chart>");

            PanelChart.Controls.Clear();
            string outPut = FusionCharts.RenderChart("Column2D", "", xmlData.ToString(), "Chart1", "800px", "400px", false, true);
            PanelChart.Controls.Add(new LiteralControl(outPut));
            FusionCharts.SetRenderer("javascript");
        }

        protected void SqlDataSource1_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {
            e.Command.CommandTimeout = 0;
        }

        protected void cmdFilter_Click(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }
    }
}