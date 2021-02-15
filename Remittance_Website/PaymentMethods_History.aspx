<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="Remittance.PaymentMethods_History" Title="Untitled Page" CodeFile="PaymentMethods_History.aspx.cs" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Payment Methods Change History
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource1" CssClass="Grid"
                AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" PagerSettings-Mode="NumericFirstLast"
                PagerSettings-Position="TopAndBottom" BackColor="White" BorderColor="#DEDFDE" PageSize="20" PagerSettings-PageButtonCount="30"
                BorderStyle="None" BorderWidth="1px" CellPadding="4" DataKeyNames="SL" ForeColor="Black"
                GridLines="Vertical">
                <RowStyle BackColor="#F7F7DE" />
                <Columns>
                    <asp:BoundField DataField="SL" HeaderText="#" InsertVisible="False" ReadOnly="True"
                        SortExpression="SL" ItemStyle-HorizontalAlign="Center" ItemStyle-ForeColor="Silver" />
                    <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" SortExpression="PaymentMethod" ItemStyle-Font-Bold="true" />
                    <asp:BoundField DataField="PaymentMethodDetails" HeaderText="Details" SortExpression="PaymentMethodDetails" />
                    <asp:TemplateField HeaderText="Allow Payment" SortExpression="AllowPayment">
                        <ItemTemplate>
                            <%# (Eval("AllowPayment").ToString() == "True") ? "<img src='Images/tick.png' width='20px' height='20px' title='Allowed'>" : "<img src='Images/cross.png' width='20px' height='20px' title='Not Allowed'>"%>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Changed on" SortExpression="AllowDT">
                        <ItemTemplate>
                            <span title='<%# Eval("AllowDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                <%# TrustControl1.ToRecentDateTime(Eval("AllowDT"))%></span>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="About" SortExpression="AllowDT">
                        <ItemTemplate>
                            <div class="time-small" title='<%# Eval("AllowDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                <time class="timeago" datetime='<%# Eval("AllowDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time></div>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="By" SortExpression="AllowBy">
                        <ItemTemplate>
                            <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("AllowBy") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                </Columns>
                <FooterStyle BackColor="#CCCC99" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                <AlternatingRowStyle BackColor="White" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_PaymentMethods_AllowPayment_Log_Browse" SelectCommandType="StoredProcedure">
            </asp:SqlDataSource>
        </ContentTemplate>
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
        UseAnimation="false" VerticalSide="Middle">
    </asp:AlwaysVisibleControlExtender>
</asp:Content>
