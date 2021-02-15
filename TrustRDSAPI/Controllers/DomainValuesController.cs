using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Web.Http;
using TrustRDSAPI.Authorization;
using TrustRDSAPI.Filters;
using TrustRDSAPI.Models;

namespace TrustRDSAPI.Controllers
{
    [BasicAuthentication]
    public class DomainValuesController : ApiController
    {

        [System.Web.Http.HttpGet]
        //[System.Web.Http.ActionName("XMLMethod")]

        public HttpResponseMessage GetBankRoutingCodes()
        {
            DateTime startDate = DateTime.Now;
            string ExHouse = Thread.CurrentPrincipal.Identity.Name;

            string sessionID = RandomString(12);
            List<BankRoutingCodes> OrderList = new List<BankRoutingCodes>();

            try
            {
                DataTable OrderResponse = GetRoutingCodesApi(sessionID, startDate, ExHouse);
                if (OrderResponse.Rows.Count > 0)
                {
                    OrderList = (from DataRow dr in OrderResponse.Rows
                                 select new BankRoutingCodes()
                                 {

                                     RoutingCode = dr["Routing_Number"].ToString(),
                                     BankName = dr["Bank_Name"].ToString(),
                                     BranchName = dr["Branch_Name"].ToString()
                                 }).ToList();

                    return Request.CreateResponse(HttpStatusCode.OK, OrderList);
                }
                else if (OrderResponse.Rows.Count == 0)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "No RoutingCode Found,Try Again");
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


        }

        private DataTable GetRoutingCodesApi(string SessionID, DateTime startDT, string ExHouseCode)
        {
            DataTable RemilistDT = new DataTable();
            try
            {
                //
                using (SqlDataAdapter da = new SqlDataAdapter())
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        string Query = "s_Api_GetRoutingCodes";//***
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
                Common.WriteLog(SessionID, "RDS API", "s_Api_GetRoutingCodes", ex.Message);
            }
            return RemilistDT;
        }

        [System.Web.Http.HttpGet]
        //[System.Web.Http.ActionName("XMLMethod")]

        public HttpResponseMessage GetResponseCodes()
        {
            DateTime startDate = DateTime.Now;
            string ExHouse = Thread.CurrentPrincipal.Identity.Name;

            string sessionID = RandomString(12);
            List<ResponseCodes> OrderList = new List<ResponseCodes>();

            try
            {
                DataTable OrderResponse = GetResponseCodesApi(sessionID, startDate, ExHouse);
                if (OrderResponse.Rows.Count > 0)
                {
                    OrderList = (from DataRow dr in OrderResponse.Rows
                                 select new ResponseCodes()
                                 {

                                     StatusCode = dr["StatusCode"].ToString(),
                                     Description = dr["StatusDescription"].ToString()
                                   
                                 }).ToList();

                    return Request.CreateResponse(HttpStatusCode.OK, OrderList);
                }
                else if (OrderResponse.Rows.Count == 0)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "No RoutingCode Found,Try Again");
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


        }

        private DataTable GetResponseCodesApi(string SessionID, DateTime startDT, string ExHouseCode)
        {
            DataTable RemilistDT = new DataTable();
            try
            {
                //
                using (SqlDataAdapter da = new SqlDataAdapter())
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        string Query = "s_Api_GetResponseCodes";//***
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
                Common.WriteLog(SessionID, "RDS API", "s_Api_GetResponseCodes", ex.Message);
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

    }
}
