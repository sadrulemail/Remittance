using System;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OfficeOpenXml;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Remittance
{
    public partial class TfDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            TrustControl1.getUserRoles();

            if (!IsPostBack)
                RiaDashBoardStatusCount();
        }


        protected void lbtnOrderDownload_Click(object sender, EventArgs e)
        {
            ServiceLockStatus objLockStatus = new ServiceLockStatus();
            try
            {
                objLockStatus = CheckServiceLockStatus("TfAPI", "TfDownloadInvoicesForPayout");
                if (!objLockStatus.Running)
                {
                    TfWebService.TransfastService tfService = new TfWebService.TransfastService();

                    string downloadStatus = tfService.DownloadInvoicesForPayout( Session["EMPID"].ToString(), chkBoxTrdParty.Checked, getValueOfKey("Tf_KeyCode"));
                    
                    if (downloadStatus=="1")
                        TrustControl1.ClientMsg("New Orders Downloaded Successfully.");
                   else if (downloadStatus == "5")
                        TrustControl1.ClientMsg("Orders Save failed to Remilist.");
                    else
                        TrustControl1.ClientMsg(downloadStatus);
                   // gdvOrdersReceived.DataBind();
                }
                else
                    TrustControl1.ClientMsg(objLockStatus.Msg);
            }
            catch(Exception ex)
            {
                Common.WriteLog("", "TfAPI", "TfDownloadInvoicesForPayout UI", ex.Message);
            }
            finally
            {
                UpdateServiceLockStatus("TfAPI", "TfDownloadInvoicesForPayout");
            }

        }
     

        private void RiaDashBoardStatusCount()
        {
 
            try
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_TfDashBoardSelect";//***
                    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        SqlParameter sqlTfPaidfail = new SqlParameter("@TfPaidFail", SqlDbType.Int, 50);
                        sqlTfPaidfail.Direction = ParameterDirection.InputOutput;
                        sqlTfPaidfail.Value = 0;
                        cmd.Parameters.Add(sqlTfPaidfail);

                        SqlParameter sqlCancelPending = new SqlParameter("@CancelPending", SqlDbType.Int, 50);
                        sqlCancelPending.Direction = ParameterDirection.InputOutput;
                        sqlCancelPending.Value = 0;
                        cmd.Parameters.Add(sqlCancelPending);

                        SqlParameter sqlCancelNotificationToRia = new SqlParameter("@CancelNotificationPending", SqlDbType.Int, 50);
                        sqlCancelNotificationToRia.Direction = ParameterDirection.InputOutput;
                        sqlCancelNotificationToRia.Value = 0;
                        cmd.Parameters.Add(sqlCancelNotificationToRia);

                        SqlParameter sqlPaidPending = new SqlParameter("@PaidPending", SqlDbType.Int, 50);
                        sqlPaidPending.Direction = ParameterDirection.InputOutput;
                        sqlPaidPending.Value = 0;
                        cmd.Parameters.Add(sqlPaidPending);

                        SqlParameter sqlPublishedPending = new SqlParameter("@PublishedPending", SqlDbType.Int, 50);
                        sqlPublishedPending.Direction = ParameterDirection.InputOutput;
                        sqlPublishedPending.Value = 0;
                        cmd.Parameters.Add(sqlPublishedPending);

                        //SqlParameter sqlRollBackPending = new SqlParameter("@RollBackPending", SqlDbType.Int, 50);
                        //sqlRollBackPending.Direction = ParameterDirection.InputOutput;
                        //sqlRollBackPending.Value = 0;
                        //cmd.Parameters.Add(sqlRollBackPending);

                        cmd.Connection = conn;
                        conn.Open();

                        cmd.ExecuteNonQuery();

                        litTfPaidFail.Text = sqlTfPaidfail.Value.ToString();
                        //litCancelResponsePending.Text = sqlCancelPending.Value.ToString();
                        //litCancelAcceptedPending.Text = sqlCancelNotificationToRia.Value.ToString();
                        litPaidPending.Text = sqlPaidPending.Value.ToString();
                        litPublishPending.Text = sqlPublishedPending.Value.ToString();

                    }

                }


            }
            catch (Exception ex)
            {

            }
          
        }

     

        private ServiceLockStatus CheckServiceLockStatus(string ApplicationID,string MethodName)
        {

            ServiceLockStatus objLockStatus = new ServiceLockStatus();
            try
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_ServiceLockStatusSelect";//***
                    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@ApplicationID", System.Data.SqlDbType.VarChar).Value = ApplicationID;
                        cmd.Parameters.Add("@MethodName", System.Data.SqlDbType.VarChar).Value =MethodName;
                        cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = Session["EMPID"].ToString();

                        SqlParameter sqlRunning = new SqlParameter("@IsRunning", SqlDbType.Bit);
                        sqlRunning.Direction = ParameterDirection.InputOutput;
                        sqlRunning.Value = 0;
                        cmd.Parameters.Add(sqlRunning);

                        SqlParameter sqlMsg = new SqlParameter("@Msg", SqlDbType.VarChar, 250);
                        sqlMsg.Direction = ParameterDirection.InputOutput;
                        sqlMsg.Value = "";
                        cmd.Parameters.Add(sqlMsg);

                        cmd.Connection = conn;
                        conn.Open();

                        cmd.ExecuteNonQuery();


                        objLockStatus.Running = (bool)sqlRunning.Value;
                        objLockStatus.Msg = sqlMsg.Value.ToString();


                    }

                }
            }
            catch(Exception ex)
            {
                objLockStatus.Running = true;
                objLockStatus.Msg ="Please try again..";
            }

            return objLockStatus;
        }

        private void UpdateServiceLockStatus(string ApplicationID, string MethodName)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_ServiceLockStatusUpdate";//***
                    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@ApplicationID", System.Data.SqlDbType.VarChar).Value = ApplicationID;
                        cmd.Parameters.Add("@MethodName", System.Data.SqlDbType.VarChar).Value = MethodName;
                        cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = Session["EMPID"].ToString();

                        cmd.Connection = conn;
                        conn.Open();

                        cmd.ExecuteNonQuery();

                    }

                }
            }
            catch (Exception ex)
            {
              
            }
        }

        protected void gdvCancel_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string[] arg = new string[2];
            arg = e.CommandArgument.ToString().Split(';');

            if (e.CommandName.ToUpper() == "CANCELED")
            {
                ServiceLockStatus objLockStatus = new ServiceLockStatus();
                try
                {
                    objLockStatus = CheckServiceLockStatus("TfAPI", "ComplaintsInvoice");
                    if (!objLockStatus.Running)
                    {
                        GridViewRow row = (GridViewRow)((LinkButton)e.CommandSource).NamingContainer;
                        DropDownList ddlReqType = row.FindControl("ddlReqType") as DropDownList;
                        TextBox txtComment = ((TextBox)row.FindControl("txtComments"));
                        // string comments = ((TextBox)row.FindControl("txtComments")).Text.ToString();
                        ddlReqType.BackColor = System.Drawing.Color.White;
                        txtComment.BackColor = System.Drawing.Color.White;
                        if (ddlReqType.SelectedValue == "")
                        {
                            TrustControl1.ClientMsg("Please Select Cancel Code.");
                            ddlReqType.BackColor = System.Drawing.Color.Green;
                            return;
                        }
                        if (txtComment.Text == "")
                        {
                            TrustControl1.ClientMsg("Please entry Comments.");
                            txtComment.BackColor = System.Drawing.Color.Green;

                            return;
                        }


                      
                            TfWebService.TransfastService tfService = new TfWebService.TransfastService();
                            string downloadStatus = tfService.ComplaintsInvoice(long.Parse(arg[0]), ddlReqType.SelectedValue, txtComment.Text, Session["EMPID"].ToString(), getValueOfKey("Ria_KeyCode"));
                            if (downloadStatus == "1")
                                TrustControl1.ClientMsg("Order Cancel Request Created Successfully.");
                            else
                                TrustControl1.ClientMsg("Order Cancel Request Failed. Please try again..");
                      

                    }
                  
                }
                catch (Exception ex)
                {
                    Common.WriteLog("", "TfAPI", "ComplaintsInvoice UI", ex.Message);
                    TrustControl1.ClientMsg("Unable to connect to the remote Transfast API Server." + "Please contact with IT Network Team.");
                }
                finally
                {
                    UpdateServiceLockStatus("TfAPI", "ComplaintsInvoice");
                }
                gdvCancel.DataBind();
            }


        }

        protected void SqlDataSourceCancel_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            LabelCancel.Text = string.Format("Total Cancel Response Pending: <b>{0:N0}</b>", e.AffectedRows);
        }

        public string getValueOfKey(string KeyName)
        {
            try
            {
                return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
            }
            catch (Exception) { return string.Empty; }
        }

        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            Response.Redirect("RiaBankDeposit.aspx", true);
        }

        protected void btnAllOrder_Click(object sender, EventArgs e)
        {
            ServiceLockStatus objLockStatus = new ServiceLockStatus();
            try
            {
                objLockStatus = CheckServiceLockStatus("TfAPI", "TfDownloadAllInvoices");
                if (!objLockStatus.Running)
                {
                    TfWebService.TransfastService tfService = new TfWebService.TransfastService();

                    string downloadStatus = tfService.DownloadAllInvoices(Session["EMPID"].ToString(), chkBoxTrdParty.Checked, getValueOfKey("Tf_KeyCode"));

                    if (downloadStatus == "1")
                        TrustControl1.ClientMsg("Orders Downloaded Successfully.");
                    else if (downloadStatus == "5")
                        TrustControl1.ClientMsg("Orders Save failed to Remilist.");
                    else
                        TrustControl1.ClientMsg(downloadStatus);
                    // gdvOrdersReceived.DataBind();
                }
                else
                    TrustControl1.ClientMsg(objLockStatus.Msg);
            }
            catch (Exception ex)
            {
                Common.WriteLog("", "TfAPI", "TfDownloadAllInvoices UI", ex.Message);
            }
            finally
            {
                UpdateServiceLockStatus("TfAPI", "TfDownloadAllInvoices");
            }
        }
    }

    public struct ServiceLockStatus
    {
        public bool Running { get; set; }
        public string Msg { get; set; }
    }
}