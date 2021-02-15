using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography;
using System.Text;
using System.IO;

namespace Remittance
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Directory.Exists(Server.MapPath("Upload"))) Directory.CreateDirectory(Server.MapPath("Upload"));

            try
            {
                string ApplicationID = System.Configuration.ConfigurationManager.AppSettings["ApplicationID"].ToString();
                //string CookieName = "Login_" + ApplicationID;
                //if (Request.Cookies[CookieName] != null)
                //{
                //    HttpCookie cookie = Request.Cookies.Get(CookieName);
                //    LoginTo(cookie.Values["ID"].ToString(), cookie.Values["Password"].ToString(), true); 
                //}            
            }
            catch (Exception) { }
            ((Panel)(Page.Master.FindControl("MenuPanel"))).Visible = false;



            //string focusScript = "document.getElementById('" + txtEmpID.ClientID + "').focus();";
            //if (!IsPostBack)
            //    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "clientScript", "setTimeout(\"" + focusScript + ";\",100);", true);
            //else
            //    ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "clientScript", focusScript, true);

            try
            {
                string AppName = "";
                string ApplicationPath = "";
                string Logo = "";

                int ApplicationID = int.Parse(System.Configuration.ConfigurationManager.AppSettings["ApplicationID"].ToString().Trim());
                string oConnString = System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString;
                System.Data.SqlClient.SqlConnection oConn = new System.Data.SqlClient.SqlConnection(oConnString);
                System.Data.SqlClient.SqlCommand oComm = new System.Data.SqlClient.SqlCommand(string.Format("SELECT * FROM [Applications] WHERE ID = {0}", ApplicationID), oConn);

                if (oConn.State == System.Data.ConnectionState.Closed) oConn.Open();

                IDataReader DR = oComm.ExecuteReader();
                while (DR.Read())
                {
                    AppName = DR["ApplicationName"].ToString();
                    ApplicationPath = DR["ApplicationPath"].ToString();
                    Logo = DR["Logo"].ToString();
                }
                try
                {
                    ((HyperLink)this.Page.Master.FindControl("ApplicationName")).Text = AppName;
                }
                catch (Exception) { }
                try
                {
                    ((HyperLink)this.Page.Master.FindControl("ApplicationName")).NavigateUrl = ApplicationPath;
                }
                catch (Exception) { }
                try
                {
                    ((HyperLink)this.Page.Master.FindControl("ApplicationLogo")).NavigateUrl = ApplicationPath;
                }
                catch (Exception) { }
                try
                {
                    ((HyperLink)this.Page.Master.FindControl("ApplicationLogo")).ImageUrl = Logo;
                }
                catch (Exception) { }
                try
                {
                    ((HyperLink)this.Page.Master.FindControl("lblRole")).Visible = false;
                }
                catch (Exception) { }
                try
                {
                    imgApp.ImageUrl = Logo;
                }
                catch (Exception) { }
                try
                {
                    ((System.Web.UI.HtmlControls.HtmlGenericControl)this.Page.Master.FindControl("FavLogo")).Attributes["href"] = Logo;
                }
                catch (Exception) { }


                lblTitle.Text = string.Format("Login to {0}", AppName);
                this.Title = string.Format("Login :: {0}", AppName);
            }
            catch (Exception) { }

            if (imgApp.ImageUrl == "") imgApp.ImageUrl = "Images/keys.png";

            if (IsPostBack)
            {
                txtEmpID.Attributes.Add("value", txtEmpID.Text);
                txtPassword.Attributes.Add("value", txtPassword.Text);
            }
            else
            {
                txtEmpID.Focus();
            }
        }

        protected void cmdNext_Click(object sender, EventArgs e)
        {
            string ImageIdentifier = "";

            try
            {
                string oConnString = System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString;

                SqlConnection oConn = new SqlConnection(oConnString);
                if (oConn.State == ConnectionState.Closed) oConn.Open();
                SqlCommand oCommand = new SqlCommand("SELECT dbo.f_EmpImageIdentifier (@EmpID) AS ImageIdentifier", oConn);
                oCommand.CommandType = CommandType.Text;
                oCommand.Parameters.Add("@EmpID", SqlDbType.VarChar).Value = txtEmpID.Text;

                if (oConn.State == ConnectionState.Closed)
                    oConn.Open();

                SqlDataReader oReader = oCommand.ExecuteReader();

                string Role = string.Empty;
                while (oReader.Read())
                {
                    ImageIdentifier = string.Format("{0}", oReader["ImageIdentifier"]);
                }

                oConn.Close();
            }
            catch (Exception)
            { }

            lblEmpID.Text = txtEmpID.Text;
            txtEmpID.Enabled = false;
            cmdNext.Visible = txtEmpID.Visible = false;
            cmdLogin.Visible = PanelPassword.Visible = lnkBack.Visible = hypForgetPass.Visible = true;
            litEmpImage.Text = string.Format("<img src='EmpImage.aspx?EMPID={0}&imgid={1}&W=200' width='100' height='100' style='border:1px solid gray;padding:2px;border-radius:50px'></img>", txtEmpID.Text, ImageIdentifier);
            txtPassword.Focus();
        }
        protected void lnkBack_Click(object sender, EventArgs e)
        {
            lblEmpID.Text = "";
            lblError.Text = "";
            txtPassword.Text = "";
            txtEmpID.Enabled = true;
            cmdNext.Visible = txtEmpID.Visible = true;
            cmdLogin.Visible = PanelPassword.Visible = lnkBack.Visible = hypForgetPass.Visible = false;
            litEmpImage.Text = "";
            txtEmpID.Focus();
        }

        protected void cmdLogin_Click(object sender, EventArgs e)
        {
            Session["EMPID"] = null;
            Session["DESIGID"] = null;
            Session["DEPTID"] = null;
            Session["BRANCHID"] = null;

            Session["APPID_ROLE"] = string.Empty;

            string EmpID;
            try
            {
                EmpID = txtEmpID.Text.Trim();
            }
            catch (Exception)
            {
                ClientMsg("Please enter Login ID and Password.");
                return;
            }
            LoginTo(EmpID, txtPassword.Text);
        }

        private void SetCookie()
        {
            try
            {
                string ApplicationID = System.Configuration.ConfigurationManager.AppSettings["ApplicationID"].ToString();
                HttpCookie cookie = new HttpCookie("Login_" + ApplicationID);
                cookie.Values.Add("ID", txtEmpID.Text);
                cookie.Values.Add("Password", EncodePassword(txtPassword.Text));
                cookie.Expires = DateTime.Now.AddMonths(1);
                Response.Cookies.Add(cookie);
            }
            catch (Exception) { }
        }

        private bool LoginTo(string EmpID, string Password)
        {
            int ApplicationID = int.Parse(System.Configuration.ConfigurationManager.AppSettings["ApplicationID"].ToString().Trim());

            bool LoginSuccess = false;
            string Msg = "";

            if (Password == string.Empty)
            {
                ClientMsg("Please enter Login ID and Password.");
                //txtEmpID.Text = "dsf";
                return false;
            }
            else
            {
                try
                {
                    SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString);
                    SqlCommand oCommand = new SqlCommand("sp_Emp_Login", oConn);
                    oCommand.CommandType = CommandType.StoredProcedure;

                    SqlParameter Sql_Done = new SqlParameter("@Done", SqlDbType.Bit);
                    Sql_Done.Direction = ParameterDirection.InputOutput;
                    Sql_Done.Value = LoginSuccess;
                    oCommand.Parameters.Add(Sql_Done);

                    SqlParameter Sql_Msg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
                    Sql_Msg.Direction = ParameterDirection.InputOutput;
                    Sql_Msg.Value = Msg;
                    oCommand.Parameters.Add(Sql_Msg);

                    oCommand.Parameters.AddWithValue("@EmpID", EmpID);
                    oCommand.Parameters.AddWithValue("@Password", Password);

                    oCommand.Parameters.Add("@AppID", SqlDbType.Int).Value = ApplicationID;
                    oCommand.Parameters.Add("@IP", SqlDbType.VarChar).Value = getIP_Address();
                    oCommand.Parameters.Add("@Browser", SqlDbType.VarChar).Value = Request.UserAgent.ToString();
                    oCommand.Parameters.Add("@UsingCookie", SqlDbType.Bit).Value = false;

                    if (oConn.State == ConnectionState.Closed)
                        oConn.Open();

                    oCommand.ExecuteNonQuery();

                    LoginSuccess = (bool)Sql_Done.Value;
                    Msg = string.Format("{0}", Sql_Msg.Value);

                    oConn.Close();

                }
                catch (Exception ex)
                {
                    ClientMsg(ex.Message);
                }

                try
                {
                    if (LoginSuccess)
                    {
                        Session["EMPID"] = EmpID;

                        if (Request.QueryString["Prev"] != null)
                        {
                            string tail = "";
                            foreach (String key in Request.QueryString.AllKeys)
                            {
                                if (key.ToLower() != "prev")
                                    tail += "&" + key + "=" + Request.QueryString[key].ToString();
                            }
                            Response.Redirect(Request.QueryString["Prev"] + tail, true);
                            //Page.ClientScript.RegisterStartupScript(this.GetType(), "redirect", "location.href = '" + Request.QueryString["Prev"] + tail + "'", true);
                            //return false;
                        }
                        else
                        {
                            //Page.ClientScript.RegisterStartupScript(this.GetType(), "redirect", "location.href = 'Default.aspx'", true);
                            Response.Redirect("Default.aspx", true);
                            //HttpContext.Current.ApplicationInstance.CompleteRequest();
                            //return false;
                        }
                    }
                    else
                    {
                        lblError.Text = Msg;
                    }
                }
                catch (Exception ex)
                {
                    ClientMsg("Error2: " + ex.Message);
                }

            }
            txtPassword.Focus();
            return false;
        }

        private string getIP_Address()
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

        private string getBrowserInfo()
        {
            string Client_BrowserInfo = string.Empty;
            try
            {
                Client_BrowserInfo = Request.Browser.Browser;
            }
            catch (Exception) { }
            try
            {
                Client_BrowserInfo += ", " + Request.Browser.Version;
            }
            catch (Exception) { }
            //try
            //{
            //    Client_BrowserInfo += ", JavaScript:" + HttpContext.Current.Request.Browser["JavaScriptVersion"];
            //}
            //catch (Exception) { }
            try
            {
                Client_BrowserInfo += ", " + Request.Browser.Platform;
            }
            catch (Exception) { }
            return Client_BrowserInfo;
        }

        public string EncodePassword(string OriginalPassword)
        {
            Byte[] originalBytes;
            Byte[] encodedBytes;
            MD5 md5;
            md5 = new MD5CryptoServiceProvider();
            originalBytes = ASCIIEncoding.Default.GetBytes(OriginalPassword);
            encodedBytes = md5.ComputeHash(originalBytes);
            return BitConverter.ToString(encodedBytes);
        }

        private void ClientMsg(string MsgTxt)
        {
            lblError.Text = "<br>" + MsgTxt + "<br>";
            //ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", "alert('" + MsgTxt + "')", true);
        }

        protected void txtEmpID_TextChanged(object sender, EventArgs e)
        {
            cmdNext_Click(sender, e);
        }
    }
}