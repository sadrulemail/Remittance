<%@ Page Title="Add New Remittance" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    Inherits="Remittance.Remittance_Add" CodeFile="Remittance_Add.aspx.cs" EnableViewState="true" EnableSessionState="ReadOnly" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <style>
        .group-body {
            display: inline-block;
            vertical-align: top;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text="Add New Remittance"></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="group" style="display: table; margin-left: 50px">
                <h5>Remitance Add</h5>
                <asp:Panel runat="server" ID="Panel1" CssClass="group-body">
                    <table cellpadding="2px">
                        <tr>
                            <td>Ex-House: 
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlExHouse" runat="server"
                                    DataSourceID="SqlDataSourceExHouse" DataTextField="ExHouseName"
                                    DataValueField="ExHouseCode">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlDataSourceExHouse" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                    SelectCommand="SELECT [ExHouseCode], [ExHouseName] FROM [dbo].[ExHouses] WITH (NOLOCK) WHERE ExHouse_Type = 'W' AND Active = 1 ORDER BY [ExHouseName]; "></asp:SqlDataSource>
                                <asp:RequiredFieldValidator ID="reqddlExHouse" ControlToValidate="ddlExHouse"
                                    ValidationGroup="HoForwarding" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>Currency:                               
                            </td>
                            <td>
                                <asp:DropDownList ID="cboCurrency" runat="server"
                                    DataSourceID="SqlDataSourceCurrency" DataTextField="Currency"
                                    DataValueField="Currency">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlDataSourceCurrency" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                    SelectCommand="SELECT Currency FROM [v_Currency];"></asp:SqlDataSource>
                            </td>
                        </tr>
                        <tr>
                            <td>Amount:
                            </td>
                            <td>
                                <asp:TextBox ID="txtAmount" runat="server" Width="100px" placeholder="0.00" TextMode="Number"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqAmount" ControlToValidate="txtAmount"
                                    ValidationGroup="HoForwarding" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>Beneficiary Name:
                            </td>
                            <td>
                                <asp:TextBox ID="txtBeneficiaryName" runat="server" placeholder="beneficiary name" Width="400px" MaxLength="50"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqBeneficiaryName" ControlToValidate="txtBeneficiaryName"
                                    ValidationGroup="HoForwarding" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>Beneficiary Address:
                            </td>
                            <td>
                                <asp:TextBox ID="txtBeneficiaryAddress" runat="server" placeholder="beneficiary address" Width="400px" MaxLength="200"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Remitter Name:
                            </td>
                            <td>
                                <asp:TextBox ID="txtRemitterName" runat="server" placeholder="remitter name" Width="400px" MaxLength="100"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="reqtxtRemitterName" ControlToValidate="txtRemitterName"
                                    ValidationGroup="HoForwarding" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>Remitter Address:
                            </td>
                            <td>
                                <asp:TextBox ID="txtRemitterAddress" runat="server" placeholder="remitter address" Width="400px" MaxLength="200"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Ref Order Receipt:
                            </td>
                            <td>
                                <asp:TextBox ID="txtRefOrderReceipt" runat="server" Width="200px" placeholder="receipt no" MaxLength="50"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="reqtxtRefOrderReceipt" ControlToValidate="txtRefOrderReceipt"
                                    ValidationGroup="HoForwarding" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>Paid Date:</td>
                            <td>
                                <asp:TextBox ID="txtPaidOn" runat="server" CssClass="Watermark Date" Watermark="dd/mm/yyyy"
                                     MaxLength="10" Width="80px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="reqtxtPaidOn" ControlToValidate="txtPaidOn"
                                    ValidationGroup="HoForwarding" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                            </td>
                        </tr>

                          <tr>
                            <td>value Date:</td>
                            <td>
                                <asp:TextBox ID="txtValueDate" runat="server" CssClass="Watermark Date" Watermark="dd/mm/yyyy"
                                   MaxLength="10" Width="80px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="reqtxtValueDate" ControlToValidate="txtValueDate"
                                    ValidationGroup="HoForwarding" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                            </td>
                        </tr>

                          <tr>
                            <td>Instrument No.
                            </td>
                            <td>
                                <asp:TextBox ID="txtInstumentNo" runat="server" Width="200px" placeholder="instument no" MaxLength="50">
                                </asp:TextBox>
                                
                            </td>
                        </tr>
                        <tr>
                            <td>Instrument Date:
                            </td>
                            <td>
                                <asp:TextBox ID="txtInstrumentDate" runat="server" CssClass="Watermark Date" Watermark="dd/mm/yyyy"
                                     MaxLength="10" Width="80px">
                                </asp:TextBox>
                               
                            </td>
                        </tr>
                        <tr>
                            <td >ID Type:
                            </td>
                            <td>
                                <asp:DropDownList ID="txtIDType" runat="server" Font-Size="10pt" AppendDataBoundItems="true"
                                    Font-Bold="true" DataSourceID="SqlDataSourceIDType" DataTextField="IDType" DataValueField="IDType"
                                    ><asp:ListItem></asp:ListItem>

                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlDataSourceIDType" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                    SelectCommand="SELECT [IDType] FROM [IDType] with (nolock) WHERE ([Active] = @Active) ORDER BY [OrderCol]">
                                    <SelectParameters>
                                        <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </td>
                        </tr>
                        <tr >
                            <td>ID Number:
                            </td>
                            <td>
                                <asp:TextBox ID="txtIDNo" runat="server" Width="200px" placeholder="id no" MaxLength="50"></asp:TextBox>
                            </td>
                        </tr>
                        <tr id="IdExpiryDateTr" runat="server">
                            <td>ID Expiry Date:</td>
                            <td>
                                <asp:TextBox ID="txtIDExpiryDate" runat="server" CssClass="Watermark Date" Watermark="dd/mm/yyyy"
                                     MaxLength="10" Width="80px"></asp:TextBox>
                             
                            </td>
                        </tr>
                    </table>

                </asp:Panel>
                <div class="center">
                    <asp:Button ID="cmdSave" runat="server" Text="Save" OnClick="cmdSave_Click"
                        ValidationGroup="HoForwarding" Width="100px" Height="30px" />
                    <asp:LinkButton ID="cmdNew" runat="server" Text="Add New" OnClick="cmdNew_Click"
                        CausesValidation="false" CssClass="bold Link" />
                    <div style="padding:5px">
                    <asp:Label ID="lblStatus" runat="server" Text="" Font-Size="X-Large" CssClass="bold"></asp:Label>
                        </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="false" AssociatedUpdatePanelID="UpdatePanel1"
        DisplayAfter="10">
        <ProgressTemplate>
            <%--<div class="TransparentGrayBackground">
            </div>--%>
            <asp:Image ID="Image1" runat="server" alt="" ImageUrl="~/Images/processing.gif" CssClass="LoadingImage"
                Width="214" Height="138" />
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:AlwaysVisibleControlExtender ID="UpdateProgress1_AlwaysVisibleControlExtender"
        runat="server" Enabled="True" HorizontalSide="Center" TargetControlID="Image1"
        UseAnimation="false" VerticalSide="Middle"></asp:AlwaysVisibleControlExtender>
</asp:Content>
