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
    public partial class APIBankDeposit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            TrustControl1.getUserRoles();

            //if (!IsPostBack)
            //    RiaDashBoardStatusCount();
        }


        //protected void lbtnOrderDownload_Click(object sender, EventArgs e)
        //{
        //    ServiceLockStatus objLockStatus = new ServiceLockStatus();
        //    try
        //    {
        //        objLockStatus = CheckServiceLockStatus("Ria API", "BD_GetOrderForDownload");
        //        if (!objLockStatus.Running)
        //        {
        //            RiaFxWebService.RiaFxGlobalService fxService = new RiaFxWebService.RiaFxGlobalService();                    
        //            string downloadStatus = fxService.BD_GetOrderForDownload(Session["BRANCHID"].ToString().PadLeft(4, '0'), Session["BRANCHNAME"].ToString(), Session["EMPID"].ToString(), getValueOfKey("Ria_KeyCode"));
                    
        //            if (downloadStatus=="1")
        //                TrustControl1.ClientMsg("Order Downloaded Successfully.");
        //           else if (downloadStatus == "5")
        //                TrustControl1.ClientMsg("Have no Orders for Download.");
        //            else
        //                TrustControl1.ClientMsg("Order Download Failed. Please try again..");
        //            gdvOrdersReceived.DataBind();
        //        }
        //        else
        //            TrustControl1.ClientMsg(objLockStatus.Msg);
        //    }
        //    catch(Exception ex)
        //    { }
        //    finally
        //    {
        //        UpdateServiceLockStatus("Ria API", "BD_GetOrderForDownload");
        //    }

        //}
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
                    gdvCancel.DataBind(); //..
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


                        //litReceivedPending.Text = sqlReceivePending.Value.ToString();
                        //litCancelResponsePending.Text = sqlCancelPending.Value.ToString();
                        //litCancelAcceptedPending.Text = sqlCancelNotificationToRia.Value.ToString();
                        //litPaidPending.Text = sqlPaidPending.Value.ToString();
                        //litPublishPending.Text = sqlPublishedPending.Value.ToString();
                        //litRollBackPending.Text = sqlRollBackPending.Value.ToString();
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
                //   ServiceLockStatus objLockStatus = new ServiceLockStatus();
                int Done = 0;
                try
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        string Query = "s_API_BankDepositOrderReceive";//***
                        conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.CommandText = Query;
                            cmd.CommandType = System.Data.CommandType.StoredProcedure;

                            cmd.Parameters.Add("@SessionID", System.Data.SqlDbType.VarChar).Value = arg[0];
                            cmd.Parameters.Add("@Currency", System.Data.SqlDbType.VarChar).Value = arg[1];
                            cmd.Parameters.Add("@ExHouse", System.Data.SqlDbType.VarChar).Value = arg[2];
                            cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = Session["EMPID"].ToString();

                            SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Int);
                            sqlDone.Direction = ParameterDirection.InputOutput;
                            sqlDone.Value = 0;
                            cmd.Parameters.Add(sqlDone);

                            cmd.Connection = conn;
                            conn.Open();

                            cmd.ExecuteNonQuery();


                            Done = (int)sqlDone.Value;

                        }

                    }

                  
                        if (Done == 1)
                            TrustControl1.ClientMsg("Order Received Successfully.");
                        else
                            TrustControl1.ClientMsg("Order Received Failed. Please try again..");
                  
                }
                catch (Exception ex)
                {
                    Common.WriteLog("", "RDS API", "s_API_BankDepositOrderReceive", ex.Message);
                }
                //finally
                //{
                //    UpdateServiceLockStatus("Ria API", "BD_InputOrderStatusNoticesReceive");
                //}
                gdvOrdersReceived.DataBind();

                //TrustControl1.ClientMsg(Msg);
            }

            if (e.CommandName.ToUpper() == "REJECT")
            {
                //   ServiceLockStatus objLockStatus = new ServiceLockStatus();
                int Done = 0;
                try
                {
                    GridViewRow row = (GridViewRow)((LinkButton)e.CommandSource).NamingContainer;
                  
                    TextBox txtComment = ((TextBox)row.FindControl("txtOrderRejectReason"));
                   
                    txtComment.BackColor = System.Drawing.Color.White;
                 
                    if (txtComment.Text == "")
                    {
                        TrustControl1.ClientMsg("Please entry Reasons.");
                        txtComment.BackColor = System.Drawing.Color.Yellow;

                        return;
                    }

                    using (SqlConnection conn = new SqlConnection())
                    {
                        string Query = "s_API_BankDepositOrderReject";//***
                        conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.CommandText = Query;
                            cmd.CommandType = System.Data.CommandType.StoredProcedure;

                            cmd.Parameters.Add("@SessionID", System.Data.SqlDbType.VarChar).Value = arg[0];
                            cmd.Parameters.Add("@Currency", System.Data.SqlDbType.VarChar).Value = arg[1];
                            cmd.Parameters.Add("@ExHouse", System.Data.SqlDbType.VarChar).Value = arg[2];
                            cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = Session["EMPID"].ToString();
                            cmd.Parameters.Add("@Comments", System.Data.SqlDbType.VarChar).Value = txtComment.Text;

                            SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Int);
                            sqlDone.Direction = ParameterDirection.InputOutput;
                            sqlDone.Value = 0;
                            cmd.Parameters.Add(sqlDone);

                            cmd.Connection = conn;
                            conn.Open();

                            cmd.ExecuteNonQuery();


                            Done = (int)sqlDone.Value;

                        }

                    }


                    if (Done == 1)
                        TrustControl1.ClientMsg("Order Reject Successfully.");
                    else
                        TrustControl1.ClientMsg("Order Reject Failed. Please try again..");

                }
                catch (Exception ex)
                {
                    Common.WriteLog("", "RDS API", "s_API_BankDepositOrderReceive", ex.Message);
                }
                //finally
                //{
                //    UpdateServiceLockStatus("Ria API", "BD_InputOrderStatusNoticesReceive");
                //}
                gdvOrdersReceived.DataBind();

                //TrustControl1.ClientMsg(Msg);
            }

        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
           
        }

        protected void gdvOrdersReceived_SelectedIndexChanged(object sender, EventArgs e)
        {
            modal.Show();
        }

        private string CancelOrder(long SL,int StatusCode,string Comment)
        {
            string Msg = "Cancel not possible.";
      
            try
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_API_CancelOrderUpdate";//***
                    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@SL", System.Data.SqlDbType.VarChar).Value = SL;
                        cmd.Parameters.Add("@StatusCode", System.Data.SqlDbType.Int).Value = StatusCode;
                        cmd.Parameters.Add("@Comment", System.Data.SqlDbType.VarChar).Value = Comment;
                        cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = Session["EMPID"];
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


            if (e.CommandName.ToUpper() == "CANCELED")
            {
                //ServiceLockStatus objLockStatus = new ServiceLockStatus();
                try
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
                        ddlReqType.BackColor = System.Drawing.Color.Yellow;
                        return;
                    }
                    if (txtComment.Text == "")
                    {
                        TrustControl1.ClientMsg("Please entry Comments.");
                        txtComment.BackColor = System.Drawing.Color.Yellow;

                        return;
                    }
                    string cancelStatus = CancelOrder(long.Parse(e.CommandArgument.ToString()), int.Parse(ddlReqType.SelectedValue), txtComment.Text);
                    TrustControl1.ClientMsg(cancelStatus);
                    //string ChkCancel = CheckRIDCancellation(long.Parse(e.CommandArgument.ToString()), ddlReqType.SelectedValue);

                    //if (ChkCancel == "1")
                    //{
                    //    RiaFxWebService.RiaFxGlobalService fxService = new RiaFxWebService.RiaFxGlobalService();
                    //    string downloadStatus = fxService.BD_InputCancelRequestResponses(long.Parse(e.CommandArgument.ToString()), ddlReqType.SelectedValue, txtComment.Text, Session["BRANCHID"].ToString().PadLeft(4, '0'), Session["BRANCHNAME"].ToString(), Session["EMPID"].ToString(), getValueOfKey("Ria_KeyCode"));
                    //    if (downloadStatus == "1")
                    //        TrustControl1.ClientMsg("Order Cancel Successfully.");
                    //    else
                    //        TrustControl1.ClientMsg("Order Cancel Failed. Please try again..");
                    //}
                    //else
                    //    TrustControl1.ClientMsg(ChkCancel);



                }
                catch (Exception ex)
                { }
                finally
                {
                    //UpdateServiceLockStatus("Ria API", "BD_InputOrderStatusNoticesReceive");
                }
                gdvCancel.DataBind();//..
            }


        }

        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total Receive Pending: <b>{0:N0}</b>", e.AffectedRows);
        }

        protected void SqlDataSourceOrdersView_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblOrdersNo.Text = string.Format("Total Orders: <b>{0:N0}</b>", e.AffectedRows);
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

        protected void btnReceive_Click(object sender, EventArgs e)
        {
            string Msg = "";
            try
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_API_BDOrderReceiveExHouseWise";//***
                    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@ExHouse", System.Data.SqlDbType.VarChar).Value = cboExHouse.SelectedValue;
                        //cmd.Parameters.Add("@StatusCode", System.Data.SqlDbType.Int).Value = StatusCode;
                        //cmd.Parameters.Add("@Comment", System.Data.SqlDbType.VarChar).Value = Comment;
                        cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = Session["EMPID"];
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
                Msg = ex.Message;
            }

            gdvOrdersReceived.DataBind();
            TrustControl1.ClientMsg(Msg);
        }
    }

    public struct ServiceLockStatus
    {
        public bool Running { get; set; }
        public string Msg { get; set; }
    }
}