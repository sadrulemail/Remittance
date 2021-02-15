<%@ Page Title="Transfast Orders Download" Language="C#" AutoEventWireup="true"
    Inherits="Remittance.TfComplaints" MasterPageFile="~/MasterPage.master" CodeFile="TfComplaints.aspx.cs" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text="Complaints Response Status"></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
       


             <div class="group" style="display: table">
                <h2>Complaints  Status update to Remilist
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
                                   
                                    <asp:LinkButton runat="server" ID="lnkCanceled" Style="margin-left: 7px" ToolTip="Cancel Orders"
                                        CommandName="CANCELED" CommandArgument='<%#Eval("ID")+ ";" +Eval("RefOrderReceipt")%>'
                                        CssClass="button1" ValidationGroup="Cancel">Status Update</asp:LinkButton>
                                    <asp:ConfirmButtonExtender runat="server" ID="conReceived" TargetControlID="lnkCanceled"
                                        ConfirmText="Do you want to Update Status to Remilist?"></asp:ConfirmButtonExtender>
                                 <%--   <asp:SqlDataSource ID="SqlDataSourceCancelStatus" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="SELECT  TfCode,TfCodeDesc FROM TfErrorCode"></asp:SqlDataSource>--%>
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
