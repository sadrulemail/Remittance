using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Remittance
{
    public partial class Flora_IC_Export : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");
            if (TrustControl1.getUserRoles() == "")
            {
                Response.End();
            }


            Tab3.Visible = TrustControl1.isRole("FLORA_EXPORT");
        }
        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            if (GridView1.Rows.Count > 1)
            {
                double Total = 0;
                double Amount = 0;

                for (int i = 0; i < GridView1.Rows.Count; i++)
                {
                    Total += double.Parse(GridView1.Rows[i].Cells[2].Text);
                    Amount += double.Parse(GridView1.Rows[i].Cells[3].Text);
                }
                GridView1.FooterRow.Cells[1].Text = "Total";
                GridView1.FooterRow.Cells[2].Text = string.Format("{0:N0}", Total);
                GridView1.FooterRow.Cells[3].Text = string.Format("{0:N2}", Amount);
            }
        }
        protected void GridView2_DataBound(object sender, EventArgs e)
        {
            if (GridView2.Rows.Count > 1)
            {
                double Total = 0;
                double Amount = 0;

                for (int i = 0; i < GridView2.Rows.Count; i++)
                {
                    Total += double.Parse(GridView2.Rows[i].Cells[2].Text);
                    Amount += double.Parse(GridView2.Rows[i].Cells[3].Text);
                }
                GridView2.FooterRow.Cells[1].Text = "Total";
                GridView2.FooterRow.Cells[2].Text = string.Format("{0:N0}", Total);
                GridView2.FooterRow.Cells[3].Text = string.Format("{0:N2}", Amount);
            }
        }

        protected void cmdMarkPaid_Click(object sender, EventArgs e)
        {
            SqlDataSource_IC_Mark_as_Paid.Select(DataSourceSelectArguments.Empty);
        }

        protected void SqlDataSource_IC_Mark_as_Paid_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatusMarkPaid.Text = string.Format("<b>New Batch Generated.</b>" +
                "<br />Total Items: <b>{1:N0}</b>" +
                "<br />Total Amount: <b>{2:N2}</b>" +
                "<br />Download: <a class='Link' href='Flora_IC_Download.aspx?batch={0}'><b>Batch # {0}</b></a>"
                , e.Command.Parameters["@BatchNo"].Value
                , e.Command.Parameters["@Total"].Value
                , e.Command.Parameters["@TotalAmount"].Value);
            PanelStatusMarkPaid.Visible = true;

            GridView1.DataBind();
            GridView2.DataBind();
            cmdMarkPaid.Enabled = false;
        }
        protected void TabContainer1_ActiveTabChanged(object sender, EventArgs e)
        {
            if (TabContainer1.ActiveTab == Tab1)
            {
                GridView2.DataBind();
            }

            if (TabContainer1.ActiveTab == Tab2)
            {
                GridView1.DataBind();
            }

            if (TabContainer1.ActiveTab == Tab3)
            {
                cmdMarkPaid.Enabled = GridView2.Rows.Count > 0 || GridView1.Rows.Count > 0;
            }

            if (TabContainer1.ActiveTab == Tab4)
            {
                GridViewHistory.DataBind();
            }
        }
    }
}