<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    Inherits="Remittance.SummaryHO" CodeFile="SummaryHO.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .WaterMark
        {
            color: Silver;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Remittance Payment Summary Report for Head Office
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <table class="ui-corner-all Panel1">
                            <tr>
                                <td>
                                    <table style="font-size: small">
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
                                                    SelectCommand="SELECT * FROM [v_PaymentMethods] ORDER BY OrderCol"></asp:SqlDataSource>
                                            </td>
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
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table>
                                        <tr>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                                Ex-House:
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="cboExHouse" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                                    DataSourceID="SqlDataSourceBranch" DataTextField="ExHouseName" DataValueField="ExHouseCode"
                                                    OnSelectedIndexChanged="cboExHouse_SelectedIndexChanged">
                                                    <asp:ListItem Value="-1" Text="All"></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                    SelectCommand="SELECT [ExHouseCode],ExHouseCode +', '+[ExHouseName] as ExHouseName FROM [v_ExHouseListDetails] ORDER BY ExHouseName">
                                                </asp:SqlDataSource>
                                            </td>
                                            <td style="padding: 0px 10px 0px 10px">
                                                <asp:Button ID="cmdFilter" runat="server" Text="Show" />
                                            </td>
                                        </tr>
                                    </table>
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
            <div style="margin: 0px 0px 50px 10px">
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
                    CssClass="Grid" Width="700px" AllowSorting="True" CellPadding="4" ForeColor="Black"
                    AutoGenerateColumns="False" DataSourceID="SqlDataSource1" Style="font-size: small;
                    font-family: Arial" OnDataBound="GridView1_DataBound1" ShowFooter="True" OnRowDataBound="GridView1_RowDataBound1">
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                    <Columns>
                        <asp:BoundField DataField="BranchName" HeaderText="Paid Branch Name" SortExpression="BranchName"
                            ItemStyle-HorizontalAlign="Left" ReadOnly="true"></asp:BoundField>
                        <%--<asp:BoundField DataField="PaidBranch" HeaderText="Paid Branch" SortExpression="PaidBranch"
                        ItemStyle-HorizontalAlign="Center" ReadOnly="true">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>--%>
                        <asp:TemplateField HeaderText="Paid Branch" InsertVisible="False" SortExpression="PaidBranch">
                            <ItemTemplate>
                                <%# Eval("PaidBranch") %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="Currency" HeaderText="Currency" SortExpression="Currency"
                            ItemStyle-HorizontalAlign="Center"></asp:BoundField>
                        <asp:TemplateField HeaderText="Total" ItemStyle-HorizontalAlign="Center" SortExpression="Total">
                            <ItemTemplate>
                                <%# string.Format(TrustControl1.Bangla, "{0:N0}", Eval("Total"))%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Amount" ItemStyle-HorizontalAlign="Right" SortExpression="Amount">
                            <ItemTemplate>
                                <%# string.Format(TrustControl1.Bangla, "{0:N2}", Eval("Amount"))%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" ItemStyle-HorizontalAlign="Center">
                        </asp:BoundField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <%# getLink(Eval("PaidBranch"), Eval("Currency"), cboPaymentMethod.Text, cboExHouse.Text, Eval("Status"), txtDateFrom.Text , txtDateTo.Text )%>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                    </Columns>
                    <FooterStyle BackColor="#CCCC99" HorizontalAlign="Right" Font-Bold="true" />
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
                <asp:Button ID="cmdExport" runat="server" Text="Export xlsx" Width="120px" Font-Bold="true"
                    Height="30px" OnClick="cmdExport_Click" Visible="false" />
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                    SelectCommand="sp_RemiList_Summary_HO" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected"
                    OnUpdated="SqlDataSource1_Updated">
                    <SelectParameters>
                        <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                        <asp:ControlParameter ControlID="txtDateFrom" DefaultValue="01/01/1900" Name="DateFrom"
                            PropertyName="Text" Type="DateTime" />
                        <asp:ControlParameter ControlID="txtDateTo" DefaultValue="01/01/1900" Name="DateTo"
                            PropertyName="Text" Type="DateTime" />
                        <asp:ControlParameter ControlID="cboExHouse" Name="ExHouseCode" PropertyName="SelectedValue"
                            Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
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