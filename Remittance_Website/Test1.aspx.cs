using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Threading;

public partial class Test1 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        //Label1.Text = Convert.ToBase64String(Guid.NewGuid().ToByteArray());
        ////Label1.Text = Guid.NewGuid().ToString("N");

        //StringBuilder builder = new StringBuilder();
        //SHA256 shaAlgorithm = new SHA256Managed();
        //byte[] shaDigest = shaAlgorithm.ComputeHash(ASCIIEncoding.ASCII.GetBytes(Label1.Text));
        Label1.Text = RandomString(11);
        //Thread.Sleep(100);
        Label2.Text = RandomString(11);
        //Thread.Sleep(100);
        Label3.Text = RandomString(11);
    }

    private Random random = new Random();

    private string RandomString(int length)
    {
        //Random random = new Random();
        const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        //string RetVal = "";
        //for(int i = 0; i < length; i++)
        //{
        //    RetVal += chars.Substring(random.Next(0, chars.Length), 1);
        //}
        //return RetVal;

        return new string(Enumerable.Repeat(chars, length)
          .Select(s => s[random.Next(s.Length)]).ToArray());
    }

    public string RandomString(int size, bool lowerCase)
    {
        StringBuilder builder = new StringBuilder();
        Random random = new Random();
        char ch;
        for (int i = 0; i < size; i++)
        {
            ch = Convert.ToChar(Convert.ToInt32(Math.Floor(26 * random.NextDouble() + 65)));
            builder.Append(ch);
        }
        if (lowerCase)
            return builder.ToString().ToLower();
        return builder.ToString();
    }
}