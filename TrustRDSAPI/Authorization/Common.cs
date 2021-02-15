using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace TrustRDSAPI.Authorization
{
    public class Common
    {
        public static void WriteLog(string RefCallID, string ExCode, string ServiceName, string LogText)
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_ErrorLog_Insert";
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RefCallID", System.Data.SqlDbType.VarChar).Value = RefCallID;
                    cmd.Parameters.Add("@ExCode", System.Data.SqlDbType.VarChar).Value = ExCode;
                    cmd.Parameters.Add("@ServiceName", System.Data.SqlDbType.VarChar).Value = ServiceName;
                    cmd.Parameters.Add("@Msg", System.Data.SqlDbType.VarChar).Value = LogText;
                    cmd.Connection = conn;
                    if (conn.State == System.Data.ConnectionState.Closed) conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }


    }
}