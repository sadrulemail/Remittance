using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

namespace Remittance
{
    public partial class Comments_Browse : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");
            if (TrustControl1.getUserRoles() == "")
            {
                Response.End();
            }

            if (IsPostBack)
                GridView1.DataBind();

            this.Title = "Browse Comments";
        }
        protected void cmdFilter_Click(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }
        protected void txtFilter_TextChanged(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }
        protected void Timer1_Tick(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }
        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total: <b>{0}</b>", e.AffectedRows);
        }
        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Completed")
            {
                string oConnString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                SqlConnection oConn = new SqlConnection(oConnString);
                if (oConn.State == ConnectionState.Closed)
                    oConn.Open();
                SqlCommand oCommand = new SqlCommand("sp_Comment_Insert", oConn);
                oCommand.CommandType = CommandType.StoredProcedure;
                oCommand.Parameters.Add("@RID", SqlDbType.VarChar).Value = e.CommandArgument.ToString();
                oCommand.Parameters.Add("@Comment", SqlDbType.VarChar).Value = "OK";
                oCommand.Parameters.Add("@PostedBy", SqlDbType.VarChar).Value = Session["EMPID"].ToString();
                oCommand.Parameters.Add("@Branch", SqlDbType.VarChar).Value = Session["BRANCHID"].ToString();
                oCommand.Parameters.Add("@CommentStatusID", SqlDbType.VarChar).Value = "3";

                if (oConn.State == ConnectionState.Closed)
                    oConn.Open();

                oCommand.ExecuteNonQuery();
                oConn.Close();
                GridView1.DataBind();
            }
        }
        protected void cboCommentStatus_DataBound(object sender, EventArgs e)
        {
            ListItem li = new ListItem("All", "0");
            cboCommentStatus.Items.Add(li);
        }
    }
}