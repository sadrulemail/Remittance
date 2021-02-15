<%@ WebHandler Language="C#" Class="Remittance.Search_CS" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;

namespace Remittance
{
    public class Search_CS : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string prefixText = context.Request.QueryString["q"];
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = string.Format("EXEC sp_Search_Emp '{0}', 20, '1'", prefixText);
                conn.ConnectionString = ConfigurationManager
                        .ConnectionStrings["TblUserDBConnectionString"].ConnectionString;
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.Connection = conn;
                    StringBuilder sb = new StringBuilder();
                    conn.Open();
                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            string Result = sdr["RESULT"].ToString().Replace(",", " ").Replace(Environment.NewLine, " ").Replace("\n", "");
                            if (sdr["ServiceStatus"].ToString() != "1")
                                Result = "<i style='color:Gray'>" + Result + "</i>";

                            sb.Append(
                                string.Format("{0},{1},{2},{3}"
                                , Result
                                , sdr["Img"]
                                , sdr["ID"]
                                , sdr["URL"])
                                ).Append(Environment.NewLine);
                        }
                    }
                    conn.Close();
                    context.Response.Write(sb.ToString());
                }
            }
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