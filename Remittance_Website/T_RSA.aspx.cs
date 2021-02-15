using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

public partial class T_RSA : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void Button1_Click(object sender, EventArgs e)
    {
      string a=  EncryptRSA(TextBox1.Text);
        Label2.Text = a;
        //string a = EncryptRSA(TextBox1.Text);
        //Label2.Text = EncryptRSA(TextBox1.Text);

        //return;
        //   RSACryptoServiceProvider RSA = new RSACryptoServiceProvider();
        // Read public key in a string  
        //   string str = RSA.ToXmlString(true);

        //Label1.Text = str.Replace("<","&lt;").Replace(">","&gt;");
        //// Get key into parameters  
        ////RSAParameters RSAKeyInfo = RSA.ExportParameters(true);


    }


    public string EncryptRSA(string data)
    {
        var rsa = new RSACryptoServiceProvider();
        // string _publicKey = "<RSAKeyValue><Modulus>6SiIfmpTaRgAtpY3pDR3q5XGd7w1VC0Klcosg5HWZH6lthPPwjGUhLqN5QmwRUMUtmmVMCbb2sSVpxcF35CzhQCTpfkEy+aiUHYSQXAFf+HSmI3Mx0m+OZdWdCwnGEV/9hAIpKJLGZTUNdRuHHtzCbnyhGYMbZzMey3EVHalr0k=</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";

     // string _publicKey = "<RSAKeyValue><Modulus>ueLmviG3uvv5vsuPcgQoPkRKipV6JdZKTLEFeegMRD8r+3AD6xjygOHcRU5eTnwZgNDHDdJ+OAuuP1Q6XCmSiSzKKOwmAGTqdXIlr5k5WXvvYG9TKsLhr51lp8U6C5qebii1FWxpIKAafsfvzNpQXONOI2YQ5Q4bF9zCDNf/FAU=</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";
        string _publicKey = "<RSAKeyValue><Modulus>utJGvQnwhdipZwzx1n/TGTgoL2uOXt3bcYyAU4V5IHw2ew6y3fxRTNgXURBNTDy4G2KoKW3QejM/G2GLBNQxGfs6GFdDDKXTBwqpiB1bkzsGItEj/8DKtFefVCLBuv1CqJwHqV7uQpKp7ffCVrXSqADQhStJFRPKr0pXBBdAugk=</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";
        rsa.FromXmlString(_publicKey);
        var dataToEncrypt = Encoding.UTF8.GetBytes(data);
        var encryptedByteArray = rsa.Encrypt(dataToEncrypt, false).ToArray();
        return Convert.ToBase64String(encryptedByteArray);
    }

    public string EncryptRSA_Data(string data, string _publicKey)
    {
        var rsa = new RSACryptoServiceProvider();
        // string _publicKey = "<RSAKeyValue><Modulus>6SiIfmpTaRgAtpY3pDR3q5XGd7w1VC0Klcosg5HWZH6lthPPwjGUhLqN5QmwRUMUtmmVMCbb2sSVpxcF35CzhQCTpfkEy+aiUHYSQXAFf+HSmI3Mx0m+OZdWdCwnGEV/9hAIpKJLGZTUNdRuHHtzCbnyhGYMbZzMey3EVHalr0k=</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";

        // string _publicKey = "<RSAKeyValue><Modulus>ueLmviG3uvv5vsuPcgQoPkRKipV6JdZKTLEFeegMRD8r+3AD6xjygOHcRU5eTnwZgNDHDdJ+OAuuP1Q6XCmSiSzKKOwmAGTqdXIlr5k5WXvvYG9TKsLhr51lp8U6C5qebii1FWxpIKAafsfvzNpQXONOI2YQ5Q4bF9zCDNf/FAU=</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";
        // string _publicKey = "<RSAKeyValue><Modulus>utJGvQnwhdipZwzx1n/TGTgoL2uOXt3bcYyAU4V5IHw2ew6y3fxRTNgXURBNTDy4G2KoKW3QejM/G2GLBNQxGfs6GFdDDKXTBwqpiB1bkzsGItEj/8DKtFefVCLBuv1CqJwHqV7uQpKp7ffCVrXSqADQhStJFRPKr0pXBBdAugk=</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";

          _publicKey = "<RSAKeyValue><Modulus>"+ _publicKey+"</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";

        rsa.FromXmlString(_publicKey);
        var dataToEncrypt = Encoding.UTF8.GetBytes(data);
        var encryptedByteArray = rsa.Encrypt(dataToEncrypt, false).ToArray();
        return Convert.ToBase64String(encryptedByteArray);
    }


    public string DecryptRSA(string data)
    {
        var rsa = new RSACryptoServiceProvider();
        //   string _publicKey = "<RSAKeyValue><Modulus>38N8BuU+JqB3DlSHcZfsvCCNQAB+wAWILcog9teLmKSiAKXOiBM4MzjcuW+521lT4stdwUEYkx99rZXMuDCKRCN9kt0w42QJyWQ35Hx4LQG7tgqGfNrjszwR0ngpznepCPJl82VhT7HzJreW0+DeV0vvZHqxfgmrFJoT7Uoh5Lc=</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";

         string _publicKey = "<RSAKeyValue><Modulus>ueLmviG3uvv5vsuPcgQoPkRKipV6JdZKTLEFeegMRD8r+3AD6xjygOHcRU5eTnwZgNDHDdJ+OAuuP1Q6XCmSiSzKKOwmAGTqdXIlr5k5WXvvYG9TKsLhr51lp8U6C5qebii1FWxpIKAafsfvzNpQXONOI2YQ5Q4bF9zCDNf/FAU=</Modulus><Exponent>AQAB</Exponent><P>2kuGxzCOs0WAzFUJFE/RiTE72uxDMhvsLQ8DeOKMYkwffGbyjKluiSnKCAcC37GZxzn8DZGx+aqitSpkCfs8aw==</P><Q>2f5XcHVdIbj1JZj/AWWjLl/6oa3IG/sDiho62YyNtTGsqlsbkkmPcOus3JeyWg2Ig8czKIU8xfYSiy1jvbINTw==</Q><DP>Pc+W+T3xmid7AeCuMncrcLplJWcy27R2WofextL3RzogzDvmQBgVuXcAwuchVC/YyEXN7hWsHHLJoZzAOOdPww==</DP><DQ>pRG9cIDOpuyBZZj28D3gVQuEo80ODHIE+hxml7mgzKXy04Tt2dYt8hnj6Z5NBXfd+btrd7F8lYKCBDW4ozoibQ==</DQ><InverseQ>bhks7LLhqN0lqdQwi924Q1oWCZM8kyX+oJ2h4H80Im0P9zVguINIyuONEiDUfDhJgSkMEaYCs1wOCEjwzz93PA==</InverseQ><D>LhFvwhs1H6AnCwQD7uvc1WGzX5kgBpSPIWaVxtqdf6RwUAY40mECaLKRFpQPhz/2Shhz3JcYNOegLY3AUOr0p6JTmTAWtgHdKRsrr9ZGL8IC3D6NZqBZRynWOwP6C9TFl6EIC/1Ek921TXkmtcZTd8Qa/kGNn19fsWS2aZtbydk=</D></RSAKeyValue>";
     //   string _publicKey = TextBox2.Text;
        var dataToDecrypt = Convert.FromBase64String(data);
        rsa.FromXmlString(_publicKey);
        var DecryptedByte = rsa.Decrypt(dataToDecrypt, false);
        return Encoding.UTF8.GetString(DecryptedByte);
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        //string b=  DecryptRSA(Label2.Text);
        //  Label3.Text = b;
        string authenticationToken = "PEF1dGhlbnRpY2F0aW9uPjxJZD4xNDNhN2ViNy1iMWEyLTQ5ZDAtOGJlYS0wMzZlMzY0NzRkNGE8L0lkPjxVc2VyTmFtZT5hb0l4a0xvUm5KbTd0Y2lEQU9OWGlJaFJZTnJBbFpkeHVHNlRiVWJOS2NQUGRFNWlFQkFvamx3N1VUOHNmSUFtQ3gxVytXZzd3b1RtelBncHlMVVU3cWRsdjhwNzRDMkVicTI0Qmp6N2NaZEYyc2hGcyt0VDk3QVdJMmdNMERXcTZScjA1MFRVZ3dPNURkMFR4UEJrZlZLZmo5d2drMDBJZkZzUmtzOW40aWc9PC9Vc2VyTmFtZT48UGFzc3dvcmQ+cEx0N3VVQWNSQldSaSt0MStwaWx1R3EyaVhsUzRkZkt1WCtDSUV1YkhMWkxHM1hycTd5cXNic1BPY3pwMCtvV1hWUUxwdmRqdUYxa0RvSURnZHIxdjBaNVpiU0Nuamtlbk4ycFhhUUVBS3l3QmROMWUzMEFzMkpUWmxuSTZmRzFyMWsvY0NRRllwRXlKSUhzbFRkMFpnblh2SUdwQVVIN3BnSHRRekZlTnVnPTwvUGFzc3dvcmQ+PEJyYW5jaElkPkRGcHhLdkJGNUh5a1ZSRHhyQlpHdElONldDMlpEYnVSSDFJK2kwVGNEMkF3SjJmNkVIT0xPV1V3dVp0bWdsRHBKSXEySmVVWjkxRmc1dkFueWRhTlFic0Uvb0ovSlArVTg3Q2NPUXFzelFmV2FNZTROYWRCSGdvRnMvV3ZjMVJ3VldpdHBvcGQrbEpMRzltSldmMlBQOTU2NjhpK004S3NQa0Q5U003MUlHVT08L0JyYW5jaElkPjwvQXV0aGVudGljYXRpb24+";
        var decodedAuthenticationToken = Encoding.UTF8.GetString(Convert.FromBase64String(authenticationToken));
        ParseAuthorizationToken(decodedAuthenticationToken);
    }

    protected void Button3_Click(object sender, EventArgs e)
    {
        // string str = RSA.ToXmlString(true);   //The output looks like the following that has both public and private keys.

        RSACryptoServiceProvider RSA = new RSACryptoServiceProvider();
 //       string str = RSA.ToXmlString(false); // Read public key in a string  
        string str = RSA.ToXmlString(true);
        //  TextBox2.Text = string.Format("{0}", str.Replace("<", "&lt;").Replace(">", "&gt;"));
        TextBox2.Text = CredEncrypt("A03E7201-E238-4EC7-9E59-4CF3D5F6CC6B", "RDSTESTAPI", "RDSTest123");// string.Format("{0}", str);
    }

    public string CredEncrypt(string systemid, string user, string password)
    {
        StringBuilder xml_Credentials = new StringBuilder();
        xml_Credentials.Append("<Authentication>");
        xml_Credentials.Append("<Id>" + systemid + "</Id>");
        xml_Credentials.Append("<UserName>" + EncryptRSA(user) + "</UserName>");
        xml_Credentials.Append("<Password>" + EncryptRSA(password) + "</Password>");
        xml_Credentials.Append("<BranchID>" + EncryptRSA("0002") + "</BranchID>");
        xml_Credentials.Append("</Authentication>");
        TextBox3.Text = xml_Credentials.ToString();
        return System.Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(xml_Credentials.ToString()));
    }
    private string ParseAuthorizationToken(string xmlToken)
    {
        XmlDocument XmlReqBody = new XmlDocument();

        XmlReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>" + xmlToken);



        XmlReader xmlReader = new XmlNodeReader(XmlReqBody);
        DataSet ds = new DataSet();
        ds.ReadXml(xmlReader);

        DataTable dt = ds.Tables["Authentication"];
        string id = dt.Rows[0]["Id"].ToString();
        string UserName = dt.Rows[0]["UserName"].ToString();
        string a = DecryptRSA(UserName);
        return "";
    }



    protected void btnToken_Click(object sender, EventArgs e)
    {
        string token = CredEncrypt_Data(txtSystemID.Text.Trim(),txtUser.Text.Trim(),txtPassword.Text.Trim(), txtBranchID.Text.Trim(),txtPublickey.Text.Trim());
    }

    public string CredEncrypt_Data(string systemid, string user, string password,string BranchID,string publicKey)
    {
        StringBuilder xml_Credentials = new StringBuilder();
        xml_Credentials.Append("<Authentication>");
        xml_Credentials.Append("<Id>" + systemid + "</Id>");
        xml_Credentials.Append("<UserName>" + EncryptRSA_Data(user, publicKey) + "</UserName>");
        xml_Credentials.Append("<Password>" + EncryptRSA_Data(password, publicKey) + "</Password>");
        xml_Credentials.Append("<BranchID>" + EncryptRSA_Data(BranchID, publicKey) + "</BranchID>");
        xml_Credentials.Append("</Authentication>");
        TextBox3.Text = System.Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(xml_Credentials.ToString()));
        return System.Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(xml_Credentials.ToString()));
    }
}