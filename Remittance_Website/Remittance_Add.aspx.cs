using System;
using System.Data;
using System.Data.SqlClient;

namespace Remittance
{
    public partial class Remittance_Add : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            txtPaidOn.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);
            txtValueDate.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);
            txtInstrumentDate.Text = txtValueDate.Text;
            TrustControl1.getUserRoles();
            
            //string RID = string.Format("{0}", Request.QueryString["id"]);
            

            if (!IsPostBack)
            {
                txtAmount.Focus();
                
            }
            
            //TrustControl1.ClientMsg("Saved Successfully.<br><a href=''>Go to Remittance</a>");
        }


        protected void cmdSave_Click(object sender, EventArgs e)
        {
            string Msg = "";
            bool done = false;
            Int64 RID = 0;
            lblStatus.Text = "";

            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Remilist_Add_IC";

                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand(Query, conn))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@Currency", System.Data.SqlDbType.VarChar).Value = cboCurrency.SelectedItem.Value;
                    cmd.Parameters.Add("@Amount", SqlDbType.Decimal).Value = Decimal.Parse(txtAmount.Text);
                    cmd.Parameters.Add("@BeneficiaryName", System.Data.SqlDbType.VarChar).Value = txtBeneficiaryName.Text.Trim();
                    cmd.Parameters.Add("@BeneficiaryAddress", System.Data.SqlDbType.VarChar).Value = txtBeneficiaryAddress.Text.Trim();
                    cmd.Parameters.Add("@RemitterName", System.Data.SqlDbType.VarChar).Value = txtRemitterName.Text.Trim();
                    cmd.Parameters.Add("@RemitterAddress", System.Data.SqlDbType.VarChar).Value = txtRemitterAddress.Text.Trim();
                    cmd.Parameters.Add("@ExHouseCode", System.Data.SqlDbType.VarChar).Value = ddlExHouse.SelectedItem.Value;
                    cmd.Parameters.Add("@RefOrderReceipt", System.Data.SqlDbType.VarChar).Value = txtRefOrderReceipt.Text.Trim();
                    cmd.Parameters.Add("@PaidOn", SqlDbType.DateTime).Value = DateTime.Parse(txtPaidOn.Text);
                    cmd.Parameters.Add("@ValueDate", SqlDbType.DateTime).Value = DateTime.Parse(txtValueDate.Text);
                    cmd.Parameters.Add("@Instrument", System.Data.SqlDbType.VarChar).Value = txtInstumentNo.Text.Trim();
                    if (txtInstrumentDate.Text.Trim().Length > 0)
                        cmd.Parameters.Add("@InstrumentDate", SqlDbType.DateTime).Value = DateTime.Parse(txtInstrumentDate.Text);
                    cmd.Parameters.Add("@IDType", System.Data.SqlDbType.VarChar).Value = txtIDType.Text.Trim();
                    cmd.Parameters.Add("@IDNumber", System.Data.SqlDbType.VarChar).Value = txtIDNo.Text.Trim();
                    if (txtIDExpiryDate.Text.Trim().Length > 0)
                        cmd.Parameters.Add("@IDExpiryDate", SqlDbType.DateTime).Value = DateTime.Parse(txtIDExpiryDate.Text);

                    cmd.Parameters.Add("@ToBranch", System.Data.SqlDbType.Int).Value = Session["BRANCHID"].ToString();
                    cmd.Parameters.Add("@PaidBranch", System.Data.SqlDbType.Int).Value = Session["BRANCHID"].ToString();
                    cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = Session["EMPID"].ToString();

                    SqlParameter SQL_RID = new SqlParameter("@RID", SqlDbType.BigInt);
                    SQL_RID.Direction = ParameterDirection.InputOutput;
                    SQL_RID.Value = RID;
                    cmd.Parameters.Add(SQL_RID);

                    SqlParameter SQL_Msg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
                    SQL_Msg.Direction = ParameterDirection.InputOutput;
                    SQL_Msg.Value = Msg;
                    cmd.Parameters.Add(SQL_Msg);

                    SqlParameter SQL_Done = new SqlParameter("@Done", SqlDbType.Bit);
                    SQL_Done.Direction = ParameterDirection.InputOutput;
                    SQL_Done.Value = done;
                    cmd.Parameters.Add(SQL_Done);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                    done = (bool)SQL_Done.Value;
                    RID = (Int64)SQL_RID.Value;
                    Msg = string.Format("{0}", SQL_Msg.Value);
                }
            }

            if (done)
            {
                //TrustControl1.ClientMsg(Msg);
                //cboCurrency.Text = "";
                txtAmount.Text = "";
                txtBeneficiaryName.Text = "";
                txtBeneficiaryAddress.Text = "";
                txtRemitterName.Text = "";
                txtRemitterAddress.Text = "";
                //ddlExHouse.SelectedValue.Trim();
                txtRefOrderReceipt.Text.Trim();
                txtPaidOn.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);
                string RedirectURL = string.Format("Remittance_Show.aspx?id={0}", RID);
                //Response.Redirect(string.Format("Remittance_Show.aspx?id={0}", RID), false);
                //TrustControl1.ClientScript("window.location='" + RedirectURL + "';");
                Panel1.Enabled = false;
                cmdSave.Enabled = false;
                lblStatus.Text = "RID Saved: <a href='" + RedirectURL + "' class='Link'>" + RID.ToString() + "</a>";
                Response.Redirect(string.Format("Remittance_Show.aspx?id={0}", RID), false);
            }
            else
            {
                lblStatus.Text = (Msg);
            }
        }

     
    
        protected void cmdNew_Click(object sender, EventArgs e)
        {
            Response.Redirect("Remittance_Add.aspx", false);
        }
    }
}