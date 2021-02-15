<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="Remittance.Remittance_Browse" CodeFile="Remittance_Browse.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Browse Remittance
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate> 
            <table >
                <tr>
                    <td>
                        <table class="SmallFont ui-corner-all Panel1">
                            <tr>
                                <td style="padding-left: 2px" colspan="2">
                                    <asp:TextBox ID="txtFilter" runat="server" Width="205px" onfocus="this.select()"
                                        Watermark='enter text to filter' Enabled="false"></asp:TextBox>
                                </td>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right;">
                                    To Branch:
                                </td>
                                <td>
                                    <asp:DropDownList ID="cboBranch" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                        DataSourceID="SqlDataSourceBranch" DataTextField="BranchName" DataValueField="BranchID"
                                        OnDataBound="cboBranch_DataBound" OnSelectedIndexChanged="cboBranch_SelectedIndexChanged">
                                        <asp:ListItem Value="-2" Text=""></asp:ListItem>
                                        <asp:ListItem Value="-1" Text="Branch Assigned"></asp:ListItem>
                                        <asp:ListItem Value="-5" Text="All Payable From My Branch"></asp:ListItem>
                                        <asp:ListItem Value="-3" Text="All Branch (Except Head Office)"></asp:ListItem>
                                        <asp:ListItem Value="-9999" Text="No Branch Assigned"></asp:ListItem>
                                        <asp:ListItem Value="0" Text="Any Branch"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Head Office"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="SELECT [BranchID], [BranchName] FROM [V_BranchOnly] ORDER by BranchName">
                                    </asp:SqlDataSource>
                                </td>                                
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    Paid:
                                </td>
                                <td>
                                    <asp:DropDownList ID="cboPaid" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                        OnSelectedIndexChanged="cboPaid_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="Unpaid"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Paid"></asp:ListItem>
                                        <asp:ListItem Value="-1" Text="Show All"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td style="text-align: right">
                                    Method:
                                </td>
                                <td>
                                    <asp:DropDownList ID="cboPaymentMethod" AutoPostBack="True" runat="server" AppendDataBoundItems="true"
                                        DataSourceID="SqlDataSourcePaymentMethod" DataTextField="PaymentMethodDetails"
                                        DataValueField="PaymentMethod" OnDataBound="cboPaymentMethod_DataBound" 
                                        onselectedindexchanged="cboPaymentMethod_SelectedIndexChanged">
                                        <asp:ListItem Text="ALL" Value="-1"></asp:ListItem>
                                        <asp:ListItem Text="" Value="-2"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourcePaymentMethod" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="SELECT * FROM [v_PaymentMethods] ORDER BY OrderCol"></asp:SqlDataSource>
                                </td>
                                
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtPIN" runat="server" Width="130px" Watermark="PIN Code" onfocus="this.select()"></asp:TextBox>
                                </td>
                                <td style="padding-left: 2px">
                                    <asp:Button ID="cmdFilter" runat="server" Text="Filter" Width="70px" 
                                        onclick="cmdFilter_Click" />
                                </td>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    <asp:Label ID="lblRoutingBank" runat="server" Text="Routing Bank:"></asp:Label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="cboRoutingBank" runat="server" AppendDataBoundItems="true"
                                        AutoPostBack="true" DataSourceID="SqlDataSourceRoutingBank" DataTextField="Bank_Name"
                                        DataValueField="BEFTN_Bank_Code" 
                                        onselectedindexchanged="cboRoutingBank_SelectedIndexChanged" 
                                        ondatabound="cboRoutingBank_DataBound">
                                        <asp:ListItem Text="" Value="-1"></asp:ListItem>
                                        <asp:ListItem Text="Only with Routing Codes" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourceRoutingBank" runat="server" ConnectionString="<%$ ConnectionStrings:TblUserDBConnectionString %>"
                                        SelectCommand="sp_BEFTN_Banks" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                                </td>
                                <td style="text-align: right">
                                    Status:
                                </td>
                                <td>
                                    <asp:DropDownList ID="cboStatus" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cboStatus_SelectedIndexChanged">
                                        <asp:ListItem>ACTIVE</asp:ListItem>
                                        <asp:ListItem>ON HOLD</asp:ListItem>
                                        <asp:ListItem>CANCEL</asp:ListItem>
                                        <asp:ListItem>RETURN</asp:ListItem>
                                        <asp:ListItem>REJECT</asp:ListItem>
                                        <asp:ListItem>ALL</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    Show:
                                </td>
                                <td>
                                    <asp:DropDownList ID="dboTop" runat="server" AutoPostBack="true" 
                                        CausesValidation="false" onselectedindexchanged="dboTop_SelectedIndexChanged">
                                    <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    <asp:ListItem Value="1000" Text="1000"></asp:ListItem>
                                    <asp:ListItem Value="5000" Text="5000"></asp:ListItem>
                                    <asp:ListItem Value="10000" Text="10000"></asp:ListItem>
                                    <asp:ListItem Value="50000" Text="50000"></asp:ListItem>
                                    <asp:ListItem Value="100000" Text="100000"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;
                                </td>
                                <td style="padding-left: 2px">
                                    &nbsp;
                                </td>                                
                                <td align="right">
                                    Ex-House:
                                </td>
                                <td  colspan="4" align="left">
                                    <asp:DropDownList ID="cboExHouse" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                        DataSourceID="SqlDataSource2" DataTextField="ExHouseName" DataValueField="ExHouseCode">
                                        <asp:ListItem Value="-1" Text="All"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="SELECT [ExHouseCode], ExHouseCode+', '+[ExHouseName] as ExHouseName FROM [v_ExHouseListDetails] ORDER BY ExHouseName">
                                    </asp:SqlDataSource>
                                </td>
                                <td  align="right">
                                    <asp:DropDownList ID="cboPub" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cboPub_SelectedIndexChanged">
                                        <asp:ListItem Value="P" Text="Published"></asp:ListItem>
                                        <asp:ListItem Value="N" Text="Not Published"></asp:ListItem>
                                        <asp:ListItem Value="*" Text="All"></asp:ListItem>                                        
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <br />
            <asp:GridView ID="GridView1" runat="server" BackColor="White" AllowPaging="True" 
                CssClass="Grid" AllowSorting="True" BorderColor="#DEDFDE" BorderStyle="None"
                Width="100%" BorderWidth="1px" CellPadding="4" ForeColor="Black" AutoGenerateColumns="False"
                PagerSettings-PageButtonCount="30" DataSourceID="SqlDataSource1" Style="font-size: small;
                font-family: Arial" OnDataBound="GridView1_DataBound" OnRowDataBound="GridView1_RowDataBound"
                OnRowCommand="GridView1_RowCommand" OnRowUpdated="GridView1_RowUpdated">
                <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
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
                            <asp:HyperLink ID="hypBatch" NavigateUrl='<%# string.Format("ShowBatch.aspx?batch={0}#{1}", Eval("Batch"), Eval("ID")) %>'
                                runat="server" ToolTip="Show Batch" Target="_blank" Visible='<%# ((TrustControl1.isRole("ADMIN","UPLOAD")) ? true : false) %>'
                                Text='<%# Eval("Batch") %>'>
                            </asp:HyperLink>
                            <asp:Label ID="lblBatch" runat="server" Target="_blank" Visible='<%# ((TrustControl1.isRole("ADMIN","UPLOAD")) ? false : true) %>'
                                Text='<%# Eval("Batch") %>'>
                            </asp:Label>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="ValueDate" HeaderText="Value Date" SortExpression="ValueDate"
                        ReadOnly="true" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center" Visible="false">
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
                                <%# Eval("ExHouseCode") %></span></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="ToBranchName" SortExpression="ToBranchName">
                        <ItemTemplate>
                            <asp:Label ID="lblToBranchName" runat="server" Text='<%# Eval("ToBranchName") %>'
                                ToolTip='<%# Eval("ToBranch") %>'>
                            </asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Routing Number" SortExpression="RoutingNumber">
                        <ItemTemplate>
                            <uc3:BEFTN ID="BEFTN1" runat="server" Code='<%# Eval("RoutingNumber") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="A/C No" SortExpression="Account">
                        <ItemTemplate>
                            <%# Eval("Account") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Status" SortExpression="Status" ItemStyle-Wrap="false">
                        <ItemTemplate>
                            <%# Eval("Status") %></ItemTemplate>
                        <ItemStyle Wrap="False" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Payment Method" SortExpression="PaymentMethod">
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("PaymentMethod") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="RemitterName" HeaderText="Remitter Name" SortExpression="RemitterName"
                        ReadOnly="true" />
                    <asp:BoundField DataField="BeneficiaryName" HeaderText="Beneficiary Name" SortExpression="BeneficiaryName"
                        ReadOnly="true" />
                    <asp:BoundField DataField="BankName" HeaderText="Bank Name" SortExpression="BankName"
                        ReadOnly="true" />
                    <asp:BoundField DataField="BranchName" HeaderText="Branch Name" SortExpression="BranchName"
                        ReadOnly="true" />
                    <asp:BoundField DataField="TestNumber" HeaderText="Test Number" SortExpression="TestNumber"
                        ItemStyle-HorizontalAlign="Center" ReadOnly="true" Visible="false">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Paid" SortExpression="Paid">
                        <ItemTemplate>
                            <%# (Eval("Paid").ToString() == "True") ? "<img src='Images/tick.png' width='20px' height='20px'>" : ""%>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Published" SortExpression="Published">
                        <ItemTemplate>
                            <%# (Eval("Published").ToString() == "True") ? "<img src='Images/tick.png' width='20px' height='20px'>" : ""%>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="PaidOn" HeaderText="Paid On" SortExpression="PaidOn" ReadOnly="true" Visible="false" />
                    <asp:TemplateField HeaderText="PaidBy" SortExpression="Paid By" ItemStyle-HorizontalAlign="Center" Visible="false">
                        <ItemTemplate>
                            <uc2:EMP ID="EMP1" Username='<%# Eval("PaidBy") %>' Position="Left" runat="server" />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
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
            <asp:Label ID="lblStatus" runat="server" Text="" Style="font-size: small"></asp:Label><br />
            <br />
            <asp:Button ID="cmdExport" runat="server" Text="Download as xlsx" Width="150px" Font-Bold="true"
                Height="30px" OnClick="cmdExport_Click" Visible="false" />
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_RemiList_Browse" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected"
                EnableCaching="false">
                <SelectParameters>
                    <asp:ControlParameter ControlID="txtFilter" Name="Filter" PropertyName="Text" Type="String"
                        DefaultValue="*" />
                    <asp:ControlParameter ControlID="cboBranch" Name="ToBranch" PropertyName="SelectedValue"
                        Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                    <asp:ControlParameter ControlID="cboPaid" Name="Paid" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="cboRoutingBank" Name="RoutingBank" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="cboStatus" Name="Status" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="txtPIN" Name="PIN" PropertyName="Text" DefaultValue=""
                        Type="String" ConvertEmptyStringToNull="false" />
                    <asp:SessionParameter Name="MyBranchID" SessionField="BRANCHID" Type="Int32" ConvertEmptyStringToNull="true"
                        DefaultValue="" />
                    <asp:ControlParameter ControlID="cboPaymentMethod" Name="PaymentMethod" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="dboTop" Name="Top" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="cboExHouse" Name="ExHouse" PropertyName="SelectedValue"
                        Type="String" DefaultValue="-1" />
                    <asp:ControlParameter ControlID="cboPub" Name="Published" PropertyName="SelectedValue"
                        Type="String" DefaultValue="P" />
                </SelectParameters>
            </asp:SqlDataSource>
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
