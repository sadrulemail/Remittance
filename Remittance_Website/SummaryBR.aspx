<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="Remittance.SummaryBR" CodeFile="SummaryBR.aspx.cs" %>

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
    Remittance Payment Summary Report for Branch
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <table >
                            <tr>
                                <td>
                                    <table style="font-size: small" class="ui-corner-all Panel1">
                                        <tr>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                                Payment Date:
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtDateFrom" runat="server" Width="80px" CssClass="Watermark Date"
                                                    Watermark="dd/mm/yyyy" AutoPostBack="true"></asp:TextBox>
                                            </td>
                                            <td>
                                                to
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtDateTo" runat="server" Width="80px" CssClass="Watermark Date"
                                                    Watermark="dd/mm/yyyy" AutoPostBack="true"></asp:TextBox>
                                            </td>
                                </td>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    Method:
                                </td>
                                <td>
                                    <asp:DropDownList ID="cboPaymentMethod" AutoPostBack="True" runat="server" AppendDataBoundItems="true"
                                        DataSourceID="SqlDataSourcePaymentMethod" DataTextField="PaymentMethodDetails"
                                        DataValueField="PaymentMethod" OnDataBound="cboPaymentMethod_DataBound">
                                        <asp:ListItem Text="ALL" Value="-1"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourcePaymentMethod" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="SELECT * FROM [v_PaymentMethods] ORDER BY OrderCol" EnableCaching="true" CacheDuration="600"></asp:SqlDataSource>
                                </td>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    Paid Branch:
                                </td>
                                <td>
                                    <asp:DropDownList ID="cboBranch" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                        DataSourceID="SqlDataSourceBranch" DataTextField="BranchName" DataValueField="BranchID"
                                        OnDataBound="cboBranch_DataBound" OnSelectedIndexChanged="cboBranch_SelectedIndexChanged1">
                                        <asp:ListItem Value="-1" Text="All"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Head Office"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="SELECT [BranchID], [BranchName] FROM [V_BranchOnly] ORDER by BranchName">
                                    </asp:SqlDataSource>
                                    <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                        Status:
                                    </td>
                                <td>
                                    <asp:DropDownList ID="DropDownListStatus" runat="server" AutoPostBack="true" OnSelectedIndexChanged="DropDownListStatus_SelectedIndexChanged">
                                        <asp:ListItem Text="ACTIVE" Value="ACTIVE"></asp:ListItem>
                                        <asp:ListItem Text="ON HOLD" Value="ON HOLD"></asp:ListItem>
                                        <asp:ListItem Text="CANCEL" Value="CANCEL"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td style="padding: 0px 10px 0px 10px">
                                    <asp:Button ID="cmdFilter" runat="server" Text="Show" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            </td><td style="padding-left: 10px">
                <asp:LinkButton ID="cmdPreviousDay" runat="server" OnClick="cmdPreviousDay_Click"
                    CssClass="button1"><img src="Images/Previous.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                <asp:LinkButton ID="cmdNextDay" runat="server" OnClick="cmdNextDay_Click" CssClass="button1"><img src="Images/Next.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
            </td>
            </tr></table>
            <div style="margin:0px 0px 50px 10px">
            <table class="Panel1">
                <tr>
                    <td>
                        Currency:
                    </td>
                    <td>
                        <asp:RadioButtonList ID="radioCurrency" runat="server" AutoPostBack="true" DataSourceID="SqlDataSourceCurrecny"
                            DataTextField="Currency" DataValueField="Currency" RepeatDirection="Horizontal"
                            OnDataBound="radioCurrency_DataBound">
                        </asp:RadioButtonList>
                    </td>
                </tr>
            </table>
            <asp:SqlDataSource ID="SqlDataSourceCurrecny" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="SELECT * FROM [v_Currency]"></asp:SqlDataSource>
            <br />
            <asp:GridView ID="GridView1" runat="server" BackColor="White" AllowPaging="false"
                CssClass="Grid" Width="700px" AllowSorting="True" BorderColor="#DEDFDE" BorderStyle="None"
                BorderWidth="1px" CellPadding="4" ForeColor="Black" AutoGenerateColumns="False"
                DataSourceID="SqlDataSource1" Style="font-size: small; font-family: Arial" OnDataBound="GridView1_DataBound1"
                ShowFooter="True">
                <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                <Columns>
                    <asp:BoundField DataField="ExHouseCode" HeaderText="ExHouseCode" SortExpression="ExHouseCode"
                        ItemStyle-HorizontalAlign="Left" ReadOnly="true"></asp:BoundField>
                    <asp:BoundField DataField="ExHouseName" HeaderText="ExHouseName" SortExpression="ExHouseName"
                        ItemStyle-HorizontalAlign="Left" ReadOnly="true"></asp:BoundField>
                    <asp:BoundField DataField="Currency" HeaderText="Currency" SortExpression="Currency"
                        ItemStyle-HorizontalAlign="Center"></asp:BoundField>
                    <asp:BoundField DataField="Total" HeaderText="Total" SortExpression="Total" ReadOnly="true"
                        ItemStyle-HorizontalAlign="Center">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Amount" HeaderText="Amount" ReadOnly="true" ItemStyle-HorizontalAlign="Right"
                        DataFormatString="{0:N2}" SortExpression="Amount">
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" ItemStyle-HorizontalAlign="Center">
                    </asp:BoundField>                    
                    <asp:TemplateField>
                        <ItemTemplate>                                                        
                            <%# getLink(cboBranch.SelectedValue, Eval("Currency"), cboPaymentMethod.Text, Eval("ExHouseCode"), Eval("Status"), txtDateFrom.Text, txtDateTo.Text) %>                            
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField> 
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
            <asp:Button ID="cmdExport" runat="server" Text="Export to xlsx" Width="120px" Font-Bold="true"
                Height="30px" OnClick="cmdExport_Click" Visible="false" />
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_RemiList_Summary_BR" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected"
                OnUpdated="SqlDataSource1_Updated">
                <SelectParameters>
                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                    <asp:ControlParameter ControlID="txtDateFrom" Name="DateFrom" DefaultValue='01/01/1900'
                        PropertyName="Text" Type="DateTime" />
                    <asp:ControlParameter ControlID="txtDateTo" Name="DateTo" DefaultValue='01/01/1900'
                        PropertyName="Text" Type="DateTime" />
                    <asp:ControlParameter ControlID="cboBranch" Name="PaidBranch" PropertyName="SelectedValue"
                        Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                    <asp:ControlParameter ControlID="DropDownListStatus" Name="Status" PropertyName="SelectedValue"
                        Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
                    <asp:ControlParameter ControlID="cboPaymentMethod" Name="PaymentMethod" PropertyName="SelectedValue"
                        Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
                    <asp:ControlParameter ControlID="radioCurrency" Name="Currency" PropertyName="SelectedValue"
                        Type="String" ConvertEmptyStringToNull="true" DefaultValue="BDT" />
                </SelectParameters>
            </asp:SqlDataSource>
            </div>
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
