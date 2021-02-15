using System;
using System.Web;
using System.Web.UI;
using System.IO;
using System.Data;

namespace Remittance
{
    public partial class CR_BR2_Form : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            TrustControl1.getUserRoles();
            DataView DV = (DataView)(ObjectDataSource1.Select());

            DataSet1.sp_Remittance_SelectRow oRow;
            if (DV.Table.Rows.Count < 1)
            {
                Response.Write("Remittance Not Found.");
                Response.End();
            }
            else
            {
                oRow = (DataSet1.sp_Remittance_SelectRow)(DV.Table.Rows[0]);
                if (!oRow.Paid)
                {
                    Response.Write("Remittance is Not Paid.");
                    Response.End();
                }

                CrystalReportSource1.Report.Parameters[0].DefaultValue = string.Format("Ref: {0}", Request.QueryString["ref"]);
                CrystalReportSource1.Report.Parameters[1].DefaultValue = string.Format("{0}", oRow.BranchName);
                CrystalReportSource1.Report.Parameters[2].DefaultValue = string.Format("{0}", oRow.BankName);

                if (!oRow.IsDistrictNull())
                    CrystalReportSource1.Report.Parameters[3].DefaultValue = string.Format("{0}", oRow.District);

                CrystalReportSource1.Report.Parameters[4].DefaultValue = string.Format("{0}", oRow.Instrument);

                if (!oRow.IsInstrumentDateNull())
                    CrystalReportSource1.Report.Parameters[5].DefaultValue = string.Format("{0:dd-MMM-yyyy}", oRow.InstrumentDate);

                CrystalReportSource1.Report.Parameters[6].DefaultValue = oRow.Amount.ToString();
                CrystalReportSource1.Report.Parameters[7].DefaultValue = string.Format("{0}", oRow.BeneficiaryName);

                if (!oRow.IsAccountNull())
                    CrystalReportSource1.Report.Parameters[8].DefaultValue = string.Format("{0}", oRow.Account);

                CrystalReportSource1.Report.Parameters[9].DefaultValue = Session["EMPNAME"].ToString();
                CrystalReportSource1.Report.Parameters[10].DefaultValue = string.Format("{0}", Session["DESIGNATION"]);
                CrystalReportSource1.Report.Parameters[11].DefaultValue = Session["BRANCHNAME"].ToString();

                if (!oRow.IsPaidOnNull())
                    CrystalReportSource1.Report.Parameters[12].DefaultValue = string.Format("{0:dd-MMM-yyyy}", oRow.InstrumentDate);
                if (!oRow.IsAccountNull())
                    CrystalReportSource1.Report.Parameters[13].DefaultValue = string.Format("{0}", oRow.ExHouseName);
                else
                    CrystalReportSource1.Report.Parameters[13].DefaultValue = string.Format("{0}", oRow.ExHouseCode);

                if (!oRow.IsRefOrderReceiptNull())
                    CrystalReportSource1.Report.Parameters[14].DefaultValue = string.Format("{0}", oRow.RefOrderReceipt);

                CrystalReportSource1.Report.Parameters[15].DefaultValue = string.Format("{0}", Request.QueryString["id"]);
                CrystalReportSource1.Report.Parameters[16].DefaultValue = string.Format("{0}", oRow.Currency);
                CrystalReportSource1.Report.Parameters[17].DefaultValue = string.Format("{0}", oRow.PaymentMethod);
                CrystalReportSource1.Report.Parameters[18].DefaultValue = string.Format("{0}", oRow.PaymentMethodDetails);
                CrystalReportSource1.Report.Parameters[19].DefaultValue = string.Format("{0}", oRow.RemitterName);

                //CrystalReportSource1.ReportDocument.Refresh();

                //ExportToPdf();
            }
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
            //ObjectDataSource1.DataBind();
            //CrystalReportSource1.DataBind();
            //CrystalReportSource1.ReportDocument.Refresh();
            //CrystalReportViewer1.DataBind();


            //Output to PDF
            using (Stream oStream = 
                CrystalReportSource1.ReportDocument.ExportToStream(
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
                    Response.AddHeader("Content-Disposition", string.Format("inline;filename=Remittance_{0}.pdf", Request.QueryString["id"]));
                    Response.Cache.SetCacheability(HttpCacheability.NoCache);
                    Response.BinaryWrite(ms.ToArray());
                    Response.End();
                }
            }
        }
    }
}