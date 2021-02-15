using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;

public partial class ChangePassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //ErrorDiv.Visible = false;
            //if (Session["EMPID"] == null)
            //    Response.Redirect("Login.aspx?Prev=PasswordChange.aspx", true);

            if (IsPostBack)
            {
                //System.Threading.Thread.Sleep(1000);
                txtNewPassword.Attributes.Add("value", txtNewPassword.Text);
                txtPassword.Attributes.Add("value", txtPassword.Text);
                txtRePassword.Attributes.Add("value", txtRePassword.Text);
            }
            else
            {
                TrustControl1.getUserRoles();
                //Panel2.Visible = false;
                //Panel1.Visible = true;
                txtPassword.Focus();
            }
        }
        protected void cmdChangePassword_Click(object sender, EventArgs e)
        {
            bool Done = false;
            string Msg = "";
            int Focus = 0;

            try
            {
                SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString);
                SqlCommand oCommand = new SqlCommand("ChangePassword", oConn);
                oCommand.CommandType = CommandType.StoredProcedure;

                if (oConn.State == ConnectionState.Closed)
                    oConn.Open();
                oCommand.Parameters.Add("@param_OldPassword", SqlDbType.VarChar).Value = txtPassword.Text;
                oCommand.Parameters.Add("@param_NewPassword", SqlDbType.VarChar).Value = txtNewPassword.Text;
                oCommand.Parameters.Add("@param_RetypePassword", SqlDbType.VarChar).Value = txtRePassword.Text;
                oCommand.Parameters.Add("@param_EmpID", SqlDbType.VarChar).Value = Session["EMPID"].ToString();
                oCommand.Parameters.Add("@param_IP", SqlDbType.Text).Value = getIPAddress();


                SqlParameter sql_Done = new SqlParameter("@Done", SqlDbType.Bit);
                sql_Done.Value = Done;
                sql_Done.Direction = ParameterDirection.InputOutput;
                oCommand.Parameters.Add(sql_Done);

                SqlParameter sql_Msg = new SqlParameter("@Msg", SqlDbType.VarChar);
                sql_Msg.Size = 255;
                sql_Msg.Value = Msg;
                sql_Msg.Direction = ParameterDirection.InputOutput;
                oCommand.Parameters.Add(sql_Msg);

                SqlParameter sql_Focus = new SqlParameter("@Focus", SqlDbType.Int);
                sql_Focus.Value = Focus;
                sql_Focus.Direction = ParameterDirection.InputOutput;
                oCommand.Parameters.Add(sql_Focus);

                oCommand.ExecuteNonQuery();

                Msg = string.Format("<br />{0}<br />", sql_Msg.Value);
                Done = (bool)sql_Done.Value;
                Focus = (int)sql_Focus.Value;

                oConn.Close();

                //Response.Write(ROW_AFFECTED.ToString());

                lblErrorMsg.Text = Msg;

                if (Done)
                {
                    Panel2.Visible = false;
                    Panel1.Visible = true;
                    lblMsg.Text = Msg;

                    if (Request.QueryString["Prev"] == null)
                        Session.Abandon();
                    else
                        cmdLogin.Text = "Done";
                }
                else
                {
                    switch (Focus)
                    {
                        case 1:
                            txtPassword.Focus();
                            break;
                        case 2:
                            txtNewPassword.Focus();
                            break;
                        case 3:
                            txtRePassword.Focus();
                            break;
                        default:
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write(ex.Message);
                Response.End();
            }
        }

        public string getIPAddress()
        {
            string Client_IP_Address = string.Empty;
            try
            {
                Client_IP_Address = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
            }
            catch (Exception)
            {
                try
                {
                    Client_IP_Address = HttpContext.Current.Request.UserHostAddress;
                }
                catch (Exception)
                {
                    Client_IP_Address = Request.ServerVariables["LOCAL_ADDR"].ToString();
                }
            }
            return Client_IP_Address;
        }

        protected void cmdCancel_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["Prev"] == null)
                Response.Redirect("Default.aspx");
            else
                Response.Redirect(Request.QueryString["Prev"]);
        }

        protected void cmdLogin_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["Prev"] != null)
            {
                string tail = "";
                foreach (String key in Request.QueryString.AllKeys)
                {
                    if (key.ToLower() != "prev")
                        tail += "&" + key + "=" + Request.QueryString[key].ToString();
                }
                Response.Redirect(Request.QueryString["Prev"] + tail, true);
            }
            else
            {
                Response.Redirect("Default.aspx", true);
            }
        }
    }
