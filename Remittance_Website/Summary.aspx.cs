using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OfficeOpenXml;
using System.Data;

namespace Remittance
{
    public partial class Summary : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");
            if (TrustControl1.getUserRoles() == "")
            {
                Response.End();
            }

            if (!IsPostBack)
            {
                txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
                txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
                GridView1.DataBind();
            }

            if (Session["BRANCHID"].ToString() != "1")
            {
                cboRoutingBank.Visible = false;
                lblRoutingBank.Visible = false;
                cboBranch.Enabled = false;
            }
        }

        protected void cboBranch_DataBound(object sender, EventArgs e)
        {
            foreach (ListItem i in cboBranch.Items)
                i.Selected = false;


            if (Session["BRANCHID"].ToString() != "1")
            {
                foreach (ListItem ii in cboBranch.Items)
                {
                    if (ii.Value == Session["BRANCHID"].ToString())
                        ii.Selected = true;

                    if (ii.Value == "0")
                        ii.Enabled = false;

                    if (ii.Value == "1")
                        ii.Enabled = false;

                    if (ii.Value == "-1")
                        ii.Enabled = false;

                    if (ii.Value == "-2")
                        ii.Enabled = false;
                }
                //cboBranch.Enabled = false;
            }


        }
        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total: <b>{0:N0}</b>", e.AffectedRows);
            //cmdExport.Visible = (e.AffectedRows > 0 && Session["BRANCHID"].ToString() == "1");

        }
        protected void cboPaid_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.EditIndex = -1;
        }
        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {

        }
        protected void GridView1_DataBound(object sender, EventArgs e)
        {

        }
        protected void cboBranch_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.EditIndex = -1;
        }
        protected void txtFilter_TextChanged(object sender, EventArgs e)
        {
            GridView1.EditIndex = -1;
        }
        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {

        }
        protected void GridView1_RowUpdated(object sender, GridViewUpdatedEventArgs e)
        {
            if (hidRoutingMsg.Value != "")
            {
                e.KeepInEditMode = true;
                TrustControl1.ClientMsg(hidRoutingMsg.Value);
            }
        }
        protected void SqlDataSource1_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            hidRoutingMsg.Value = Msg;
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

                    }

                    worksheet.Cells["A1:K1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["A1:A"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["B1:B"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["D1:D"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["I1:I"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["K1:K"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["A1:K1"].Style.Font.Bold = true;



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
        protected void GridView1_DataBound1(object sender, EventArgs e)
        {
            double Amount = 0;
            if (GridView1.Rows.Count > 1)
            {
                for (int i = 0; i < GridView1.Rows.Count; i++)
                {
                    Amount += double.Parse(GridView1.Rows[i].Cells[3].Text);
                }
                GridView1.FooterRow.Cells[3].Text = string.Format("{0:N2}", Amount);
            }
        }
    }
}