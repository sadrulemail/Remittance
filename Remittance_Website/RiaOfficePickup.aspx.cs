using System;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OfficeOpenXml;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Collections.Generic;
using System.Net;

namespace Remittance
{
    public partial class RiaOfficePickup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            TrustControl1.getUserRoles();
        }

        //private DataTable Required_Field()
        //{
        //    // create table
        //    var dt = new System.Data.DataTable("table1");

        //    // create fields
       
        //    dt.Columns.Add("field1", typeof(string));
      

        //    // insert row values
        //    dt.Rows.Add(new Object[]{
        //        "BeneCityOfBirth"
        //   });
        //    dt.Rows.Add(new Object[]{
        //        "BeneCountryOfBirth"
        //   });
        //    dt.Rows.Add(new Object[]{
        //        "BeneCountryOfResidence"
        //   });
        //    dt.Rows.Add(new Object[]{
        //        "BeneTaxID"
        //   });
        //    return dt; 
        //}

        protected void btnVerifyOrder_Click(object sender, EventArgs e)
        {

            btnVerifyOrder.Enabled = false;
            txtPin.Enabled = false;
            txtAmount.Enabled = false;
            try
            {
                string branchID = Session["BRANCHID"].ToString().PadLeft(4, '0');
                DataTable dt = new DataTable();
                RiaFxWebService.RiaFxGlobalService fxService = new RiaFxWebService.RiaFxGlobalService();
                RiaFxWebService.OP_Verify_Order verifyOrder = new RiaFxWebService.OP_Verify_Order();

                //try
                //{
                    //   fxService.Timeout = 100;
                    verifyOrder = fxService.OP_VerifyOrderForpayout(txtPin.Text.Trim(), decimal.Parse(txtAmount.Text.Trim()), branchID, Session["BRANCHNAME"].ToString(), Session["EMPID"].ToString(), getValueOfKey("Ria_KeyCode"));
                //}
                //catch (WebException ex)
                //{
                //    if (ex.Status == WebExceptionStatus.Timeout) // timeout
                //    {
                //        // Handle timeout exception
                      
                //    }
                //    if (ex.Status == WebExceptionStatus.ConnectFailure) // for connection failure
                //    {
                //        // Handle timeout exception

                //    }

                //}
                //  verifyOrder.Required_Fields;

                if (verifyOrder.ResponseCode == "1000")
                {
                    txtBeneAmount.Text = verifyOrder.Amount.ToString();
                    txtBeneCurrency.Text = verifyOrder.Currency.ToString();
                    txtPinNo.Text = verifyOrder.Pin.ToString();
                    txtOrderNo.Text = verifyOrder.OrderNo.ToString();
                    txtTransRefID.Text = verifyOrder.TransRefID.ToString();
                    hidVerifyOrderRefID.Value = verifyOrder.RefID;

                    if (double.Parse(txtAmount.Text) != double.Parse(txtBeneAmount.Text))
                        lblAmount.Visible = true;
                 //   dt = Required_Field();
                    //  string RequiredField = "";
                    foreach (string RequiredField in verifyOrder.Required_Fields)
                    {


                        switch (RequiredField)
                        {
                            case "BeneIDType":
                                TrBeneIDType.Visible = true;
                                break;
                            case "BeneIDNumber":
                                TrBeneIDNo.Visible = true;
                                break;
                            case "BeneIDIssuedBy":
                                TrBeneIDIssuedBy.Visible = true;
                                break;
                            case "BeneIDIssuedByCountry":
                                TrBeneIDIssuedCountry.Visible = true;
                                break;

                            case "BeneIDIssuedByState":
                                TrBeneIssuedByState.Visible = true;
                                break;
                            case "BeneIDIssueDate":
                                TrBeneIDIssuedDate.Visible = true;
                                break;
                            case "BeneIDExpirationDate":
                                TrBeneIdExpiDate.Visible = true;
                                break;

                            //case "CorrespLocID":
                            //    TrCorpLocID.Visible = true;
                            //    break;
                            case "CorrespLocName":
                                TrCorpLocName.Visible = true;
                                break;
                            case "CorrespLocAddress":
                                TrCorrespLocAddress.Visible = true;
                                break;
                            case "CorrespLocCity":
                                TrCorrespLocCity.Visible = true;
                                break;
                            case "CorrespLocState":
                                TrCorrespLocState.Visible = true;
                                break;
                            case "CorrespLocPostalCode":
                                TrCorrespLocPostalCode.Visible = true;
                                break;
                            case "CorrespLocCountry":
                                TrCorrespLocCountry.Visible = true;
                                break;
                            case "BeneTelNo":
                                TrBeneTelNo.Visible = true;
                                break;
                            case "BeneAddress":
                                TrBeneAddress.Visible = true;
                                break;
                            case "BeneCity":
                                TrBeneCity.Visible = true;
                                break;
                            case "BeneCounty":
                                TrBeneCounty.Visible = true;
                                break;
                            case "BeneState":
                                TrBeneState.Visible = true;
                                break;
                            case "BenePostalCode":
                                TrBenePostalCode.Visible = true;
                                break;

                            case "BeneCountry":
                                TrBeneCountry.Visible = true;
                                break;

                            case "BeneNationality":
                                TrBeneNationality.Visible = true;
                                break;
                            case "BeneCountryOfResidence":
                                TrBeneCountryOfResident.Visible = true;
                                break;
                            case "BeneDateOfBirth":
                                TrBeneDOB.Visible = true;
                                break;
                            case "BeneCountryOfBirth":
                                TrBeneCountryBirth.Visible = true;
                                break;

                            case "BeneStateOfBirth":
                                TrBeneStateBirth.Visible = true;
                                break;
                            case "BeneCityOfBirth":
                                TrBeneCityOfBirth.Visible = true;
                                break;


                            case "BeneOccupation":
                                TrBeneOccupation.Visible = true;
                                break;
                            case "BeneGender":
                                TrBeneGender.Visible = true;
                                break;
                            case "BeneTaxID":
                                TrBeneTaxID.Visible = true;
                                break;

                            case "BeneCustRelationship":
                                TrBeneCustRelation.Visible = true;
                                break;

                            case "BeneDistrict":
                                TrBeneDistrict.Visible = true;
                                break;
                            case "BeneIdentityCode":
                                TrBeneIdentityCode.Visible = true;
                                break;


                            case "BeneCURPNumber":
                                TrBeneCURPNumber.Visible = true;
                                break;


                            case "TransferReason":
                                TrBeneTransferReason.Visible = true;
                                break;

                            case "OnBehalfOf":
                                TrOnBehalfOf.Visible = true;
                                break;
                            default:
                                // Console.WriteLine("I'm sorry, I don't understand that!");
                                break;
                        }
                    }
                    PanelRequired.Visible = true;
                  
                }
                else if(verifyOrder.ResponseCode=="")
                {
                    hidVerifyOrderRefID.Value = "";
                    TrustControl1.ClientMsg("Error occured, Pls try again.");
                    //TrBeneIDType.Visible = true;

                    //            TrBeneIDNo.Visible = true;

                    //            TrBeneIDIssuedBy.Visible = true;
                    //PanelRequired.Visible = true;

                }
                else 
                {
                    hidVerifyOrderRefID.Value = "";
                    TrustControl1.ClientMsg(verifyOrder.ResponseText);

                }
            }
            catch (Exception ex)
            {
                hidVerifyOrderRefID.Value = "";
                Common.WriteLog("", "Ria API", "VerifyOrder", ex.Message);
                TrustControl1.ClientMsg("Unable to connect to the remote Ria API Server." + "Please contact with IT Network Team.");
            }



        }

        private void ClearForm()
        {
            foreach(Control C in PanelRequired.Controls)
            {
                foreach (Control C1 in C.Controls)
                {
                    if (C1 is TextBox)
                    {
                        ((TextBox)C1).Text = "";
                    }
                }
                if (C is TextBox)
                {
                    ((TextBox)C).Text = "";
                }
            }
        }

        public  string XmlText(string InputXmlValue)
        {
            return InputXmlValue.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;").Replace("'","").Replace("\n", "<br>");
        }

        public string getValueOfKey(string KeyName)
        {
            try
            {
                return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
            }
            catch (Exception) { return string.Empty; }
        }

        private string XmlRequiredFieldValue(string branchCode)
        {
            StringBuilder requiredData = new StringBuilder();

            if (txtBeneIDType.Text.Trim() != "")
                requiredData.Append("<BeneIDType>" + txtBeneIDType.Text.Trim() + @"</BeneIDType>");
            if (txtBeneIDNo.Text.Trim() != "")
                requiredData.Append("<BeneIDNumber>" + txtBeneIDNo.Text.Trim() + @"</BeneIDNumber>");
            if (txtBeneIDIssuedBy.Text.Trim() != "")
                requiredData.Append("<BeneIDIssuedBy>" + txtBeneIDIssuedBy.Text.Trim() + @"</BeneIDIssuedBy>");
            if (txtBeneIDIssuedCountry.Text.Trim() != "")
                requiredData.Append("<BeneIDIssuedByCountry>" + txtBeneIDIssuedCountry.Text.Trim() + @"</BeneIDIssuedByCountry>");
            if (txtBeneIssuedByState.Text.Trim() != "")
                requiredData.Append("<BeneIDIssuedByState>" + txtBeneIDIssuedDate.Text.Trim() + @"</BeneIDIssuedByState>");
            if (txtBeneIDIssuedDate.Text.Trim() != "")
                requiredData.Append("<BeneIDIssueDate>" + DateTime.Parse(txtBeneIDIssuedDate.Text.Trim()).ToString("yyyyMMdd") + @"</BeneIDIssueDate>");
            if (txtBeneIdExpiDate.Text.Trim() != "")
                requiredData.Append("<BeneIDExpirationDate>" +DateTime.Parse( txtBeneIdExpiDate.Text.Trim()).ToString("yyyyMMdd") + @"</BeneIDExpirationDate>");

            //if (txtCorpLocID.Text.Trim() != "")
                requiredData.Append("<CorrespLocID>" + branchCode + @"</CorrespLocID>");
            if (txtCorpLocName.Text.Trim() != "")
                requiredData.Append("<CorrespLocName>" + txtCorpLocName.Text.Trim() + @"</CorrespLocName>");
            if (txtCorrespLocAddress.Text.Trim() != "")
                requiredData.Append("<CorrespLocAddress>" + txtCorrespLocAddress.Text.Trim() + @"</CorrespLocAddress>");
            if (txtCorrespLocCity.Text.Trim() != "")
                requiredData.Append("<CorrespLocCity>" + txtCorrespLocCity.Text.Trim() + @"</CorrespLocCity>");
            if (txtCorrespLocState.Text.Trim() != "")
                requiredData.Append("<CorrespLocState>" + txtCorrespLocState.Text.Trim() + @"</CorrespLocState>");
            if (txtCorrespLocPostalCode.Text.Trim() != "")
                requiredData.Append("<CorrespLocPostalCode>" + txtCorrespLocPostalCode.Text.Trim() + @"</CorrespLocPostalCode>");
            if (txtCorrespLocCountry.Text.Trim() != "")
                requiredData.Append("<CorrespLocCountry>" + txtCorrespLocCountry.Text.Trim() + @"</CorrespLocCountry>");

            if (txtBeneTelNo.Text.Trim() != "")
                requiredData.Append("<BeneTelNo>" + txtBeneTelNo.Text.Trim() + @"</BeneTelNo>");
            if (txtBeneAddress.Text.Trim() != "")
                requiredData.Append("<BeneAddress>" + txtBeneAddress.Text.Trim() + @"</BeneAddress>");
            if (txtBeneCity.Text.Trim() != "")
                requiredData.Append("<BeneCity>" + txtBeneCity.Text.Trim() + @"</BeneCity>");
            if (txtBeneCounty.Text.Trim() != "")
                requiredData.Append("<BeneCounty>" + txtBeneCounty.Text.Trim() + @"</BeneCounty>");
            if (txtBeneState.Text.Trim() != "")
                requiredData.Append("<BeneState>" + txtBeneState.Text.Trim() + @"</BeneState>");

            if (txtBenePostalCode.Text.Trim() != "")
                requiredData.Append("<BenePostalCode>" + txtBenePostalCode.Text.Trim() + @"</BenePostalCode>");
            if (txtBeneCountry.Text.Trim() != "")
                requiredData.Append("<BeneCountry>" + txtBeneCountry.Text.Trim() + @"</BeneCountry>");
            if (txtBeneNationality.Text.Trim() != "")
                requiredData.Append("<BeneNationality>" + txtBeneNationality.Text.Trim() + @"</BeneNationality>");
            if (txtBeneCountryOfResident.Text.Trim() != "")
                requiredData.Append("<BeneCountryOfResidence>" + txtBeneCountryOfResident.Text.Trim() + @"</BeneCountryOfResidence>");
            if (txtBeneDOB.Text.Trim() != "")
                requiredData.Append("<BeneDateOfBirth>" + DateTime.Parse(txtBeneDOB.Text.Trim()).ToString("yyyyMMdd") + @"</BeneDateOfBirth>");
            if (txtBeneCountryBirth.Text.Trim() != "")
                requiredData.Append("<BeneCountryOfBirth>" + txtBeneCountryBirth.Text.Trim() + @"</BeneCountryOfBirth>");
            if (txtBeneStateBirth.Text.Trim() != "")
                requiredData.Append("<BeneStateOfBirth>" + txtBeneStateBirth.Text.Trim() + @"</BeneStateOfBirth>");

            if (txtBeneCityOfBirth.Text.Trim() != "")
                requiredData.Append("<BeneCityOfBirth>" + txtBeneCityOfBirth.Text.Trim() + @"</BeneCityOfBirth>");
            if (txtBeneOccupation.Text.Trim() != "")
                requiredData.Append("<BeneOccupation>" + txtBeneOccupation.Text.Trim() + @"</BeneOccupation>");
            if (txtBeneGender.Text.Trim() != "")
                requiredData.Append("<BeneGender>" + txtBeneGender.Text.Trim() + @"</BeneGender>");
            if (txtBeneTaxID.Text.Trim() != "")
                requiredData.Append("<BeneTaxID>" + txtBeneTaxID.Text.Trim() + @"</BeneTaxID>");
            if (txtBeneCustRelation.Text.Trim() != "")
                requiredData.Append("<BeneCustRelationship>" + txtBeneCustRelation.Text.Trim() + @"</BeneCustRelationship>");

            if (txtBeneDistrict.Text.Trim() != "")
                requiredData.Append("<BeneDistrict>" + txtBeneDistrict.Text.Trim() + @"</BeneDistrict>");
            if (txtBeneIdentityCode.Text.Trim() != "")
                requiredData.Append("<BeneIdentityCode>" + txtBeneIdentityCode.Text.Trim() + @"</BeneIdentityCode>");
            if (txtBeneCURPNumber.Text.Trim() != "")
                requiredData.Append("<BeneCURPNumber>" + txtBeneCURPNumber.Text.Trim() + @"</BeneCURPNumber>");
            if (txtBeneTransferReason.Text.Trim() != "")
                requiredData.Append("<TransferReason>" + txtBeneTransferReason.Text.Trim() + @"</TransferReason>");
            if (txtOnBehalfOf.Text.Trim() != "")
                requiredData.Append("<OnBehalfOf>" + txtOnBehalfOf.Text.Trim() + @"</OnBehalfOf>");

            if (txtBenePhone.Text.Trim() != "")
                requiredData.Append("<BenePhoneNo>" + txtBenePhone.Text.Trim() + @"</BenePhoneNo>");
                
            return requiredData.ToString();
        }


        protected void btnConfirmPaid_Click(object sender, EventArgs e)
        {
            try
            {
                string branchCode = Session["BRANCHID"].ToString().PadLeft(4, '0');
                string xmlRequiredField = XmlRequiredFieldValue(branchCode);
                RiaFxWebService.RiaFxGlobalService fxService = new RiaFxWebService.RiaFxGlobalService();
                RiaFxWebService.OP_Paid_Order paidOrder = new RiaFxWebService.OP_Paid_Order();
                paidOrder = fxService.OP_ConfirmOrderPaid(hidVerifyOrderRefID.Value, txtPinNo.Text.Trim(), xmlRequiredField, branchCode, Session["BRANCHNAME"].ToString(), Session["EMPID"].ToString(), getValueOfKey("Ria_KeyCode"));

                if (paidOrder.ResponseCode == "1000")
                {
                    if(paidOrder.RollBackRequired == "2")
                    TrustControl1.ClientMsg("Paid Successfully to Ria. <br>" + "Paid to Remilist: " + (paidOrder.Done == true ? "Yes" : "No"));
                   else if (paidOrder.RollBackRequired == "0")
                        TrustControl1.ClientMsg("Transaction failed and RollBack Successfully to Ria End. <br>" + "Please Payment again");

                    else if (paidOrder.RollBackRequired == "1")
                        TrustControl1.ClientMsg("Payment not completed. An error occured. <br>" + "Rollback required to Ria end. <br>" + " Please contact with NRB Division");

                    btnConfirmPaid.Enabled = false;
                }
                else
                {
                    string resText = XmlText(paidOrder.ResponseText);
                    TrustControl1.ClientMsg("Paid Failed,Please try again. <br>" + resText);
                    //TrustControl1.ClientMsg("ssss");
                }
            }
            catch(Exception ex)
            {
                Common.WriteLog("", "Ria API", "btnConfirmPaid_Click", ex.Message);
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            //TrustControl1.ClientMsg("Line1<br><br>Line2");
            Response.Redirect("RiaOfficePickup.aspx", true);
        }
    }
    public struct OP_Verify_Order
    {
        //      public  List<string> Required_Fields { get; set; }
        public List<OP_RequiredFields> Required_Fields { get; set; }
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
}