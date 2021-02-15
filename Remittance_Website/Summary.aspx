<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="Remittance.Summary" CodeFile="Summary.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        .WaterMark
        {
            color: Silver;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Remittance Payment Summary Report
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table style="background-color: #F5FEC5; padding: 2px; background-image: url('Images/bg4.gif');
                background-position: top; border: solid 1px silver; background-repeat: repeat-x;">
                <tr>
                    <td>
                        <table style="font-size: small">
                            <tr>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    Payment Date
                                </td>
                                <td>
                                    <asp:TextBox ID="txtDateFrom" runat="server" Width="80px" AutoPostBack="true"></asp:TextBox>
                                    <asp:TextBoxWatermarkExtender ID="txtDateFrom_TextBoxWatermarkExtender" WatermarkText="dd/mm/yyyy"
                                        WatermarkCssClass="WaterMark" runat="server" Enabled="True" TargetControlID="txtDateFrom">
                                    </asp:TextBoxWatermarkExtender>
                                    <asp:CalendarExtender ID="txtDateFrom_CalendarExtender" runat="server" CssClass="cal_Theme1"
                                        Enabled="True" Format="dd/MM/yyyy" TargetControlID="txtDateFrom">
                                    </asp:CalendarExtender>
                                    <asp:MaskedEditExtender ID="txtDateFrom_MaskedEditExtender" runat="server" Enabled="True"
                                        Mask="99/99/9999" MaskType="Date" TargetControlID="txtDateFrom">
                                    </asp:MaskedEditExtender>
                                    <asp:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="txtDateFrom_MaskedEditExtender"
                                        InvalidValueBlurredMessage="Invalid" InvalidValueMessage="Invalid" ControlToValidate="txtDateFrom"></asp:MaskedEditValidator>
                                </td>
                                <td>
                                    to
                                </td>
                                <td>
                                    <asp:TextBox ID="txtDateTo" runat="server" Width="80px" AutoPostBack="true"></asp:TextBox>
                                    <asp:TextBoxWatermarkExtender ID="txtDateTo_TextBoxWatermarkExtender" WatermarkText="dd/mm/yyyy"
                                        WatermarkCssClass="WaterMark" runat="server" Enabled="True" TargetControlID="txtDateTo">
                                    </asp:TextBoxWatermarkExtender>
                                    <asp:CalendarExtender ID="txtDateTo_CalendarExtender" runat="server" CssClass="cal_Theme1"
                                        Enabled="True" Format="dd/MM/yyyy" TargetControlID="txtDateTo">
                                    </asp:CalendarExtender>
                                    <asp:MaskedEditExtender ID="txtDateTo_MaskedEditExtender" runat="server" Enabled="True"
                                        Mask="99/99/9999" MaskType="Date" TargetControlID="txtDateTo">
                                    </asp:MaskedEditExtender>
                                    <asp:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="txtDateTo_MaskedEditExtender"
                                        InvalidValueBlurredMessage="Invalid" InvalidValueMessage="Invalid" ControlToValidate="txtDateTo"></asp:MaskedEditValidator>
                                </td>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    To Branch:
                                </td>
                                <td>
                                    <asp:DropDownList ID="cboBranch" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                        DataSourceID="SqlDataSourceBranch" DataTextField="BranchName" DataValueField="BranchID"
                                        OnDataBound="cboBranch_DataBound" OnSelectedIndexChanged="cboBranch_SelectedIndexChanged">
                                        <asp:ListItem Value="-2" Text="All"></asp:ListItem>
                                        <asp:ListItem Value="-1" Text="Branch Assigned"></asp:ListItem>
                                        <asp:ListItem Value="-3" Text="All Branch (Except Head Office)"></asp:ListItem>
                                        <asp:ListItem Value="0" Text="No Branch Assigned"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Head Office"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="SELECT [BranchID], [BranchName] FROM [V_BranchOnly] ORDER by BranchName">
                                    </asp:SqlDataSource>
                                </td>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    <asp:Label ID="lblRoutingBank" runat="server" Text="Routing Bank:"></asp:Label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="cboRoutingBank" runat="server" AppendDataBoundItems="true"
                                        AutoPostBack="true" DataSourceID="SqlDataSourceRoutingBank" DataTextField="Bank_Name"
                                        DataValueField="BEFTN_Bank_Code">
                                        <asp:ListItem Text="All" Value="-1"></asp:ListItem>
                                        <asp:ListItem Text="Only with Routing Codes" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourceRoutingBank" runat="server" ConnectionString="<%$ ConnectionStrings:TblUserDBConnectionString %>"
                                        SelectCommand="sp_BEFTN_Banks" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                                </td>
                                <td style="padding: 0px 10px 0px 10px">
                                    <asp:Button ID="cmdFilter" runat="server" Text="Show" Width="100px" Font-Bold="true" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <br />
            <asp:GridView ID="GridView1" runat="server" BackColor="White" AllowPaging="True"
                Width="450px" AllowSorting="True" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                CellPadding="4" ForeColor="Black" AutoGenerateColumns="False" DataSourceID="SqlDataSource1"
                Style="font-size: small; font-family: Arial" 
                ondatabound="GridView1_DataBound1" ShowFooter="True">
                <RowStyle BackColor="#F7F7DE" CssClass="Grid" VerticalAlign="Top" />
                <Columns>
                    <asp:BoundField DataField="PaidOn" HeaderText="Paid On" SortExpression="PaidOn" ItemStyle-HorizontalAlign="Center"
                        ReadOnly="true">
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Currency" HeaderText="Currency" SortExpression="Currency"
                        ItemStyle-HorizontalAlign="Center">
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Total" HeaderText="Total" SortExpression="Total" ReadOnly="true"
                        ItemStyle-HorizontalAlign="Center">
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Amount" HeaderText="Amount" ReadOnly="true" ItemStyle-HorizontalAlign="Right"
                        DataFormatString="{0:N2}" SortExpression="Amount">
                    <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                </Columns>
                <FooterStyle BackColor="#CCCC99" CssClass="Grid" HorizontalAlign="Right" Font-Bold="true" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                <PagerSettings Position="TopAndBottom" Mode="NumericFirstLast" />
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="false" ForeColor="White" />
                <AlternatingRowStyle BackColor="White" />
                <EmptyDataTemplate>
                    <div style="border: solid 1px silver; padding: 10px; background-color: #F6F6F6">
                        No Data Found.</div>
                </EmptyDataTemplate>
                <EditRowStyle BackColor="#C5E2FD" />
            </asp:GridView>
            <asp:HiddenField ID="hidRoutingMsg" runat="server" Value="" />
            <br />
            <asp:Label ID="lblStatus" runat="server" Text="" Style="font-size: small"></asp:Label>
            <br />
            <asp:Button ID="cmdExport" runat="server" Text="Export" Width="120px" Font-Bold="true"
                Height="30px" OnClick="cmdExport_Click" Visible="false" />
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_RemiList_Summary" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected"
                OnUpdated="SqlDataSource1_Updated">
                <SelectParameters>
                    <asp:ControlParameter ControlID="cboBranch" Name="ToBranch" PropertyName="SelectedValue"
                        Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                    <asp:ControlParameter ControlID="cboRoutingBank" Name="RoutingBank" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                    <asp:ControlParameter ControlID="txtDateFrom" Name="DateFrom" PropertyName="Text"
                        Type="DateTime" DefaultValue="" />
                    <asp:ControlParameter ControlID="txtDateTo" Name="DateTo" PropertyName="Text" Type="DateTime" />
                </SelectParameters>
            </asp:SqlDataSource>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="cmdExport" />
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
        UseAnimation="false" VerticalSide="Middle">
    </asp:AlwaysVisibleControlExtender>
</asp:Content>
