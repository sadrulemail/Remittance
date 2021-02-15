<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="Remittance.Flora_Export_Count" CodeFile="Flora_Export_Count.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Flora Export Ready Count
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table >
                <tr> 
                    <td>
                        <table class="SmallFont ui-corner-all Panel1">
                            <tr>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    To Branch:
                                </td>
                                <td>
                                    <asp:DropDownList ID="cboBranch" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                        DataSourceID="SqlDataSourceBranch" DataTextField="BranchName" 
                                        DataValueField="BranchID" ondatabound="cboBranch_DataBound">
                                        <asp:ListItem Value="-1" Text="All"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Head Office"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="SELECT [BranchID], [BranchName] FROM [V_BranchOnly] ORDER by BranchName">
                                    </asp:SqlDataSource>
                                </td>
                                <td style="padding-left: 2px">
                                    <asp:Button ID="cmdFilter" runat="server" Text="Filter" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
             
            <br />
            <asp:GridView ID="GridView1" runat="server" BackColor="White" AllowPaging="true"
                CssClass="Grid" AllowSorting="true" BorderColor="#DEDFDE" BorderStyle="None"
                BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Both" AutoGenerateColumns="False"
                PagerSettings-PageButtonCount="30" DataSourceID="SqlDataSource1" Style="font-size: small;
                font-family: Arial" Width="500px">
                <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                <Columns>
                    <asp:BoundField DataField="Currency" HeaderText="Currency" SortExpression="Currency"
                        ReadOnly="true" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="ExHouseCode" HeaderText="ExHouse Code" SortExpression="ExHouseCode"
                        ReadOnly="true" />
                    <asp:BoundField DataField="ExHouseName" HeaderText="ExHouse Name" SortExpression="ExHouseName"
                        ReadOnly="true" />
                    <asp:BoundField DataField="Total" HeaderText="Total" SortExpression="Total" ReadOnly="true"
                        ItemStyle-HorizontalAlign="Right" />
                </Columns>
                <FooterStyle BackColor="#CCCC99" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                <PagerSettings Position="TopAndBottom" Mode="NumericFirstLast" />
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="false" ForeColor="White" />
                <AlternatingRowStyle BackColor="White" />
                <EmptyDataTemplate>
                    <div style="border: solid 1px silver; padding: 10px; background-color: #F6F6F6; width: 500px">
                        No Data Found to Export to Flora.</div>
                </EmptyDataTemplate>
                <EditRowStyle BackColor="#C5E2FD" />
            </asp:GridView>
            <asp:HiddenField ID="hidRoutingMsg" runat="server" Value="" />
            <br />
            <asp:Label ID="lblStatus" runat="server" Text="" Style="font-size: small"></asp:Label>
            <br />
            <br />
            <asp:Button ID="cmdMarkPaid" runat="server" Text="Mark All as Paid" Width="200px"
                Font-Bold="true" Height="30px" Visible="false" />
            <asp:ConfirmButtonExtender ID="cmdMarkPaid_ConfirmButtonExtender" runat="server"
                ConfirmText="Do you want to mark all as Paid?" Enabled="True" TargetControlID="cmdMarkPaid">
            </asp:ConfirmButtonExtender>
            <asp:Panel ID="PanelStatusMarkPaid" runat="server" CssClass="Border" Visible="false"
                Width="300px">
                <asp:Label ID="lblStatusMarkPaid" runat="server" Text="" Font-Bold="true" Font-Size="Small"></asp:Label>
            </asp:Panel>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_Flora_Ready_To_Export" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="cboBranch" Name="ToBranch" PropertyName="SelectedValue"
                        Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                    
                </SelectParameters>
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
