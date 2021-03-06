﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OfficeOpenXml;
using System.Data;

namespace Remittance
{
    public partial class Paid_Grid : System.Web.UI.Page
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
                txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);
                txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);
            }

            this.Title = "Paid Grid";
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
                    else
                        ii.Enabled = false;
                }
            }
        }
        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total: <b>{0:N0}</b>", e.AffectedRows);

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
                    worksheet.Cells[StartRow, 1].Value = "RID";
                    worksheet.Cells[StartRow, 2].Value = "Amount";
                    worksheet.Cells[StartRow, 3].Value = "Currency";
                    worksheet.Cells[StartRow, 4].Value = "Paid On";
                    worksheet.Cells[StartRow, 5].Value = "Paid By";
                    worksheet.Cells[StartRow, 6].Value = "Paid Branch";
                    worksheet.Cells[StartRow, 7].Value = "Paid Bank";
                    worksheet.Cells[StartRow, 8].Value = "Paymnet Method";
                    worksheet.Cells[StartRow, 9].Value = "Exhouse Code";
                    worksheet.Cells[StartRow, 10].Value = "To Branch Name";
                    worksheet.Cells[StartRow, 11].Value = "Routing Number";
                    worksheet.Cells[StartRow, 12].Value = "Remitter Name";
                    worksheet.Cells[StartRow, 13].Value = "Beneficiary Name";


                    worksheet.Column(1).Width = 20;
                    worksheet.Column(2).Width = 12;
                    worksheet.Column(3).Width = 12;
                    worksheet.Column(4).Width = 10;
                    worksheet.Column(5).Width = 15;
                    worksheet.Column(6).Width = 15;
                    worksheet.Column(7).Width = 15;
                    worksheet.Column(8).Width = 15;
                    worksheet.Column(9).Width = 15;
                    worksheet.Column(10).Width = 15;
                    worksheet.Column(11).Width = 15;
                    worksheet.Column(12).Width = 15;

                    DataView DV = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);
                    for (int r = 0; r < DV.Table.Rows.Count; r++)
                    {
                        int R = StartRow + r + 1;
                        //worksheet.Cells[R, 1].Value = r + 1;

                        if (DV.Table.Rows[r]["ID"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 1].Value = DV.Table.Rows[r]["ID"].ToString();
                            //worksheet.Cells[R, 1].Style.Numberformat.Format = "MM/dd/yyyy";
                        }

                        if (DV.Table.Rows[r]["Amount"] != DBNull.Value)
                        {
                            worksheet.Cells[R, 2].Value = DV.Table.Rows[r]["Amount"];
                            worksheet.Cells[R, 2].Style.Numberformat.Format = "#,##0.00";
                        }

                        if (DV.Table.Rows[r]["Currency"] != DBNull.Value)
                            worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["Currency"].ToString();

                        if (DV.Table.Rows[r]["PaidOn"] != DBNull.Value)
                            worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["PaidOn"];

                        if (DV.Table.Rows[r]["PaidBy"] != DBNull.Value)
                            worksheet.Cells[R, 5].Value = DV.Table.Rows[r]["PaidBy"];

                        if (DV.Table.Rows[r]["PaidBranch"] != DBNull.Value)
                            worksheet.Cells[R, 6].Value = DV.Table.Rows[r]["PaidBranch"].ToString();

                        if (DV.Table.Rows[r]["PaymentMethod"] != DBNull.Value)
                            worksheet.Cells[R, 7].Value = DV.Table.Rows[r]["PaymentMethod"].ToString();

                        if (DV.Table.Rows[r]["BankName"] != DBNull.Value)
                            worksheet.Cells[R, 8].Value = DV.Table.Rows[r]["BankName"].ToString();

                        if (DV.Table.Rows[r]["ExHouseName"] != DBNull.Value)
                            worksheet.Cells[R, 9].Value = DV.Table.Rows[r]["ExHouseName"].ToString();

                        if (DV.Table.Rows[r]["ToBranchName"] != DBNull.Value)
                            worksheet.Cells[R, 10].Value = DV.Table.Rows[r]["ToBranchName"].ToString();

                        if (DV.Table.Rows[r]["RoutingNumber"] != DBNull.Value)
                            worksheet.Cells[R, 11].Value = DV.Table.Rows[r]["RoutingNumber"].ToString();

                        if (DV.Table.Rows[r]["RemitterName"] != DBNull.Value)
                            worksheet.Cells[R, 12].Value = DV.Table.Rows[r]["RemitterName"].ToString();

                        if (DV.Table.Rows[r]["BeneficiaryName"] != DBNull.Value)
                            worksheet.Cells[R, 13].Value = DV.Table.Rows[r]["BeneficiaryName"].ToString();

                    }

                    worksheet.Cells["A1:L1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
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
                Response.AddHeader("Content-Disposition", "attachment;filename=" +
                    "Remittance_Paid.xlsx"
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
    }
}