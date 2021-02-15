using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OfficeOpenXml;
using System.Data;
using System.Xml;
using System.Text;
using Newtonsoft.Json;
using System.Web.Script.Serialization;
using System.Data.SqlClient;

namespace Remittance
{
    public partial class TfOrderStatus : System.Web.UI.Page
    {
        int TotalCount = 0;
        int TotalRows = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");
            TrustControl1.getUserRoles();

            //if (IsPostBack)
            //{
            //    //GridView1.DataBind();
            //}
            //else
            //{
            //    txtDateFrom.Text = string.Format("{0:dd/MM/yyy}", DateTime.Now.Date);
               
            //}

            this.Title = "Transfast Order Status";
        }
        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
         
            //    cmdDownload.Visible = true;
            //else
            //    cmdDownload.Visible = false;

        }
        public string getBgColor(object DT, string Color)
        {
            return Color;
        }
        
      

        protected void btnStatus_Click(object sender, EventArgs e)
        {
            try
            {
                bool thirdparty = GetBDThirdParty(txtOrderNo.Text);
                TfWebService.TransfastService tfService = new TfWebService.TransfastService();
                string invoiceStatus = tfService.InvoiceStatus(txtOrderNo.Text.Trim(), thirdparty, getValueOfKey("Tf_KeyCode"));
                JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
                TfInvoiceStatus error_Obj = jsonSerializer.Deserialize<TfInvoiceStatus>(invoiceStatus);
                string orderStatus = error_Obj.Status;

                JavaScriptSerializer js = new JavaScriptSerializer();
                string jsonData = "[" + js.Serialize(error_Obj.Invoice) + "]";

                DataTable dtStatus = (DataTable)JsonConvert.DeserializeObject(jsonData, (typeof(DataTable)));


                dvOrderStatus.DataSource = dtStatus;
                dvOrderStatus.DataBind();

                OrderStatus.Text = string.Format("Order Status: <b>{0:N0}</b>", orderStatus);

                if (orderStatus.ToUpper() == "OK")
                {
                    PanelPaidStatus.Visible = true;
                    OrderStatus.Visible = false;
                }
                else
                {
                    PanelPaidStatus.Visible = false;
                    OrderStatus.Visible = true;
                }
            }
            catch(Exception ex)
            {
                Common.WriteLog("", "TfAPI", "InvoiceStatus UI", ex.Message);
                TrustControl1.ClientMsg("Error occured,Please try again.");
            }





        }


        private bool GetBDThirdParty(string OrderNo)
        {
            bool ThirdpartyBD = false;
            try
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_Tf_GetThirdPartyBD";//***
                    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@OrderNo", System.Data.SqlDbType.VarChar).Value = OrderNo;
                     
                        SqlParameter sqlThirdpartyBD = new SqlParameter("@ThirdpartyBD", SqlDbType.Bit);
                        sqlThirdpartyBD.Direction = ParameterDirection.InputOutput;
                        sqlThirdpartyBD.Value = 0;
                        cmd.Parameters.Add(sqlThirdpartyBD);

                        cmd.Connection = conn;
                        conn.Open();

                        cmd.ExecuteNonQuery();


                        ThirdpartyBD = (bool)sqlThirdpartyBD.Value;

                    }

                }
            }
            catch (Exception ex)
            {
                Common.WriteLog(OrderNo, "TfAPI", "s_Tf_GetThirdPartyBD", ex.Message);
            }
            return ThirdpartyBD;
        }




        public string getValueOfKey(string KeyName)
        {
            try
            {
                return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
            }
            catch (Exception) { return string.Empty; }
        }

    }

    public struct TfInvoiceStatus
    {

        public string Status { get; set; }
        public TfInvoice Invoice { get; set; }
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
}