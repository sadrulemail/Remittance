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
    public partial class SummaryBR_View : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //Page.Form.Attributes.Add("enctype", "multipart/form-data");        
            TrustControl1.getUserRoles();


            if (Session["BRANCHID"].ToString() != "1")
            {
                //    Response.Write("No Permission.<br><br><a href=''>Home</a>");
                //    Response.End();

                if (string.Format("{0}", Request.QueryString["PaidBranch"]) != Session["BRANCHID"].ToString())
                {
                    Response.Write("No Permission.<br><br><a href=''>Home</a>");
                    Response.End();
                }
            }
        }
        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total: <b>{0:N0}</b>", e.AffectedRows);
        }
    }
}