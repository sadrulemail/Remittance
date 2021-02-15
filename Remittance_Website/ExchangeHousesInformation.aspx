<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="Remittance.ExchangeHousesInformation"
    Title="Untitled Page" CodeFile="ExchangeHousesInformation.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .style1
        {
            width: 22px;
        }
        .style2
        {
            width: 22px;
            font-weight: bold;
            text-align: center;
        }
        .style3
        {
            text-align: center;
        }
        .style5
        {
            width: 79px;
            text-align: center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Exchange House Information
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="padding-left: 50px">
                               <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
                    CssClass="Grid" BorderColor="#DEDFDE" BorderStyle="Solid" BorderWidth="1px"
                    CellPadding="4" DataSourceID="SqlDataSource2" ForeColor="Black" AllowSorting="True"
                    Font-Size="Small" DataKeyNames="ExHouseCode">
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                    <Columns>
                        <asp:BoundField DataField="ExHouseCode" HeaderText="ExHouse Code" ReadOnly="True"
                            ItemStyle-Font-Bold="true" SortExpression="ExHouseCode">
                            <ItemStyle Font-Bold="True" />
                        </asp:BoundField>                        
                        <asp:BoundField DataField="ExHouseName" HeaderText="ExHouse Name" SortExpression="ExHouseName" HeaderStyle-HorizontalAlign="left" />                        
                        <asp:BoundField DataField="ExHouseCountry" HeaderText="Country" SortExpression="ExHouseCountry" />
                        <asp:BoundField DataField="ExHousePIN" HeaderText="PIN Format" SortExpression="PIN" /> 
                        <asp:TemplateField HeaderText="Comments" SortExpression="Comments">
                            <ItemTemplate>
                                <%# Eval("Comments").ToString().Replace("\n", "<br />") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <FooterStyle BackColor="#CCCC99" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="false" ForeColor="White" />
                    <AlternatingRowStyle BackColor="White" />
                </asp:GridView><br />
                <asp:Label ID="lblStatus" runat="server" Text=""></asp:Label>
                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                    SelectCommand="SELECT * FROM [ExHouses] WHERE Active = 1 ORDER BY ExHouseCode" onselected="SqlDataSource2_Selected">
                </asp:SqlDataSource>
            </div>
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
