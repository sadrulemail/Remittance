<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" EnableViewState="true" EnableSessionState="ReadOnly"
    AutoEventWireup="true" Inherits="Remittance.Flora_Export" CodeFile="Flora_Export.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Export to Flora
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <table class="SmallFont Panel1">
                            <tr>
                                <td>
                                    <table>
                                        <tr>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">To Branch:
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="cboBranch" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                                    DataSourceID="SqlDataSourceBranch" DataTextField="BranchName" DataValueField="BranchID"
                                                    OnDataBound="cboBranch_DataBound">
                                                    <asp:ListItem Value="-1" Text="All"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Head Office"></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                    SelectCommand="SELECT [BranchID], [BranchName] FROM [V_BranchOnly] ORDER by BranchName"></asp:SqlDataSource>

                                            </td>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">ExHouse:
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="cboExHouse" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                                    DataSourceID="SqlDataSourceExHouseCodes" DataTextField="ExHouseName" DataValueField="ExHouseCode">
                                                    <asp:ListItem Value="" Text=""></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDataSourceExHouseCodes" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                    SelectCommand="SELECT [ExHouseCode], ExHouseCode + ', ' + [ExHouseName] as ExHouseName FROM [v_ExHouseListDetails] with (nolock) ORDER BY ExHouseCode"></asp:SqlDataSource>
                                            </td>
                                        </tr>
                                    </table>
                                    <table>
                                        <tr>
                                            <td>Currency:</td>
                                            <td>
                                                <asp:RadioButtonList ID="radioCurrency" runat="server" AutoPostBack="true"
                                                    DataSourceID="SqlDataSourceCurrecny" DataTextField="Currency"
                                                    DataValueField="Currency" RepeatDirection="Horizontal"
                                                    OnDataBound="radioCurrency_DataBound">
                                                </asp:RadioButtonList>
                                                <asp:SqlDataSource ID="SqlDataSourceCurrecny" runat="server"
                                                    ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                    SelectCommand="SELECT * FROM [v_Currency]"></asp:SqlDataSource>
                                            </td>

                                            <td style="padding-left: 2px">
                                                <asp:Button ID="cmdFilter" runat="server" Text="Filter" />
                                            </td>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <div class="Panel1">
                            <table style="border-collapse: collapse">
                                <tr>
                                    <td>Remittance:</td>
                                    <td class="right bold">
                                        <asp:Label ID="lblStatus" runat="server" Text="0" Style="font-size: small"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Incentive:</td>
                                    <td class="right bold">
                                        <asp:Label ID="lblStatusIncentive" runat="server" Text="0" Style="font-size: small"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-top: 1px solid silver">Total Ready:</td>
                                    <td class="right bold" style="border-top: 1px solid silver">
                                        <asp:Label ID="lblTotal" runat="server" Text="0" Style="font-size: small"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td>
                        <asp:Panel runat="server" ID="PanelExport" class="Panel1">
                            Payment Type:
                            <asp:DropDownList ID="cboPaymentType" runat="server">
                                <asp:ListItem Value="R" Text="Remittance"></asp:ListItem>
                                <asp:ListItem Value="I" Text="Incentive"></asp:ListItem>
                            </asp:DropDownList>
                            Top:
                            <asp:TextBox ID="txtTop" runat="server" Text="400" Width="80px"></asp:TextBox>
                            <asp:Button ID="cmdMarkPaid" runat="server" Text="Mark as Paid" Width="100px" Font-Bold="true"
                                Height="30px" OnClick="cmdMarkPaid_Click" />
                            <%--<asp:ConfirmButtonExtender ID="ConfirmButtonExtender2" runat="server"
                                ConfirmText="Do you want to mark all as Paid?" Enabled="True" TargetControlID="cmdMarkPaid"></asp:ConfirmButtonExtender>--%>

                        </asp:Panel>

                        <asp:Panel ID="PanelStatusMarkPaid" runat="server" CssClass="Border Shadow ui-corner-all"
                            Visible="false" Width="300px">
                            <asp:Label ID="lblStatusMarkPaid" runat="server" Text="" Font-Bold="true" Font-Size="Small"></asp:Label>
                        </asp:Panel>
                    </td>
                </tr>
            </table>

            <div style="margin: 0px 0px 50px 10px">
                <div class="group">
                    <h5>Remittance Payment Ready to Export</h5>
                    <div class="group-body">

                        <asp:GridView ID="GridView1" runat="server" BackColor="White" AllowPaging="true"
                            CssClass="Grid" AllowSorting="true" BorderColor="#DEDFDE" BorderStyle="None"
                            BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Both" AutoGenerateColumns="False"
                            PagerSettings-PageButtonCount="20" PageSize="5" DataSourceID="SqlDataSource1" Style="font-size: small; font-family: Arial">
                            <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                            <Columns>
                                <asp:TemplateField HeaderText="RID" SortExpression="ID" ItemStyle-HorizontalAlign="Center"
                                    ItemStyle-Font-Size="Large" ItemStyle-Font-Bold="true">
                                    <ItemTemplate>
                                        <a href='Remittance_Show.aspx?id=<%# Eval("ID") %>' target="_blank">
                                            <%# Eval("PaymentDescription") %></a>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:HyperLink runat="server" ID="cmdID" Text='<%# Bind("ID") %>' Target="_blank"
                                            NavigateUrl='<%# "Remittance_Show.aspx?id=" + Eval("ID") %>'></asp:HyperLink>
                                    </EditItemTemplate>
                                    <ItemStyle Font-Bold="True" Font-Size="Large" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Batch" HeaderText="Batch" SortExpression="Batch" ItemStyle-HorizontalAlign="Center"
                                    ReadOnly="true">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ValueDate" HeaderText="Value Date" SortExpression="ValueDate"
                                    ReadOnly="true" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                                    ReadOnly="true" ItemStyle-HorizontalAlign="Right">
                                    <ItemStyle HorizontalAlign="Right" Font-Bold="true" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Currency" HeaderText="Currency" ReadOnly="true" ItemStyle-HorizontalAlign="Center">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="ExHouse Code" SortExpression="ExHouseCode">
                                    <ItemTemplate>
                                        <span title='<%# Eval("ExHouseName") %>'>
                                            <%# Eval("ExHouseCode") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ToBranchName" SortExpression="ToBranchName">
                                    <ItemTemplate>
                                        <asp:Label ID="lblToBranchName" runat="server" Text='<%# Eval("ToBranchName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Account" HeaderText="Account" SortExpression="Account"
                                    ItemStyle-Wrap="false" />
                                <asp:TemplateField HeaderText="Status" SortExpression="Status" ItemStyle-Wrap="false">
                                    <ItemTemplate>
                                        <%# Eval("Status") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="RemitterName" HeaderText="Remitter Name" SortExpression="RemitterName"
                                    ReadOnly="true" />
                                <asp:BoundField DataField="BeneficiaryName" HeaderText="Beneficiary Name" SortExpression="BeneficiaryName"
                                    ReadOnly="true" />
                                <asp:BoundField DataField="BankName" HeaderText="Bank Name" SortExpression="BankName"
                                    ReadOnly="true" />
                                <asp:BoundField DataField="BranchName" HeaderText="Branch Name" SortExpression="BranchName"
                                    ReadOnly="true" />
                                <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" SortExpression="PaymentMethod"
                                    ReadOnly="true" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="TestNumber" HeaderText="Test Number" SortExpression="TestNumber"
                                    ItemStyle-HorizontalAlign="Center" ReadOnly="true" />
                                <asp:CheckBoxField DataField="Paid" HeaderText="Paid" SortExpression="Paid" ItemStyle-HorizontalAlign="Center"
                                    ReadOnly="true">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:CheckBoxField>
                            </Columns>
                            <FooterStyle BackColor="#CCCC99" />
                            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                            <PagerSettings Position="TopAndBottom" Mode="NumericFirstLast" />
                            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#6B696B" Font-Bold="false" ForeColor="White" />
                            <AlternatingRowStyle BackColor="White" />
                            <EmptyDataTemplate>
                                <div style="border: solid 1px silver; padding: 10px; background-color: #F6F6F6; width: 500px">
                                    No Data Found.
                                </div>
                            </EmptyDataTemplate>
                            <EditRowStyle BackColor="#C5E2FD" />
                        </asp:GridView>
                        <asp:HiddenField ID="hidRoutingMsg" runat="server" Value="" />
                        
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                            SelectCommand="sp_Flora_Ready" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected"
                            UpdateCommand="sp_Flora_Mark_as_Paid" UpdateCommandType="StoredProcedure" OnUpdated="SqlDataSource1_Updated">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="cboBranch" Name="ToBranch" PropertyName="SelectedValue"
                                    Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                                <asp:ControlParameter ControlID="cboExHouse" Name="ExHouse" PropertyName="SelectedValue"
                                    Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
                                <asp:ControlParameter ControlID="radioCurrency" Name="Currency" PropertyName="SelectedValue"
                                    Type="String" ConvertEmptyStringToNull="true" DefaultValue="BDT" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                <asp:ControlParameter ControlID="cboBranch" Name="ToBranch" PropertyName="SelectedValue"
                                    Type="Int32" />
                                <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                                <asp:ControlParameter ControlID="cboExHouse" Name="ExHouse" PropertyName="SelectedValue"
                                    Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
                                <asp:Parameter Name="BatchNo" Type="Int32" Direction="InputOutput" DefaultValue="0" />
                                <asp:Parameter Name="Total" Type="Int32" Direction="InputOutput" DefaultValue="0" />
                                <asp:ControlParameter ControlID="radioCurrency" Name="Currency" PropertyName="SelectedValue"
                                    Type="String" ConvertEmptyStringToNull="true" DefaultValue="BDT" />
                                <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue=" " Size="255" />
                                <asp:ControlParameter ControlID="txtTop" Name="Top" PropertyName="Text"
                                Type="Int32" />
                            <asp:ControlParameter ControlID="cboPaymentType" Name="PaymentType" PropertyName="SelectedValue"
                                Type="String" />
                            </UpdateParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                            SelectCommand="sp_Flora_Ready_Not" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="cboBranch" Name="ToBranch" PropertyName="SelectedValue"
                                    Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                                <asp:ControlParameter ControlID="cboExHouse" Name="ExHouse" PropertyName="SelectedValue"
                                    Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
                                <asp:ControlParameter ControlID="radioCurrency" Name="Currency" PropertyName="SelectedValue"
                                    Type="String" ConvertEmptyStringToNull="true" DefaultValue="BDT" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <br />
                        <br />
                        <asp:GridView ID="GridView2" runat="server" BackColor="White" AllowPaging="true"
                            CssClass="Grid" AllowSorting="true" BorderColor="#DEDFDE" BorderStyle="None"
                            BorderWidth="1px" CellPadding="4" ForeColor="Red" GridLines="Both" AutoGenerateColumns="False"
                            PagerSettings-PageButtonCount="30" DataSourceID="SqlDataSource2" Style="font-size: small; font-family: Arial">
                            <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" ForeColor="Red" />
                            <Columns>
                                <asp:TemplateField HeaderText="RID" SortExpression="ID" ItemStyle-HorizontalAlign="Center"
                                    ItemStyle-Font-Size="Large" ItemStyle-Font-Bold="true">
                                    <ItemTemplate>
                                        <a href='Remittance_Show.aspx?id=<%# Eval("ID") %>' target="_blank">
                                            <%# Eval("PaymentDescription") %></a>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:HyperLink runat="server" ID="cmdID" Text='<%# Bind("ID") %>' Target="_blank"
                                            NavigateUrl='<%# "Remittance_Show.aspx?id=" + Eval("ID") %>'></asp:HyperLink>
                                    </EditItemTemplate>
                                    <ItemStyle Font-Bold="True" Font-Size="Large" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Batch" HeaderText="Batch" SortExpression="Batch" ItemStyle-HorizontalAlign="Center"
                                    ReadOnly="true">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ValueDate" HeaderText="Value Date" SortExpression="ValueDate"
                                    ReadOnly="true" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                                    ReadOnly="true" ItemStyle-HorizontalAlign="Right">
                                    <ItemStyle HorizontalAlign="Right" Font-Bold="true" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Currency" HeaderText="Currency" ReadOnly="true" ItemStyle-HorizontalAlign="Center">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="ExHouse Code" SortExpression="ExHouseCode">
                                    <ItemTemplate>
                                        <span title='<%# Eval("ExHouseName") %>'>
                                            <%# Eval("ExHouseCode") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ToBranchName" SortExpression="ToBranchName">
                                    <ItemTemplate>
                                        <asp:Label ID="lblToBranchName" runat="server" Text='<%# Eval("ToBranchName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Account" HeaderText="Account" SortExpression="Account"
                                    ItemStyle-Wrap="false" />
                                <asp:TemplateField HeaderText="Status" SortExpression="Status" ItemStyle-Wrap="false">
                                    <ItemTemplate>
                                        <%# Eval("Status") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="RemitterName" HeaderText="Remitter Name" SortExpression="RemitterName"
                                    ReadOnly="true" />
                                <asp:BoundField DataField="BeneficiaryName" HeaderText="Beneficiary Name" SortExpression="BeneficiaryName"
                                    ReadOnly="true" />
                                <asp:BoundField DataField="BankName" HeaderText="Bank Name" SortExpression="BankName"
                                    ReadOnly="true" />
                                <asp:BoundField DataField="BranchName" HeaderText="Branch Name" SortExpression="BranchName"
                                    ReadOnly="true" />
                                <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" SortExpression="PaymentMethod"
                                    ReadOnly="true" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="TestNumber" HeaderText="Test Number" SortExpression="TestNumber"
                                    ItemStyle-HorizontalAlign="Center" ReadOnly="true" />
                                <asp:CheckBoxField DataField="Paid" HeaderText="Paid" SortExpression="Paid" ItemStyle-HorizontalAlign="Center"
                                    ReadOnly="true">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:CheckBoxField>
                            </Columns>
                            <FooterStyle BackColor="#CCCC99" />
                            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                            <PagerSettings Position="TopAndBottom" Mode="NumericFirstLast" />
                            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#6B696B" Font-Bold="false" ForeColor="White" />
                            <AlternatingRowStyle BackColor="White" />
                            <EmptyDataTemplate>
                                <div style="border: solid 1px silver; padding: 10px; background-color: #F6F6F6; width: 500px">
                                    No Error Found.
                                </div>
                            </EmptyDataTemplate>
                            <EditRowStyle BackColor="#C5E2FD" />
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <div style="margin: 0px 0px 50px 10px">
                <div class="group">
                    <h5>Incentive Payment Ready to Export</h5>
                    <div class="group-body">

                        <asp:GridView ID="GridView3" runat="server" BackColor="White" AllowPaging="true"
                            CssClass="Grid" AllowSorting="true" BorderColor="#DEDFDE" BorderStyle="None"
                            BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Both" AutoGenerateColumns="False"
                            PagerSettings-PageButtonCount="20" PageSize="5" DataSourceID="SqlDataSource3" Style="font-size: small; font-family: Arial">
                            <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                            <Columns>
                                <asp:TemplateField HeaderText="RID" SortExpression="ID" ItemStyle-HorizontalAlign="Center"
                                    ItemStyle-Font-Size="Large" ItemStyle-Font-Bold="true">
                                    <ItemTemplate>
                                        <a href='Remittance_Show.aspx?id=<%# Eval("RID") %>' target="_blank">
                                            <%# Eval("PaymentDescription") %></a>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:HyperLink runat="server" ID="cmdID" Text='<%# Bind("RID") %>' Target="_blank"
                                            NavigateUrl='<%# "Remittance_Show.aspx?id=" + Eval("RID") %>'></asp:HyperLink>
                                    </EditItemTemplate>
                                    <ItemStyle Font-Bold="True" Font-Size="Large" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Batch" HeaderText="Batch" SortExpression="Batch" ItemStyle-HorizontalAlign="Center"
                                    ReadOnly="true">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ValueDate" HeaderText="Value Date" SortExpression="ValueDate"
                                    ReadOnly="true" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="IncentiveAmount" HeaderText="Incentive Amount" SortExpression="IncentiveAmount" DataFormatString="{0:N2}"
                                    ReadOnly="true" ItemStyle-HorizontalAlign="Right">
                                    <ItemStyle HorizontalAlign="Right" Font-Bold="true" />
                                </asp:BoundField>
                                <asp:BoundField DataField="IncentiveCurrency" HeaderText="Incentive Currency" ReadOnly="true" ItemStyle-HorizontalAlign="Center">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="ExHouse Code" SortExpression="ExHouseCode">
                                    <ItemTemplate>
                                        <span title='<%# Eval("ExHouseName") %>'>
                                            <%# Eval("ExHouseCode") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ToBranchName" SortExpression="ToBranchName">
                                    <ItemTemplate>
                                        <asp:Label ID="lblToBranchName" runat="server" Text='<%# Eval("ToBranchName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Account" HeaderText="Account" SortExpression="Account"
                                    ItemStyle-Wrap="false" />
                                <asp:TemplateField HeaderText="Status" SortExpression="Status" ItemStyle-Wrap="false">
                                    <ItemTemplate>
                                        <%# Eval("Status") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="RemitterName" HeaderText="Remitter Name" SortExpression="RemitterName"
                                    ReadOnly="true" />
                                <asp:BoundField DataField="BeneficiaryName" HeaderText="Beneficiary Name" SortExpression="BeneficiaryName"
                                    ReadOnly="true" />
                                <asp:BoundField DataField="BankName" HeaderText="Bank Name" SortExpression="BankName"
                                    ReadOnly="true" />
                                <asp:BoundField DataField="BranchName" HeaderText="Branch Name" SortExpression="BranchName"
                                    ReadOnly="true" />
                                <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" SortExpression="PaymentMethod"
                                    ReadOnly="true" ItemStyle-HorizontalAlign="Center" />
                                <asp:CheckBoxField DataField="Paid" HeaderText="Paid" SortExpression="Paid" ItemStyle-HorizontalAlign="Center"
                                    ReadOnly="true">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:CheckBoxField>
                            </Columns>
                            <FooterStyle BackColor="#CCCC99" />
                            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                            <PagerSettings Position="TopAndBottom" Mode="NumericFirstLast" />
                            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#6B696B" Font-Bold="false" ForeColor="White" />
                            <AlternatingRowStyle BackColor="White" />
                            <EmptyDataTemplate>
                                <div style="border: solid 1px silver; padding: 10px; background-color: #F6F6F6; width: 500px">
                                    No Data Found.
                                </div>
                            </EmptyDataTemplate>
                            <EditRowStyle BackColor="#C5E2FD" />
                        </asp:GridView>
                        <asp:HiddenField ID="HiddenField1" runat="server" Value="" />


                       
                        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                            SelectCommand="s_Incentive_FLORA_Ready" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource3_Selected"
                           >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="cboBranch" Name="ToBranch" PropertyName="SelectedValue"
                                    Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                                <asp:ControlParameter ControlID="cboExHouse" Name="ExHouse" PropertyName="SelectedValue"
                                    Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
                                <asp:ControlParameter ControlID="radioCurrency" Name="Currency" PropertyName="SelectedValue"
                                    Type="String" ConvertEmptyStringToNull="true" DefaultValue="BDT" />
                            </SelectParameters>
                            
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                            SelectCommand="sp_Flora_Ready_Not" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="cboBranch" Name="ToBranch" PropertyName="SelectedValue"
                                    Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                                <asp:ControlParameter ControlID="cboExHouse" Name="ExHouse" PropertyName="SelectedValue"
                                    Type="String" ConvertEmptyStringToNull="true" DefaultValue="" />
                                <asp:ControlParameter ControlID="radioCurrency" Name="Currency" PropertyName="SelectedValue"
                                    Type="String" ConvertEmptyStringToNull="true" DefaultValue="BDT" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        
                        
                    </div>
                </div>
            </div>
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
        UseAnimation="false" VerticalSide="Middle"></asp:AlwaysVisibleControlExtender>
</asp:Content>
