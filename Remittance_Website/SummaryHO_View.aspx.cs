using System;
using System.Web.UI.WebControls;

namespace Remittance
{
    public partial class SummaryHO_View : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //Page.Form.Attributes.Add("enctype", "multipart/form-data");        
            TrustControl1.getUserRoles();

            if (Session["BRANCHID"].ToString() != "1")
            {
                Response.Write("No Permission.<br><br><a href=''>Home</a>");
                Response.End();
            }
        }
        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total: <b>{0:N0}</b>", e.AffectedRows);
        }
        protected void GridView2_DataBound(object sender, EventArgs e)
        {
            try
            {
                double Total = 0;
                int Count = 0;

                for (int r = 0; r < GridView2.Rows.Count; r++)
                {
                    if (GridView2.Rows[r].RowType == DataControlRowType.DataRow)
                    {
                        Total += double.Parse(GridView2.Rows[r].Cells[1].Text.Replace(",", ""));
                        Count += int.Parse(GridView2.Rows[r].Cells[3].Text);
                    }
                }

                GridView2.FooterRow.Cells[1].Text = string.Format("{0:N2}", Total);
                GridView2.FooterRow.Cells[3].Text = string.Format("{0:N0}", Count);
                GridView2.FooterRow.Cells[3].HorizontalAlign = HorizontalAlign.Center;
            }
            catch (Exception) { }
        }
    }
}