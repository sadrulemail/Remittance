using System;
using System.IO;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using OfficeOpenXml;
using System.Text.RegularExpressions;

namespace Remittance
{
    public partial class Upload_Web : System.Web.UI.Page
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
        string PaidBranch;
        string PaidOn;
        string RITCountryCode;
        string FxAmount;
        string FxCurrency;
        string brname;
        DataSetWeb.TempUpload_WEBDataTable DT;
        DataSetMap.Branch_MappingDataTable DTMap;
        DataSetMap.v_RIT_CountryCodesDataTable DTCountry;
        DataSetMap.v_BranchOnlyDataTable DTBranch;

        protected void Page_Load(object sender, EventArgs e)
        {
             
            

            this.Title = "Upload Remittance Web Data";

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
            RunNonQuery("EXEC sp_DeleteTempUpload_Web '" + HidPageID.Value + "', '" + Session["EMPID"].ToString() + "'", "RemittanceConnectionString", CommandType.Text);
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

        protected void cmdViewData_Click(object sender, EventArgs e)
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
            DT = new DataSetWeb.TempUpload_WEBDataTable();
            
            
            
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
                            case "NMT/NEC WEB":
                                ParseWorkSheet_NMTNEC_WEB(currentWorksheet, ExHouseCode);
                                break;                            
                            case "RIA WEB":
                                Parse_RIA_WEB_Ex(currentWorksheet, ExHouseCode);
                                break;                                
                            case "PLD WEB":
                                Parse_PLD_WEB_Ex(currentWorksheet, ExHouseCode);
                                break;
                            case "WU WEB":
                                Parse_WU_WEB_Ex(currentWorksheet, ExHouseCode);
                                break;
                                
                            case "XM WEB":
                                Parse_XM_WEB_Ex(currentWorksheet, ExHouseCode);
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
                        bulkCopy.DestinationTableName = "TempUpload_WEB";
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
                lblStatus.Text = "Parsing file failed. Please check your file format.";
                File.Delete(HidUploadTempFile.Value);
            }


            Panel2.Visible = true;
        }
       

        private void Parse_RIA_WEB_Ex(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = true;
            int SL = 0;

            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);
                    
                    if (S.StartsWith("Date"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S == "")
                        isDataRow = false;
                }
                catch (Exception) { continue; }

                try
                {
                    if (isDataRow)
                    {
                        SL++;                        
                        ValueDate = WS.Cells["A" + r].Value.ToString();
                        //ValueDate = (DateTime.ParseExact(WS.Cells["A" + r].Value.ToString(), "dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture)).ToLongDateString(); //WS.Cells["E" + r].Value.ToString();                                                
                        RemitterName = "";//(string.Format("{0}", WS.Cells["K" + r].Value) + " " + string.Format("{0}", WS.Cells["L" + r].Value) + " " + string.Format("{0}", WS.Cells["M" + r].Value));                        
                        BeneficiaryName ="" ;//(string.Format("{0}", WS.Cells["T" + r].Value) + " " + string.Format("{0}", WS.Cells["U" + r].Value) + " " + string.Format("{0}", WS.Cells["V" + r].Value));                        
                        BankName = "Trust Bank Ltd.";
                        BranchName = string.Format("{0}", WS.Cells["D" + r].Value);
                        Area = "";
                        District = "";
                        Account = "";
                        Amount = string.Format("{0:N2}", WS.Cells["M" + r].Value); //Received Amount                        

                        PaidOn = WS.Cells["G" + r].Value.ToString();
                        PaidBranch= WS.Cells["C" + r].Value.ToString();
                        PaidBranch = (PaidBranch.Substring(1 + PaidBranch.LastIndexOf("-"))).Trim();
                        try
                        {
                            int BrCode = int.Parse(PaidBranch);
                        }
                        catch (Exception) { continue; }

                        RemitterAddress = ""; //string.Format("{0}", WS.Cells["O" + r].Value);
                        BeneficiaryAddress = "";// string.Format("{0}", WS.Cells["X" + r].Value); 
                        PIN = getNumberFromCell(WS, "K" + r); // string.Format("{0}", WS.Cells["A" + r].Value); ;
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["F" + r].Value); //Order no.
                        Purpose = "";
                        PaymentMethod = "IC";
                        BeneficiaryID = "";
                        //ToBranch = string.Format("{0}", WS.Cells["D" + r].Value);
                        ToBranch = PaidBranch;
                        Contact = "";                        
                        CommentHO = "";
                        CommentBR = "";
                        RoutingNumber = "";
                        FxAmount = "0";
                        FxCurrency = "";
                        RITCountryCode = "0";
                        InsertTempUpload(_ExHouseCode, SL.ToString(), RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR, int.Parse(PaidBranch), PaidOn, FxAmount, FxCurrency, RITCountryCode);                        
                    }
                }
                catch (Exception ex)
                {
                   // lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }

        private void Parse_PLD_WEB_Ex(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = true;
            int SL = 0;

            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);

                    if (S.StartsWith("Pay Date"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S == "")
                        isDataRow = false;
                }
                catch (Exception) { continue; }

                try
                {
                    if (isDataRow)
                    {
                        SL++;
                        
                        ValueDate = WS.Cells["A" + r].Value.ToString();
                        //ValueDate = (DateTime.ParseExact(WS.Cells["A" + r].Value.ToString(), "dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture)).ToLongDateString(); //WS.Cells["E" + r].Value.ToString();                                                
                        RemitterName = "";//(string.Format("{0}", WS.Cells["K" + r].Value) + " " + string.Format("{0}", WS.Cells["L" + r].Value) + " " + string.Format("{0}", WS.Cells["M" + r].Value));                        
                        BeneficiaryName = string.Format("{0}", WS.Cells["C" + r].Value);                        
                        BranchName= WS.Cells["D" + r].Value.ToString();                        
                        BranchName = BranchName.Substring(0, BranchName.IndexOf('/')).Trim();
                        BranchName = BranchName.Trim();
                        BankName = "Trust Bank Ltd.";                        
                        Area = "";
                        District = "";
                        Account = "";
                        Amount = string.Format("{0:N2}", WS.Cells["E" + r].Value); //Received Amount
                        PaidOn = WS.Cells["A" + r].Value.ToString();
                        PaidBranch = WS.Cells["D" + r].Value.ToString();
                        PaidBranch = (PaidBranch.Substring(1 + PaidBranch.LastIndexOf("-"))).Trim();

                        try
                        {
                            int BrCode = int.Parse(PaidBranch);
                        }
                        catch (Exception) { continue; }

                        RemitterAddress = ""; //string.Format("{0}", WS.Cells["O" + r].Value);
                        BeneficiaryAddress = "";// string.Format("{0}", WS.Cells["X" + r].Value); 
                        PIN = ""; //getNumberFromCell(WS, "K" + r); // string.Format("{0}", WS.Cells["A" + r].Value); ;
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value); //Tracking
                        Purpose = "";
                        PaymentMethod = "IC";
                        BeneficiaryID = "";
                        //ToBranch = string.Format("{0}", WS.Cells["D" + r].Value);
                        ToBranch = PaidBranch;
                        Contact = "";
                        CommentHO = "";
                        CommentBR = "";
                        RoutingNumber = "";
                        FxAmount = "0";
                        FxCurrency = "";
                        RITCountryCode = "0";
                        InsertTempUpload(_ExHouseCode, SL.ToString(), RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR, int.Parse(PaidBranch), PaidOn, FxAmount, FxCurrency, RITCountryCode);
                    }
                }
                catch (Exception ex)
                {
                    // lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
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
   
     
        
        private void ParseWorkSheet_NMTNEC_WEB(ExcelWorksheet WS, string _ExHouseCode)
        {
            bool isDataRow = false;
            //int iSL = 1;
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
                        RemitterName = string.Format("{0}", WS.Cells["D" + r].Value);
                        BeneficiaryName = getNumberFromCell(WS, "K" + r);
                        BankName = "Trust Bank Ltd.";//string.Format("{0}", WS.Cells["O" + r].Value);
                        BranchName = string.Format("{0}", WS.Cells["P" + r].Value);
                        Area = string.Format("{0}", WS.Cells["L" + r].Value); 
                        District = string.Format("{0}", WS.Cells["L" + r].Value); 
                        Account = "";
                        Amount = string.Format("{0:N2}", WS.Cells["R" + r].Value);

                        RemitterAddress = string.Format("{0}", WS.Cells["F" + r].Value) + "," + string.Format("{0}", WS.Cells["E" + r].Value);
                        BeneficiaryAddress = string.Format("{0}", WS.Cells["L" + r].Value);
                        PIN = "";
                        Password = string.Format("{0}", WS.Cells["N" + r].Value);
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        Contact = string.Format("{0}", WS.Cells["Q" + r].Value);
                        Purpose = "";
                        PaymentMethod = "IC";
                        BeneficiaryID = "";
                        //ToBranch = "0";
                        //ToBranch = getToBranchAll(ToBranch);
                        CommentHO = "";
                        CommentBR = "";
                        PaidOn = WS.Cells["G" + r].Value.ToString();
                        PaidBranch = WS.Cells["J" + r].Value.ToString();
                        //PaidBranch = (PaidBranch.Substring(1 + PaidBranch.LastIndexOf("-"))).Trim();
                        try
                        {
                            int BrCode = int.Parse(PaidBranch);
                        }
                        catch (Exception) { continue; }

                        ToBranch = PaidBranch;
                        FxAmount = "0";
                        FxCurrency = "";
                        RITCountryCode = "0";

                        InsertTempUpload(_ExHouseCode, SL, RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR, int.Parse(PaidBranch), PaidOn, FxAmount, FxCurrency, RITCountryCode);
                        
                    }
                }
                catch (Exception ex)
                {
                    lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }

        private void Parse_WU_WEB_Ex(ExcelWorksheet WS, string _ExHouseCode)
        {
            DTMap = new DataSetMap.Branch_MappingDataTable();
            DTCountry = new DataSetMap.v_RIT_CountryCodesDataTable();
            

            DataView dvBranches = (DataView)ObjectDataSourceMapping.Select();
            DTMap = (DataSetMap.Branch_MappingDataTable)dvBranches.Table;

            DataView dvRITCountry = (DataView)ObjectDataSourceRITCountry.Select();
            DTCountry = (DataSetMap.v_RIT_CountryCodesDataTable)dvRITCountry.Table;


            bool isDataRow = true;
            int SL = 0;

            for (int r = 1; r <= WS.Dimension.End.Row; r++)
            {
                try
                {
                    string S = string.Format("{0}", WS.Cells["A" + r].Value);

                    if (S.StartsWith("Branch Code"))
                    {
                        isDataRow = true;
                        continue;
                    }
                    else if (isDataRow && S == "")
                        isDataRow = false;
                }
                catch (Exception) { continue; }

                try
                {
                    if (isDataRow)
                    {
                        SL++;

                        //ValueDate = WS.Cells["A" + r].Value.ToString();
                        ValueDate = DateTime.Now.Date.ToString();
                        
                        RemitterName = "";
                        BeneficiaryName = "";
                        BranchName = "";
                        BankName = "Trust Bank Ltd.";
                        Area = WS.Cells["C" + r].Value.ToString();
                        Area = Area.Substring(0, Area.IndexOf(' ')).Trim();
                        Area = Area.Trim();

                        District = "";
                        Account = "";
                        Amount = string.Format("{0:N2}", WS.Cells["F" + r].Value); //Received Amount
                        FxAmount = string.Format("{0:N2}", WS.Cells["E" + r].Value); //USD Amount
                        FxCurrency = "USD";
                        PaidOn = DateTime.Now.Date.ToString();
                        PaidBranch = "";// WS.Cells["D" + r].Value.ToString();

                        //Branch
                        DataRow [] brRows = DTMap.Select("Mapping_Code='" + WS.Cells["A" + r].Value.ToString().Trim() + "'");
                        if (brRows.Length > 0)
                        {
                            DataSetMap.Branch_MappingRow oRow = (DataSetMap.Branch_MappingRow)brRows[0];
                            PaidBranch = oRow.BranchID.ToString();
                        }

                        //PaidBranch = (PaidBranch.Substring(1 + PaidBranch.LastIndexOf("-"))).Trim();
                        //RIT Country Code
                        DataRow[] ritRows = DTCountry.Select("RIT_Country_Name='" + WS.Cells["B" + r].Value.ToString().Trim() + "'");
                        if (ritRows.Length > 0)
                        {
                            DataSetMap.v_RIT_CountryCodesRow oRow1 = (DataSetMap.v_RIT_CountryCodesRow)ritRows[0];
                            RITCountryCode = oRow1.RIT_Country_ID.ToString();
                        }

                        try
                        {
                            int BrCode = int.Parse(PaidBranch);
                        }
                        catch (Exception) { continue; }
                        
                        RemitterAddress = ""; 
                        BeneficiaryAddress = "";
                        PIN = ""; 
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["D" + r].Value); 
                        Purpose = "";
                        PaymentMethod = "IC";
                        BeneficiaryID = "";                        
                        ToBranch = PaidBranch;
                        Contact = "";
                        CommentHO = string.Format("{0}", WS.Cells["B" + r].Value);
                        CommentBR = "";
                        RoutingNumber = "";
                        InsertTempUpload(_ExHouseCode, SL.ToString(), RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR, int.Parse(PaidBranch), PaidOn, FxAmount, FxCurrency, RITCountryCode);
                    }
                }
                catch (Exception ex)
                {
                    // lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }

        private void Parse_XM_WEB_Ex(ExcelWorksheet WS, string _ExHouseCode)
        {

            DataView dvRITCountry = (DataView)ObjectDataSourceRITCountry.Select();
            DTCountry = (DataSetMap.v_RIT_CountryCodesDataTable)dvRITCountry.Table;

            DataView dvBranchID = (DataView)ObjectDataSourceBranchOnly.Select();
            DTBranch = (DataSetMap.v_BranchOnlyDataTable)dvBranchID.Table;

            bool isDataRow = true;
           int SL = 1;

            for (int r = 2; r <= WS.Dimension.End.Row; r++)
            {
                

                try
                {
                    if (isDataRow)
                    {
                        SL++;
                        //ValueDate = WS.Cells["H" + r].Value.ToString();
                        ValueDate=string.Format("{0:dd/MM/yyyy}", WS.Cells["H" + r].Value);
                        RemitterName = WS.Cells["D" + r].Value.ToString(); 
                        BeneficiaryName = WS.Cells["C" + r].Value.ToString(); 
                        BranchName = WS.Cells["A" + r].Value.ToString();
                        BranchName = (BranchName.Substring(1 + BranchName.LastIndexOf("-"))).Trim();
                        BankName = "Trust Bank Ltd.";
                        Area = WS.Cells["K" + r].Value.ToString();     
                        District = WS.Cells["J" + r].Value.ToString(); 
                        Account = "";
                        Amount = string.Format("{0:N2}", WS.Cells["F" + r].Value); //Received Amount
                        FxAmount = string.Format("{0:N2}", WS.Cells["G" + r].Value); //USD Amount
                        FxCurrency = "USD";
                        PaidOn = WS.Cells["H" + r].Value.ToString(); 
                        //PaidBranch = BranchName;// WS.Cells["D" + r].Value.ToString();
                        //RIT Country Code
                        DataRow[] ritRows = DTCountry.Select("RIT_Country_Name='" + WS.Cells["E" + r].Value.ToString().Trim() + "'");
                        if (ritRows.Length > 0)
                        {
                            DataSetMap.v_RIT_CountryCodesRow oRow1 = (DataSetMap.v_RIT_CountryCodesRow)ritRows[0];
                            RITCountryCode = oRow1.RIT_Country_ID.ToString();
                        }

                        //Branch
                        brname = " Branch";
                        DataRow[] ritRows2 = DTBranch.Select("BranchName='" + WS.Cells["I" + r].Value.ToString().Trim() + "'");
                        if (ritRows2.Length > 0)
                        {
                            DataSetMap.v_BranchOnlyRow oRow2 = (DataSetMap.v_BranchOnlyRow)ritRows2[0];
                            PaidBranch = oRow2.BranchID.ToString();
                        }
                        else
                        {
                            PaidBranch = "0";
                        }

                        //try
                        //{
                        //    int BrCode = int.Parse(PaidBranch);
                        //}
                        //catch (Exception) { continue; }

                        RemitterAddress = "";
                        BeneficiaryAddress = "";
                        PIN = "";
                        Password = "";
                        RefOrderReceipt = string.Format("{0}", WS.Cells["B" + r].Value);
                        Purpose = "";
                        PaymentMethod = "IC";
                        BeneficiaryID = "";
                        ToBranch = PaidBranch;
                        Contact = "";
                        CommentHO = string.Format("{0}", WS.Cells["L" + r].Value);
                        CommentBR = "";
                        RoutingNumber = "";
                        InsertTempUpload(_ExHouseCode, SL.ToString(), RemitterName, RemitterAddress, BeneficiaryName, BeneficiaryAddress, BankName, BranchName, Area, District, Account, Amount, PIN, Password, RefOrderReceipt, Contact, Purpose, PaymentMethod, ValueDate, BeneficiaryID, ToBranch, CommentHO, CommentBR, int.Parse(PaidBranch), PaidOn, FxAmount, FxCurrency, RITCountryCode);
                    }
                }
                catch (Exception ex)
                {
                    // lblStatus.Text += "<br>" + r.ToString() + " " + ex.Message;
                }
            }
        }

        private void InsertTempUpload(string ExHouseCode1, string SL, string RemitterName, string RemitterAddress, string BeneficiaryName, string BeneficiaryAddress, string BankName, string BranchName, string Area, string District, string Account, string Amount, string PIN, string Password, string RefOrderReceipt, string Contact, string Purpose, string PaymentMethod, string ValueDate, string BeneficiaryID, string ToBranch, string CommentHO, string CommentBR, int PaidBranch, string PaidOn, string FxAmount, string FxCurrency, string RITCountryCode)
        {
        
            try
            {
                
                DataSetWeb.TempUpload_WEBRow oRow = DT.NewTempUpload_WEBRow();

                //RemitterAccount = AccountFilter(RemitterAccount);
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
                //oRow.RoutingNumber = RoutingNo;
                try
                {
                    oRow.ValueDate = DateTime.Parse(ValueDate);
                }
                catch (Exception) { }
                try
                {
                   oRow.PaidOn = DateTime.Parse(PaidOn);
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
                oRow.PaidBranch = PaidBranch;
                oRow.ToBranch = PaidBranch;
                //oRow.PaidOn = PaidOn;
                oRow.SessionID = HidPageID.Value;
                oRow.EmpID = Session["EMPID"].ToString();
                oRow.InsertDT = DateTime.Now;
                //oRow.RemitterAccount = RemitterAccount;
                //oRow.RemitterAccType = RemitterAccType;
                //oRow.AccountType = AccountType;
                oRow.PaymentMethod = PaymentMethod;// getPaymentMethod(PIN, Account);
                oRow.FxAmount = decimal.Parse(FxAmount);
                oRow.FxCountryCode = int.Parse(RITCountryCode);
                oRow.FxCurrency = FxCurrency;           

                DT.Rows.Add(oRow);                
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
                for (int c = 0; c < GridView1.Columns.Count; c++)
                    if (GridView1.HeaderRow.Cells[c].Text == "Amount")
                        AmountCol = c;

                double TotalAmount = 0;
                for (int i = 0; i < GridView1.Rows.Count; i++)
                {
                    GridView1.Rows[i].Cells[0].Text = (i + 1).ToString();
                    TotalAmount += double.Parse(GridView1.Rows[i].Cells[AmountCol].Text);
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

        //private string getToBranchAll(string ToBranch)
        //{
        //    //if (dboAnyBRanch.SelectedItem.Value == "")
        //    //    return ToBranch;
        //    //else
        //    //    return dboAnyBRanch.SelectedItem.Value;
        //}
    }
}