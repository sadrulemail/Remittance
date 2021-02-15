using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Web.Http;
using System.Web.Mvc;
using TrustRDSAPI.Authorization;
using TrustRDSAPI.Filters;
using TrustRDSAPI.Models;

namespace TrustRDSAPI.Controllers
{
    // [AllowAnonymous]

   [BasicAuthentication]
    //[RequireHttps]
    public class PaymentsController : ApiController
    {
       
        [System.Web.Http.HttpPost] 
       public HttpResponseMessage PostBankDepositOrders([FromBody] Models.BankDepositOrder [] orders)
        {
            DateTime startDate = DateTime.Now;
            string InsertBy = Thread.CurrentPrincipal.Identity.Name;
           string sessionID= SaveBulkBankDepositDownload(orders, InsertBy);
            if (sessionID == "")
                return Request.CreateResponse(HttpStatusCode.BadRequest, "Bad request,Pls try again");
           else if (sessionID== "2627")
                return Request.CreateResponse(HttpStatusCode.BadRequest, "Same orderid not allowed, Pls try again");
            else if (sessionID == "DBNull")
                return Request.CreateResponse(HttpStatusCode.BadRequest, "Mandatory value required,Pls try again");
           else
            {
                List<BankDepositOrderResponse> OrderList = new List<BankDepositOrderResponse>();
             
                try
                {
                    DataTable OrderResponse = GetBankDepositResponse(sessionID, startDate);
                    if (OrderResponse.Rows.Count > 0)
                    {
                        OrderList = (from DataRow dr in OrderResponse.Rows
                                     select new BankDepositOrderResponse()
                                     {
                                         RefID = dr["RefID"].ToString(),
                                         ExHouseCode = dr["ExHouseCode"].ToString(),
                                         OrderID = dr["OrderID"].ToString(),
                                         ReceiverAmount =double.Parse( dr["ReceiverAmount"].ToString()==""?"0": dr["ReceiverAmount"].ToString()),
                                         ReceiverCurrencyCode = dr["ReceiverCurrencyCode"].ToString(),
                                         StatusCode = dr["OrderStatusCode"].ToString(),
                                         StatusDesc = dr["StatusDescription"].ToString()
                                     }).ToList();

                        return Request.CreateResponse(HttpStatusCode.Created, OrderList);
                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.InternalServerError, "InternalServerError,Try Again");
                    }
                }
                catch(Exception ex)
                {
                    Common.WriteLog(sessionID, "RDS API", "GetBankDepositResponse", ex.Message);
                    return Request.CreateResponse(HttpStatusCode.InternalServerError, "InternalServerError,Try Again");
                }
                //finally
                //{
                //    OrderList.ToArray;
                //}

            }
            //else
            //    return Request.CreateResponse(HttpStatusCode.BadRequest, "Bad request,Pls try again");
        }

        private string SaveBulkBankDepositDownload(BankDepositOrder[] orders, string InsertBy )
        {
            string SessionID = RandomString(11); //Guid.NewGuid().ToString();// RandomString(11);
         
            DataTable dt_mtr = new DataTable();
            dt_mtr.Columns.Add("SL", typeof(long));
            dt_mtr.Columns.Add("OrderID", typeof(string));
            dt_mtr.Columns.Add("RefID", typeof(string));
            dt_mtr.Columns.Add("ExHouseCode", typeof(string));
            dt_mtr.Columns.Add("SenderName", typeof(string));
            dt_mtr.Columns.Add("SenderCountryCode", typeof(string));
            dt_mtr.Columns.Add("SenderEmail", typeof(string));
            dt_mtr.Columns.Add("SenderMobile", typeof(string));
            dt_mtr.Columns.Add("SenderCurrencyCode", typeof(string));
            dt_mtr.Columns.Add("SenderAmount", typeof(decimal));


            dt_mtr.Columns.Add("ReceiverName", typeof(string));
            dt_mtr.Columns.Add("ReceiverAddress", typeof(string));
            dt_mtr.Columns.Add("ReceiverMobile", typeof(string));
            dt_mtr.Columns.Add("ReceiverEmail", typeof(string));

            dt_mtr.Columns.Add("RoutingCode", typeof(string));
            dt_mtr.Columns.Add("BankCode", typeof(string));
            dt_mtr.Columns.Add("AccountNumber", typeof(string));
            dt_mtr.Columns.Add("ReceiverCurrencyCode", typeof(string));

            dt_mtr.Columns.Add("ReceiverAmount", typeof(decimal));
            dt_mtr.Columns.Add("ReceiverIDType", typeof(string));
            dt_mtr.Columns.Add("ReceiverIDNumber", typeof(string));
            dt_mtr.Columns.Add("Purpose", typeof(string));
            dt_mtr.Columns.Add("SessionID", typeof(string));
            dt_mtr.Columns.Add("InsertBy", typeof(string));
            dt_mtr.Columns.Add("InsertDT", typeof(DateTime));
            dt_mtr.Columns.Add("ApiCallID", typeof(string));
            try
            {
              



                foreach (BankDepositOrder order in orders)
                {
                  
                    dt_mtr.Rows.Add(null, order.OrderID==""?null: order.OrderID, RandomString(11), InsertBy, order.SenderName==""?null: order.SenderName, order.SenderCountryCode==""?null: order.SenderCountryCode,
                       order.SenderEmail,order.SenderMobile,order.SenderCurrencyCode==""?null: order.SenderCurrencyCode, order.SenderAmount,order.ReceiverName==""?null: order.ReceiverName,
                       order.ReceiverAddress==""?null: order.ReceiverAddress, order.ReceiverMobile,order.ReceiverEmail,order.RoutingCode==""?null: order.RoutingCode, null,
                       order.AccountNumber==""?null: order.AccountNumber, order.ReceiverCurrencyCode==""?null: order.ReceiverCurrencyCode, order.ReceiverAmount<=0?null: order.ReceiverAmount, order.ReceiverIDType,
                       order.ReceiverIDNumber,order.Purpose, SessionID, InsertBy, DateTime.Now,order.ApiCallID);
                   
                }

                if (dt_mtr.Rows.Count > 0)
                {
                    string connString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                    // open the destination data
                    using (SqlConnection destinationConnection = new SqlConnection(connString))
                    {
                        // open the connection
                        destinationConnection.Open();
                        using (SqlBulkCopy bulkCopy =
                             new SqlBulkCopy(destinationConnection.ConnectionString,
                                    SqlBulkCopyOptions.TableLock))
                        {
                            bulkCopy.BulkCopyTimeout = 0;
                            bulkCopy.DestinationTableName = "RemiListAPI_Temp";
                            bulkCopy.WriteToServer(dt_mtr);
                        }

                    }

                }
                else
                    SessionID = "";

            }
            catch (SqlException Ex)
            {
                if (Ex.Number == 2627)
                {
                    SessionID = "2627"; //same orderid not allowed
                }
                else
                    SessionID = "";
                Common.WriteLog(SessionID, "RDS API", "RemiListAPI_Temp", Ex.Message);
            }
         
            catch (Exception ex)
            {
                if(ex.Message.Contains("does not allow DBNull.Value"))
                    SessionID = "DBNull"; // mandatory value required
                else
                SessionID = "";
             
                Common.WriteLog(SessionID, "RDS API", "RemiListAPI_Temp", ex.Message);
            }
           
            return SessionID;
        }

        [System.Web.Http.HttpPost]
        public HttpResponseMessage PostCashPickupOrders([FromBody] Models.CashPickupOrder[] orders)
        {
            DateTime startDate = DateTime.Now;
            string InsertBy = Thread.CurrentPrincipal.Identity.Name;
            string sessionID = SaveBulkCashPickupOrder(orders, InsertBy);
            if (sessionID == "")
                return Request.CreateResponse(HttpStatusCode.BadRequest, "Bad request,Pls try again");
            else if (sessionID == "2627")
                return Request.CreateResponse(HttpStatusCode.BadRequest, "Same orderid not allowed, Pls try again");
            else if (sessionID == "DBNull")
                return Request.CreateResponse(HttpStatusCode.BadRequest, "Mandatory value required,Pls try again");
            else
            {
                List<BankDepositOrderResponse> OrderList = new List<BankDepositOrderResponse>();

                try
                {
                    DataTable OrderResponse = GetCashPickupResponse(sessionID, startDate);
                    if (OrderResponse.Rows.Count > 0)
                    {
                        OrderList = (from DataRow dr in OrderResponse.Rows
                                     select new BankDepositOrderResponse()
                                     {
                                         RefID = dr["RefID"].ToString(),
                                         ExHouseCode = dr["ExHouseCode"].ToString(),
                                         OrderID = dr["OrderID"].ToString(),
                                         ReceiverAmount = double.Parse(dr["ReceiverAmount"].ToString() == "" ? "0" : dr["ReceiverAmount"].ToString()),
                                         ReceiverCurrencyCode = dr["ReceiverCurrencyCode"].ToString(),
                                         StatusCode = dr["OrderStatusCode"].ToString(),
                                         StatusDesc = dr["StatusDescription"].ToString()
                                     }).ToList();

                        return Request.CreateResponse(HttpStatusCode.Created, OrderList);
                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.InternalServerError, "InternalServerError,Try Again");
                    }
                }
                catch (Exception ex)
                {
                    Common.WriteLog(sessionID, "RDS API", "GetBankDepositResponse", ex.Message);
                    return Request.CreateResponse(HttpStatusCode.InternalServerError, "InternalServerError,Try Again");
                }
                //finally
                //{
                //    OrderList.ToArray;
                //}

            }
            //else
            //    return Request.CreateResponse(HttpStatusCode.BadRequest, "Bad request,Pls try again");
        }

        private string SaveBulkCashPickupOrder(CashPickupOrder[] orders, string InsertBy)
        {
            string SessionID = RandomString(11); //Guid.NewGuid().ToString();// RandomString(11);

            DataTable dt_mtr = new DataTable();
            dt_mtr.Columns.Add("SL", typeof(long));
            dt_mtr.Columns.Add("OrderID", typeof(string));
            dt_mtr.Columns.Add("RefID", typeof(string));
            dt_mtr.Columns.Add("ExHouseCode", typeof(string));
            dt_mtr.Columns.Add("SenderName", typeof(string));
            dt_mtr.Columns.Add("SenderCountryCode", typeof(string));
            dt_mtr.Columns.Add("SenderEmail", typeof(string));
            dt_mtr.Columns.Add("SenderMobile", typeof(string));
            dt_mtr.Columns.Add("SenderCurrencyCode", typeof(string));
            dt_mtr.Columns.Add("SenderAmount", typeof(decimal));


            dt_mtr.Columns.Add("ReceiverName", typeof(string));
            dt_mtr.Columns.Add("ReceiverAddress", typeof(string));
            dt_mtr.Columns.Add("ReceiverMobile", typeof(string));
            dt_mtr.Columns.Add("ReceiverEmail", typeof(string));
            dt_mtr.Columns.Add("PIN", typeof(string));
         
            dt_mtr.Columns.Add("ReceiverCurrencyCode", typeof(string));

            dt_mtr.Columns.Add("ReceiverAmount", typeof(decimal));
            dt_mtr.Columns.Add("ReceiverIDType", typeof(string));
            dt_mtr.Columns.Add("ReceiverIDNumber", typeof(string));
            dt_mtr.Columns.Add("Purpose", typeof(string));
            dt_mtr.Columns.Add("SessionID", typeof(string));
            dt_mtr.Columns.Add("InsertBy", typeof(string));
            dt_mtr.Columns.Add("InsertDT", typeof(DateTime));
            dt_mtr.Columns.Add("ApiCallID", typeof(string));
            try
            {




                foreach (CashPickupOrder order in orders)
                {

                    dt_mtr.Rows.Add(null, order.OrderID == "" ? null : order.OrderID, RandomString(11), InsertBy, order.SenderName == "" ? null : order.SenderName, order.SenderCountryCode == "" ? null : order.SenderCountryCode,
                       order.SenderEmail, order.SenderMobile, order.SenderCurrencyCode == "" ? null : order.SenderCurrencyCode, order.SenderAmount, order.ReceiverName == "" ? null : order.ReceiverName,
                       order.ReceiverAddress == "" ? null : order.ReceiverAddress, order.ReceiverMobile, order.ReceiverEmail, order.PIN == "" ? null : order.PIN,
                       order.ReceiverCurrencyCode == "" ? null : order.ReceiverCurrencyCode, order.ReceiverAmount <= 0 ? null : order.ReceiverAmount, order.ReceiverIDType,
                       order.ReceiverIDNumber, order.Purpose, SessionID, InsertBy, DateTime.Now,order.ApiCallID);

                }

                if (dt_mtr.Rows.Count > 0)
                {
                    string connString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                    // open the destination data
                    using (SqlConnection destinationConnection = new SqlConnection(connString))
                    {
                        // open the connection
                        destinationConnection.Open();
                        using (SqlBulkCopy bulkCopy =
                             new SqlBulkCopy(destinationConnection.ConnectionString,
                                    SqlBulkCopyOptions.TableLock))
                        {
                            bulkCopy.BulkCopyTimeout = 0;
                            bulkCopy.DestinationTableName = "RemiListCashPickupAPI_Temp";
                            bulkCopy.WriteToServer(dt_mtr);
                        }

                    }

                }
                else
                    SessionID = "";

            }
            catch (SqlException Ex)
            {
                if (Ex.Number == 2627)
                {
                    SessionID = "2627"; //same orderid not allowed
                }
                else
                    SessionID = "";
                Common.WriteLog(SessionID, "RDS API", "RemiListAPI_Temp", Ex.Message);
            }

            catch (Exception ex)
            {
                if (ex.Message.Contains("does not allow DBNull.Value"))
                    SessionID = "DBNull"; // mandatory value required
                else
                    SessionID = "";

                Common.WriteLog(SessionID, "RDS API", "RemiListAPI_Temp", ex.Message);
            }

            return SessionID;
        }

        private DataTable GetCashPickupResponse(string SessionID, DateTime startDT)
        {
            DataTable RemilistDT = new DataTable();
            try
            {
                //
                using (SqlDataAdapter da = new SqlDataAdapter())
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        string Query = "s_Api_CashPickupResponse";//***
                        conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.CommandText = Query;
                            cmd.CommandType = System.Data.CommandType.StoredProcedure;
                            cmd.Parameters.Add("@SessionID", System.Data.SqlDbType.VarChar).Value = SessionID;
                            cmd.Parameters.Add("@StartDT", System.Data.SqlDbType.DateTime).Value = startDT;

                            cmd.Connection = conn;
                            conn.Open();
                            da.SelectCommand = cmd;
                            da.Fill(RemilistDT);

                        }

                    }
                }
                //
            }
            catch (Exception ex)
            {
                Common.WriteLog(SessionID, "RDS API", "s_Api_CashPickupResponse", ex.Message);
            }
            return RemilistDT;
        }

        private DataTable GetBankDepositResponse(string SessionID,DateTime startDT)
        {
            DataTable RemilistDT = new DataTable();
            try
            {
                //
                using (SqlDataAdapter da = new SqlDataAdapter())
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        string Query = "s_Api_BankDepositResponse";//***
                        conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.CommandText = Query;
                            cmd.CommandType = System.Data.CommandType.StoredProcedure;
                            cmd.Parameters.Add("@SessionID", System.Data.SqlDbType.VarChar).Value = SessionID;
                            cmd.Parameters.Add("@StartDT", System.Data.SqlDbType.DateTime).Value = startDT;

                            cmd.Connection = conn;
                            conn.Open();
                            da.SelectCommand = cmd;
                            da.Fill(RemilistDT);

                        }

                    }
                }
                //
            }
            catch (Exception ex)
            {
                Common.WriteLog(SessionID, "RDS API", "s_Api_BankDepositResponse", ex.Message);
            }
            return RemilistDT;
        }

        private DataTable GetOrderCancelResponse(string SessionID, DateTime startDT)
        {
            DataTable RemilistDT = new DataTable();
            try
            {
                //
                using (SqlDataAdapter da = new SqlDataAdapter())
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        string Query = "s_Api_OrderCancelResponse";//***
                        conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.CommandText = Query;
                            cmd.CommandType = System.Data.CommandType.StoredProcedure;
                            cmd.Parameters.Add("@SessionID", System.Data.SqlDbType.VarChar).Value = SessionID;
                            cmd.Parameters.Add("@StartDT", System.Data.SqlDbType.DateTime).Value = startDT;

                            cmd.Connection = conn;
                            conn.Open();
                            da.SelectCommand = cmd;
                            da.Fill(RemilistDT);

                        }

                    }
                }
                //
            }
            catch (Exception ex)
            {
                Common.WriteLog(SessionID, "RDS API", "s_Api_BdOrderCancelResponse", ex.Message);
            }
            return RemilistDT;
        }

        private DataTable UpdateOrderInfoResponse(string RefID, string OrderID,string AccNo, string AccName, string RoutingNo, DateTime startDT, string ExHouseCode,string PaymentMethod,string ApiCallID)
        {
            DataTable RemilistDT = new DataTable();
            try
            {
                //
                using (SqlDataAdapter da = new SqlDataAdapter())
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        string Query = "s_Api_OrderInfoUpdate";//***
                        conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.CommandText = Query;
                            cmd.CommandType = System.Data.CommandType.StoredProcedure;
                            cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                            cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = OrderID;
                            cmd.Parameters.Add("@AccName", System.Data.SqlDbType.VarChar).Value = AccName;
                            cmd.Parameters.Add("@AccNo", System.Data.SqlDbType.VarChar).Value = AccNo;
                            cmd.Parameters.Add("@RoutingNo", System.Data.SqlDbType.VarChar).Value = RoutingNo;
                            cmd.Parameters.Add("@StartDT", System.Data.SqlDbType.DateTime).Value = startDT;
                            cmd.Parameters.Add("@ExHouseCode", System.Data.SqlDbType.VarChar).Value = ExHouseCode;
                            cmd.Parameters.Add("@PaymentMethod", System.Data.SqlDbType.VarChar).Value = PaymentMethod;
                            cmd.Parameters.Add("@ApiCallID", System.Data.SqlDbType.VarChar).Value = ApiCallID;

                            cmd.Connection = conn;
                            conn.Open();
                            da.SelectCommand = cmd;
                            da.Fill(RemilistDT);

                        }

                    }
                }
                //
            }
            catch (Exception ex)
            {
                Common.WriteLog(RefID, "RDS API", "s_Api_OrderInfoUpdate", ex.Message);
            }
            return RemilistDT;
        }

        private DataTable GetOrderStatusApi(string SessionID, string RefIDs, DateTime startDT, string ExHouseCode)
        {
            DataTable RemilistDT = new DataTable();
            try
            {
                //
                using (SqlDataAdapter da = new SqlDataAdapter())
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        string Query = "s_Api_GetOrdersStatus";//***
                        conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.CommandText = Query;
                            cmd.CommandType = System.Data.CommandType.StoredProcedure;
                            cmd.Parameters.Add("@SessionID", System.Data.SqlDbType.VarChar).Value = SessionID;
                            cmd.Parameters.Add("@RefIDs", System.Data.SqlDbType.VarChar).Value = RefIDs;
                            cmd.Parameters.Add("@StartDT", System.Data.SqlDbType.DateTime).Value = startDT;
                            cmd.Parameters.Add("@ExHouseCode", System.Data.SqlDbType.VarChar).Value = ExHouseCode;

                            cmd.Connection = conn;
                            conn.Open();
                            da.SelectCommand = cmd;
                            da.Fill(RemilistDT);

                        }

                    }
                }
                //
            }
            catch (Exception ex)
            {
                Common.WriteLog(SessionID, "RDS API", "s_Api_GetOrdersStatus", ex.Message);
            }
            return RemilistDT;
        }

        private DataTable GetCancelOrderStatusApi(string SessionID, string CancelRefIDs, DateTime startDT, string ExHouseCode)
        {
            DataTable RemilistDT = new DataTable();
            try
            {
                //
                using (SqlDataAdapter da = new SqlDataAdapter())
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        string Query = "s_Api_GetCancelOrdersStatus";//***
                        conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.CommandText = Query;
                            cmd.CommandType = System.Data.CommandType.StoredProcedure;
                            cmd.Parameters.Add("@SessionID", System.Data.SqlDbType.VarChar).Value = SessionID; 
                            cmd.Parameters.Add("@CancelRefIDs", System.Data.SqlDbType.VarChar).Value = CancelRefIDs;
                            cmd.Parameters.Add("@StartDT", System.Data.SqlDbType.DateTime).Value = startDT;
                            cmd.Parameters.Add("@ExHouseCode", System.Data.SqlDbType.VarChar).Value = ExHouseCode;

                            cmd.Connection = conn;
                            conn.Open();
                            da.SelectCommand = cmd;
                            da.Fill(RemilistDT);

                        }

                    }
                }
                //
            }
            catch (Exception ex)
            {
                Common.WriteLog(SessionID, "RDS API", "s_Api_GetCancelOrdersStatus", ex.Message);
            }
            return RemilistDT;
        }

        private DataTable GetReturnOrderStatusApi(string SessionID, DateTime startDT, string ExHouseCode)
        {
            DataTable RemilistDT = new DataTable();
            try
            {
                //
                using (SqlDataAdapter da = new SqlDataAdapter())
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        string Query = "s_Api_GetReturnOrdersStatus";//***
                        conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.CommandText = Query;
                            cmd.CommandType = System.Data.CommandType.StoredProcedure;
                            cmd.Parameters.Add("@SessionID", System.Data.SqlDbType.VarChar).Value = SessionID;
                            cmd.Parameters.Add("@StartDT", System.Data.SqlDbType.DateTime).Value = startDT;
                            cmd.Parameters.Add("@ExHouseCode", System.Data.SqlDbType.VarChar).Value = ExHouseCode;

                            cmd.Connection = conn;
                            conn.Open();
                            da.SelectCommand = cmd;
                            da.Fill(RemilistDT);

                        }

                    }
                }
                //
            }
            catch (Exception ex)
            {
                Common.WriteLog(SessionID, "RDS API", "s_Api_GetCancelOrdersStatus", ex.Message);
            }
            return RemilistDT;
        }

        private Random random = new Random();

        private string RandomString(int length)
        {

            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
          
            return new string(Enumerable.Repeat(chars, length)
              .Select(s => s[random.Next(s.Length)]).ToArray());
        }

        [System.Web.Http.HttpPost]
        //[System.Web.Http.ActionName("XMLMethod")]
        public HttpResponseMessage CancelOrdersRequest([FromBody] Models.BankDepositOrdersCancel[] orders)
     //   public HttpResponseMessage BankDepositOrderCancel([FromBody] Models.BankDepositOrdersCancel[] orders)
        {
            DateTime startDate = DateTime.Now;
            string ExHouse = Thread.CurrentPrincipal.Identity.Name;
            string sessionID = SaveBulkOrdersCancel(orders, ExHouse);
            if (sessionID != "")
            {
                List<OrdersCancelResponse> OrderList = new List<OrdersCancelResponse>();

                try
                {
                    DataTable OrderResponse = GetOrderCancelResponse(sessionID, startDate);
                    if (OrderResponse.Rows.Count > 0)
                    {
                        OrderList = (from DataRow dr in OrderResponse.Rows
                                     select new OrdersCancelResponse()
                                     {
                                         CancelRefID = dr["SL"].ToString(),
                                         RefID = dr["RefID"].ToString(),
                                         ExHouseCode = dr["ExHouse"].ToString(),
                                         OrderID = dr["OrderID"].ToString(),
                                         StatusCode = dr["OrderStatusCode"].ToString(),
                                         StatusDesc = dr["StatusDescription"].ToString()
                                     }).ToList();

                        return Request.CreateResponse(HttpStatusCode.Created, OrderList);
                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.BadRequest, "Order Not Found");
                    }
                }
                catch (Exception ex)
                {
                    Common.WriteLog(sessionID, "RDS API", "GetBankDepositResponse", ex.Message);
                    return Request.CreateResponse(HttpStatusCode.InternalServerError, "InternalServerError,Try Again");
                }
                //finally
                //{
                //    OrderList.ToArray;
                //}

            }
            else
                return Request.CreateResponse(HttpStatusCode.BadRequest, "Bad request,Pls try again");
        }

        private string SaveBulkOrdersCancel(BankDepositOrdersCancel[] orders, string ExHouse)
        {
            string SessionID = RandomString(12); //Guid.NewGuid().ToString();// RandomString(11);
                                                 //  string ExHouseCode = "LULUAPI";
            //int IsSave = 0;
            DataTable dt_mtr = new DataTable();
            dt_mtr.Columns.Add("SL", typeof(long));
            dt_mtr.Columns.Add("SessionID", typeof(string));
            dt_mtr.Columns.Add("RefID", typeof(string));
            dt_mtr.Columns.Add("OrderID", typeof(string));
            dt_mtr.Columns.Add("ExHouseCode", typeof(string)); 
            dt_mtr.Columns.Add("ApiCallID", typeof(string));

            try
            {
                
                foreach (BankDepositOrdersCancel order in orders)
                {

                    dt_mtr.Rows.Add(null,SessionID, order.RefID, order.OrderID,  ExHouse, order.ApiCallID);

                }

                if (dt_mtr.Rows.Count > 0)
                {
                    string connString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                    // open the destination data
                    using (SqlConnection destinationConnection = new SqlConnection(connString))
                    {
                        // open the connection
                        destinationConnection.Open();
                        using (SqlBulkCopy bulkCopy =
                             new SqlBulkCopy(destinationConnection.ConnectionString,
                                    SqlBulkCopyOptions.TableLock))
                        {
                            bulkCopy.BulkCopyTimeout = 0;
                            bulkCopy.DestinationTableName = "BankDepositOrderCancelAPI_Temp";
                            bulkCopy.WriteToServer(dt_mtr);
                        }

                    }
                   
                }

            }
            catch (Exception ex)
            {
                SessionID = "";
               
                Common.WriteLog(SessionID, "RDS API", "BankDepositOrderCancelAPI_Temp", ex.Message);
            }

            return SessionID;
        }

        private DataTable GetOrdersCancelResponse(string SessionID, DateTime startDT)
        {
            DataTable RemilistDT = new DataTable();
            try
            {
                //
                using (SqlDataAdapter da = new SqlDataAdapter())
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        string Query = "s_Api_OrderCancelResponse";//***
                        conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.CommandText = Query;
                            cmd.CommandType = System.Data.CommandType.StoredProcedure;
                            cmd.Parameters.Add("@SessionID", System.Data.SqlDbType.VarChar).Value = SessionID;
                            cmd.Parameters.Add("@StartDT", System.Data.SqlDbType.DateTime).Value = startDT;

                            cmd.Connection = conn;
                            conn.Open();
                            da.SelectCommand = cmd;
                            da.Fill(RemilistDT);

                        }

                    }
                }
                //
            }
            catch (Exception ex)
            {
                Common.WriteLog(SessionID, "RDS API", "s_Api_BdOrderCancelResponse", ex.Message);
            }
            return RemilistDT;
        }

        //[System.Web.Http.HttpPost]
        //[System.Web.Http.ActionName("XMLMethod")]
        //public string PostData([FromBody]object value)
        //{
        //    return "";
        //}

        [System.Web.Http.HttpPost]
        //[System.Web.Http.ActionName("XMLMethod")]

        public HttpResponseMessage GetOrdersStatus([FromBody] Models.OrdersStatus[] orders)
        {
            DateTime startDate = DateTime.Now;
            string ExHouse = Thread.CurrentPrincipal.Identity.Name;

            StringBuilder sbCancelRefID = new StringBuilder();
            String delimiter = "";
            foreach (OrdersStatus order in orders)
            {
                sbCancelRefID.Append(delimiter).Append(order.RefID);
                delimiter = ",";

            }

            //tring a= sb.ToString();

            string sessionID = RandomString(12);
            List<OrdersStatusResponse> OrderList = new List<OrdersStatusResponse>();

            try
            {
                DataTable OrderResponse = GetOrderStatusApi(sessionID, sbCancelRefID.ToString(), startDate, ExHouse);
                if (OrderResponse.Rows.Count > 0)
                {
                    OrderList = (from DataRow dr in OrderResponse.Rows
                                 select new OrdersStatusResponse()
                                 {
                                   
                                     RefID = dr["RefID"].ToString(),
                                     ExHouseCode = dr["ExHouseCode"].ToString(),
                                     OrderID = dr["OrderID"].ToString(),
                                     ReceiverCurrencyCode = dr["Currency"].ToString(),
                                     ReceiverAmount = double.Parse( dr["Amount"].ToString()==""?"0": dr["Amount"].ToString()),
                                     AccountNumber = dr["Account"].ToString(),
                                     ReceiverName = dr["BeneficiaryName"].ToString(),
                                     RoutingCode = dr["RoutingNumber"].ToString(),
                                     StatusCode = dr["StatusCode"].ToString(),
                                     StatusDesc = dr["StatusDescription"].ToString()
                                 }).ToList();

                    return Request.CreateResponse(HttpStatusCode.OK, OrderList);
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.InternalServerError, "InternalServerError,Try Again");
                }
            }
            catch (Exception ex)
            {
                Common.WriteLog(sessionID, "RDS API", "GetBankDepositResponse", ex.Message);
                return Request.CreateResponse(HttpStatusCode.InternalServerError, "InternalServerError,Try Again");
            }


            //}
            //else
            //    return Request.CreateResponse(HttpStatusCode.BadRequest, "Bad request,Pls try again");
        }

        [System.Web.Http.HttpPost]
        //[System.Web.Http.ActionName("XMLMethod")]
      
        public HttpResponseMessage GetCancelOrdersStatus([FromBody] Models.CancelOrdersStatus[] orders)
        {
            DateTime startDate = DateTime.Now;
            string ExHouse = Thread.CurrentPrincipal.Identity.Name;

            StringBuilder sbCancelRefID = new StringBuilder();
            String delimiter = "";
            foreach (CancelOrdersStatus order in orders)
            {
                sbCancelRefID.Append(delimiter).Append(order.CancelRefID);
                delimiter = ",";
           
            }

           //tring a= sb.ToString();

            string sessionID = RandomString(12); 
            List<CancelOrdersStatusResponse> OrderList = new List<CancelOrdersStatusResponse>();

            try
                {
                    DataTable OrderResponse = GetCancelOrderStatusApi(sessionID, sbCancelRefID.ToString(), startDate, ExHouse);
                    if (OrderResponse.Rows.Count > 0)
                    {
                        OrderList = (from DataRow dr in OrderResponse.Rows
                                     select new CancelOrdersStatusResponse()
                                     {
                                         CancelRefID = dr["CancelRefID"].ToString(),
                                         RefID = dr["RefID"].ToString(),
                                         ExHouseCode = dr["ExHouse"].ToString(),
                                         OrderID = dr["OrderID"].ToString(),
                                         Comments= dr["Comment"].ToString(),
                                         StatusCode = dr["StatusCode"].ToString(),
                                         StatusDesc = dr["StatusDescription"].ToString()
                                     }).ToList();

                        return Request.CreateResponse(HttpStatusCode.OK, OrderList);
                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.InternalServerError, "InternalServerError,Try Again");
                    }
                }
                catch (Exception ex)
                {
                    Common.WriteLog(sessionID, "RDS API", "GetBankDepositResponse", ex.Message);
                    return Request.CreateResponse(HttpStatusCode.InternalServerError, "InternalServerError,Try Again");
                }
              

            //}
            //else
            //    return Request.CreateResponse(HttpStatusCode.BadRequest, "Bad request,Pls try again");
        }

        [System.Web.Http.HttpGet]
        //[System.Web.Http.ActionName("XMLMethod")]

        public HttpResponseMessage GetReturnOrdersStatus()
        {
            DateTime startDate = DateTime.Now;
            string ExHouse = Thread.CurrentPrincipal.Identity.Name;

            string sessionID = RandomString(12);
            List<ReturnOrdersStatus> OrderList = new List<ReturnOrdersStatus>();

            try
            {
                DataTable OrderResponse = GetReturnOrderStatusApi(sessionID, startDate, ExHouse);
                if (OrderResponse.Rows.Count > 0)
                {
                    OrderList = (from DataRow dr in OrderResponse.Rows
                                 select new ReturnOrdersStatus()
                                 {
                                   
                                     RefID = dr["TransRefID"].ToString(),
                                     ExHouseCode = dr["ExHouseCode"].ToString(),
                                     OrderID = dr["RefOrderReceipt"].ToString(),
                                     Reasons = dr["ReasonOfReturn"].ToString(),
                                     StatusCode = dr["StatusCode"].ToString(),
                                     StatusDesc = dr["StatusDescription"].ToString()
                                 }).ToList();

                    return Request.CreateResponse(HttpStatusCode.OK, OrderList);
                }
                else if(OrderResponse.Rows.Count == 0)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "No Return Orders Found,Try Again");
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.InternalServerError, "InternalServerError,Try Again");
                }
            }
            catch (Exception ex)
            {
                Common.WriteLog(sessionID, "RDS API", "GetReturnOrdersStatus", ex.Message);
                return Request.CreateResponse(HttpStatusCode.InternalServerError, "InternalServerError,Try Again");
            }


            //}
            //else
            //    return Request.CreateResponse(HttpStatusCode.BadRequest, "Bad request,Pls try again");
        }

        [System.Web.Http.HttpPut]
        //[System.Web.Http.ActionName("XMLMethod")]
        public HttpResponseMessage UpdateBankDepositOrderInfo([FromBody] Models.BankDepositOrderInfoUpdate orders)
    
        {
            if(orders==null)
            {
                Common.WriteLog("", "RDS API", "UpdateOrderInfo", "order is null");
                return Request.CreateResponse(HttpStatusCode.BadRequest, "Bad request, Update single order info");
            }
            if (orders.ReceiverName == null && orders.RoutingCode == null && orders.AccNo == null)
            {
                Common.WriteLog("", "RDS API", "UpdateOrderInfo", "Acc name:" + orders.ReceiverName + "Acc No:" + orders.AccNo + "Routing:" + orders.RoutingCode);
                return Request.CreateResponse(HttpStatusCode.BadRequest, "Bad request,Mandatory field required");
            }
            DateTime startDate = DateTime.Now;
            string ExHouse = Thread.CurrentPrincipal.Identity.Name;

            //  List<OrderInfoResponse> OrderList = new List<OrderInfoResponse>();
            OrderInfoResponse OrderList = new OrderInfoResponse();

            try
                {
                    DataTable OrderResponse = UpdateOrderInfoResponse(orders.RefID,orders.OrderID,orders.AccNo,orders.ReceiverName,orders.RoutingCode, startDate, ExHouse,"ACC", orders.ApiCallID);
                    if (OrderResponse.Rows.Count > 0)
                    {
                  
                    OrderList.RefID = OrderResponse.Rows[0]["RefID"].ToString();
                    OrderList.ExHouseCode = OrderResponse.Rows[0]["ExHouseCode"].ToString();
                    OrderList.OrderID = OrderResponse.Rows[0]["OrderID"].ToString();
                    OrderList.StatusCode = OrderResponse.Rows[0]["StatusCode"].ToString();
                    OrderList.StatusDesc = OrderResponse.Rows[0]["StatusDesc"].ToString();
                        return Request.CreateResponse(HttpStatusCode.OK, OrderList);
                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.InternalServerError, "InternalServerError,Try Again");
                    }
                }
                catch (Exception ex)
                {
                    Common.WriteLog("", "RDS API", "UpdateOrderInfo", ex.Message);
                    return Request.CreateResponse(HttpStatusCode.InternalServerError, "InternalServerError,Try Again");
                }
                //finally
                //{
                //    OrderList.ToArray;
                //}

            //}
            //else
            //    return Request.CreateResponse(HttpStatusCode.BadRequest, "Bad request,Pls try again");
        }

        [System.Web.Http.HttpPut]
        //[System.Web.Http.ActionName("XMLMethod")]
        public HttpResponseMessage UpdateCashPickupOrderInfo([FromBody] Models.CashPickupOrderInfoUpdate orders)

        {
            if (orders == null)
            {
                Common.WriteLog("", "RDS API", "UpdateOrderInfo", "order is null");
                return Request.CreateResponse(HttpStatusCode.BadRequest, "Bad request,Order not found");
            }
            if (orders.ReceiverName == null)
            {
                Common.WriteLog("", "RDS API", "UpdateOrderInfo", "Acc name:" + orders.ReceiverName );
                return Request.CreateResponse(HttpStatusCode.BadRequest, "Bad request,Mandatory field required");
            }
            DateTime startDate = DateTime.Now;
            string ExHouse = Thread.CurrentPrincipal.Identity.Name;

            //  List<OrderInfoResponse> OrderList = new List<OrderInfoResponse>();
            OrderInfoResponse OrderList = new OrderInfoResponse();

            try
            {
                DataTable OrderResponse = UpdateOrderInfoResponse(orders.RefID, orders.OrderID, "", orders.ReceiverName,"", startDate, ExHouse,"IC", orders.ApiCallID);
                if (OrderResponse.Rows.Count > 0)
                {

                    OrderList.RefID = OrderResponse.Rows[0]["RefID"].ToString();
                    OrderList.ExHouseCode = OrderResponse.Rows[0]["ExHouseCode"].ToString();
                    OrderList.OrderID = OrderResponse.Rows[0]["OrderID"].ToString();
                    OrderList.StatusCode = OrderResponse.Rows[0]["StatusCode"].ToString();
                    OrderList.StatusDesc = OrderResponse.Rows[0]["StatusDesc"].ToString();
                    return Request.CreateResponse(HttpStatusCode.OK, OrderList);
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.InternalServerError, "InternalServerError,Try Again");
                }
            }
            catch (Exception ex)
            {
                Common.WriteLog("", "RDS API", "UpdateOrderInfo", ex.Message);
                return Request.CreateResponse(HttpStatusCode.InternalServerError, "InternalServerError,Try Again");
            }
            //finally
            //{
            //    OrderList.ToArray;
            //}

            //}
            //else
            //    return Request.CreateResponse(HttpStatusCode.BadRequest, "Bad request,Pls try again");
        }

        //[System.Web.Http.HttpGet]       
        //public string BankDeposit()
        //{
        //    return "OK";
        //}
    }
}
