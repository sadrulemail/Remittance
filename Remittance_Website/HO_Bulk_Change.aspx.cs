using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class HO_Bulk_Change : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();
        lblTitle.Text = "Bulk Return";
        this.Title = "Bulk Return";
    }

    protected void cmdShow_Click(object sender, EventArgs e)
    {
        txtRIDs.Text = txtRIDs.Text.Replace("\n", ",").Replace(" ", "").Replace(";", ",");
        GridView1.DataBind();
    }

    protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        lblStatus.Text = string.Format("Total: <b>{0:N0}</b>", e.AffectedRows);
        cmdSave.Enabled = e.AffectedRows > 0;
        txtRIDs.Enabled = e.AffectedRows == 0;
    }

    protected void cmdSave_Click(object sender, EventArgs e)
    {
        if(cboReturn.SelectedItem.Value == "")
        {
            TrustControl1.ClientMsg("Please select Return Reason.", cboReturn);
            return;
        }

        string oConnString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;
        SqlConnection oConn = new SqlConnection(oConnString);
        if (oConn.State == ConnectionState.Closed) oConn.Open();

        SqlCommand oCommand = new SqlCommand("s_RemiList_Bulk_Return", oConn);
        oCommand.CommandType = CommandType.StoredProcedure;

        SqlParameter sql_RIDs = new SqlParameter("@RIDs", SqlDbType.VarChar, -1);
        sql_RIDs.Value = txtRIDs.Text;



        SqlParameter sql_Msg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
        sql_Msg.Value = " ";
        sql_Msg.Direction = ParameterDirection.Output;

      

        oCommand.Parameters.Add(sql_RIDs);
        oCommand.Parameters.Add(sql_Msg);
        oCommand.Parameters.AddWithValue("@PaymentMethod", "BEFTN");
        oCommand.Parameters.AddWithValue("@ReturnBy", Session["EMPID"].ToString());
        oCommand.Parameters.AddWithValue("@ReturnReasonID", cboReturn.SelectedItem.Value);


        oCommand.ExecuteNonQuery();

        lblBulkStatus.Text = string.Format("{0}", sql_Msg.Value);
        cmdSave.Enabled = false;
    }
}