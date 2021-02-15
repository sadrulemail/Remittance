<%@ Page Title="RDS API Bank Deposit Orders" Language="C#" AutoEventWireup="true"
    Inherits="Remittance.APIBankDeposit" MasterPageFile="~/MasterPage.master" CodeFile="APIBankDeposit.aspx.cs" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text="RDS API Bank Deposit Orders"></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <%--  <div style="margin-bottom: 20px; float: right; max-width: 65%;">

                <div class="box-widget-outer">
                    <div class="box-widget">
                        <div class="box-widget-header">Receive Pending</div>
                        <div class="box-widget-value">
                            <asp:Literal ID="litReceivedPending" runat="server" Text=""></asp:Literal>
                        </div>
                    </div>
                    <div class="box-widget">
                        <div><a class="box-widget-anchor" href='RiaOPRollBack.aspx' target="_blank">Rollback Pending (OP)</a></div>
                        <div class="box-widget-value">
                            <asp:Literal ID="litRollBackPending" runat="server" Text=""></asp:Literal>
                        </div>
                    </div>
                   
                </div>

                <div class="box-widget-outer">
                    <div class="box-widget">
                        <div class="box-widget-header">Cencel Response Pending</div>
                        <div class="box-widget-value">
                            <asp:Literal ID="litCancelResponsePending" runat="server" Text=""></asp:Literal>
                        </div>
                    </div>
                    <div class="box-widget">
                        <div class="box-widget-header">Cancel Accepted Pending</div>
                        <div class="box-widget-value">
                            <asp:Literal ID="litCancelAcceptedPending" runat="server" Text=""></asp:Literal>
                        </div>
                    </div>
                </div>

                <div class="box-widget-outer">
                    <div class="box-widget">
                        <div class="box-widget-header">Paid Pending</div>
                        <div class="box-widget-value">
                            <asp:Literal ID="litPaidPending" runat="server" Text=""></asp:Literal>
                        </div>
                    </div>
                    <div class="box-widget">
                        <div class="box-widget-header">Publish Pending</div>
                        <div class="box-widget-value">
                            <asp:Literal ID="litPublishPending" runat="server" Text=""></asp:Literal>
                        </div>
                    </div>


                </div>
                <div class="box-widget-outer">
                    <div class="right" style="padding: 20px">
                        <asp:LinkButton ID="LinkButton1" runat="server" ToolTip="Refresh" OnClick="LinkButton1_Click"><img src="Images/Refresh.png" alt="" width="30" /></asp:LinkButton>
                    </div>
                </div>

            </div>--%>



            <div class="group" style="display: table">


                <h2>Receive Pending Orders</h2>
                <table>
                    <tr>
                        <td>
                            <table style="font-size: small" class="ui-corner-all Panel1">
                                <tr>
                                    <td>
                                        <table>
                                               <tr>
                                            <td style="padding-left: 10px; white-space: nowrap;">
                                                Ex-House:
                                                 <asp:DropDownList ID="cboExHouse" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                                    DataSourceID="SqlDataSourceBranch" DataTextField="ExHouseName" DataValueField="ExHouseCode"
                                                   >
                                                    <asp:ListItem Value="" Text="All"></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                    SelectCommand="SELECT [ExHouseCode],ExHouseCode +', '+[ExHouseName] as ExHouseName FROM [dbo].[ExHouses] WHERE ExHouse_Type='A' ORDER BY ExHouseName">
                                                </asp:SqlDataSource>
                                                 <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="cboExHouse" ValidationGroup="grpExHouse" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>

                                              <%--  Filter
                                                    <asp:TextBox ID="txtFilter" runat="server" Watermark="RefID or Order No"></asp:TextBox>
                                                     Date <asp:TextBox ID="txtDateFrom" runat="server" Width="80px" CssClass="Watermark Date"
                                                        Watermark="dd/mm/yyyy" AutoPostBack="true"></asp:TextBox>
                                                    to <asp:TextBox ID="txtDateTo" runat="server" Width="80px" CssClass="Watermark Date"
                                                        Watermark="dd/mm/yyyy" AutoPostBack="true"></asp:TextBox>
                                                      <asp:Button ID="btnSearch" runat="server" Text="Show" OnClick="btnSearch_Click" />
                                                     <asp:Button ID="btnReceive" runat="server" Text="Receive ExHouse Wise" OnClick="btnReceive_Click" />--%>
                                            </td>
                                            
                                           
                                        </tr>
                                            <tr>
                                                <td>Filter
                                                    <asp:TextBox ID="txtFilter" runat="server" Watermark="RefID or Order No"></asp:TextBox>
                                                     Date <asp:TextBox ID="txtDateFrom" runat="server" Width="80px" CssClass="Watermark Date"
                                                        Watermark="dd/mm/yyyy" AutoPostBack="true"></asp:TextBox>
                                                    to <asp:TextBox ID="txtDateTo" runat="server" Width="80px" CssClass="Watermark Date"
                                                        Watermark="dd/mm/yyyy" AutoPostBack="true"></asp:TextBox>
                                                      <asp:Button ID="btnSearch" runat="server" Text="Show" OnClick="btnSearch_Click" />
                                                     <asp:Button ID="btnReceive" runat="server" Text="Receive ExHouse Wise" ValidationGroup="grpExHouse" OnClick="btnReceive_Click" />
                                                   
                                                </td>
                                               


                                            </tr>
                                          

                                        </table>

                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td style="padding-left: 10px">
                          <%--  <asp:Button ID="btnSearch" runat="server" Text="Show" OnClick="btnSearch_Click" />--%>
                        </td>
                    </tr>
                </table>

                <div>

                    <%--  <asp:Button ID="lbtnOrderDownload" runat="server" OnClick="lbtnOrderDownload_Click" Text="Get New Orders"></asp:Button>--%>

                    <asp:GridView ID="gdvOrdersReceived" runat="server" AllowPaging="True" Visible="true" AllowSorting="True"
                        AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" OnRowCommand="gdvOrdersReceived_RowCommand" OnSelectedIndexChanged="gdvOrdersReceived_SelectedIndexChanged"
                        PagerSettings-PageButtonCount="30" BorderWidth="1px" CellPadding="4" DataKeyNames="SessionID,ReceiverCurrencyCode"
                        DataSourceID="SqlDataSource1" PageSize="20" ForeColor="Black" GridLines="Vertical"
                        CssClass="Grid" PagerSettings-Position="TopAndBottom">
                        <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                        <Columns>
                            <asp:TemplateField HeaderText="SessionID" SortExpression="SessionID">
                                <ItemTemplate>
                                    <asp:LinkButton ID="cmdViewOrders" runat="server" CausesValidation="False" CommandName="Select"
                                        Text='<%# Eval("SessionID") %>'
                                        ToolTip="Orders">
                                    </asp:LinkButton>
                                    
                                </ItemTemplate>
                                <ItemStyle Font-Names="courier" CssClass="bold" />
                            </asp:TemplateField>
                            <%--  <asp:BoundField DataField="SessionID" HeaderText="SessionID" SortExpression="SessionID" Visible="true" />--%>
                            <asp:BoundField DataField="ExHouseCode" HeaderText="ExHouse Code" ReadOnly="True" SortExpression="ExHouseCode" />
                            <asp:BoundField DataField="NoOfOrder" HeaderText="No of Order" ReadOnly="True" SortExpression="NoOfOrder" ItemStyle-CssClass="center" />

                            <asp:BoundField DataField="ReceiverCurrencyCode" HeaderText="Currency" SortExpression="ReceiverCurrencyCode"
                                ItemStyle-HorizontalAlign="Center" />
                            <asp:BoundField DataField="PaymentAmount" HeaderText="Amount" SortExpression="PaymentAmount" ItemStyle-HorizontalAlign="Right"
                                ItemStyle-Font-Bold="true" DataFormatString="{0:N2}" />
                            <asp:TemplateField HeaderText="Date" SortExpression="InsertDT">
                                <ItemTemplate>
                                    <%#Eval("InsertDT", "{0:dd-MM-yyyy}") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%-- <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" ItemStyle-CssClass="center" />--%>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" ID="lnkReceived" Style="margin-left: 7px" ToolTip="Receive Orders"
                                        CommandName="RECEIVED" CommandArgument='<%#Eval("SessionID") + ";" +Eval("ReceiverCurrencyCode")+ ";" +Eval("ExHouseCode")%>'
                                        CssClass="button1" ValidationGroup="Cancel">Receive</asp:LinkButton>
                                    <asp:ConfirmButtonExtender runat="server" ID="conReceived" TargetControlID="lnkReceived"
                                        ConfirmText="Do you want to Receive the Orders?"></asp:ConfirmButtonExtender>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Left" Wrap="false" />
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>

                                    <%--       <span id="idCancelreason" class="hidden">--%>
                                    <asp:TextBox runat="server" ID="txtOrderRejectReason" placeholder="reject reason"
                                        ValidationGroup="grvReject" MaxLength="255" Width="200px"></asp:TextBox>
                                    <%--<asp:RequiredFieldValidator ID="rfvCancelReason" ControlToValidate="txtOrderRejectReason"
                                            runat="server"  ValidationGroup="grvReject" 
                                            ErrorMessage="*" ForeColor="Red" Font-Bold="true"></asp:RequiredFieldValidator>--%>

                                    <asp:LinkButton runat="server" ID="lnkReject" Style="margin-left: 7px" ToolTip="Reject Orders"
                                        CommandName="REJECT" CommandArgument='<%#Eval("SessionID") + ";" +Eval("ReceiverCurrencyCode")+ ";" +Eval("ExHouseCode")%>'
                                        CssClass="button1" ValidationGroup="grvReject">Reject</asp:LinkButton>
                                    <asp:ConfirmButtonExtender runat="server" ID="conReject" TargetControlID="lnkReject"
                                        ConfirmText="Do you want to Reject the Orders?"></asp:ConfirmButtonExtender>

                                    <%--  </span>

                                    <span style="white-space: nowrap">
                                        <a href="" id="cancelBtnclient" onclick='$("#idCancelreason").show();$(this).hide();$("#cancelCloseBtnclient").show();return false'>
                                            <img src="Images/delete.png" width="16" height="16" border="0" /></a> <a href=""
                                                class="hidden" id="cancelCloseBtnclient" onclick='$("#idCancelreason").hide();$(this).hide();$("#cancelBtnclient").show();return false'>Close</a>

                                    </span>--%>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Left" Wrap="false" />
                            </asp:TemplateField>
                        </Columns>
                        <FooterStyle BackColor="#CCCC99" />
                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <AlternatingRowStyle BackColor="White" />
                    </asp:GridView>
                    <asp:Label ID="lblStatus" runat="server" Text="" Font-Size="Small"></asp:Label>
                </div>
            </div>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="s_API_BankDepositOrderSelect" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected">
                <SelectParameters>
                      <asp:ControlParameter ControlID="cboExHouse" Name="ExHouseCode" PropertyName="SelectedValue"
                            Type="String" ConvertEmptyStringToNull="true" DefaultValue="-1" />
                    <asp:ControlParameter ControlID="txtFilter" Name="Filter" PropertyName="Text"
                        Type="String" DefaultValue="*" />
                    <asp:ControlParameter ControlID="txtDateFrom" Name="FromDate" DefaultValue='01/01/1900'
                        PropertyName="Text" Type="DateTime" />
                    <asp:ControlParameter ControlID="txtDateTo" Name="ToDate" DefaultValue='01/01/1900'
                        PropertyName="Text" Type="DateTime" />
                </SelectParameters>
            </asp:SqlDataSource>
            <%-------------------------------Start Modal-----------------------------------------------------------%>
            <span style="visibility: hidden">
                <asp:Button runat="server" ID="cmdPopup" /></span>
            <asp:ModalPopupExtender ID="modal" runat="server" CancelControlID="ModalClose" TargetControlID="cmdPopup"
                PopupControlID="ModalPanel" BackgroundCssClass="ModalPopupBG" PopupDragHandleControlID="ModalTitleBar"
                RepositionMode="RepositionOnWindowResize" X="-1" Y="20" CacheDynamicResults="False"
                Drag="True">
            </asp:ModalPopupExtender>
            <asp:Panel ID="ModalPanel" runat="server" CssClass="Panel1 ui-corner-all" Width="96%">
                <div style="padding: 5px">
                    <table width="100%">
                        <tr>
                            <td></td>
                            <td align="right">
                                <asp:Image ID="ModalClose" runat="server" ImageUrl="~/Images/close.gif" ToolTip="Close"
                                    Style="cursor: pointer" Width="21px" Height="21px" />
                            </td>
                        </tr>
                    </table>

                    <asp:GridView ID="gdvOrdersDetails" runat="server" AllowPaging="True" Visible="true" AllowSorting="True"
                        AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None"
                        PagerSettings-PageButtonCount="30" BorderWidth="1px" CellPadding="2"
                        DataSourceID="SqlDataSourceOrdersView" PageSize="20" ForeColor="Black" GridLines="Vertical"
                        CssClass="Grid" PagerSettings-Position="TopAndBottom">
                        <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                        <Columns>

                            <asp:TemplateField HeaderText="SessionID">
                                <ItemTemplate>
                                    <div title="SessionID">
                                        <%#Eval("SessionID") %>
                                    </div>
                                    <div title="RefID">
                                        <%#Eval("RefID") %>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="OrderID" HeaderText="Order No" SortExpression="OrderID" Visible="true" />


                            <asp:TemplateField HeaderText="Sender Name">
                                <ItemTemplate>
                                    <div title="Sender Name">
                                        <%#Eval("SenderName") %>
                                    </div>
                                    <div title="Sender Country Code">
                                        <%#Eval("SenderCountryCode") %>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="ReceiverName" HeaderText="ReceiverName" ReadOnly="True" SortExpression="ReceiverName" />
                            <asp:TemplateField HeaderText="Receiver Address">
                                <ItemTemplate>
                                    <div title="Name">
                                        <%#Eval("ReceiverName") %>
                                    </div>
                                    <div title="Address">
                                        <%#Eval("ReceiverAddress") %>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="ReceiverCurrencyCode" HeaderText="ReceiverCurrency" SortExpression="ReceiverCurrencyCode"
                                ItemStyle-HorizontalAlign="Center" />
                            <asp:BoundField DataField="ReceiverAmount" HeaderText="Receiver Amount" SortExpression="ReceiverAmount" ItemStyle-HorizontalAlign="Right"
                                ItemStyle-Font-Bold="true" DataFormatString="{0:N2}" />
                            <asp:TemplateField HeaderText="Routing Code">
                                <ItemTemplate>
                                    <div title="Routing Code">
                                        <%#Eval("RoutingCode") %>
                                    </div>
                                    <div title="Account No">
                                        <%#Eval("AccountNumber") %>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date" SortExpression="InsertDT">
                                <ItemTemplate>
                                    <%#Eval("InsertDT", "{0:dd-MM-yyyy}") %>
                                </ItemTemplate>
                            </asp:TemplateField>



                        </Columns>
                        <EmptyDataTemplate>No data found</EmptyDataTemplate>
                        <FooterStyle BackColor="#CCCC99" />
                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <AlternatingRowStyle BackColor="White" />
                    </asp:GridView>
                    <asp:Label ID="lblOrdersNo" runat="server" Text="" Font-Size="Small"></asp:Label>

                </div>
            </asp:Panel>
            <asp:SqlDataSource ID="SqlDataSourceOrdersView" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="s_API_OrdersView" SelectCommandType="StoredProcedure" OnSelected="SqlDataSourceOrdersView_Selected">
                <SelectParameters>
                    <asp:ControlParameter ControlID="gdvOrdersReceived" Name="SessionID" PropertyName="SelectedValue" />
                    <asp:ControlParameter ControlID="gdvOrdersReceived" Name="ReceiverCurrencyCode" PropertyName="SelectedValue" />
                </SelectParameters>

            </asp:SqlDataSource>
            <%-----------------------------------------------------End Modal------------------------------------------------%>

            <div class="group" style="display: table">
                <h2>Order Cencel Response Pending
                </h2>
                <div>

                    <asp:GridView ID="gdvCancel" runat="server" AllowPaging="True" Visible="true" AllowSorting="True"
                        AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" OnRowCommand="gdvCancel_RowCommand"
                        PagerSettings-PageButtonCount="30" BorderWidth="1px" CellPadding="4" DataKeyNames="SL"
                        DataSourceID="SqlDataSourceCancel" PageSize="20" ForeColor="Black" GridLines="Vertical"
                        CssClass="Grid" PagerSettings-Position="TopAndBottom">
                        <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                        <Columns>
                            <asp:BoundField DataField="SL" HeaderText="ID" ReadOnly="True" SortExpression="SL" />
                            <asp:BoundField DataField="ExHouseCode" HeaderText="ExHouse Code" SortExpression="ExHouseCode" Visible="false" />
                            <asp:BoundField DataField="RefID" HeaderText="RefID" ReadOnly="True" SortExpression="RefID" />
                            <asp:BoundField DataField="OrderID" HeaderText="Order No" ReadOnly="True" SortExpression="OrderID" />
                            <asp:TemplateField HeaderText="RID" ItemStyle-HorizontalAlign="Center" SortExpression="ID">
                                <ItemTemplate>
                                    <b><a href='Remittance_Show.aspx?id=<%# Eval("ID") %>' title="View Remittance" target="_blank">
                                        <%# Eval("ID") %></a></b><a name='<%# Eval("ID","{0}") %>'></a>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="ReceiverName" HeaderText="Receiver Name" SortExpression="ReceiverName" />
                            <asp:BoundField DataField="ReceiverCurrencyCode" HeaderText="Currency" SortExpression="ReceiverCurrencyCode" ItemStyle-CssClass="center" />
                            <asp:BoundField DataField="ReceiverAmount" HeaderText="Amount" SortExpression="ReceiverAmount" ItemStyle-HorizontalAlign="Right"
                                ItemStyle-Font-Bold="true" DataFormatString="{0:N2}" />
                            <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" ItemStyle-CssClass="center" />
                            <asp:BoundField DataField="Paid" HeaderText="Paid" SortExpression="Paid" ItemStyle-CssClass="center" />
                            <asp:TemplateField HeaderText="Date">
                                <ItemTemplate>
                                    <%#Eval("InsertDT", "{0:dd-MM-yyyy}") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:DropDownList ID="ddlReqType" runat="server" DataSourceID="SqlDataSourceCancelStatus"
                                        AppendDataBoundItems="true" DataTextField="Status" DataValueField="StatusID">
                                        <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                    </asp:DropDownList>
                                    <%--       <asp:RequiredFieldValidator ID="RequiredFieldValidatorType"
                                        runat="server" ErrorMessage="*" ControlToValidate="ddlReqType" ValidationGroup="Cancel"></asp:RequiredFieldValidator>--%>
                                    <asp:TextBox runat="server" ID="txtComments" placeholder="Comments"
                                        ValidationGroup="Cancel" MaxLength="255" Width="200px"></asp:TextBox>
                                    <%--  <asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                                        runat="server" ErrorMessage="*" ControlToValidate="ddlReqType" ValidationGroup="Comment"></asp:RequiredFieldValidator>--%>
                                    <asp:LinkButton runat="server" ID="lnkCanceled" Style="margin-left: 7px" ToolTip="Cancel Orders"
                                        CommandName="CANCELED" CommandArgument='<%#Eval("SL")%>'
                                        CssClass="button1" ValidationGroup="Cancel">Response</asp:LinkButton>
                                    <asp:ConfirmButtonExtender runat="server" ID="conReceived" TargetControlID="lnkCanceled"
                                        ConfirmText="Do you want to Canceled the Orders?"></asp:ConfirmButtonExtender>
                                    <asp:SqlDataSource ID="SqlDataSourceCancelStatus" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="SELECT StatusID,Status FROM [Remittance].[dbo].[StatusRemilist] WHERE StatusID IN ( 8, 9 )"></asp:SqlDataSource>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Left" Wrap="false" />
                            </asp:TemplateField>
                        </Columns>
                        <FooterStyle BackColor="#CCCC99" />
                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <AlternatingRowStyle BackColor="White" />
                    </asp:GridView>
                    <asp:Label ID="LabelCancel" runat="server" Text="" Font-Size="Small"></asp:Label>
                </div>
            </div>

            <asp:SqlDataSource ID="SqlDataSourceCancel" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="s_API_CancelOrdersNoSelect" SelectCommandType="StoredProcedure" OnSelected="SqlDataSourceCancel_Selected"></asp:SqlDataSource>
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
