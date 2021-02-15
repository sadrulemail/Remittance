using System.Web.Services;
using System.Data.SqlClient;
using System.Data;

namespace Remittance
{
    /// <summary>
    /// Summary description for BEFTNService
    /// </summary>
    [WebService(Namespace = "http://172.22.1.26/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.Web.Script.Services.ScriptService]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class BEFTNService : System.Web.Services.WebService
    {
        [WebMethod]
        public string getBEFTNInfo(string contextKey)
        {
            string Retval = "";
            string oConnString = System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString;
            SqlConnection.ClearAllPools();
            SqlConnection oConn = new SqlConnection(oConnString);
            if (oConn.State == ConnectionState.Closed)
                oConn.Open();
            SqlCommand oCommand = new SqlCommand("sp_BEFTN_Codes_Select", oConn);
            oCommand.CommandType = CommandType.StoredProcedure;
            oCommand.Parameters.Add("@Routing_Number", SqlDbType.VarChar).Value = contextKey;

            if (oConn.State == ConnectionState.Closed)
                oConn.Open();

            SqlDataReader oReader = oCommand.ExecuteReader();

            string Role = string.Empty;
            while (oReader.Read())
            {
                Retval = string.Format("<div class='ui-corner-all'><table>");
                Retval = string.Format("{0}<tr><td><img src='Banklogo/{4}.jpg' height='50'></td><td><b><span style='font-size:large'>{1}</span></b><br>{2}<br>{3}<br>{5}, {6}</td></tr>",
                    Retval,
                    contextKey,
                    oReader["Bank_Name"],
                    oReader["Branch_Name"],
                    oReader["Bank_Code"],
                    oReader["THANA_NAME"],
                    oReader["DIST_NAME"]
                    );
                //Retval = string.Format("{0}<tr><td>{1}</td></tr>", Retval, oReader["EMP"]);
                //Retval = string.Format("{0}<tr><td>{1}</td></tr>", Retval, oReader["DesigFullName"]);
                //Retval = string.Format("{0}<tr><td>{1}</td></tr>", Retval, oReader["BranchName"]);
                Retval = string.Format("{0}</tr></table></div>", Retval);
            }
            return Retval;
        }

    }

}