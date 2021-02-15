<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    Inherits="Remittance.TfOrderStatus" CodeFile="TfOrderStatus.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%--<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>--%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Transfast Order Status
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <table style="font-size: small" class="ui-corner-all Panel1">
                            <tr>
                                <td>
                                    <table>
                                        <tr>

                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">Order No
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtOrderNo" runat="server"
                                                    Watermark="Order No"></asp:TextBox>
                                            </td>
                                            <td style="padding-left: 10px">
                                                <asp:Button ID="btnStatus" runat="server" OnClick="btnStatus_Click" Text="Order Status"></asp:Button>
                                            </td>

                                        </tr>
                                    </table>

                                </td>
                            </tr>
                        </table>
                    </td>



                </tr>
            </table>
            <br />

            <asp:Label ID="OrderStatus" runat="server" Text="" Visible="false"></asp:Label>
            <asp:Panel ID="PanelPaidStatus" runat="server" Visible="false">

                <div style="padding: 12px; display: inline-block; margin-left: 20px" class="ui-corner-all Panel2">
                    <asp:DetailsView ID="dvOrderStatus" runat="server" AutoGenerateRows="False" CellPadding="4"
                        ForeColor="Black" BackColor="#FFFFB5" Style="font-size: small"
                        DataKeyNames="TfPin" CssClass="Grid">
                        <FooterStyle BackColor="#CCCC99" />
                        <RowStyle VerticalAlign="Middle" />
                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                        <Fields>
                            <asp:BoundField DataField="TfPin" HeaderText="Order No" SortExpression="TfPin" ItemStyle-Font-Bold="true"
                                ItemStyle-Font-Size="Large" HeaderStyle-Font-Bold="true">
                                <HeaderStyle Font-Bold="True" />
                                <ItemStyle Font-Bold="True" Font-Size="Large" />
                            </asp:BoundField>
                            <asp:BoundField DataField="StatusName" HeaderText="Status Name" SortExpression="StatusName" />
                            <asp:TemplateField HeaderText="Transaction Date">
                                <ItemTemplate>
                                    <%# ((Eval("TransactionDate")).ToString() != "") ? "<div title='" + Eval("TransactionDate", "{0:dddd \ndd MMMM, yyyy \nh:mm:ss tt}") + "'>" + Eval("TransactionDate") + " <span class='time-small'>(<time class='timeago' datetime='" + Eval("TransactionDate", "{0:yyyy-MM-dd HH:mm:ss}") + "'></time>)</span></div>" : ""%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Receive Currency" SortExpression="ReceiveCurrencyIsoCode">
                                <ItemTemplate>
                                    <%# Eval("ReceiveCurrencyIsoCode")%>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Receive Amount" SortExpression="ReceiveAmount">
                                <ItemTemplate>
                                    <span style="font-weight: bold; font-size: 130%">
                                        <%# Eval("ReceiveAmount", "{0:N2}") %></span>

                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Receiver Name">
                                <ItemTemplate>
                                    '<%#Eval("ReceiverFullName")%>'
                                </ItemTemplate>

                            </asp:TemplateField>

                            <asp:BoundField DataField="ReceiverAddress" HeaderText="Receiver Address" ReadOnly="True" SortExpression="ReceiverAddress" />
                            <asp:BoundField DataField="ReceiverNationalityName" HeaderText="Receiver Nationality" ReadOnly="True" SortExpression="ReceiverNationalityName" />
                            <asp:BoundField DataField="ReceiverCountryIsoCode" HeaderText="Receiver Country" ReadOnly="True" SortExpression="ReceiverCountryIsoCode" />
                            <asp:BoundField DataField="ReceiverCityName" HeaderText="Receiver City" ReadOnly="True" SortExpression="ReceiverCityName" />
                            <asp:BoundField DataField="ReceiverPhoneMobile" HeaderText="Receiver Mobile" ReadOnly="True" SortExpression="ReceiverPhoneMobile" />

                            <asp:BoundField DataField="PaymentModeName" HeaderText="Payment Mode" ReadOnly="True" SortExpression="PaymentModeName" />
                            <asp:BoundField DataField="AccountNumber" HeaderText="Account Number" ReadOnly="True" SortExpression="AccountNumber" />
                            <asp:BoundField DataField="BankName" HeaderText="Bank Name" ReadOnly="True" SortExpression="BankName" />
                           
                             <asp:TemplateField HeaderText="Sender Amount" SortExpression="SendAmount">
                                <ItemTemplate>
                                    <span style="font-weight: bold; font-size: 130%">
                                        <%# Eval("SendAmount", "{0:N2}") %></span>

                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Sender Name">
                                <ItemTemplate>
                                    '<%#Eval("SenderFullName")%>'
                                </ItemTemplate>

                            </asp:TemplateField>

                            <asp:BoundField DataField="SenderAddress" HeaderText="Sender Address" ReadOnly="True" SortExpression="SenderAddress" />
                            <%--   <asp:BoundField DataField="SenderNationalityName" HeaderText="Sender Nationality" ReadOnly="True" SortExpression="SenderNationalityName" />--%>
                            <asp:BoundField DataField="SenderCountryName" HeaderText="Sender Country" ReadOnly="True" SortExpression="SenderCountryName" />
                            <asp:BoundField DataField="SenderCityName" HeaderText="Sender City" ReadOnly="True" SortExpression="SenderCityName" />
                            <asp:BoundField DataField="SenderPhoneMobile" HeaderText="Sender Mobile" ReadOnly="True" SortExpression="SenderPhoneMobile" />



                        </Fields>
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <EditRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                        <EmptyDataTemplate>
                            Remittance Not Found.
                        </EmptyDataTemplate>
                        <EmptyDataRowStyle Font-Size="Large" Font-Bold="true" ForeColor="Red" CssClass="Panel1" />
                    </asp:DetailsView>
                </div>
            </asp:Panel>

        </ContentTemplate>
        <%--<Triggers>
            <asp:PostBackTrigger ControlID="cmdDownload" />
        </Triggers>--%>
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
