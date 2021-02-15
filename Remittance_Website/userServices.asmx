<%@ WebService Language="C#" Class="Remittance.userServices" %>


using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System;

namespace Remittance
{
    [WebService(Namespace = "https://intraweb.tblbd.com/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.Web.Script.Services.ScriptService]
    public class userServices : System.Web.Services.WebService
    {
        [WebMethod]
        public string getUserInfo(string contextKey)
        {
            string Retval = "";
            string oConnString = System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString;
            SqlConnection oConn = new SqlConnection(oConnString);
            SqlConnection.ClearAllPools();
            if (oConn.State == ConnectionState.Closed)
                oConn.Open();
            SqlCommand oCommand = new SqlCommand("usp_getEmpInfo", oConn);
            oCommand.CommandType = CommandType.StoredProcedure;
            oCommand.Parameters.Add("@param_EmpID", SqlDbType.VarChar).Value = contextKey;

            if (oConn.State == ConnectionState.Closed)
                oConn.Open();

            SqlDataReader oReader = oCommand.ExecuteReader();

            string Role = string.Empty;
            while (oReader.Read())
            {
                Retval = string.Format("<table class='ui-corner-all'>");
                Retval = string.Format("{0}<tr><td><a href='../Profile.aspx?ID={2}' title='view profile' target='_blank'><img src='{3}' width='60'></a></td><td nowrap=nowrap>{1}</td></tr>",
                    Retval,
                    oReader["Emp"],
                    contextKey,
                    oReader["ImgFull"]);
                //Retval = string.Format("{0}<tr><td>{1}</td></tr>", Retval, oReader["EMP"]);
                //Retval = string.Format("{0}<tr><td>{1}</td></tr>", Retval, oReader["DesigFullName"]);
                //Retval = string.Format("{0}<tr><td>{1}</td></tr>", Retval, oReader["BranchName"]);
                Retval = string.Format("{0}</tr></table></a>", Retval);
            }
            return Retval;
        }

        [WebMethod]
        public string getCbsAccountInfo(string contextKey)
        {
            string Retval = "1";
            try
            {
                string oConnString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;
                SqlConnection oConn = new SqlConnection(oConnString);
                SqlConnection.ClearAllPools();
                if (oConn.State == ConnectionState.Closed)
                    oConn.Open();
                string Q = "select dbo.fn_Cbs_Acc_Name('" + contextKey + "') as acname";
                SqlCommand oCommand = new SqlCommand(Q, oConn);
                oCommand.Parameters.Add("@Accno", SqlDbType.VarChar).Value = contextKey;

                if (oConn.State == ConnectionState.Closed)
                    oConn.Open();

                SqlDataReader oReader = oCommand.ExecuteReader();

                string Role = string.Empty;
                while (oReader.Read())
                {
                    Retval = toJS(string.Format("{0}", oReader["acname"]));
                }

                if (Retval.Length == 0)
                {
                    Retval = toJS("A/C Not Found.");
                }
            }
            catch (Exception ex)
            {
                Retval = ex.Message;
            }

            return Retval;
        }

        [WebMethod]
        public string getTCashAccountInfo(string contextKey)
        {
            string Retval = "1";
            try
            {
                string oConnString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;
                SqlConnection oConn = new SqlConnection(oConnString);
                SqlConnection.ClearAllPools();
                if (oConn.State == ConnectionState.Closed)
                    oConn.Open();
                string Q = "select dbo.fn_TCash_Acc_Name('" + contextKey + "') as acname";
                SqlCommand oCommand = new SqlCommand(Q, oConn);
                oCommand.Parameters.Add("@Accno", SqlDbType.VarChar).Value = contextKey;

                if (oConn.State == ConnectionState.Closed)
                    oConn.Open();

                SqlDataReader oReader = oCommand.ExecuteReader();

                string Role = string.Empty;
                while (oReader.Read())
                {
                    Retval = toJS(string.Format("{0}", oReader["acname"]));
                }

                if (Retval.Length == 0)
                {
                    Retval = toJS("A/C Not Found.");
                }
            }
            catch (Exception ex)
            {
                Retval = ex.Message;
            }

            return Retval;
        }

        public string getValueOfKey(string KeyName)
        {
            try
            {
                return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
            }
            catch (Exception) { return string.Empty; }
        }

        public string toJS(object value)
        {
            try
            {
                return HttpUtility.JavaScriptStringEncode(value.ToString().Replace("\n", ""));
            }
            catch (Exception)
            {
                return "";
            }
        }

    }
}