using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography;
using System.Security.Principal;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;
using System.Xml;
using System.Xml.Linq;
using TrustRDSAPI.Authorization;

namespace TrustRDSAPI.Filters
{
    public class BasicAuthenticationAttribute: AuthorizationFilterAttribute
    {
        public override void OnAuthorization(HttpActionContext actionContext)
        {
            var authHeader = actionContext.Request.Headers.Authorization;
            string userName = "";
            if (authHeader != null)
            {
                try {
                    //   var authenticationToken = actionContext.Request.Headers.Authorization.Parameter;
                    string authenticationToken = actionContext.Request.Headers.Authorization.ToString();
                    string decodedAuthenticationToken = Encoding.UTF8.GetString(Convert.FromBase64String(authenticationToken));
                    userName = ParseAuthorizationToken(decodedAuthenticationToken);
                    //var usernamePasswordArray = decodedAuthenticationToken.Split(':');
                    //var userName = usernamePasswordArray[0];
                    //var password = usernamePasswordArray[1];

                    // Replace this with your own system of security / means of validating credentials
                    //      var isValid = userName == "mejba" && password == "123";

                    //if (isValid)
                    //{
                    //    var principal = new GenericPrincipal(new GenericIdentity(userName), null);
                    //    Thread.CurrentPrincipal = principal;

                    //    actionContext.Response =
                    //       actionContext.Request.CreateResponse(HttpStatusCode.OK,
                    //          "User " + userName + " successfully authenticated");

                    //    return;
                    //}
                    if (userName != "")
                    {
                        var principal = new GenericPrincipal(new GenericIdentity(userName), null);
                        Thread.CurrentPrincipal = principal;
                        base.OnAuthorization(actionContext);
                     
                        return;
                    }
                }
                catch(Exception ex)
                {
                    //actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.BadRequest);
                    //return;
                }
                }

            HandleUnathorized(actionContext);
        }

        private static void HandleUnathorized(HttpActionContext actionContext)
        {
            actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
           // actionContext.Response.Headers.Add("WWW-Authenticate", "Basic Scheme='Data' location = 'http://localhost:");
        }

        private string ParseAuthorizationToken(string xmlToken)
        {
            try
            {
                XmlDocument XmlReqBody = new XmlDocument();

                XmlReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>" + xmlToken);

                XmlReader xmlReader = new XmlNodeReader(XmlReqBody);
                DataSet ds = new DataSet();
                ds.ReadXml(xmlReader);

                DataTable dt = ds.Tables["Authentication"];
                string SystemID = dt.Rows[0]["Id"].ToString();
                string UserName = dt.Rows[0]["UserName"].ToString();
                string Password = dt.Rows[0]["Password"].ToString();
                if (SystemID == "" || UserName == "" || Password == "")
                    return "";
                DataTable dt_Autho = GetAuthenticationInfo(dt.Rows[0]["Id"].ToString());
                if (dt_Autho.Rows.Count > 0)
                {
                    string private_key = dt_Autho.Rows[0]["PrivateKey"].ToString();
                    string ExHouseCode=dt_Autho.Rows[0]["ExHouseCode"].ToString();
                   string d_userName= DecryptRSA(UserName, private_key);
                    if (ExHouseCode == DecryptRSA(UserName, private_key) && dt_Autho.Rows[0]["ExPassword"].ToString() == DecryptRSA(Password, private_key))
                        return dt_Autho.Rows[0]["ExHouseCode"].ToString();
                    else return "";
                            
                }
                else
                    return "";
             //   string UserName = DecryptRSA(dt.Rows[0]["UserName"].ToString());
            }
            catch(Exception ex)
            {
                Common.WriteLog("", "RDSAuthentication", "AuthorizationToken", ex.Message);
            }
            return "";
        }

        public string DecryptRSA(string data,string _PrivateKey)
        {
            var rsa = new RSACryptoServiceProvider();
           //   string _publicKey = "<RSAKeyValue><Modulus>38N8BuU+JqB3DlSHcZfsvCCNQAB+wAWILcog9teLmKSiAKXOiBM4MzjcuW+521lT4stdwUEYkx99rZXMuDCKRCN9kt0w42QJyWQ35Hx4LQG7tgqGfNrjszwR0ngpznepCPJl82VhT7HzJreW0+DeV0vvZHqxfgmrFJoT7Uoh5Lc=</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";

          //  string _publicKey = "<RSAKeyValue><Modulus>" + "38N8BuU+JqB3DlSHcZfsvCCNQAB+wAWILcog9teLmKSiAKXOiBM4MzjcuW+521lT4stdwUEYkx99rZXMuDCKRCN9kt0w42QJyWQ35Hx4LQG7tgqGfNrjszwR0ngpznepCPJl82VhT7HzJreW0+DeV0vvZHqxfgmrFJoT7Uoh5Lc=" + "</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";
        
            var dataToDecrypt = Convert.FromBase64String(data);
            rsa.FromXmlString(_PrivateKey);
            var DecryptedByte = rsa.Decrypt(dataToDecrypt, false);
            return Encoding.UTF8.GetString(DecryptedByte);
        }

        private DataTable GetAuthenticationInfo(string systemId)
        {
            DataTable dt = new DataTable();
            using (SqlDataAdapter da = new SqlDataAdapter())
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_Remi_Authentication_Info";//***
                    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@SystemID", System.Data.SqlDbType.VarChar).Value = systemId;
                       

                        cmd.Connection = conn;
                        conn.Open();
                        da.SelectCommand = cmd;
                        da.Fill(dt);

                    }

                }
            }
            return dt;
        }
    }
}