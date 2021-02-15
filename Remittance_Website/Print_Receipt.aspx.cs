using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data;


    public partial class Print_Receipt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            TrustControl1.getUserRoles();

            DataView DV = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty); 

            if (DV.Table.Rows.Count > 0)
            {
                if (string.Format("{0}", DV.Table.Rows[0]["PaymentMethod"]) != "IC")
                    CrystalReportSource1.Report.FileName = "Reports/Print_Receipt_Others.rpt";

                CrystalReportSource1.Report.Parameters[0].DefaultValue = string.Format("{0}", Request.QueryString["id"]);
                CrystalReportSource1.Report.Parameters[1].DefaultValue = string.Format("{0}", DV.Table.Rows[0]["PaidBranchName"]);
                CrystalReportSource1.Report.Parameters[2].DefaultValue = DV.Table.Rows[0]["Amount"].ToString();
                CrystalReportSource1.Report.Parameters[3].DefaultValue = string.Format("{0}", DV.Table.Rows[0]["Currency"]);
                CrystalReportSource1.Report.Parameters[4].DefaultValue = string.Format("{0}", DV.Table.Rows[0]["ExHouseName"]);
                CrystalReportSource1.Report.Parameters[5].DefaultValue = string.Format("{0}", DV.Table.Rows[0]["RemitterName"]);
                CrystalReportSource1.Report.Parameters[6].DefaultValue = string.Format("{0}", DV.Table.Rows[0]["BeneficiaryName"]);
                CrystalReportSource1.Report.Parameters[7].DefaultValue = string.Format("{0:dd MMM yyyy hh:mm:ss tt}", DV.Table.Rows[0]["PaidOn"]);
                CrystalReportSource1.Report.Parameters[8].DefaultValue = string.Format("{0}", DV.Table.Rows[0]["AmountInWord"]);
                CrystalReportSource1.Report.Parameters[9].DefaultValue = Session["EMPNAME"].ToString();
                CrystalReportSource1.Report.Parameters[10].DefaultValue = Session["DESIGNATION"].ToString();
                
            }
            else
            {
                Response.Clear();
                Response.Write("<h2 style='font-family:arial;margin:100px'>You have no permission to print this receipt.</h2>");
                Response.End();
            }
        }
        protected void CrystalReportViewer1_AfterRender(object source, CrystalDecisions.Web.HtmlReportRender.AfterRenderEvent e)
        {
            ExportToPdf();
        }

        private void ExportToPdf()
        {
            //CrystalReportSource1.ReportDocument.ExportToHttpResponse(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat
            //    , this.Response, true, string.Format("Remittance_Receipt_{0}", Request.QueryString["id"]));
            ////CrystalReportSource1.ReportDocument.Close();
            ////CrystalReportSource1.ReportDocument.Dispose();

            //Output to PDF
            try
            {
                using (Stream oStream = (Stream)CrystalReportSource1.ReportDocument.ExportToStream(
                        CrystalDecisions.Shared.ExportFormatType.PortableDocFormat))
                {
                    using (MemoryStream ms = new MemoryStream())
                    {
                        oStream.CopyTo(ms);
                        SqlDataSourcePrintLog_Insert.Select(DataSourceSelectArguments.Empty);
                        Response.Clear();
                        Response.ClearContent();
                        Response.ClearHeaders();
                        Response.Buffer = true;
                        Response.ContentType = "application/pdf";
                        Response.AddHeader("Content-Disposition", string.Format("inline;filename=Remittance_Receipt_{0}.pdf", Request.QueryString["id"]));
                        Response.Cache.SetCacheability(HttpCacheability.NoCache);
                        Response.BinaryWrite(ms.ToArray());
                        Response.End();
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write(ex.Message);
            }
        }

        private void Page_Unload(object sender, System.EventArgs e)
        {
            //if (CrystalReportSource1 != null)
            //{
            //    //CrystalReportSource1.Report = null;
            //    CrystalReportSource1.Dispose();
            //    CrystalReportViewer1 = null; 
            //}
        }
        protected void SqlDataSource1_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {
            e.Command.Parameters["@isAdmin"].Value = (TrustControl1.isRole("ADMIN"));
        }
    }
