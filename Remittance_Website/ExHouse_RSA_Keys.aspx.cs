using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

public partial class ExHouse_RSA_Keys_Page : System.Web.UI.Page
{ 
    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();
    }

    protected void btnToken_Click(object sender, EventArgs e)
    {
        string PublicKey = txtPublickey.Text.Trim().Replace("&lt;", "<").Replace("&gt;", ">");
        litToken.Text = CredEncrypt_Data(txtSystemID.Text.Trim(), txtUser.Text.Trim(), txtPassword.Text.Trim(), txtBranchID.Text.Trim(), PublicKey);
    }

    public string EncryptRSA_Data(string data, string _publicKey)
    {
        var rsa = new RSACryptoServiceProvider();
        // string _publicKey = "<RSAKeyValue><Modulus>6SiIfmpTaRgAtpY3pDR3q5XGd7w1VC0Klcosg5HWZH6lthPPwjGUhLqN5QmwRUMUtmmVMCbb2sSVpxcF35CzhQCTpfkEy+aiUHYSQXAFf+HSmI3Mx0m+OZdWdCwnGEV/9hAIpKJLGZTUNdRuHHtzCbnyhGYMbZzMey3EVHalr0k=</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";

        // string _publicKey = "<RSAKeyValue><Modulus>ueLmviG3uvv5vsuPcgQoPkRKipV6JdZKTLEFeegMRD8r+3AD6xjygOHcRU5eTnwZgNDHDdJ+OAuuP1Q6XCmSiSzKKOwmAGTqdXIlr5k5WXvvYG9TKsLhr51lp8U6C5qebii1FWxpIKAafsfvzNpQXONOI2YQ5Q4bF9zCDNf/FAU=</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";
        // string _publicKey = "<RSAKeyValue><Modulus>utJGvQnwhdipZwzx1n/TGTgoL2uOXt3bcYyAU4V5IHw2ew6y3fxRTNgXURBNTDy4G2KoKW3QejM/G2GLBNQxGfs6GFdDDKXTBwqpiB1bkzsGItEj/8DKtFefVCLBuv1CqJwHqV7uQpKp7ffCVrXSqADQhStJFRPKr0pXBBdAugk=</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";

        _publicKey = "<RSAKeyValue><Modulus>" + _publicKey + "</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";

        rsa.FromXmlString(_publicKey);
        var dataToEncrypt = Encoding.UTF8.GetBytes(data);
        var encryptedByteArray = rsa.Encrypt(dataToEncrypt, false).ToArray();
        return Convert.ToBase64String(encryptedByteArray);
    }

    public string CredEncrypt_Data(string systemid, string user, string password, string BranchID, string publicKey)
    {
        StringBuilder xml_Credentials = new StringBuilder();
        xml_Credentials.Append("<Authentication>");
        xml_Credentials.Append("<Id>" + systemid + "</Id>");
        xml_Credentials.Append("<UserName>" + EncryptRSA_Data(user, publicKey) + "</UserName>");
        xml_Credentials.Append("<Password>" + EncryptRSA_Data(password, publicKey) + "</Password>");
        xml_Credentials.Append("<BranchID>" + EncryptRSA_Data(BranchID, publicKey) + "</BranchID>");
        xml_Credentials.Append("</Authentication>");
        //TextBox3.Text = xml_Credentials.ToString();
        return System.Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(xml_Credentials.ToString()));
    }

    protected void cmdGeneratePrivateKey_Click(object sender, EventArgs e)
    {
        //TrustControl1.ClientMsg(DateTime.Now.ToString());
        //return;
        string Msg = "";
        // string str = RSA.ToXmlString(true);   //The output looks like the following that has both public and private keys.

        RSACryptoServiceProvider RSA = new RSACryptoServiceProvider(2048);
        string PrivateKey = RSA.ToXmlString(true);
        string PublicKey = RSA.ToXmlString(false);

        //       string str = RSA.ToXmlString(false); // Read public key in a string 


        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                string Q = "s_RSAKey_Genarate";
                cmd.CommandText = Q;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@ExHouseCode", System.Data.SqlDbType.VarChar).Value = DropDownList1.SelectedItem.Value;
                cmd.Parameters.Add("@ExPassword", System.Data.SqlDbType.VarChar).Value = RandomString(14);
                cmd.Parameters.Add("@PrivateKey", System.Data.SqlDbType.VarChar).Value = PrivateKey;
                cmd.Parameters.Add("@PublicKey", System.Data.SqlDbType.VarChar).Value = PublicKey;

                SqlParameter sql_Msg = new SqlParameter("@Msg", System.Data.SqlDbType.VarChar, 255);
                sql_Msg.Direction = System.Data.ParameterDirection.InputOutput;
                sql_Msg.Value = " ";
                cmd.Parameters.Add(sql_Msg);

                cmd.Connection = conn;
                if (conn.State == ConnectionState.Closed) conn.Open();

                cmd.ExecuteNonQuery();
                conn.Close();

                Msg = string.Format("{0}", sql_Msg.Value);
            }
        }
        

        TrustControl1.ClientMsg(Msg);

        //string str = RSA.ToXmlString(true);
        //txtPublickey.Text = str;

        
        

        //  TextBox2.Text = string.Format("{0}", str.Replace("<", "&lt;").Replace(">", "&gt;"));
        //TextBox2.Text = CredEncrypt("A03E7201-E238-4EC7-9E59-4CF3D5F6CC6B", "RDSTESTAPI", "RDSTest123");// string.Format("{0}", str);
    }

    protected void cmdShowKey_Click(object sender, EventArgs e)
    {
        //TrustControl1.ClientMsg(DateTime.Now.ToString());
        //return;
        string ExHouseCode = DropDownList1.SelectedItem.Value;
        txtUser.Text = ExHouseCode;
        txtPassword.Text = "";
        txtSystemID.Text = "";
        txtPublickey.Text = "";

        DataTable DT = new DataTable();

        using (SqlDataAdapter da = new SqlDataAdapter())
        {
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "s_RSAKey_Select";
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ExHouseCode", System.Data.SqlDbType.VarChar).Value = ExHouseCode;

                    cmd.Connection = conn;
                    if (conn.State == ConnectionState.Closed) conn.Open();
                    da.SelectCommand = cmd;                    
                    da.Fill(DT);
                }
            }
        }

        if (DT.Rows.Count > 0)
        {
            txtPassword.Text = string.Format("{0}", DT.Rows[0]["ExPassword"]);
            txtSystemID.Text = string.Format("{0}", DT.Rows[0]["SystemID"]);
            string PublicKey = string.Format("{0}", DT.Rows[0]["PublicKey"]);
            txtPublickey.Text = PublicKey.Replace("<", "&lt;").Replace(">", "&gt;"); ;
        }
    }

    private string RandomString(int length)
    {
        Random random = new Random();
        const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

        return new string(Enumerable.Repeat(chars, length)
          .Select(s => s[random.Next(s.Length)]).ToArray());
    }
}