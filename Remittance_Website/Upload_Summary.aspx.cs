using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Remittance
{
    public partial class Upload_Summary : System.Web.UI.Page
    {
        int TotalCount = 0;
        int TotalRows = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");
            if (TrustControl1.getUserRoles() == "")
            {
                Response.End();
            }

            if (!IsPostBack)
            {
                txtDateFrom.Text = string.Format("{0:dd/MM/yyy}", DateTime.Now.Date);
                txtDateTo.Text = string.Format("{0:dd/MM/yyy}", DateTime.Now.Date);
            }

            this.Title = "Upload Remittance Data Summary";
        }
        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            try
            {
                TotalRows = e.AffectedRows;
            }
            catch (Exception) { }
        }

        public string getBgColor(object DT, string Color)
        {
            return Color;
        }
        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            //if (e.Row.RowType == DataControlRowType.DataRow)
            //{
            //    //if (Convert.ToDateTime(DataBinder.Eval(e.Row.DataItem, "DT")).Date == DateTime.Now.Date)
            //    //{
            //    //    e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFFF88");
            //    //    e.Row.ForeColor = System.Drawing.Color.Black;
            //    //    TotalCount++;
            //    //}
            //    if (Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "Published")) == false)
            //    {
            //        //e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#EEEEEE");
            //        e.Row.ForeColor = System.Drawing.Color.Gray;
            //        TotalCount++;
            //    }
            //}
            //lblStatus.Text = string.Format("Total Batch: <b>{0}</b>, Totay: <b>{1}</b>", TotalRows, TotalCount);
        }

        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            //lblStatus.Text = string.Format("Total Batch: <b>{0}</b><br />Totay's Total Batch: <b>{1}</b>", TotalRows, TotalCount);


            double Amount = 0;
            int Total = 0;

            try
            {
                lblStatus.Text = string.Format("Total Rows: <b>{0}</b>", TotalRows);
                for (int r = 0; r < GridView1.Rows.Count; r++)
                {
                    Amount += double.Parse(GridView1.Rows[r].Cells[2].Text);
                    Total += int.Parse(GridView1.Rows[r].Cells[1].Text);
                }



                GridView1.FooterRow.Cells[1].Text = string.Format("{0}", Total);
                GridView1.FooterRow.Cells[2].Text = string.Format("{0:N2}", Amount);

                GridView1.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Center;
                GridView1.FooterRow.Cells[2].HorizontalAlign = HorizontalAlign.Right;
            }
            catch (Exception) { }
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

        protected void radioCurrency_DataBound(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                radioCurrency.SelectedIndex = 0;
            }
        }
    }
}