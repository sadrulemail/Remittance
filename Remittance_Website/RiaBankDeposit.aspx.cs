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
    public partial class RiaBankDeposit : System.Web.UI.Page
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
                objLockStatus = CheckServiceLockStatus("Ria API", "BD_GetOrderForDownload");
                if (!objLockStatus.Running)
                {
                    RiaFxWebService.RiaFxGlobalService fxService = new RiaFxWebService.RiaFxGlobalService();                    
                    string downloadStatus = fxService.BD_GetOrderForDownload(Session["BRANCHID"].ToString().PadLeft(4, '0'), Session["BRANCHNAME"].ToString(), Session["EMPID"].ToString(), getValueOfKey("Ria_KeyCode"));
                    
                    if (downloadStatus=="1")
                        TrustControl1.ClientMsg("Order Downloaded Successfully.");
                   else if (downloadStatus == "5")
                        TrustControl1.ClientMsg("Have no Orders for Download.");
                    else
                        TrustControl1.ClientMsg("Order Download Failed. Please try again..");
                    gdvOrdersReceived.DataBind();
                }
                else
                    TrustControl1.ClientMsg(objLockStatus.Msg);
            }
            catch(Exception ex)
            {
                Common.WriteLog("", "Ria API", "BD_GetOrderForDownload UI", ex.Message);
            }
            finally
            {
                UpdateServiceLockStatus("Ria API", "BD_GetOrderForDownload");
            }

        }
        protected void btnCancelOrder_Click(object sender, EventArgs e)
        {
            ServiceLockStatus objLockStatus = new ServiceLockStatus();
            try
            {
                objLockStatus = CheckServiceLockStatus("Ria API", "BD_GetCancelationRequests");
                if (!objLockStatus.Running)
                {
                    RiaFxWebService.RiaFxGlobalService fxService = new RiaFxWebService.RiaFxGlobalService();
                    string downloadStatus = fxService.BD_GetCancelationRequests(Session["BRANCHID"].ToString().PadLeft(4, '0'), Session["BRANCHNAME"].ToString(), Session["EMPID"].ToString(), getValueOfKey("Ria_KeyCode"));
                    if (downloadStatus == "1")
                        TrustControl1.ClientMsg("Cancel Pending Orders Downloaded Successfully.");
                    else if (downloadStatus == "5")
                        TrustControl1.ClientMsg("Have no Cancel Pending Orders for Downloading.");
                    else
                        TrustControl1.ClientMsg("Cancel Pending Orders Download Failed. Please try again..");
                    gdvCancel.DataBind();
                }
                else
                    TrustControl1.ClientMsg(objLockStatus.Msg);
            }
            catch (Exception ex)
            { Common.WriteLog("", "Ria API", "BD_GetCancelationRequests UI", ex.Message); }
            finally
            {
                Common.UpdateServiceLockStatus("Ria API", "BD_GetCancelationRequests", Session["EMPID"].ToString());
            }
        }

        private void RiaDashBoardStatusCount()
        {
 
            try
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_RiaDashBoardSelect";//***
                    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                      
                        SqlParameter sqlReceivePending = new SqlParameter("@ReceivePending", SqlDbType.Int, 50);
                        sqlReceivePending.Direction = ParameterDirection.InputOutput;
                        sqlReceivePending.Value = 0;
                        cmd.Parameters.Add(sqlReceivePending);

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

                        SqlParameter sqlRollBackPending = new SqlParameter("@RollBackPending", SqlDbType.Int, 50);
                        sqlRollBackPending.Direction = ParameterDirection.InputOutput;
                        sqlRollBackPending.Value = 0;
                        cmd.Parameters.Add(sqlRollBackPending);

                        cmd.Connection = conn;
                        conn.Open();

                        cmd.ExecuteNonQuery();


                        litReceivedPending.Text = sqlReceivePending.Value.ToString();
                        litCancelResponsePending.Text = sqlCancelPending.Value.ToString();
                        litCancelAcceptedPending.Text = sqlCancelNotificationToRia.Value.ToString();
                        litPaidPending.Text = sqlPaidPending.Value.ToString();
                        litPublishPending.Text = sqlPublishedPending.Value.ToString();
                        litRollBackPending.Text = sqlRollBackPending.Value.ToString();
                    }

                }


            }
            catch (Exception ex)
            {

            }
          
        }

        protected void gdvOrdersReceived_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            //if (e.CommandName.ToUpper() == "TRANSFER" && TrustControl1.isRole("ADMIN"))
            string[] arg = new string[2];
            arg = e.CommandArgument.ToString().Split(';');
            if (e.CommandName.ToUpper() == "RECEIVED")
            {
                ServiceLockStatus objLockStatus = new ServiceLockStatus();
                try
                {
                    objLockStatus = CheckServiceLockStatus("Ria API", "BD_InputOrderStatusNoticesReceive");
                    if (!objLockStatus.Running)
                    {
                        RiaFxWebService.RiaFxGlobalService fxService = new RiaFxWebService.RiaFxGlobalService();
                        string downloadStatus = fxService.BD_InputOrderStatusNoticesReceive(Session["BRANCHID"].ToString().PadLeft(4, '0'), Session["BRANCHNAME"].ToString(), arg[1], arg[0],Session["EMPID"].ToString(), getValueOfKey("Ria_KeyCode"));
                        if (downloadStatus == "1")
                            TrustControl1.ClientMsg("Order Received Successfully.");
                        else
                            TrustControl1.ClientMsg("Order Received Failed. Please try again..");
                    }
                    else
                        TrustControl1.ClientMsg(objLockStatus.Msg);
                }
                catch (Exception ex)
                {
                    Common.WriteLog("", "Ria API", "BD_InputOrderStatusNoticesReceive UI", ex.Message);
                }
                finally
                {
                    UpdateServiceLockStatus("Ria API", "BD_InputOrderStatusNoticesReceive");
                }
                gdvOrdersReceived.DataBind();

                //TrustControl1.ClientMsg(Msg);
            }

          
        }

    private string CheckRIDCancellation(long RID,string TypeCode)
        {
            string Msg = "Cancel not possible.";
      
            try
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_Ria_CheckRIDforCancel";//***
                    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@RID", System.Data.SqlDbType.VarChar).Value = RID;
                        cmd.Parameters.Add("@TypeCode", System.Data.SqlDbType.VarChar).Value = TypeCode;

                        SqlParameter sqlMsg = new SqlParameter("@Msg", SqlDbType.VarChar, 250);
                        sqlMsg.Direction = ParameterDirection.InputOutput;
                        sqlMsg.Value = "";
                        cmd.Parameters.Add(sqlMsg);

                        cmd.Connection = conn;
                        conn.Open();

                        cmd.ExecuteNonQuery();

                     
                        Msg = sqlMsg.Value.ToString();
                    }

                }
             

            }
            catch (Exception ex)
            {

            }
            return Msg;
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
                    objLockStatus = CheckServiceLockStatus("Ria API", "BD_InputCancelRequestResponses");
                    if (!objLockStatus.Running)
                    {
                        GridViewRow row = (GridViewRow)((LinkButton)e.CommandSource).NamingContainer;
                       DropDownList ddlReqType = row.FindControl("ddlReqType") as DropDownList;
                        TextBox txtComment = ((TextBox)row.FindControl("txtComments"));
                       // string comments = ((TextBox)row.FindControl("txtComments")).Text.ToString();
                        ddlReqType.BackColor = System.Drawing.Color.White;
                        txtComment.BackColor = System.Drawing.Color.White;
                        if (ddlReqType.SelectedValue=="")
                        {
                            TrustControl1.ClientMsg("Please Select Cancel Code.");
                            ddlReqType.BackColor=System.Drawing.Color.Green;
                            return;
                        }
                        if (txtComment.Text == "")
                        {
                            TrustControl1.ClientMsg("Please entry Comments.");
                            txtComment.BackColor= System.Drawing.Color.Green; 
                         
                            return;
                        }

                        if (arg[0].ToString() == "")
                        {
                            if (ddlReqType.SelectedValue != "1000")
                            {
                                RiaFxWebService.RiaFxGlobalService fxService = new RiaFxWebService.RiaFxGlobalService();
                                string downloadStatus = fxService.BD_InputCancelRequestResponsesOrderWise(arg[1], ddlReqType.SelectedValue, txtComment.Text, Session["BRANCHID"].ToString().PadLeft(4, '0'), Session["BRANCHNAME"].ToString(), Session["EMPID"].ToString(), getValueOfKey("Ria_KeyCode"));
                                if (downloadStatus == "1")
                                    TrustControl1.ClientMsg("Order Reject Successfully.");
                                else
                                    TrustControl1.ClientMsg("Order Reject Failed. Please try again..");
                            }
                            else
                                TrustControl1.ClientMsg("Accepted not allow. Only Rejected allow.");

                        }
                        else
                        {
                            string ChkCancel = CheckRIDCancellation(long.Parse(arg[0]), ddlReqType.SelectedValue);

                            //  if ((ChkCancel == "1" && ddlReqType.SelectedValue == "1000") || ddlReqType.SelectedValue != "1000")
                            if (ChkCancel == "1")
                            {
                                RiaFxWebService.RiaFxGlobalService fxService = new RiaFxWebService.RiaFxGlobalService();
                                string downloadStatus = fxService.BD_InputCancelRequestResponses(long.Parse(arg[0]), ddlReqType.SelectedValue, txtComment.Text, Session["BRANCHID"].ToString().PadLeft(4, '0'), Session["BRANCHNAME"].ToString(), Session["EMPID"].ToString(), getValueOfKey("Ria_KeyCode"));
                                if (downloadStatus == "1")
                                    TrustControl1.ClientMsg("Order Cancel Successfully.");
                                else
                                    TrustControl1.ClientMsg("Order Cancel Failed. Please try again..");
                            }
                            else
                                TrustControl1.ClientMsg(ChkCancel);
                        }
                    }
                    else
                        TrustControl1.ClientMsg(objLockStatus.Msg);
                }
                catch (Exception ex)
                {
                    Common.WriteLog("", "Ria API", "BD_InputCancelRequestResponses UI", ex.Message);
                    TrustControl1.ClientMsg("Unable to connect to the remote Ria API Server." + "Please contact with IT Network Team.");
                }
                finally
                {
                    UpdateServiceLockStatus("Ria API", "BD_InputCancelRequestResponses");
                }
                gdvCancel.DataBind();
            }


        }

        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total Receive Pending: <b>{0:N0}</b>", e.AffectedRows);
        }

        protected void SqlDataSourceCancel_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            LabelCancel.Text = string.Format("Total Cancel Response Pending: <b>{0:N0}</b>", e.AffectedRows);
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
    }

    public struct ServiceLockStatus
    {
        public bool Running { get; set; }
        public string Msg { get; set; }
    }
}