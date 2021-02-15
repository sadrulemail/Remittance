using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OfficeOpenXml;
using System.Data;
using System.Xml;
using System.Text;

namespace Remittance
{
    public partial class RiaSummaryReport : System.Web.UI.Page
    {
        int TotalCount = 0;
        int TotalRows = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");
            TrustControl1.getUserRoles();

            if (IsPostBack)
            {
                //GridView1.DataBind();
            }
            else
            {
                txtDateFrom.Text = string.Format("{0:dd/MM/yyy}", DateTime.Now.Date);
               
            }

            this.Title = "Ria Summary Report";
        }
        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
         
            //    cmdDownload.Visible = true;
            //else
            //    cmdDownload.Visible = false;

        }
        public string getBgColor(object DT, string Color)
        {
            return Color;
        }
        
      

        protected void btndailyReport_Click(object sender, EventArgs e)
        {
            XmlDocument SOAPReqBody = new XmlDocument();
            RiaFxWebService.RiaFxGlobalService fxService = new RiaFxWebService.RiaFxGlobalService();
            string dailyReport = fxService.Ria_GetDailyOrdersReport(Session["BRANCHID"].ToString().PadLeft(4, '0'), Session["BRANCHNAME"].ToString(),DateTime.Parse(txtDateFrom.Text).ToString("yyyyMMdd"), Session["EMPID"].ToString(), getValueOfKey("Ria_KeyCode"));
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            //     SOAPReqBody.LoadXml(@" <?xml version=""1.0"" encoding=""UTF-8""?>
            //     <RequiredField>" + RequiredFieldXml +
            //@"</RequiredField>");
            sb.AppendLine("<DailyReport>");
            sb.AppendLine(dailyReport);
            sb.AppendLine("</DailyReport>");
            SOAPReqBody.LoadXml(sb.ToString());
            XmlReader xmlReader = new XmlNodeReader(SOAPReqBody);
            DataSet ds = new DataSet();
            ds.ReadXml(xmlReader);
            DataTable dtOrders = ds.Tables["Orders"];
            //if (dtRequired != null)
            gdvDailyReport.DataSource = dtOrders;
            gdvDailyReport.DataBind();
            if(dtOrders != null)
            LabelDailyReport.Text = string.Format("Total Orders: <b>{0:N0}</b>", dtOrders.Rows.Count.ToString());
            else
                LabelDailyReport.Text = "";
        }

        protected void btnSummaryReport_Click(object sender, EventArgs e)
        {
            XmlDocument SOAPReqBody = new XmlDocument();
            RiaFxWebService.RiaFxGlobalService fxService = new RiaFxWebService.RiaFxGlobalService();
            string dailyReport = fxService.Ria_GetDailyOrdersSummaryReport(Session["BRANCHID"].ToString().PadLeft(4, '0'), Session["BRANCHNAME"].ToString(), DateTime.Parse(txtDateFrom.Text).ToString("yyyyMMdd"), Session["EMPID"].ToString(), getValueOfKey("Ria_KeyCode"));
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            //     SOAPReqBody.LoadXml(@" <?xml version=""1.0"" encoding=""UTF-8""?>
            //     <RequiredField>" + RequiredFieldXml +
            //@"</RequiredField>");
            sb.AppendLine("<DailyReport>");
            sb.AppendLine(dailyReport);
            sb.AppendLine("</DailyReport>");
            SOAPReqBody.LoadXml(sb.ToString());
            XmlReader xmlReader = new XmlNodeReader(SOAPReqBody);
            DataSet ds = new DataSet();
            ds.ReadXml(xmlReader);
            DataTable dtOrders = ds.Tables["Orders"];
            //if (dtRequired != null)
            gdvSummaryReport.DataSource = dtOrders;
            gdvSummaryReport.DataBind();
        }
        public string getValueOfKey(string KeyName)
        {
            try
            {
                return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
            }
            catch (Exception) { return string.Empty; }
        }

    }
}