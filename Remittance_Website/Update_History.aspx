﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Update_History.aspx.cs" Inherits="Update_History" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Update History
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="s_Update_History_Count" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected">
                <SelectParameters>
                    <asp:ControlParameter ControlID="txtDateFrom" Name="FromDate" PropertyName="Text"
                        Type="DateTime" ConvertEmptyStringToNull="true" DefaultValue="1/1/1900" />
                    <asp:ControlParameter ControlID="txtDateTo" Name="ToDate" PropertyName="Text" Type="DateTime"
                        ConvertEmptyStringToNull="true" DefaultValue="1/1/1900" />
                    <asp:ControlParameter ControlID="DropDownListStatus" Name="Status" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="cboPaymentMethod" Name="PaymentMethod" PropertyName="SelectedValue"
                        Type="String" DefaultValue="-1" />
                    <asp:ControlParameter ControlID="txtBatch" Name="Batch" PropertyName="Text" Type="Int32"
                        DefaultValue="-1" />
                </SelectParameters>
            </asp:SqlDataSource>
            <table>
                <tr>
                    <td>
                        <table class="SmallFont Panel1">
                            <tr>
                                <td>
                                    Batch:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtBatch" runat="server" placeholder="batch" AutoPostBack="true"
                                        MaxLength="10" Width="80px"></asp:TextBox>
                                </td>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    Date:
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
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    Status:
                                </td>
                                <td>
                                    <asp:DropDownList ID="DropDownListStatus" runat="server" AutoPostBack="true">
                                        <asp:ListItem Text="ACTIVE" Value="ACTIVE"></asp:ListItem>
                                        <asp:ListItem Text="ON HOLD" Value="ON HOLD"></asp:ListItem>
                                        <asp:ListItem Text="CANCEL" Value="CANCEL"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    Method:
                                </td>
                                <td>
                                    <asp:DropDownList ID="cboPaymentMethod" AutoPostBack="True" runat="server" AppendDataBoundItems="true"
                                        DataSourceID="SqlDataSourcePaymentMethod" DataTextField="PaymentMethod" DataValueField="PaymentMethod">
                                        <asp:ListItem Text="ALL" Value="-1"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourcePaymentMethod" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="SELECT * FROM [v_PaymentMethods] ORDER BY OrderCol"></asp:SqlDataSource>
                                </td>
                                <td style="padding-left: 10px">
                                    <asp:Button ID="cmdFilter" runat="server" Text="Show" OnClick="cmdFilter_Click" />
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
            <asp:GridView ID="GridView1" runat="server" BackColor="White" 
                AllowPaging="false" DataKeyNames="EmpID"
                ShowFooter="true" PageSize="15" CssClass="Grid" AllowSorting="true" BorderColor="#DEDFDE"
                BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Both"
                AutoGenerateColumns="False" PagerSettings-PageButtonCount="30" DataSourceID="SqlDataSource1"
                Style="font-size: small; font-family: Arial" 
                OnDataBound="GridView1_DataBound" 
                onselectedindexchanged="GridView1_SelectedIndexChanged">
                <RowStyle BackColor="#F7F7DE" CssClass="Grid" VerticalAlign="Top" />
                <Columns>
                    <asp:TemplateField HeaderText="EmpID" SortExpression="EmpID">
                        <ItemTemplate>
                            <a href='../Profile.aspx?id=<%# Eval("EmpID") %>' target="_blank">
                                <%# Eval("EmpID")%></a></ItemTemplate>
                        <ItemStyle Font-Bold="True" HorizontalAlign="Left" />
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Total" SortExpression="Total" DataField="Total" ItemStyle-HorizontalAlign="Right" />
                    <asp:CommandField ShowSelectButton="true" />
                </Columns>
                <FooterStyle BackColor="#CCCC99" HorizontalAlign="Right" Font-Bold="true" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                <PagerSettings Position="TopAndBottom" Mode="NumericFirstLast" />
                <SelectedRowStyle BackColor="#FFA200" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="false" ForeColor="White" Font-Names="Arial Narrow" />
                <AlternatingRowStyle BackColor="White" />
                <EmptyDataTemplate>
                    <div style="border: solid 1px silver; padding: 10px; background-color: #F6F6F6; width: 200px">
                        No Data Found.</div>
                </EmptyDataTemplate>
                <EditRowStyle BackColor="#C5E2FD" />
            </asp:GridView>
            <asp:HiddenField ID="hidRoutingMsg" runat="server" Value="" />
            <br />
            <asp:Label ID="lblStatus" runat="server" Text="" Style="font-size: small"></asp:Label><br />
            <br />
            <asp:Button ID="cmdExport" runat="server" Text="Export xlsx" Width="120px" Font-Bold="true"
                Height="30px" OnClick="cmdExport_Click" Visible="false" />
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="s_Update_History_Details" SelectCommandType="StoredProcedure"
                OnSelected="SqlDataSource1_Selected">
                <SelectParameters>
                    <asp:ControlParameter ControlID="txtDateFrom" Name="FromDate" PropertyName="Text"
                        Type="DateTime" ConvertEmptyStringToNull="true" DefaultValue="1/1/1900" />
                    <asp:ControlParameter ControlID="txtDateTo" Name="ToDate" PropertyName="Text" Type="DateTime"
                        ConvertEmptyStringToNull="true" DefaultValue="1/1/1900" />
                    <asp:ControlParameter ControlID="DropDownListStatus" Name="Status" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="cboPaymentMethod" Name="PaymentMethod" PropertyName="SelectedValue"
                        Type="String" DefaultValue="-1" />
                    <asp:ControlParameter ControlID="txtBatch" Name="Batch" PropertyName="Text" Type="Int32"
                        DefaultValue="-1" />
                    <asp:ControlParameter ControlID="GridView1" DefaultValue="*" Name="EmpID" 
                        PropertyName="SelectedValue" Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:GridView ID="GridView2" runat="server" BackColor="White" AllowPaging="true"
                PageSize="10" CssClass="Grid" AllowSorting="true" BorderColor="#DEDFDE" BorderStyle="None"
                BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Both" AutoGenerateColumns="False"
                PagerSettings-PageButtonCount="30" DataSourceID="SqlDataSource2" Style="font-size: small;
                font-family: Arial">
                <RowStyle BackColor="#F7F7DE" CssClass="Grid" VerticalAlign="Top" />
                <Columns>
                    <asp:TemplateField HeaderText="RID" SortExpression="ID">
                        <ItemTemplate>
                            <a href='Remittance_Show.aspx?id=<%# Eval("ID") %>' title="View Remittance" target="_blank">
                                <%# Eval("ID") %></a></ItemTemplate>
                        <EditItemTemplate>
                            <asp:HyperLink runat="server" ID="cmdID" Text='<%# Bind("ID") %>' Target="_blank"
                                NavigateUrl='<%# "Remittance_Show.aspx?id=" + Eval("ID") %>'></asp:HyperLink></EditItemTemplate>
                        <ItemStyle Font-Bold="True" Font-Size="Medium" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Batch" SortExpression="Batch">
                        <ItemTemplate>
                            <a href='ShowBatch.aspx?batch=<%# Eval("Batch") %>' target="_blank">
                                <%# Eval("Batch") %></a>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                        ReadOnly="true" ItemStyle-HorizontalAlign="Right">
                        <ItemStyle HorizontalAlign="Right" Font-Bold="true" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Currency" HeaderText="Currency" ReadOnly="true" ItemStyle-HorizontalAlign="Center">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Paid" SortExpression="Paid">
                        <ItemTemplate>
                            <%# (Eval("Paid").ToString() == "True") ? "<img src='Images/tick.png' width='20px' height='20px'>" : ""%>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Paid On" SortExpression="PaidOn" ItemStyle-Wrap="false"
                        ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <span title='<%# Eval("PaidOn", "{0:dddd, dd MMMM yyyy, hh:mm:ss tt}")%>'>
                                <%# TrustControl1.ToRecentDateTime(Eval("PaidOn")) %></span></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="About" SortExpression="PaidOn" ItemStyle-Wrap="false"
                        ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <span class="time-small" title='<%# Eval("PaidOn", "{0:dddd, dd MMMM yyyy, hh:mm:ss tt}")%>'>
                                <time class="timeago" datetime='<%# Eval("PaidOn","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="PaidBy" SortExpression="Paid By" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <uc2:EMP ID="EMP1" Username='<%# Eval("PaidBy") %>' runat="server" />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Paid Branch" SortExpression="PaidBranch" ItemStyle-Font-Bold="true">
                        <ItemTemplate>
                            <%# Eval("PaidBranch")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" SortExpression="PaymentMethod"
                        ReadOnly="true" ItemStyle-HorizontalAlign="Center" />
                    <%--<asp:TemplateField HeaderText="ExHouse Code" SortExpression="ExHouseCode">
                        <ItemTemplate>
                            <span title='<%# Eval("ExHouseName") %>'>
                                <%# Eval("ExHouseCode") %></span>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>--%>
                    <%--<asp:TemplateField HeaderText="ToBranchName" SortExpression="ToBranchName">
                        <ItemTemplate>
                            <span title='<%# Eval("ToBranch") %>'>
                                <%# Eval("ToBranchName") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>--%>
                    <asp:TemplateField HeaderText="Routing Number" SortExpression="RoutingNumber">
                        <ItemTemplate>
                            <uc3:BEFTN ID="BEFTN1" runat="server" Code='<%# Eval("RoutingNumber") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Status" SortExpression="Status" ItemStyle-Wrap="false"
                        Visible="false">
                        <ItemTemplate>
                            <%# Eval("Status") %></ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="RemitterName" HeaderText="Remitter Name" SortExpression="RemitterName"
                        ReadOnly="true" />
                    <asp:BoundField DataField="BeneficiaryName" HeaderText="Beneficiary Name" SortExpression="BeneficiaryName"
                        ReadOnly="true" />
                    <asp:TemplateField HeaderText="Status" SortExpression="Status" ItemStyle-Wrap="false"
                        Visible="true">
                        <ItemTemplate>
                            <%# Eval("Status") %></ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <FooterStyle BackColor="#CCCC99" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                <PagerSettings Position="TopAndBottom" Mode="NumericFirstLast" />
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="false" ForeColor="White" Font-Names="Arial Narrow" />
                <AlternatingRowStyle BackColor="White" />
                <EmptyDataTemplate>
                    <div style="border: solid 1px silver; padding: 10px; background-color: #F6F6F6; width: 500px">
                        No Remittance Paid.</div>
                </EmptyDataTemplate>
                <EditRowStyle BackColor="#C5E2FD" />
            </asp:GridView>
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
