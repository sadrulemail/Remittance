 <%@ WebService Language="C#" Class="RiaFxGlobalService" %>
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


/// <summary>
/// Summary description for RiaFxGlobalService
/// </summary>
[WebService(Namespace = "https://ibanking.tblbd.com/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class RiaFxGlobalService : System.Web.Services.WebService
{

    public RiaFxGlobalService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod(Description = "Service Task: Verify Order for payout"
        + "<br>" + "Returns:"
        + "<br>" + "Response Code=1000: " + "Success"

      )]
    public OP_Verify_Order OP_VerifyOrderForpayout(
 string PIN,
 decimal BeneAmount,
 string BranchCode,
 string BranchName,
 string EmpID,
 string KeyCode
  )
    {
        OP_Verify_Order op_verify = InvokeVerifyOrderService(PIN, BeneAmount, BranchCode, BranchName, EmpID, KeyCode
);
        return op_verify;
    }

    private OP_Verify_Order InvokeVerifyOrderService(string Pin, decimal BeneAmount, string BranchCode, string BranchName, string EmpID, string KeyCode)
    {
        string CallRefID = Guid.NewGuid().ToString();
        XmlDocument SOAPReqBody = new XmlDocument();
        DateTime CallDateTime = DateTime.Now;
        DateTime DatetimeUtc = DateTime.UtcNow;
        OP_Verify_Order obj_verify_order = new OP_Verify_Order();
        string response_node = "";
        DateTime ResponseDateTimeUTC = DateTime.UtcNow;

        string TransRefID = "";
        bool OrderFound = false;
        string PINResponse = "";
        string OrderNo = "";

        string ResponseCode = "";
        string ResponseText = "";
        bool Done = false;
        string Msg = "";

        string BeneCurrenceResp = "";
        decimal BeneAmountResp = 0;

        if (KeyCode != getValueOfKey("Ria_KeyCode"))
        {
            obj_verify_order.ResponseText = "Invalid KeyCode";
            obj_verify_order.ResponseCode = "-2";

            return obj_verify_order;
        }


        SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>
            <Root>" + GetRiaHeader(CallRefID, CallDateTime, BranchCode, EmpID, DatetimeUtc, BranchName) +
                   "<DateTimeLocal>" + CallDateTime.ToString("yyyyMMddHHmmss") + @"</DateTimeLocal>
			       <DateTimeUTC>" + DatetimeUtc.ToString("yyyyMMddHHmmss") + @"</DateTimeUTC>
			       <PIN>" + Pin + @"</PIN>
			       <BeneAmount>" + BeneAmount + @"</BeneAmount>
			      <CorrespLocID>" + BranchCode + @"</CorrespLocID>
			</Root>");
        //  <CorrespLocID>" + 0012 + @"</CorrespLocID>

        RiaFxGlobalWebReferance.FXGlobalSending FxObject = new RiaFxGlobalWebReferance.FXGlobalSending();
        XmlNode nodeObj = null;
        List<string> listRequiredField = new List<string>();
        //try
        //{
        nodeObj = FxObject.OP_VerifyOrderForPayout(SOAPReqBody);
        response_node = nodeObj.InnerXml;
        DataTable dtRoot = new DataTable();
        DataTable dtHeader = new DataTable();
        DataTable dtOrderResponse = new DataTable();
        DataTable dtRequired = new DataTable();
        string RequiredField = "";
        try
        {
            XmlReader xmlReader = new XmlNodeReader(nodeObj);
            DataSet ds = new DataSet();
            ds.ReadXml(xmlReader);
            dtRoot = ds.Tables["Root"];
            dtHeader = ds.Tables["Header"];
            dtOrderResponse = ds.Tables["VerifyOrderResponse"];
            dtRequired = ds.Tables["RequiredField"];
            //   List<OP_RequiredFields> listRequiredField = new List<OP_RequiredFields>();

            if (dtRequired != null)
                foreach (DataRow row in dtRequired.Rows)
                {
                    // OP_RequiredFields objReq = new OP_RequiredFields();
                    // objReq.RequiredField = row["FieldName"].ToString();
                    RequiredField = RequiredField + "|" + row["FieldName"].ToString();
                    listRequiredField.Add(row["FieldName"].ToString());
                }




            try
            {
                ResponseDateTimeUTC = DateTime.ParseExact(dtHeader.Rows[0]["ResponseDateTimeUTC"].ToString(), "yyyyMMddHHmmss", CultureInfo.InvariantCulture);
            }
            catch (Exception ex)
            { }
            try
            {
                TransRefID = dtOrderResponse.Rows[0]["TransRefID"].ToString();
            }
            catch (Exception ex)
            { }
            try
            {
                OrderFound = bool.Parse(dtOrderResponse.Rows[0]["OrderFound"].ToString());
            }
            catch (Exception ex)
            { }
            try
            {

                PINResponse = dtOrderResponse.Rows[0]["PIN"].ToString();
            }
            catch (Exception ex)
            { }
            try
            {
                OrderNo = dtOrderResponse.Rows[0]["OrderNo"].ToString();
            }
            catch (Exception ex)
            { }

            ResponseCode = dtOrderResponse.Rows[0]["ResponseCode"].ToString();
            ResponseText = dtOrderResponse.Rows[0]["ResponseText"].ToString();

            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Ria_OP_OrderVerify_Insert";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@CallRefID", System.Data.SqlDbType.VarChar).Value = CallRefID;
                    cmd.Parameters.Add("@BeneAmountReq", System.Data.SqlDbType.Money).Value = BeneAmount;
                    cmd.Parameters.Add("@CallDate", System.Data.SqlDbType.DateTime).Value = CallDateTime;
                    cmd.Parameters.Add("@CallDateUTC", System.Data.SqlDbType.DateTime).Value = DatetimeUtc;

                    cmd.Parameters.Add("@BranchCode", System.Data.SqlDbType.VarChar).Value = BranchCode;
                    cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = EmpID;
                    try
                    {
                        cmd.Parameters.Add("@MethodCalled", System.Data.SqlDbType.VarChar).Value = dtHeader.Rows[0]["MethodCalled"].ToString();
                    }
                    catch (Exception ex)
                    {

                    }
                    try
                    {
                        cmd.Parameters.Add("@CallID_Ext", System.Data.SqlDbType.VarChar).Value = dtHeader.Rows[0]["CallID_Ext"].ToString();
                    }
                    catch (Exception ex)
                    {

                    }
                    cmd.Parameters.Add("@ResponseDateTimeUTC", System.Data.SqlDbType.DateTime).Value = ResponseDateTimeUTC;
                    cmd.Parameters.Add("@TransRefID", System.Data.SqlDbType.VarChar).Value = TransRefID.Trim();
                    cmd.Parameters.Add("@OrderFound", System.Data.SqlDbType.Bit).Value = OrderFound;
                    cmd.Parameters.Add("@PINResponse", System.Data.SqlDbType.VarChar).Value = PINResponse.Trim();
                    cmd.Parameters.Add("@OrderNo", System.Data.SqlDbType.VarChar).Value = OrderNo.Trim();

                    try
                    {
                        cmd.Parameters.Add("@SeqIDRA", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["SeqIDRA"].ToString(); ;
                    }
                    catch (Exception ex)
                    {

                    }
                    try
                    {
                        cmd.Parameters.Add("@SeqIDPA", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["SeqIDPA"].ToString();
                    }
                    catch (Exception ex)
                    {

                    }
                    try
                    {
                        cmd.Parameters.Add("@OrderDate", System.Data.SqlDbType.Date).Value = DateTime.ParseExact(dtOrderResponse.Rows[0]["OrderDate"].ToString(), "yyyyMMdd", CultureInfo.InvariantCulture);
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CountryFrom", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CountryFrom"].ToString();
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustNameFirst", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustNameFirst"].ToString();
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustNameMiddle", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustNameMiddle"].ToString();
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustNameLast1", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustNameLast1"].ToString();
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustNameLast2", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustNameLast2"].ToString();
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustAddress", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustAddress"].ToString();
                    }
                    catch (Exception ex)
                    { }

                    try
                    {
                        cmd.Parameters.Add("@CustCity", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustCity"].ToString();
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustState", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustState"].ToString();
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustCountry", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustCountry"].ToString();
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustZip", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustZip"].ToString();
                    }
                    catch (Exception ex)
                    { }

                    try
                    {
                        cmd.Parameters.Add("@CustTelNo", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustTelNo"].ToString();
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustBeneRelationship", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustBeneRelationship"].ToString();
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustCurrency", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustCurrency"].ToString();
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustAmount", System.Data.SqlDbType.Decimal).Value = decimal.Parse(dtOrderResponse.Rows[0]["CustAmount"].ToString());
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@Rate", System.Data.SqlDbType.Decimal).Value = decimal.Parse(dtOrderResponse.Rows[0]["Rate"].ToString());
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@BeneNameFirst", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["BeneNameFirst"].ToString();
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@BeneNameMiddle", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["BeneNameMiddle"].ToString();
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@BeneNameLast1", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["BeneNameLast1"].ToString();
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@BeneNameLast2", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["BeneNameLast2"].ToString();
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@BeneAddress", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["BeneAddress"].ToString();


                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@BeneCity", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["BeneCity"].ToString();

                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@BeneState", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["BeneState"].ToString();

                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@BeneCountry", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["BeneCountry"].ToString();


                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        BeneCurrenceResp = dtOrderResponse.Rows[0]["BeneCurrency"].ToString();
                        cmd.Parameters.Add("@BeneCurrency", System.Data.SqlDbType.VarChar).Value = BeneCurrenceResp;

                    }
                    catch (Exception ex)
                    { }

                    try
                    {
                        BeneAmountResp = decimal.Parse(dtOrderResponse.Rows[0]["BeneAmount"].ToString());
                        cmd.Parameters.Add("@BeneAmountResp", System.Data.SqlDbType.Decimal).Value = BeneAmountResp;

                    }
                    catch (Exception ex)
                    { }
                    try
                    {

                        cmd.Parameters.Add("@PCRate", System.Data.SqlDbType.Decimal).Value = decimal.Parse(dtOrderResponse.Rows[0]["PCRate"].ToString());

                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@TransferReason", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["TransferReason"].ToString();

                    }
                    catch (Exception ex)
                    { }

                    try
                    {
                        cmd.Parameters.Add("@CustID1Type", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustID1Type"].ToString();

                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustID1No", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustID1No"].ToString();

                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustID1ExpirationDate", System.Data.SqlDbType.Date).Value = DateTime.Parse(dtOrderResponse.Rows[0]["CustID1ExpirationDate"].ToString());

                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustID1IssuedBy", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustID1IssuedBy"].ToString();

                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustID1IssuedByCountry", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustID1IssuedByCountry"].ToString();

                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustCountryOfBirth", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustCountryOfBirth"].ToString();

                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustDateOfBirth", System.Data.SqlDbType.Date).Value = DateTime.Parse(dtOrderResponse.Rows[0]["CustDateOfBirth"].ToString());

                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        cmd.Parameters.Add("@CustNationality", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["CustNationality"].ToString();

                    }
                    catch (Exception ex)
                    { }

                    cmd.Parameters.Add("@ResponseCode", System.Data.SqlDbType.VarChar).Value = ResponseCode;
                    cmd.Parameters.Add("@ResponseText", System.Data.SqlDbType.VarChar).Value = ResponseText;
                    cmd.Parameters.Add("@RequiredFields", System.Data.SqlDbType.VarChar).Value = RequiredField;

                    SqlParameter sqlRefID = new SqlParameter("@Msg", SqlDbType.VarChar);
                    sqlRefID.Direction = ParameterDirection.InputOutput;
                    sqlRefID.Value = "";
                    cmd.Parameters.Add(sqlRefID);

                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = 0;
                    cmd.Parameters.Add(sqlDone);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();

                    //RefID = sqlRefID.Value.ToString();
                    Done = (bool)sqlDone.Value;
                    Msg = sqlDone.Value.ToString();
                }
            }
            if (!Done)
            {
                obj_verify_order.ResponseCode = "0";
                obj_verify_order.ResponseText = Msg;
            }

        }
        catch (Exception ex)
        {
            obj_verify_order.ResponseCode = "";
            obj_verify_order.ResponseText = ex.Message;
            Common.WriteLog(CallRefID, "Ria API", "OP_VerifyOrderForPayout", ex.Message);
        }
        finally
        {
            SaveReqResponseData("Ria API",CallRefID, "OP_VerifyOrder", CallDateTime, SOAPReqBody.InnerXml, response_node, ResponseCode, ResponseText);
        }

        ResponseText = Common.XmlText(ResponseText);

        obj_verify_order.Required_Fields = listRequiredField;
        obj_verify_order.TransRefID = TransRefID;
        obj_verify_order.ResponseCode = ResponseCode;
        obj_verify_order.ResponseText = ResponseText;
        obj_verify_order.RefID = CallRefID;
        obj_verify_order.OrderNo = OrderNo;
        obj_verify_order.Pin = PINResponse;
        obj_verify_order.Amount = BeneAmountResp;
        obj_verify_order.Currency = BeneCurrenceResp;

        return obj_verify_order;
    }

    [WebMethod(Description = "Service Task: Confirm Order"
+ "<br>" + "Returns:"
+ "<br>" + "Done=1: " + "Success"
+ "<br>" + "ResponseCode=1000: " + "Success"

)]
    public OP_Paid_Order OP_ConfirmOrderPaid(
    string RefID_Verify,
    string Pin,
    string RequiredFieldXml,
    string BranchCode,
    string BranchName,
    string EmpID,
    string KeyCode
)
    {
        PaidRemilistStatus paidStatus = new PaidRemilistStatus();
        OP_Paid_Order paidOrder = new OP_Paid_Order();
        bool Done = false;
        if (KeyCode != getValueOfKey("Ria_KeyCode"))
        {
            paidOrder.Done = Done;
            paidOrder.ResponseCode = "-2";

            return paidOrder;
        }

        // string RequuiredXml = RequiredField();
        string CallRefID = Guid.NewGuid().ToString();
        XmlDocument SOAPReqBody = new XmlDocument();
        DateTime CallDateTime = DateTime.Now;
        DateTime DatetimeUtc = DateTime.UtcNow;
        DateTime PaidDateTimeLocal = DateTime.Now; //20180830154000
        DateTime PaidDateTimeUTC = DateTime.UtcNow; //20180830094000
        string VerifyOrderTransRefID = "";
        string response_node = "";
        string MethodCalled = "";
        string ResponseCode = "";
        string ResponseText = "";

        string voidOrder = "";
        string OrderNo_Req = "";
        //  string TranRefID = "";
        string BeneCurrencyReq = "";
        decimal BeneAmountReq = 0;
        bool isTimedOut = false;


        try
        {
            DataTable RemiListDT = PINCheck(RefID_Verify, Pin);

            if (RemiListDT.Rows.Count > 0)
            {
                Done = true;
                OrderNo_Req = RemiListDT.Rows[0]["OrderNo"].ToString();
                VerifyOrderTransRefID = RemiListDT.Rows[0]["TransRefID"].ToString();
                BeneCurrencyReq = RemiListDT.Rows[0]["BeneCurrency"].ToString();
                BeneAmountReq = decimal.Parse(RemiListDT.Rows[0]["BeneAmount"].ToString());

            }
            else
            {
                paidOrder.Done = Done;
                paidOrder.ResponseCode = "-1";

                return paidOrder;
            }


            SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>
           <Root>" + GetRiaHeader(CallRefID, CallDateTime, BranchCode, EmpID, DatetimeUtc, BranchName) +
                 "<DateTimeLocal>" + CallDateTime.ToString("yyyyMMddHHmmss") + @"</DateTimeLocal>
			       <DateTimeUTC>" + DatetimeUtc.ToString("yyyyMMddHHmmss") + @"</DateTimeUTC>
	   
             <VerifyOrderTransRefID>" + VerifyOrderTransRefID + @"</VerifyOrderTransRefID>
		      <OrderNo>" + OrderNo_Req + @"</OrderNo>
		      <PIN>" + Pin + @"</PIN>
		      <BeneCurrency>" + BeneCurrencyReq + @"</BeneCurrency>
		      <BeneAmount>" + BeneAmountReq + @"</BeneAmount>
              <PaidDateTimeLocal>" + PaidDateTimeLocal.ToString("yyyyMMddHHmmss") + @"</PaidDateTimeLocal>
		      <PaidDateTimeUTC>" + PaidDateTimeUTC.ToString("yyyyMMddHHmmss") + @"</PaidDateTimeUTC>"


                //+RequiredField()+ <CorrespLocID>" + BranchCode + @"</CorrespLocID>"
                + RequiredFieldXml +
                @"</Root>");


            XmlNode nodeObj = null;
            try
            {
                RiaFxGlobalWebReferance.FXGlobalSending FxObject = new RiaFxGlobalWebReferance.FXGlobalSending();
                // FxObject.Timeout = 100; //for testing timeout
                nodeObj = FxObject.OP_ConfirmOrderPaid(SOAPReqBody);
                response_node = nodeObj.InnerXml;
            }

            catch (WebException ex)
            {
                if (ex.Status == WebExceptionStatus.Timeout)
                {
                    // Handle timeout exception
                    isTimedOut = true;
                    ResponseText = "Time Out. Unable to connect with Ria Server. ";
                    voidOrder = OP_VoidOrderPaidConfirmation(RefID_Verify, VerifyOrderTransRefID.Trim(), OrderNo_Req.Trim(), Pin.Trim(), BeneCurrencyReq, BeneAmountReq, BranchCode, BranchName, EmpID);
                }
                Common.WriteLog(CallRefID, "Ria API", "OP_ConfirmOrderPaid TimeOut", ex.Message);
            }


            DataTable dtRoot = new DataTable();
            DataTable dtHeader = new DataTable();
            DataTable dtOrderResponse = new DataTable();
            DataTable dtRequired = new DataTable();


            XmlReader xmlReader = new XmlNodeReader(nodeObj);
            DataSet ds = new DataSet();
            ds.ReadXml(xmlReader);
            dtRoot = ds.Tables["Root"];
            dtHeader = ds.Tables["Header"];
            dtOrderResponse = ds.Tables["ConfirmOrderPaidResponse"];

            //  MethodCalled = dtHeader.Rows[0]["MethodCalled"].ToString();
            string CallID_Ext = dtHeader.Rows[0]["CallID_Ext"].ToString();
            DateTime ResponseDateTimeUTC = DateTime.ParseExact(dtHeader.Rows[0]["ResponseDateTimeUTC"].ToString(), "yyyyMMddHHmmss", CultureInfo.InvariantCulture);
            string TransRefID = dtOrderResponse.Rows[0]["TransRefID"].ToString();
            string PINResponse = "";
            string OrderNo = "";
            string BeneCurrency = "";
            decimal BeneAmountResponse = 0;

            if (isTimedOut == false)
            {
                try
                {
                    PINResponse = dtOrderResponse.Rows[0]["PIN"].ToString();
                    OrderNo = dtOrderResponse.Rows[0]["OrderNo"].ToString();
                    BeneCurrency = dtOrderResponse.Rows[0]["BeneCurrency"].ToString();
                    BeneAmountResponse = decimal.Parse(dtOrderResponse.Rows[0]["BeneAmount"].ToString());
                }
                catch (Exception ex)
                {
                    ResponseText = "PIN or Order Not found. ";
                    Common.WriteLog(CallRefID, "Ria API", "OP_ConfirmOrderPaid", ex.Message);
                }
                ResponseCode = dtOrderResponse.Rows[0]["ResponseCode"].ToString();
                ResponseText = dtOrderResponse.Rows[0]["ResponseText"].ToString();




                if (ResponseCode == "1000") //Paid at Ria End Done
                {
                    paidStatus = FxOfficePickupMarkAsPaid(RefID_Verify, CallID_Ext, BeneCurrency, BeneAmountResponse, EmpID, ResponseDateTimeUTC, ResponseCode, ResponseText); //Paid mark in RemiList
                    SaveRequiredFieldValue(CallRefID, RequiredFieldXml);
                    paidOrder.RollBackRequired = "2"; // set default value
                }
                if (paidStatus.Done == false && ResponseCode == "1000")   //Failed to save in RemiList
                                                                          //Roleback at Ria
                {

                    voidOrder = OP_VoidOrderPaidConfirmation(RefID_Verify, TransRefID.Trim(), OrderNo.Trim(), Pin.Trim(), BeneCurrency, BeneAmountResponse, BranchCode, BranchName, EmpID);
                    if (voidOrder == "0")   //Roleback Failed
                    {
                        paidOrder.RollBackRequired = "1";
                        UpdateRollBackFlag(RefID_Verify);
                    }
                    else
                        paidOrder.RollBackRequired = "0";

                }
            }

        }
        catch (Exception ex)
        {
            ResponseText += ex.Message;
            Common.WriteLog(CallRefID, "Ria API", "OP_ConfirmOrderPaid", ex.Message);
        }
        finally
        {
            // OP_VoidOrderPaidConfirmation(RefID_Verify, VerifyOrderTransRefID.Trim(), OrderNo_Req.Trim(), Pin.Trim(), BeneCurrencyReq, BeneAmountReq, BranchCode, BranchName, EmpID);
            SaveReqResponseData("Ria API",CallRefID, "OP_ConfirmOrderPaid", CallDateTime, SOAPReqBody.InnerXml, response_node, ResponseCode, "paidStatus:" + paidStatus.Done + "|ResponseText" + ResponseText);
        }

        ResponseText = Common.XmlText(ResponseText);

        paidOrder.Done = paidStatus.Done;
        paidOrder.RID = paidStatus.RID;
        paidOrder.ResponseCode = ResponseCode;
        paidOrder.ResponseText = ResponseText;
        return paidOrder;
    }
    public string getValueOfKey(string KeyName)
    {
        try
        {
            return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
        }
        catch (Exception) { return string.Empty; }
    }

    private DataTable PINCheck(string RefID_Verify, string Pin)
    {
        DataTable RemilistDT = new DataTable();
        try
        {
            //
            using (SqlDataAdapter da = new SqlDataAdapter())
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_Ria_PIN_Check";//***
                    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@RefIdVerify", System.Data.SqlDbType.VarChar).Value = RefID_Verify;
                        cmd.Parameters.Add("@Pin", System.Data.SqlDbType.VarChar).Value = Pin;


                        cmd.Connection = conn;
                        conn.Open();
                        da.SelectCommand = cmd;
                        da.Fill(RemilistDT);

                    }

                }
            }
            //

        }
        catch (Exception ex)
        {
            Common.WriteLog(RefID_Verify, "Ria API", "s_Ria_PIN_Check", ex.Message);
        }
        return RemilistDT;
    }

    //private string RequiredField()
    //{
    //    string requiredData = "<BeneIDType>" + "NIC" + @"</BeneIDType>
    //<BeneIDNumber>" + "BD99887744" + @"</BeneIDNumber>
    //               <BeneIDIssuedByCountry>" + "BD" + @"</BeneIDIssuedByCountry>
    //               ";


    //    return requiredData;
    //}

    private void SaveRequiredFieldValue(string RefIDPaid, string RequiredFieldXml)
    {
        XmlDocument SOAPReqBody = new XmlDocument();
        string Chield_Tag = "";
        string Chield_TagValue = "";
        try
        {
            SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>
            <RequiredField>" + RequiredFieldXml +
       @"</RequiredField>");

            XmlReader xmlReader = new XmlNodeReader(SOAPReqBody);
            DataSet ds = new DataSet();
            ds.ReadXml(xmlReader);
            DataTable dtRequired = ds.Tables["RequiredField"];
            if (dtRequired != null)
                foreach (DataColumn column in dtRequired.Columns)
                {
                    Chield_Tag = column.ToString().Trim();
                    Chield_TagValue = dtRequired.Rows[0][column].ToString();
                    if (Chield_Tag != "Request_Id")
                        SaveRequiredField(RefIDPaid, Chield_Tag, Chield_TagValue);
                }
        }
        catch (Exception ex)
        {
            Common.WriteLog(RefIDPaid, "Ria API", "SaveRequiredFieldValue", ex.Message);
        }
    }

    private void SaveRequiredField(string RefIDPaid, string TagName, string TagValue)
    {

        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_RiaRequiredFieldValue_Insert";//***
            conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@RefIDPaid", System.Data.SqlDbType.VarChar).Value = RefIDPaid;
                cmd.Parameters.Add("@RequiredField", System.Data.SqlDbType.VarChar).Value = TagName;
                cmd.Parameters.Add("@RequiredFieldValue", System.Data.SqlDbType.VarChar).Value = TagValue;

                cmd.Connection = conn;
                conn.Open();

                cmd.ExecuteNonQuery();


            }
        }
    }

    private void UpdateRollBackFlag(string RefID_Verify)
    {
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Ria_OP_PaidRollBack_StatusUpdate";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RefIDVerify", System.Data.SqlDbType.VarChar).Value = RefID_Verify;

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                }
            }
        }
        catch (Exception ex)
        { }
    }

    private string GetRiaHeader(string CallRefID, DateTime CallDateTime, string BranchCode, string EmpID, DateTime DatetimeUtc, string BranchName)
    {
        string TerminalID = string.Format("{0}_{1}", BranchCode, EmpID);
        string header = "<CorrespID>" + getValueOfKey("RiaCorrespID") + @"</CorrespID>
			       <LayoutVersion>" + getValueOfKey("RiaLayoutVersion") + @"</LayoutVersion>
			       <Header> 
			              <CallID>" + CallRefID + @"</CallID> 
			              <CallDateTimeLocal>" + CallDateTime.ToString("yyyyMMddHHmmss") + @"</CallDateTimeLocal>
			              <CorrespLocNo>" + BranchCode + @"</CorrespLocNo>
                          <CorrespLocNo_Ria>" + BranchCode + @"</CorrespLocNo_Ria>
                          <CorrespLocName>" + Common.XmlText(BranchName) + @"</CorrespLocName> 
			              <CorrespLocCountry>" + "BD" + @"</CorrespLocCountry>
			              <UserID>" + EmpID + @"</UserID> 
			              <TerminalID>" + TerminalID + @"</TerminalID> 
			              <LanguageCultureCode>en-US</LanguageCultureCode>
			       </Header>"
                  ;
        return header;
    }

    [WebMethod(Description = "Service Task: Verify Order for payout"
    + "<br>" + "Returns:"
    + "<br>" + "1: " + "Success"

    )]
    private string OP_VoidOrderPaidConfirmation(
    string RefID_Verify,
    string TransRefIDPaid,
    string OrderNo,
    string Pin,
    string BeneCurrency,
    decimal BeneAmount,
    string BranchCode,
    string BranchName,
    string EmpID
    )
    {
        string CallRefID = Guid.NewGuid().ToString();
        XmlDocument SOAPReqBody = new XmlDocument();
        DateTime CallDateTime = DateTime.Now;
        DateTime DatetimeUtc = DateTime.UtcNow;
        string response_node = "";
        string MethodCalled = "";
        string ResponseCode = "";
        string ResponseText = "";
        bool CancelOrder = false;
        string VoidOrder = "0";

        try
        {
            SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>
            <Root>" + GetRiaHeader(CallRefID, CallDateTime, BranchCode, EmpID, DatetimeUtc, BranchName) +
            "<DateTimeLocal>" + CallDateTime.ToString("yyyyMMddHHmmss") + @"</DateTimeLocal>
			       <DateTimeUTC>" + DatetimeUtc.ToString("yyyyMMddHHmmss") + @"</DateTimeUTC>
                <OrderPaidTransRefID>" + TransRefIDPaid + @"</OrderPaidTransRefID>
		      <OrderNo>" + OrderNo + @"</OrderNo>
		      <PIN>" + Pin + @"</PIN>
		      <BeneCurrency>" + BeneCurrency + @"</BeneCurrency>
		      <BeneAmount>" + BeneAmount + @"</BeneAmount>
         	</Root>");

            RiaFxGlobalWebReferance.FXGlobalSending FxObject = new RiaFxGlobalWebReferance.FXGlobalSending();
            XmlNode nodeObj = FxObject.OP_VoidOrderPaidConfirmation(SOAPReqBody);
            response_node = nodeObj.InnerXml;
            DataTable dtRoot = new DataTable();
            DataTable dtHeader = new DataTable();
            DataTable dtOrderResponse = new DataTable();
            DataTable dtRequired = new DataTable();
            XmlReader xmlReader = new XmlNodeReader(nodeObj);
            DataSet ds = new DataSet();
            ds.ReadXml(xmlReader);
            dtRoot = ds.Tables["Root"];
            dtHeader = ds.Tables["Header"];
            dtOrderResponse = ds.Tables["VoidOrderPaidConfirmResponse"];
            MethodCalled = dtHeader.Rows[0]["MethodCalled"].ToString();
            string CallID_Ext = dtHeader.Rows[0]["CallID_Ext"].ToString();
            DateTime ResponseDateTimeUTC = DateTime.ParseExact(dtHeader.Rows[0]["ResponseDateTimeUTC"].ToString(), "yyyyMMddHHmmss", CultureInfo.InvariantCulture);
            string TransRefID = dtOrderResponse.Rows[0]["TransRefID"].ToString();
            string PINResponse = dtOrderResponse.Rows[0]["PIN"].ToString();
            string OrderNoResponse = dtOrderResponse.Rows[0]["OrderNo"].ToString();
            string BeneCurrencyResponse = dtOrderResponse.Rows[0]["BeneCurrency"].ToString();
            double BeneAmountResponse = double.Parse(dtOrderResponse.Rows[0]["BeneAmount"].ToString());

            ResponseCode = dtOrderResponse.Rows[0]["ResponseCode"].ToString();
            ResponseText = dtOrderResponse.Rows[0]["ResponseText"].ToString();
            CancelOrder = VoidPaidOrder(RefID_Verify, CallRefID, MethodCalled, ResponseDateTimeUTC, TransRefID, PINResponse, OrderNoResponse, BeneCurrencyResponse, BeneAmountResponse, ResponseCode, ResponseText, EmpID);

            if (ResponseCode == "1000")// && CancelOrder)
                VoidOrder = "1";

        }
        catch (Exception ex)
        {
            Common.WriteLog(RefID_Verify, "Ria API", "OP_VoidOrderPaidConfirmation", ex.Message);
        }
        finally
        {
            SaveReqResponseData("Ria API",CallRefID, "OP_VoidOrderPaidConfirmation", CallDateTime, SOAPReqBody.InnerXml, response_node, VoidOrder, ResponseText);
        }
        return VoidOrder;
    }


    private PaidRemilistStatus FxOfficePickupMarkAsPaid(string RefId_VerifyOrder, string RefID_PaidOrder, string BeneCurrency, decimal BeneAmountResponse, string EmpID, DateTime ResponseDateTimeUTC, string ResponseCode, string ResponseText)
    {
        //int Done = 0;
        //Int64 RID = 0;
        PaidRemilistStatus paidStatus = new PaidRemilistStatus();
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Ria_Paid_RemiList";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RefId_VerifyOrder", System.Data.SqlDbType.VarChar).Value = RefId_VerifyOrder;
                    cmd.Parameters.Add("@RefID_PaidOrder", System.Data.SqlDbType.VarChar).Value = RefID_PaidOrder;
                    cmd.Parameters.Add("@BeneCurrency", System.Data.SqlDbType.VarChar).Value = BeneCurrency;
                    cmd.Parameters.Add("@BeneAmount", System.Data.SqlDbType.Decimal).Value = BeneAmountResponse;
                    cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = EmpID;
                    cmd.Parameters.Add("@DateTimeUTCPaid", System.Data.SqlDbType.DateTime).Value = ResponseDateTimeUTC;
                    cmd.Parameters.Add("@ResponseCode", System.Data.SqlDbType.VarChar).Value = ResponseCode;
                    cmd.Parameters.Add("@ResponseTextPaid", System.Data.SqlDbType.VarChar).Value = ResponseText;
                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = 0;
                    cmd.Parameters.Add(sqlDone);

                    SqlParameter sqlRID = new SqlParameter("@RID", SqlDbType.BigInt);
                    sqlRID.Direction = ParameterDirection.InputOutput;
                    sqlRID.Value = 0;
                    cmd.Parameters.Add(sqlRID);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    paidStatus.Done = (bool)sqlDone.Value;
                    paidStatus.RID = (Int64)sqlRID.Value;


                }

            }

        }
        catch (Exception ex)
        {
            Common.WriteLog(RefID_PaidOrder, "Ria API", "s_Ria_Paid_RemiList", ex.Message);
            paidStatus.Done = false;
        }
        return paidStatus;
    }

    private bool VoidPaidOrder(string RefIDVerify, string RefIDCall, string MethodCalled, DateTime ResponseDateTimeUTC, string TransRefID, string PINResponse, string OrderNo, string BeneCurrency, double BeneAmountResponse, string ResponseCode, string ResponseText, string EmpID)
    {
        bool Done = false;
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Ria_Void_OrderPaid_Confirmation";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("RefIDVerify", System.Data.SqlDbType.VarChar).Value = RefIDVerify;
                    cmd.Parameters.Add("@RefIDCall", System.Data.SqlDbType.VarChar).Value = RefIDCall;
                    cmd.Parameters.Add("@MethodCalled", System.Data.SqlDbType.VarChar).Value = MethodCalled;
                    cmd.Parameters.Add("@ResponseDateTimeUTC", System.Data.SqlDbType.DateTime).Value = ResponseDateTimeUTC;

                    cmd.Parameters.Add("@TransRefID", System.Data.SqlDbType.VarChar).Value = TransRefID;
                    cmd.Parameters.Add("@PINResponse", System.Data.SqlDbType.VarChar).Value = PINResponse;

                    cmd.Parameters.Add("@OrderNo", System.Data.SqlDbType.VarChar).Value = OrderNo;
                    cmd.Parameters.Add("@BeneCurrency", System.Data.SqlDbType.VarChar).Value = BeneCurrency;
                    cmd.Parameters.Add("@BeneAmountResponse", System.Data.SqlDbType.VarChar).Value = BeneAmountResponse;
                    cmd.Parameters.Add("@ResponseCode", System.Data.SqlDbType.VarChar).Value = ResponseCode;
                    cmd.Parameters.Add("@ResponseText", System.Data.SqlDbType.VarChar).Value = ResponseText;
                    cmd.Parameters.Add("@InsertBy", System.Data.SqlDbType.VarChar).Value = EmpID;
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
            Done = false;
            Common.WriteLog(RefIDCall, "Ria API", "s_Ria_Void_OrderPaid_Confirmation", ex.Message);
        }
        return Done;
    }

    //
    private void SaveReqResponseData( string ExHouseCode,string CallRefID,string MethodCalled, DateTime CallDate, string ReqData, string ResponseData, string ResponseCode, string ResponseText)
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
            Common.WriteLog(CallRefID, "Ria API", "s_FxServiceLog_Insert", ex.Message);
        }
    }

    [WebMethod(Description = "Service Task: Checking Order Details"
        + "<br>" + "Returns:"
        + "<br>" + "Response Code=1000: " + "Success"

      )]
    public string GetOrderDetails(
        string OrderNo,
    string Pin,
    string BranchCode,
    string BranchName,
    string EmpID,
    string KeyCode
    )
    {
        string response_node = "";
        string CallRefID = Guid.NewGuid().ToString();
        XmlDocument SOAPReqBody = new XmlDocument();
        DateTime CallDateTime = DateTime.Now;
        DateTime DatetimeUtc = DateTime.UtcNow;
        SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>
            <Root>" + GetRiaHeader(CallRefID, CallDateTime, BranchCode, EmpID, DatetimeUtc, BranchName) +
            "<Request><OrderNo>" + "SN1234567555" + @"</OrderNo></Request>
           </Root>");

        RiaFxGlobalWebReferance.FXGlobalSending FxObject = new RiaFxGlobalWebReferance.FXGlobalSending();
        XmlNode nodeObj = FxObject.GetOrderDetails(SOAPReqBody);
        response_node = nodeObj.InnerXml;
        DataTable dtRoot = new DataTable();
        DataTable dtHeader = new DataTable();
        DataTable dtOrderResponse = new DataTable();
        DataTable dtRequired = new DataTable();
        XmlReader xmlReader = new XmlNodeReader(nodeObj);
        DataSet ds = new DataSet();
        ds.ReadXml(xmlReader);
        dtRoot = ds.Tables["Root"];
        dtHeader = ds.Tables["Header"];
        return "";
    }

    [WebMethod(Description = "Service Task: Checking Order Details"
         + "<br>" + "Returns:"
         + "<br>" + "Response Code=1000: " + "Success"

       )]
    public string InputPayersCustSvcMsgs(
         string OrderNo,
    string Pin,
    string BranchCode,
    string BranchName,
    string EmpID,
    string KeyCode
    )
    {
        string response_node = "";
        string CallRefID = Guid.NewGuid().ToString();
        XmlDocument SOAPReqBody = new XmlDocument();
        DateTime CallDateTime = DateTime.Now;
        DateTime DatetimeUtc = DateTime.UtcNow;
        SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>
            <Root>" + GetRiaHeader(CallRefID, CallDateTime, BranchCode, EmpID, DatetimeUtc, BranchName) +
            "<Request><OrderNo>" + "SN1234567555" + @"</OrderNo></Request>
           </Root>");

        RiaFxGlobalWebReferance.FXGlobalSending FxObject = new RiaFxGlobalWebReferance.FXGlobalSending();
        XmlNode nodeObj = FxObject.InputPayersCustSvcMsgs(SOAPReqBody);
        response_node = nodeObj.InnerXml;
        DataTable dtRoot = new DataTable();
        DataTable dtHeader = new DataTable();
        DataTable dtOrderResponse = new DataTable();
        DataTable dtRequired = new DataTable();
        XmlReader xmlReader = new XmlNodeReader(nodeObj);
        DataSet ds = new DataSet();
        ds.ReadXml(xmlReader);
        dtRoot = ds.Tables["Root"];
        dtHeader = ds.Tables["Header"];
        return "";
    }


    [WebMethod(Description = "Service Task:Bank Deposit Get Order For Download pending Orders"
    + "<br>" + "Returns:"
    + "<br>" + "1: " + "Success"
    + "<br>" + "-2: " + "Invalid Key Code"
    + "<br>" + "-3: " + "Local Database Down"
    + "<br>" + "4: " + "Default Fail"

    )]
    public string BD_GetOrderForDownload(
      string BranchCode,
      string BranchName,
      string EmpID,
      string KeyCode
    )
    {
        if (KeyCode != getValueOfKey("Ria_KeyCode"))
            return "-2";
        string CallRefID = Guid.NewGuid().ToString();

        long NotificationID = GetRemittanceSequence("Ria API", 1);
        if (NotificationID == 0)
        {
            return "-3";

        }
        XmlDocument SOAPReqBody = new XmlDocument();
        DateTime CallDateTime = DateTime.Now;
        DateTime DatetimeUtc = DateTime.UtcNow;
        string response_node = "";
        string MethodCalled = "";

        int SaveDone = 4;

        try
        {
            SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>
            <Root>" + GetRiaHeader(CallRefID, CallDateTime, BranchCode, EmpID, DatetimeUtc, BranchName) +

      "<RequestType>" + "OrdersForDownload" + @"</RequestType>
		     
         	</Root>");

            RiaFxGlobalWebReferance.FXGlobalSending FxObject = new RiaFxGlobalWebReferance.FXGlobalSending();
            //
            //string node = "<ResponseLayoutVersion>2.0</ResponseLayoutVersion><Header><MethodCalled>GetOrdersForDownload</MethodCalled><CallID_Ext>3e178c27-85fc-4688-8c79-a9b1d4a25c65</CallID_Ext><ResponseDateTimeUTC>20180924055926</ResponseDateTimeUTC></Header><RequestType>OrdersForDownload</RequestType><RequestResponses><Order><OrderNo>JP1924127355</OrderNo><PIN>11331261314</PIN><SendingCorrespSeqID>2309</SendingCorrespSeqID><PayingCorrespSeqID>536</PayingCorrespSeqID><SalesDate>20180921</SalesDate><SalesTime>213821</SalesTime><CountryFrom>JP</CountryFrom>" +
            //        "<CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>52003</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>82.10</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>82.10</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>USD</CustomerChargeCurrency>" +
            //        "<CustomerChargeAmount>0.00</CustomerChargeAmount><BeneID>1154516555</BeneID><BeneFirstName>HASINA</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>LASTNAME</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>Titas Comilla</BeneAddress><BeneCity>Comilla</BeneCity><BeneState></BeneState><BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo></BenePhoneNo><BeneCellNo></BeneCellNo><BeneMessage></BeneMessage><CustID>2044606555</CustID><CustFirstName>KANDEL</CustFirstName><CustMiddleName></CustMiddleName>" +
            //        "<CustLastName>BHABINDRA</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type>Residence Card</CustID1Type><CustID1No>EG35603982EK</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>  </CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>20181016</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState>" +
            //        "<CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry></CustTaxCountry><CustCountryOfBirth>  </CustCountryOfBirth><CustNationality>NP</CustNationality><CustDateOfBirth>19920202</CustDateOfBirth><CustOccupation>Part-timer</CustOccupation><CustSourceOfFunds>Salary</CustSourceOfFunds><CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Wife</CustBeneRelationship>" +
            //        "<TransferReason>Family Assistance</TransferReason><BankName>TRUST BANK LTD</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>00780310006434</BankAccountNo><BeneIDType>CIN</BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Comilla</BankCity><BankBranchNo>392645</BankBranchNo><BankBranchName>Titas Branch (Comilla)</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode>392645</BankRoutingCode><BIC_SWIFT>TTBLBDDH</BIC_SWIFT>" +
            //        "<UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924127455</OrderNo><PIN>11331373167</PIN><SendingCorrespSeqID>2310</SendingCorrespSeqID><PayingCorrespSeqID>539</PayingCorrespSeqID><SalesDate>20180921</SalesDate><SalesTime>213824</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID>" +
            //        "<SendingCorrespBranchNo>52003</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>82.10</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>82.10</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>USD</CustomerChargeCurrency>" +
            //        "<CustomerChargeAmount>0.00</CustomerChargeAmount><BeneID>1154516455</BeneID><BeneFirstName>HASSAN</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>ALI</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>Titas Comilla</BeneAddress><BeneCity>Comilla</BeneCity><BeneState></BeneState><BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo></BenePhoneNo><BeneCellNo></BeneCellNo><BeneMessage></BeneMessage><CustID>2044606655</CustID><CustFirstName>KANDEL</CustFirstName><CustMiddleName></CustMiddleName>" +
            //        "<CustLastName>BHABINDRA</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type>Residence Card</CustID1Type><CustID1No>EG35603982EK</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>  </CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>20181016</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState>" +
            //        "<CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry></CustTaxCountry><CustCountryOfBirth>  </CustCountryOfBirth><CustNationality>NP</CustNationality><CustDateOfBirth>19920202</CustDateOfBirth><CustOccupation>Part-timer</CustOccupation><CustSourceOfFunds>Salary</CustSourceOfFunds><CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Wife</CustBeneRelationship><TransferReason>Family Assistance</TransferReason>" +
            //        "<BankName>TRUST BANK LTD</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>00780310006434</BankAccountNo><BeneIDType>CIN</BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Comilla</BankCity><BankBranchNo>392645</BankBranchNo><BankBranchName>Titas Branch (Comilla)</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode>392645</BankRoutingCode><BIC_SWIFT>TTBLBDDH</BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix>" +
            //        "<MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924127555</OrderNo><PIN>11331221189</PIN><SendingCorrespSeqID>2311</SendingCorrespSeqID><PayingCorrespSeqID>540</PayingCorrespSeqID><SalesDate>20180921</SalesDate><SalesTime>213826</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>52003</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency>" +
            //        "<BeneficiaryAmount>164.20</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>164.20</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>USD</CustomerChargeCurrency><CustomerChargeAmount>0.00</CustomerChargeAmount><BeneID>1154516355</BeneID><BeneFirstName>HASSAN</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>ALI</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>Titas Comilla</BeneAddress><BeneCity>Comilla</BeneCity>" +
            //        "<BeneState></BeneState><BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo></BenePhoneNo><BeneCellNo></BeneCellNo><BeneMessage></BeneMessage><CustID>2044606755</CustID><CustFirstName>KANDEL</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>BHABINDRA</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type>Residence Card</CustID1Type><CustID1No>EG35603982EK</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>  </CustID1IssuedByCountry>" +
            //        "<CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>20181016</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry></CustTaxCountry><CustCountryOfBirth>  </CustCountryOfBirth><CustNationality>NP</CustNationality><CustDateOfBirth>19920202</CustDateOfBirth>" +
            //        "<CustOccupation>Part-timer</CustOccupation><CustSourceOfFunds>Salary</CustSourceOfFunds><CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Wife</CustBeneRelationship><TransferReason>Family Assistance</TransferReason><BankName>TRUST BANK LTD</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>00780310006434</BankAccountNo><BeneIDType>CIN</BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Comilla</BankCity><BankBranchNo>392645</BankBranchNo><BankBranchName>Titas Branch (Comilla)</BankBranchName>" +
            //        "<BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode>392645</BankRoutingCode><BIC_SWIFT>TTBLBDDH</BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924127655</OrderNo><PIN>11331223120</PIN><SendingCorrespSeqID>2312</SendingCorrespSeqID><PayingCorrespSeqID>537</PayingCorrespSeqID><SalesDate>20180921</SalesDate><SalesTime>214148</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo>" +
            //        "<PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>52003</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>821.00</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>821.00</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>USD</CustomerChargeCurrency><CustomerChargeAmount>0.00</CustomerChargeAmount>" +
            //        "<BeneID>1154517455</BeneID><BeneFirstName>Suhaila</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>Hassana</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>Titas Comilla</BeneAddress><BeneCity>Comilla</BeneCity><BeneState></BeneState><BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo></BenePhoneNo><BeneCellNo></BeneCellNo><BeneMessage></BeneMessage><CustID>2044606655</CustID><CustFirstName>KANDEL</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>BHABINDRA</CustLastName><CustLastName2></CustLastName2>" +
            //        "<CustCountry>JP</CustCountry><CustID1Type>Residence Card</CustID1Type><CustID1No>EG35603982EK</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>  </CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>20181016</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate>" +
            //        "<CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry></CustTaxCountry><CustCountryOfBirth>  </CustCountryOfBirth><CustNationality>NP</CustNationality><CustDateOfBirth>19920202</CustDateOfBirth><CustOccupation>Part-timer</CustOccupation><CustSourceOfFunds>Salary</CustSourceOfFunds><CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Wife</CustBeneRelationship><TransferReason>Family Assistance</TransferReason><BankName>TRUST BANK LTD</BankName><BankAccountType>Savings</BankAccountType>" +
            //        "<BankAccountNo>00780310006434</BankAccountNo><BeneIDType>CIN</BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Comilla</BankCity><BankBranchNo>392645</BankBranchNo><BankBranchName>Titas Branch (Comilla)</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode>392645</BankRoutingCode><BIC_SWIFT>TTBLBDDH</BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924127755</OrderNo>" +
            //        "<PIN>11331218459</PIN><SendingCorrespSeqID>2313</SendingCorrespSeqID><PayingCorrespSeqID>538</PayingCorrespSeqID><SalesDate>20180921</SalesDate><SalesTime>214152</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>52003</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>821.00</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency>" +
            //        "<PaymentAmount>821.00</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>USD</CustomerChargeCurrency><CustomerChargeAmount>0.00</CustomerChargeAmount><BeneID>1154517555</BeneID><BeneFirstName>Jasmine</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>Ali</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>Titas Comilla</BeneAddress><BeneCity>Comilla</BeneCity><BeneState></BeneState><BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo></BenePhoneNo><BeneCellNo></BeneCellNo>" +
            //        "<BeneMessage></BeneMessage><CustID>2044606655</CustID><CustFirstName>KANDEL</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>BHABINDRA</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type>Residence Card</CustID1Type><CustID1No>EG35603982EK</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>  </CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>20181016</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No>" +
            //        "<CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry></CustTaxCountry><CustCountryOfBirth>  </CustCountryOfBirth><CustNationality>NP</CustNationality><CustDateOfBirth>19920202</CustDateOfBirth><CustOccupation>Part-timer</CustOccupation><CustSourceOfFunds>Salary</CustSourceOfFunds><CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Wife</CustBeneRelationship>" +
            //        "<TransferReason>Family Assistance</TransferReason><BankName>TRUST BANK LTD</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>00780310006434</BankAccountNo><BeneIDType>CIN</BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Comilla</BankCity><BankBranchNo>392645</BankBranchNo><BankBranchName>Titas Branch (Comilla)</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode>392645</BankRoutingCode><BIC_SWIFT>TTBLBDDH</BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype>" +
            //        "<MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924127855</OrderNo><PIN>11331344052</PIN><SendingCorrespSeqID>2314</SendingCorrespSeqID><PayingCorrespSeqID>541</PayingCorrespSeqID><SalesDate>20180921</SalesDate><SalesTime>214155</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>52003</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency>" +
            //        "<BeneficiaryAmount>164.20</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>164.20</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>USD</CustomerChargeCurrency><CustomerChargeAmount>0.00</CustomerChargeAmount><BeneID>1154517655</BeneID><BeneFirstName>Anan</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>Yasir</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>Titas Comilla</BeneAddress><BeneCity>Comilla</BeneCity><BeneState></BeneState>" +
            //        "<BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo></BenePhoneNo><BeneCellNo></BeneCellNo><BeneMessage></BeneMessage><CustID>2044606655</CustID><CustFirstName>KANDEL</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>BHABINDRA</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type>Residence Card</CustID1Type><CustID1No>EG35603982EK</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>  </CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate>" +
            //        "<CustID1ExpirationDate>20181016</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry></CustTaxCountry><CustCountryOfBirth>  </CustCountryOfBirth><CustNationality>NP</CustNationality><CustDateOfBirth>19920202</CustDateOfBirth><CustOccupation>Part-timer</CustOccupation><CustSourceOfFunds>Salary</CustSourceOfFunds>" +
            //        "<CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Wife</CustBeneRelationship><TransferReason>Family Assistance</TransferReason><BankName>TRUST BANK LTD</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>00780310006434</BankAccountNo><BeneIDType>CIN</BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Comilla</BankCity><BankBranchNo>392645</BankBranchNo><BankBranchName>Titas Branch (Comilla)</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode>392645</BankRoutingCode><BIC_SWIFT>TTBLBDDH</BIC_SWIFT>" +
            //        "<UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924128455</OrderNo><PIN>11331376016</PIN><SendingCorrespSeqID>990</SendingCorrespSeqID><PayingCorrespSeqID>543</PayingCorrespSeqID><SalesDate>20180921</SalesDate><SalesTime>222900</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>51480</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer>" +
            //        "<PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>740.00</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>740.00</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>JPY</CustomerChargeCurrency><CustomerChargeAmount>880.00</CustomerChargeAmount><BeneID>1154520355</BeneID><BeneFirstName>KANDEL</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>BHABINDRA</BeneLastName><BeneLastName2></BeneLastName2>" +
            //        "<BeneAddress>Titas Comilla</BeneAddress><BeneCity>Comilla</BeneCity><BeneState></BeneState><BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo></BenePhoneNo><BeneCellNo></BeneCellNo><BeneMessage></BeneMessage><CustID>2044611255</CustID><CustFirstName>Yuri</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>Kanazawa</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type>Residence Card</CustID1Type><CustID1No>EG35603982EK</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState>" +
            //        "<CustID1IssuedByCountry>  </CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>20181016</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry></CustTaxCountry><CustCountryOfBirth>  </CustCountryOfBirth><CustNationality>NP</CustNationality><CustDateOfBirth>19920202</CustDateOfBirth>" +
            //        "<CustOccupation>Part-timer</CustOccupation><CustSourceOfFunds>Salary</CustSourceOfFunds><CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Wife</CustBeneRelationship><TransferReason>Family Assistance</TransferReason><BankName>BANGLADESH COMMERCE BANK LIMITED</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>00780310006434</BankAccountNo><BeneIDType></BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Barishal</BankCity><BankBranchNo>030060281</BankBranchNo><BankBranchName>Barishal</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode>" +
            //        "<BankRoutingCode></BankRoutingCode><BIC_SWIFT></BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924128555</OrderNo><PIN>11331457391</PIN><SendingCorrespSeqID>991</SendingCorrespSeqID><PayingCorrespSeqID>542</PayingCorrespSeqID><SalesDate>20180921</SalesDate><SalesTime>222904</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>51480</SendingCorrespBranchNo>" +
            //        "<BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>740.00</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>740.00</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>JPY</CustomerChargeCurrency><CustomerChargeAmount>880.00</CustomerChargeAmount><BeneID>1154520455</BeneID><BeneFirstName>HASSAN</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>BHABINDRA</BeneLastName>" +
            //        "<BeneLastName2></BeneLastName2><BeneAddress>Titas Comilla</BeneAddress><BeneCity>Comilla</BeneCity><BeneState></BeneState><BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo></BenePhoneNo><BeneCellNo></BeneCellNo><BeneMessage></BeneMessage><CustID>2044611355</CustID><CustFirstName>Yurima</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>Kanazawa</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type>Residence Card</CustID1Type><CustID1No>EG35603982EK</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState>" +
            //        "<CustID1IssuedByCountry>  </CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>20181016</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry></CustTaxCountry><CustCountryOfBirth>  </CustCountryOfBirth><CustNationality>NP</CustNationality><CustDateOfBirth>19920202</CustDateOfBirth>" +
            //        "<CustOccupation>Part-timer</CustOccupation><CustSourceOfFunds>Salary</CustSourceOfFunds><CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Wife</CustBeneRelationship><TransferReason>Family Assistance</TransferReason><BankName>BANGLADESH COMMERCE BANK LIMITED</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>00780310006434</BankAccountNo><BeneIDType></BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Barishal</BankCity><BankBranchNo>030060281</BankBranchNo><BankBranchName>Barishal</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode>" +
            //        "<BankRoutingCode></BankRoutingCode><BIC_SWIFT></BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order></RequestResponses><RequestErrors />";

            //string node = "<ResponseLayoutVersion>2.0</ResponseLayoutVersion><Header><MethodCalled>GetOrdersForDownload</MethodCalled><CallID_Ext>c7370dac-4716-40f5-b466-33e9d696c431</CallID_Ext><ResponseDateTimeUTC>20181104043534</ResponseDateTimeUTC></Header><RequestType>OrdersForDownload</RequestType><RequestResponses><Order><OrderNo>JP1924306855</OrderNo><PIN>11331147863</PIN><SendingCorrespSeqID>1045</SendingCorrespSeqID><PayingCorrespSeqID>567</PayingCorrespSeqID><SalesDate>20181101</SalesDate><SalesTime>014429</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>51480</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>7500.00</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>7500.00</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>JPY</CustomerChargeCurrency><CustomerChargeAmount>880.00</CustomerChargeAmount><BeneID>1157064455</BeneID><BeneFirstName>MUHAMMAD AKRAM</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>URF AKRI</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>123 WonderLand</BeneAddress><BeneCity>Dhaka</BeneCity><BeneState>C</BeneState><BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo>923046478860</BenePhoneNo><BeneCellNo>923046478860</BeneCellNo><BeneMessage></BeneMessage><CustID>2047116155</CustID><CustFirstName>Mayumi</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>Takeshi</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type>PASSPORT</CustID1Type><CustID1No>HZ6893922</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>PK</CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>20200721</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry>PK</CustTaxCountry><CustCountryOfBirth>PK</CustCountryOfBirth><CustNationality>PK</CustNationality><CustDateOfBirth>19871024</CustDateOfBirth><CustOccupation>Construction Trades and Related Workers</CustOccupation><CustSourceOfFunds>Salary and Overtime</CustSourceOfFunds><CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Father</CustBeneRelationship><TransferReason>Family Assistance</TransferReason><BankName>TRUST BANK LTD</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>2050267020003</BankAccountNo><BeneIDType></BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Chittagong</BankCity><BankBranchNo>240150136</BankBranchNo><BankBranchName>Agrabad</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode></BankRoutingCode><BIC_SWIFT></BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924307655</OrderNo><PIN>11331304174</PIN><SendingCorrespSeqID>1046</SendingCorrespSeqID><PayingCorrespSeqID>568</PayingCorrespSeqID><SalesDate>20181101</SalesDate><SalesTime>041424</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>51480</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>15000.00</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>15000.00</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>JPY</CustomerChargeCurrency><CustomerChargeAmount>880.00</CustomerChargeAmount><BeneID>1157078155</BeneID><BeneFirstName>AKTAR HOSSAIN</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>ABDURRASHID</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>123 WonderLand</BeneAddress><BeneCity>Dhaka</BeneCity><BeneState>C</BeneState><BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo>923046478860</BenePhoneNo><BeneCellNo>923046478860</BeneCellNo><BeneMessage></BeneMessage><CustID>2047128355</CustID><CustFirstName>Haneda</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>Takeshi</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type>PASSPORT</CustID1Type><CustID1No>JP6893922</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>JP</CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>20200721</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry>JP</CustTaxCountry><CustCountryOfBirth>JP</CustCountryOfBirth><CustNationality>JP</CustNationality><CustDateOfBirth>19871024</CustDateOfBirth><CustOccupation>Customer Services</CustOccupation><CustSourceOfFunds>Salary and Overtime</CustSourceOfFunds><CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Father</CustBeneRelationship><TransferReason>Family Assistance</TransferReason><BankName>TRUST BANK LTD</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>00020310240118</BankAccountNo><BeneIDType></BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Chittagong</BankCity><BankBranchNo>240151485</BankBranchNo><BankBranchName>C D A  Avenue</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode></BankRoutingCode><BIC_SWIFT></BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924307755</OrderNo><PIN>11331411254</PIN><SendingCorrespSeqID>1047</SendingCorrespSeqID><PayingCorrespSeqID>576</PayingCorrespSeqID><SalesDate>20181101</SalesDate><SalesTime>041732</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>51480</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>15000.00</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>15000.00</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>JPY</CustomerChargeCurrency><CustomerChargeAmount>880.00</CustomerChargeAmount><BeneID>1157078255</BeneID><BeneFirstName>MD FAZLU</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>RAHMAN</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>123 WonderLand</BeneAddress><BeneCity>Dhaka</BeneCity><BeneState>C</BeneState><BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo>923046478860</BenePhoneNo><BeneCellNo>923046478860</BeneCellNo><BeneMessage></BeneMessage><CustID>2047128555</CustID><CustFirstName>Date</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>Takeshi</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type>PASSPORT</CustID1Type><CustID1No>JP6893922</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>JP</CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>20200721</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry>JP</CustTaxCountry><CustCountryOfBirth>JP</CustCountryOfBirth><CustNationality>JP</CustNationality><CustDateOfBirth>19871024</CustDateOfBirth><CustOccupation>Customer Services</CustOccupation><CustSourceOfFunds>Salary and Overtime</CustSourceOfFunds><CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Father</CustBeneRelationship><TransferReason>Family Assistance</TransferReason><BankName>TRUST BANK LTD</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>00020311003364</BankAccountNo><BeneIDType></BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Chittagong</BankCity><BankBranchNo>240151485</BankBranchNo><BankBranchName>C D A  Avenue</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode></BankRoutingCode><BIC_SWIFT></BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924307855</OrderNo><PIN>11331410354</PIN><SendingCorrespSeqID>1048</SendingCorrespSeqID><PayingCorrespSeqID>569</PayingCorrespSeqID><SalesDate>20181101</SalesDate><SalesTime>041851</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>51480</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>18750.00</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>18750.00</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>JPY</CustomerChargeCurrency><CustomerChargeAmount>880.00</CustomerChargeAmount><BeneID>1157078355</BeneID><BeneFirstName>MDAJDU MIAH</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>MD SONAI</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>123 WonderLand</BeneAddress><BeneCity>Dhaka</BeneCity><BeneState>C</BeneState><BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo>923046478860</BenePhoneNo><BeneCellNo>923046478860</BeneCellNo><BeneMessage></BeneMessage><CustID>2047128755</CustID><CustFirstName>Wanade</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>Takeshi</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type>PASSPORT</CustID1Type><CustID1No>JP6893922</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>JP</CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>20200721</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry>JP</CustTaxCountry><CustCountryOfBirth>JP</CustCountryOfBirth><CustNationality>JP</CustNationality><CustDateOfBirth>19871024</CustDateOfBirth><CustOccupation>Customer Services</CustOccupation><CustSourceOfFunds>Salary and Overtime</CustSourceOfFunds><CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Father</CustBeneRelationship><TransferReason>Family Assistance</TransferReason><BankName>TRUST BANK LTD</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>70220311001322</BankAccountNo><BeneIDType></BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Chittagong</BankCity><BankBranchNo>240151485</BankBranchNo><BankBranchName>C D A  Avenue</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode></BankRoutingCode><BIC_SWIFT></BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924307955</OrderNo><PIN>11331335626</PIN><SendingCorrespSeqID>1049</SendingCorrespSeqID><PayingCorrespSeqID>570</PayingCorrespSeqID><SalesDate>20181101</SalesDate><SalesTime>042033</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>51480</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>22500.00</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>22500.00</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>JPY</CustomerChargeCurrency><CustomerChargeAmount>880.00</CustomerChargeAmount><BeneID>1157078455</BeneID><BeneFirstName>MD JELO</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>MOLLAH</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>5545 Royale Palace</BeneAddress><BeneCity>Dhaka</BeneCity><BeneState>C</BeneState><BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo>923046478860</BenePhoneNo><BeneCellNo>923046478860</BeneCellNo><BeneMessage></BeneMessage><CustID>2047128755</CustID><CustFirstName>Wanade</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>Takeshi</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type>PASSPORT</CustID1Type><CustID1No>JP6893922</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>JP</CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>20200721</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry>JP</CustTaxCountry><CustCountryOfBirth>JP</CustCountryOfBirth><CustNationality>JP</CustNationality><CustDateOfBirth>19871024</CustDateOfBirth><CustOccupation>Customer Services</CustOccupation><CustSourceOfFunds>Salary and Overtime</CustSourceOfFunds><CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Father</CustBeneRelationship><TransferReason>Family Assistance</TransferReason><BankName>TRUST BANK LTD</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>12345678901</BankAccountNo><BeneIDType></BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Chittagong</BankCity><BankBranchNo>240151485</BankBranchNo><BankBranchName>C D A  Avenue</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode></BankRoutingCode><BIC_SWIFT></BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924308055</OrderNo><PIN>11331151062</PIN><SendingCorrespSeqID>1050</SendingCorrespSeqID><PayingCorrespSeqID>571</PayingCorrespSeqID><SalesDate>20181101</SalesDate><SalesTime>042107</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>51480</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>22500.00</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>22500.00</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>JPY</CustomerChargeCurrency><CustomerChargeAmount>880.00</CustomerChargeAmount><BeneID>1157078555</BeneID><BeneFirstName>MONIR</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>HOSSAIN</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>5545 Royale Palace</BeneAddress><BeneCity>Dhaka</BeneCity><BeneState>C</BeneState><BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo>923046478860</BenePhoneNo><BeneCellNo>923046478860</BeneCellNo><BeneMessage></BeneMessage><CustID>2047128755</CustID><CustFirstName>Wanade</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>Takeshi</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type>PASSPORT</CustID1Type><CustID1No>JP6893922</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>JP</CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>20200721</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry>JP</CustTaxCountry><CustCountryOfBirth>JP</CustCountryOfBirth><CustNationality>JP</CustNationality><CustDateOfBirth>19871024</CustDateOfBirth><CustOccupation>Customer Services</CustOccupation><CustSourceOfFunds>Salary and Overtime</CustSourceOfFunds><CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Father</CustBeneRelationship><TransferReason>Family Assistance</TransferReason><BankName>TRUST BANK LTD</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>98745632102</BankAccountNo><BeneIDType></BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Chittagong</BankCity><BankBranchNo>240151485</BankBranchNo><BankBranchName>C D A  Avenue</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode></BankRoutingCode><BIC_SWIFT></BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924308155</OrderNo><PIN>11331358533</PIN><SendingCorrespSeqID>1051</SendingCorrespSeqID><PayingCorrespSeqID>572</PayingCorrespSeqID><SalesDate>20181101</SalesDate><SalesTime>042512</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>51480</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>7500.00</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>7500.00</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>JPY</CustomerChargeCurrency><CustomerChargeAmount>880.00</CustomerChargeAmount><BeneID>1157078655</BeneID><BeneFirstName>JASHIM</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>SHAFIULLLH</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>5545 Royale Palace</BeneAddress><BeneCity>Dhaka</BeneCity><BeneState>C</BeneState><BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo>923046478860</BenePhoneNo><BeneCellNo>923046478860</BeneCellNo><BeneMessage></BeneMessage><CustID>2047129155</CustID><CustFirstName>Yurika</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>Takeshi</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type>PASSPORT</CustID1Type><CustID1No>JP6893922</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>JP</CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>20200721</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry>JP</CustTaxCountry><CustCountryOfBirth>JP</CustCountryOfBirth><CustNationality>JP</CustNationality><CustDateOfBirth>19871024</CustDateOfBirth><CustOccupation>Customer Services</CustOccupation><CustSourceOfFunds>Salary and Overtime</CustSourceOfFunds><CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Father</CustBeneRelationship><TransferReason>Family Assistance</TransferReason><BankName>BANK ASIA LIMITED</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>1083475001217</BankAccountNo><BeneIDType></BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Barisal</BankCity><BankBranchNo>070060283</BankBranchNo><BankBranchName>Barisal</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode></BankRoutingCode><BIC_SWIFT></BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924308255</OrderNo><PIN>11331174558</PIN><SendingCorrespSeqID>1052</SendingCorrespSeqID><PayingCorrespSeqID>573</PayingCorrespSeqID><SalesDate>20181101</SalesDate><SalesTime>042635</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>51480</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>7500.00</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>7500.00</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>JPY</CustomerChargeCurrency><CustomerChargeAmount>880.00</CustomerChargeAmount><BeneID>1157078755</BeneID><BeneFirstName>MOHAMMAD AZAM</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>KHAN</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>5545 Royale Palace</BeneAddress><BeneCity>Dhaka</BeneCity><BeneState>C</BeneState><BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo>923046478860</BenePhoneNo><BeneCellNo>923046478860</BeneCellNo><BeneMessage></BeneMessage><CustID>2047129355</CustID><CustFirstName>Yuri</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>Takeshi</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type>PASSPORT</CustID1Type><CustID1No>JP6893922</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>JP</CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>20200721</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry>JP</CustTaxCountry><CustCountryOfBirth>JP</CustCountryOfBirth><CustNationality>JP</CustNationality><CustDateOfBirth>19871024</CustDateOfBirth><CustOccupation>Customer Services</CustOccupation><CustSourceOfFunds>Salary and Overtime</CustSourceOfFunds><CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Father</CustBeneRelationship><TransferReason>Family Assistance</TransferReason><BankName>BANK ASIA LIMITED</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>07934001252</BankAccountNo><BeneIDType></BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Barisal</BankCity><BankBranchNo>390369</BankBranchNo><BankBranchName>Gazipur Sadar  Branch - DIP  Sadar</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode></BankRoutingCode><BIC_SWIFT></BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924308355</OrderNo><PIN>11331196698</PIN><SendingCorrespSeqID>1053</SendingCorrespSeqID><PayingCorrespSeqID>574</PayingCorrespSeqID><SalesDate>20181101</SalesDate><SalesTime>042813</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>51480</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>15000.00</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>15000.00</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>JPY</CustomerChargeCurrency><CustomerChargeAmount>880.00</CustomerChargeAmount><BeneID>1157078855</BeneID><BeneFirstName>RABEYA</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>BEGUM</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>5545 Royale Palace</BeneAddress><BeneCity>Dhaka</BeneCity><BeneState>C</BeneState><BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo>923046478860</BenePhoneNo><BeneCellNo>923046478860</BeneCellNo><BeneMessage></BeneMessage><CustID>2047129555</CustID><CustFirstName>MAHAFUZ ALAM</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>ABID MIAH</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type>PASSPORT</CustID1Type><CustID1No>JP6893922</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>JP</CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>20200721</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry>JP</CustTaxCountry><CustCountryOfBirth>JP</CustCountryOfBirth><CustNationality>JP</CustNationality><CustDateOfBirth>19871024</CustDateOfBirth><CustOccupation>Customer Services</CustOccupation><CustSourceOfFunds>Salary and Overtime</CustSourceOfFunds><CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Father</CustBeneRelationship><TransferReason>Family Assistance</TransferReason><BankName>BANK ASIA LIMITED</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>112233445566</BankAccountNo><BeneIDType></BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Barisal</BankCity><BankBranchNo>390437</BankBranchNo><BankBranchName>Ramgonj Branch - DIP  Laxmipur</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode></BankRoutingCode><BIC_SWIFT></BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924308455</OrderNo><PIN>11331228737</PIN><SendingCorrespSeqID>1054</SendingCorrespSeqID><PayingCorrespSeqID>575</PayingCorrespSeqID><SalesDate>20181101</SalesDate><SalesTime>042917</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>51480</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>15000.00</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>15000.00</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>JPY</CustomerChargeCurrency><CustomerChargeAmount>880.00</CustomerChargeAmount><BeneID>1157078955</BeneID><BeneFirstName>MD BORHAN</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>BEGUM</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>5545 Royale Palace</BeneAddress><BeneCity>Dhaka</BeneCity><BeneState>C</BeneState><BeneZipCode>0000</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo>923046478860</BenePhoneNo><BeneCellNo>923046478860</BeneCellNo><BeneMessage></BeneMessage><CustID>2047129755</CustID><CustFirstName>MAHAFUZ ALAM</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>UDDIN</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type>PASSPORT</CustID1Type><CustID1No>JP6893922</CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>JP</CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>20200721</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry>JP</CustTaxCountry><CustCountryOfBirth>JP</CustCountryOfBirth><CustNationality>JP</CustNationality><CustDateOfBirth>19871024</CustDateOfBirth><CustOccupation>Customer Services</CustOccupation><CustSourceOfFunds>Salary and Overtime</CustSourceOfFunds><CustPaymentMethod>Cash</CustPaymentMethod><CustBeneRelationship>Father</CustBeneRelationship><TransferReason>Family Assistance</TransferReason><BankName>BANK ASIA LIMITED</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>7788990011</BankAccountNo><BeneIDType></BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Barisal</BankCity><BankBranchNo>390437</BankBranchNo><BankBranchName>Ramgonj Branch - DIP  Laxmipur</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode></BankRoutingCode><BIC_SWIFT></BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order></RequestResponses><RequestErrors />";
            //string node = "<ResponseLayoutVersion>2.0</ResponseLayoutVersion><Header><MethodCalled>GetOrdersForDownload</MethodCalled><CallID_Ext>d36d660e-63ff-42b6-8312-389f6d0c77c5</CallID_Ext><ResponseDateTimeUTC>20190103050622</ResponseDateTimeUTC></Header><RequestType>OrdersForDownload</RequestType><RequestResponses><Order><OrderNo>JP1924521255</OrderNo><PIN>11331417134</PIN><SendingCorrespSeqID>1127</SendingCorrespSeqID><PayingCorrespSeqID>603</PayingCorrespSeqID><SalesDate>20181228</SalesDate><SalesTime>215414</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>51480</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>7500.00</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>7500.00</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>JPY</CustomerChargeCurrency><CustomerChargeAmount>880.00</CustomerChargeAmount><BeneID>1159096255</BeneID><BeneFirstName>Fahim</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>Ali</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>920-0000 ISHIKAWA-KEN  KANAZAWA-SHI</BeneAddress><BeneCity>DAIRA-42-13 OKUWAMACHI  BUILDI</BeneCity><BeneState></BeneState><BeneZipCode>9218046</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo></BenePhoneNo><BeneCellNo></BeneCellNo><BeneMessage></BeneMessage><CustID>2049139655</CustID><CustFirstName>MD MASUM</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>MURSHED</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type></CustID1Type><CustID1No></CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>  </CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>19000101</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry>  </CustTaxCountry><CustCountryOfBirth>  </CustCountryOfBirth><CustNationality>BD</CustNationality><CustDateOfBirth>19820804</CustDateOfBirth><CustOccupation>STUDENT</CustOccupation><CustSourceOfFunds></CustSourceOfFunds><TransferReason>PERSONAL SAVINGS</TransferReason><BankName>TRUST BANK LTD</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>11680310033979</BankAccountNo><BeneIDType></BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Barisal</BankCity><BankBranchNo>240060284</BankBranchNo><BankBranchName>Barisal</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode></BankRoutingCode><BIC_SWIFT></BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924521355</OrderNo><PIN>11331348223</PIN><SendingCorrespSeqID>1128</SendingCorrespSeqID><PayingCorrespSeqID>602</PayingCorrespSeqID><SalesDate>20181228</SalesDate><SalesTime>215418</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>51480</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>7500.00</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>7500.00</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>JPY</CustomerChargeCurrency><CustomerChargeAmount>880.00</CustomerChargeAmount><BeneID>1159096155</BeneID><BeneFirstName>Esteban</BeneFirstName><BeneMiddleName>Hassan</BeneMiddleName><BeneLastName>Ali</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>920-0000 ISHIKAWA-KEN  KANAZAWA-SHI</BeneAddress><BeneCity>DAIRA-42-13 OKUWAMACHI  BUILDI</BeneCity><BeneState></BeneState><BeneZipCode>9218046</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo></BenePhoneNo><BeneCellNo></BeneCellNo><BeneMessage></BeneMessage><CustID>2049139555</CustID><CustFirstName>MD MASUM</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>MURSHED</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type></CustID1Type><CustID1No></CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>  </CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>19000101</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry>  </CustTaxCountry><CustCountryOfBirth>  </CustCountryOfBirth><CustNationality>BD</CustNationality><CustDateOfBirth>19820804</CustDateOfBirth><CustOccupation>STUDENT</CustOccupation><CustSourceOfFunds></CustSourceOfFunds><TransferReason>PERSONAL SAVINGS</TransferReason><BankName>TRUST BANK LTD</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>1234567890</BankAccountNo><BeneIDType></BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Chittagong</BankCity><BankBranchNo>240151485</BankBranchNo><BankBranchName>C D A  Avenue</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode></BankRoutingCode><BIC_SWIFT></BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order><Order><OrderNo>JP1924521455</OrderNo><PIN>11331463862</PIN><SendingCorrespSeqID>1129</SendingCorrespSeqID><PayingCorrespSeqID>604</PayingCorrespSeqID><SalesDate>20181228</SalesDate><SalesTime>215420</SalesTime><CountryFrom>JP</CountryFrom><CountryTo>BD</CountryTo><PayingCorrespLocID>0</PayingCorrespLocID><SendingCorrespBranchNo>51480</SendingCorrespBranchNo><BeneQuestion></BeneQuestion><BeneAnswer></BeneAnswer><PmtInstructions></PmtInstructions><BeneficiaryCurrency>BDT</BeneficiaryCurrency><BeneficiaryAmount>7500.00</BeneficiaryAmount><DeliveryMethod>2</DeliveryMethod><PaymentCurrency>BDT</PaymentCurrency><PaymentAmount>7500.00</PaymentAmount><CommissionCurrency>BDT</CommissionCurrency><CommissionAmount>0.00</CommissionAmount><CustomerChargeCurrency>JPY</CustomerChargeCurrency><CustomerChargeAmount>880.00</CustomerChargeAmount><BeneID>1159096055</BeneID><BeneFirstName>Paul</BeneFirstName><BeneMiddleName></BeneMiddleName><BeneLastName>FARID</BeneLastName><BeneLastName2></BeneLastName2><BeneAddress>920-0000 ISHIKAWA-KEN  KANAZAWA-SHI</BeneAddress><BeneCity>DAIRA-42-13 OKUWAMACHI  BUILDI</BeneCity><BeneState></BeneState><BeneZipCode>9218046</BeneZipCode><BeneCountry>BD</BeneCountry><BenePhoneNo></BenePhoneNo><BeneCellNo></BeneCellNo><BeneMessage></BeneMessage><CustID>2049139755</CustID><CustFirstName>MD MASUM</CustFirstName><CustMiddleName></CustMiddleName><CustLastName>MURSHED</CustLastName><CustLastName2></CustLastName2><CustCountry>JP</CustCountry><CustID1Type></CustID1Type><CustID1No></CustID1No><CustID1IssuedBy></CustID1IssuedBy><CustID1IssuedByState></CustID1IssuedByState><CustID1IssuedByCountry>  </CustID1IssuedByCountry><CustID1IssuedDate></CustID1IssuedDate><CustID1ExpirationDate>19000101</CustID1ExpirationDate><CustID2Type></CustID2Type><CustID2No></CustID2No><CustID2IssuedBy></CustID2IssuedBy><CustID2IssuedByState></CustID2IssuedByState><CustID2IssuedByCountry>  </CustID2IssuedByCountry><CustID2IssuedDate></CustID2IssuedDate><CustID2ExpirationDate>19000101</CustID2ExpirationDate><CustTaxID></CustTaxID><CustTaxCountry>  </CustTaxCountry><CustCountryOfBirth>  </CustCountryOfBirth><CustNationality>BD</CustNationality><CustDateOfBirth>19820804</CustDateOfBirth><CustOccupation>STUDENT</CustOccupation><CustSourceOfFunds></CustSourceOfFunds><TransferReason>PERSONAL SAVINGS</TransferReason><BankName>BANK ASIA LIMITED</BankName><BankAccountType>Savings</BankAccountType><BankAccountNo>555555555555</BankAccountNo><BeneIDType></BeneIDType><BeneIDNo></BeneIDNo><BeneTaxID></BeneTaxID><BankCity>Barisal</BankCity><BankBranchNo>070060283</BankBranchNo><BankBranchName>Barisal</BankBranchName><BankBranchAddress></BankBranchAddress><BankCode></BankCode><BankRoutingCode></BankRoutingCode><BIC_SWIFT></BIC_SWIFT><UnitaryBankAccountNo></UnitaryBankAccountNo><Valuetype>Same Day</Valuetype><MobileWalletPrefix></MobileWalletPrefix><MobileWalletAccountNo></MobileWalletAccountNo></Order></RequestResponses><RequestErrors />";
            //SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>
            //<Root>" + node + "</Root>");
            // XmlReader xmlReader = new XmlNodeReader(SOAPReqBody);

            // end

            XmlNode nodeObj = FxObject.GetOrdersForDownload(SOAPReqBody);//-
            response_node = nodeObj.InnerXml;//-
            DataTable dtRoot = new DataTable();
            DataTable dtHeader = new DataTable();
            DataTable dtOrderResponse = new DataTable();

            XmlReader xmlReader = new XmlNodeReader(nodeObj);//-
            DataSet ds = new DataSet();
            ds.ReadXml(xmlReader);
            dtRoot = ds.Tables["Root"];
            dtHeader = ds.Tables["Header"];
            dtOrderResponse = ds.Tables["Order"];

            DateTime ResponseDateTimeUTC = DateTime.ParseExact(dtHeader.Rows[0]["ResponseDateTimeUTC"].ToString(), "yyyyMMddHHmmss", CultureInfo.InvariantCulture);

            if (dtOrderResponse != null)
                SaveDone = SaveBulkDownloadData(dtOrderResponse, dtRoot.Rows[0]["RequestType"].ToString(), CallRefID, CallDateTime, ResponseDateTimeUTC, EmpID, NotificationID);
            else
                SaveDone = 5;
        }
        catch (Exception ex)
        {
            SaveDone = 3;
            Common.WriteLog(CallRefID, "Ria API", "GetOrderForDownload", ex.Message);
        }
        finally
        {
            SaveReqResponseData("Ria API",CallRefID, "OrdersForDownload", CallDateTime, SOAPReqBody.InnerXml, response_node, SaveDone.ToString(), SaveDone.ToString());
        }
        return SaveDone.ToString();
    }

    private long GetRemittanceSequence(string AppID, int NoOfSl)
    {
        long number = 0;
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_RemittanceSequence";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@AppID", System.Data.SqlDbType.VarChar).Value = AppID;
                    cmd.Parameters.Add("@NoOfSL", System.Data.SqlDbType.Int).Value = NoOfSl;
                    SqlParameter sqlNumber = new SqlParameter("@SlNo", SqlDbType.BigInt);
                    sqlNumber.Direction = ParameterDirection.InputOutput;
                    sqlNumber.Value = 0;
                    cmd.Parameters.Add(sqlNumber);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    number = (long)sqlNumber.Value;

                }

            }
        }
        catch (Exception ex)
        {
            number = 0;
            Common.WriteLog("", "Ria API", "s_RemittanceSequence", ex.Message);
        }
        return number;
    }


    private bool CheckConnection()
    {
        bool Done = true;
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "SELECT 1";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.Text;
                    //cmd.Parameters.Add("@AppID", System.Data.SqlDbType.VarChar).Value = AppID;
                    //cmd.Parameters.Add("@NoOfSL", System.Data.SqlDbType.Int).Value = NoOfSl;
                    //SqlParameter sqlNumber = new SqlParameter("@SlNo", SqlDbType.BigInt);
                    //sqlNumber.Direction = ParameterDirection.InputOutput;
                    //sqlNumber.Value = 0;
                    //cmd.Parameters.Add(sqlNumber);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();




                }

            }
        }
        catch (Exception ex)
        {
            Done = false;

        }
        return Done;
    }


    private int SaveBulkDownloadData(DataTable dtOrder, string RequestType, string RefIDDownload, DateTime CallDateTime, DateTime ResponseDateTimeUTC, string EmpID, long NotificationID)
    {
        int IsSave = 0;
        DataTable dt_mtr = new DataTable();
        dt_mtr.Columns.Add("NotificationID", typeof(long));
        dt_mtr.Columns.Add("RefIDDownload", typeof(string));
        dt_mtr.Columns.Add("RID", typeof(long));
        dt_mtr.Columns.Add("RequestType", typeof(string));
        dt_mtr.Columns.Add("OrderNo", typeof(string));
        dt_mtr.Columns.Add("PCOrderNo", typeof(string));
        dt_mtr.Columns.Add("Pin", typeof(string));
        dt_mtr.Columns.Add("SendingCorrespSeqID", typeof(string));
        dt_mtr.Columns.Add("PayingCorrespSeqID", typeof(string));
        dt_mtr.Columns.Add("SalesDT", typeof(DateTime));
        //dt_mtr.Columns.Add("SalesTime", typeof(DateTime));
        dt_mtr.Columns.Add("CountryFrom", typeof(string));
        dt_mtr.Columns.Add("CountryTo", typeof(string));
        dt_mtr.Columns.Add("PayingCorrespLocID", typeof(string));
        dt_mtr.Columns.Add("SendingCorrespBranchNo", typeof(string));
        dt_mtr.Columns.Add("BeneQuestion", typeof(string));
        dt_mtr.Columns.Add("BeneAnswer", typeof(string));

        dt_mtr.Columns.Add("PmtInstructions", typeof(string));
        dt_mtr.Columns.Add("BeneficiaryCurrency", typeof(string));
        dt_mtr.Columns.Add("BeneficiaryAmount", typeof(decimal));
        dt_mtr.Columns.Add("DeliveryMethod", typeof(int));
        dt_mtr.Columns.Add("PaymentCurrency", typeof(string));
        dt_mtr.Columns.Add("PaymentAmount", typeof(decimal));
        dt_mtr.Columns.Add("CommissionCurrency", typeof(string));
        dt_mtr.Columns.Add("CommissionAmount", typeof(decimal));
        dt_mtr.Columns.Add("CustomerChargeCurrency", typeof(string));
        dt_mtr.Columns.Add("CustomerChargeAmount", typeof(decimal));
        dt_mtr.Columns.Add("BeneID", typeof(string));
        dt_mtr.Columns.Add("BeneFirstName", typeof(string));
        dt_mtr.Columns.Add("BeneMiddleName", typeof(string));
        dt_mtr.Columns.Add("BeneLastName", typeof(string));
        dt_mtr.Columns.Add("BeneLastName2", typeof(string));

        dt_mtr.Columns.Add("BeneAddress", typeof(string));
        dt_mtr.Columns.Add("BeneCity", typeof(string));
        dt_mtr.Columns.Add("BeneState", typeof(string));
        dt_mtr.Columns.Add("BeneZipCode", typeof(string));
        dt_mtr.Columns.Add("BeneCountry", typeof(string));
        dt_mtr.Columns.Add("BenePhoneNo", typeof(string));
        dt_mtr.Columns.Add("BeneCellNo", typeof(string));
        dt_mtr.Columns.Add("BeneMessage", typeof(string));
        dt_mtr.Columns.Add("CustID", typeof(string));
        dt_mtr.Columns.Add("CustFirstName", typeof(string));
        dt_mtr.Columns.Add("CustMiddleName", typeof(string));
        dt_mtr.Columns.Add("CustLastName", typeof(string));
        dt_mtr.Columns.Add("CustLastName2", typeof(string));
        dt_mtr.Columns.Add("CustCountry", typeof(string));
        dt_mtr.Columns.Add("CustID1Type", typeof(string));

        dt_mtr.Columns.Add("CustID1No", typeof(string));
        dt_mtr.Columns.Add("CustID1IssuedBy", typeof(string));
        dt_mtr.Columns.Add("CustID1IssuedByState", typeof(string));
        dt_mtr.Columns.Add("CustID1IssuedByCountry", typeof(string));
        dt_mtr.Columns.Add("CustID1IssuedDate", typeof(DateTime));
        dt_mtr.Columns.Add("CustID1ExpirationDate", typeof(DateTime));//
        dt_mtr.Columns.Add("CustID2Type", typeof(string));
        dt_mtr.Columns.Add("CustID2No", typeof(string));
        dt_mtr.Columns.Add("CustID2IssuedBy", typeof(string));
        dt_mtr.Columns.Add("CustID2IssuedByState", typeof(string));
        dt_mtr.Columns.Add("CustID2IssuedByCountry", typeof(string));
        dt_mtr.Columns.Add("CustID2IssuedDate", typeof(DateTime));
        dt_mtr.Columns.Add("CustID2ExpirationDate", typeof(DateTime));
        dt_mtr.Columns.Add("CustTaxID", typeof(string));
        dt_mtr.Columns.Add("CustTaxCountry", typeof(string));

        dt_mtr.Columns.Add("CustCountryOfBirth", typeof(string));
        dt_mtr.Columns.Add("CustNationality", typeof(string));
        dt_mtr.Columns.Add("CustDateOfBirth", typeof(DateTime));
        dt_mtr.Columns.Add("CustOccupation", typeof(string));
        dt_mtr.Columns.Add("CustSourceOfFunds", typeof(string));
        dt_mtr.Columns.Add("CustPaymentMethod", typeof(string));
        dt_mtr.Columns.Add("CustBeneRelationship", typeof(string));
        dt_mtr.Columns.Add("TransferReason", typeof(string));
        dt_mtr.Columns.Add("BankName", typeof(string));
        dt_mtr.Columns.Add("BankAccountType", typeof(string));
        dt_mtr.Columns.Add("BankAccountNo", typeof(string));
        dt_mtr.Columns.Add("BeneIDType", typeof(string));
        dt_mtr.Columns.Add("BeneIDNo", typeof(string));
        dt_mtr.Columns.Add("BeneTaxID", typeof(string));
        dt_mtr.Columns.Add("BankCity", typeof(string));

        dt_mtr.Columns.Add("BankBranchNo", typeof(string));
        dt_mtr.Columns.Add("BankBranchName", typeof(string));
        dt_mtr.Columns.Add("BankBranchAddress", typeof(string));
        dt_mtr.Columns.Add("BankCode", typeof(string));
        dt_mtr.Columns.Add("BankRoutingCode", typeof(string));
        dt_mtr.Columns.Add("BankRoutingType", typeof(string));
        dt_mtr.Columns.Add("SWIFT", typeof(string));
        dt_mtr.Columns.Add("UnitaryBankAccountNo", typeof(string));
        dt_mtr.Columns.Add("UnitaryType", typeof(string));
        dt_mtr.Columns.Add("Valuetype", typeof(string));
        dt_mtr.Columns.Add("MobileWalletPrefix", typeof(string));
        dt_mtr.Columns.Add("MobileWalletAccountNo", typeof(string));
        dt_mtr.Columns.Add("RequestDate", typeof(DateTime));
        dt_mtr.Columns.Add("ResponseDateUTC", typeof(DateTime));
        dt_mtr.Columns.Add("InsertBy", typeof(string));

        dt_mtr.Columns.Add("InsertDT", typeof(DateTime));
        dt_mtr.Columns.Add("Status", typeof(int));

        string BankRoutingType = "";
        string Swift = "";
        string UnitaryType = "";
        string SaleDate = "19900101000000";
        string SendingCorrespSeqID = null;
        string PayingCorrespSeqID = null;
        string CountryFrom = null;
        string CountryTo = null;
        string PayingCorrespLocID = null;
        string SendingCorrespBranchNo = null;
        string BeneQuestion = null;
        string BeneAnswer = null;
        string PmtInstructions = null;
        string BeneficiaryCurrency = null;
        decimal? BeneficiaryAmount = null;
        string DeliveryMethod = null;
        string PaymentCurrency = null;
        decimal? PaymentAmount = null;
        string CommissionCurrency = null;
        decimal? CommissionAmount = null;
        string CustomerChargeCurrency = null;
        decimal? CustomerChargeAmount = null;
        string BeneID = null;
        string BeneFirstName = null;
        string BeneMiddleName = null;
        string BeneLastName = null;
        string BeneLastName2 = null;
        string BeneAddress = null;
        string BeneCity = null;
        string BeneState = null;
        string BeneZipCode = null;
        string BeneCountry = null;
        string BenePhoneNo = null;
        string BeneCellNo = null;
        string BeneMessage = null;
        string CustID = null;
        string CustFirstName = null;
        string CustMiddleName = null;
        string CustLastName = null;
        string CustLastName2 = null;
        string CustCountry = null;
        string CustID1Type = null;
        string CustID1No = null;
        string CustID1IssuedBy = null;
        string CustID1IssuedByState = null;
        string CustID1IssuedByCountry = null;
        DateTime? CustID1IssuedDate = null;
        DateTime? CustID1ExpirationDate = null;
        string CustID2Type = null;
        string CustID2No = null;
        string CustID2IssuedBy = null;
        string CustID2IssuedByState = null;
        string CustID2IssuedByCountry = null;
        DateTime? CustID2IssuedDate = null;
        DateTime? CustID2ExpirationDate = null;
        string CustTaxID = null;
        string CustTaxCountry = null;
        string CustCountryOfBirth = null;
        string CustNationality = null;
        DateTime? CustDateOfBirth = null;
        string CustOccupation = null;
        string CustSourceOfFunds = null;
        string CustPaymentMethod = null;
        string CustBeneRelationship = null;
        string TransferReason = null;
        string BankName = null;
        string BankAccountType = null;
        string BankAccountNo = null;
        string BeneIDType = null;
        string BeneIDNo = null;
        string BeneTaxID = null;
        string BankCity = null;
        string BankBranchNo = null;
        string BankBranchName = null;
        string BankBranchAddress = null;
        string BankCode = null;
        string BankRoutingCode = null;
        string UnitaryBankAccountNo = null;
        string Valuetype = null;
        string MobileWalletPrefix = null;
        string MobileWalletAccountNo = null;


        try
        {
            int PCOrderNOCount = dtOrder.Rows.Count;

            long PCOrderNo = GetRemittanceSequence("Ria API", PCOrderNOCount);

            foreach (DataRow row in dtOrder.Rows)
            {
                PCOrderNo++;
                //try
                //{
                //    BankRoutingType = row["BankRoutingType"].ToString();
                //}
                //catch(Exception ex)
                //{
                //    Common.WriteLog(RefIDDownload, "Ria API", "RiaOrderDownload", ex.Message);
                //}
                try
                {
                    Swift = row["BIC_SWIFT"].ToString();
                }
                catch (Exception ex)
                { }
                try
                {


                    //  UnitaryType = row["UnitaryType"].ToString();
                    string Sales_Date = row["SalesDate"].ToString();
                    string Sales_Time = row["SalesTime"].ToString() == "" ? "000000" : row["SalesTime"].ToString();

                    SaleDate = Sales_Date + Sales_Time;
                }
                catch (Exception ex)
                {
                    SaleDate = "19900101000000";
                    Common.WriteLog(RefIDDownload, "Ria API", "RiaOrderDownload", ex.Message);

                }
                try
                {
                    SendingCorrespSeqID = string.Format("{0}", row["SendingCorrespSeqID"]);
                }
                catch (Exception ex) { }
                try { PayingCorrespSeqID = string.Format("{0}", row["PayingCorrespSeqID"]); }
                catch (Exception ex) { }
                try { CountryFrom = string.Format("{0}", row["CountryFrom"]); }
                catch (Exception ex) { }
                try { CountryTo = string.Format("{0}", row["CountryTo"]); }
                catch (Exception ex) { }
                try { PayingCorrespLocID = string.Format("{0}", row["PayingCorrespLocID"]); }
                catch (Exception ex) { }
                try { SendingCorrespBranchNo = string.Format("{0}", row["SendingCorrespBranchNo"]); }
                catch (Exception ex) { }
                try { BeneQuestion = string.Format("{0}", row["BeneQuestion"]); }
                catch (Exception ex) { }
                try { BeneAnswer = string.Format("{0}", row["BeneAnswer"]); }
                catch (Exception ex) { }
                try { PmtInstructions = string.Format("{0}", row["PmtInstructions"]); }
                catch (Exception ex) { }
                try { BeneficiaryCurrency = string.Format("{0}", row["BeneficiaryCurrency"]); }
                catch (Exception ex) { }
                try { BeneficiaryAmount = decimal.Parse(string.Format("{0}", row["BeneficiaryAmount"])); }
                catch (Exception ex) { }
                try { DeliveryMethod = string.Format("{0}", row["DeliveryMethod"]); }
                catch (Exception ex) { }
                try { PaymentCurrency = string.Format("{0}", row["PaymentCurrency"]); }
                catch (Exception ex) { }
                try { PaymentAmount = decimal.Parse(string.Format("{0}", row["PaymentAmount"])); }
                catch (Exception ex) { }
                try { CommissionCurrency = string.Format("{0}", row["CommissionCurrency"]); }
                catch (Exception ex) { }
                try { CommissionAmount = decimal.Parse(string.Format("{0}", row["CommissionAmount"])); }
                catch (Exception ex) { }
                try { CustomerChargeCurrency = string.Format("{0}", row["CustomerChargeCurrency"]); }
                catch (Exception ex) { }
                try { CustomerChargeAmount = decimal.Parse(string.Format("{0}", row["CustomerChargeAmount"])); }
                catch (Exception ex) { }
                try { BeneID = string.Format("{0}", row["BeneID"]); }
                catch (Exception ex) { }
                try { BeneFirstName = string.Format("{0}", row["BeneFirstName"]); }
                catch (Exception ex) { }
                try { BeneMiddleName = string.Format("{0}", row["BeneMiddleName"]); }
                catch (Exception ex) { }
                try { BeneLastName = string.Format("{0}", row["BeneLastName"]); }
                catch (Exception ex) { }
                try { BeneLastName2 = string.Format("{0}", row["BeneLastName2"]); }
                catch (Exception ex) { }
                try { BeneAddress = string.Format("{0}", row["BeneAddress"]); }
                catch (Exception ex) { }
                try { BeneCity = string.Format("{0}", row["BeneCity"]); }
                catch (Exception ex) { }
                try { BeneState = string.Format("{0}", row["BeneState"]); }
                catch (Exception ex) { }
                try { BeneZipCode = string.Format("{0}", row["BeneZipCode"]); }
                catch (Exception ex) { }
                try { BeneCountry = string.Format("{0}", row["BeneCountry"]); }
                catch (Exception ex) { }
                try { BenePhoneNo = string.Format("{0}", row["BenePhoneNo"]); }
                catch (Exception ex) { }
                try { BeneCellNo = string.Format("{0}", row["BeneCellNo"]); }
                catch (Exception ex) { }
                try { BeneMessage = string.Format("{0}", row["BeneMessage"]); }
                catch (Exception ex) { }
                try { CustID = string.Format("{0}", row["CustID"]); }
                catch (Exception ex) { }
                try { CustFirstName = string.Format("{0}", row["CustFirstName"]); }
                catch (Exception ex) { }
                try { CustMiddleName = string.Format("{0}", row["CustMiddleName"]); }
                catch (Exception ex) { }
                try { CustLastName = string.Format("{0}", row["CustLastName"]); }
                catch (Exception ex) { }
                try { CustLastName2 = string.Format("{0}", row["CustLastName2"]); }
                catch (Exception ex) { }
                try { CustCountry = string.Format("{0}", row["CustCountry"]); }
                catch (Exception ex) { }
                try { CustID1Type = string.Format("{0}", row["CustID1Type"]); }
                catch (Exception ex) { }
                try { CustID1No = string.Format("{0}", row["CustID1No"]); }
                catch (Exception ex) { }
                try { CustID1IssuedBy = string.Format("{0}", row["CustID1IssuedBy"]); }
                catch (Exception ex) { }
                try { CustID1IssuedByState = string.Format("{0}", row["CustID1IssuedByState"]); }
                catch (Exception ex) { }
                try { CustID1IssuedByCountry = string.Format("{0}", row["CustID1IssuedByCountry"]); }
                catch (Exception ex) { }
                try { CustID1IssuedDate = DateTime.ParseExact(string.Format("{0}", row["CustID1IssuedDate"]), "yyyyMMdd", CultureInfo.InvariantCulture); }
                catch (Exception ex) { }
                try { CustID1ExpirationDate = DateTime.ParseExact(string.Format("{0}", row["CustID1ExpirationDate"]), "yyyyMMdd", CultureInfo.InvariantCulture); }
                catch (Exception ex) { }
                try { CustID2Type = string.Format("{0}", row["CustID2Type"]); }
                catch (Exception ex) { }
                try { CustID2No = string.Format("{0}", row["CustID2No"]); }
                catch (Exception ex) { }
                try { CustID2IssuedBy = string.Format("{0}", row["CustID2IssuedBy"]); }
                catch (Exception ex) { }
                try { CustID2IssuedByState = string.Format("{0}", row["CustID2IssuedByState"]); }
                catch (Exception ex) { }
                try { CustID2IssuedByCountry = string.Format("{0}", row["CustID2IssuedByCountry"]); }
                catch (Exception ex) { }
                try { CustID2IssuedDate = DateTime.ParseExact(string.Format("{0}", row["CustID2IssuedDate"]), "yyyyMMdd", CultureInfo.InvariantCulture); }
                catch (Exception ex) { }
                try { CustID2ExpirationDate = DateTime.ParseExact(string.Format("{0}", row["CustID2ExpirationDate"]), "yyyyMMdd", CultureInfo.InvariantCulture); }
                catch (Exception ex) { }
                try { CustTaxID = row["CustTaxID"].ToString(); }
                catch (Exception ex) { }
                try { CustTaxCountry = row["CustTaxCountry"].ToString(); }
                catch (Exception ex) { }
                try { CustCountryOfBirth = row["CustCountryOfBirth"].ToString(); }
                catch (Exception ex) { }
                try { CustNationality = string.Format("{0}", row["CustNationality"]); }
                catch (Exception ex) { }
                try { CustDateOfBirth = DateTime.ParseExact(string.Format("{0}", row["CustDateOfBirth"]), "yyyyMMdd", CultureInfo.InvariantCulture); }
                catch (Exception ex) { }
                try { CustOccupation = string.Format("{0}", row["CustOccupation"]); }
                catch (Exception ex) { }
                try { CustSourceOfFunds = string.Format("{0}", row["CustSourceOfFunds"]); }
                catch (Exception ex) { }
                try { CustPaymentMethod = string.Format("{0}", row["CustPaymentMethod"]); }
                catch (Exception ex) { }
                try { CustBeneRelationship = string.Format("{0}", row["CustBeneRelationship"]); }
                catch (Exception ex) { }
                try { TransferReason = string.Format("{0}", row["TransferReason"]); }
                catch (Exception ex) { }
                try { BankName = string.Format("{0}", row["BankName"]); }
                catch (Exception ex) { }
                try { BankAccountType = string.Format("{0}", row["BankAccountType"]); }
                catch (Exception ex) { }
                try { BankAccountNo = string.Format("{0}", row["BankAccountNo"]); }
                catch (Exception ex) { }
                try { BeneIDType = string.Format("{0}", row["BeneIDType"]); }
                catch (Exception ex) { }
                try { BeneIDNo = string.Format("{0}", row["BeneIDNo"]); }
                catch (Exception ex) { }
                try { BeneTaxID = string.Format("{0}", row["BeneTaxID"]); }
                catch (Exception ex) { }
                try { BankCity = string.Format("{0}", row["BankCity"]); }
                catch (Exception ex) { }
                try { BankBranchNo = string.Format("{0}", row["BankBranchNo"]); }
                catch (Exception ex) { }
                try { BankBranchName = string.Format("{0}", row["BankBranchName"]); }
                catch (Exception ex) { }
                try { BankBranchAddress = string.Format("{0}", row["BankBranchAddress"]); }
                catch (Exception ex) { }
                try { BankCode = string.Format("{0}", row["BankCode"]); }
                catch (Exception ex) { }
                try { BankRoutingCode = string.Format("{0}", row["BankRoutingCode"]); }
                catch (Exception ex) { }
                try { UnitaryBankAccountNo = string.Format("{0}", row["UnitaryBankAccountNo"]); }
                catch (Exception ex) { }
                try { Valuetype = string.Format("{0}", row["Valuetype"]); }
                catch (Exception ex) { }
                try { MobileWalletPrefix = string.Format("{0}", row["MobileWalletPrefix"]); }
                catch (Exception ex) { }
                try { MobileWalletAccountNo = string.Format("{0}", row["MobileWalletAccountNo"]); }
                catch (Exception ex) { }

                dt_mtr.Rows.Add(NotificationID, RefIDDownload, null, RequestType, string.Format("{0}", row["OrderNo"]), PCOrderNo.ToString(), string.Format("{0}", row["Pin"]), SendingCorrespSeqID, PayingCorrespSeqID, DateTime.ParseExact(SaleDate, "yyyyMMddHHmmss", CultureInfo.InvariantCulture),
                    CountryFrom, CountryTo, PayingCorrespLocID, SendingCorrespBranchNo, BeneQuestion, BeneAnswer, PmtInstructions//14
                    , BeneficiaryCurrency, BeneficiaryAmount, DeliveryMethod, PaymentCurrency, PaymentAmount
                     , CommissionCurrency, CommissionAmount, CustomerChargeCurrency, CustomerChargeAmount,//10
                    BeneID, BeneFirstName, BeneMiddleName, BeneLastName
                   , BeneLastName2, BeneAddress, BeneCity, BeneState, BeneZipCode,
                    BeneCountry, BenePhoneNo, BeneCellNo, BeneMessage, CustID, CustFirstName, CustMiddleName, CustLastName,
                    CustLastName2, CustCountry, CustID1Type, CustID1No
                     , CustID1IssuedBy, CustID1IssuedByState, CustID1IssuedByCountry,
                     CustID1IssuedDate, CustID1ExpirationDate,
                     CustID2Type,
                     CustID2No, CustID2IssuedBy, CustID2IssuedByState, CustID2IssuedByCountry, CustID2IssuedDate,
                    CustID2ExpirationDate, CustTaxID, CustTaxCountry, CustCountryOfBirth, CustNationality,
                    CustDateOfBirth, CustOccupation, CustSourceOfFunds, CustPaymentMethod, CustBeneRelationship,
                   TransferReason, BankName, BankAccountType, BankAccountNo, BeneIDType, BeneIDNo, BeneTaxID, BankCity,
                    BankBranchNo, BankBranchName, BankBranchAddress, BankCode, BankRoutingCode,
                     BankRoutingType, Swift,
                      UnitaryBankAccountNo, UnitaryType, Valuetype, MobileWalletPrefix, MobileWalletAccountNo,
                     CallDateTime, ResponseDateTimeUTC, EmpID, DateTime.Now, 0);
                //}
                //catch(Exception ex)
                //{
                //    Common.WriteLog(RefIDDownload, "Ria API", "RiaOrderDownload", ex.Message);
                //}

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
                        bulkCopy.DestinationTableName = "Ria_OrderDownload";
                        bulkCopy.WriteToServer(dt_mtr);
                    }

                }
                IsSave = 1;
            }

        }
        catch (Exception ex)
        {
            IsSave = 2;
            Common.WriteLog(RefIDDownload, "Ria API", "RiaOrderDownload", ex.Message);
        }
        return IsSave;
    }

    [WebMethod(Description = "Service Task: Bank Deposit Cancelation Requests Download"
      + "<br>" + "Returns:"
      + "<br>" + "1: " + "Success"
              + "<br>" + "2: " + "Cancel Order not Found."
     + "<br>" + "-2: " + "Invalid Key Code"
    + "<br>" + "-3: " + "Local Database Down"
    + "<br>" + "4: " + "Default Fail"
      )]
    public string BD_GetCancelationRequests(
        string BranchCode,
        string BranchName,
        string EmpID,
        string KeyCode
      )
    {
        if (KeyCode != getValueOfKey("Ria_KeyCode"))
            return "-2";
        if (!CheckConnection())
            return "-3";
        string CallRefID = Guid.NewGuid().ToString();
        XmlDocument SOAPReqBody = new XmlDocument();
        DateTime CallDateTime = DateTime.Now;
        DateTime DatetimeUtc = DateTime.UtcNow;
        string response_node = "";
        string MethodCalled = "";

        int SaveDone = 4;

        try
        {
            SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>
            <Root>" + GetRiaHeader(CallRefID, CallDateTime, BranchCode, EmpID, DatetimeUtc, BranchName) +

      "<RequestType>" + "CancelationRequests" + @"</RequestType>
		     
         	</Root>");

            //
            //string node = "<ResponseLayoutVersion>2.0</ResponseLayoutVersion><Header><MethodCalled>GetCancellationRequests</MethodCalled>" +
            //        "<CallID_Ext>17eb5cc2-3770-43cc-81f8-72c4e3e2699e</CallID_Ext><ResponseDateTimeUTC>20181008121021</ResponseDateTimeUTC></Header>" +
            //        "<RequestType>CancelationRequests</RequestType><RequestResponses><CancelationRequest><SCOrderNo>JP1924193255</SCOrderNo></CancelationRequest>" +
            //        "<CancelationRequest><SCOrderNo>JP1924193355</SCOrderNo></CancelationRequest><CancelationRequest><SCOrderNo>JP1924193455</SCOrderNo></CancelationRequest></RequestResponses><RequestErrors />";
            //SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>
            //<Root>" + node + "</Root>");
            //XmlReader xmlReader = new XmlNodeReader(SOAPReqBody);
            // End string

            RiaFxGlobalWebReferance.FXGlobalSending FxObject = new RiaFxGlobalWebReferance.FXGlobalSending();
            XmlNode nodeObj = FxObject.GetCancellationRequests(SOAPReqBody);
            response_node = nodeObj.InnerXml;
            DataTable dtRoot = new DataTable();
            DataTable dtHeader = new DataTable();
            DataTable dtOrderResponse = new DataTable();

            XmlReader xmlReader = new XmlNodeReader(nodeObj);
            DataSet ds = new DataSet();
            ds.ReadXml(xmlReader);
            dtRoot = ds.Tables["Root"];
            dtHeader = ds.Tables["Header"];
            dtOrderResponse = ds.Tables["CancelationRequest"];

            DateTime ResponseDateTimeUTC = DateTime.ParseExact(dtHeader.Rows[0]["ResponseDateTimeUTC"].ToString(), "yyyyMMddHHmmss", CultureInfo.InvariantCulture);

            if (dtOrderResponse != null)
                SaveDone = SaveBulkCancelRequestData(dtOrderResponse, CallRefID, ResponseDateTimeUTC, EmpID);
            else
                SaveDone = 5;
        }
        catch (Exception ex)
        {
            SaveDone = 3;
            Common.WriteLog(CallRefID, "Ria API", "BD_GetCancelationRequests", ex.Message);
        }
        finally
        {
            SaveReqResponseData("Ria API",CallRefID, "CancelationRequests", CallDateTime, SOAPReqBody.InnerXml, response_node, SaveDone.ToString(), SaveDone.ToString());
        }
        return SaveDone.ToString();
    }

    private int SaveBulkCancelRequestData(DataTable dtOrderCancel, string RefIDCancel, DateTime ResponseDateTimeUTC, string EmpID)
    {
        int IsSave = 0;
        DataTable dt_mtr = new DataTable();
        dt_mtr.Columns.Add("ExHouseCode", typeof(string));
        dt_mtr.Columns.Add("RefCallID", typeof(string));
        dt_mtr.Columns.Add("OrderNo", typeof(string));
        dt_mtr.Columns.Add("RID", typeof(long));
        dt_mtr.Columns.Add("CancelPendingStatus", typeof(string));
        dt_mtr.Columns.Add("ResponseDTUtc", typeof(DateTime));
        dt_mtr.Columns.Add("InputOrderStatus", typeof(string));
        dt_mtr.Columns.Add("InsertBy", typeof(string));
        dt_mtr.Columns.Add("InsertDT", typeof(DateTime));
        dt_mtr.Columns.Add("UpdateDT", typeof(DateTime));

        try
        {

            foreach (DataRow row in dtOrderCancel.Rows)
            {

                dt_mtr.Rows.Add("Ria API", RefIDCancel, row["SCOrderNo"].ToString(), null, "New", ResponseDateTimeUTC, null, EmpID, DateTime.Now, null);

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
                        bulkCopy.DestinationTableName = "FxCancelPendingList";
                        bulkCopy.WriteToServer(dt_mtr);
                    }

                }
                IsSave = 1;
            }

        }
        catch (Exception ex)
        {
            IsSave = 2;
            Common.WriteLog(RefIDCancel, "Ria API", "FxCancelPendingList", ex.Message);
        }
        return IsSave;
    }

    [WebMethod(Description = "Service Task: Cancel Accepted/Rejected Request  against Remittance ID"
    + "<br>" + "Returns:"
    + "<br>" + "1: " + "Success"
    + "<br>" + "ResponseTypeCode 1000: " + "Cancel"
    + "<br>" + "-2: " + "Invalid Key Code"
    + "<br>" + "-3: " + "Local Database Down"
    + "<br>" + "4: " + "Default Fail"
    )]
    public string BD_InputCancelRequestResponses(
    long RID,
    string ResponseTypeCode,
    string Comment,
    string BranchCode,
    string BranchName,
    string EmpID,
    string KeyCode
    )
    {
        if (KeyCode != getValueOfKey("Ria_KeyCode"))
            return "-2";
        if (!CheckConnection())
            return "-3";
        string CallRefID = Guid.NewGuid().ToString();
        XmlDocument SOAPReqBody = new XmlDocument();
        DateTime CallDateTime = DateTime.Now;
        DateTime DatetimeUtc = DateTime.UtcNow;
        string response_node = "";
        string MethodCalled = "";

        int SaveDone = 4;
        string DoneNoticeCancel = "";

        try
        {
            SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>
            <Root>" + GetRiaHeader(CallRefID, CallDateTime, BranchCode, EmpID, DatetimeUtc, Common.XmlText(BranchName)) +

   GetInputCancelRequestData(RID, ResponseTypeCode,Common.XmlText(Comment) ) +

             @"</Root>");
            // start
            //string node = "<ResponseLayoutVersion>2.0</ResponseLayoutVersion>" +
            //"<Header>" +
            //    "<MethodCalled>InputCancelRequestResponses</MethodCalled>" +
            //    "<CallID_Ext>d8a116e4-6d5f-4d8b-8083-64927b325b8b</CallID_Ext>" +
            //    "<ResponseDateTimeUTC>20181009081913</ResponseDateTimeUTC>" +
            //"</Header>" +
            //"<InputType>CancelRequestResponses</InputType>" +
            //"<ItemsProcessed>1</ItemsProcessed>" +
            //"<Acknowledgements>" +
            //    "<CancelRequestResponseAcknowledgement>" +
            //        "<PCOrderNo>65</PCOrderNo>" +
            //        "<SCOrderNo>JP1924193255</SCOrderNo>" +
            //        "<ProcessDate>20181009</ProcessDate>" +
            //        "<ProcessTime>011913</ProcessTime>" +
            //        "<NotificationCode>1000</NotificationCode>" +
            //        "<NotificationDesc>Success</NotificationDesc>" +
            //    "</CancelRequestResponseAcknowledgement>" +
            //"</Acknowledgements>" +
            //"<InputErrors />";
            //SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>
            //<Root>" + node + "</Root>");
            //XmlReader xmlReader = new XmlNodeReader(SOAPReqBody);
            // End string

            RiaFxGlobalWebReferance.FXGlobalSending FxObject = new RiaFxGlobalWebReferance.FXGlobalSending();
            XmlNode nodeObj = FxObject.InputCancelRequestResponses(SOAPReqBody);
            response_node = nodeObj.InnerXml;
            DataTable dtRoot = new DataTable();
            DataTable dtHeader = new DataTable();
            DataTable dtOrderResponse = new DataTable();

            XmlReader xmlReader = new XmlNodeReader(nodeObj);
            DataSet ds = new DataSet();
            ds.ReadXml(xmlReader);
            dtRoot = ds.Tables["Root"];
            dtHeader = ds.Tables["Header"];
            dtOrderResponse = ds.Tables["CancelRequestResponseAcknowledgement"];

            DateTime ResponseDateTimeUTC = DateTime.ParseExact(dtHeader.Rows[0]["ResponseDateTimeUTC"].ToString(), "yyyyMMddHHmmss", CultureInfo.InvariantCulture);

            if (dtOrderResponse != null)
            {
                SaveDone = UpdateCancelRequestResponse(RID, dtOrderResponse, CallRefID, ResponseDateTimeUTC, EmpID, ResponseTypeCode, Comment);
                if (ResponseTypeCode == "1000" && dtOrderResponse.Rows[0]["NotificationCode"].ToString() == "1000")
                    DoneNoticeCancel = BD_InputOrderStatusNoticesCancelToRia(BranchCode, BranchName, RID, EmpID, "CANCELED",Comment ,KeyCode);
            }
            if (ResponseTypeCode == "1000")
            {
                if (SaveDone == 1 & DoneNoticeCancel == "1")
                    SaveDone = 1;
                else
                    SaveDone = 11;
            }
            //else
            //{
            //    if (SaveDone == 1 )
            //        SaveDone = 1;
            //    else
            //        SaveDone = 10;
            //}

            //if (SaveDone == 1 & DoneNoticeCancel == "1")
            //    SaveDone = 1;
            //else
            //    return SaveDone.ToString() + "|" + DoneNoticeCancel;
        }
        catch (Exception ex)
        {
            SaveDone = 3;
            Common.WriteLog(CallRefID, "Ria API", "BD_InputCancelRequestResponses", ex.Message);
        }
        finally
        {
            SaveReqResponseData("Ria API",CallRefID, "InputCancelRequestResponses", CallDateTime, SOAPReqBody.InnerXml, response_node, SaveDone.ToString(), DoneNoticeCancel);
        }
        return SaveDone.ToString();
    }

    [WebMethod(Description = "Service Task: Cancel Accepted/Rejected Request  against Order ID"
 + "<br>" + "Returns:"
 + "<br>" + "1: " + "Success"
 + "<br>" + "ResponseTypeCode 1000: " + "Cancel"
 + "<br>" + "-2: " + "Invalid Key Code"
 + "<br>" + "-3: " + "Local Database Down"
 + "<br>" + "4: " + "Default Fail"
 )]
    public string BD_InputCancelRequestResponsesOrderWise(
 string OrderID,
 string ResponseTypeCode,
 string Comment,
 string BranchCode,
 string BranchName,
 string EmpID,
 string KeyCode
 )
    {
        if (KeyCode != getValueOfKey("Ria_KeyCode"))
            return "-2";
        if (!CheckConnection())
            return "-3";
        string CallRefID = Guid.NewGuid().ToString();
        XmlDocument SOAPReqBody = new XmlDocument();
        DateTime CallDateTime = DateTime.Now;
        DateTime DatetimeUtc = DateTime.UtcNow;
        string response_node = "";
        string MethodCalled = "";

        int SaveDone = 4;
        string DoneNoticeCancel = "";

        try
        {
            SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>
            <Root>" + GetRiaHeader(CallRefID, CallDateTime, BranchCode, EmpID, DatetimeUtc, Common.XmlText(BranchName)) +

             GetInputCancelRequestDataOrderWise(OrderID, ResponseTypeCode,Common.XmlText(Comment) ) +

             @"</Root>");

            RiaFxGlobalWebReferance.FXGlobalSending FxObject = new RiaFxGlobalWebReferance.FXGlobalSending();
            XmlNode nodeObj = FxObject.InputCancelRequestResponses(SOAPReqBody);
            response_node = nodeObj.InnerXml;
            DataTable dtRoot = new DataTable();
            DataTable dtHeader = new DataTable();
            DataTable dtOrderResponse = new DataTable();

            XmlReader xmlReader = new XmlNodeReader(nodeObj);
            DataSet ds = new DataSet();
            ds.ReadXml(xmlReader);
            dtRoot = ds.Tables["Root"];
            dtHeader = ds.Tables["Header"];
            dtOrderResponse = ds.Tables["CancelRequestResponseAcknowledgement"];

            DateTime ResponseDateTimeUTC = DateTime.ParseExact(dtHeader.Rows[0]["ResponseDateTimeUTC"].ToString(), "yyyyMMddHHmmss", CultureInfo.InvariantCulture);

            if (dtOrderResponse != null)
            {
                SaveDone = UpdateCancelRequestResponseOrderIDWise(OrderID, dtOrderResponse, CallRefID, ResponseDateTimeUTC, EmpID, ResponseTypeCode, Comment);
                //if (ResponseTypeCode == "1000" && dtOrderResponse.Rows[0]["NotificationCode"].ToString() == "1000")
                //    DoneNoticeCancel = BD_InputOrderStatusNoticesCancelToRia(BranchCode, BranchName, RID, EmpID, "CANCELED",Comment ,KeyCode);
            }
            //if (ResponseTypeCode == "1000")
            //{
            //    if (SaveDone == 1 & DoneNoticeCancel == "1")
            //        SaveDone = 1;
            //    else
            //        SaveDone = 11;
            //}

        }
        catch (Exception ex)
        {
            SaveDone = 3;
            Common.WriteLog(CallRefID, "Ria API", "BD_InputCancelRequestResponses", ex.Message);
        }
        finally
        {
            SaveReqResponseData("Ria API",CallRefID, "InputCancelRequestResponses", CallDateTime, SOAPReqBody.InnerXml, response_node, SaveDone.ToString(), DoneNoticeCancel);
        }
        return SaveDone.ToString();
    }

    private int UpdateCancelRequestResponse(long RID, DataTable dtOrderResponse, string RefCallID, DateTime ResponseDateTimeUTC, string EmpID, string ReqTypeCode, string Comment)
    {
        int done = 2;
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Ria_UpdateInputCancelRequestData";//*** cancel request order
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ExHouseCode", System.Data.SqlDbType.VarChar).Value = "Ria API";
                    cmd.Parameters.Add("@RefCallID", System.Data.SqlDbType.VarChar).Value = RefCallID;
                    cmd.Parameters.Add("@RID", System.Data.SqlDbType.BigInt).Value = RID;
                    cmd.Parameters.Add("@DTUtc", System.Data.SqlDbType.DateTime).Value = ResponseDateTimeUTC;
                    cmd.Parameters.Add("@PCOrderNo", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["PCOrderNo"].ToString();
                    cmd.Parameters.Add("@SCOrderNo", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["SCOrderNo"].ToString();
                    cmd.Parameters.Add("@CancelTypeCode", System.Data.SqlDbType.VarChar).Value = ReqTypeCode;
                    cmd.Parameters.Add("@ResponseCode", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["NotificationCode"].ToString();
                    cmd.Parameters.Add("@ResponseDesc", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["NotificationDesc"].ToString();
                    cmd.Parameters.Add("@ProcessDT", System.Data.SqlDbType.DateTime).Value = DateTime.ParseExact(dtOrderResponse.Rows[0]["ProcessDate"].ToString() + dtOrderResponse.Rows[0]["ProcessTime"].ToString(), "yyyyMMddHHmmss", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("@Comments", System.Data.SqlDbType.VarChar).Value = Comment;
                    cmd.Parameters.Add("@InsertBy", System.Data.SqlDbType.VarChar).Value = EmpID;
                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Int);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = 0;
                    cmd.Parameters.Add(sqlDone);
                    cmd.Connection = conn;
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    done = (int)sqlDone.Value;

                }

            }

        }
        catch (Exception ex)
        {
            Common.WriteLog(RefCallID, "Ria API", "s_Ria_UpdateInputCancelRequestData", ex.Message);
        }

        return done;

    }

    private int UpdateCancelRequestResponseOrderIDWise(string OrderNo, DataTable dtOrderResponse, string RefCallID, DateTime ResponseDateTimeUTC, string EmpID, string ReqTypeCode, string Comment)
    {
        int done = 2;
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Ria_UpdateInputCancelRequestOrderWise";//*** reject request order
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ExHouseCode", System.Data.SqlDbType.VarChar).Value = "Ria API";
                    cmd.Parameters.Add("@RefCallID", System.Data.SqlDbType.VarChar).Value = RefCallID;
                    //  cmd.Parameters.Add("@RID", System.Data.SqlDbType.BigInt).Value = RID;
                    cmd.Parameters.Add("@DTUtc", System.Data.SqlDbType.DateTime).Value = ResponseDateTimeUTC;
                    cmd.Parameters.Add("@PCOrderNo", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["PCOrderNo"].ToString();
                    cmd.Parameters.Add("@SCOrderNo", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["SCOrderNo"].ToString();
                    cmd.Parameters.Add("@CancelTypeCode", System.Data.SqlDbType.VarChar).Value = ReqTypeCode;
                    cmd.Parameters.Add("@ResponseCode", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["NotificationCode"].ToString();
                    cmd.Parameters.Add("@ResponseDesc", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["NotificationDesc"].ToString();
                    cmd.Parameters.Add("@ProcessDT", System.Data.SqlDbType.DateTime).Value = DateTime.ParseExact(dtOrderResponse.Rows[0]["ProcessDate"].ToString() + dtOrderResponse.Rows[0]["ProcessTime"].ToString(), "yyyyMMddHHmmss", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("@Comments", System.Data.SqlDbType.VarChar).Value = Comment;
                    cmd.Parameters.Add("@InsertBy", System.Data.SqlDbType.VarChar).Value = EmpID;
                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Int);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = 0;
                    cmd.Parameters.Add(sqlDone);
                    cmd.Connection = conn;
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    done = (int)sqlDone.Value;

                }

            }

        }
        catch (Exception ex)
        {
            Common.WriteLog(RefCallID, "Ria API", "s_Ria_UpdateInputCancelRequestOrderWise", ex.Message);
        }

        return done;

    }

    [WebMethod(Description = "Service Task: Input Order Status Notices Receive"
    + "<br>" + "Returns:"
    + "<br>" + "1: " + "Success"

    )]
    public string BD_InputOrderStatusNoticesReceive(
      string BranchCode,
      string BranchName,
      string Currency,
      string RefIdDownload,
      string EmpID,
      string KeyCode
    )
    {
        if (KeyCode != getValueOfKey("Ria_KeyCode"))
            return "-2";
        if (!CheckConnection())
            return "-3";
        string CallRefID = Guid.NewGuid().ToString();
        XmlDocument SOAPReqBody = new XmlDocument();
        DateTime CallDateTime = DateTime.Now;
        DateTime DatetimeUtc = DateTime.UtcNow;
        string response_node = "";
        string MethodCalled = "";

        int SaveDone = 4;

        try
        {
            SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>
            <Root>" + GetRiaHeader(CallRefID, CallDateTime, BranchCode, EmpID, DatetimeUtc, Common.XmlText(BranchName)) +
            GetInputStatusReceiveData(EmpID, Currency, RefIdDownload) +
             "</Root>");

            RiaFxGlobalWebReferance.FXGlobalSending FxObject = new RiaFxGlobalWebReferance.FXGlobalSending();

            XmlNode nodeObj = FxObject.InputOrderStatusNotices(SOAPReqBody);
            response_node = nodeObj.InnerXml;
            DataTable dtRoot = new DataTable();
            DataTable dtHeader = new DataTable();
            RiaDataSet.Ria_InputOrderStatusNoticesDataTable dtOrderAck = new RiaDataSet.Ria_InputOrderStatusNoticesDataTable();

            XmlReader xmlReader = new XmlNodeReader(nodeObj);
            DataSet ds = new DataSet();
            ds.ReadXml(xmlReader);
            dtRoot = ds.Tables["Root"];
            dtHeader = ds.Tables["Header"];

            DataTable TDOSNA = new DataTable();
            TDOSNA = ds.Tables["OrderStatusNoticeAcknowledgement"];
            if (TDOSNA != null)
            {
                for (int r = 0; r < TDOSNA.Rows.Count; r++)
                {
                    RiaDataSet.Ria_InputOrderStatusNoticesRow oRow = dtOrderAck.NewRia_InputOrderStatusNoticesRow();
                    //oRow.BatchNo = 1;
                    oRow.PCOrderNo = TDOSNA.Rows[r]["PCOrderNo"].ToString();
                    oRow.SCOrderNo = TDOSNA.Rows[r]["SCOrderNo"].ToString();
                    oRow.PCNotificationID = int.Parse(TDOSNA.Rows[r]["PCNotificationID"].ToString());
                    oRow.NotificationCode = TDOSNA.Rows[r]["NotificationCode"].ToString();
                    oRow.NotificationDesc = TDOSNA.Rows[r]["NotificationDesc"].ToString();
                    oRow.ProcessDate = DateTime.ParseExact(TDOSNA.Rows[r]["ProcessDate"].ToString() + TDOSNA.Rows[r]["ProcessTime"].ToString(), "yyyyMMddHHmmss", CultureInfo.InvariantCulture);

                    //oRow.ProcessDate = DateTime.Now;
                    dtOrderAck.Rows.Add(oRow);
                }

                //dtOrderAck = (RiaDataSet.Ria_InputOrderStatusNoticesDataTable)ds.Tables["OrderStatusNoticeAcknowledgement"];

                DateTime ResponseDateTimeUTC = DateTime.ParseExact(dtHeader.Rows[0]["ResponseDateTimeUTC"].ToString(), "yyyyMMddHHmmss", CultureInfo.InvariantCulture);

                if (dtOrderAck != null)
                    SaveDone = SaveInputOrderStatusNotice(dtOrderAck, CallRefID, CallDateTime, ResponseDateTimeUTC, EmpID, Currency);
            }
            else
            {
                SaveDone = 5;
            }
        }
        catch (Exception ex)
        {
            SaveDone = 3;
            Common.WriteLog(CallRefID, "Ria API", "InputOrderStatusNoticesReceive", ex.Message);
        }
        finally
        {
            SaveReqResponseData("Ria API",CallRefID, "InputOrderStatusNoticesReceive", CallDateTime, SOAPReqBody.InnerXml, response_node, SaveDone.ToString(), SaveDone.ToString());
        }
        return SaveDone.ToString();
    }

    private int SaveInputOrderStatusNotice(RiaDataSet.Ria_InputOrderStatusNoticesDataTable dtOrderAck, string CallRefID, DateTime CallDate, DateTime ResponseDateTimeUTC, string EmpID, string Currency)
    {
        int Done = 4;
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Ria_InputOrderStatusNoticesSave";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    //cmd.Parameters.AddWithValue("@TIOS", dtOrderAck);

                    //DataTable addedCategories = dtOrderAck.GetChanges(DataRowState.Added);  

                    SqlParameter sql_TIOS = new SqlParameter();
                    sql_TIOS.ParameterName = "@TIOS";
                    sql_TIOS.SqlDbType = SqlDbType.Structured;
                    sql_TIOS.TypeName = "dbo.Ria_InputOrderStatusNotices";
                    sql_TIOS.Value = dtOrderAck;
                    cmd.Parameters.Add(sql_TIOS);

                    cmd.Parameters.Add("@RefCall_ID", System.Data.SqlDbType.VarChar).Value = CallRefID;
                    cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = EmpID;
                    //cmd.Parameters.Add("@StartDT", System.Data.SqlDbType.DateTime).Value = CallDate;

                    cmd.Parameters.Add("@Currency", System.Data.SqlDbType.VarChar).Value = Currency;
                    cmd.Parameters.Add("@OrderStatusType", System.Data.SqlDbType.VarChar).Value = "RECEIVED";
                    //cmd.Parameters.Add("@ResponseCode", System.Data.SqlDbType.VarChar).Value = ResponseCode;
                    //cmd.Parameters.Add("@ResponseText", System.Data.SqlDbType.VarChar).Value = ResponseText;
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
            Done = 2;
            Common.WriteLog(CallRefID, "Ria API", "s_Ria_InputOrderStatusNoticesSave", ex.Message);
        }
        return Done;
    }

    private string GetInputCancelRequestData(long RID, string ResponseCode, string Comments)
    {
        string xml_order = "";
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Ria_GetInputCancelRequestData";//*** cancel request order
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@RID", System.Data.SqlDbType.BigInt).Value = RID;
                    cmd.Parameters.Add("@ResponseCode", System.Data.SqlDbType.VarChar).Value = ResponseCode;
                    cmd.Parameters.Add("@Comments", System.Data.SqlDbType.VarChar).Value = Comments;
                    SqlParameter sqlXml = new SqlParameter("@xml", SqlDbType.VarChar, -1);
                    sqlXml.Direction = ParameterDirection.InputOutput;
                    sqlXml.Value = "";
                    cmd.Parameters.Add(sqlXml);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    xml_order = sqlXml.Value.ToString();

                }

            }

        }
        catch (Exception ex)
        {
            Common.WriteLog("", "Ria API", "s_Ria_GetInputCancelRequestData", ex.Message);
        }

        return xml_order;

    }
    private string GetInputCancelRequestDataOrderWise(string OrderID, string ResponseCode, string Comments)
    {
        string xml_order = "";
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Ria_GetInputCancelRequestOrderWise";//*** cancel request order
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = OrderID;
                    cmd.Parameters.Add("@ResponseCode", System.Data.SqlDbType.VarChar).Value = ResponseCode;
                    cmd.Parameters.Add("@Comments", System.Data.SqlDbType.VarChar).Value = Comments;
                    SqlParameter sqlXml = new SqlParameter("@xml", SqlDbType.VarChar, -1);
                    sqlXml.Direction = ParameterDirection.InputOutput;
                    sqlXml.Value = "";
                    cmd.Parameters.Add(sqlXml);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    xml_order = sqlXml.Value.ToString();

                }

            }

        }
        catch (Exception ex)
        {
            Common.WriteLog("", "Ria API", "s_Ria_GetInputCancelRequestOrderWise", ex.Message);
        }

        return xml_order;

    }

    private string GetInputStatusReceiveData(string EmpID, string Currency, string RefIdDownload)
    {
        string xml_order = "";
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Ria_GetInputOrderStatusReceive";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = EmpID;
                    cmd.Parameters.Add("@Currecny", System.Data.SqlDbType.VarChar).Value = Currency;
                    cmd.Parameters.Add("@RefIdDownload", System.Data.SqlDbType.VarChar).Value = RefIdDownload;
                    SqlParameter sqlXml = new SqlParameter("@xml", SqlDbType.VarChar, -1);
                    sqlXml.Direction = ParameterDirection.InputOutput;
                    sqlXml.Value = "";
                    cmd.Parameters.Add(sqlXml);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    xml_order = sqlXml.Value.ToString();

                }

            }

        }
        catch (Exception ex)
        {
            Common.WriteLog("", "Ria API", "s_Ria_GetInputOrderStatusReceive", ex.Message);
        }

        return xml_order;

    }
    private string GetInputStatusNoticeUpdateData(string EmpID, int BatchNo)
    {
        string xml_order = "";
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Ria_GetInputOrderStatusPaid";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = EmpID;
                    cmd.Parameters.Add("@BatchNo", System.Data.SqlDbType.Int).Value = BatchNo;
                    cmd.Parameters.Add("@ExHouseCode", System.Data.SqlDbType.VarChar).Value = "Ria API";
                    SqlParameter sqlXml = new SqlParameter("@xml", SqlDbType.VarChar, -1);
                    sqlXml.Direction = ParameterDirection.InputOutput;
                    sqlXml.Value = "";
                    cmd.Parameters.Add(sqlXml);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    xml_order = sqlXml.Value.ToString();
                }

            }

        }
        catch (Exception ex)
        {
            Common.WriteLog(BatchNo.ToString(), "Ria API", "s_Ria_GetInputOrderStatusPaid", ex.Message);
        }

        return xml_order;

    }
    [WebMethod(Description = "Service Task: Input Order Status Notices For Paid mark to ria and publish mark to Remilist"
     + "<br>" + "Returns:"
     + "<br>" + "1: " + "Success"
             + "<br>" + "-2: " + "Invalid Key Code"
    + "<br>" + "-3: " + "Local Database Down"
    + "<br>" + "4: " + "Default Fail"

     )]
    public string BD_InputOrderStatusNoticesPaidPublish(
       string BranchCode,
       string BranchName,
       int BatchNo,
       string EmpID,
       string KeyCode
     )
    {
        if (KeyCode != getValueOfKey("Ria_KeyCode"))
            return "-2";
        if (!CheckConnection())
            return "-3";
        string CallRefID = Guid.NewGuid().ToString();
        XmlDocument SOAPReqBody = new XmlDocument();
        DateTime CallDateTime = DateTime.Now;
        DateTime DatetimeUtc = DateTime.UtcNow;
        string response_node = "";
        string MethodCalled = "";

        int SaveDone = 4;

        try
        {
            SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>
            <Root>" + GetRiaHeader(CallRefID, CallDateTime, BranchCode, EmpID, DatetimeUtc, Common.XmlText(BranchName)) +
            GetInputStatusNoticeUpdateData(EmpID, BatchNo) +
             "</Root>");

            RiaFxGlobalWebReferance.FXGlobalSending FxObject = new RiaFxGlobalWebReferance.FXGlobalSending();

            XmlNode nodeObj = FxObject.InputOrderStatusNotices(SOAPReqBody);
            response_node = nodeObj.InnerXml;
            DataTable dtRoot = new DataTable();
            DataTable dtHeader = new DataTable();
            RiaDataSet.Ria_InputOrderStatusNoticesDataTable dtOrderAck = new RiaDataSet.Ria_InputOrderStatusNoticesDataTable();

            XmlReader xmlReader = new XmlNodeReader(nodeObj);
            DataSet ds = new DataSet();
            ds.ReadXml(xmlReader);
            dtRoot = ds.Tables["Root"];
            dtHeader = ds.Tables["Header"];

            DataTable TDOSNA = new DataTable();
            TDOSNA = ds.Tables["OrderStatusNoticeAcknowledgement"];
            if (TDOSNA != null)
            {
                for (int r = 0; r < TDOSNA.Rows.Count; r++)
                {
                    RiaDataSet.Ria_InputOrderStatusNoticesRow oRow = dtOrderAck.NewRia_InputOrderStatusNoticesRow();
                    //oRow.BatchNo = 1;
                    oRow.PCOrderNo = TDOSNA.Rows[r]["PCOrderNo"].ToString();
                    oRow.SCOrderNo = TDOSNA.Rows[r]["SCOrderNo"].ToString();
                    oRow.PCNotificationID = int.Parse(TDOSNA.Rows[r]["PCNotificationID"].ToString());
                    oRow.NotificationCode = TDOSNA.Rows[r]["NotificationCode"].ToString();
                    oRow.NotificationDesc = TDOSNA.Rows[r]["NotificationDesc"].ToString();
                    oRow.ProcessDate = DateTime.ParseExact(TDOSNA.Rows[r]["ProcessDate"].ToString() + TDOSNA.Rows[r]["ProcessTime"].ToString(), "yyyyMMddHHmmss", CultureInfo.InvariantCulture);

                    //oRow.ProcessDate = DateTime.Now;
                    dtOrderAck.Rows.Add(oRow);
                }

                //dtOrderAck = (RiaDataSet.Ria_InputOrderStatusNoticesDataTable)ds.Tables["OrderStatusNoticeAcknowledgement"];

                DateTime ResponseDateTimeUTC = DateTime.ParseExact(dtHeader.Rows[0]["ResponseDateTimeUTC"].ToString(), "yyyyMMddHHmmss", CultureInfo.InvariantCulture);

                if (dtOrderAck != null)
                    SaveDone = UpdateInputOrderStatusNoticeForPaidPublish(dtOrderAck, CallRefID, CallDateTime, ResponseDateTimeUTC, EmpID, "PAID");
            }
            else
            {
                SaveDone = 5;
            }
        }
        catch (Exception ex)
        {
            SaveDone = 3;
            Common.WriteLog(CallRefID, "Ria API", "BD_InputOrderStatusNoticesPaidPublish", ex.Message);
        }
        finally
        {
            SaveReqResponseData("Ria API",CallRefID, "InputOrderStatusNoticesPaidPublish", CallDateTime, SOAPReqBody.InnerXml, response_node, SaveDone.ToString(), SaveDone.ToString());
        }
        return SaveDone.ToString();
    }
    private int UpdateInputOrderStatusNoticeForPaidPublish(RiaDataSet.Ria_InputOrderStatusNoticesDataTable dtOrderAck, string CallRefID, DateTime CallDate, DateTime ResponseDateTimeUTC, string EmpID, string OrderStatusType)
    {
        int Done = 4;
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Ria_InputOrderStatusNoticesPaid_Publish";//*** paid to ria and publish mark to remilist
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    SqlParameter sql_TIOS = new SqlParameter();
                    sql_TIOS.ParameterName = "@TIOS";
                    sql_TIOS.SqlDbType = SqlDbType.Structured;
                    sql_TIOS.TypeName = "dbo.Ria_InputOrderStatusNotices";
                    sql_TIOS.Value = dtOrderAck;
                    cmd.Parameters.Add(sql_TIOS);

                    cmd.Parameters.Add("@RefCall_ID", System.Data.SqlDbType.VarChar).Value = CallRefID;
                    cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = EmpID;
                    //cmd.Parameters.Add("@StartDT", System.Data.SqlDbType.DateTime).Value = CallDate;

                    cmd.Parameters.Add("@OrderStatusType", System.Data.SqlDbType.VarChar).Value = OrderStatusType;
                    //cmd.Parameters.Add("@ResponseData", System.Data.SqlDbType.VarChar).Value = ResponseData;
                    //cmd.Parameters.Add("@ResponseCode", System.Data.SqlDbType.VarChar).Value = ResponseCode;
                    //cmd.Parameters.Add("@ResponseText", System.Data.SqlDbType.VarChar).Value = ResponseText;
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
            Done = 2;
            Common.WriteLog(CallRefID, "Ria API", "s_Ria_InputOrderStatusNoticesPaid_Publish", ex.Message);
        }
        return Done;
    }

    [WebMethod(Description = "Service Task: Input Order Status Notices mark CANCELED/REJECTED  to ria"
     + "<br>" + "Returns:"
     + "<br>" + "1: " + "Success"
    + "<br>" + "-2: " + "Invalid Key Code"
    + "<br>" + "-3: " + "Local Database Down"
    + "<br>" + "-4: " + "Invalid Type (CANCELED/REJECTED)"
    + "<br>" + "4: " + "Default Fail"
     )]
    public string BD_InputOrderStatusNoticesCancelToRia(
       string BranchCode,
       string BranchName,
       long RID,
       string EmpID,
       string NoticeType,
       string Reason,
       string KeyCode
     )
    {
        NoticeType = NoticeType.ToUpper();
        if (KeyCode != getValueOfKey("Ria_KeyCode"))
            return "-2";
        if (!((NoticeType == "REJECTED") || (NoticeType == "CANCELED")))
        {

            return "-4";
        }

        if (!CheckConnection())
            return "-3";
        string CallRefID = Guid.NewGuid().ToString();
        XmlDocument SOAPReqBody = new XmlDocument();
        DateTime CallDateTime = DateTime.Now;
        DateTime DatetimeUtc = DateTime.UtcNow;
        string response_node = "";
        string MethodCalled = "";

        int SaveDone = 4;

        try
        {
            SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""UTF-8""?>
            <Root>" + GetRiaHeader(CallRefID, CallDateTime, BranchCode, EmpID, DatetimeUtc, Common.XmlText(BranchName)) +
            GetInputStatusCancelDataToRia(EmpID, RID, NoticeType.ToUpper(),Common.XmlText(Reason)) +
             "</Root>");

            RiaFxGlobalWebReferance.FXGlobalSending FxObject = new RiaFxGlobalWebReferance.FXGlobalSending();

            XmlNode nodeObj = FxObject.InputOrderStatusNotices(SOAPReqBody);
            response_node = nodeObj.InnerXml;
            DataTable dtRoot = new DataTable();
            DataTable dtHeader = new DataTable();
            RiaDataSet.Ria_InputOrderStatusNoticesDataTable dtOrderAck = new RiaDataSet.Ria_InputOrderStatusNoticesDataTable();

            XmlReader xmlReader = new XmlNodeReader(nodeObj);
            DataSet ds = new DataSet();
            ds.ReadXml(xmlReader);
            dtRoot = ds.Tables["Root"];
            dtHeader = ds.Tables["Header"];

            DataTable TDOSNA = new DataTable();
            TDOSNA = ds.Tables["OrderStatusNoticeAcknowledgement"];

            if (TDOSNA != null)
            {

                SaveDone = InputOrderStatusNoticesCancel_RejectToRia(RID, TDOSNA, CallRefID, EmpID, NoticeType.ToUpper());

            }
            else
            {
                SaveDone = 5;
            }
        }
        catch (Exception ex)
        {
            SaveDone = 3;
            Common.WriteLog(CallRefID, "Ria API", "BD_InputOrderStatusNoticesCancelToRia", ex.Message);
        }
        finally
        {
            SaveReqResponseData("Ria API",CallRefID, "BD_InputOrderStatusNoticesCancelToRia", CallDateTime, SOAPReqBody.InnerXml, response_node, SaveDone.ToString(), SaveDone.ToString());
        }
        return SaveDone.ToString();
    }

    private int InputOrderStatusNoticesCancel_RejectToRia(long RID, DataTable dtOrderResponse, string RefCallID, string EmpID, string ReqTypeCode)
    {
        int done = 2;
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Ria_InputOrderStatusNoticesCancelToRia";//*** cancel/reject  order to Ria Save
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    // cmd.Parameters.Add("@ExHouseCode", System.Data.SqlDbType.VarChar).Value = "Ria API";
                    cmd.Parameters.Add("@RefCall_ID", System.Data.SqlDbType.VarChar).Value = RefCallID;
                    cmd.Parameters.Add("@RID", System.Data.SqlDbType.BigInt).Value = RID;

                    cmd.Parameters.Add("@PCOrderNo", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["PCOrderNo"].ToString();
                    cmd.Parameters.Add("@SCOrderNo", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["SCOrderNo"].ToString();
                    cmd.Parameters.Add("@PCNotificationID", System.Data.SqlDbType.Int).Value = int.Parse(dtOrderResponse.Rows[0]["PCNotificationID"].ToString());
                    cmd.Parameters.Add("@ProcessDate", System.Data.SqlDbType.DateTime).Value = DateTime.ParseExact(dtOrderResponse.Rows[0]["ProcessDate"].ToString() + dtOrderResponse.Rows[0]["ProcessTime"].ToString(), "yyyyMMddHHmmss", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("@NotificationCode", System.Data.SqlDbType.VarChar).Value = dtOrderResponse.Rows[0]["NotificationCode"].ToString();
                    cmd.Parameters.Add("@OrderStatusType", System.Data.SqlDbType.VarChar).Value = ReqTypeCode;
                    cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = EmpID;
                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Int);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = 0;
                    cmd.Parameters.Add(sqlDone);
                    cmd.Connection = conn;
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    done = (int)sqlDone.Value;

                }

            }

        }
        catch (Exception ex)
        {
            Common.WriteLog(RefCallID, "Ria API", "s_Ria_UpdateInputCancelRequestData", ex.Message);
        }

        return done;

    }

    private string GetInputStatusCancelDataToRia(string EmpID, long RID, string NoticeType, string Reason)
    {
        string xml_order = "";
        string Query = "";
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                if (NoticeType == "REJECTED")
                    Query = "s_Ria_GetInputOrderStatusRejected";
                if (NoticeType == "CANCELED")
                    Query = "s_Ria_GetInputOrderStatusCancelToRia";//***

                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = EmpID;
                    cmd.Parameters.Add("@RID", System.Data.SqlDbType.BigInt).Value = RID;
                    cmd.Parameters.Add("@Reason", System.Data.SqlDbType.VarChar).Value = Reason;
                    SqlParameter sqlXml = new SqlParameter("@xml", SqlDbType.VarChar, -1);
                    sqlXml.Direction = ParameterDirection.InputOutput;
                    sqlXml.Value = "";
                    cmd.Parameters.Add(sqlXml);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    xml_order = sqlXml.Value.ToString();

                }

            }

        }
        catch (Exception ex)
        {
            Common.WriteLog("", "Ria API", Query, ex.Message);
        }

        return xml_order;

    }


    [WebMethod(Description = "Service Task: GetDailyOrders for  daily report"
     + "<br>" + "Returns:"
     + "<br>" + "Xml"
     + "<br>" + "-2: " + "Invalid Key Code"

     )]
    public string Ria_GetDailyOrdersReport(
       string BranchCode,
       string BranchName,
       string ReportDate,
       string EmpID,
       string KeyCode
     )
    {
        if (KeyCode != getValueOfKey("Ria_KeyCode"))
            return "-2";
        if (!CheckConnection())
            return "-3";
        string CallRefID = Guid.NewGuid().ToString();
        XmlDocument SOAPReqBody = new XmlDocument();
        DateTime CallDateTime = DateTime.Now;
        DateTime DatetimeUtc = DateTime.UtcNow;
        string response_node = "";

        try
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.AppendLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            sb.AppendLine("<Root>");
            sb.AppendLine(GetRiaHeader(CallRefID, CallDateTime, BranchCode, EmpID, DatetimeUtc, Common.XmlText(BranchName)));
            //sb.AppendLine("<Request>");
            sb.AppendLine("<Request ReportDate=\"" + ReportDate + "\"/>");
            //sb.AppendLine("</Request>");
            sb.AppendLine("</Root>");

            SOAPReqBody.LoadXml(sb.ToString());

            RiaFxGlobalWebReferance.FXGlobalSending FxObject = new RiaFxGlobalWebReferance.FXGlobalSending();
            XmlNode nodeObj = FxObject.GetDailyOrders(SOAPReqBody);
            response_node = nodeObj.InnerXml;


            //XmlReader xmlReader = new XmlNodeReader(nodeObj);
            //DataSet ds = new DataSet();
            //ds.ReadXml(xmlReader);


            //DataTable TDOSNA = new DataTable();
            //TDOSNA = ds.Tables["Orders"];

        }
        catch (Exception ex)
        {
            response_node = ex.Message;
            Common.WriteLog(CallRefID, "Ria API", "Ria_GetDailyOrders", ex.Message);
        }

        return response_node;
    }

    [WebMethod(Description = "Service Task: Ria_GetDailyOrdersSummaryReport for  summary report"
    + "<br>" + "Returns:"
    + "<br>" + "Xml"
    + "<br>" + "-2: " + "Invalid Key Code"

    )]
    public string Ria_GetDailyOrdersSummaryReport(
    string BranchCode,
    string BranchName,
    string ReportDate,
    string EmpID,
    string KeyCode
    )
    {
        if (KeyCode != getValueOfKey("Ria_KeyCode"))
            return "-2";
        if (!CheckConnection())
            return "-3";
        string CallRefID = Guid.NewGuid().ToString();
        XmlDocument SOAPReqBody = new XmlDocument();
        DateTime CallDateTime = DateTime.Now;
        DateTime DatetimeUtc = DateTime.UtcNow;
        string response_node = "";

        try
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.AppendLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            sb.AppendLine("<Root>");
            sb.AppendLine(GetRiaHeader(CallRefID, CallDateTime, BranchCode, EmpID, DatetimeUtc, Common.XmlText(BranchName)));
            //sb.AppendLine("<Request>");
            sb.AppendLine("<Request ReportDate=\"" + ReportDate + "\"/>");
            //sb.AppendLine("</Request>");
            sb.AppendLine("</Root>");

            SOAPReqBody.LoadXml(sb.ToString());

            RiaFxGlobalWebReferance.FXGlobalSending FxObject = new RiaFxGlobalWebReferance.FXGlobalSending();
            XmlNode nodeObj = FxObject.GetDailyOrdersSummary(SOAPReqBody);
            response_node = nodeObj.InnerXml;



            //XmlReader xmlReader = new XmlNodeReader(nodeObj);
            //DataSet ds = new DataSet();
            //ds.ReadXml(xmlReader);

            //DataTable TDOSNA = new DataTable();
            //TDOSNA = ds.Tables["Orders"];
        }
        catch (Exception ex)
        {
            response_node = ex.Message;
            Common.WriteLog(CallRefID, "Ria API", "Ria_GetDailyOrders", ex.Message);
        }

        return response_node;
    }

}

public struct OP_Verify_Order
{
    public List<string> Required_Fields { get; set; }
    //  public  List<OP_RequiredFields> Required_Fields { get; set; }
    public string TransRefID { get; set; }
    public string ResponseCode { get; set; }
    public string ResponseText { get; set; }
    public string RefID { get; set; }
    public string OrderNo { get; set; }
    public string Pin { get; set; }
    public string Currency { get; set; }
    public decimal Amount { get; set; }

}
public struct OP_RequiredFields
{
    public string RequiredField { get; set; }
}
public struct OP_Paid_Order
{

    public Int64 RID { get; set; }
    public bool Done { get; set; }
    public string RollBackRequired { get; set; }
    public string ResponseCode { get; set; }
    public string ResponseText { get; set; }
}

public struct PaidRemilistStatus
{
    public bool Done { get; set; }
    public Int64 RID { get; set; }
}
