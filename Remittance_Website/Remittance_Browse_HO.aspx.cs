using System;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OfficeOpenXml;
using System.Data;

namespace Remittance
{
    public partial class Remittance_Browse_HO : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");
            if (TrustControl1.getUserRoles() == "")
            {
                Response.End();
            }

            if (Session["BRANCHID"].ToString() == "1" 
                && TrustControl1.isRole("ADMIN"))
            {
                foreach (ListItem ii in cboStatus.Items)
                {
                    if (ii.Value == "CANCEL")
                        ii.Enabled = true;
                    if (ii.Value == "ALL")
                        ii.Enabled = true;
                }
            }

            GridView1.Visible = IsPostBack;

            if (Session["BRANCHID"].ToString() != "1")
            {
                //GridView1.Columns[7].Visible = false;
                cboRoutingBank.Enabled = false;
                cboPub.Enabled = false;
                //lblRoutingBank.Visible = false;
            }
            this.Title = "Browse Remittance HO";

            //if (Cache["Remittance_Browse_Cache_Key"] == null) Cache["Remittance_Browse_Cache_Key"] = DateTime.Now;
        }

        protected void cboBranch_DataBound(object sender, EventArgs e)
        {
            foreach (ListItem i in cboBranch.Items)
                i.Selected = false;


            if (Session["BRANCHID"].ToString() != "1")
            {
                foreach (ListItem ii in cboBranch.Items)
                {
                    //if (ii.Value == Session["BRANCHID"].ToString())
                    //    ii.Selected = true;

                    if (ii.Value == "")
                        ii.Enabled = false;

                    if (ii.Value == "1")
                        ii.Enabled = false;

                    if (ii.Value == "-1")
                        ii.Enabled = false;

                    if (ii.Value == "-2")
                        ii.Enabled = false;

                    if (!IsPostBack && ii.Value == "-5")
                    {
                        ii.Selected = true;
                        GridView1.Visible = false;
                        cmdExport.Visible = false;
                    }
                }
                //cboBranch.Enabled = false;
                cboStatus.Enabled = false;
            }
            else
            {
                //foreach (ListItem ii in cboBranch.Items)
                //{
                //    if (ii.Value == "-5")
                //        ii.Enabled = false;
                //}   
            }
        }
        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total: <b>{0:N0}</b>", e.AffectedRows);
            cmdExport.Visible = (e.AffectedRows > 0);
            //&& Session["BRANCHID"].ToString() == "1"
            //     );
            //cmdExportBeftn.Visible = e.AffectedRows > 0;
            //cmdExportBeftn.Enabled = TrustControl1.isRole("BEFTN_EXPORT");
        }
        protected void cboPaid_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.EditIndex = -1;
            GridView1.DataBind();
        }
        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {

        }
        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            if (Session["BRANCHID"].ToString() != "1")
            {
                cboRoutingBank.Enabled = false;
                GridView1.Columns[8].Visible = false;
            }

            //try
            {
                //DataSet ds = (DataSet)GridView1.DataSource;
                //lblStatus.Text = string.Format("Total: <b>{0:N0}</b>", ds.Tables[0].Rows.Count);
            }
            //catch (Exception) { }
        }
        protected void cboBranch_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.EditIndex = -1;
            GridView1.DataBind();
        }
        protected void txtFilter_TextChanged(object sender, EventArgs e)
        {
            GridView1.EditIndex = -1;
            GridView1.DataBind();
        }
        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {

        }
        protected void GridView1_RowUpdated(object sender, GridViewUpdatedEventArgs e)
        {
            //if (hidRoutingMsg.Value != "")
            //{
            //    e.KeepInEditMode = true;
            //    TrustControl1.ClientMsg(hidRoutingMsg.Value);
            //}
        }
        protected void SqlDataSource1_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            //string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            //hidRoutingMsg.Value = Msg;
        }
        protected void cmdExport_Click(object sender, EventArgs e)
        {
            try
            {
                string FilePath = Server.MapPath("~/Upload");
                string FileName = Path.Combine(FilePath, Session.SessionID + ".xlsx");
                if (File.Exists(FileName)) File.Delete(FileName);
                FileInfo FI = new FileInfo(FileName);
                using (ExcelPackage xlPackage = new ExcelPackage(FI))
                {
                    ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("Remittance");
                    int StartRow = 1;

                    //Adding Title Row
                    worksheet.Cells[StartRow, 1].Value = "SL";
                    worksheet.Cells[StartRow, 2].Value = "Value Date";
                    worksheet.Cells[StartRow, 3].Value = "Ex. Co.";
                    worksheet.Cells[StartRow, 4].Value = "RID";
                    worksheet.Cells[StartRow, 5].Value = "Beneficiary";
                    worksheet.Cells[StartRow, 6].Value = "Bank";
                    worksheet.Cells[StartRow, 7].Value = "Branch";
                    worksheet.Cells[StartRow, 8].Value = "A/C No";
                    worksheet.Cells[StartRow, 9].Value = "Routing Code";
                    worksheet.Cells[StartRow, 10].Value = "Amount";
                    worksheet.Cells[StartRow, 11].Value = "Currency";
                    worksheet.Cells[StartRow, 12].Value = "Ref Order Receipt";

                    worksheet.Column(1).Width = 6;
                    worksheet.Column(2).Width = 12;
                    worksheet.Column(3).Width = 25;
                    worksheet.Column(4).Width = 8;
                    worksheet.Column(5).Width = 30;
                    worksheet.Column(6).Width = 30;
                    worksheet.Column(7).Width = 30;
                    worksheet.Column(8).Width = 20;
                    worksheet.Column(9).Width = 15;
                    worksheet.Column(10).Width = 15;
                    worksheet.Column(11).Width = 10;
                    worksheet.Column(12).Width = 15;


                    DataView DV = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);
                    for (int r = 0; r < DV.Table.Rows.Count; r++)
                    {
                        int R = StartRow + r + 1;

                        worksheet.Cells[R, 1].Value = r + 1;

                        if (DV.Table.Rows[r]["ValueDate"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 2].Value = ((DateTime)DV.Table.Rows[r]["ValueDate"]).ToOADate();
                            worksheet.Cells[R, 2].Style.Numberformat.Format = "MM/dd/yyyy";
                        }


                        if (DV.Table.Rows[r]["ExHouseName"] != DBNull.Value)
                            worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["ExHouseName"].ToString();

                        if (DV.Table.Rows[r]["ID"] != DBNull.Value)
                            worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["ID"];

                        if (DV.Table.Rows[r]["BeneficiaryName"] != DBNull.Value)
                            worksheet.Cells[R, 5].Value = DV.Table.Rows[r]["BeneficiaryName"].ToString();

                        if (DV.Table.Rows[r]["BankName"] != DBNull.Value)
                            worksheet.Cells[R, 6].Value = DV.Table.Rows[r]["BankName"].ToString();

                        if (DV.Table.Rows[r]["BranchName"] != DBNull.Value)
                            worksheet.Cells[R, 7].Value = DV.Table.Rows[r]["BranchName"].ToString();

                        if (DV.Table.Rows[r]["Account"] != DBNull.Value)
                            worksheet.Cells[R, 8].Value = DV.Table.Rows[r]["Account"].ToString();

                        if (DV.Table.Rows[r]["RoutingNumber"] != DBNull.Value)
                            worksheet.Cells[R, 9].Value = DV.Table.Rows[r]["RoutingNumber"].ToString();

                        if (DV.Table.Rows[r]["Amount"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 10].Value = DV.Table.Rows[r]["Amount"];
                            worksheet.Cells[R, 10].Style.Numberformat.Format = "#,##0.00";
                        }

                        if (DV.Table.Rows[r]["Currency"] != DBNull.Value)
                            worksheet.Cells[R, 11].Value = DV.Table.Rows[r]["Currency"].ToString();

                        if (DV.Table.Rows[r]["RefOrderReceipt"] != DBNull.Value)
                            worksheet.Cells[R, 12].Value = DV.Table.Rows[r]["RefOrderReceipt"].ToString();

                    }

                    worksheet.Cells["A1:L1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["A1:A"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["B1:B"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["D1:D"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["I1:I"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["K1:K"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["A1:L1"].Style.Font.Bold = true;



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
                Response.AddHeader("Content-Disposition", "attachment;filename=" + "Remittance.xlsx");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.BinaryWrite(content);
                Response.End();
            }
            catch (Exception ex)
            {
                lblStatus.Text = ex.Message;
            }
        }
        protected void cboStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.EditIndex = -1;
        }
        protected void cboPub_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.EditIndex = -1;
        }
        protected void cmdExportBeftn_Click(object sender, EventArgs e)
        {

        }
        protected void cboPaymentMethod_DataBound(object sender, EventArgs e)
        {
            for (int i = 0; i < cboPaymentMethod.Items.Count; i++)
            {
                if (i > 1)
                {
                    cboPaymentMethod.Items[i].Attributes.Add("title", cboPaymentMethod.Items[i].Text);
                    cboPaymentMethod.Items[i].Text = cboPaymentMethod.Items[i].Value;
                }
            }
        }

        protected void cmdFilter_Click(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }

        protected void cboPaymentMethod_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }

        protected void dboTop_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }

        protected void cboRoutingBank_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }

        protected void cboRoutingBank_DataBound(object sender, EventArgs e)
        {
            foreach (ListItem i in cboRoutingBank.Items)
                i.Selected = false;

            if (Session["BRANCHID"].ToString() != "1")
            {
                foreach (ListItem ii in cboRoutingBank.Items)
                {
                    if (ii.Value != "-1") ii.Enabled = false;
                }
            }
        }
    }
}