<%@ WebHandler Language="C#" Class="Remittance.BEFTN_Search" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;

namespace Remittance
{
    public class BEFTN_Search : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            //context.Response.Write("Hello World");
            SqlConnection.ClearAllPools();
            string prefixText = context.Request.QueryString["q"];
            string Query = "EXEC sp_BEFTN_Codes_Search_Service '" + prefixText + "'";
            SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString);
            SqlCommand oCommand = new SqlCommand(Query, oConn);
            if (oConn.State == System.Data.ConnectionState.Closed) oConn.Open();

            SqlDataReader oR = oCommand.ExecuteReader();
            StringBuilder sb = new StringBuilder();

            while (oR.Read())
            {
                sb.AppendLine(
                    string.Format("{0},{1},{2},{3},{4},{5}",
                    oR["Routing_Number"],
                    oR["Bank_Name"],
                    oR["Branch_Name"],
                    oR["Bank_Code"],
                    oR["THANA_NAME"],
                    oR["DIST_NAME"]
                        )
                   );
            }
            oR.Close();

            context.Response.Write(sb.ToString());
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

    }
}