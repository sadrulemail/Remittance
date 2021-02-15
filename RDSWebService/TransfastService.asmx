 <%@ WebService Language="C#" Class="TransfastService" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Xml;
using System.IO;
using System.Net;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Security.Cryptography;
using System.Text;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Net.Http;
using System.Web.Script.Serialization;
/// </summary>
[WebService(Namespace = "https://ibanking.tblbd.com/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class TransfastService : System.Web.Services.WebService
{

    public TransfastService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod(Description = "Service Task: Download invoice new or Previously downloaded Invoice"
        + "<br>" + "Returns:"
        + "<br>" + "Response Code=1: " + "Success"

      )]
    public string DownloadAllInvoices(

 string EmpID,
 bool ThirdPartyBD,
 string KeyCode
  )
    {
        string TransfastUrl = getValueOfKey("TransfastUrl");
        string InvoiceUrl = TransfastUrl + "invoice/downloadedinvoices?ModeOfPayment=C";
        // string InvoiceUrl = "https://demo-pay.transfast.net/api/invoice/downloadedinvoices?ModeOfPayment=C";
        //  string InvoiceUrl = "https://demo-pay.transfast.net/api/invoice/downloadedinvoices?IncludeDownloadedInvoices=True&ModeOfPayment=C";
        //  string jsonText = "";
        string json = "";
        string CallRefID = Guid.NewGuid().ToString();
        int SaveStatus = 3;
        string RemilistStatus = "0";
        string token_ = "";
        try
        {
            if (ThirdPartyBD)
                token_ = CredEncrypt(getValueOfKey("TransfastSystemId"), getValueOfKey("TransfastUserName3P"), getValueOfKey("TransfastPassword3P"), getValueOfKey("TransfastBranchId3P"));
            else
                token_ = CredEncrypt(getValueOfKey("TransfastSystemId"), getValueOfKey("TransfastUserName"), getValueOfKey("TransfastPassword"), getValueOfKey("TransfastBranchId"));
            var myUri = new Uri(InvoiceUrl);
            var myWebRequest = WebRequest.Create(myUri);
            var myHttpWebRequest = (HttpWebRequest)myWebRequest;
            myHttpWebRequest.PreAuthenticate = true;
            myHttpWebRequest.Headers.Add("Authorization", token_);
            myHttpWebRequest.Accept = "application/json";
            // myWebRequest.Method = "PUT"; //for download invoice
            var myWebResponse = myWebRequest.GetResponse();
            var responseStream = myWebResponse.GetResponseStream();
            if (responseStream != null)
            {
                var myStreamReader = new StreamReader(responseStream, Encoding.Default);
                json = myStreamReader.ReadToEnd();
                //  jsonText = string.Format("{0}", json);
                responseStream.Close();
                myWebResponse.Close();
                JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

                TfInvoices invoiceList = jsonSerializer.Deserialize<TfInvoices>(json);


                SaveStatus = SaveBulkInvoice(invoiceList, EmpID, CallRefID, false, ThirdPartyBD);
                if (SaveStatus == 1)
                    RemilistStatus = SaveInvoiceToRemilist(CallRefID, EmpID, "s_Tf_InvoiceDownload_Save").ToString();
            }

        }
        catch (WebException e)

        {

            TfBusinessErrors errorObj = GetTfBussinessError(e);
            RemilistStatus = errorObj.Message + "-" + errorObj.ErrorCode;
            // string   http_responseMsg = errorObj.Message;

        }
        catch (Exception ex)
        {
            Common.WriteLog(CallRefID, "TfAPI", "DownloadAllInvoices", ex.Message);
            RemilistStatus = ex.Message;
        }
        finally
        {
            SaveReqResponseData("TfAPI", "", "DownloadAllInvoices", DateTime.Now, token_, json.ToString(), SaveStatus.ToString(), RemilistStatus);
        }
        return RemilistStatus.ToString();
    }
    private int SaveBulkInvoice(TfInvoices invoiceList, string EmpID, string CallRefID, bool IsNewDownload, bool ThirdPartyBD)
    {
        int IsSave = 0;
        DataTable dt_mtr = new DataTable();
        dt_mtr.Columns.Add("ID", typeof(long));
        dt_mtr.Columns.Add("ExHouseCode", typeof(string));
        dt_mtr.Columns.Add("SessionID", typeof(string));
        dt_mtr.Columns.Add("TfPin", typeof(string));
        dt_mtr.Columns.Add("StatusName", typeof(string));
        dt_mtr.Columns.Add("TransactionDate", typeof(DateTime));
        dt_mtr.Columns.Add("BeneficiaryCurrency", typeof(string));
        dt_mtr.Columns.Add("BeneficiaryAmount", typeof(decimal));
        dt_mtr.Columns.Add("SendAmount", typeof(decimal));
        dt_mtr.Columns.Add("ExchangeRate", typeof(decimal));
        dt_mtr.Columns.Add("PaymentModeName", typeof(string));

        dt_mtr.Columns.Add("Account", typeof(string));
        dt_mtr.Columns.Add("BankName", typeof(string));
        dt_mtr.Columns.Add("BranchName", typeof(string));
        dt_mtr.Columns.Add("RemitterName", typeof(string));
        dt_mtr.Columns.Add("RemitterAddress", typeof(string));
        dt_mtr.Columns.Add("BeneficiaryName", typeof(string));
        dt_mtr.Columns.Add("BeneficiaryAddress", typeof(string));
        dt_mtr.Columns.Add("BeneficiaryState", typeof(string));
        dt_mtr.Columns.Add("BeneficiaryStateID", typeof(string));
        dt_mtr.Columns.Add("BeneficiaryCity", typeof(string));
        dt_mtr.Columns.Add("BeneficiaryCityID", typeof(string));
        dt_mtr.Columns.Add("BeneficiaryMobile", typeof(string));

        dt_mtr.Columns.Add("RemitterID", typeof(string));
        dt_mtr.Columns.Add("RemitterType", typeof(string));
        dt_mtr.Columns.Add("RemitterIDExpiryDate", typeof(DateTime));
        dt_mtr.Columns.Add("BeneficiaryID", typeof(string));
        dt_mtr.Columns.Add("BeneficiaryIDType", typeof(string));
        dt_mtr.Columns.Add("Purpose", typeof(string));
        dt_mtr.Columns.Add("RID", typeof(Int64));
        dt_mtr.Columns.Add("EmpID", typeof(string));
        dt_mtr.Columns.Add("InsertDT", typeof(DateTime));
        dt_mtr.Columns.Add("ReceiverCountryIsoCode", typeof(string));
        dt_mtr.Columns.Add("ThirdPartyBD", typeof(bool));
        dt_mtr.Columns.Add("IsNewDownload", typeof(bool));

        DateTime? TransactionDate = null;
        DateTime? SenderIDDateExpiry = null;
        try
        {
            foreach (TfInvoice invObj in invoiceList.Invoices)
            {
                try
                {
                    TransactionDate = DateTime.Parse(String.Format("{0:dd-MM-yyyy HH:mm:ss}", invObj.TransactionDate));
                }
                catch (Exception ex) { }
                try
                {
                    SenderIDDateExpiry = DateTime.Parse(String.Format("{0:dd-MM-yyyy HH:mm:ss}", invObj.SenderIDDateExpiry));
                }
                catch (Exception ex) { }

                dt_mtr.Rows.Add(null, "TfAPI", CallRefID, invObj.TfPin, invObj.StatusName, TransactionDate, invObj.ReceiveCurrencyIsoCode,
                    invObj.ReceiveAmount, invObj.SendAmount, invObj.ExchangeRate, invObj.PaymentModeName,
                    invObj.AccountNumber, invObj.BankName, invObj.BankBranch, invObj.SenderFullName, invObj.SenderAddress, invObj.ReceiverFullName,
                    invObj.ReceiverAddress, invObj.ReceiverStateName, invObj.ReceiverStateId, invObj.ReceiverCityName, invObj.ReceiverCityId, invObj.ReceiverPhoneMobile,
                    invObj.SenderId, invObj.SenderIDType, SenderIDDateExpiry, invObj.ReceiverIDNumber, invObj.ReceiverIDType, invObj.PurposeOfRemittanceId, null,
                    EmpID, DateTime.Now, invObj.ReceiverCountryIsoCode, ThirdPartyBD, IsNewDownload);
            }


            if (dt_mtr.Rows.Count > 0)
            {
                string connString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                // open the destination data
                using (SqlConnection destinationConnection = new SqlConnection(connString))
                {
                    // open the connection
                    destinationConnection.Open();
                    using (SqlBulkCopy bulkCopy =
                         new SqlBulkCopy(destinationConnection.ConnectionString,
                                SqlBulkCopyOptions.TableLock))
                    {
                        bulkCopy.BulkCopyTimeout = 0;
                        bulkCopy.DestinationTableName = "TfInvoicesDownload";
                        //  bulkCopy.DestinationTableName = DestinationTable;
                        bulkCopy.WriteToServer(dt_mtr);
                    }

                }
                IsSave = 1;
            }

        }
        catch (Exception ex)
        {
            IsSave = 2;
            Common.WriteLog("TfInvoicesDownload", "TfAPI", "SaveBulkInvoice", ex.Message);
        }
        return IsSave;
    }

    private int SaveInvoiceToRemilist(string CallRefID, string EmpID, string s_Query)
    {
        int Done = 5;
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = s_Query;//*** "s_Tf_InvoiceDownload_Save"
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@RefCallID", System.Data.SqlDbType.VarChar).Value = CallRefID;
                    cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = EmpID;

                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Int);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = 0;
                    cmd.Parameters.Add(sqlDone);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    Done = (int)sqlDone.Value;

                }

            }
        }
        catch (Exception ex)
        {
            Common.WriteLog(CallRefID, "Transfast API", "s_Tf_InvoiceDownload_Save", ex.Message);
        }
        return Done;
    }


    [WebMethod(Description = "Service Task: Pay the specified Invoice"
     + "<br>" + "Returns:"
     + "<br>" + "Response Code=1: " + "Success"
     + "<br>" + "Response Code=-2: " + "Invalid keycode"

    )]
    public string PayInvoices(

    string KeyCode
    )
    {
        if (KeyCode != getValueOfKey("Transfast_KeyCode"))
        {
            return "-2";
        }
        TfIPayInvoice jsonObj = GetInvoicePaidToTransfast();

        //        string json_ = @"{" +
        //"\"TfPin\":\"33TF624817075\"," +
        //"\"IdNumber\":\"123456789\"," +
        //"\"IdType\":14," +
        //"\"IdTypeStringReplacement\":\"14\"," +
        //"\"IdExpirationDate\":\"2019-03-29T00:00:00+03:00\"," +
        //"\"IdDateOfIssue\":\"1980-03-29T00:00:00+03:00\"," +
        //"\"IdIssuedBy\":\"Romania\"," +
        //"\"IdPlaceofIssue\":\"Romania\"," +
        //"\"ReceiverAddress\":\"address\"," +
        //"\"ReceiverOccupationId\":3," +
        //"\"RemittanceReasonId\": 1," +
        //"\"ReceiverCountryIsoCode\":\"BD\"," +
        //"\"ReceiverStateId\":\"BG046\"," +
        //"\"ReceiverCityId\":\"50274\"," +
        //"\"ReceiverPhoneHome\":\"123456789\"," +
        //"\"ReceiverDoB\":\"1980-03-29T00:00:00+03:00\"," +
        //"\"ReceiverNationalityIsoCode\":\"BD\"," +
        //"\"ReceiverGender\":\"M\"," +
        //"\"ReceiverRelationToSender\":\"Parent\"," +
        //"\"FormOfPaymentId\":\"CA\"," +
        //"\"ProofOfAddressCollected\":true," +
        //"\"KYCVerified\":false}";


        //string TransfastUrl = getValueOfKey("TransfastUrl");
        //string InvoiceUrl = TransfastUrl +"invoice/downloadedinvoices?IncludeDownloadedInvoices=False&ModeOfPayment=C";
        string InvoiceUrl = "https://demo-pay.transfast.net/api/invoice/payinvoice";
        string http_response = "";
        int SaveStatus = 3;
        int RemilistStatus = 0;
        string token_ = "";
        string http_responseMsg = "";
        if (jsonObj.RID == 0)
        {
            return "5";
        }
        //  TfBusinessErrors errorObj = new TfBusinessErrors();
        try
        {
            // token_ = CredEncrypt(getValueOfKey("TransfastSystemId"), getValueOfKey("TransfastUserName"), getValueOfKey("TransfastPassword"), getValueOfKey("TransfastBranchId"));

            if (jsonObj.ThirdPartyBD)
                token_ = CredEncrypt(getValueOfKey("TransfastSystemId"), getValueOfKey("TransfastUserName3P"), getValueOfKey("TransfastPassword3P"), getValueOfKey("TransfastBranchId3P"));
            else
                token_ = CredEncrypt(getValueOfKey("TransfastSystemId"), getValueOfKey("TransfastUserName"), getValueOfKey("TransfastPassword"), getValueOfKey("TransfastBranchId"));

            var bytes = Encoding.ASCII.GetBytes(jsonObj.JsonInvoice);
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(InvoiceUrl);
            request.PreAuthenticate = true;
            request.Headers.Add("Authorization", token_);
            request.Method = "PUT";
            request.ContentType = "application/json";
            using (var requestStream = request.GetRequestStream())
            {
                requestStream.Write(bytes, 0, bytes.Length);
            }
            try
            {
                var response = (HttpWebResponse)request.GetResponse();
                http_response = response.StatusCode.ToString();
            }
            catch (WebException e)
            {

                TfBusinessErrors errorObj = GetTfBussinessError(e);
                http_response = errorObj.ErrorCode;
                http_responseMsg = errorObj.Message;


            }
            catch (Exception ex)
            {
                RemilistStatus = 3;
                http_response = ex.Message;

                Common.WriteLog(jsonObj.RID.ToString(), "TfAPI", "PayInvoices", ex.Message);
            }

            RemilistStatus = UpdateRemilistStatus(jsonObj.RID, "payinvoice", "",http_response, http_responseMsg, "");



        }
        catch (Exception ex)
        {

            Common.WriteLog(jsonObj.RID.ToString(), "TfAPI", "PayInvoices", ex.Message);
            UpdateRemilistStatus(jsonObj.RID, "payinvoice", "",http_response, http_responseMsg, "");
        }
        finally
        {
            SaveReqResponseData("TfAPI", jsonObj.RID.ToString(), "Transfast PayInvoice", DateTime.Now, jsonObj.JsonInvoice, http_response, SaveStatus.ToString(), RemilistStatus.ToString());
        }
        return RemilistStatus.ToString();
    }

    private string GetToken(bool ThirdPartyBD)
    {
        string token_ = "";
        if (ThirdPartyBD)
            token_ = CredEncrypt(getValueOfKey("TransfastSystemId"), getValueOfKey("TransfastUserName3P"), getValueOfKey("TransfastPassword3P"), getValueOfKey("TransfastBranchId3P"));
        else
            token_ = CredEncrypt(getValueOfKey("TransfastSystemId"), getValueOfKey("TransfastUserName"), getValueOfKey("TransfastPassword"), getValueOfKey("TransfastBranchId"));
        return token_;
    }

    private TfBusinessErrors GetTfBussinessError(WebException e)
    {
        TfBusinessErrors objError = new TfBusinessErrors();

        using (WebResponse response = e.Response)
        {
            HttpWebResponse httpResponse = (HttpWebResponse)response;
            string httpStatus = httpResponse.StatusCode.ToString();
            using (Stream data = response.GetResponseStream())
            using (var reader = new StreamReader(data))
            {
                string json = reader.ReadToEnd();
                if (json != "")
                {
                    JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
                    //dynamic dobj = jsonSerializer.Deserialize<dynamic>(json);
                    //objError.ErrorCode = dobj["BusinessErrors"][0]["ErrorCode"].ToString();
                    //objError.Message = dobj["BusinessErrors"][0]["Message"].ToString();

                    TfErrors error_Obj = jsonSerializer.Deserialize<TfErrors>(json);
                    foreach (TfBusiness_Errors error in error_Obj.BusinessErrors)
                    {
                        objError.ErrorCode = error.ErrorCode;
                        objError.Message = error.Message;
                    }
                    if (objError.ErrorCode == null || objError.ErrorCode == "")
                        foreach (TfDataValidationErrors errorValidatin in error_Obj.DataValidationErrors)
                        {
                            objError.ErrorCode = errorValidatin.ErrorCode;
                            objError.Message = errorValidatin.Message + "," + errorValidatin.FieldName;
                        }



                }
                else
                    objError.ErrorCode = httpStatus;
            }
        }
        return objError;
    }

    private TfIPayInvoice GetInvoicePaidToTransfast()
    {
        TfIPayInvoice objInv = new TfIPayInvoice();

        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Tf_GetInvoiceToPaid";//*** get invoice for mark as paid
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    SqlParameter sqlRID = new SqlParameter("@RID", SqlDbType.BigInt);
                    sqlRID.Direction = ParameterDirection.InputOutput;
                    sqlRID.Value = 0;
                    cmd.Parameters.Add(sqlRID);

                    SqlParameter sqlJson = new SqlParameter("@xml", SqlDbType.VarChar, -1);
                    sqlJson.Direction = ParameterDirection.InputOutput;
                    sqlJson.Value = "";
                    cmd.Parameters.Add(sqlJson);

                    SqlParameter sqlThirdPartyBD = new SqlParameter("@ThirdPartyBD", SqlDbType.Bit);
                    sqlThirdPartyBD.Direction = ParameterDirection.InputOutput;
                    sqlThirdPartyBD.Value = 0;
                    cmd.Parameters.Add(sqlThirdPartyBD);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    objInv.JsonInvoice = sqlJson.Value.ToString();
                    objInv.RID = (long)sqlRID.Value;
                    objInv.ThirdPartyBD = (bool)sqlThirdPartyBD.Value;

                }

            }

        }
        catch (Exception ex)
        {
            Common.WriteLog("", "TfAPI", "s_Tf_GetInvoiceToPaid", ex.Message);
        }

        return objInv;

    }
    private int UpdateRemilistStatus(long RID, string ServiceType, string RequestData,string Status, string httpMessage, string EmpID)
    {
        int Done = 5;
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Tf_InvoiceStatus_Update";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@RID", System.Data.SqlDbType.VarChar).Value = RID;
                    cmd.Parameters.Add("@ServiceType", System.Data.SqlDbType.VarChar).Value = ServiceType;
                    cmd.Parameters.Add("@RequestData", System.Data.SqlDbType.VarChar).Value = RequestData;
                    cmd.Parameters.Add("@HttpStatus", System.Data.SqlDbType.VarChar).Value = Status;
                    cmd.Parameters.Add("@HttpMessage", System.Data.SqlDbType.VarChar).Value = httpMessage;
                    cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = EmpID;
                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Int);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = 0;
                    cmd.Parameters.Add(sqlDone);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    Done = (int)sqlDone.Value;

                }

            }
        }
        catch (Exception ex)
        {
            Common.WriteLog(RID.ToString(), "TfAPI", "s_Tf_InvoiceStatus_Update", ex.Message);
        }
        return Done;
        // return 0;
    }
    private void SaveReqResponseData(string ExHouseCode, string CallRefID, string MethodCalled, DateTime CallDate, string ReqData, string ResponseData, string ResponseCode, string ResponseText)
    {
        bool Done = false;
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_FxServiceLog_Insert";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ExHouseCode", System.Data.SqlDbType.VarChar).Value = ExHouseCode;
                    cmd.Parameters.Add("@CallRefID", System.Data.SqlDbType.VarChar).Value = CallRefID;
                    cmd.Parameters.Add("@ServiceReference", System.Data.SqlDbType.VarChar).Value = MethodCalled;
                    cmd.Parameters.Add("@StartDT", System.Data.SqlDbType.DateTime).Value = CallDate;

                    cmd.Parameters.Add("@RequestData", System.Data.SqlDbType.VarChar).Value = ReqData;
                    cmd.Parameters.Add("@ResponseData", System.Data.SqlDbType.VarChar).Value = ResponseData;
                    cmd.Parameters.Add("@ResponseCode", System.Data.SqlDbType.VarChar).Value = ResponseCode;
                    cmd.Parameters.Add("@ResponseText", System.Data.SqlDbType.VarChar).Value = ResponseText;
                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = 0;
                    cmd.Parameters.Add(sqlDone);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    Done = (bool)sqlDone.Value;

                }

            }
        }
        catch (Exception ex)
        {
            Common.WriteLog(CallRefID, "TfAPI", "s_FxServiceLog_Insert", ex.Message);
        }
    }


    [WebMethod(Description = "Service Task: Create new Complaints with a specified TfPin"
        + "<br>" + "Returns:"
        + "<br>" + "Response Code=1000: " + "Success"

      )]
    public string ComplaintsInvoice(
    long RID,
    string ErrorCode,
    string Description,
    string EmpID,
    string KeyCode
    )
    {
        string InvoiceUrl = "https://demo-pay.transfast.net/api/customercare/complaints";

        string http_response = "";
        int SaveStatus = 3;
        int RemilistStatus = 0;
        string token_ = "";
        string jsonObj = "";
        string http_responseMsg = "";
        TfComplaints comObj = new TfComplaints();
        try
        {
            //  token_ = CredEncrypt(getValueOfKey("TransfastSystemId"), getValueOfKey("TransfastUserName"), getValueOfKey("TransfastPassword"), getValueOfKey("TransfastBranchId"));
            comObj = GetComplainInvoiceToTransfast(RID, ErrorCode, Description);
            token_= GetToken(comObj.ThirdpartyBD);
            var bytes = Encoding.ASCII.GetBytes(comObj.JsonComplaints);
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(InvoiceUrl);
            request.PreAuthenticate = true;
            request.Headers.Add("Authorization", token_);
            request.Method = "POST";
            request.ContentType = "application/json";
            using (var requestStream = request.GetRequestStream())
            {
                requestStream.Write(bytes, 0, bytes.Length);
            }
            try
            {
                var response = (HttpWebResponse)request.GetResponse();
                http_response = response.StatusCode.ToString();

            }
            catch (WebException e)
            {
                RemilistStatus = 3;
                TfBusinessErrors errorObj = GetTfBussinessError(e);
                http_response = errorObj.ErrorCode;
                http_responseMsg = errorObj.Message;
                Common.WriteLog(RID.ToString(), "TfAPI", "ComplaintsInvoice", http_responseMsg);
            }

            RemilistStatus = UpdateRemilistStatus(RID, "ComplaintsInvoice",ErrorCode+""+Description, http_response, http_responseMsg, EmpID);// ComplaintsInvoice map to sp



        }
        catch (Exception ex)
        {

            Common.WriteLog(RID.ToString(), "TfAPI", "ComplaintsInvoice", ex.Message);
            UpdateRemilistStatus(RID, "ComplaintsInvoice",ErrorCode+""+Description, http_response, http_responseMsg, "");
        }
        finally
        {
            SaveReqResponseData("TfAPI", RID.ToString(), "ComplaintsInvoice", DateTime.Now, jsonObj, http_response, SaveStatus.ToString(), RemilistStatus.ToString());
        }
        return RemilistStatus.ToString();
    }


    private TfComplaints GetComplainInvoiceToTransfast(long RID, string ErrorCode, string Description)
    {

        TfComplaints complaintsObj = new TfComplaints();

        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Tf_GetComplaintInvoice";//*** get invoice for mark as paid
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RID", System.Data.SqlDbType.BigInt).Value = RID;
                    cmd.Parameters.Add("@ErrorCode", System.Data.SqlDbType.VarChar).Value = ErrorCode;
                    cmd.Parameters.Add("@Description", System.Data.SqlDbType.VarChar).Value = Description;
                    SqlParameter sqlJson = new SqlParameter("@Json", SqlDbType.VarChar, -1);
                    sqlJson.Direction = ParameterDirection.InputOutput;
                    sqlJson.Value = "";
                    cmd.Parameters.Add(sqlJson);

                    SqlParameter sqlThirdpartyBD = new SqlParameter("@ThirdpartyBD", SqlDbType.Bit);
                    sqlThirdpartyBD.Direction = ParameterDirection.InputOutput;
                    sqlThirdpartyBD.Value = 0;
                    cmd.Parameters.Add(sqlThirdpartyBD);


                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    complaintsObj.JsonComplaints = sqlJson.Value.ToString();
                    complaintsObj.ThirdpartyBD = (bool)sqlThirdpartyBD.Value;


                }

            }

        }
        catch (Exception ex)
        {
            Common.WriteLog(RID.ToString(), "TfAPI", "s_Tf_GetInvoiceToPaid", ex.Message);
        }

        return complaintsObj;

    }

    [WebMethod(Description = "Service Task: TfCatalogMethods"
    + "<br>" + "Returns:"
    + "<br>" + "Response Code=1000: " + "Success"

    )]
    public string TfCatalogMethods(
    string TfPin,
    string Description,
    string ErrorCode,
    //string BranchCode,
    //string BranchName,
    //string EmpID,
    string KeyCode
    )
    {
        string TransfastUrl = getValueOfKey("TransfastUrl");
        string sUrl = TransfastUrl + "catalogs/banks/?countryisocode=us&bankname=bancomer";
        //    HttpWebResponse   res = new HttpWebResponse ();
        WebRequest req = WebRequest.Create(sUrl) as HttpWebRequest;
        WebHeaderCollection myheaders = new WebHeaderCollection();
        string c = "";
        try
        {
            //  string token_="PEF1dGhlbnRpY2F0aW9uPjxJZD4xNDNhN2ViNy1iMWEyLTQ5ZDAtOGJlYS0wMzZlMzY0NzRkNGE8L0lkPjxVc2VyTmFtZT5VZm1HcjdjU1AvenRPajlmNUYvV1B4QVdiNDlIMkRNNWlzVTV4SUROeStVNUJ6UStydWFMNjNnTjlGQnlwUDlDZ0d6NGZZL1l1STRZRWZERmJ5ZTd2TGpHd0gvRkRHZVd2RGZzZGhyVWdteUdmV0JPN1NzL3AwejhYQlBFZGFQQjAzR3RsL0dmRnNmYlBnckkwanRZNmZHTDBFckpVU0VTRVpJZ3JQcW43bDA9PC9Vc2VyTmFtZT48UGFzc3dvcmQ+SnpVWndtYk42aHlZZVJTQUVGYzZEQ1F0ZWtqYUJ5QUQyZWNLUVBKYlRjM082UEdrdmk1cnlHTHJ0SW9QUEpId2xhTW9zL3IwbjIyWkJUWWxERVpFTDRHeUQ5eTdkT1JhMEZhYS9Rc1kxek9rTjQ4b3VzeDFEbWhZdXZseEJOa3pLSEI3bi9QOUlNNUp6Zk81N20vakl1MGczamcyWjIxZDNyOEV0UVhsQUxRPTwvUGFzc3dvcmQ+PEJyYW5jaElkPnhXeS9uenhoV210NTNzMmNlbXNUcnNyODBROXBKUGVIVm02bFI5SkpMRzJpdTNUVTdMeHJKbXdYSjdpNFZqMmtuWVpNVmNyUTlWdllVbHJlcGdQRms3WjNhYTRsQnZ2ZzZSM3JIcGlLaDlCOFBrWWhqK3RWb05QQmpxVFB4NnNEUzlQRW9pNzhYemdDNWY0TmJPY015bWt4WlpYcllaSVdKdWJOcktneUNrVT08L0JyYW5jaElkPjwvQXV0aGVudGljYXRpb24+";
            //     string token_ = CredEncrypt("143a7eb7-b1a2-49d0-8bea-036e36474d4a","BAALTERNATE3","bauser3","BA33000003");
            string token_ = CredEncrypt(getValueOfKey("TransfastSystemId"), getValueOfKey("TransfastUserName"), getValueOfKey("TransfastPassword"), getValueOfKey("TransfastBranchId"));
            var myUri = new Uri(sUrl);
            var myWebRequest = WebRequest.Create(myUri);
            var myHttpWebRequest = (HttpWebRequest)myWebRequest;
            myHttpWebRequest.PreAuthenticate = true;
            myHttpWebRequest.Headers.Add("Authorization", token_);
            myHttpWebRequest.Accept = "application/json";

            var myWebResponse = myWebRequest.GetResponse();
            var responseStream = myWebResponse.GetResponseStream();
            if (responseStream != null)
            {
                var myStreamReader = new StreamReader(responseStream, Encoding.Default);
                var json = myStreamReader.ReadToEnd();

                responseStream.Close();
                myWebResponse.Close();

                JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
                dynamic dobj = jsonSerializer.Deserialize<dynamic>(json);
                string TotalCount = dobj["TotalCount"].ToString();
                //object Banks = dobj["Banks"];
                string id = dobj["Banks"][0]["Id"].ToString();
                string Name = dobj["Banks"][0]["Name"].ToString();
            }
        }
        catch (Exception ex)
        {

        }

        return c;
    }

    [WebMethod(Description = "Service Task: Invoice Status"
  + "<br>" + "Returns:"
  + "<br>" + "Response Code=1000: " + "Success"

  )]
    public string InvoiceStatus(
  string TfPin,
  bool ThirdPartyBD,
  string KeyCode
  )
    {
        string TransfastUrl = getValueOfKey("TransfastUrl");
        string sUrl = TransfastUrl + "Invoice/InvoiceStatus/?TfPin=" + TfPin;
        //    HttpWebResponse   res = new HttpWebResponse ();
        WebRequest req = WebRequest.Create(sUrl) as HttpWebRequest;
        WebHeaderCollection myheaders = new WebHeaderCollection();
        string json = "";
        string token_ = "";
        try
        {
            if (ThirdPartyBD)
                token_ = CredEncrypt(getValueOfKey("TransfastSystemId"), getValueOfKey("TransfastUserName3P"), getValueOfKey("TransfastPassword3P"), getValueOfKey("TransfastBranchId3P"));
            else
                token_ = CredEncrypt(getValueOfKey("TransfastSystemId"), getValueOfKey("TransfastUserName"), getValueOfKey("TransfastPassword"), getValueOfKey("TransfastBranchId"));

            // string token_ = CredEncrypt(getValueOfKey("TransfastSystemId"), getValueOfKey("TransfastUserName"), getValueOfKey("TransfastPassword"), getValueOfKey("TransfastBranchId"));
            var myUri = new Uri(sUrl);
            var myWebRequest = WebRequest.Create(myUri);
            var myHttpWebRequest = (HttpWebRequest)myWebRequest;
            myHttpWebRequest.PreAuthenticate = true;
            myHttpWebRequest.Headers.Add("Authorization", token_);
            myHttpWebRequest.Accept = "application/json";

            var myWebResponse = myWebRequest.GetResponse();
            var responseStream = myWebResponse.GetResponseStream();
            if (responseStream != null)
            {
                var myStreamReader = new StreamReader(responseStream, Encoding.Default);
                json = myStreamReader.ReadToEnd();

                responseStream.Close();
                myWebResponse.Close();
            }

            //


            //catch (Exception ex)
            //{
            //    RemilistStatus = 3;
            //    http_response = ex.Message;

            //    Common.WriteLog(jsonObj.RID.ToString(), "TfAPI", "PayInvoices", ex.Message);
            //}

            //

        }

        catch (WebException e)
        {

            TfBusinessErrors errorObj = GetTfBussinessError(e);
            Common.WriteLog(TfPin, "TfAPI", "InvoiceStatus", errorObj.Message);


        }
        catch (Exception ex)
        {
            json = "";
            Common.WriteLog(TfPin, "TfAPI", "InvoiceStatus", ex.Message);
        }

        return json;
    }

    [WebMethod(Description = "Service Task: Download New Orders"
       + "<br>" + "Returns:"
       + "<br>" + "Response Code=1: " + "Success"
       + "<br>" + "Response Code=-2: " + "Invalid keycode"

      )]
    public string DownloadInvoicesForPayout(
      string EmpID,
      bool ThirdPartyBD,
      string KeyCode
      )
    {
        if (KeyCode != getValueOfKey("Transfast_KeyCode"))
        {
            return "-2";
        }
        //   TfIPayInvoice jsonObj = GetInvoicePaidToTransfast();
        string TransfastUrl = getValueOfKey("TransfastUrl");
        string InvoiceUrl = TransfastUrl + "invoice/downloadedinvoices?ModeOfPayment=C";
        // string InvoiceUrl = "https://demo-pay.transfast.net/api/invoice/downloadedinvoices?IncludeDownloadedInvoices=True&ModeOfPayment=C";
        string http_response = "";
        int SaveStatus = 3;
        string RemilistStatus = "0";
        string token_ = "";
        //  string http_responseMsg = "";
        string jsonText = "";
        string CallRefID = Guid.NewGuid().ToString();

        TfBusinessErrors errorObj = new TfBusinessErrors();
        try
        {
            if (ThirdPartyBD)
                token_ = CredEncrypt(getValueOfKey("TransfastSystemId"), getValueOfKey("TransfastUserName3P"), getValueOfKey("TransfastPassword3P"), getValueOfKey("TransfastBranchId3P"));
            else
                token_ = CredEncrypt(getValueOfKey("TransfastSystemId"), getValueOfKey("TransfastUserName"), getValueOfKey("TransfastPassword"), getValueOfKey("TransfastBranchId"));


            var bytes = Encoding.ASCII.GetBytes("");
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(InvoiceUrl);
            request.PreAuthenticate = true;
            request.Headers.Add("Authorization", token_);
            request.Method = "PUT";
            request.ContentType = "application/json";
            using (var requestStream = request.GetRequestStream())
            {
                requestStream.Write(bytes, 0, bytes.Length);
            }
            //try
            //{
            var response = (HttpWebResponse)request.GetResponse();
            http_response = response.StatusCode.ToString();
            //}


            var responseStream = response.GetResponseStream();
            if (responseStream != null)
            {
                var myStreamReader = new StreamReader(responseStream, Encoding.Default);
                string json = myStreamReader.ReadToEnd();
                jsonText = string.Format("{0}", json);
                responseStream.Close();
                response.Close();

                JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

                TfInvoices invoiceList = jsonSerializer.Deserialize<TfInvoices>(json);


                SaveStatus = SaveBulkInvoice(invoiceList, EmpID, CallRefID, true, ThirdPartyBD);
                if (SaveStatus == 1)
                    RemilistStatus = SaveInvoiceToRemilist(CallRefID, EmpID, "s_Tf_InvoiceDownload_Save").ToString();
            }

        }
        catch (WebException e)

        {
            //TfBusinessErrors errorObj = GetTfBussinessError(e);
            errorObj = GetTfBussinessError(e);
            RemilistStatus = errorObj.Message + "-" + errorObj.ErrorCode;
            // string   http_responseMsg = errorObj.Message;

        }
        catch (Exception ex)
        {
            Common.WriteLog(CallRefID, "TfAPI", "DownloadInvoicesForPayout", ex.Message);
            RemilistStatus = ex.Message;
        }
        finally
        {
            SaveReqResponseData("TfAPI", "", "DownloadInvoicesForPayout", DateTime.Now, token_, jsonText, SaveStatus.ToString(), RemilistStatus);
        }
        return RemilistStatus.ToString();
    }

    public string CredEncrypt(string systemid, string user, string password, string branchid)
    {
        StringBuilder xml_Credentials = new StringBuilder();
        xml_Credentials.Append("<Authentication>");
        xml_Credentials.Append("<Id>" + systemid + "</Id>");
        xml_Credentials.Append("<UserName>" + EncryptRSA(user) + "</UserName>");
        xml_Credentials.Append("<Password>" + EncryptRSA(password) + "</Password>");
        xml_Credentials.Append("<BranchId>" + EncryptRSA(branchid) + "</BranchId>");
        xml_Credentials.Append("</Authentication>");
        return System.Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(xml_Credentials.ToString()));
    }

    public string getValueOfKey(string KeyName)
    {
        try
        {
            return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
        }
        catch (Exception) { return string.Empty; }
    }


    public string EncryptRSA(string data)
    {
        var rsa = new RSACryptoServiceProvider();
        //   string _publicKey = "<RSAKeyValue><Modulus>38N8BuU+JqB3DlSHcZfsvCCNQAB+wAWILcog9teLmKSiAKXOiBM4MzjcuW+521lT4stdwUEYkx99rZXMuDCKRCN9kt0w42QJyWQ35Hx4LQG7tgqGfNrjszwR0ngpznepCPJl82VhT7HzJreW0+DeV0vvZHqxfgmrFJoT7Uoh5Lc=</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";

        string _publicKey = "<RSAKeyValue><Modulus>" + getValueOfKey("TransfastRSAKeyModulus") + "</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";
        rsa.FromXmlString(_publicKey);
        byte[] dataToEncrypt = Encoding.UTF8.GetBytes(data);
        byte[] encryptedByteArray = rsa.Encrypt(dataToEncrypt, false).ToArray();
        return Convert.ToBase64String(encryptedByteArray);
    }

    //public string Decrypt(string data)
    //{
    //    var rsa = new RSACryptoServiceProvider();
    //    var dataByte = Convert.FromBase64String(data);
    //    rsa.FromXmlString(_privateKey);
    //    var decryptedByte = rsa.Decrypt(dataByte, false);
    //    return Encoding.UTF8.GetString(decryptedByte);
    //}
}

public struct TfComplaints
{
    public string JsonComplaints{ get; set; }
    public bool ThirdpartyBD { get; set; }
}

public struct TfErrors
{
    public TfBusiness_Errors[] BusinessErrors { get; set; }
    public TfDataValidationErrors[] DataValidationErrors { get; set; }

}
public struct TfDataValidationErrors
{
    public string ErrorCode { get; set; }
    public string Message { get; set; }
    public string FieldName { get; set; }
}
public struct TfBusiness_Errors
{
    public string ErrorCode { get; set; }
    public string Message { get; set; }
}

public struct TfBusinessErrors
{
    public string ErrorCode { get; set; }
    public string Message { get; set; }
}

public struct TfIPayInvoice
{
    public long RID { get; set; }
    public string JsonInvoice { get; set; }
    public bool ThirdPartyBD { get; set; }
}

public struct TfInvoices
{
    public TfInvoice[] Invoices { get; set; }
}

public struct TfInvoice
{

    public string TfPin { get; set; }
    public string AgentBranchId { get; set; }
    public string Status { get; set; }
    public string StatusName { get; set; }
    public string TransactionDate { get; set; }
    public string ReceiveCurrencyIsoCode { get; set; }
    public decimal ReceiveAmount { get; set; }
    public decimal SendAmount { get; set; }
    public string PayoutBranchId { get; set; }
    public decimal ExchangeRate { get; set; }
    public decimal CommAmountLocal { get; set; }
    public decimal CommAmountForeign { get; set; }
    public string PaymentModeId { get; set; }
    public string PaymentModeName { get; set; }
    public string AccountNumber { get; set; }
    public string BankName { get; set; }
    public string BankBranch { get; set; }
    public string SenderFullName { get; set; }

    public string SenderAddress { get; set; }
    public string SenderAddressUnicode { get; set; }
    public string SenderCityId { get; set; }
    public string SenderCityName { get; set; }
    public string SenderStateId { get; set; }
    public string SenderStateName { get; set; }

    public string SenderCountryIsoCode { get; set; }
    public string SenderCountryName { get; set; }
    public string SenderPhoneMobile { get; set; }
    public string ReceiverFullName { get; set; }
    public string ReceiverFirstName { get; set; }
    public string ReceiverMiddleName { get; set; }

    public string ReceiverLastName { get; set; }
    public string ReceiverSecondLastName { get; set; }
    public string ReceiverCountryIsoCode { get; set; }
    public string ReceiverCountryName { get; set; }
    public string ReceiverStateId { get; set; }
    public string ReceiverStateName { get; set; }

    public string ReceiverCityId { get; set; }
    public string ReceiverCityName { get; set; }
    public string ReceiverAddress { get; set; }
    public string ReceiverNationalityIsoCode { get; set; }
    public string ReceiverNationalityName { get; set; }
    public string ReceiverPhoneMobile { get; set; }

    public string ReceiverPhoneHome { get; set; }
    public string ReceiverPhoneWork { get; set; }
    public string ReceiptNo { get; set; }
    public string SenderId { get; set; }
    public string Reference { get; set; }
    public string SenderIDNumber { get; set; }

    public string SenderIDType { get; set; }
    public string SenderIDTypeDesc { get; set; }
    public string SenderIDDateExpiry { get; set; }
    public string SenderIsIndividual { get; set; }
    public string ReceiverIDType { get; set; }
    public string ReceiverIDNumber { get; set; }
    public string ReceiverEmailID { get; set; }

    public string ReceiverAccountType { get; set; }
    public string ReceiverIsIndividual { get; set; }
    public string PurposeOfRemittanceId { get; set; }

}