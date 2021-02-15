<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    Inherits="Remittance.Paid_Grid" CodeFile="Paid_Grid.aspx.cs" EnableViewState="true" EnableSessionState="ReadOnly" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Remittance Paid Grid
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_RemiList_Paid_Grid" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected">
                <SelectParameters>
                    <asp:ControlParameter ControlID="txtFilter" Name="Filter" PropertyName="Text" Type="String"
                        ConvertEmptyStringToNull="false" DefaultValue="" />
                    <asp:ControlParameter ControlID="cboBranch" Name="PaidBranch" PropertyName="SelectedValue"
                        Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                    <asp:ControlParameter ControlID="cboPaymentMethod" Name="PaymentMethod" PropertyName="SelectedValue"
                        Type="String" ConvertEmptyStringToNull="true" DefaultValue="-1" />
                    <asp:ControlParameter ControlID="txtDateFrom" Name="FromDate" PropertyName="Text"
                        Type="DateTime" ConvertEmptyStringToNull="true" DefaultValue="1/1/1900" />
                    <asp:ControlParameter ControlID="txtDateTo" Name="ToDate" PropertyName="Text" Type="DateTime"
                        ConvertEmptyStringToNull="true" DefaultValue="1/1/1900" />
                    <asp:ControlParameter ControlID="cboExHouse" Name="ExHouse" PropertyName="SelectedValue"
                        Type="String" DefaultValue="-1" />
                    <asp:ControlParameter ControlID="cboBank" Name="BankCode" PropertyName="SelectedValue"
                        Type="String" DefaultValue="-1" />
                </SelectParameters>
            </asp:SqlDataSource>
            </asp:Timer>
            <table>
                <tr>
                    <td>
                        <table class="SmallFont Panel1">
                            <tr>
                                <td>
                                    <table>
                                        <tr>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                                Paid Date:
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
                                                Paid Bank:
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="cboBank" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                                    DataSourceID="SqlDataSourceBank" DataTextField="Bank_Name" DataValueField="BEFTN_Bank_Code"
                                                     >
                                                    <asp:ListItem Value="-1" Text="All Banks"></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDataSourceBank" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                    SelectCommand="SELECT [BEFTN_Bank_Code], [Bank_Name] FROM [v_Banks] ORDER by Bank_Name">
                                                </asp:SqlDataSource>
                                            </td>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                                Branch:
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="cboBranch" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                                    DataSourceID="SqlDataSourceBranch" DataTextField="BranchName" DataValueField="BranchID"
                                                    OnDataBound="cboBranch_DataBound" OnSelectedIndexChanged="cboBranch_SelectedIndexChanged">
                                                    <asp:ListItem Value="-1" Text="All Branch"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Head Office"></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                    SelectCommand="SELECT [BranchID], [BranchName] FROM [V_BranchOnly] ORDER by BranchName">
                                                </asp:SqlDataSource>
                                            </td>
                                        </tr>
                                    </table>
                                    <table>
                                        <tr>
                                            <td style="padding-left: 2px" >
                                                <asp:TextBox ID="txtFilter" runat="server" Width="120px" onfocus="this.select()"
                                                    AutoPostBack="True" Watermark="enter text to filter" OnTextChanged="txtFilter_TextChanged"></asp:TextBox>
                                            </td>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                                Ex-House:
                                            </td>
                                            <td colspan="9">
                                                <asp:DropDownList ID="cboExHouse" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                                    DataSourceID="SqlDataSource2" DataTextField="ExHouseName" DataValueField="ExHouseCode">
                                                    <asp:ListItem Value="-1" Text="All"></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                    SelectCommand="SELECT [ExHouseCode], ExHouseCode+', '+[ExHouseName] as ExHouseName FROM [v_ExHouseListDetails] ORDER BY ExHouseName">
                                                </asp:SqlDataSource>
                                            </td>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                                Method:
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="cboPaymentMethod" AutoPostBack="True" runat="server" AppendDataBoundItems="true"
                                                    DataSourceID="SqlDataSourcePaymentMethod" DataTextField="PaymentMethod" DataValueField="PaymentMethod"
                                                    OnSelectedIndexChanged="cboPaymentMethod_SelectedIndexChanged">
                                                    <asp:ListItem Text="ALL" Value="-1"></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDataSourcePaymentMethod" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                    SelectCommand="SELECT * FROM [v_PaymentMethods] ORDER BY OrderCol"></asp:SqlDataSource>
                                            </td>
                                            <td style="padding-left: 2px">
                                                <asp:Button ID="cmdFilter" runat="server" Text="Show" OnClick="cmdFilter_Click" />
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
            <asp:GridView ID="GridView1" runat="server" BackColor="White" AllowPaging="true" EnableViewState="false"
                PageSize="15" CssClass="Grid" AllowSorting="true" BorderColor="#DEDFDE" BorderStyle="None"
                BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Both" AutoGenerateColumns="False"
                PagerSettings-PageButtonCount="30" DataSourceID="SqlDataSource1" Style="font-size: small;
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
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                        ReadOnly="true" ItemStyle-HorizontalAlign="Right">
                        <ItemStyle HorizontalAlign="Right" Font-Bold="true" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Currency" SortExpression="Currency" HeaderText="Currency" ReadOnly="true" ItemStyle-HorizontalAlign="Center">
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
                            <span title='<%# Eval("PaidBranch")%>'>
                                <%# Eval("PaidBranchName")%></span></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Paid Bank" SortExpression="BankName" ItemStyle-Font-Bold="true">
                        <ItemTemplate>
                           
                                <%# Eval("BankName")%></ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" SortExpression="PaymentMethod"
                        ReadOnly="true" ItemStyle-HorizontalAlign="Center" />
                    <asp:TemplateField HeaderText="ExHouse Code" SortExpression="ExHouseCode">
                        <ItemTemplate>
                            <span title='<%# Eval("ExHouseName") %>'>
                                <%# Eval("ExHouseCode") %></span>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="ToBranchName" SortExpression="ToBranchName">
                        <ItemTemplate>
                            <span title='<%# Eval("ToBranch") %>'>
                                <%# Eval("ToBranchName") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
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
            <asp:HiddenField ID="hidRoutingMsg" runat="server" Value="" />
            <br />
            <asp:Label ID="lblStatus" runat="server" Text="" Style="font-size: small"></asp:Label><br />
            <br />
            <asp:Button ID="cmdExport" runat="server" Text="Export xlsx" Width="120px" Font-Bold="true"
                Height="30px" OnClick="cmdExport_Click" Visible="true" />
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
