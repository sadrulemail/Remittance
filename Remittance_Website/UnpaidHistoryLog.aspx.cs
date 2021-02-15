using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Remittance
{
    public partial class UnpaidHistoryLog : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            TrustControl1.getUserRoles();

            if (!IsPostBack)
            {
                txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);
                txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);

                txtDateFromPaid.Text = "01/01/2013";
                txtDateToPaid.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);
            }
            this.Title = "Unpaid Mark History";
        }
        protected void txtRID_TextChanged(object sender, EventArgs e)
        {
            txtDateFrom.Text = "";
            txtDateTo.Text = "";
        }
        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total Rows: <b>{0:N0}</b>", e.AffectedRows);
        }
        protected void cmdPreviousDay_Click(object sender, EventArgs e)
        {
            DateTime DT = DateTime.Parse(txtDateFrom.Text);
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
        }
        protected void cmdNextDay_Click(object sender, EventArgs e)
        {
            DateTime DT = DateTime.Parse(txtDateFrom.Text);
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(1));
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(1));
        }
    }
}