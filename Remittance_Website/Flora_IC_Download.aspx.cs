using System;
using System.Web;
using System.Web.UI;
using System.IO;
using System.Data;
using System.Text;

namespace Remittance
{
    public partial class Flora_IC_Download : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");
            if (TrustControl1.getUserRoles() == "")
            {
                Response.End();
            }

            lblTitle.Text = string.Format("Flora IC Export Batch: {0}", Request.QueryString["batch"]);
            this.Title = string.Format("IC Batch # {0}", Request.QueryString["batch"]);


            if (string.Format("{0}", Request.QueryString["mode"]) == "txt")
            {
                //Download
                if (!Directory.Exists(Server.MapPath("Upload")))
                {
                    Directory.CreateDirectory(Server.MapPath("Upload"));
                }

                ExportFloraTxt();
                Response.End();

            }
        }

        private void ExportFloraTxt()
        {
            string Batch = string.Format("{0}", Request.QueryString["batch"]);
            if (Batch == string.Empty) Response.End();
            try
            {
                DataView DV2 = (DataView)SqlDataSource2.Select(DataSourceSelectArguments.Empty);
                DateTime SentDT = (DateTime)DV2.Table.Rows[0]["DT"];
                string BranchID = DV2.Table.Rows[0]["BranchID"].ToString();
                BranchID = BranchID.PadLeft(4, '0');

                DataView DV = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);


                string FilePath = Server.MapPath("~/Upload");
                string FileName = Path.Combine(FilePath, Session.SessionID + "_IC_" + Batch + ".txt");
                if (File.Exists(FileName)) File.Delete(FileName);
                FileInfo FI = new FileInfo(FileName);



                StringBuilder sb = new StringBuilder();
                for (int r = 0; r < DV.Table.Rows.Count; r++)
                {
                    string Accountno = string.Format("{0}", DV.Table.Rows[r]["Accountno"]);
                    double Amount_tk = double.Parse(DV.Table.Rows[r]["Amount_tk"].ToString());
                    string Dr_Cr = string.Format("{0}", DV.Table.Rows[r]["Dr_Cr"]);
                    string Trn_br_code = string.Format("{0}", DV.Table.Rows[r]["Trn_br_code"]);
                    string Acbranch_code = string.Format("{0}", DV.Table.Rows[r]["Acbranch_code"]);
                    string Remark = string.Format("{0}", DV.Table.Rows[r]["Remark"]);

                    string AmountString = (string.Format("{0:N2}", Amount_tk)).Replace(",", "");
                    string Line = string.Format("{0},{1},{2},{3},{4},{5}"
                        , Accountno
                        , AmountString
                        , Dr_Cr
                        , Trn_br_code
                        , Acbranch_code
                        , Remark);
                    sb.AppendLine(Line);
                }

                File.AppendAllText(FileName, "Accountno,Amount_tk,Dr_Cr,Trn_br_code,Acbranch_code,Remark" + Environment.NewLine);
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
                //Response.Write("Error: " + ex.Message);
            }
        }

        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            for (int r = 0; r < GridView1.Rows.Count; r++)
            {
                if (GridView1.Rows[r].Cells[2].Text == "DR")
                    GridView1.Rows[r].ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}