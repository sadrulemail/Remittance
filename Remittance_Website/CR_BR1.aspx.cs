using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data;

namespace Remittance
{
    public partial class CR_BR1_Form : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {

                DataSet1.sp_Remittance_SelectRow oRow = (DataSet1.sp_Remittance_SelectRow)((DataView)(ObjectDataSource1.Select())).Table.Rows[0];

                CrystalReportSource1.Report.Parameters[0].DefaultValue = string.Format("Ref: {0}", Request.QueryString["ref"]);
                CrystalReportSource1.Report.Parameters[1].DefaultValue = string.Format("{0}", oRow.BranchName);
                CrystalReportSource1.Report.Parameters[2].DefaultValue = string.Format("{0}", oRow.BankName);
                CrystalReportSource1.Report.Parameters[3].DefaultValue = string.Format("{0}", oRow.District);
                CrystalReportSource1.Report.Parameters[4].DefaultValue = string.Format("{0}", oRow.Instrument);
                if (!oRow.IsInstrumentDateNull())
                    CrystalReportSource1.Report.Parameters[5].DefaultValue = string.Format("{0:MM/dd/yyyy}", oRow.InstrumentDate);
                CrystalReportSource1.Report.Parameters[6].DefaultValue = oRow.Amount.ToString();
                CrystalReportSource1.Report.Parameters[7].DefaultValue = string.Format("{0}", oRow.BeneficiaryName);
                CrystalReportSource1.Report.Parameters[8].DefaultValue = string.Format("{0}", oRow.Account);
                CrystalReportSource1.Report.Parameters[9].DefaultValue = Session["EMPNAME"].ToString();
                CrystalReportSource1.Report.Parameters[10].DefaultValue = Session["DESIGNATION"].ToString();
                CrystalReportSource1.Report.Parameters[11].DefaultValue = Session["BRANCHNAME"].ToString();
                CrystalReportSource1.Report.Parameters[12].DefaultValue = oRow.Currency;
            }
            catch (Exception) { }
        }
        protected void CrystalReportViewer1_AfterRender(object source, CrystalDecisions.Web.HtmlReportRender.AfterRenderEvent e)
        {
            try
            {
                SqlDataSourcePrintLog_Insert.Select(DataSourceSelectArguments.Empty);
                ExportToPdf();
            }
            catch (Exception) { }
        }

        private void ExportToPdf()
        {
            try
            {
                //ObjectDataSource1.DataBind();
                //CrystalReportSource1.DataBind();
                //CrystalReportSource1.ReportDocument.Refresh();


                //Output to PDF
                using (Stream oStream = CrystalReportSource1.ReportDocument.ExportToStream(
                    CrystalDecisions.Shared.ExportFormatType.PortableDocFormat))
                {
                    using (MemoryStream ms = new MemoryStream())
                    {
                        oStream.CopyTo(ms);

                        Response.Clear();
                        Response.ClearContent();
                        Response.ClearHeaders();
                        Response.Buffer = true;
                        Response.ContentType = "application/pdf";
                        Response.AddHeader("Content-Disposition", string.Format("inline;filename=Report_{0}.pdf", Request.QueryString["id"]));
                        Response.Cache.SetCacheability(HttpCacheability.NoCache);
                        Response.BinaryWrite(ms.ToArray());
                        Response.End();
                    }
                }
            }
            catch (Exception) { }
        }
    }
}