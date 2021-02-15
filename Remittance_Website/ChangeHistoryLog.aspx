<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    Inherits="Remittance.ChangeHistoryLog" CodeFile="ChangeHistoryLog.aspx.cs" %>

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
    Remittance Edit History Log
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <table>
                            <tr>
                                <td>
                                    <table style="font-size: small" class="ui-corner-all Panel1">
                                        <tr>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                                RID:
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtRID" runat="server" Width="50px" CssClass="Watermark" Watermark="RID"
                                                    AutoPostBack="true" Text="" OnTextChanged="txtRID_TextChanged"></asp:TextBox>
                                            </td>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                                Batch:
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtBatch" runat="server" Width="80px" placeholder="batch" AutoPostBack="true"
                                                    Text=""></asp:TextBox>
                                            </td>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                                Filter:
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtFilter" runat="server" Width="180px" CssClass="Watermark" Watermark="enter text to filter"
                                                    AutoPostBack="true" Text=""></asp:TextBox>
                                            </td>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                                Modify from
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
            <asp:GridView ID="GridView1" runat="server" BackColor="White" AllowPaging="True"
                PagerSettings-PageButtonCount="30" CssClass="Grid" AllowSorting="True" BorderColor="#DEDFDE"
                BorderStyle="Solid" BorderWidth="1px" CellPadding="4" ForeColor="Black" AutoGenerateColumns="False"
                DataSourceID="SqlDataSource1" Style="font-size: small; font-family: Arial" DataKeyNames="ID">
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
                    <asp:TemplateField HeaderText="Batch" SortExpression="Batch">
                        <ItemTemplate>
                            <a href='ShowBatch.aspx?batch=<%# Eval("Batch") %>' target="_blank">
                                <%# Eval("Batch") %></a>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="BeneficiaryName" HeaderText="Beneficiary Name" SortExpression="BeneficiaryName" />
                    <asp:BoundField DataField="Account" HeaderText="Beneficiary Account" SortExpression="Account"
                        ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" SortExpression="PaymentMethod"
                        ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" ItemStyle-HorizontalAlign="Center" />
                    <asp:TemplateField HeaderText="To Branch" SortExpression="ToBranch" ItemStyle-HorizontalAlign="Center"
                        ItemStyle-Wrap="false">
                        <ItemTemplate>
                            <%# Eval("ToBranch")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Routing Number" SortExpression="RoutingNumber">
                        <ItemTemplate>
                            <uc3:BEFTN ID="RoutingNumber" runat="server" Code='<%# Eval("RoutingNumber") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Bank Name" SortExpression="BankName">
                        <ItemTemplate>
                            <%# Eval("BankName")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Branch Name" SortExpression="BranchName">
                        <ItemTemplate>
                            <%# Eval("BranchName")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="District" SortExpression="District">
                        <ItemTemplate>
                            <%# Eval("District")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Modify By" SortExpression="ModifyBy" ItemStyle-HorizontalAlign="Center"
                        ItemStyle-Wrap="false">
                        <ItemTemplate>
                            <uc2:EMP ID="EMP2" Username='<%# Eval("ModifyBy") %>' Position="" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Modified On" SortExpression="ModifyDT" ItemStyle-HorizontalAlign="Center"
                        ItemStyle-Wrap="false">
                        <ItemTemplate>
                            <div title='<%# Eval("ModifyDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                <%# TrustControl1.ToRecentDateTime(Eval("ModifyDT"))%><br />
                                <time class="timeago" datetime='<%# Eval("ModifyDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                            </div>
                        </ItemTemplate>
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
                        No Data Found.
                    </div>
                </EmptyDataTemplate>
                <EditRowStyle BackColor="#C5E2FD" />
            </asp:GridView>
            <asp:HiddenField ID="hidRoutingMsg" runat="server" Value="" />
            <br />
            <asp:Label ID="lblStatus" runat="server" Text="" Style="font-size: small"></asp:Label>
            <br />
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_RemiList_History_Browse" SelectCommandType="StoredProcedure"
                OnSelected="SqlDataSource1_Selected">
                <SelectParameters>
                    <asp:ControlParameter ControlID="txtDateFrom" Name="DateFrom" DefaultValue='01/01/1900'
                        PropertyName="Text" Type="DateTime" />
                    <asp:ControlParameter ControlID="txtDateTo" Name="DateTo" DefaultValue='01/01/1900'
                        PropertyName="Text" Type="DateTime" />
                    <asp:ControlParameter ControlID="txtFilter" Name="Filter" PropertyName="Text" Type="String"
                        DefaultValue="*" Size="255" />
                    <asp:ControlParameter ControlID="txtRID" Name="RID" PropertyName="Text" Type="Int32"
                        DefaultValue="-1" />
                    <asp:ControlParameter ControlID="txtBatch" Name="Batch" PropertyName="Text" Type="Int32"
                        DefaultValue="-1" />
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