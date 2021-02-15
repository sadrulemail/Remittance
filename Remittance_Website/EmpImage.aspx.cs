using System;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Web;

namespace Remittance
{
    public partial class EmpImage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(Request.QueryString["EMPID"]))
            {
                try
                {
                    HttpCachePolicy cachePolicy = Response.Cache;
                    cachePolicy.SetCacheability(HttpCacheability.ServerAndPrivate);
                    cachePolicy.VaryByParams["EMPID"] = true;
                    cachePolicy.VaryByParams["W"] = true;
                    cachePolicy.VaryByParams["H"] = true;
                    cachePolicy.VaryByParams["imgid"] = true;
                    cachePolicy.SetOmitVaryStar(true);
                    cachePolicy.SetExpires(DateTime.Now + TimeSpan.FromHours(6));
                    cachePolicy.SetValidUntilExpires(true);
                    //cachePolicy.SetLastModified(new DateTime(2010,03,02,12,0,0));



                    string EmpID = Request.QueryString["EMPID"];
                    string TableName = "Emp_Pic";

                    int Width = 0;
                    int Height = 0;

                    try
                    {
                        Width = int.Parse(Request.QueryString["W"].ToString());
                    }
                    catch (Exception) { }
                    try
                    {
                        Height = int.Parse(Request.QueryString["H"].ToString());
                    }
                    catch (Exception) { }

                    string Query = "SELECT TOP 1 Picture FROM TblUserDB.dbo." + TableName;
                    Query += " WHERE EMPID='" + EmpID + "'";
                    byte[] logo = (byte[])fetchScalar(Query, Width, Height);
                    Response.ContentType = "Image/JPEG";
                    Response.BinaryWrite(logo);
                }
                catch (Exception)
                {
                    Response.ContentType = "Image/JPEG";
                    //try
                    //{
                    //    Response.BinaryWrite(new byte[] { });
                    //}
                    //catch (Exception)
                    //{
                        //try
                        //{
                        //string NoImageFile = ConfigurationManager.AppSettings["NoImageFile"].ToString();
                        //byte[] noimage = File.ReadAllBytes(NoImageFile);
                        Response.Redirect("~/Images/NoFace.jpg");
                        //}
                        //catch (Exception) { }
                    //}
                }
            }
        }

        object fetchScalar(string query, int Width, int Height)
        {
            try
            {
                // connect to data source
                SqlConnection myConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString);

                // initialize command object with query
                SqlCommand myCmd = new SqlCommand(query, myConn);

                // open connection
                if (myConn.State == ConnectionState.Closed)
                    myConn.Open();

                // get scalar
                object scalar = myCmd.ExecuteScalar();

                // close connection
                myConn.Close();

                Bitmap b = (Bitmap)Bitmap.FromStream(new MemoryStream((byte[])scalar));

                Bitmap output;
                if (Width == 0)
                    output = b;
                else if (Height == 0)
                {
                    double newHeight = ((double)Width * (double)b.Height / (double)b.Width);
                    output = new Bitmap(b, new Size(Width, (int)newHeight));
                }
                else
                    output = new Bitmap(b, new Size(Width, Height));

                MemoryStream ms = new MemoryStream();
                output.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg);
                return ms.ToArray();
            }
            catch (Exception)
            {
                return null;
            }
        }
    }
}