using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;

namespace Remittance
{
    public partial class PaymentMethod_Status : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");

            if (TrustControl1.getUserRoles() == "")
            {
                //if (Session["DEPTID"].ToString() != "7")    //Not IT & Cards
                {
                    Response.Write("No Permission.<br><br><a href=''>Home</a>");
                    Response.End();
                }
            }

            this.Title = "Payment Methods";
        }
        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            int[] AL = new int[GridView1.Columns.Count];

            for (int r = 0; r < GridView1.Rows.Count; r++)
            {
                for (int c = 1; c < AL.Length; c++)
                {
                    AL[c] += int.Parse(GridView1.Rows[r].Cells[c].Text.Replace(",", ""));
                    GridView1.FooterRow.Cells[c].Text = string.Format("{0:N0}", AL[c]);
                }
            }
        }
    }
}