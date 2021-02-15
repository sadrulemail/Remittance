<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="Remittance.Flora_IC_Export" CodeFile="Flora_IC_Export.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Flora IC Export
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:TabContainer runat="server" ID="TabContainer1" CssClass="NewsTab" Width="800px"
                ActiveTabIndex="0" OnActiveTabChanged="TabContainer1_ActiveTabChanged" OnDemand="True">
                <asp:TabPanel runat="server" ID="Tab1">
                    <HeaderTemplate>
                        Ready (Branch Wise)</HeaderTemplate>
                    <ContentTemplate>
                        <table class="ui-corner-all Panel1">
                            <tr>
                                <td>
                                    <table class="SmallFont">
                                        <tr>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                                Ex-House:
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="cboExHouse" runat="server" AppendDataBoundItems="True" AutoPostBack="True"
                                                    DataSourceID="SqlDataSourceExHouse" DataTextField="ExHouseName" DataValueField="ExHouseCode">
                                                    <asp:ListItem Value="-1" Text="All"></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDataSourceExHouse" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                    SelectCommand="SELECT [ExHouseCode],ExHouseCode+', '+[ExHouseName] as ExHouseName FROM [v_ExHouseListDetails] ORDER BY ExHouseName">
                                                </asp:SqlDataSource>
                                            </td>
                                            <td style="padding-left: 2px">
                                                <asp:Button ID="Button1" runat="server" Text="Filter" Width="100px" Font-Bold="True" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <br />
                        <asp:GridView ID="GridView2" runat="server" BackColor="White" ShowFooter="True" CssClass="Grid"
                            AllowSorting="True" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                            CellPadding="4" ForeColor="Black" AutoGenerateColumns="False" DataSourceID="SqlDataSource2"
                            Style="font-size: small; font-family: Arial" Width="100%" OnDataBound="GridView2_DataBound">
                            <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                            <Columns>
                                <asp:BoundField DataField="PaidBranch" HeaderText="Paid Branch" SortExpression="PaidBranch"
                                    ReadOnly="True">
                                    <ItemStyle Font-Bold="True" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PaidBranchName" HeaderText="Paid Branch Name" SortExpression="PaidBranchName"
                                    ReadOnly="True" />
                                <asp:BoundField DataField="Total" HeaderText="Total" SortExpression="Total" ReadOnly="True"
                                    DataFormatString="{0:N0}">
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" ReadOnly="True"
                                    DataFormatString="{0:N2}">
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                            </Columns>
                            <FooterStyle BackColor="#CCCC99" HorizontalAlign="Right" Font-Bold="True" Font-Size="Large" />
                            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                            <PagerSettings Position="TopAndBottom" Mode="NumericFirstLast" PageButtonCount="30" />
                            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#6B696B" Font-Bold="False" ForeColor="White" />
                            <AlternatingRowStyle BackColor="White" />
                            <EmptyDataTemplate>
                                <div style="border: solid 1px silver; padding: 10px; background-color: #F6F6F6; width: 500px">
                                    No IC Paid Remittance Found.</div>
                            </EmptyDataTemplate>
                            <EditRowStyle BackColor="#C5E2FD" />
                        </asp:GridView>
                        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                            SelectCommand="sp_IC_Ready_To_Export_Br_Wise" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="cboExHouse" Name="ExHouseCode" PropertyName="SelectedValue"
                                    Type="String" DefaultValue="" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </ContentTemplate>
                </asp:TabPanel>
                <asp:TabPanel runat="server" ID="Tab2">
                    <HeaderTemplate>
                        Ready (Ex-House Wise)</HeaderTemplate>
                    <ContentTemplate>
                        <table class="ui-corner-all Panel1">
                            <tr>
                                <td>
                                    <table class="SmallFont">
                                        <tr>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                                Paid Branch:
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="cboBranch" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                                    DataSourceID="SqlDataSourceBranch" DataTextField="BranchName" DataValueField="BranchID">
                                                    <asp:ListItem Value="-1" Text="All"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Head Office"></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                    SelectCommand="SELECT [BranchID], [BranchName] FROM [V_BranchOnly] ORDER by BranchName">
                                                </asp:SqlDataSource>
                                            </td>
                                            <td style="padding-left: 2px">
                                                <asp:Button ID="cmdFilter" runat="server" Text="Filter" Width="100px" Font-Bold="true" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <br />
                        <asp:GridView ID="GridView1" runat="server" BackColor="White" ShowFooter="True" CssClass="Grid"
                            AllowSorting="True" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                            CellPadding="4" ForeColor="Black" AutoGenerateColumns="False" PagerSettings-PageButtonCount="30"
                            DataSourceID="SqlDataSource1" Style="font-size: small; font-family: Arial" Width="100%"
                            OnDataBound="GridView1_DataBound">
                            <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                            <Columns>
                                <asp:BoundField DataField="ExHouseCode" HeaderText="ExHouse Code" SortExpression="ExHouseCode"
                                    ReadOnly="true" ItemStyle-Font-Bold="true" />
                                <asp:BoundField DataField="ExHouseName" HeaderText="ExHouse Name" SortExpression="ExHouseName"
                                    ReadOnly="true" />
                                <asp:BoundField DataField="Total" HeaderText="Total" SortExpression="Total" ReadOnly="true"
                                    ItemStyle-HorizontalAlign="Right" DataFormatString="{0:N0}">
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" ReadOnly="true"
                                    ItemStyle-HorizontalAlign="Right" DataFormatString="{0:N2}">
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                            </Columns>
                            <FooterStyle BackColor="#CCCC99" HorizontalAlign="Right" Font-Bold="true" Font-Size="Large" />
                            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                            <PagerSettings Position="TopAndBottom" Mode="NumericFirstLast" />
                            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#6B696B" Font-Bold="false" ForeColor="White" />
                            <AlternatingRowStyle BackColor="White" />
                            <EmptyDataTemplate>
                                <div style="border: solid 1px silver; padding: 10px; background-color: #F6F6F6; width: 500px">
                                    No IC Paid Remittance Found.</div>
                            </EmptyDataTemplate>
                            <EditRowStyle BackColor="#C5E2FD" />
                        </asp:GridView>
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                            SelectCommand="sp_IC_Ready_To_Export" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="cboBranch" Name="PaidBranch" PropertyName="SelectedValue"
                                    Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </ContentTemplate>
                </asp:TabPanel>
                <asp:TabPanel runat="server" ID="Tab3">
                    <HeaderTemplate>
                        Export New</HeaderTemplate>
                    <ContentTemplate>
                        <asp:Label ID="lblStatus" runat="server" Style="font-size: small"></asp:Label>
                        <br />
                        <asp:Button ID="cmdMarkPaid" runat="server" Text="Generate New Batch" Width="200px"
                            Font-Bold="True" Height="30px" OnClick="cmdMarkPaid_Click" />
                        <asp:ConfirmButtonExtender ID="cmdMarkPaid_ConfirmButtonExtender" runat="server"
                            ConfirmText="Do you want to generate new batch now?" Enabled="True" TargetControlID="cmdMarkPaid">
                        </asp:ConfirmButtonExtender>
                        <asp:Panel ID="PanelStatusMarkPaid" runat="server" CssClass="Border" Visible="False"
                            Width="300px">
                            <asp:Label ID="lblStatusMarkPaid" runat="server" Font-Size="Small"></asp:Label>
                        </asp:Panel>
                    </ContentTemplate>
                </asp:TabPanel>
                <asp:TabPanel runat="server" ID="Tab4">
                    <HeaderTemplate>
                        Export History</HeaderTemplate>
                    <ContentTemplate>
                        <asp:GridView ID="GridViewHistory" runat="server" BackColor="White" AllowPaging="true"
                            CssClass="Grid" AllowSorting="True" BorderColor="#DEDFDE" BorderStyle="None"
                            PageSize="20" BorderWidth="1px" CellPadding="4" ForeColor="Black" AutoGenerateColumns="False"
                            PagerSettings-PageButtonCount="30" DataSourceID="SqlDataSourceHistory" Style="font-size: small;
                            font-family: Arial" Width="100%">
                            <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" HorizontalAlign="Center" />
                            <Columns>
                                <asp:BoundField DataField="BatchID" HeaderText="Batch" SortExpression="BatchID"
                                    ItemStyle-Font-Bold="true" />
                                <asp:TemplateField HeaderText="DT" SortExpression="DT">
                                    <ItemTemplate>
                                        <span title='<%# Eval("DT","{0:dddd, \ndd MMMM yyyy, \nhh:mm:ss tt}") %>'>
                                            <%# TrustControl1.ToRecentDateTime(Eval("DT")) %></span></ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="About" SortExpression="DT">
                                    <ItemTemplate>
                                        <span title='<%# Eval("DT","{0:dddd, \ndd MMMM yyyy, \nhh:mm:ss tt}") %>'>
                                            <%# TrustControl1.ToRelativeDate(Eval("DT"))%></span></ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="By Emp" SortExpression="ByEmp">
                                    <ItemTemplate>
                                        <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("ByEmp") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="BranchID" HeaderText="Branch" SortExpression="BranchID" />
                                <asp:BoundField DataField="TotalItems" HeaderText="Items" SortExpression="TotalItems"
                                    DataFormatString="{0:N0}" />
                                <asp:BoundField DataField="TotalAmount" HeaderText="Total Amount" SortExpression="TotalAmount"
                                    DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <a href='Flora_IC_Download.aspx?batch=<%# Eval("BatchID") %>&mode=txt'>Re-Download</a>
                                        | <a target="_blank" href='Flora_IC_Download.aspx?batch=<%# Eval("BatchID") %>&mode=view'>View</a>
                                    </ItemTemplate>
                                    <ItemStyle Wrap="false" />
                                </asp:TemplateField>
                            </Columns>
                            <FooterStyle BackColor="#CCCC99" HorizontalAlign="Right" Font-Bold="true" Font-Size="Large" />
                            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                            <PagerSettings Position="TopAndBottom" Mode="NumericFirstLast" />
                            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#6B696B" Font-Bold="false" ForeColor="White" />
                            <AlternatingRowStyle BackColor="White" />
                            <EmptyDataTemplate>
                                <div style="border: solid 1px silver; padding: 10px; background-color: #F6F6F6; width: 500px">
                                    History is not available.</div>
                            </EmptyDataTemplate>
                            <EditRowStyle BackColor="#C5E2FD" />
                        </asp:GridView>
                        <asp:SqlDataSource ID="SqlDataSourceHistory" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                            SelectCommand="SELECT * FROM Flora_IC_Export_Log ORDER BY BatchID">
                            <SelectParameters>
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </ContentTemplate>
                </asp:TabPanel>
            </asp:TabContainer>
            <asp:SqlDataSource ID="SqlDataSource_IC_Mark_as_Paid" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_IC_Mark_as_Paid" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource_IC_Mark_as_Paid_Selected">
                <SelectParameters>
                    <asp:SessionParameter Name="BranchID" SessionField="BRANCHID" Type="Int32" />
                    <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                    <asp:Parameter DefaultValue="0" Direction="InputOutput" Name="BatchNo" Type="Int32" />
                    <asp:Parameter DefaultValue="0" Direction="InputOutput" Name="Total" Type="Int32" />
                    <asp:Parameter DefaultValue="0" Direction="InputOutput" Name="TotalAmount" Type="Double" />
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
