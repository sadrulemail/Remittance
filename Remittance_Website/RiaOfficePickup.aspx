<%@ Page Title="Ria Bank Deposit Orders Download" Language="C#" AutoEventWireup="true"
    Inherits="Remittance.RiaOfficePickup" MasterPageFile="~/MasterPage.master" CodeFile="RiaOfficePickup.aspx.cs" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text="Ria Office Pickup Payout"></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            
            <div class="group" style="display: table">
                <h2>Ria Office Pickup Payout</h2>
                <div>

                    <table>
                        <tr>
                            <td>Pin</td>
                            <td>
                                <asp:TextBox ID="txtPin" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorPin"
                                    runat="server" ErrorMessage="*" ControlToValidate="txtPin" ValidationGroup="Verification"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>Amount</td>
                            <td>
                                <asp:TextBox ID="txtAmount" data-validation="number" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator_Amount"
                                    runat="server" ErrorMessage="*" ControlToValidate="txtAmount" ValidationGroup="Verification"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <asp:Button ID="btnVerifyOrder" runat="server" OnClick="btnVerifyOrder_Click" ValidationGroup="Verification" Text="Verify Order"></asp:Button>
<asp:ConfirmButtonExtender runat="server" ID="conVerify" TargetControlID="btnVerifyOrder"
                                ConfirmText="Do you want to Verify the Order?"></asp:ConfirmButtonExtender>
                            <asp:LinkButton ID="Button1" CssClass="Link bold" runat="server" Text="Verify New" OnClick="Button1_Click" />
                            </td>
                            
                        </tr>
                    </table>

                </div>
            </div>
             <asp:Panel ID="PanelRequired" runat="server" Visible="false">
                <div style="padding: 10px 20px 20px 0px">
                        <table>
                            <tr>
                                <td valign="top">
                                  <%--  <div style="padding: 12px" >--%>
                                         <div class="group" style="display: table">
                    <h2>Ria Office Pickup Confirm Order Paid</h2>
                    <div>
                        <asp:HiddenField ID="hidVerifyOrderRefID" runat="server" />
                        <table>
                            <tr>
                                <td>Verify Order Trans RefID</td>
                                <td>
                                    <asp:TextBox ID="txtTransRefID" ReadOnly="true" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                                        runat="server" ErrorMessage="*" ControlToValidate="txtTransRefID" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                            <tr>
                                <td>Order No</td>
                                <td>
                                    <asp:TextBox ID="txtOrderNo" ReadOnly="true" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2"
                                        runat="server" ErrorMessage="*" ControlToValidate="txtOrderNo" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>


                            </tr>
                            <tr>
                                <td>Pin No</td>
                                <td>
                                    <asp:TextBox ID="txtPinNo" ReadOnly="true" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3"
                                        runat="server" ErrorMessage="*" ControlToValidate="txtPinNo" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                            <tr>
                                <td>Beneficiary Currency</td>
                                <td>
                                    <asp:TextBox ID="txtBeneCurrency" ReadOnly="true" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4"
                                        runat="server" ErrorMessage="*" ControlToValidate="txtBeneCurrency" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                            <tr>
                                <td>Beneficiary Amount</td>
                                <td>
                                    <asp:TextBox ID="txtBeneAmount" ReadOnly="true" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5"
                                        runat="server" ErrorMessage="*" ControlToValidate="txtBeneAmount" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                    <asp:Label ID="lblAmount" Visible="false" ForeColor="Red" runat="server" Text="Amount not Match"></asp:Label>
                                </td>

                            </tr>
                                                                                 

                            <tr id="TrBeneIDType" runat="server" visible="false" >
                                <td> <asp:Label ID="lblBeneIDType"  runat="server" Text="Beneficiary ID Type"></asp:Label></td>
                                <td>
                                    <asp:TextBox ID="txtBeneIDType"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator16"
                                        runat="server" ErrorMessage="*" Enabled="true" ControlToValidate="txtBeneIDType" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                             <tr id="TrBeneIDNo" runat="server" visible="false" >
                                  <td> <asp:Label ID="lblBeneIDNo"  runat="server" Text="Beneficiary ID No"></asp:Label></td>
                               
                                <td>
                                    <asp:TextBox ID="txtBeneIDNo"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator15"
                                        runat="server" ErrorMessage="*" Enabled="true" ControlToValidate="txtBeneIDNo" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                            <tr id="TrBeneIDIssuedBy" runat="server" visible="false" >
                                  <td> <asp:Label ID="lblBeneIDIssuedBy"  runat="server" Text="Beneficiary ID Issued By"></asp:Label></td>
                                
                                <td>
                                    <asp:TextBox ID="txtBeneIDIssuedBy"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator13"
                                        runat="server" ErrorMessage="*" Enabled="true" ControlToValidate="txtBeneIDIssuedBy" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                             <tr id="TrBeneIDIssuedCountry" runat="server" visible="false" >
                                 <td> <asp:Label ID="lblBeneIDIssuedCountry"  runat="server" Text="Beneficiary ID Issued By Country"></asp:Label></td>
                             
                                <td>
                                    <asp:TextBox ID="txtBeneIDIssuedCountry"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator14"
                                        runat="server" ErrorMessage="*" Enabled="true" ControlToValidate="txtBeneIDIssuedCountry" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                             <tr id="TrBeneIssuedByState" runat="server" visible="false" >
                                 <td> <asp:Label ID="lblBeneIssuedByState"  runat="server" Text="Beneficiary ID Issued By State"></asp:Label></td>
                                
                                <td>
                                    <asp:TextBox ID="txtBeneIssuedByState"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator23"
                                        runat="server" ErrorMessage="*" Enabled="true" ControlToValidate="txtBeneIssuedByState" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                            <tr id="TrBeneIDIssuedDate" runat="server" visible="false" >
                                  <td> <asp:Label ID="lblBeneIDIssuedDate"  runat="server" Text="Beneficiary ID Issued Date"></asp:Label></td>
                               
                                <td>
                                     <asp:TextBox ID="txtBeneIDIssuedDate"  runat="server" Width="80px"
                                        Watermark="dd/mm/yyyy" CssClass="Watermark Date"></asp:TextBox>
                                    
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator12"
                                        runat="server" ErrorMessage="*" Enabled="true" ControlToValidate="txtBeneIDIssuedDate" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                             <tr id="TrBeneIdExpiDate" runat="server" visible="false" >
                                  <td> <asp:Label ID="lblBeneIdExpiDate"  runat="server" Text="Beneficiary ID Expiration Date"></asp:Label></td>
                             
                                <td>
                                       <asp:TextBox ID="txtBeneIdExpiDate"  runat="server" Width="80px"
                                        Watermark="dd/mm/yyyy" CssClass="Watermark Date"></asp:TextBox>
                                 
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator24"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtBeneIdExpiDate" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>

                         <%--    <tr id="TrCorpLocID" runat="server" visible="false" >
                                      <td> <asp:Label ID="lblCorpLocID"  runat="server" Text="Correspond Location ID"></asp:Label></td>
                               
                                <td>
                                    <asp:TextBox ID="txtCorpLocID"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator25"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtCorpLocID" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>--%>
                                <tr id="TrCorpLocName" runat="server" visible="false" >
                                    <td> <asp:Label ID="lblCorpLocName"  runat="server" Text="Correspond Location Name"></asp:Label></td>
                            
                                <td>
                                    <asp:TextBox ID="txtCorpLocName"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator26"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtCorpLocName" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                               <tr id="TrCorrespLocAddress" runat="server" visible="false" >
                                      <td> <asp:Label ID="lblCorrespLocAddress"  runat="server" Text="Corresp Loc Address"></asp:Label></td>
                               
                                <td>
                                    <asp:TextBox ID="txtCorrespLocAddress"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator27"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtCorrespLocAddress" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                              <tr id="TrCorrespLocCity" runat="server" visible="false" >
                                     <td> <asp:Label ID="lblCorrespLocCity"  runat="server" Text="Corresp Loc City"></asp:Label></td>
                              
                                <td>
                                    <asp:TextBox ID="txtCorrespLocCity"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator28"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtCorrespLocCity" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>


                                <tr id="TrCorrespLocState" runat="server" visible="false" >
                                    <td> <asp:Label ID="lblCorrespLocState"  runat="server" Text="Corresp Loc State"></asp:Label></td>
                               
                                <td>
                                    <asp:TextBox ID="txtCorrespLocState"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator29"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtCorrespLocState" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                               <tr id="TrCorrespLocPostalCode" runat="server" visible="false" >
                                    <td> <asp:Label ID="lblCorrespLocPostalCode"  runat="server" Text="Corresp Loc Postal Code"></asp:Label></td>
                             
                                <td>
                                    <asp:TextBox ID="txtCorrespLocPostalCode"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator30"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtCorrespLocPostalCode" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                               <tr id="TrCorrespLocCountry" runat="server" visible="false" >
                                       <td> <asp:Label ID="lblCorrespLocCountry"  runat="server" Text="Corresp Loc Country"></asp:Label></td>
                              
                                <td>
                                    <asp:TextBox ID="txtCorrespLocCountry"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator31"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtCorrespLocCountry" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                                <tr id="TrBeneTelNo" runat="server" visible="false" >
                                     <td> <asp:Label ID="lblBeneTelNo"  runat="server" Text="Beneficiary Tel No"></asp:Label></td>
                             
                                <td>
                                    <asp:TextBox ID="txtBeneTelNo"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator32"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtBeneTelNo" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                              <tr id="TrBeneAddress" runat="server" visible="false" >
                                    <td> <asp:Label ID="lblBeneAddress"  runat="server" Text="Beneficiary BeneAddress"></asp:Label></td>
                           
                                <td>
                                    <asp:TextBox ID="txtBeneAddress"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator33"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtBeneAddress" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                              <tr id="TrBeneCity" runat="server" visible="false" >
                                     <td> <asp:Label ID="lblBeneCity"  runat="server" Text="Beneficiary City"></asp:Label></td>
                                
                                <td>
                                    <asp:TextBox ID="txtBeneCity"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator34"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtBeneCity" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>

                              <tr id="TrBeneCounty" runat="server" visible="false" >
                                  <td> <asp:Label ID="lblBeneCounty"  runat="server" Text="Beneficiary Country"></asp:Label></td>
                                <td>
                                    <asp:TextBox ID="txtBeneCounty"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator35"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtBeneCounty" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                              <tr id="TrBeneState" runat="server" visible="false" >
                               <td> <asp:Label ID="lblBeneState"  runat="server" Text="Beneficiary State"></asp:Label></td>
                                <td>
                                    <asp:TextBox ID="txtBeneState"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator36"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtBeneState" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                               <tr id="TrBenePostalCode" runat="server" visible="false" >
                                    <td> <asp:Label ID="lblBenePostalCode"  runat="server" Text="Beneficiary Postal Code"></asp:Label></td>
                                
                                <td>
                                    <asp:TextBox ID="txtBenePostalCode"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator37"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtBenePostalCode" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                               <tr id="TrBeneCountry" runat="server" visible="false" >
                                <td>Beneficiary Country</td>
                                <td>
                                    <asp:TextBox ID="txtBeneCountry" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator380"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtBeneCountry" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                             <tr id="TrBeneNationality" runat="server" visible="false" >
                                 <td> <asp:Label ID="lblBeneNationality"  runat="server" Text="Beneficiary Nationality"></asp:Label></td>
                             
                                <td>
                                    <asp:TextBox ID="txtBeneNationality"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator17"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtBeneNationality" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                               <tr id="TrBeneCountryOfResident" runat="server" visible="false" >
                                   <td> <asp:Label ID="lblBeneCountryOfResident"  runat="server" Text="Beneficiary Country of Residence"></asp:Label></td>
                              
                                <td>
                                    <asp:TextBox ID="txtBeneCountryOfResident"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtBeneCountryOfResident" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                             <tr id="TrBeneDOB" runat="server" visible="false" >
                                   <td> <asp:Label ID="lblBeneDOB"  runat="server" Text="Beneficiary Date of Birth"></asp:Label></td>
                             
                                <td>
                                    <asp:TextBox ID="txtBeneDOB"  runat="server" Width="80px"
                                        Watermark="dd/mm/yyyy" CssClass="Watermark Date"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator10"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtBeneDOB" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                                <tr id="TrBeneCountryBirth" runat="server" visible="false" >
                                  <td> <asp:Label ID="lblBeneCountry"  runat="server" Text="Beneficiary Country Of Birth"></asp:Label></td>
                               
                                <td>
                                    <asp:TextBox ID="txtBeneCountryBirth"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtBeneCountryBirth" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                           <tr id="TrBeneStateBirth" runat="server" visible="false" >
                                <td> <asp:Label ID="lblBeneStateBirth"  runat="server" Text="Beneficiary State of Birth"></asp:Label></td>
                               
                                <td>
                                    <asp:TextBox ID="txtBeneStateBirth"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator20"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtBeneStateBirth" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                             <tr id="TrBeneCityOfBirth" runat="server" visible="false" >
                                  <td> <asp:Label ID="lblBeneCityOfBirth"  runat="server" Text="Beneficiary City of Birth"></asp:Label></td>
                               
                                <td>
                                    <asp:TextBox ID="txtBeneCityOfBirth"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6"
                                        runat="server" ErrorMessage="*" Enabled="false" ControlToValidate="txtBeneCityOfBirth" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                          
                          
                            <tr id="TrBeneOccupation" runat="server" visible="false" >
                                  <td> <asp:Label ID="lblBeneOccupation"  runat="server" Text="Beneficiary Occupation"></asp:Label></td>
                                
                                <td>
                                    <asp:TextBox ID="txtBeneOccupation"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator18"
                                        runat="server" ErrorMessage="*" Enabled="true" ControlToValidate="txtBeneOccupation" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                            <tr id="TrBeneGender" runat="server" visible="false" >
                                  <td> <asp:Label ID="lblBeneGender"  runat="server" Text="Beneficiary Gender"></asp:Label></td>
                                
                                <td>
                                    <asp:TextBox ID="txtBeneGender"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator11"
                                        runat="server" ErrorMessage="*" Enabled="true" ControlToValidate="txtBeneGender" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                             <tr id="TrBeneTaxID" runat="server" visible="false" >
                                     <td> <asp:Label ID="lblBeneTaxID"  runat="server" Text="Beneficiary Tax ID"></asp:Label></td>
                               
                                <td>
                                    <asp:TextBox ID="txtBeneTaxID"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator21"
                                        runat="server" ErrorMessage="*" Enabled="true" ControlToValidate="txtBeneTaxID" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                             <tr id="TrBeneCustRelation" runat="server" visible="false" >
                                   <td> <asp:Label ID="lblBeneCustRelation"  runat="server" Text="Beneficiary & Couster Relationship"></asp:Label></td>
                               
                                <td>
                                    <asp:TextBox ID="txtBeneCustRelation"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9"
                                        runat="server" ErrorMessage="*" Enabled="true" ControlToValidate="txtBeneCustRelation" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                              
                               <tr id="TrBeneDistrict" runat="server" visible="false" >
                                    <td> <asp:Label ID="lblBeneDistrict" runat="server" Text="Beneficiary BeneDistrict"></asp:Label></td>
                            
                                <td>
                                    <asp:TextBox ID="txtBeneDistrict"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator38"
                                        runat="server" ErrorMessage="*" Enabled="true" ControlToValidate="txtBeneDistrict" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                           <tr id="TrBeneIdentityCode" runat="server" visible="false" >
                                <td> <asp:Label ID="lblBeneIdentityCode"  runat="server" Text="Beneficiary BeneIdentity Code"></asp:Label></td>
                                
                                <td>
                                    <asp:TextBox ID="txtBeneIdentityCode"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator39"
                                        runat="server" ErrorMessage="*" Enabled="true" ControlToValidate="txtBeneIdentityCode" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                           
                              <tr id="TrBeneCURPNumber" runat="server" visible="false" >
                                  <td> <asp:Label ID="lblBeneCURPNumber"  runat="server" Text="Beneficiary BeneCURPNumber"></asp:Label></td>
                            
                                <td>
                                    <asp:TextBox ID="txtBeneCURPNumber"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator40"
                                        runat="server" ErrorMessage="*" Enabled="true" ControlToValidate="txtBeneCURPNumber" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                             <tr id="TrBeneTransferReason" runat="server" visible="false" >
                                <td> <asp:Label ID="lblBeneTransferReason" Visible="true" runat="server" Text="Beneficiary Transfer Reason"></asp:Label></td>
                               
                                <td>
                                    <asp:TextBox ID="txtBeneTransferReason" Visible="true" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator22"
                                        runat="server" ErrorMessage="*" Enabled="true" ControlToValidate="txtBeneTransferReason" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                               <tr id="TrOnBehalfOf" runat="server" visible="false" >
                                  <td> <asp:Label ID="Label1" runat="server"  Text="Beneficiary OnBehalfOf"></asp:Label></td>
                               
                                <td>
                                    <asp:TextBox ID="txtOnBehalfOf"   runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator41"
                                        runat="server" ErrorMessage="*" Enabled="true" ControlToValidate="txtOnBehalfOf" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                                 <tr id="TrBenePhone" runat="server" visible="false" >
                                       <td> <asp:Label ID="lblBenePhone"  runat="server" Text="Beneficiary Phone No"></asp:Label></td>
                                
                                <td>
                                    <asp:TextBox ID="txtBenePhone"  runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator19"
                                        runat="server" ErrorMessage="*" Enabled="true" ControlToValidate="txtBenePhone" ValidationGroup="OfficePickup"></asp:RequiredFieldValidator>
                                </td>

                            </tr>
                           
                            <tr>
                                <td></td>
                                <td>
                                    <asp:Button ID="btnConfirmPaid"  ValidationGroup="OfficePickup" runat="server" Text="Confirm Order Paid" OnClick="btnConfirmPaid_Click" />
                                    <asp:ConfirmButtonExtender runat="server" ID="ConfirmButtonExtender1" TargetControlID="btnConfirmPaid"
                                        ConfirmText="Do you want to Pay the Order?"></asp:ConfirmButtonExtender>
                                     <asp:LinkButton ID="LinkButton2" CssClass="Link bold" runat="server" Text="Verify New" OnClick="Button1_Click" />
                                </td>

                            </tr>
                        </table>
                    </div>
                </div>
                                     <%--   </div>--%>
                                    </td>
                                  <td valign="top" style="padding-left:20px;">
                                    <div style="padding: 12px" class="ui-corner-all Panel2">
                                               <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" CellPadding="4"
                                            DataSourceID="SqlDataSource1" ForeColor="Black" BackColor="#FFFFB5" Style="font-size: small"
                                            DataKeyNames="ID" CssClass="Grid">
                                            <FooterStyle BackColor="#CCCC99" />
                                            <RowStyle VerticalAlign="Middle" />
                                            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                                            <Fields>
                                                                                             
                                            <%--    <asp:TemplateField HeaderText="ExHouse" SortExpression="ExHouseCode">
                                                    <ItemTemplate>
                                                        <%# Eval("ExHouseName")%>
                                                        (<b><%# Eval("ExHouseCode") %></b>)
                                                    </ItemTemplate>
                                                </asp:TemplateField>--%>
                                                <asp:BoundField DataField="CustomerFullName" HeaderText="Remitter Name" SortExpression="CustomerFullName" />
                                             <asp:BoundField DataField="CustAddress" HeaderText="Remitter Address" SortExpression="CustAddress"
                                                    HtmlEncode="false" />
                                                <asp:BoundField DataField="CustState" HeaderText="Remitter State" SortExpression="CustState"
                                                    HtmlEncode="false" />
                                                <asp:BoundField DataField="CustCountry" HeaderText="Remitter Country" SortExpression="CustCountry"
                                                    HtmlEncode="false" />
                                                 <asp:BoundField DataField="CustTelNo" HeaderText="Remitter TelNo" SortExpression="CustTelNo"
                                                    HtmlEncode="false" />
                                                <asp:BoundField DataField="BeneFullName" HeaderText="Beneficiary Full Name" SortExpression="BeneFullName"
                                                    ItemStyle-Font-Bold="true" ItemStyle-Font-Size="Medium" HeaderStyle-Font-Bold="true">
                                                    <HeaderStyle Font-Bold="True" />
                                                    <ItemStyle Font-Bold="True" Font-Size="Medium" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="BeneAddress" HeaderText="Beneficiary Address" SortExpression="BeneAddress"
                                                    HtmlEncode="false" />
                                                  <asp:BoundField DataField="BeneCity" HeaderText="Beneficiary City" SortExpression="BeneCity"
                                                    HtmlEncode="false" />
                                                <asp:BoundField DataField="BeneState" HeaderText="Beneficiary State" SortExpression="BeneState"
                                                    HtmlEncode="false" />
                                                
                                                <asp:BoundField DataField="BeneCountry" HeaderText="Beneficiary Country" SortExpression="BeneCountry"
                                                    HtmlEncode="false" />
                                                  <asp:BoundField DataField="CustBeneRelationship" HeaderText="CustBene Relationship" SortExpression="CustBeneRelationship"
                                                    HtmlEncode="false" />
                                                 <asp:BoundField DataField="TransferReason" HeaderText="Transfer Reason" SortExpression="TransferReason"
                                                    HtmlEncode="false" />
                                           
                                             
                                            </Fields>
                                            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                            <EditRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                            <EmptyDataTemplate>
                                                Order Not Found.
                                            </EmptyDataTemplate>
                                            <EmptyDataRowStyle Font-Size="Large" Font-Bold="true" ForeColor="Red" CssClass="Panel1" />
                                        </asp:DetailsView>
                                         <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                            SelectCommand="s_Ria_OP_OrderDetails" SelectCommandType="StoredProcedure">
                                            <SelectParameters>
                                                <asp:ControlParameter  ControlID="hidVerifyOrderRefID" Name="RefIdVerify"/>
                                             
                                            </SelectParameters>
                                             </asp:SqlDataSource>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                    </div>

           
               

            </asp:Panel>


        </ContentTemplate>
        <Triggers>
        </Triggers>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="false" AssociatedUpdatePanelID="UpdatePanel1"
        DisplayAfter="10">
        <ProgressTemplate>
            <div class="TransparentGrayBackground">
            </div>
            <asp:Image ID="Image1" runat="server" alt="" ImageUrl="~/Images/processing.gif" CssClass="LoadingImage"
                Width="214" Height="138" />
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:AlwaysVisibleControlExtender ID="UpdateProgress1_AlwaysVisibleControlExtender"
        runat="server" Enabled="True" HorizontalSide="Center" TargetControlID="Image1"
        UseAnimation="false" VerticalSide="Middle"></asp:AlwaysVisibleControlExtender>
</asp:Content>
