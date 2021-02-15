<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="RTGS_Download_History.aspx.cs" Inherits="RTGS_Download_History" %>


<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    RTGS Export History
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table class="">
                <tr>
                    <td>
                        <table class="SmallFont ui-corner-all Panel1">
                            <tr>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    Export From Branch:
                                </td>
                                <td>
                                    <asp:DropDownList ID="cboBranch" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                        DataSourceID="SqlDataSourceBranch" DataTextField="BranchName" DataValueField="BranchID"
                                        OnDataBound="cboBranch_DataBound">
                                        <asp:ListItem Value="-1" Text="All"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Head Office"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="SELECT [BranchID], [BranchName] FROM [V_BranchOnly] ORDER by BranchName" EnableCaching="true" CacheDuration="600">
                                    </asp:SqlDataSource>
                                </td>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    Export Date: from
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
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" Font-Size="Small"
                DataKeyNames="BatchID" DataSourceID="SqlDataSource1" AllowPaging="True" CssClass="Grid"
                AllowSorting="True" BackColor="White" BorderColor="#DEDFDE" BorderStyle="Solid"
                PagerSettings-Position="TopAndBottom" PageSize="20" PagerSettings-Mode="NumericFirstLast"
                PagerSettings-PageButtonCount="20" BorderWidth="1px" CellPadding="4" ForeColor="Black">
                <RowStyle BackColor="#F7F7DE" HorizontalAlign="Center" />
                <Columns>
                    <asp:BoundField DataField="BatchID" HeaderText="Batch ID" InsertVisible="False" ReadOnly="True"
                        ItemStyle-Font-Bold="true" SortExpression="BatchID" />
                    <asp:TemplateField HeaderText="Exported On" SortExpression="DT">
                        <ItemTemplate>
                            <span title='<%# Eval("DT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                <%# TrustControl1.ToRecentDateTime(Eval("DT"))%></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="About" SortExpression="DT">
                        <ItemTemplate>
                            <span class="time-small" title='<%# Eval("DT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                <time class="timeago" datetime='<%# Eval("DT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="By Emp" SortExpression="ByEmp">
                        <ItemTemplate>
                            <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("ByEmp") %>' />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("ByEmp") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="BranchID" HeaderText="Branch ID" SortExpression="BranchID" />
                    <asp:BoundField DataField="BranchName" HeaderText="Branch Name" SortExpression="BranchName" />
                    <asp:BoundField DataField="TotalItems" HeaderText="Total Items" SortExpression="TotalItems" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <a href='RTGS_Download.aspx?batch=<%# Eval("BatchID") %>'>
                                <img src='Images/ext/xls.gif' width='16' height='16' border='0' title='xlsx' /></a>
                            &nbsp;&nbsp;<a href='RTGS_Download.aspx?batch=<%# Eval("BatchID") %>&view=yes' target="_blank"><img
                                src='Images/open.png' width='16' height='16' border='0' title='View' /></a>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div style="border: solid 1px silver; padding: 10px; background-color: #F6F6F6;">
                        No Data Found.</div>
                </EmptyDataTemplate>
                <FooterStyle BackColor="#CCCC99" />
                <PagerStyle HorizontalAlign="Left" CssClass="PagerStyle" />
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                <AlternatingRowStyle BackColor="White" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_RTGS_Export_Log_Browse" SelectCommandType="StoredProcedure"
                OnSelected="SqlDataSource1_Selected">
                <SelectParameters>
                    <asp:ControlParameter ControlID="cboBranch" PropertyName="SelectedValue" Name="BranchID"
                        Type="Int32" />
                    <asp:ControlParameter ControlID="txtDateFrom" Name="FromDate" PropertyName="Text"
                        Type="DateTime" ConvertEmptyStringToNull="true" DefaultValue="1/1/1900" />
                    <asp:ControlParameter ControlID="txtDateTo" Name="ToDate" PropertyName="Text" Type="DateTime"
                        ConvertEmptyStringToNull="true" DefaultValue="1/1/1900" />
                </SelectParameters>
            </asp:SqlDataSource>
            <br />
            <asp:Label ID="lblStatus" runat="server" Text="" Font-Size="Small"></asp:Label>
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
        UseAnimation="false" VerticalSide="Middle">
    </asp:AlwaysVisibleControlExtender>
</asp:Content>

