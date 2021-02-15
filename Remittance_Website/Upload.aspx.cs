using System;
using System.IO;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using OfficeOpenXml;
using System.Text.RegularExpressions;

namespace Remittance
{
    public partial class Upload : System.Web.UI.Page
    {

        string SL;
        string RemitterName;
        string RemitterAddress;
        string BeneficiaryName;
        string BeneficiaryAddress;
        string BankName;
        string BranchName;
        string Area;
        string District;
        string Account;
        string Amount;
        string PIN;
        string Password;
        string RefOrderReceipt;
        string Contact;
        string Purpose;
        string PaymentMethod;
        string ValueDate;
        string BeneficiaryID;
        string ToBranch;
        string ExHouseCode;
        string CommentHO;
        string CommentBR;
        string RemitterAccount;
        string RemitterAccType;
        string AccountType;
        string RoutingNumber;
        DataSet1.TempUploadDataTable DT;

        protected void Page_Load(object sender, EventArgs e)
        {
            this.Title = "Upload Remittance Data";

            Page.Form.Attributes.Add("enctype", "multipart/form-data");
            TrustControl1.getUserRoles();

            if (!(Session["BRANCHID"].ToString() == "1" && (TrustControl1.isRole("ADMIN")
                || TrustControl1.isRole("UPLOAD")))
                )    //Not IT & Cards
            {
                Response.Write("No Permission.<br><br><a href=''>Home</a>");
                Response.End();
            }

            if (!Directory.Exists(Server.MapPath("Upload")))
            {
                Directory.CreateDirectory(Server.MapPath("Upload"));
            }

            if (!IsPostBack)
            {
                //string Clear = string.Format("{0}", Request.QueryString["clear"]);
                //if (Clear == "YES")
                Random R = new Random(DateTime.Now.Millisecond +
                                DateTime.Now.Second * 1000 +
                                DateTime.Now.Minute * 60000 +
                                DateTime.Now.Hour * 3600000);

                HidPageID.Value = string.Format("{0}{1}", Session.SessionID, R.Next());

                HidUploadTempFile.Value = Server.MapPath("Upload/" + Session["EMPID"].ToString() + "_" + HidPageID.Value + ".xlsx");
                {
                    CleanDatabase();
                    //Response.Redirect("Upload.aspx", true);
                }

                Panel2.Visible = false;

                //GridView1.DataBind();
            }
            Session["SESSIONID"] = Session.SessionID;

            //lblUploadStatus.Text = AccountFilter("kjskj --82734897323-4987 320-;sd ");
        }

        private void CleanDatabase()
        {
            RunNonQuery("EXEC sp_DeleteTempUpload '" + HidPageID.Value + "', '" + Session["EMPID"].ToString() + "'", "RemittanceConnectionString", CommandType.Text);
        }

        protected void FileUpload1_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            Session["FILENAME"] = FileUpload1.FileName.Trim();
            //lblUploadStatus.Text = "Uploaded File: " + FileUpload1.FileName;
            if (File.Exists(HidUploadTempFile.Value))
                File.Delete(HidUploadTempFile.Value);
            FileUpload1.SaveAs(HidUploadTempFile.Value);
            File.SetCreationTime(HidUploadTempFile.Value, DateTime.Now);
        }

        private void DeleteOldUploadedFiles()
        {
            string[] Files = Directory.GetFiles(Server.MapPath("Upload/"));
            foreach (string FileName in Files)
                if (File.GetCreationTime(FileName) < DateTime.Now.AddHours(-1) || FileName.Contains(Session.SessionID))
                    File.Delete(FileName);
        }

        protected void cmdCheck_Click(object sender, EventArgs e)
        {
            Panel1.Visible = false;
            try
            {
                ParseFile(HidUploadTempFile.Value, cboExHouse.SelectedItem.Value, int.Parse(txtWorksheet.Text));
            }
            catch (Exception ex)
            {
                lblStatus.Text = ex.Message;
            }
            DeleteOldUploadedFiles();
        }

        private void ParseFile(string FileName, string ExHouseCode, int Worksheet)
        {
            CleanDatabase();
            DT = new DataSet1.TempUploadDataTable();

            //lblUploadStatus.Text += "<br>" + FileName;
            //try
            //{
            //    StringBuilder sb;
            //    StreamReader reader = new StreamReader(FileName);
            //    sb = new StringBuilder();
            //    string Line = string.Empty;
            //    int TotalRows = 0;

            //    while (reader.Peek() >= 0)
            //    {
            //        Line = reader.ReadLine();
            //        if (Line.StartsWith("|"))
            //        {
            //            string[] words = Line.Split("|".ToCharArray());
            //            try
            //            {                        
            //                int i1 = int.Parse(words[1].Trim());


            //                ObjectDataSource1.InsertParameters["SessionID"].DefaultValue = Session.SessionID;
            //                ObjectDataSource1.InsertParameters["InsertDT"].DefaultValue = DateTime.Now.ToString();                
            //                ObjectDataSource1.Insert();
            //                TotalRows++;
            //            }
            //            catch (Exception) { }                    
            //        }
            //    }
            //    reader.Close();
            //    lblStatus.Text = "Total Rows: <b>" + TotalRows.ToString() + "</b>";        
            //}
            //catch (Exception) { }

            //FileStream stream = File.Open(FileName, FileMode.Open, FileAccess.Read);
            ////IExcelDataReader excelReader = ExcelReaderFactory.CreateBinaryReader(stream);
            //IExcelDataReader excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
            ////excelReader.IsFirstRowAsColumnNames = false;
            //DataSet result = excelReader.AsDataSet();

            ////5. Data Reader methods
            //while (excelReader.Read())
            //{
            //    string s = excelReader[0].ToString();
            //}

            ////6. Free resources (IExcelDataReader is IDisposable)
            //excelReader.Close();

            //ParseWorkSheet_UTL_TT();
            //return;


            FileInfo FI = new FileInfo(FileName);
            try
            {
                using (ExcelPackage package = new ExcelPackage(FI))
                {
                    ExcelWorkbook workBook = package.Workbook;
                    if (workBook.Worksheets.Count > 0)
                    {
                        ExcelWorksheet currentWorksheet = workBook.Worksheets[Worksheet];

                        switch (ExHouseCode.ToUpper())
                        {
                            case "UTL TT":
                                ParseWorkSheet_UTL_TT(currentWorksheet, ExHouseCode);
                                break;
                            case "UTL IC":
                                ParseWorkSheet_UTL_IC(currentWorksheet, ExHouseCode);
                                break;
                            case "GULF":
                                ParseWorkSheet_GULF(currentWorksheet, ExHouseCode);
                                break;
                            case "NEC TT":
                                ParseWorkSheet_NEC_TT(currentWorksheet, ExHouseCode);
                                break;
                            case "NEC IC":
                                ParseWorkSheet_NEC_IC(currentWorksheet, ExHouseCode);
                                break;                                
                            case "NEC UK":
                                ParseWorkSheet_NEC_UK_BDT(currentWorksheet, ExHouseCode);
                                break;
                            case "ORCHID":
                                ParseWorkSheet_Orchid(currentWorksheet, ExHouseCode);
                                break;
                            case "OMAN":
                                ParseWorkSheet_Oman(currentWorksheet, ExHouseCode);
                                break;
                            case "OMAN IC":
                                ParseWorkSheet_Oman_IC(currentWorksheet, ExHouseCode);
                                break;
                            case "MITALI":
                                ParseWorkSheet_Mitali(currentWorksheet, ExHouseCode);
                                break;
                            case "WSF":
                                ParseWorkSheet_Wsf(currentWorksheet, ExHouseCode);
                                break;
                            case "WSF SMA":
                                ParseWorkSheet_Wsf_SMA(currentWorksheet, ExHouseCode);
                                break;
                            case "NMT TT":
                                ParseWorkSheet_Nmt_TT(currentWorksheet, ExHouseCode);
                                break;
                            case "NMT IC":
                                ParseWorkSheet_Nmt_IC(currentWorksheet, ExHouseCode);
                                break;
                            case "TRUST":
                                ParseTrust_Ex(currentWorksheet, ExHouseCode);
                                break;
                            case "ZENJ":
                                ParseZenj_Ex(currentWorksheet, ExHouseCode);
                                break;
                            case "ZENJ BE":
                                ParseZenjBE_Ex(currentWorksheet, ExHouseCode);
                                break;
                            case "PLD":
                                ParsePLD_Ex(currentWorksheet, ExHouseCode);
                                break;
                            case "KFE":
                                ParseKFE_Ex(currentWorksheet, ExHouseCode);
                                break;
                            case "KBE":
                                ParseKBE_Ex(currentWorksheet, ExHouseCode);
                                break;
                            case "CITY":
                                ParseCITY_Ex(currentWorksheet, ExHouseCode);
                                break;
                            case "XM":
                                Parse_XM_Ex(currentWorksheet, ExHouseCode);
                                break;
                            case "GMT":
                                Parse_GMT_Ex(currentWorksheet, ExHouseCode);
                                break;
                            case "RIA":
                                Parse_RIA_Ex(currentWorksheet, ExHouseCode);
                                break;
                            case "CUSTOM":      //Custom Excel Format
                                ParseCustomFormat(currentWorksheet);
                                break;
                            case "JOY":
                                ParseJoy_Ex(currentWorksheet, ExHouseCode);
                                break;
                            case "TRANSFAST":
                                ParseTransfast_Ex(currentWorksheet, ExHouseCode);
                                break;
                        }
                    }
                }

                #region Bulk Copy to DB
                string connString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;
                using (SqlConnection destinationConnection = new SqlConnection(connString))
                {
                    destinationConnection.Open();
                    using (SqlBulkCopy bulkCopy =
                         new SqlBulkCopy(destinationConnection.ConnectionString,
                                SqlBulkCopyOptions.TableLock))
                    {
                        bulkCopy.DestinationTableName = "TempUpload";
                        bulkCopy.WriteToServer(DT);
                    }
                }
                #endregion

                Panel1.Visible = false;
                GridView1.Visible = true;
                GridView1.DataBind();

                cmdUpdate.Enabled = GridView1.Rows.Count > 0;

                try
                {
                    File.Delete(FileName);
                }
                catch (Exception) { }
            }
            catch (Exception ex)
            {
                Panel2.Visible = false;
                cmdUpdate.Visible = false;
                lblStatus.Text = "Parsing file failed. Please check your file format. " + ex.Message;
                File.Delete(HidUploadTempFile.Value);
            }


            Panel2.Visible = true;
        }

        private void ParseWorkSheet_UTL_TT(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("DATE"))
                    {
                        ValueDate = WS.Cells["B" + r].Value.ToString();
                    }
                }
                catch (Exception) { }

                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("SL"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);
                        RemitterName = string.Format("{0}", WS.Cells["B" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "C" + r);
                        BankName = string.Format("{0}", WS.Cells["D" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["E" + r].Value);
                        Area = string.Format("{0}", WS.Cells["F" + r].Value);
                        District = string.Format("{0}", WS.Cells["G" + r].Value);
                        Account = getNumberFromCell(WS, "H" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["I" + r].Value);
                        RemitterAddress = "";
                        BeneficiaryAddress = "";
                        PIN = "";
                        Password = "";
                        RefOrderReceipt = "";
                        Contact = "";
                        Purpose = "";
                        PaymentMethod = "";
                        BeneficiaryID = "";
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }

        private void Parse_RIA_Ex(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = true;
            int SL = 0;

            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
               //DateTime PayingDate;

                //try
                //{
                //    //PayingDate = DateTime.Parse(WS.Cells["E" + r].Value.ToString().Trim());
                //    //ValueDate = DateTime.ParseExact(WS.Cells["E" + r].Value.ToString(), "dd-MM-yyyy", System.Globalization.CultureInfo.InvariantCulture).ToLongDateString();                
                //    //ValueDate = PayingDate.ToString();
                //    //ValueDate = PayingDate.ToLongDateString();
                //    ValueDate = DateTime.Now.Date.ToLongDateString();
                
                //}
                //catch (Exception)
                //{
                //    //ValueDate = DateTime.Now.Date.ToLongDateString();
                //    isDataRow = false;
                //}
               // try
               // {
                    //VD = (VD.Replace("Date:", "")).Trim();
                    //ValueDate = DateTime.ParseExact(WS.Cells["E" + r].Value.ToString(), "dd-MM-yyyy", System.Globalization.CultureInfo.InvariantCulture).ToLongDateString();
                    //ValueDate = WS.Cells["E" + r].Value.ToString();
                    //ValueDate = DateTime.FromOADate((double)WS.Cells["E" + r].Value).ToString();
              //  }
               // catch (Exception)
               // {
                    //ValueDate = DateTime.Now.Date.ToLongDateString();
               // }

                try
                {
                    if (isDataRow)
                    {
                        SL++;
                        //ValueDate = WS.Cells["E" + r].Value.ToString();
                        //ValueDate = (DateTime.ParseExact(WS.Cells["E" + r].Value.ToString(), "dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture)).ToLongDateString(); //WS.Cells["E" + r].Value.ToString();                        
                        //ValueDate =DateTime.Today.Date.ToString();
                        RemitterName = (string.Format("{0}", WS.Cells["K" + r].Value) + " " + string.Format("{0}", WS.Cells["L" + r].Value) + " " + string.Format("{0}", WS.Cells["M" + r].Value));
                        //RemitterName = string.Format("{0}", WS.Cells["K" + r].Value);
                        BeneficiaryName = (string.Format("{0}", WS.Cells["T" + r].Value) + " " + string.Format("{0}", WS.Cells["U" + r].Value) + " " + string.Format("{0}", WS.Cells["V" + r].Value));
                        //BeneficiaryName = string.Format("{0}", WS.Cells["T" + r].Value);
                        BankName = string.Format("{0}", WS.Cells["AF" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["I" + r].Value);
                        Area = "";
                        District = string.Format("{0}", WS.Cells["AI" + r].Value); ;
                        Account = getNumberFromCell(WS, "AD" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["G" + r].Value);

                        RemitterAddress = string.Format("{0}", WS.Cells["O" + r].Value);
                        BeneficiaryAddress = string.Format("{0}", WS.Cells["X" + r].Value); ;
                        PIN = getNumberFromCell(WS, "H" + r); // string.Format("{0}", WS.Cells["A" + r].Value); ;
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["D" + r].Value);
                        Contact = "";
                        Purpose = "";
                        PaymentMethod = "";
                        BeneficiaryID = "";
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";
                        RoutingNumber = "";

                        InsertTempUpload(_ExHouseCode, SL.ToString(), RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR, RoutingNumber);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }
        private string getNumberFromCell(ExcelWorksheet WS, string CollumName)
        {
            try
            {
                return string.Format("{0:N0}", WS.Cells[CollumName].Value).Replace(",", "");
            }
            catch (Exception)
            {
                return string.Format("{0}", WS.Cells[CollumName].Value);
            }
        }
        private void ParseWorkSheet_UTL_IC(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToString().StartsWith("Date"))
                    {
                        ValueDate = WS.Cells["B" + r].Value.ToString();
                    }
                }
                catch (Exception) { }

                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("SL"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);
                        RemitterName = string.Format("{0}", WS.Cells["B" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "C" + r);
                        BeneficiaryAddress = string.Format("{0}", WS.Cells["D" + r].Value);
                        BeneficiaryID = string.Format("{0}", WS.Cells["E" + r].Value);
                        BankName = string.Format("{0}", WS.Cells["F" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["G" + r].Value);
                        PIN = getNumberFromCell(WS, "H" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["I" + r].Value);

                        RemitterAddress = "";
                        Area = "";
                        District = "";
                        Account = "";
                        Password = "";
                        RefOrderReceipt = "";
                        Contact = "";
                        Purpose = "";
                        PaymentMethod = "";
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }
        private void ParseWorkSheet_GULF(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    for (int c = 1; c <= WS.Dimension.End.Column; c++)
                    {
                        string S = string.Format("{0}", WS.Cells[r, c].Value);
                        if (S.ToString().ToUpper().StartsWith("REPORT DATE"))
                        {
                            ValueDate = WS.Cells[r, c + 1].Value.ToString();
                        }
                    }
                }
                catch (Exception) { }

                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("SL"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);
                        RemitterName = string.Format("{0}", WS.Cells["K" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "E" + r);
                        BeneficiaryAddress = "";
                        BeneficiaryID = "";
                        BankName = string.Format("{0}", WS.Cells["H" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["I" + r].Value);
                        PIN = string.Format("{0}", WS.Cells["B" + r].Value).Trim();
                        Amount = string.Format("{0:N2}", WS.Cells["D" + r].Value);

                        RemitterAddress = "";
                        Area = "";
                        District = string.Format("{0}", WS.Cells["J" + r].Value); ;
                        Account = getNumberFromCell(WS, "G" + r);
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        Contact = string.Format("{0}", WS.Cells["F" + r].Value);
                        Purpose = "";
                        PaymentMethod = "";
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }
        private void ParseWorkSheet_NEC_TT(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("SERIAL NO"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);

                        //ValueDate = WS.Cells["C" + r].Value.ToString();
                        try
                        {
                            int D = int.Parse(((WS.Cells["C" + r].Value.ToString()).Split('/'))[0]);
                            int M = int.Parse(((WS.Cells["C" + r].Value.ToString()).Split('/'))[1]);
                            int Y = int.Parse(((WS.Cells["C" + r].Value.ToString()).Split('/'))[2]);
                            ValueDate = (new DateTime(Y, M, D)).ToLongDateString();
                        }
                        catch (Exception)
                        {
                            ValueDate = (DateTime.FromOADate(double.Parse(WS.Cells["C" + r].Value.ToString()))).ToShortDateString();
                        }

                        RemitterName = string.Format("{0}", WS.Cells["K" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "D" + r);
                        BeneficiaryAddress = "";
                        BeneficiaryID = "";
                        BankName = string.Format("{0}", WS.Cells["E" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["F" + r].Value);
                        PIN = "";
                        Amount = string.Format("{0:N2}", WS.Cells["I" + r].Value);

                        RemitterAddress = "";
                        Area = "";
                        District = string.Format("{0}", WS.Cells["G" + r].Value);
                        Account = getNumberFromCell(WS, "H" + r);
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        Contact = string.Format("{0}", WS.Cells["J" + r].Value);

                        Purpose = string.Format("{0}", WS.Cells["L" + r].Value);
                        PaymentMethod = "";
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";
                        RoutingNumber = string.Format("{0}", WS.Cells["M" + r].Value);

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR, RoutingNumber);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }
        private void ParseWorkSheet_NEC_IC(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("SERIAL NO"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S.ToUpper().StartsWith("TEST"))
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);
                        ValueDate = WS.Cells["C" + r].Value.ToString();
                        //(DateTime.ParseExact(WS.Cells["C" + r].Value.ToString(), "dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture)).ToLongDateString();
                        RemitterName = string.Format("{0}", WS.Cells["K" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "D" + r);
                        BeneficiaryAddress = "";
                        BeneficiaryID = "";
                        BankName = string.Format("{0}", WS.Cells["G" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["H" + r].Value);
                        PIN = getNumberFromCell(WS, "F" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["I" + r].Value);

                        RemitterAddress = "";
                        Area = "";
                        District = "";
                        Account = getNumberFromCell(WS, "G" + r);
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        Contact = string.Format("{0}", WS.Cells["J" + r].Value);

                        Purpose = string.Format("{0}", WS.Cells["L" + r].Value);
                        PaymentMethod = string.Format("{0}", WS.Cells["E" + r].Value);
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }
       private void ParseWorkSheet_NEC_UK_BDT(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.StartsWith("Serial No"))
                    //if (S.ToUpper().StartsWith("Serial No"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S.ToUpper().StartsWith("TEST"))
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);
                        ValueDate = WS.Cells["C" + r].Value.ToString();
                        //(DateTime.ParseExact(WS.Cells["C" + r].Value.ToString(), "dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture)).ToLongDateString();
                        RemitterName = string.Format("{0}", WS.Cells["L" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "D" + r);
                        BeneficiaryAddress = "";
                        BeneficiaryID = "";
                        BankName = string.Format("{0}", WS.Cells["E" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["F" + r].Value);
                        PIN = ""; //getNumberFromCell(WS, "F" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["J" + r].Value);

                        RemitterAddress = "";
                        Area = "";
                        District = string.Format("{0}", WS.Cells["G" + r].Value);
                        Account = getNumberFromCell(WS, "I" + r);
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        Contact = string.Format("{0}", WS.Cells["K" + r].Value);
                        RoutingNumber = string.Format("{0}", WS.Cells["H" + r].Value);

                        Purpose = string.Format("{0}", WS.Cells["M" + r].Value);
                        PaymentMethod = "";//string.Format("{0}", WS.Cells["E" + r].Value);
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR,RoutingNumber);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }
        private void ParseWorkSheet_Orchid(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("DATE"))
                    {
                        ValueDate = WS.Cells["B" + r].Value.ToString();
                    }
                }
                catch (Exception) { }

                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("SL"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);
                        RemitterName = string.Format("{0}", WS.Cells["C" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "D" + r);
                        BankName = string.Format("{0}", WS.Cells["H" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["I" + r].Value);
                        Area = string.Format("{0}", WS.Cells["J" + r].Value);
                        District = "";
                        Account = getNumberFromCell(WS, "F" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["L" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = "";
                        PIN = getNumberFromCell(WS, "G" + r);
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        Contact = "";
                        Purpose = "";
                        PaymentMethod = "";
                        BeneficiaryID = string.Format("{0}", WS.Cells["K" + r].Value);
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }
        private void ParseWorkSheet_Oman(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("DATE"))
                    {
                        ValueDate = WS.Cells["A" + r].Value.ToString().ToUpper().Replace("DATE:", "");
                    }
                }
                catch (Exception) { }

                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("SL"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);
                        RemitterName = string.Format("{0}", WS.Cells["I" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "C" + r);
                        BankName = string.Format("{0}", WS.Cells["E" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["F" + r].Value);
                        Area = "";
                        District = "";
                        Account = getNumberFromCell(WS, "D" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["G" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = "";
                        PIN = "";
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        Contact = "";
                        Purpose = "";
                        PaymentMethod = "";
                        BeneficiaryID = "";
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";
                        RoutingNumber = string.Format("{0}", WS.Cells["K" + r].Value);

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR, RoutingNumber);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }
        private void ParseWorkSheet_Oman_IC(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("DATE"))
                    {
                        ValueDate = WS.Cells["A" + r].Value.ToString().ToUpper().Replace("DATE:", "");
                    }
                }
                catch (Exception) { }

                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("SL"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);
                        //RemitterName = _ExHouseCode;
                        RemitterName = string.Format("{0}", WS.Cells["J" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "E" + r);
                        BankName = "";
                        BranchName = string.Format("{0}", WS.Cells["D" + r].Value);
                        Area = "";
                        District = "";
                        Account = "";
                        Amount = string.Format("{0:N2}", WS.Cells["G" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = "";
                        PIN = getNumberFromCell(WS, "C" + r);
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        Contact = string.Format("{0}", WS.Cells["F" + r].Value);
                        Purpose = "";
                        PaymentMethod = "";
                        BeneficiaryID = string.Format("{0}", WS.Cells["I" + r].Value);
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }
        private void ParseWorkSheet_Mitali(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("DATE"))
                    {
                        ValueDate = WS.Cells["B" + r].Value.ToString();
                    }
                }
                catch (Exception) { }

                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("SL"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);
                        RemitterName = string.Format("{0}", WS.Cells["B" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "C" + r);
                        BankName = string.Format("{0}", WS.Cells["G" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["H" + r].Value);
                        Area = string.Format("{0}", WS.Cells["I" + r].Value);
                        District = "";
                        Account = getNumberFromCell(WS, "E" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["K" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = "";
                        PIN = getNumberFromCell(WS, "F" + r);
                        Password = "";
                        RefOrderReceipt = "";
                        Contact = "";
                        Purpose = "";
                        PaymentMethod = "";
                        BeneficiaryID = string.Format("{0}", WS.Cells["J" + r].Value);
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
            //bool isDataRow = false;
            //int iSL = 1;
            //for (int r = 1; r <= WS.Dimension.End.Row; r++)
            //{
            //    try
            //    {
            //        string S = string.Format("{0}", WS.Cells["A" + r].Value);
            //        if (S.ToUpper().StartsWith("MEX"))
            //        {
            //            //ValueDate = WS.Cells["A" + r].Value.ToString().ToUpper().Replace("  "," ").Replace("MEX / REM DT.", "");
            //            ValueDate = string.Format("{0:dd-MMM-yyyy}", DateTime.Now.Date);
            //        }
            //    }
            //    catch (Exception) { }

            //    try
            //    {
            //        string S = string.Format("{0}", WS.Cells["A" + r].Value);
            //        if (S.ToUpper().StartsWith("MEX"))
            //        {
            //            isDataRow = true;
            //            continue;
            //        }
            //        //else if (isDataRow && S == "")
            //        //    isDataRow = false;
            //    }
            //    catch (Exception) { }

            //    try
            //    {
            //        if (isDataRow)
            //        {
            //            SL = iSL.ToString();
            //            RefOrderReceipt = string.Format("{0}", WS.Cells["A" + r].Value);
            //            if (RefOrderReceipt.Length == 0) continue;

            //            iSL++;
            //            RemitterName = string.Format("{0}", WS.Cells["B" + r].Value);
            //            BeneficiaryName = getNumberFromCell(WS, "C" + r);
            //            BankName = string.Format("{0}", WS.Cells["D" + r].Value);
            //            BranchName = "";
            //            Area = "";
            //            District = "";
            //            Account = "";
            //            Amount = string.Format("{0:N2}", WS.Cells["F" + r].Value);

            //            RemitterAddress = string.Format("{0}", WS.Cells["B" + (r + 1)].Value);
            //            RemitterAddress = RemitterAddress.Trim();
            //            if (RemitterAddress.EndsWith(","))
            //                RemitterAddress = RemitterAddress.Substring(0, RemitterAddress.Length - 1);
            //            RemitterAddress += "<br>" + string.Format("{0}", WS.Cells["B" + (r + 2)].Value);

            //            BeneficiaryAddress = string.Format("{0}", WS.Cells["C" + (r + 1)].Value);
            //            BeneficiaryAddress = BeneficiaryAddress.Trim();
            //            if (BeneficiaryAddress.EndsWith(","))
            //                BeneficiaryAddress = BeneficiaryAddress.Substring(0, BeneficiaryAddress.Length - 1);
            //            BeneficiaryAddress += "<br>" + string.Format("{0}", WS.Cells["C" + (r + 2)].Value);

            //            PIN = "";
            //            Password = "";

            //            Contact = "";
            //            Purpose = "";
            //            PaymentMethod = string.Format("{0}", WS.Cells["E" + r].Value);
            //            string EE = string.Format("{0}", WS.Cells["E" + (r + 1)].Value);
            //            if (EE.Trim().Length > 0)
            //                PaymentMethod = PaymentMethod + "<br>" + EE;

            //            BeneficiaryID = "";
            //            ToBranch = "";
            //            ToBranch = getToBranchAll(ToBranch);
            //            CommentHO = "";
            //            CommentBR = "";


            //            InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
            //        }
            //    }
            //    catch (Exception ex)
            //    {
            //        lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
            //    }
            //}
        }

        private void ParseTrust_Ex(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    ValueDate = (DateTime.FromOADate(double.Parse(WS.Cells["A1"].Value.ToString()))).ToShortDateString();
                }
                catch (Exception) { }

                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("REF"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S.Trim() == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = "";
                        RemitterName = string.Format("{0}", WS.Cells["B" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "C" + r);
                        BankName = string.Format("{0}", WS.Cells["G" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["H" + r].Value);
                        Area = string.Format("{0}", WS.Cells["I" + r].Value);
                        District = "";
                        Account = getNumberFromCell(WS, "E" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["K" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = "";
                        PIN = getNumberFromCell(WS, "F" + r);
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["A" + r].Value);
                        Contact = string.Format("{0}", WS.Cells["D" + r].Value);
                        Purpose = "";
                        PaymentMethod = "";
                        BeneficiaryID = string.Format("{0}", WS.Cells["J" + r].Value);
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }

            //ValueDate = DateTime.Today.ToLongDateString();
            //bool isDataRow = false;
            //int iSL = 1;
            //for (int r = 1; r <= WS.Dimension.End.Row; r++)
            //{
            //    try
            //    {
            //        string S = string.Format("{0}", WS.Cells["A" + r].Value);
            //        if (S.ToUpper().StartsWith("RECEIPT"))
            //        {
            //            //ValueDate = "";
            //        }
            //    }
            //    catch (Exception) { }

            //    try
            //    {
            //        string S = string.Format("{0}", WS.Cells["A" + r].Value);
            //        if (S.ToUpper().StartsWith("RECEIPT"))
            //        {
            //            isDataRow = true;
            //            continue;
            //        }
            //        //else if (isDataRow && S == "")
            //        //    isDataRow = false;
            //    }
            //    catch (Exception) { }

            //    try
            //    {
            //        if (isDataRow)
            //        {
            //            SL = iSL.ToString();
            //            RefOrderReceipt = string.Format("{0}", WS.Cells["A" + r].Value);
            //            if (RefOrderReceipt.Length == 0) continue;

            //            iSL++;
            //            RemitterName = string.Format("{0}", WS.Cells["K" + r].Value);
            //            BeneficiaryName = getNumberFromCell(WS, "B" + r);
            //            BankName = "";
            //            BranchName = string.Format("{0}", WS.Cells["F" + r].Value);
            //            Area = "";
            //            District = "";
            //            Account = "";
            //            Amount = string.Format("{0:N2}", WS.Cells["D" + r].Value);

            //            RemitterAddress = string.Format("{0}", WS.Cells["L" + r].Value);
            //            RemitterAddress = RemitterAddress.Trim();                    
            //            RemitterAddress += "<br>" + string.Format("{0}", WS.Cells["M" + r].Value);

            //            BeneficiaryAddress = "";// string.Format("{0}", WS.Cells["C" + (r + 1)].Value);
            //            BeneficiaryAddress.Trim();
            //            //if (BeneficiaryAddress.Trim().EndsWith(","))
            //            //    BeneficiaryAddress = BeneficiaryAddress.Trim().Substring(0, BeneficiaryAddress.Trim().Length - 1);
            //            //BeneficiaryAddress += "<br>" + string.Format("{0}", WS.Cells["C" + (r + 2)].Value);

            //            PIN = string.Format("{0}", WS.Cells["I" + r].Value);
            //            Password = string.Format("{0}", WS.Cells["J" + r].Value);

            //            Contact = string.Format("{0}", WS.Cells["C" + r].Value);
            //            Purpose = "";
            //            PaymentMethod = string.Format("{0}", WS.Cells["E" + r].Value);
            //            //string EE = string.Format("{0}", WS.Cells["E" + (r + 1)].Value);
            //            //if (EE.Trim().Length > 0)
            //            //    PaymentMethod = PaymentMethod + "<br>" + EE;

            //            BeneficiaryID = string.Format("{0}", WS.Cells["G" + r].Value);
            //            ToBranch = "";
            //            ToBranch = getToBranchAll(ToBranch);
            //            CommentHO = "";
            //            CommentBR = "";

            //            for (int ii = 1; ii < 10; ii++)
            //            {
            //                int cellNo = (ii + r);
            //                string tmp = string.Format("{0}", WS.Cells["A" + cellNo].Value);
            //                if (tmp.Length > 0)
            //                    break;
            //                else
            //                {
            //                    tmp = string.Format("{0}", WS.Cells["B" + cellNo].Value);
            //                    if(tmp.StartsWith("AC#"))
            //                    {
            //                        Account = tmp.Replace("AC#:", "").Trim();
            //                    }
            //                    if (tmp.StartsWith("Bank"))
            //                    {
            //                        BankName = tmp.Replace("Bank:", "").Trim();
            //                    }
            //                    if (tmp.StartsWith("Branch"))
            //                    {
            //                        BranchName = tmp.Replace("Branch:", "").Trim();
            //                    }
            //                    if (tmp.StartsWith("Dist"))
            //                    {
            //                        District = tmp.Replace("Dist:", "").Trim();
            //                    }
            //                }
            //            }

            //            //Details


            //            InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
            //        }
            //    }
            //    catch (Exception ex)
            //    {
            //        lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
            //    }
            //}
        }
        private void ParseWorkSheet_Wsf(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            int iSL = 1;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    string S = string.Format("{0}", WS.Cells["B" + r].Value).ToUpper();
                    if (S.ToUpper().StartsWith("TEST"))
                    {
                        string D = WS.Cells["B" + r].Value.ToString().ToUpper().Replace("TEST", "");
                        D = D.Replace(":", "");
                        D = D.Substring(D.IndexOf("DATED", 0), 18);
                        D = D.Replace("DATED", "").Trim();
                        ValueDate = D;
                    }
                }
                catch (Exception) { }

                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("ORDER"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = iSL.ToString();
                        iSL++;
                        RemitterName = string.Format("{0}", WS.Cells["I" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "C" + r);
                        BankName = string.Format("{0}", WS.Cells["E" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["F" + r].Value);
                        Area = "";
                        District = string.Format("{0}", WS.Cells["K" + r].Value);
                        Account = "";
                        Amount = string.Format("{0:N2}", WS.Cells["H" + r].Value);

                        RemitterAddress = string.Format("TT Serial No. {0}", WS.Cells["B" + r].Value);
                        BeneficiaryAddress = "";
                        PIN = "";
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["A" + r].Value);
                        Contact = string.Format("{0}", WS.Cells["J" + r].Value);
                        Purpose = "";
                        PaymentMethod = string.Format("{0}", WS.Cells["D" + r].Value);
                        BeneficiaryID = "";
                        ToBranch = "";
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }

        private void ParseWorkSheet_Wsf_SMA(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            int iSL = 1;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                //try
                //{
                //    string S = string.Format("{0}", WS.Cells["B" + r].Value).ToUpper();
                //    if (S.ToUpper().StartsWith("TEST"))
                //    {
                //        string D = WS.Cells["B" + r].Value.ToString().ToUpper().Replace("TEST", "");
                //        D = D.Replace(":", "");
                //        D = D.Substring(D.IndexOf("DATED", 0), 18);
                //        D = D.Replace("DATED", "").Trim();
                //        ValueDate = D;
                //    }
                //}
                //catch (Exception) { }

                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("ORDER"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = iSL.ToString();
                        iSL++;
                        RemitterName = string.Format("{0}", WS.Cells["I" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "E" + r);
                        BankName = string.Format("{0}", WS.Cells["G" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["H" + r].Value);
                        ValueDate = DateTime.FromOADate((double)WS.Cells["C" + r].Value).ToString();
                        Area = "";
                        District = string.Format("{0}", WS.Cells["K" + r].Value);
                        if (!(string.Format("{0}", WS.Cells["F" + r].Value)).ToUpper().Trim().StartsWith("CASH"))
                        {
                            Account = getNumberFromCell(WS, "F" + r);
                            PaymentMethod = "";
                        }
                        else
                        {
                            Account = "";
                            PaymentMethod = "IC";
                        }
                        Amount = string.Format("{0:N2}", WS.Cells["D" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = "";
                        PIN = getNumberFromCell(WS, "A" + r);
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        Contact = string.Format("{0}", WS.Cells["J" + r].Value);
                        Purpose = "";

                        BeneficiaryID = "";
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }

        private void ParseWorkSheet_Nmt_TT(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            int iSL = 1;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                //try
                //{
                //    string S = string.Format("{0}", WS.Cells["B" + r].Value).ToUpper();
                //    if (S.ToUpper().StartsWith("TEST"))
                //    {
                //        string D = WS.Cells["B" + r].Value.ToString().ToUpper().Replace("TEST", "");
                //        D = D.Replace(":", "");
                //        D = D.Substring(D.IndexOf("DATED", 0), 18);
                //        D = D.Replace("DATED", "").Trim();
                //        ValueDate = D;
                //    }
                //}
                //catch (Exception) { }

                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("SERIAL"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);
                        ValueDate = WS.Cells["C" + r].Value.ToString();//(DateTime.ParseExact(WS.Cells["C" + r].Value.ToString(), "dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture)).ToLongDateString();
                        RemitterName = string.Format("{0}", WS.Cells["J" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "D" + r);
                        BankName = string.Format("{0}", WS.Cells["E" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["F" + r].Value);
                        Area = "";
                        District = "";
                        Account = getNumberFromCell(WS, "G" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["H" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = "";
                        PIN = "";
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        Contact = string.Format("{0}", WS.Cells["I" + r].Value);
                        Purpose = string.Format("{0}", WS.Cells["K" + r].Value);
                        PaymentMethod = "";
                        BeneficiaryID = "";
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }

        private void ParseCITY_Ex(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            int iSL = 1;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {

                string VD = string.Format("{0}", WS.Cells["A" + r].Value);

                if (VD.Trim().ToLower().StartsWith("date") && !isDataRow)
                {
                    try
                    {
                        VD = (VD.Replace("Date:", "")).Trim();
                        ValueDate = DateTime.ParseExact(VD, "dd-MM-yyyy", System.Globalization.CultureInfo.InvariantCulture).ToLongDateString();
                    }
                    catch (Exception)
                    {
                        ValueDate = DateTime.Now.Date.ToLongDateString();
                    }
                }
                try
                {
                    int SL = int.Parse(WS.Cells["A" + r].Value.ToString());
                    isDataRow = true;
                }
                catch (Exception)
                {
                    isDataRow = false;
                }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);
                        //ValueDate = WS.Cells["C" + r].Value.ToString();//(DateTime.ParseExact(WS.Cells["C" + r].Value.ToString(), "dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture)).ToLongDateString();
                        RemitterName = string.Format("{0}", WS.Cells["C" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "D" + r);
                        BankName = string.Format("{0}", WS.Cells["H" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["I" + r].Value);
                        Area = string.Format("{0}", WS.Cells["J" + r].Value);
                        District = "";
                        Account = getNumberFromCell(WS, "F" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["L" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = "";
                        PIN = getNumberFromCell(WS, "G" + r);
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        Contact = string.Format("{0}", WS.Cells["E" + r].Value);
                        Purpose = "";
                        PaymentMethod = "";
                        BeneficiaryID = string.Format("{0}", WS.Cells["K" + r].Value);
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }
        private void Parse_XM_Ex(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            int SL = 0;

            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                DateTime PayingDate;

                try
                {
                    PayingDate = DateTime.Parse(WS.Cells["B" + r].Value.ToString().Trim());
                    ValueDate = PayingDate.ToLongDateString();
                    isDataRow = true;
                }
                catch (Exception)
                {
                    isDataRow = false;
                }


                //if (VD.Trim().ToLower().StartsWith("date") && !isDataRow)
                //{
                //    try
                //    {
                //        VD = (VD.Replace("Date:", "")).Trim();
                //        ValueDate = DateTime.ParseExact(VD, "dd-MM-yyyy", System.Globalization.CultureInfo.InvariantCulture).ToLongDateString();
                //    }
                //    catch (Exception)
                //    {
                //        ValueDate = PayingDate.ToLongDateString();
                //    }
                //}


                try
                {
                    if (isDataRow)
                    {
                        SL++;
                        //ValueDate = WS.Cells["C" + r].Value.ToString();//(DateTime.ParseExact(WS.Cells["C" + r].Value.ToString(), "dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture)).ToLongDateString();
                        RemitterName = string.Format("{0}", WS.Cells["L" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "D" + r);
                        BankName = string.Format("{0}", WS.Cells["G" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["E" + r].Value);
                        Area = "";
                        District = "";
                        Account = getNumberFromCell(WS, "C" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["J" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = "";
                        PIN = "";// string.Format("{0}", WS.Cells["A" + r].Value); ;
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["A" + r].Value);
                        Contact = "";
                        Purpose = "";
                        PaymentMethod = "";
                        BeneficiaryID = "";
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";
                        RoutingNumber = string.Format("{0}", WS.Cells["I" + r].Value); ;

                        InsertTempUpload(_ExHouseCode, SL.ToString(), RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR, RoutingNumber);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }
        private void Parse_XM_Ex_Old(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            int SL = 0;

            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                DateTime PayingDate;

                try
                {
                    PayingDate = DateTime.Parse(WS.Cells["B" + r].Value.ToString().Trim());
                    ValueDate = PayingDate.ToLongDateString();
                    isDataRow = true;
                }
                catch (Exception)
                {
                    isDataRow = false;
                }
                

                //if (VD.Trim().ToLower().StartsWith("date") && !isDataRow)
                //{
                //    try
                //    {
                //        VD = (VD.Replace("Date:", "")).Trim();
                //        ValueDate = DateTime.ParseExact(VD, "dd-MM-yyyy", System.Globalization.CultureInfo.InvariantCulture).ToLongDateString();
                //    }
                //    catch (Exception)
                //    {
                //        ValueDate = PayingDate.ToLongDateString();
                //    }
                //}
                

                try
                {
                    if (isDataRow)
                    {
                        SL++;
                        //ValueDate = WS.Cells["C" + r].Value.ToString();//(DateTime.ParseExact(WS.Cells["C" + r].Value.ToString(), "dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture)).ToLongDateString();
                        RemitterName = string.Format("{0}", WS.Cells["K" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "D" + r);
                        BankName = string.Format("{0}", WS.Cells["G" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["E" + r].Value);
                        Area = "";
                        District = "";
                        Account = getNumberFromCell(WS, "C" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["I" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = "";
                        PIN = "";
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["A" + r].Value);
                        Contact = "";
                        Purpose = "";
                        PaymentMethod = "";
                        BeneficiaryID = "";
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL.ToString(), RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }

        private void Parse_GMT_Ex(ExcelWorksheet WS, string _ExHouseCode)
        {
            //bool isDataRow = false;
            ///int iSL = 1; 
            bool isDataRow = true;
            //int SL = 1;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                ////try
                ////{
                ////    string S = string.Format("{0}", WS.Cells["B" + r].Value);
                ////    //if (S.ToUpper().StartsWith("Date"))
                ////    //{
                ////    ValueDate = WS.Cells["B" + r].Value.ToString();
                ////            //.ToUpper().Replace("Date:", "");
                ////    //}
                ////}
                ////catch (Exception) { }
                ////try
                ////{
                ////    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                ////    if (S.ToUpper().StartsWith("SL."))
                ////    {
                ////        isDataRow = true;
                ////        continue;
                ////    }
                ////    else if (isDataRow && S == "")
                ////        isDataRow = false;
                ////}
                ////catch (Exception) { }

            //for (int r = 1; r <= WS.Dimension.End.Row; r++)
            //{
            //    DateTime PayingDate;

            //    try
            //    {
            //        PayingDate = DateTime.Parse(WS.Cells["B" + r].Value.ToString().Trim());
            //        ValueDate = PayingDate.ToLongDateString();
            //        isDataRow = true;
            //    }
            //    catch (Exception)
            //    {
            //        isDataRow = false;
            //    }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);
                        //SL++;
                        //ValueDate = WS.Cells["C" + r].Value.ToString();//(DateTime.ParseExact(WS.Cells["C" + r].Value.ToString(), "dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture)).ToLongDateString();
                        RemitterName = string.Format("{0}", WS.Cells["C" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "D" + r);
                        BankName = string.Format("{0}", WS.Cells["H" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["I" + r].Value);
                        Area = "";
                        District = string.Format("{0}", WS.Cells["J" + r].Value);
                        Account = getNumberFromCell(WS, "F" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["L" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = "";
                        PIN = getNumberFromCell(WS, "G" + r);
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        Contact = string.Format("{0}", WS.Cells["E" + r].Value);
                        Purpose = string.Format("{0}", WS.Cells["M" + r].Value);
                        PaymentMethod = "IC";
                        BeneficiaryID = string.Format("{0}", WS.Cells["K" + r].Value);
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";
                        string RoutingNo = string.Format("{0}", WS.Cells["N" + r].Value);

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR, RoutingNo);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }
        private void ParseWorkSheet_Nmt_IC(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            int iSL = 1;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                //try
                //{
                //    string S = string.Format("{0}", WS.Cells["B" + r].Value).ToUpper();
                //    if (S.ToUpper().StartsWith("TEST"))
                //    {
                //        string D = WS.Cells["B" + r].Value.ToString().ToUpper().Replace("TEST", "");
                //        D = D.Replace(":", "");
                //        D = D.Substring(D.IndexOf("DATED", 0), 18);
                //        D = D.Replace("DATED", "").Trim();
                //        ValueDate = D;
                //    }
                //}
                //catch (Exception) { }

                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("SL"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);
                        ValueDate = WS.Cells["C" + r].Value.ToString();//(DateTime.ParseExact(WS.Cells["C" + r].Value.ToString(), "dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture)).ToLongDateString();
                        RemitterName = string.Format("{0}", WS.Cells["K" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "D" + r);
                        BankName = string.Format("{0}", WS.Cells["G" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["H" + r].Value);
                        Area = "";
                        District = "";
                        Account = getNumberFromCell(WS, "G" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["I" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = "";
                        PIN = getNumberFromCell(WS, "F" + r);
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        Contact = string.Format("{0}", WS.Cells["J" + r].Value);
                        Purpose = string.Format("{0}", WS.Cells["L" + r].Value);
                        PaymentMethod = "IC";
                        BeneficiaryID = string.Format("{0}", WS.Cells["E" + r].Value);
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }

        private void ParseZenj_Ex(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            ValueDate = DateTime.Today.Date.ToString();

            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("S"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S.Trim() == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value).Trim();
                        RemitterName = string.Format("{0}", WS.Cells["K" + r].Value).Trim();
                        BeneficiaryName = getNumberFromCell(WS, "G" + r).Trim();
                        BankName = string.Format("{0}", WS.Cells["I" + r].Value).Trim();
                        BranchName = string.Format("{0}", WS.Cells["J" + r].Value).Trim();
                        Area = "";
                        District = string.Format("{0}", WS.Cells["E" + r].Value).Trim();
                        Account = getNumberFromCell(WS, "H" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["C" + r].Value).Replace(",", "").Trim();

                        RemitterAddress = string.Format("{0}", WS.Cells["M" + r].Value).Trim();
                        BeneficiaryAddress = "";
                        PIN = getNumberFromCell(WS, "D" + r).Trim();
                        try
                        {
                            long _pin = long.Parse(PIN);
                            if (_pin == 0) PIN = "";
                        }
                        catch (Exception) { }

                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value).Trim();
                        Contact = "";
                        Purpose = string.Format("{0}", WS.Cells["N" + r].Value).Trim();
                        PaymentMethod = "";
                        BeneficiaryID = "";
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }

        private void ParseZenjBE_Ex(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            ValueDate = DateTime.Today.Date.ToString();

            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("S"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S.Trim() == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);
                        RemitterName = string.Format("{0}", WS.Cells["C" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "D" + r);
                        BankName = string.Format("{0}", WS.Cells["G" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["H" + r].Value);
                        Area = "";
                        District = string.Format("{0}", WS.Cells["I" + r].Value);
                        Account = getNumberFromCell(WS, "F" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["J" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = "";
                        PIN = "";
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        Contact = string.Format("{0}", WS.Cells["E" + r].Value); ;
                        Purpose = "";
                        PaymentMethod = "";
                        BeneficiaryID = "";
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }

        private void ParsePLD_Ex(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            for (int r = 0; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    if (!isDataRow)
                    {
                        string S = string.Format("{0}", WS.Cells["C" + r].Value);
                        double id_receiver = double.Parse(S);
                        isDataRow = true;
                    }
                }
                catch (Exception)
                {
                    continue;
                }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", r - 1);
                        RemitterName = string.Format("{0}", WS.Cells["I" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "D" + r);
                        BankName = string.Format("{0}", WS.Cells["Q" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["W" + r].Value);
                        Area = "";
                        District = string.Format("{0}", WS.Cells["K" + r].Value);
                        Account = getNumberFromCell(WS, "P" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["C" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = string.Format("{0}", WS.Cells["E" + r].Value);
                        PIN = "";
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["O" + r].Value);

                        Contact = "";
                        if ((string.Format("{0}", WS.Cells["F" + r].Value)).Trim().Length > 3)
                            Contact = string.Format("{0}", WS.Cells["F" + r].Value);
                        if ((string.Format("{0}", WS.Cells["G" + r].Value)).Trim().Length > 3)
                            Contact += string.Format(", {0}", WS.Cells["G" + r].Value).Trim();
                        if (Contact.StartsWith(","))
                            Contact = Contact.Substring(1);

                        Purpose = "";
                        PaymentMethod = "";
                        BeneficiaryID = "";
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }

        private void ParseKFE_Ex(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            int _SL = 1;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    //string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    //if (S.Length > 0)
                    //{
                    //    isDataRow = true;
                    //    continue;
                    //}                

                    ValueDate = DateTime.Parse(WS.Cells["B" + r].Value.ToString()).ToString();
                }
                catch (Exception) { }

                try
                {
                    int Ref = int.Parse(WS.Cells["A" + r].Value.ToString());
                    isDataRow = true;
                }
                catch (Exception)
                {
                    isDataRow = false;
                }

                try
                {
                    if (isDataRow)
                    {
                        SL = _SL.ToString();
                        RemitterName = string.Format("{0}", WS.Cells["J" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "D" + r);
                        BankName = string.Format("{0}", WS.Cells["F" + r].Value);

                        if (!string.Format("{0}", WS.Cells["G" + r].Value).ToUpper().StartsWith("ID"))
                        {
                            BranchName = string.Format("{0}", WS.Cells["G" + r].Value);
                            BeneficiaryID = "";
                        }
                        else
                        {
                            BranchName = "";
                            BeneficiaryID = string.Format("{0}", WS.Cells["G" + r].Value).Substring(3);
                        }

                        Area = string.Format("{0}", WS.Cells["I" + r].Value);
                        District = "";
                        Account = getNumberFromCell(WS, "E" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["K" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = "";
                        PIN = getNumberFromCell(WS, "H" + r);
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["A" + r].Value);
                        Contact = "";
                        Purpose = "";
                        PaymentMethod = "";

                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                        _SL++;
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }
        private void ParseKBE_Ex(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            int iSL = 1;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {

                string VD = string.Format("{0}", WS.Cells["A" + r].Value);

                if (VD.Trim().ToLower().StartsWith("date") && !isDataRow)
                {
                    try
                    {
                        VD = (VD.Replace("Date:", "")).Trim();
                        ValueDate = DateTime.ParseExact(VD, "dd-MM-yyyy", System.Globalization.CultureInfo.InvariantCulture).ToLongDateString();
                    }
                    catch (Exception)
                    {
                        ValueDate = DateTime.Now.Date.ToLongDateString();
                    }
                }
                try
                {
                    int SL = int.Parse(WS.Cells["A" + r].Value.ToString());
                    isDataRow = true;
                }
                catch (Exception)
                {
                    isDataRow = false;
                }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);
                        //ValueDate = WS.Cells["C" + r].Value.ToString();
                        //(DateTime.ParseExact(WS.Cells["C" + r].Value.ToString(), "dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture)).ToLongDateString();
                        RemitterName = string.Format("{0}", WS.Cells["C" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "D" + r);
                        BankName = string.Format("{0}", WS.Cells["H" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["I" + r].Value);
                        Area = string.Format("{0}", WS.Cells["J" + r].Value);
                        District = "";
                        Account = getNumberFromCell(WS, "F" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["L" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = "";
                        PIN = getNumberFromCell(WS, "G" + r);
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        Contact = string.Format("{0}", WS.Cells["E" + r].Value);
                        Purpose = "";
                        PaymentMethod = "";
                        BeneficiaryID = string.Format("{0}", WS.Cells["K" + r].Value);
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";
                        RoutingNumber = string.Format("{0}", WS.Cells["M" + r].Value);

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR, RoutingNumber);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }

        private void ParseCustomFormat(ExcelWorksheet WS)
        {
            //Same as Orchid
            bool isDataRow = false;
            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                string _ExHouseCode = "";
                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("DATE"))
                    {
                        ValueDate = (DateTime.FromOADate(double.Parse(WS.Cells["B" + r].Value.ToString()))).ToShortDateString();
                    }
                }
                catch (Exception) { }

                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("SL"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        RemitterName = string.Format("{0}", WS.Cells["C" + r].Value);
                        RemitterAddress = string.Format("{0}", WS.Cells["D" + r].Value);
                        RemitterAccount = getNumberFromCell(WS, "E" + r);
                        RemitterAccType = string.Format("{0}", WS.Cells["F" + r].Value);

                        BeneficiaryName = getNumberFromCell(WS, "G" + r);
                        BeneficiaryAddress = string.Format("{0}", WS.Cells["H" + r].Value);

                        Contact = string.Format("{0}", WS.Cells["I" + r].Value);
                        Account = getNumberFromCell(WS, "J" + r);
                        AccountType = string.Format("{0}", WS.Cells["K" + r].Value);

                        PIN = getNumberFromCell(WS, "L" + r);
                        Password = string.Format("{0}", WS.Cells["M" + r].Value);
                        BankName = string.Format("{0}", WS.Cells["N" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["O" + r].Value);
                        Area = string.Format("{0}", WS.Cells["P" + r].Value);
                        District = string.Format("{0}", WS.Cells["Q" + r].Value);
                        BeneficiaryID = string.Format("{0}", WS.Cells["R" + r].Value);
                        Amount = string.Format("{0:N2}", WS.Cells["S" + r].Value);
                        Purpose = string.Format("{0}", WS.Cells["T" + r].Value);
                        PaymentMethod = string.Format("{0}", WS.Cells["U" + r].Value);
                        _ExHouseCode = string.Format("{0}", WS.Cells["V" + r].Value);
                        ToBranch = string.Format("{0}", WS.Cells["W" + r].Value);
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = string.Format("{0}", WS.Cells["X" + r].Value);

                        CommentBR = "";


                        InsertTempUpload(_ExHouseCode
                            , SL
                            , RemitterName
                            , RemitterAddress
                            , BeneficiaryName
                            , BeneficiaryAddress
                            , BankName
                            , BranchName
                            , Area
                            , District
                            , Account
                            , Amount
                            , PIN
                            , Password
                            , RefOrderReceipt
                            , Contact
                            , Purpose
                            , PaymentMethod
                            , ValueDate
                            , BeneficiaryID
                            , ToBranch
                            , CommentHO
                            , CommentBR
                            , RemitterAccount
                            , RemitterAccType
                            , AccountType
                            );
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }

        private void ParseJoy_Ex(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            ValueDate = DateTime.Today.Date.ToString();

            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("DATE"))
                    {
                        ValueDate = WS.Cells["A" + r].Value.ToString().ToUpper().Replace("DATE:", "");
                    }
                }
                catch (Exception) { }
                
                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("S"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S.Trim() == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        SL = string.Format("{0}", WS.Cells["A" + r].Value);
                        RemitterName = string.Format("{0}", WS.Cells["C" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "D" + r);
                        BankName = string.Format("{0}", WS.Cells["H" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["I" + r].Value);
                        Area = "";
                        District = "";
                        Account = getNumberFromCell(WS, "F" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["L" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = string.Format("{0}", WS.Cells["J" + r].Value);
                        if (Account.Trim().Length == 0)
                        {
                            PIN = getNumberFromCell(WS, "B" + r);
                            RefOrderReceipt = "";
                        }
                        else
                        {
                            PIN = "";
                            RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        }
                        Password = "";
                        Contact = string.Format("{0}", WS.Cells["E" + r].Value);
                        Purpose = string.Format("{0}", WS.Cells["G" + r].Value); ;
                        PaymentMethod = "";
                        BeneficiaryID = string.Format("{0}", WS.Cells["K" + r].Value);
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }

        private void ParseTransfast_Ex(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            ValueDate = DateTime.Today.Date.ToString();
            ValueDate = DateTime.Now.Date.ToLongDateString();
            int _SL = 0;

            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                //try
                //{
                //    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                //    if (S.ToUpper().StartsWith("Invoice"))
                //    {
                        
                //        //WS.Cells["A" + r].Value.ToString().ToUpper().Replace("DATE:", "");
                //    }
                //}
                //catch (Exception) { }

                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    if (S.ToUpper().StartsWith("INVOICE"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S.Trim() == "")
                        isDataRow = false;
                }
                catch (Exception) { }

                try
                {
                    if (isDataRow)
                    {
                        _SL++;
                        SL = _SL.ToString();
                        RemitterName = string.Format("{0}", WS.Cells["G" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "H" + r);
                        BankName = string.Format("{0}", WS.Cells["N" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["M" + r].Value);
                        Area = "";
                        District = string.Format("{0}", WS.Cells["P" + r].Value); 
                        Account = getNumberFromCell(WS, "J" + r);
                        Amount = string.Format("{0:N2}", WS.Cells["S" + r].Value);

                        RemitterAddress = "";
                        BeneficiaryAddress = string.Format("{0}", WS.Cells["P" + r].Value);
                        if (Account.Trim().Length == 0)
                        {
                            PIN = getNumberFromCell(WS, "B" + r);
                            RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        }
                        else
                        {
                            PIN = "";
                            RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        }
                        Password = "";
                        Contact = string.Format("{0}", WS.Cells["T" + r].Value);
                        Purpose = "";// string.Format("{0}", WS.Cells["G" + r].Value); ;
                        PaymentMethod = "";
                        BeneficiaryID = "";// string.Format("{0}", WS.Cells["K" + r].Value);
                        ToBranch = "";
                        ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR);
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }


        private void InsertTempUpload(string ExHouseCode1, string SL, string RemitterName, string RemitterAddress, string BeneficiaryName, string BeneficiaryAddress, string BankName, string BranchName, string Area, string District, string Account, string Amount, string PIN, string Password, string RefOrderReceipt, string Contact, string Purpose, string PaymentMethod, string ValueDate, string BeneficiaryID, string ToBranch, string CommentHO, string CommentBR)
        {
            RoutingNumber = "";
            InsertTempUpload(ExHouseCode1, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR, RoutingNumber);
        }
        private void InsertTempUpload(string ExHouseCode1, string SL, string RemitterName, string RemitterAddress, string BeneficiaryName, string BeneficiaryAddress, string BankName, string BranchName, string Area, string District, string Account, string Amount, string PIN, string Password, string RefOrderReceipt, string Contact, string Purpose, string PaymentMethod, string ValueDate, string BeneficiaryID, string ToBranch, string CommentHO, string CommentBR, string RoutingNo)
        {
            RemitterAccount = "";
            RemitterAccType = "";
            AccountType = "";

            InsertTempUpload(ExHouseCode1, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR, RemitterAccount, RemitterAccType, AccountType, RoutingNo);
        }

        private void InsertTempUpload(string ExHouseCode1, string SL, string RemitterName, string RemitterAddress, string BeneficiaryName, string BeneficiaryAddress, string BankName, string BranchName, string Area, string District, string Account, string Amount, string PIN, string Password, string RefOrderReceipt, string Contact, string Purpose, string PaymentMethod, string ValueDate, string BeneficiaryID, string ToBranch, string CommentHO, string CommentBR, string RemitterAccount, string RemitterAccType, string AccountType)
        {
            RoutingNumber = "";
            InsertTempUpload(ExHouseCode1, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR, RemitterAccount, RemitterAccType, AccountType, RoutingNumber);
        }

        private void InsertTempUpload(string ExHouseCode1, string SL, string RemitterName, string RemitterAddress, string BeneficiaryName, string BeneficiaryAddress, string BankName, string BranchName, string Area, string District, string Account, string Amount, string PIN, string Password, string RefOrderReceipt, string Contact, string Purpose, string PaymentMethod, string ValueDate, string BeneficiaryID, string ToBranch, string CommentHO, string CommentBR, string RemitterAccount, string RemitterAccType, string AccountType, string RoutingNo)
        {
            try
            {
                DataSet1.TempUploadRow oRow = DT.NewTempUploadRow();

                if (!chkDoNotChangeAccountNumber.Checked)
                    Account = AccountFilter(Account);
                else
                    Account = Account.Trim();

                RemitterAccount = AccountFilter(RemitterAccount);
                PIN = PINFilter(PIN);

                oRow.ExHouseCode = ExHouseCode1;
                try
                {
                    oRow.SL = int.Parse(SL);
                }
                catch (Exception) { }
                oRow.RemitterName = RemitterName;
                oRow.RemitterAddress = RemitterAddress;
                oRow.BeneficiaryName = BeneficiaryName;
                oRow.BeneficiaryAddress = BeneficiaryAddress;
                oRow.BankName = BankName;
                oRow.BranchName = BranchName;
                oRow.Area = Area;
                oRow.District = District;
                oRow.Account = Account;
                oRow.Amount = decimal.Parse(Amount);
                oRow.PIN = PIN;
                oRow.Password = Password;
                oRow.RefOrderReceipt = RefOrderReceipt;
                oRow.Contact = Contact;
                oRow.Purpose = Purpose;
                oRow.RoutingNumber = RoutingNo;
                try
                {
                    oRow.ValueDate = DateTime.Parse(ValueDate);
                }
                catch (Exception) { }
                oRow.BeneficiaryID = BeneficiaryID;
                try
                {
                    oRow.ToBranch = int.Parse(ToBranch);
                }
                catch (Exception) { }
                oRow.CommentHO = CommentHO;
                oRow.CommentBR = CommentBR;
                oRow.SessionID = HidPageID.Value;
                oRow.EmpID = Session["EMPID"].ToString();
                oRow.InsertDT = DateTime.Now;
                oRow.RemitterAccount = RemitterAccount;
                oRow.RemitterAccType = RemitterAccType;
                oRow.AccountType = AccountType;
                oRow.PaymentMethod = getPaymentMethod(PIN, Account);

                DT.Rows.Add(oRow);


                //ObjectDataSource1.InsertParameters["ExHouseCode"].DefaultValue = ExHouseCode1;//currentWorksheet.Cells[r, 3].Value.ToString();
                //ObjectDataSource1.InsertParameters["SL"].DefaultValue = SL;
                //ObjectDataSource1.InsertParameters["RemitterName"].DefaultValue = RemitterName;
                //ObjectDataSource1.InsertParameters["RemitterAddress"].DefaultValue = RemitterAddress;
                //ObjectDataSource1.InsertParameters["BeneficiaryName"].DefaultValue = BeneficiaryName;
                //ObjectDataSource1.InsertParameters["BeneficiaryAddress"].DefaultValue = BeneficiaryAddress;
                //ObjectDataSource1.InsertParameters["BankName"].DefaultValue = BankName;
                //ObjectDataSource1.InsertParameters["BranchName"].DefaultValue = BranchName;
                //ObjectDataSource1.InsertParameters["Area"].DefaultValue = Area;
                //ObjectDataSource1.InsertParameters["District"].DefaultValue = District;
                //ObjectDataSource1.InsertParameters["Account"].DefaultValue = Account;
                //ObjectDataSource1.InsertParameters["Amount"].DefaultValue = Amount;
                //ObjectDataSource1.InsertParameters["PIN"].DefaultValue = PIN;
                //ObjectDataSource1.InsertParameters["Password"].DefaultValue = Password;
                //ObjectDataSource1.InsertParameters["RefOrderReceipt"].DefaultValue = RefOrderReceipt;
                //ObjectDataSource1.InsertParameters["Contact"].DefaultValue = Contact;
                //ObjectDataSource1.InsertParameters["Purpose"].DefaultValue = Purpose;
                //ObjectDataSource1.InsertParameters["ValueDate"].DefaultValue = ValueDate;
                //ObjectDataSource1.InsertParameters["BeneficiaryID"].DefaultValue = BeneficiaryID;
                //ObjectDataSource1.InsertParameters["ToBranch"].DefaultValue = ToBranch;
                //ObjectDataSource1.InsertParameters["CommentHO"].DefaultValue = CommentHO;
                //ObjectDataSource1.InsertParameters["CommentBR"].DefaultValue = CommentBR;
                //ObjectDataSource1.InsertParameters["SessionID"].DefaultValue = HidPageID.Value;
                //ObjectDataSource1.InsertParameters["EmpID"].DefaultValue = Session["EMPID"].ToString();
                //ObjectDataSource1.InsertParameters["InsertDT"].DefaultValue = DateTime.Now.ToString();
                //ObjectDataSource1.InsertParameters["RemitterAccount"].DefaultValue = RemitterAccount;
                //ObjectDataSource1.InsertParameters["RemitterAccType"].DefaultValue = RemitterAccType;
                //ObjectDataSource1.InsertParameters["AccountType"].DefaultValue = AccountType;
                //ObjectDataSource1.InsertParameters["PaymentMethod"].DefaultValue = getPaymentMethod(PIN, Account);

                //ObjectDataSource1.Insert();
            }
            catch (Exception ex)
            {
            }
        }



        private void RunNonQuery(string Query, string ConnectionStringsName, CommandType commandType)
        {
            string oConnString = System.Configuration.ConfigurationManager.ConnectionStrings[ConnectionStringsName].ConnectionString;
            SqlConnection oConn = new SqlConnection(oConnString);

            SqlCommand oCommand = new SqlCommand(Query, oConn);
            oCommand.CommandType = commandType;
            if (oConn.State == ConnectionState.Closed)
                oConn.Open();
            try
            {
                oCommand.ExecuteNonQuery();
            }
            catch (Exception) { }
        }

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            //RunNonQuery("EXEC sp_Update_CardNumber_from_TempImport '" + HidPageID.Value + "'", "RemittanceConnectionString", CommandType.Text);
            //Panel2.Visible = false;        
            //TrustControl1.ClientMsg("Updated in Card Process Database");
            //CleanDatabase();
            SqlDataSourceRemiList_Add.Select(System.Web.UI.DataSourceSelectArguments.Empty);
        }

        protected void FileUpload1_UploadedFileError(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {

        }        

        protected void ObjectDataSource1_Inserting(object sender, ObjectDataSourceMethodEventArgs e)
        {

        }

        protected void cmdClearData_Click(object sender, EventArgs e)
        {
            CleanDatabase();
        }
        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            if (GridView1.Rows.Count > 0)
            {
                int AmountCol = 0;
                int StatusCol = 0;

                for (int c = 0; c < GridView1.Columns.Count; c++)
                {
                    if (GridView1.HeaderRow.Cells[c].Text == "Amount")
                        AmountCol = c;
                    if (GridView1.HeaderRow.Cells[c].Text == "Status")
                        StatusCol = c;
                }

                double TotalAmount = 0;
                for (int i = 0; i < GridView1.Rows.Count; i++)
                {
                    GridView1.Rows[i].Cells[0].Text = (i + 1).ToString();
                    TotalAmount += double.Parse(GridView1.Rows[i].Cells[AmountCol].Text);

                    if (GridView1.Rows[i].Cells[StatusCol].Text == "REJECT")
                    {
                        GridView1.Rows[i].BackColor = System.Drawing.Color.Teal;
                        cmdUpdate.Visible = false;
                    }
                }
                GridView1.FooterRow.Cells[AmountCol].Text = string.Format("{0:N2}", TotalAmount);
                GridView1.FooterRow.Cells[AmountCol].HorizontalAlign = HorizontalAlign.Right;                

                //Hide Cells
                for (int c = 4; c < 21; c++)
                {
                    bool isEmpty = true;
                    for (int r = 0; r < GridView1.Rows.Count; r++)
                    {
                        if (GridView1.Rows[r].Cells[c].Text.Trim() != "&nbsp;")
                        {
                            isEmpty = false;
                        }
                    }

                    if (isEmpty)
                        GridView1.Columns[c].Visible = false;
                }
            }
        }
        protected void cmdDataBind_Click(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }
        protected void SqlDataSourceRemiList_Add_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            string BatchID = e.Command.Parameters["@Batch"].Value.ToString();
            Label3.Text = string.Format("Data Saved with the Batch ID: {0}", BatchID);
            Label4.Text = string.Format("<a href='ShowBatch.aspx?batch={0}'>Show Data</a>", BatchID);
            Panel2.Visible = false;
            GridView1.Visible = false;
        }

        private string getPaymentMethod(string PIN, string Account)
        {
            string RetVal = "";

            if ((PIN.Trim().Length == 0 || PIN == null) && Account.Trim().Length > 0)
                RetVal = "ACC";

            if (PIN.Trim().Length > 0 && (Account.Trim().Length == 0 || Account == null))
                RetVal = "IC";

            return RetVal;
        }

        private string AccountFilter(string Account)
        {
            string RetVal = Account;

            Regex rgx = new Regex("[^0-9-]");   //take only numbers and dash
            RetVal = rgx.Replace(RetVal, "");
            RetVal = Regex.Replace(RetVal, "-{2,}", "-");   //replacing all consecutive dashes to single dash

            while (RetVal.StartsWith("-"))
                RetVal = RetVal.Substring(1);

            while (RetVal.EndsWith("-"))
                RetVal = RetVal.Substring(0, RetVal.Length - 1);

            return RetVal;
        }

        private string PINFilter(string PIN)
        {
            string RetVal = PIN.Trim();

            if (RetVal.EndsWith(".00"))
                RetVal = RetVal.Substring(0, RetVal.Length - 3);

            Regex rgx = new Regex("[^0-9]");   //take only numbers 
            RetVal = rgx.Replace(RetVal, "");
            return RetVal;
        }

        private string getToBranchAll(string ToBranch)
        {
            if (dboAnyBRanch.SelectedItem.Value == "")
                return ToBranch;
            else
                return dboAnyBRanch.SelectedItem.Value;
        }
    }
}