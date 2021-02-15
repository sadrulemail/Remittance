<%@ Page Title="Transfast Orders Download" Language="C#" AutoEventWireup="true"
    Inherits="Remittance.TfDashboard" MasterPageFile="~/MasterPage.master" CodeFile="TfDashboard.aspx.cs" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text="Transfast Orders Download"></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="margin-bottom: 20px; float: right; max-width: 65%;">

                 <div class="box-widget-outer">
                    <div class="box-widget">
                        <div class="box-widget-header">Tf Paid Fail</div>
                        <div class="box-widget-value">
                            <asp:Literal ID="litTfPaidFail" runat="server" Text=""></asp:Literal>
                        </div>
                    </div>
                     <%--<div class="box-widget">
                        <div><a class="box-widget-anchor" href='RiaOPRollBack.aspx' target="_blank">Rollback Pending (OP)</a></div>
                        <div class="box-widget-value">
                            <asp:Literal ID="litRollBackPending" runat="server" Text=""></asp:Literal>
                        </div>
                    </div>--%>
                  
                </div>

               <%-- <div class="box-widget-outer" >
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
                </div>--%>

                <div class="box-widget-outer">
                    <div class="box-widget">
                        <div class="box-widget-header">Tf Paid Pending</div>
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

            </div>



            <div class="group" style="display: table">


                <h2>Orders Download Pending</h2>

                <div class="group-body">
                    <div>
                        Third Party Bank Deposit (Tick) &nbsp
                    <asp:CheckBox ID="chkBoxTrdParty" runat="server" />
                    </div>
                    <asp:Button ID="lbtnOrderDownload" runat="server" OnClick="lbtnOrderDownload_Click" Text="Download New Orders"></asp:Button>
                    <asp:ConfirmButtonExtender runat="server" ID="conDwnload" TargetControlID="lbtnOrderDownload"
                        ConfirmText="Do you want to Download new Orders?"></asp:ConfirmButtonExtender>
                    <asp:Button ID="btnAllOrder" runat="server" Text="Download All Orders" OnClick="btnAllOrder_Click"></asp:Button>
                    <asp:ConfirmButtonExtender runat="server" ID="conDwnloadAll" TargetControlID="btnAllOrder"
                        ConfirmText="Do you want to Download all  Orders which is not mark as paid or cancel?"></asp:ConfirmButtonExtender>

                </div>
            </div>

             <div class="group" style="display: table">
                <h2>Order Cencel  Pending
                </h2>
                <div>
                   
                    <asp:GridView ID="gdvCancel" runat="server" AllowPaging="True" Visible="true" AllowSorting="True"
                        AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" OnRowCommand="gdvCancel_RowCommand"
                        PagerSettings-PageButtonCount="30" BorderWidth="1px" CellPadding="4" DataKeyNames="ID"
                        DataSourceID="SqlDataSourceCancel" PageSize="20" ForeColor="Black" GridLines="Vertical"
                        CssClass="Grid" PagerSettings-Position="TopAndBottom">
                        <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                        <Columns>
                            <asp:BoundField DataField="ExHouseCode" HeaderText="ExHouse Code" SortExpression="ExHouseCode" Visible="false" />
                            <%-- <asp:BoundField DataField="ID" HeaderText="RID" ReadOnly="True" SortExpression="ID" />--%>
                            <asp:TemplateField HeaderText="RID" ItemStyle-HorizontalAlign="Center" SortExpression="ID">
                                <ItemTemplate>
                                    <b><a href='Remittance_Show.aspx?id=<%# Eval("ID") %>' title="View Remittance" target="_blank">
                                        <%# Eval("ID") %></a></b><a name='<%# Eval("ID","{0}") %>'></a>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                              <asp:BoundField DataField="RefOrderReceipt" HeaderText="Order No" ReadOnly="True" SortExpression="RefOrderReceipt" />
                            <asp:BoundField DataField="BeneficiaryName" HeaderText="Beneficiary Name" SortExpression="BeneficiaryName" />
                            <asp:BoundField DataField="BeneficiaryAddress" HeaderText="BeneficiaryAddress" SortExpression="BeneficiaryAddress" Visible="false" />

                            <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" ItemStyle-CssClass="center" />
                            <asp:BoundField DataField="Paid" HeaderText="Paid" SortExpression="Paid" ItemStyle-CssClass="center" />
                          
                            <asp:BoundField DataField="Published" HeaderText="Published" SortExpression="Published" ItemStyle-CssClass="center" />
                            <asp:BoundField DataField="StatusName" HeaderText="Process Status" SortExpression="StatusName" />
                             <asp:BoundField DataField="RoutingNumber" HeaderText="Routing Number" SortExpression="RoutingNumber" />
                             <asp:BoundField DataField="Currency" HeaderText="Currency" SortExpression="Currency"
                                ItemStyle-HorizontalAlign="Center" />
                            <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" ItemStyle-HorizontalAlign="Right"
                                ItemStyle-Font-Bold="true" DataFormatString="{0:N2}" />
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:DropDownList ID="ddlReqType" runat="server" DataSourceID="SqlDataSourceCancelStatus"
                                        AppendDataBoundItems="true" DataTextField="TfCodeDesc" DataValueField="TfCode">
                                        <asp:ListItem Text="Select Cancel Code" Value=""></asp:ListItem>
                                    </asp:DropDownList>
                                    <%--       <asp:RequiredFieldValidator ID="RequiredFieldValidatorType"
                                        runat="server" ErrorMessage="*" ControlToValidate="ddlReqType" ValidationGroup="Cancel"></asp:RequiredFieldValidator>--%>
                                    <asp:TextBox runat="server" ID="txtComments" placeholder="Comments"
                                        ValidationGroup="Cancel" MaxLength="255" Width="200px"></asp:TextBox>
                                    <%--  <asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                                        runat="server" ErrorMessage="*" ControlToValidate="ddlReqType" ValidationGroup="Comment"></asp:RequiredFieldValidator>--%>
                                    <asp:LinkButton runat="server" ID="lnkCanceled" Style="margin-left: 7px" ToolTip="Cancel Orders"
                                        CommandName="CANCELED" CommandArgument='<%#Eval("ID")+ ";" +Eval("RefOrderReceipt")%>'
                                        CssClass="button1" ValidationGroup="Cancel">Cancel Request</asp:LinkButton>
                                    <asp:ConfirmButtonExtender runat="server" ID="conReceived" TargetControlID="lnkCanceled"
                                        ConfirmText="Do you want to Canceled the Orders?"></asp:ConfirmButtonExtender>
                                    <asp:SqlDataSource ID="SqlDataSourceCancelStatus" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="SELECT  TfCode,TfCodeDesc FROM TfErrorCode"></asp:SqlDataSource>
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
                SelectCommand="s_Tf_CancelOrderListSelect" SelectCommandType="StoredProcedure" OnSelected="SqlDataSourceCancel_Selected"></asp:SqlDataSource>


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
