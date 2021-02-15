<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageChart.master" AutoEventWireup="true"
    Inherits="Remittance.Country_Wise_Summary_Report" CodeFile="Country_Wise_Summary_Report.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Country wise Summary Report
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="s_country_wise_summary_Reporting" SelectCommandType="StoredProcedure"
                OnSelected="SqlDataSource1_Selected"
                onselecting="SqlDataSource1_Selecting">
                <SelectParameters>
                    <asp:ControlParameter ControlID="txtDateFrom" Name="Fdate" PropertyName="Text" Type="DateTime"
                        ConvertEmptyStringToNull="true" DefaultValue="1/1/1900" />
                    <asp:ControlParameter ControlID="txtDateTo" Name="Tdate" PropertyName="Text" Type="DateTime"
                        ConvertEmptyStringToNull="true" DefaultValue="1/1/1900" />
                </SelectParameters>
            </asp:SqlDataSource>
            <table>
                <tr>
                    <td>
                        <table class="SmallFont Panel1">
                            <tr>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    Paid Date: from
                                </td>
                                <td>
                                    <asp:TextBox ID="txtDateFrom" runat="server" CssClass="Watermark Date" Watermark="dd/mm/yyyy"
                                        AutoPostBack="true" MaxLength="10" Width="80px"></asp:TextBox>
                                </td>
                                <td>
                                    to
                                </td>
                                <td>
                                    <asp:TextBox ID="txtDateTo" runat="server" CssClass="Watermark Date" Watermark="dd/mm/yyyy"
                                        AutoPostBack="true" MaxLength="10" Width="80px"></asp:TextBox>
                                </td>
                                <td style="padding-left: 2px">
                                    <asp:Button ID="cmdFilter" runat="server" Text="Show" 
                                        onclick="cmdFilter_Click" />
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="padding-left: 10px">
                        <asp:LinkButton ID="cmdPreviousDay" runat="server" OnClick="cmdPreviousDay_Click"
                            CssClass="button1"><img src="Images/Previous.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                        <asp:LinkButton ID="cmdNextDay" runat="server" OnClick="cmdNextDay_Click" CssClass="button1"><img src="Images/Next.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                    </td>
                </tr>
            </table>
            <br />
            <table>
                <tr>
                    <td valign="top">
                        <asp:GridView ID="GridView1" runat="server" BackColor="White" AllowPaging="false"
                            PageSize="15" CssClass="Grid" AllowSorting="true" BorderColor="#DEDFDE" BorderStyle="None"
                            BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Both" AutoGenerateColumns="False"
                            PagerSettings-PageButtonCount="30" DataSourceID="SqlDataSource1" Style="font-size: small;
                            font-family: Arial" OnDataBound="GridView1_DataBound">
                            <RowStyle BackColor="#F7F7DE" CssClass="Grid" VerticalAlign="Top" />
                            <Columns>
                                <asp:BoundField DataField="SL" HeaderText="SL" SortExpression="SL" />
                                <asp:BoundField DataField="CoverFund_CountryName" HeaderText="Country" SortExpression="CoverFund_CountryName" />
                                <asp:BoundField DataField="CoverFundCurrency" HeaderText="Currency" SortExpression="CoverFundCurrency" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="Total" HeaderText="Total" SortExpression="Total" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="Amount_FCY" HeaderText="Amount FCY" SortExpression="Amount_FCY"
                                    ItemStyle-HorizontalAlign="Right" DataFormatString="{0:N4}" />
                                <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" ItemStyle-HorizontalAlign="Right"
                                    DataFormatString="{0:N2}" />
                            </Columns>
                            <FooterStyle BackColor="#CCCC99" />
                            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                            <PagerSettings Position="TopAndBottom" Mode="NumericFirstLast" />
                            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#6B696B" Font-Bold="false" ForeColor="White" Font-Names="Arial Narrow" />
                            <AlternatingRowStyle BackColor="White" />
                            <EmptyDataTemplate>
                                <div style="border: solid 1px silver; padding: 10px; background-color: #F6F6F6; width: 500px">
                                    No Data Found.</div>
                            </EmptyDataTemplate>
                            <EditRowStyle BackColor="#C5E2FD" />
                        </asp:GridView>
                        <asp:HiddenField ID="hidRoutingMsg" runat="server" Value="" />
                        <br />
                        <asp:Label ID="lblStatus" runat="server" Text="" Style="font-size: small"></asp:Label><br />
                        <br />
                        <asp:Button ID="btn_xlsx" runat="server" Text="Download as xlsx" OnClick="btn_xlsx_Click" />
                    </td>
                    <td valign="top" style="padding-left:10px">
                        <asp:Panel ID="PanelChart" runat="server">
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btn_xlsx" />
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
