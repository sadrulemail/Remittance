<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="Remittance.MM_Export" CodeFile="MM_Export.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Export to t-cash
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <table class="SmallFont ui-corner-all Panel1">
                            <tr>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    To Branch:
                                </td>
                                <td>
                                    <asp:DropDownList ID="cboBranch" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                        DataSourceID="SqlDataSourceBranch" DataTextField="BranchName" DataValueField="BranchID"
                                        OnDataBound="cboBranch_DataBound">
                                        <asp:ListItem Value="-1" Text="All"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Head Office"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="SELECT [BranchID], [BranchName] FROM [V_BranchOnly] ORDER by BranchName">
                                    </asp:SqlDataSource>
                                </td>
                                <td>
                                    <asp:Button ID="cmdFilter" runat="server" Text="Filter" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <br />
            <asp:GridView ID="GridView1" runat="server" BackColor="White" AllowPaging="true"
                CssClass="Grid" AllowSorting="true" BorderColor="#DEDFDE" BorderStyle="None"
                BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Both" AutoGenerateColumns="False"
                PagerSettings-PageButtonCount="30" DataSourceID="SqlDataSource1" Style="font-size: small;
                font-family: Arial">
                <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                <Columns>
                    <asp:TemplateField HeaderText="RID" SortExpression="ID" ItemStyle-HorizontalAlign="Center"
                        ItemStyle-Font-Size="Large" ItemStyle-Font-Bold="true">
                        <ItemTemplate>
                            <a href='Remittance_Show.aspx?id=<%# Eval("ID") %>' target="_blank">
                                <%# Eval("ID") %></a>
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
                        ReadOnly="true" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"
                        Visible="false">
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
                    <asp:TemplateField HeaderText="ToBranch Name" SortExpression="ToBranchName">
                        <ItemTemplate>
                            <asp:Label ID="lblToBranchName" runat="server" Text='<%# Eval("ToBranchName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="AccountType" HeaderText="Beneficiary Account Type" SortExpression="AccountType"
                        ItemStyle-HorizontalAlign="Center" Visible="false" />
                    <asp:BoundField DataField="Account" HeaderText="Beneficiary Account" SortExpression="Account"
                        ItemStyle-HorizontalAlign="Center" ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="BeneficiaryName" HeaderText="Beneficiary Name" SortExpression="BeneficiaryName"
                        ReadOnly="true" />
                    <asp:BoundField DataField="RemitterAccType" HeaderText="Remitter Account Type" SortExpression="RemitterAccType"
                        ItemStyle-HorizontalAlign="Center" Visible="false" />
                    <asp:BoundField DataField="RemitterAccount" HeaderText="Remitter Account" SortExpression="RemitterAccount"
                        ItemStyle-HorizontalAlign="Center" ReadOnly="true" ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="RemitterName" HeaderText="Remitter Name" SortExpression="RemitterName"
                        ReadOnly="true" />
                    <asp:BoundField DataField="BankName" HeaderText="Bank Name" SortExpression="BankName"
                        ReadOnly="true" />
                    <asp:BoundField DataField="BranchName" HeaderText="Branch Name" SortExpression="BranchName"
                        ReadOnly="true" />
                    <asp:BoundField DataField="CBS_ID" HeaderText="CBS ID" SortExpression="CBS_ID" ReadOnly="true"
                        Visible="false" />
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
                        No Data Found.</div>
                </EmptyDataTemplate>
                <EditRowStyle BackColor="#C5E2FD" />
            </asp:GridView>
            <asp:HiddenField ID="hidRoutingMsg" runat="server" Value="" />
            <br />
            <asp:Label ID="lblStatus" runat="server" Text="" Style="font-size: small"></asp:Label>
            <br />
            <br />
            <asp:Button ID="cmdMarkPaid" runat="server" Text="Mark All as Paid" Width="200px"
                Font-Bold="true" Height="30px" OnClick="cmdMarkPaid_Click" />
            <asp:ConfirmButtonExtender ID="cmdMarkPaid_ConfirmButtonExtender" runat="server"
                ConfirmText="Do you want to mark all as Paid?" Enabled="True" TargetControlID="cmdMarkPaid">
            </asp:ConfirmButtonExtender>
            <asp:Panel ID="PanelStatusMarkPaid" runat="server" CssClass="Border Shadow ui-corner-all"
                Visible="false" Width="300px">
                <asp:Label ID="lblStatusMarkPaid" runat="server" Text="" Font-Bold="true" Font-Size="Small"></asp:Label>
            </asp:Panel>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_MM_Ready" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected"
                UpdateCommand="sp_MM_Mark_as_Paid" UpdateCommandType="StoredProcedure" OnUpdated="SqlDataSource1_Updated">
                <SelectParameters>
                    <asp:ControlParameter ControlID="cboBranch" Name="ToBranch" PropertyName="SelectedValue"
                        Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                    <asp:ControlParameter ControlID="cboBranch" Name="ToBranch" PropertyName="SelectedValue"
                        Type="Int32" />
                    <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                    <asp:Parameter Name="BatchNo" Type="Int32" Direction="InputOutput" DefaultValue="0" />
                    <asp:Parameter Name="Total" Type="Int32" Direction="InputOutput" DefaultValue="0" />
                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue=" " Size="255" />
                </UpdateParameters>
            </asp:SqlDataSource>
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
