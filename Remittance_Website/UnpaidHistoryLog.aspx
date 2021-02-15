<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="Remittance.UnpaidHistoryLog" CodeFile="UnpaidHistoryLog.aspx.cs" %>

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
    Remittance Unpaid History Log
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <table class="ui-corner-all Panel1" style="font-size: small;">
                            <tr>
                                <td>
                                    <table style="border-collapse:collapse">
                                        <tr>
                                            <td style="padding-left: 10px; white-space: nowrap;">
                                                RID:
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtRID" runat="server" Width="50px" CssClass="Watermark" Watermark="RID"
                                                    AutoPostBack="true" Text="" OnTextChanged="txtRID_TextChanged"></asp:TextBox>
                                            </td>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                                Filter:
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtFilter" runat="server" Width="180px" CssClass="Watermark" Watermark="enter text to filter"
                                                    AutoPostBack="true" Text=""></asp:TextBox>
                                            </td>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                                Mark as Unpaid: from
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
                                            <td style="padding: 0px 10px 0px 10px">
                                                <asp:Button ID="cmdFilter" runat="server" Text="Show" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table style="border-collapse:collapse">
                                        <tr>
                                            <td style="padding-left: 10px; white-space: nowrap;">
                                                Ex-House
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="cboExHouse" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                                    DataSourceID="SqlDataSource2" DataTextField="ExHouseName" DataValueField="ExHouseCode">
                                                    <asp:ListItem Value="" Text="All"></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                    SelectCommand="SELECT [ExHouseCode],ExHouseCode+', '+[ExHouseName] as ExHouseName FROM [v_ExHouseListDetails] ORDER BY ExHouseName">
                                                </asp:SqlDataSource>
                                            </td>
                                            <td style="padding-left: 10px; white-space: nowrap;">
                                                Paid Date: from
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtDateFromPaid" runat="server" Width="80px" CssClass="Watermark Date"
                                                    Watermark="dd/mm/yyyy" AutoPostBack="true"></asp:TextBox>
                                            </td>
                                            <td>
                                                to
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtDateToPaid" runat="server" Width="80px" CssClass="Watermark Date"
                                                    Watermark="dd/mm/yyyy" AutoPostBack="true"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="padding-left:10px">
                        <asp:LinkButton ID="cmdPreviousDay" runat="server" OnClick="cmdPreviousDay_Click" CssClass="button1"><img src="Images/Previous.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                        <asp:LinkButton ID="cmdNextDay" runat="server" OnClick="cmdNextDay_Click" CssClass="button1"><img src="Images/Next.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                    </td>
                </tr>
            </table>
            <br />
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_RemiList_History_Payment_Browse" SelectCommandType="StoredProcedure"
                OnSelected="SqlDataSource1_Selected">
                <SelectParameters>
                    <asp:ControlParameter ControlID="txtDateFrom" Name="DateFrom" DefaultValue='01/01/1900'
                        PropertyName="Text" Type="DateTime" />
                    <asp:ControlParameter ControlID="txtDateTo" Name="DateTo" DefaultValue='01/01/1900'
                        PropertyName="Text" Type="DateTime" />
                    <asp:ControlParameter ControlID="txtDateFromPaid" Name="DateFromPaid" DefaultValue='01/01/1900'
                        PropertyName="Text" Type="DateTime" />
                    <asp:ControlParameter ControlID="txtDateToPaid" Name="DateToPaid" DefaultValue='01/01/1900'
                        PropertyName="Text" Type="DateTime" />
                    <asp:ControlParameter ControlID="txtFilter" Name="Filter" PropertyName="Text" Type="String"
                        DefaultValue=" " Size="255" />
                    <asp:ControlParameter ControlID="txtRID" Name="RID" PropertyName="Text" Type="Int32"
                        DefaultValue="-1" />
                    <asp:ControlParameter ControlID="cboExHouse" Name="ExHouse" PropertyName="Text" Type="String"
                        DefaultValue="-1" Size="50" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:GridView ID="GridView1" runat="server" BackColor="White" AllowPaging="True"
                PagerSettings-PageButtonCount="30" CssClass="Grid" AllowSorting="True" BorderColor="#DEDFDE"
                BorderStyle="Solid" BorderWidth="1px" CellPadding="4" ForeColor="Black" AutoGenerateColumns="False"
                DataSourceID="SqlDataSource1" Style="font-size: small; font-family: Arial" DataKeyNames="ID"
                Width="100%">
                <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                        SortExpression="ID" ItemStyle-HorizontalAlign="Center" />
                    <asp:TemplateField HeaderText="RID" SortExpression="RID">
                        <ItemTemplate>
                            <a href='Remittance_Show.aspx?id=<%# Eval("RID") %>' title="View Remittance" target="_blank">
                                <%# Eval("RID") %></a></ItemTemplate>
                        <ItemStyle Font-Bold="True" Font-Size="Medium" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                        ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="Currency" HeaderText="Currency" SortExpression="Currency"
                        ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="ExHouseCode" HeaderText="Ex House" SortExpression="ExHouseCode"
                        ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="BeneficiaryName" HeaderText="Beneficiary Name" SortExpression="BeneficiaryName" />
                    <asp:BoundField DataField="Account" HeaderText="Account" SortExpression="Account"
                        ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" SortExpression="PaymentMethod"
                        ItemStyle-HorizontalAlign="Center" />
                    <asp:TemplateField HeaderText="Paid On" SortExpression="PaidOn" ItemStyle-HorizontalAlign="Center"
                        ItemStyle-Wrap="false">
                        <ItemTemplate>
                            <div title='<%# Eval("PaidOn","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                <%# TrustControl1.ToRecentDateTime(Eval("PaidOn"))%><br />
                                <time class="timeago" datetime='<%# Eval("PaidOn","{0:yyyy-MM-dd HH:mm:ss}") %>'></time></div>
                            
                            Paid by:
                            <uc2:EMP ID="EMP1" Username='<%# Eval("PaidBy") %>' Position="" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="PaidBranch" HeaderText="Paid Branch" SortExpression="PaidBranch"
                        ItemStyle-HorizontalAlign="Center" />
                    <asp:TemplateField HeaderText="Instrument" SortExpression="InstrumentDate">
                        <ItemTemplate>
                            <%# Eval("Instrument") %>
                            <%# Eval("InstrumentDate","<br>Date: {0:dd/MM/yyyy}")%>                            
                            <uc3:BEFTN ID="BEFTN_History" runat="server" Code='<%# Eval("RoutingNumber") %>'
                                TextFormat="<br>Routing: {0}" />
                            <%# Eval("Paid_Batch","<br>Paid Batch: {0}")%>
                        </ItemTemplate>
                        <ItemStyle Wrap="false" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Paid Against ID" SortExpression="IDNumber">
                        <ItemTemplate>
                            <%# Eval("IDType")%>
                            <%# Eval("IDNumber","<br>{0}")%>
                            <%# Eval("IDExpityDate", "<br>Expiry: {0:dd/MM/yyyy}")%>
                        </ItemTemplate>
                        <ItemStyle Wrap="false" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Unpaid Marked By" SortExpression="UnpaidBy" ItemStyle-HorizontalAlign="Center"
                        ItemStyle-Wrap="false">
                        <ItemTemplate>
                            <uc2:EMP ID="EMP2" Username='<%# Eval("UnpaidBy") %>' Position="" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Unpaid Marked On" SortExpression="UnpaidOn" ItemStyle-HorizontalAlign="Center"
                        ItemStyle-Wrap="false">
                        <ItemTemplate>
                            <div title='<%# Eval("UnpaidOn","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                <%# TrustControl1.ToRecentDateTime(Eval("UnpaidOn"))%><br />
                                <time class="timeago" datetime='<%# Eval("UnpaidOn","{0:yyyy-MM-dd HH:mm:ss}") %>'></time></div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="UnpaidReason" HeaderText="Unpaid Reason" SortExpression="UnpaidReason" ItemStyle-Font-Bold="true" />
                    <asp:TemplateField HeaderText="Rollbacked" SortExpression="Rollbacked">
                        <ItemTemplate>
                            <%# (Eval("Rollbacked").ToString() == "True") ? "<img src='Images/rollback.png' width='32' height='32'>" : ""%>
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
