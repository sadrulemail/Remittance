<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    Inherits="Remittance.Remittance_Show" EnableEventValidation="false" CodeFile="Remittance_Show.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        function setIDType(txt) {
            var t = document.getElementById("ctl00_ContentPlaceHolder2_txtIDType");
            t.value = txt;
        }
        function setReason(txt) {
            var t = document.getElementById("ctl00_ContentPlaceHolder2_txtUnpaidReason");
            t.value = txt;
        }
    </script>
    <style>
        .group-body {
            display: inline-block;
            vertical-align: top;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text=""></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="margin-left: 20px">
                <asp:Panel ID="PanelGoto" runat="server">
                    <table class="Panel1" style="margin-left: 5px;">
                        <tr>
                            <td style="padding-left: 7px">Remittance ID:
                            </td>
                            <td>
                                <asp:TextBox ID="txtRID" runat="server" Width="80px" CssClass="Center"></asp:TextBox>
                                <asp:FilteredTextBoxExtender runat="server" ID="FilteredTextBoxExtenderNumberOnly"
                                    TargetControlID="txtRID" ValidChars="0123456789"></asp:FilteredTextBoxExtender>
                            </td>
                            <td>
                                <asp:Button ID="cmdOK" runat="server" Text="Go" OnClick="cmdOK_Click" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:Panel ID="PanelRemittance" runat="server">
                    <asp:Panel runat="server" ID="PanelStatus" Visible="false">
                        <table class="Panel1 ui-corner-all" style="margin-left: 25px; margin-top: 10px">
                            <tr>
                                <td style="padding: 7px">
                                    <asp:Label ID="lblRemittanceStatus" runat="server" Text="" Font-Bold="true" Font-Size="Larger"></asp:Label>
                                </td>
                            </tr>
                        </table>
                        <br />
                    </asp:Panel>
                    <div style="padding: 10px 20px 20px 0px">
                        <table>
                            <tr>
                                <td valign="top">
                                    <div style="padding: 12px" class="ui-corner-all Panel2">
                                        <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" CellPadding="2"
                                            DataSourceID="SqlDataSource1" ForeColor="Black" BackColor="#FFFFB5" Style="font-size: small"
                                            DataKeyNames="ID" CssClass="Grid" OnDataBound="DetailsView1_DataBound">
                                            <FooterStyle BackColor="#CCCC99" />
                                            <RowStyle VerticalAlign="Middle" />
                                            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                                            <Fields>
                                                <asp:BoundField DataField="ID" HeaderText="Remittance ID" SortExpression="ID" ItemStyle-Font-Bold="true"
                                                    ItemStyle-Font-Size="Large" HeaderStyle-Font-Bold="true">
                                                    <HeaderStyle Font-Bold="True" />
                                                    <ItemStyle Font-Bold="True" Font-Size="Large" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Batch" HeaderText="Batch" SortExpression="Batch" />
                                                <asp:TemplateField HeaderText="ExHouse" SortExpression="ExHouseCode">
                                                    <ItemTemplate>
                                                        <%# Eval("ExHouseName")%>
                                                        (<b><%# Eval("ExHouseCode") %></b>)
                                                        <%# Eval("ExHouse_Type","(<b>{0}</b>)") %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="RemitterName" HeaderText="Remitter Name" SortExpression="RemitterName" />
                                                <asp:BoundField DataField="RemitterAddress" HeaderText="Remitter Address" SortExpression="RemitterAddress"
                                                    HtmlEncode="false" />
                                                <asp:BoundField DataField="RemitterAccount" HeaderText="Remitter Account" SortExpression="RemitterAccount"
                                                    HtmlEncode="false" />
                                                <asp:BoundField DataField="RemitterAccType" HeaderText="Remitter Acc Type" SortExpression="RemitterAccType"
                                                    HtmlEncode="false" />
                                                <asp:BoundField DataField="BeneficiaryName" HeaderText="Beneficiary Name" SortExpression="BeneficiaryName"
                                                    ItemStyle-Font-Bold="true" ItemStyle-Font-Size="Medium" HeaderStyle-Font-Bold="true">
                                                    <HeaderStyle Font-Bold="True" />
                                                    <ItemStyle Font-Bold="True" Font-Size="Medium" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="BeneficiaryAddress" HeaderText="Beneficiary Address" SortExpression="BeneficiaryAddress"
                                                    HtmlEncode="false" />
                                                <asp:BoundField DataField="BankName" HeaderText="Bank Name" SortExpression="BankName" />
                                                <asp:BoundField DataField="BranchName" HeaderText="Branch Name" SortExpression="BranchName" />
                                                <asp:BoundField DataField="Area" HeaderText="Area" SortExpression="Area" />
                                                <asp:BoundField DataField="District" HeaderText="District" SortExpression="District" />
                                                <asp:BoundField DataField="Account" HeaderText="A/C Number" SortExpression="Account" />
                                                <asp:BoundField DataField="AccountType" HeaderText="A/C Type" SortExpression="AccountType" />
                                                <asp:TemplateField HeaderText="Amount" SortExpression="Amount">
                                                    <ItemTemplate>
                                                        <span style="font-weight: bold; font-size: 130%">
                                                            <%# Eval("Amount", "{0:N2}") %></span>
                                                        <%# Eval("AmountInWord", "({0})")%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="Currency" HeaderText="Currency" ItemStyle-Font-Size="Larger"
                                                    ItemStyle-Font-Bold="true">
                                                    <ItemStyle Font-Bold="True" Font-Size="Larger" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="PIN" HeaderText="PIN" SortExpression="PIN" Visible="false" />
                                                <asp:BoundField DataField="Password" HeaderText="Password" SortExpression="Password" />
                                                <asp:BoundField DataField="RefOrderReceipt" HeaderText="Ref Order Receipt" SortExpression="RefOrderReceipt" />
                                                <asp:BoundField DataField="Contact" HeaderText="Contact" SortExpression="Contact" />
                                                <asp:BoundField DataField="Purpose" HeaderText="Purpose" SortExpression="Purpose" />
                                                <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" SortExpression="PaymentMethod"
                                                    HtmlEncode="false" ItemStyle-Font-Bold="true">
                                                    <ItemStyle Font-Bold="True" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="ValueDate" HeaderText="Value Date" SortExpression="ValueDate"
                                                    DataFormatString="{0:dd/MM/yyyy}"></asp:BoundField>
                                                <asp:TemplateField HeaderText="Routing Code" HeaderStyle-Font-Bold="true">
                                                    <ItemTemplate>
                                                        <uc3:BEFTN ID="BEFTN1" runat="server" Code='<%# Eval("RoutingNumber") %>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Font-Size="Large" />
                                                    <HeaderStyle Font-Bold="True" />
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="SL" HeaderText="SL" SortExpression="SL" />
                                                <asp:BoundField DataField="BeneficiaryID" HeaderText="Beneficiary ID" SortExpression="BeneficiaryID" />
                                                <asp:BoundField DataField="TestNumber" HeaderText="Test Number" SortExpression="TestNumber" />
                                                <asp:TemplateField HeaderText="To Branch">
                                                    <ItemTemplate>
                                                        <%# Eval("ToBranchName")%><%# Eval("ToBranch", " ({0})")%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField ShowHeader="false" ItemStyle-BackColor="White">
                                                    <ItemTemplate>
                                                        <div style="background-color: #C5D8F4; width: 100%; height: 3px">
                                                        </div>
                                                    </ItemTemplate>
                                                    <ItemStyle BackColor="White" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Insert By" SortExpression="EmpID">
                                                    <ItemTemplate>
                                                        <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("EmpID") %>' />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Insert DT">
                                                    <ItemTemplate>
                                                        <%# ((Eval("InsertDT")).ToString() != "") ? "<div title='" + Eval("InsertDT", "{0:dddd \ndd MMMM, yyyy \nh:mm:ss tt}") + "'>" + Eval("InsertDT") + " <span class='time-small'>(<time class='timeago' datetime='" + Eval("InsertDT", "{0:yyyy-MM-dd HH:mm:ss}") + "'></time>)</span></div>" : ""%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Modify By" SortExpression="ModifyBy">
                                                    <ItemTemplate>
                                                        <uc2:EMP ID="EMP2" runat="server" Username='<%# Eval("ModifyBy") %>' />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Modify DT">
                                                    <ItemTemplate>
                                                        <%# ((Eval("ModifyDT")).ToString() != "") ? "<div title='" + Eval("ModifyDT", "{0:dddd \ndd MMMM, yyyy \nh:mm:ss tt}") + "'>" + Eval("ModifyDT") + " <span class='time-small'>(<time class='timeago' datetime='" + Eval("ModifyDT", "{0:yyyy-MM-dd HH:mm:ss}") + "'></time>)</span></div>" : ""%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField ShowHeader="false" ItemStyle-BackColor="White">
                                                    <ItemTemplate>
                                                        <div style="background-color: #C5D8F4; width: 100%; height: 3px">
                                                        </div>
                                                    </ItemTemplate>
                                                    <ItemStyle BackColor="White" />
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="Status" HeaderText="Status" ItemStyle-Font-Bold="true">
                                                    <ItemStyle Font-Bold="True" />
                                                </asp:BoundField>
                                                <asp:TemplateField HeaderText="Allow Payment">
                                                    <ItemTemplate>
                                                        <%# (Eval("AllowPayment").ToString() == "False") ? "<img src='Images/cross.png' width='20' height='20'>" : ""%>
                                                    </ItemTemplate>
                                                    <HeaderStyle Font-Bold="true" />
                                                </asp:TemplateField>
                                                <asp:CheckBoxField DataField="Published" HeaderText="Published" Visible="false" />
                                                <asp:TemplateField HeaderText="Paid">
                                                    <ItemTemplate>
                                                        <%# (Eval("Paid").ToString() == "True") ? "<img src='Images/tick.png' width='30' height='30'>" : ""%>
                                                    </ItemTemplate>
                                                    <HeaderStyle Font-Bold="true" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Paid By" SortExpression="PaidBy">
                                                    <ItemTemplate>
                                                        <uc2:EMP ID="EMP3" runat="server" Username='<%# Eval("PaidBy") %>' />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Paid On">
                                                    <ItemTemplate>
                                                        <%# ((Eval("PaidOn")).ToString() != "") ? "<div title='" + Eval("PaidOn", "{0:dddd \ndd MMMM, yyyy \nh:mm:ss tt}") + "'>" + Eval("PaidOn") + " <span class='time-small'>(<time class='timeago' datetime='" + Eval("PaidOn", "{0:yyyy-MM-dd HH:mm:ss}") + "'></time>)</span></div>" : ""%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Paid Branch">
                                                    <ItemTemplate>
                                                        <%# Eval("PaidBranchName")%><%# Eval("PaidBranch", " ({0})")%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="Paid_Batch" HeaderText="Paid Batch ID" SortExpression="Paid_Batch" />
                                                <asp:BoundField DataField="Instrument" HeaderText="Instrument No." SortExpression="Instrument"
                                                    ItemStyle-Font-Bold="true" HeaderStyle-Font-Bold="true">
                                                    <HeaderStyle Font-Bold="True" />
                                                    <ItemStyle Font-Bold="True" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="InstrumentDate" HeaderText="Instrument Date" SortExpression="InstrumentDate"
                                                    DataFormatString="{0:dd/MM/yyyy}" />
                                                <asp:BoundField DataField="BEFTN_BatchID" HeaderText="BEFTN Batch" SortExpression="BEFTN_BatchID"
                                                    Visible="false" />
                                                <asp:BoundField DataField="IDType" HeaderText="ID Type" SortExpression="IDType" />
                                                <asp:BoundField DataField="IDNumber" HeaderText="ID Number" SortExpression="IDNumber" />
                                                <asp:BoundField DataField="IDExpityDate" HeaderText="ID Expiry Date" SortExpression="IDExpityDate"
                                                    DataFormatString="{0:dd/MM/yyyy}" />
                                                <asp:BoundField DataField="CommentStatus" HeaderText="Comment Status" SortExpression="CommentStatus"
                                                    Visible="false" />
                                                <asp:BoundField DataField="Flora_IC_BatchID" HeaderText="Flora IC BatchID" SortExpression="Flora_IC_BatchID"
                                                    Visible="false" />
                                                <asp:TemplateField ShowHeader="False" ControlStyle-Width="100px">
                                                    <ItemTemplate>
                                                        <asp:Button CssClass="Button" Font-Size="Small" ID="cmdRemiEdit" runat="server" OnClick='cmdRemiEdit_Click'
                                                            Text="Edit" Visible='<%# isRowEditable(Eval("Paid"), Eval("Published")) %>'></asp:Button>
                                                    </ItemTemplate>
                                                    <ControlStyle Width="100px" />
                                                </asp:TemplateField>
                                            </Fields>
                                            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                            <EditRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                            <EmptyDataTemplate>
                                                Remittance Not Found.
                                            </EmptyDataTemplate>
                                            <EmptyDataRowStyle Font-Size="Large" Font-Bold="true" ForeColor="Red" CssClass="Panel1" />
                                        </asp:DetailsView>
                                        <asp:DetailsView ID="DetailsView2" runat="server" AutoGenerateRows="False" CellPadding="4"
                                            DataSourceID="SqlDataSource1" ForeColor="Black" BackColor="White" BorderColor="#DEDFDE" Style="font-size: small"
                                            BorderStyle="Solid" BorderWidth="1px" DataKeyNames="ID" CssClass="Grid" Visible="false" OnItemUpdated="DetailsView2_ItemUpdated">
                                            <FooterStyle BackColor="#CCCC99" />
                                            <RowStyle BackColor="#F7F7DE" VerticalAlign="Middle" />
                                            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                                            <Fields>
                                                <asp:BoundField DataField="ID" HeaderText="RID" SortExpression="ID" ReadOnly="true"
                                                    ItemStyle-Font-Bold="true" ItemStyle-Font-Size="Large">
                                                    <ItemStyle Font-Bold="True" Font-Size="Large" />
                                                </asp:BoundField>
                                                <asp:TemplateField HeaderText="Ex-House" SortExpression="ExHouseCode">
                                                    <ItemTemplate>
                                                        <%# Eval("ExHouseName") %>
                                                        <span style="margin-left: 10px" class="bold">
                                                            <asp:Label runat="server" ID="lblExHouseCode" Text='<%# Eval("ExHouseCode") %>'></asp:Label>
                                                        </span>

                                                    </ItemTemplate>
                                                    <ControlStyle Width="100px" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Amount" SortExpression="Amount">
                                                    <ItemTemplate>
                                                        <span style="font-weight: bold">
                                                            <%# Eval("Amount", "{0:N2}") %>
                                                            <%# Eval("Currency") %></span>
                                                        <%# Eval("AmountInWord", "({0})")%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="ToBranch Name" SortExpression="ToBranchName">
                                                    <%--<ItemTemplate>                            
                                                <asp:Label ID="lblToBranchName" runat="server" Text='<%# Eval("ToBranchName") %>'>
                                                </asp:Label>
                                            </ItemTemplate>--%>
                                                    <EditItemTemplate>
                                                        <asp:DropDownList ID="cboToBranch" runat="server" DataSourceID="SqlDataSourceToBranch"
                                                            AppendDataBoundItems="true" DataTextField="BranchName" DataValueField="BranchID"
                                                            SelectedValue='<%# Bind("ToBranch") %>'>
                                                            <asp:ListItem Text="" Value=""></asp:ListItem>
                                                            <asp:ListItem Text="Any Branch" Value="0"></asp:ListItem>
                                                            <asp:ListItem Text="Head Office" Value="1"></asp:ListItem>
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlDataSourceToBranch" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                            SelectCommand="SELECT [BranchName], [BranchID] FROM [V_BranchOnly] ORDER BY [BranchName]"></asp:SqlDataSource>
                                                    </EditItemTemplate>
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Status" SortExpression="Status" ItemStyle-Wrap="false">
                                                    <ItemTemplate>
                                                        <%# Eval("Status") %>
                                                    </ItemTemplate>
                                                    <EditItemTemplate>
                                                        <asp:DropDownList ID="cboStatus" runat="server" AutoPostBack="true"
                                                            OnSelectedIndexChanged="cboStatus_SelectedIndexChanged" OnDataBound="cboStatus_OnDataBound"
                                                            DataTextField="Status" SelectedValue='<%# Bind("Status") %>'>
                                                            <asp:ListItem>ACTIVE</asp:ListItem>
                                                            <asp:ListItem>ON HOLD</asp:ListItem>
                                                            <asp:ListItem>CANCEL</asp:ListItem>
                                                            <asp:ListItem>RETURN</asp:ListItem>
                                                            <asp:ListItem>REJECT</asp:ListItem>
                                                        </asp:DropDownList>
                                                        <asp:TextBox ID="txtReason" MaxLength="50" Width="250px" Watermark="Reason" Visible="false" runat="server"></asp:TextBox>
                                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidatorReason" Enabled="false" ControlToValidate="txtReason" ValidationGroup="grpRiaComment" runat="server" ErrorMessage="RequiredFieldValidator"></asp:RequiredFieldValidator>--%>
                                                    </EditItemTemplate>
                                                    <ItemStyle Wrap="False" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Payment Method" SortExpression="PaymentMethod">
                                                    <EditItemTemplate>
                                                        <asp:DropDownList ID="cboPaymentMethod" runat="server" AppendDataBoundItems="True"
                                                            DataSourceID="SqlDataSourcePaymentMethod" DataTextField="PaymentMethodDetails"
                                                            DataValueField="PaymentMethod" SelectedValue='<%# Bind("PaymentMethod") %>' OnDataBound="cboPaymentMethod_DataBound">
                                                            <asp:ListItem Text="Not Assigned" Value=""></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <%# Eval("PaymentMethod") %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Beneficiary Name" SortExpression="BeneficiaryName">
                                                    <ItemTemplate>
                                                        <%# Eval("BeneficiaryName")%>
                                                    </ItemTemplate>
                                                    <EditItemTemplate>
                                                        <asp:TextBox runat="server" ID="txtBeneficiaryName" Text='<%# Bind("BeneficiaryName") %>'
                                                            Width="350px" MaxLength="255" Watermark="Beneficiary Name"></asp:TextBox>
                                                    </EditItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Beneficiary Account" SortExpression="Account">
                                                    <ItemTemplate>
                                                        <%# Eval("Account")%>
                                                    </ItemTemplate>
                                                    <ItemStyle Wrap="false" />
                                                    <EditItemTemplate>
                                                        <asp:TextBox runat="server" ID="txtAccount" Text='<%# Bind("Account") %>' Width="200px"
                                                            MaxLength="50" Watermark="Beneficiary A/C"></asp:TextBox>
                                                    </EditItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Routing Number" SortExpression="RoutingNumber">
                                                    <EditItemTemplate>
                                                        <asp:TextBox AutoCompleteType="None" ID="txtRoutingNumber" onclick="this.select()"
                                                            Watermark="Routing No." Text='<%# Bind("RoutingNumber") %>' runat="server" Width="100px"
                                                            CausesValidation="false" CssClass="BEFTNSearchBox">
                                                        </asp:TextBox>
                                                        <uc3:BEFTN ID="BEFTN1" runat="server" Code='<%# Eval("RoutingNumber") %>' />
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <uc3:BEFTN ID="BEFTN1" runat="server" Code='<%# Eval("RoutingNumber") %>' />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:CheckBoxField HeaderText="Published" DataField="Published" SortExpression="Published"
                                                    ItemStyle-HorizontalAlign="Left" ReadOnly="true">
                                                    <ItemStyle HorizontalAlign="Left" />
                                                </asp:CheckBoxField>
                                                <asp:TemplateField ShowHeader="False" ControlStyle-Width="100px">
                                                    <EditItemTemplate>
                                                        <asp:Button ID="cmdUpdateM" runat="server" CausesValidation="True" ValidationGroup="grpRiaComment" CommandName="Update"
                                                            Text="Update" />
                                                        <%--<asp:ConfirmButtonExtender ID="cmdUpdateM_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Update?"
                                                            Enabled="True" TargetControlID="cmdUpdateM">
                                                        </asp:ConfirmButtonExtender>--%>
                                                        <asp:Button ID="cmdCancel" runat="server" Text="Cancel" CausesValidation="false" OnClick="cmdCancel_Click" />
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:Button ID="cmdEdit" runat="server" CausesValidation="False" CommandName="Edit"
                                                            Text="Edit" />
                                                    </ItemTemplate>
                                                    <ControlStyle Width="100px" />
                                                </asp:TemplateField>
                                            </Fields>
                                            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                            <AlternatingRowStyle BackColor="White" />
                                            <EmptyDataTemplate>
                                                Remittance Not Found.
                                            </EmptyDataTemplate>
                                            <EmptyDataRowStyle Font-Size="Large" Font-Bold="true" ForeColor="Red" CssClass="Panel1" />
                                        </asp:DetailsView>
                                        <asp:HiddenField ID="hidRoutingMsg" runat="server" Value="" />
                                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                            SelectCommand="sp_Remittance_Select" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected"
                                            UpdateCommand="sp_RemiList_Update" UpdateCommandType="StoredProcedure" OnUpdated="SqlDataSource1_Updated"
                                            OnUpdating="SqlDataSource1_Updating">
                                            <SelectParameters>
                                                <asp:QueryStringParameter Name="ID" QueryStringField="id" Type="Int64" />
                                            </SelectParameters>
                                            <UpdateParameters>
                                                <asp:Parameter Name="ID" Type="Int32" Direction="InputOutput" DefaultValue="0" />
                                                <asp:Parameter Name="ToBranch" Type="Int32" />
                                                <asp:SessionParameter Name="ModifyBy" SessionField="EMPID" Type="String" />
                                                <asp:Parameter Name="Msg" Type="String" Direction="InputOutput" DefaultValue="" Size="255" />
                                                <asp:Parameter Name="FocusControl" Type="String" Direction="InputOutput" DefaultValue=""
                                                    Size="50" />
                                                <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                                <asp:Parameter Name="RoutingNumber" Type="String" />
                                                <asp:Parameter Name="Status" Type="String" />
                                                <asp:Parameter Name="PaymentMethod" Type="String" DefaultValue="" />
                                                <asp:Parameter Name="BeneficiaryName" Type="String" DefaultValue="" />
                                                <asp:Parameter Name="Account" Type="String" DefaultValue="" />
                                                <asp:Parameter Name="Done" Type="Boolean" DefaultValue="false" Direction="InputOutput" />
                                            </UpdateParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </td>
                                <td valign="top" style="padding-left: 20px; max-width: 400px">
                                    <asp:Panel ID="PanelHistory" runat="server" CssClass="ui-corner-all Panel2 centertext">
                                        <div class="bold">
                                            Change History
                                        </div>
                                        <asp:Panel ID="PanelHistoryList" runat="server" Style="border: solid 1px White; background-color: #F5F5F5; padding: 3px; margin: 5px"
                                            Height="280px" ScrollBars="Vertical" CssClass="ui-corner-all">
                                            <asp:DataList ID="DataListHistory" runat="server" CssClass="Grid" BorderColor="#DEDFDE"
                                                BorderStyle="Solid" BorderWidth="1px" CellPadding="4" DataKeyField="ID" DataSourceID="SqlDataSourceRemilistHistory"
                                                ForeColor="Black" GridLines="Both">
                                                <ItemTemplate>
                                                    <span title='<%# Eval("ID") %>'>
                                                        <%# Eval("[#]","<b># {0}</b>") %></span>
                                                    <br />
                                                    Beneficiary:
                                                    <%# Eval("BeneficiaryName") %>
                                                    <%# Eval("Account", "<br />Account: {0}") %>
                                                    <br />
                                                    Payment Method:
                                                    <%# Eval("PaymentMethod") %>
                                                    <uc3:BEFTN ID="BEFTN_History" runat="server" Code='<%# Eval("RoutingNumber") %>'
                                                        TextFormat="<br />Routing Number: {0}" />
                                                    <%# Eval("BankName", "<br />Bank Name: {0}") %>
                                                    <%# Eval("BranchName", "<br />Branch: {0}") %>
                                                    <%# Eval("District", "<br />District: {0}")%>
                                                    <%# Eval("ToBranch", "<br />To Branch: {0}") %>
                                                    <%# Eval("Status","<br />Status: {0}") %>
                                                    <div style="color: Gray">
                                                        Modified: <span title='<%# Eval("ModifyDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                                            <%# TrustControl1.ToRecentDateTime(Eval("ModifyDT")) %>
                                                            (<time class="timeago" datetime='<%# Eval("ModifyDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>)</span>
                                                        <br />
                                                        By:
                                                        <uc2:EMP ID="EMPHistory" runat="server" Username='<%# Eval("ModifyBy") %>' />
                                                    </div>
                                                </ItemTemplate>
                                                <AlternatingItemStyle BackColor="White" />
                                                <ItemStyle BackColor="#F7F7DE" HorizontalAlign="Left" CssClass="TDTR" />
                                            </asp:DataList>
                                            <asp:SqlDataSource ID="SqlDataSourceRemilistHistory" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                SelectCommand="sp_RemiList_History_Select" SelectCommandType="StoredProcedure"
                                                OnSelected="SqlDataSourceRemilistHistory_Selected">
                                                <SelectParameters>
                                                    <asp:QueryStringParameter Name="ID" QueryStringField="id" Type="Int64" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                            <asp:SqlDataSource ID="SqlDataSourcePaymentMethod" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                SelectCommand="SELECT * FROM [v_PaymentMethods] ORDER BY OrderCol"></asp:SqlDataSource>
                                            <br />
                                        </asp:Panel>
                                    </asp:Panel>
                                    <br />
                                    <asp:Panel ID="PanelReturnHistory" runat="server" CssClass="ui-corner-all Panel2 centertext">
                                        <div class="bold">
                                            Return History
                                        </div>
                                        <asp:Panel ID="PanelReturnHistoryList" runat="server" Style="border: solid 1px White; background-color: #F5F5F5; padding: 3px; margin: 5px"
                                            Height="280px" ScrollBars="Vertical" CssClass="ui-corner-all">
                                            <asp:DataList ID="DataListReturnHistory" runat="server" CssClass="Grid" BorderColor="#DEDFDE"
                                                BorderStyle="Solid" BorderWidth="1px" CellPadding="4" DataKeyField="ID" DataSourceID="SqlDataSourceReturnHistory"
                                                ForeColor="Black" GridLines="Both">
                                                <ItemTemplate>
                                                    <span title='<%# Eval("ID") %>'>
                                                        <%# Eval("[#]","<b># {0}</b>") %></span>
                                                    <br />
                                                    Beneficiary:
                                                    <%# Eval("BeneficiaryName") %>
                                                    <%# Eval("Account", "<br />Account: {0}") %>
                                                    <br />
                                                    <%# Eval("PaymentMethod","Payment Method: {0}") %>
                                                    <br />
                                                    <%# Eval("Paid_Batch", "Paid Batch: {0}")%>
                                                    <uc3:BEFTN ID="BEFTN_History_Return" runat="server" Code='<%# Eval("RoutingNumber") %>'
                                                        TextFormat="<br />Routing Number: {0}" />
                                                    <br />
                                                    Status: RETURN<br />

                                                    Return Reason:
                                                    <%# Eval("ReasonOfReturn","<b>{0}</b>")%> <%# Eval("ReturnReasonID", "({0})")%>
                                                    <div style="color: Gray">
                                                        Return: <span title='<%# Eval("ReturnOn","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                                            <%# TrustControl1.ToRecentDateTime(Eval("ReturnOn"))%>
                                                            (<time class="timeago" datetime='<%# Eval("ReturnOn","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>)</span>
                                                        <br />
                                                        By:
                                                        <uc2:EMP ID="EMPHistoryReturn" runat="server" Username='<%# Eval("ReturnBy") %>' />
                                                    </div>
                                                    <div class='<%# (Eval("Rollbacked").ToString() == "True") ? "" : "hide" %>'>
                                                        <img src='Images/rollback.png' width='32' height='32'><br />
                                                        <b>Rollbacked</b> on: <span title='<%# Eval("RollbackDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                                            <%# TrustControl1.ToRecentDateTime(Eval("RollbackDT"))%>
                                                            (<time class="timeago" datetime='<%# Eval("RollbackDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>)</span>
                                                        <br />
                                                        By:
                                                        <uc2:EMP ID="EMP5" runat="server" Username='<%# Eval("RollbackBy") %>' />
                                                    </div>
                                                </ItemTemplate>
                                                <AlternatingItemStyle BackColor="White" />
                                                <ItemStyle BackColor="#F7F7DE" HorizontalAlign="Left" CssClass="TDTR" />
                                            </asp:DataList>
                                            <asp:SqlDataSource ID="SqlDataSourceReturnHistory" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                SelectCommand="sp_RemiList_Return_History_Select" SelectCommandType="StoredProcedure"
                                                OnSelected="SqlDataSourceReturnHistory_Selected">
                                                <SelectParameters>
                                                    <asp:QueryStringParameter Name="ID" QueryStringField="id" Type="Int64" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                            <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                SelectCommand="SELECT * FROM [v_PaymentMethods] ORDER BY OrderCol"></asp:SqlDataSource>
                                            <br />
                                        </asp:Panel>
                                    </asp:Panel>
                                    <br />
                                    <asp:Panel ID="PanelPaymentHistory" runat="server" CssClass="ui-corner-all Panel2 centertext">
                                        <div class="bold">
                                            Payment History
                                        </div>
                                        <asp:Panel ID="Panel2" runat="server" Style="border: solid 1px White; background-color: #F5F5F5; padding: 3px; margin: 5px"
                                            Height="280px" ScrollBars="Vertical" CssClass="ui-corner-all">
                                            <asp:DataList ID="DataListPaymentHistory" runat="server" CssClass="Grid" BorderColor="#DEDFDE"
                                                BorderStyle="Solid" BorderWidth="1px" CellPadding="4" DataKeyField="ID" DataSourceID="SqlDataSourcePaymentHistory"
                                                ForeColor="Black" GridLines="Both">
                                                <ItemTemplate>
                                                    <span title='<%# Eval("ID") %>'>
                                                        <%# Eval("[#]","<b># {0}</b>") %></span>
                                                    <br />
                                                    Beneficiary:
                                                    <%# Eval("BeneficiaryName") %>
                                                    <br />
                                                    Paid on: <span title='<%# Eval("PaidOn","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                                        <%# TrustControl1.ToRecentDateTime(Eval("PaidOn"))%>
                                                        (<time class="timeago" datetime='<%# Eval("PaidOn","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>)</span><br />
                                                    Paid by:
                                                    <uc2:EMP ID="EMP_PaidBy" runat="server" Username='<%# Eval("PaidBy") %>' />
                                                    <%# Eval("PaidBranch", "<br />Paid Branch: {0}")%>
                                                    <%# Eval("PaymentMethod","<br />Payment Method: {0}") %>
                                                    <%# Eval("Instrument", "<br />Instrument No. {0}")%><%# Eval("InstrumentDate", ", Date: {0:dd/MM/yyyy}")%>
                                                    <%# Eval("IDType", "<br />{0}: ")%><%# Eval("IDNumber", "{0}")%><%# Eval("IDExpityDate", ", Expiry: {0:dd/MM/yyyy}")%>
                                                    <%# Eval("Account", "<br />Account: {0}") %>
                                                    <uc3:BEFTN ID="BEFTN_History" runat="server" Code='<%# Eval("RoutingNumber") %>'
                                                        TextFormat="<br />Routing Number: {0}" />
                                                    <%# Eval("Paid_Batch", "<br />Paid Batch ID: {0}")%>
                                                    <%# Eval("UnpaidReason", "<br />Reason: <b>{0}</b>")%>
                                                    <div style="color: Gray">
                                                        Unpaid on: <span title='<%# Eval("UnpaidOn","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                                            <%# TrustControl1.ToRecentDateTime(Eval("UnpaidOn"))%>
                                                            (<time class="timeago" datetime='<%# Eval("UnpaidOn","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>)</span>
                                                        <br />
                                                        By:
                                                        <uc2:EMP ID="EMPHistory" runat="server" Username='<%# Eval("UnpaidBy") %>' />
                                                    </div>
                                                    <div class='<%# (Eval("Rollbacked").ToString() == "True") ? "" : "hide" %>'>
                                                        <img src='Images/rollback.png' width='32' height='32'><br />
                                                        <b>Rollbacked</b> on: <span title='<%# Eval("RollbackDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                                            <%# TrustControl1.ToRecentDateTime(Eval("RollbackDT"))%>
                                                            (<time class="timeago" datetime='<%# Eval("RollbackDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>)</span>
                                                        <br />
                                                        By:
                                                        <uc2:EMP ID="EMP5" runat="server" Username='<%# Eval("RollbackBy") %>' />
                                                    </div>
                                                </ItemTemplate>
                                                <AlternatingItemStyle BackColor="White" />
                                                <ItemStyle BackColor="#F7F7DE" HorizontalAlign="Left" CssClass="TDTR" />
                                            </asp:DataList>
                                            <asp:SqlDataSource ID="SqlDataSourcePaymentHistory" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                SelectCommand="sp_RemiList_History_Payment_Select" SelectCommandType="StoredProcedure"
                                                OnSelected="SqlDataSourcePaymentHistory_Selected">
                                                <SelectParameters>
                                                    <asp:QueryStringParameter Name="ID" QueryStringField="id" Type="Int64" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                            <br />
                                        </asp:Panel>
                                    </asp:Panel>
                                </td>
                                <td valign="top" style="padding-left: 20px; max-width: 400px">
                                    <asp:Panel ID="panelNotice" runat="server" Visible="true">
                                        <div class="group" style="display: table">
                                            <h2>Input Order Status Notice 
                                            </h2>
                                            <div>
                                                <asp:GridView ID="gdvOrderStatus" runat="server" AllowPaging="True" Visible="true" AllowSorting="True"
                                                    AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None"
                                                    PagerSettings-PageButtonCount="30" BorderWidth="1px" CellPadding="4"
                                                    DataSourceID="SqlDataSourceOrderStatus" PageSize="10" ForeColor="Black" GridLines="Vertical"
                                                    CssClass="Grid" PagerSettings-Position="TopAndBottom">
                                                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                                                    <Columns>
                                                        <asp:BoundField DataField="SCOrderNo" HeaderText="Order No" SortExpression="SCOrderNo" />
                                                        <asp:BoundField DataField="PCOrderNo" HeaderText="PC Order No" ReadOnly="True" SortExpression="PCOrderNo" />
                                                        <asp:BoundField DataField="OrderStatus" HeaderText="Input Status" ReadOnly="True" SortExpression="OrderStatus" />
                                                        <asp:BoundField DataField="NotificationCode" HeaderText="Response Code" SortExpression="NotificationCode" ItemStyle-CssClass="center" />
                                                        <asp:BoundField DataField="NotificationStatus" HeaderText="Response" SortExpression="NotificationStatus" />

                                                        <asp:TemplateField HeaderText="Insert Date" SortExpression="InsertDT" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <uc2:EMP ID="EMP4" runat="server" Username='<%# Eval("InsertBy") %>' />
                                                                <div title='<%# Eval("InsertDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                                                    <%# TrustControl1.ToRecentDateTime(Eval("InsertDT"))%><br />
                                                                    <time class="timeago" datetime='<%# Eval("InsertDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                                                </div>

                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <%--   <asp:TemplateField HeaderText="Printed By">
                                                        <ItemTemplate>
                                                           
                                                        </ItemTemplate>
                                                    </asp:TemplateField>--%>
                                                    </Columns>
                                                    <FooterStyle BackColor="#CCCC99" />
                                                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                                                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                                    <AlternatingRowStyle BackColor="White" />
                                                </asp:GridView>
                                                <asp:Label ID="LabelOrderStatus" runat="server" Text="" Font-Size="Small"></asp:Label>
                                            </div>
                                        </div>
                                    </asp:Panel>
                                    <asp:SqlDataSource ID="SqlDataSourceOrderStatus" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="s_Ria_InputOrderStatusNoticeSelect" SelectCommandType="StoredProcedure" OnSelected="SqlDataSourceOrderStatus_Selected">
                                        <SelectParameters>
                                            <asp:QueryStringParameter QueryStringField="id" Name="RID" DbType="Int64" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:Panel ID="panelCancel" runat="server" Visible="true">
                                        <div class="group" style="display: table">
                                            <h2>Input Cancel Order Request Response
                                            </h2>
                                            <div>
                                                <asp:GridView ID="gdvCancelReqResp" runat="server" AllowPaging="True" Visible="true" AllowSorting="True"
                                                    AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None"
                                                    PagerSettings-PageButtonCount="30" BorderWidth="1px" CellPadding="4"
                                                    DataSourceID="SqlDataSourceReqResp" PageSize="10" ForeColor="Black" GridLines="Vertical"
                                                    CssClass="Grid" PagerSettings-Position="TopAndBottom">
                                                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                                                    <Columns>
                                                        <asp:BoundField DataField="SCOrderNo" HeaderText="Order No" SortExpression="SCOrderNo" />
                                                        <asp:BoundField DataField="PCOrderNo" HeaderText="PC Order No" ReadOnly="True" SortExpression="PCOrderNo" />
                                                        <asp:BoundField DataField="ReqType" HeaderText="Input Cancel Type" ReadOnly="True" SortExpression="ReqType" />
                                                        <%--<asp:BoundField DataField="ResponseCode" HeaderText="Response Code" SortExpression="ResponseCode" ItemStyle-CssClass="center" />--%>
                                                        <asp:BoundField DataField="Comments" HeaderText="Comments" SortExpression="Comments" />
                                                        <asp:TemplateField HeaderText="ResponseCode" SortExpression="InsertDT">
                                                            <ItemTemplate>
                                                                <%# Eval("ResponseCode") %>
                                                                <div>
                                                                    <%# Eval("ResponseDesc") %>
                                                                </div>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Insert Date" SortExpression="InsertDT" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <uc2:EMP ID="EMP4" runat="server" Username='<%# Eval("InsertBy") %>' />
                                                                <div title='<%# Eval("InsertDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                                                    <%# TrustControl1.ToRecentDateTime(Eval("InsertDT"))%><br />
                                                                    <time class="timeago" datetime='<%# Eval("InsertDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                                                </div>

                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                    </Columns>
                                                    <FooterStyle BackColor="#CCCC99" />
                                                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                                                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                                    <AlternatingRowStyle BackColor="White" />
                                                </asp:GridView>
                                                <asp:SqlDataSource ID="SqlDataSourceReqResp" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                    SelectCommand="s_Ria_InputCancelOrderReqRespSelect" SelectCommandType="StoredProcedure" OnSelected="SqlDataSourceReqResp_Selected">
                                                    <SelectParameters>
                                                        <asp:QueryStringParameter QueryStringField="id" Name="RID" DbType="Int64" />
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                                <asp:Label ID="LabelReqResp" runat="server" Text="" Font-Size="Small"></asp:Label>
                                            </div>
                                        </div>
                                    </asp:Panel>

                                    <asp:Panel ID="panelTfCancelReq" runat="server" Visible="true">
                                        <div class="group" style="display: table">
                                            <h2>Cancel Order Request to Transfast 
                                            </h2>
                                            <div>
                                                <asp:GridView ID="gdvTfReq" runat="server" AllowPaging="True" Visible="true" AllowSorting="True"
                                                    AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None"
                                                    PagerSettings-PageButtonCount="30" BorderWidth="1px" CellPadding="4"
                                                    DataSourceID="SqlDataSourceTfCancelReq" PageSize="10" ForeColor="Black" GridLines="Vertical"
                                                    CssClass="Grid" PagerSettings-Position="TopAndBottom">
                                                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                                                    <Columns>
                                                        <asp:BoundField DataField="ServiceType" HeaderText="Service Type" SortExpression="ServiceType" />
                                                        <asp:BoundField DataField="RequestData" HeaderText="Request Data" SortExpression="RequestData" />
                                                        <asp:TemplateField HeaderText="Service Status" SortExpression="ServiceStatus">
                                                            <ItemTemplate>
                                                                <%# Eval("ServiceStatus") %>
                                                                <div>
                                                                    <%# Eval("HttpMessage") %>
                                                                </div>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Insert Date" SortExpression="InsertDT" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <uc2:EMP ID="EMP4" runat="server" Username='<%# Eval("InsertBy") %>' />
                                                                <div title='<%# Eval("InsertDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                                                    <%# TrustControl1.ToRecentDateTime(Eval("InsertDT"))%><br />
                                                                    <time class="timeago" datetime='<%# Eval("InsertDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                                                </div>

                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                    </Columns>
                                                    <FooterStyle BackColor="#CCCC99" />
                                                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                                                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                                    <AlternatingRowStyle BackColor="White" />
                                                </asp:GridView>
                                                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                    SelectCommand="s_Ria_InputCancelOrderReqRespSelect" SelectCommandType="StoredProcedure" OnSelected="SqlDataSourceReqResp_Selected">
                                                    <SelectParameters>
                                                        <asp:QueryStringParameter QueryStringField="id" Name="RID" DbType="Int64" />
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                                <asp:Label ID="Label1" runat="server" Text="" Font-Size="Small"></asp:Label>
                                            </div>
                                        </div>

                                        <asp:SqlDataSource ID="SqlDataSourceTfCancelReq" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                            SelectCommand="s_Tf_CanceReqSelect" SelectCommandType="StoredProcedure" OnSelected="SqlDataSourceTfCancelReq_Selected">
                                            <SelectParameters>
                                                <asp:QueryStringParameter QueryStringField="id" Name="RID" DbType="Int64" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                        <asp:Label ID="LabelTfCancelReq" runat="server" Text="" Font-Size="Small"></asp:Label>
                                    </asp:Panel>
                                </td>
                            </tr>
                        </table>
                        <br />
                        <asp:Panel runat="server" ID="PanelPrintReceipt" Visible="false">
                            <br />
                            <table>
                                <tr>
                                    <td>
                                        <img src="Images/Receipt.png" height="30px" />
                                    </td>
                                    <td>
                                        <asp:HyperLink CssClass="Button" Font-Size="Small" ID="hypPrintReceipt" runat="server"
                                            Target="_blank" ToolTip="Download as pdf" Text="Print Receipt" NavigateUrl="~/Print_Receipt.aspx"></asp:HyperLink>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <br />
                        <asp:Panel ID="PanelRefreshComment" runat="server" Visible="false">
                            <table>
                                <tr>
                                    <td>
                                        <asp:ImageButton ID="cmdRefreshComment" runat="server" ImageUrl="~/Images/comment.png"
                                            ToolTip="Refresh" CausesValidation="false" Width="50px" OnClick="cmdRefreshComment_Click" />
                                    </td>
                                    <td style="font-size: large; font-weight: bold; padding: 0px 0px 5px 5px;">Comments/Instructions/Amendments:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblCommentStatus" CssClass="Panel1 ui-corner-all" Style="padding: 5px"
                                            runat="server" Text="" Font-Bold="true" Font-Size="Large" ForeColor="Blue"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="LightGoldenrodYellow"
                                BorderColor="Tan" BorderWidth="1px" CellPadding="4" DataKeyNames="CID" DataSourceID="SqlDataSourceComments"
                                GridLines="None" CssClass="Grid" Style="font-size: small" Width="650px" ForeColor="Black">
                                <RowStyle VerticalAlign="Top" />
                                <Columns>
                                    <asp:TemplateField HeaderText="#" SortExpression="SL">
                                        <ItemTemplate>
                                            <span title='<%# Eval("CID") %>'>
                                                <%# Eval("SL") %></span>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" BackColor="#6B696B" ForeColor="White" Width="15px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Comment" SortExpression="Comment">
                                        <ItemTemplate>
                                            <b>
                                                <%# Eval("Comment") %></b>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Posted On" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <div title='<%# Eval("DT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                                <%# TrustControl1.ToRecentDateTime(Eval("DT")) %><br />
                                                <time class="timeago" datetime='<%# Eval("DT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Posted By" SortExpression="PostedBy" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <uc2:EMP ID="EMP4" runat="server" Username='<%# Eval("PostedBy") %>' />
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="BranchName" HeaderText="From" SortExpression="BranchName"
                                        ItemStyle-HorizontalAlign="Center">
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                </Columns>
                                <FooterStyle BackColor="Tan" />
                                <PagerStyle BackColor="PaleGoldenrod" ForeColor="DarkSlateBlue" HorizontalAlign="Center" />
                                <SelectedRowStyle BackColor="DarkSlateBlue" ForeColor="GhostWhite" />
                                <HeaderStyle ForeColor="White" Font-Bold="True" />
                                <AlternatingRowStyle BackColor="PaleGoldenrod" />
                            </asp:GridView>
                            <asp:SqlDataSource ID="SqlDataSourceComments" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                SelectCommand="SELECT ROW_NUMBER() OVER(ORDER BY CID) AS SL, * FROM [v_Comments] WHERE ([RID] = @RID) ORDER BY [CID]"
                                OnSelected="SqlDataSourceComments_Selected">
                                <SelectParameters>
                                    <asp:QueryStringParameter Name="RID" QueryStringField="id" Type="Int64" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </asp:Panel>
                        <br />
                        <div style="width: 550px; text-align: center">
                            <asp:Label ID="lblStatus" runat="server" Font-Bold="True" Font-Size="Medium"></asp:Label><br />
                        </div>
                    </div>
                    <table>
                        <tr>
                            <td valign="top">
                                <div style="padding-left: 20px">
                                    <asp:Button ID="cmdView_Comment" runat="server" Text="Post Comment" CssClass="ViewTitleSelected"
                                        OnClick="cmdView_Comment_Click" CausesValidation="false" />
                                    <asp:Button ID="cmdView_Pay" runat="server" Text="Remittance Payment" CssClass="ViewTitle"
                                        OnClick="cmdView_Pay_Click" CausesValidation="false" />
                                    <asp:Button ID="cmdView_HoForwarding" runat="server" Text="HO Forwarding" CssClass="ViewTitle"
                                        OnClick="cmdView_HoForwarding_Click" CausesValidation="false" />
                                    <asp:Button ID="cmdView_Forwarding" runat="server" Text="Forwarding" CssClass="ViewTitle"
                                        OnClick="cmdView_Forwarding_Click" CausesValidation="false" />
                                    <asp:Button ID="cmdView_Unpaid" runat="server" Text="Unpaid" CssClass="ViewTitle"
                                        OnClick="cmdView_Unpaid_Click" CausesValidation="false" />
                                    <asp:Button ID="cmdView_Return" runat="server" Text="Return" CssClass="ViewTitle"
                                        OnClick="cmdView_Return_Click" CausesValidation="false" />
                                </div>
                                <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
                                    <asp:View ID="v_Comment" runat="server">
                                        <div class="ViewPanel Shadow">
                                            <table style="border-collapse: collapse;" border="0">
                                                <tr>
                                                    <td>
                                                        <asp:TextBox ID="txtComment" runat="server" Font-Names="Arial" Height="40px" TextMode="MultiLine"
                                                            Width="410px"></asp:TextBox><asp:RequiredFieldValidator ID="RequiredFieldValidator9"
                                                                runat="server" ErrorMessage="*" ControlToValidate="txtComment" ValidationGroup="Comment"></asp:RequiredFieldValidator>
                                                        <asp:Panel ID="PanelCommentStatus" runat="server">
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <b>Comment Status:</b>
                                                                    </td>
                                                                    <td>
                                                                        <asp:DropDownList ID="cboCommentStatus" runat="server" AppendDataBoundItems="true"
                                                                            DataSourceID="SqlDataSourceCommentStatus" DataTextField="CommentStatus" DataValueField="ID">
                                                                            <asp:ListItem Text="" Value=""></asp:ListItem>
                                                                        </asp:DropDownList>
                                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorcboCommentStatus" runat="server"
                                                                            ErrorMessage="*" ControlToValidate="cboCommentStatus" ValidationGroup="Comment"></asp:RequiredFieldValidator>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <asp:SqlDataSource ID="SqlDataSourceCommentStatus" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                                SelectCommand="SELECT * FROM [v_CommentStatus]"></asp:SqlDataSource>
                                                        </asp:Panel>
                                                    </td>
                                                    <td style="padding-left: 10px;" valign="top">
                                                        <asp:Button ID="cmdCommentPost" runat="server" ValidationGroup="Comment" Font-Bold="True"
                                                            Height="40px" OnClick="cmdCommentPost_Click" Text="Post" Width="120px" />
                                                        <asp:ConfirmButtonExtender ID="cmdCommentPost_ConfirmButtonExtender" runat="server"
                                                            ConfirmText="Do want to post comment?" Enabled="True" TargetControlID="cmdCommentPost"></asp:ConfirmButtonExtender>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <asp:SqlDataSource ID="SqlDataSourceComment" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                            SelectCommand="sp_Comment_Insert" SelectCommandType="StoredProcedure" OnSelected="SqlDataSourceComment_Selected">
                                            <SelectParameters>
                                                <asp:QueryStringParameter Name="RID" QueryStringField="id" Type="Int64" />
                                                <asp:ControlParameter ControlID="txtComment" Name="Comment" PropertyName="Text" Type="String" />
                                                <asp:SessionParameter Name="PostedBy" SessionField="EMPID" Type="String" />
                                                <asp:SessionParameter Name="Branch" SessionField="BRANCHID" Type="Int32" />
                                                <asp:ControlParameter ControlID="cboCommentStatus" Name="CommentStatusID" PropertyName="SelectedValue"
                                                    Type="Int32" DefaultValue="1" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </asp:View>
                                    <asp:View ID="v_Pay" runat="server">
                                        <div class="ViewPanel Shadow">
                                            <table>
                                                <tr id="RemittancePinTr" runat="server">
                                                    <td style="font-size: small; font-weight: bold">Remittance PIN:
                                                    </td>
                                                    <td style="margin-left: 80px">
                                                        <asp:TextBox ID="txtPIN" runat="server" Width="120px" MaxLength="50"></asp:TextBox>
                                                    </td>
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td style="font-size: small; font-weight: bold" valign="middle">Instrument No.
                                                    </td>
                                                    <td style="margin-left: 80px" nowrap="nowrap">
                                                        <asp:TextBox ID="txtInstumentNo" runat="server" Enabled="False" Font-Size="Large"
                                                            MaxLength="20" Width="240px">
                                                        </asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtInstumentNo"
                                                            ErrorMessage="*" SetFocusOnError="True" ValidationGroup="Pay"></asp:RequiredFieldValidator>
                                                    </td>
                                                    <td style="font-size: 11pt;" rowspan="6" valign="top">
                                                        <asp:Button ID="cmdPay" runat="server" Enabled="False" Font-Bold="True" Height="30px"
                                                            OnClick="cmdPay_Click" Text="Pay Now" ValidationGroup="Pay" Width="120px" /><asp:ConfirmButtonExtender
                                                                ID="cmdPay_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to pay now?"
                                                                Enabled="True" TargetControlID="cmdPay"></asp:ConfirmButtonExtender>
                                                        &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td nowrap="nowrap" style="font-size: small; font-weight: bold">Instrument Date:
                                                    </td>
                                                    <td style="margin-left: 80px">
                                                        <asp:TextBox ID="txtInstrumentDate" runat="server" CssClass="Watermark Date" Watermark="dd/mm/yyyy"
                                                            Width="80px">
                                                        </asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtInstrumentDate"
                                                            ErrorMessage="*" SetFocusOnError="True" ValidationGroup="Pay"></asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td nowrap="nowrap" style="font-size: small; font-weight: bold">&nbsp;
                                                    </td>
                                                    <td style="margin-left: 80px">&nbsp;
                                                    </td>
                                                </tr>
                                                <tr id="IdTypeTr" runat="server">
                                                    <td nowrap="nowrap" style="font-size: small; font-weight: bold" align="right">ID Type:
                                                    </td>
                                                    <td style="margin-left: 80px">
                                                        <asp:DropDownList ID="txtIDType" runat="server" Font-Size="10pt" AppendDataBoundItems="true"
                                                            Font-Bold="true" DataSourceID="SqlDataSourceIDType" DataTextField="IDType" DataValueField="IDType"
                                                            ><asp:ListItem></asp:ListItem>

                                                        </asp:DropDownList>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtIDType"
                                                            ErrorMessage="*" ValidationGroup="Pay"></asp:RequiredFieldValidator>
                                                        <%--<asp:DropDownExtender ID="txtIDType_DropDownExtender" runat="server" DropDownControlID="gridIDType"
                                                            DynamicServicePath="" Enabled="True" TargetControlID="txtIDType">
                                                        </asp:DropDownExtender>--%>
                                                        <asp:SqlDataSource ID="SqlDataSourceIDType" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                            SelectCommand="SELECT [IDType] FROM [IDType] with (nolock) WHERE ([Active] = @Active) ORDER BY [OrderCol]">
                                                            <SelectParameters>
                                                                <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
                                                            </SelectParameters>
                                                        </asp:SqlDataSource>
                                                        <%--<asp:GridView ID="gridIDType" runat="server" AutoGenerateColumns="False" BackColor="White"
                                                            Width="100px" BorderColor="#E7E7FF" BorderStyle="None" BorderWidth="1px" CellPadding="3"
                                                            DataKeyNames="IDType" DataSourceID="SqlDataSourceIDType" GridLines="Horizontal"
                                                            CssClass="Shadow" ShowHeader="False">
                                                            <RowStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" Font-Size="10pt" CssClass="Grid" />
                                                            <Columns>
                                                                <asp:TemplateField>
                                                                    <ItemTemplate>
                                                                        <a style="cursor: pointer" onclick="javascript:setIDType('<%# Eval("IDType") %>')">
                                                                            <%# Eval("IDType") %></a>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                            <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                                                            <PagerStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" HorizontalAlign="Right" />
                                                            <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                                                            <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                                                            <AlternatingRowStyle BackColor="#F7F7F7" />
                                                        </asp:GridView>--%>
                                                    </td>
                                                </tr>
                                                <tr id="IdNumberTr" runat="server">
                                                    <td nowrap="nowrap" style="font-size: small; font-weight: bold" align="right">ID Number:
                                                    </td>
                                                    <td style="margin-left: 80px">
                                                        <asp:TextBox ID="txtIDNo" runat="server" Width="240px" Font-Size="14pt" MaxLength="20"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtIDNo"
                                                            ErrorMessage="*" ValidationGroup="Pay"></asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr id="IdExpiryDateTr" runat="server">
                                                    <td nowrap="nowrap" style="font-size: small; font-weight: bold" align="right">ID Expiry Date:
                                                    </td>
                                                    <td style="margin-left: 80px">
                                                        <asp:TextBox ID="txtIDExpiryDate" runat="server" Width="80px" CssClass="Watermark Date"
                                                            Watermark="dd/mm/yyyy"></asp:TextBox><asp:RequiredFieldValidator ValidationGroup="Pay"
                                                                ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtIDExpiryDate"
                                                                ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                        <asp:CheckBox ID="chkNoExpiryDate" CausesValidation="false" AutoPostBack="true" Text="No Expiry Date"
                                                            Font-Size="Small" runat="server" OnCheckedChanged="chkNoExpiryDate_CheckedChanged" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <asp:SqlDataSource ID="SqlDataSourcePay" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                            SelectCommand="sp_Remittance_Pay" SelectCommandType="StoredProcedure" OnSelected="SqlDataSourcePay_Selected">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="DetailsView1" Name="ID" PropertyName="SelectedValue"
                                                    Type="Int64" />
                                                <asp:SessionParameter Name="PaidBy" SessionField="EMPID" Type="String" />
                                                <asp:SessionParameter Name="PaidBranch" SessionField="BRANCHID" Type="Int32" />
                                                <asp:ControlParameter Name="PIN" Type="String" Size="30" ControlID="txtPIN" PropertyName="Text"
                                                    DefaultValue=" " />
                                                <asp:ControlParameter Name="Instrument" Type="String" Size="20" ControlID="txtInstumentNo"
                                                    PropertyName="Text" />
                                                <asp:ControlParameter Name="InstrumentDate" Type="DateTime" ControlID="txtInstrumentDate"
                                                    PropertyName="Text" />
                                                <asp:ControlParameter Name="IDType" Type="String" ControlID="txtIDType" PropertyName="Text"
                                                    DefaultValue=" " />
                                                <asp:ControlParameter Name="IDNumber" Type="String" ControlID="txtIDNo" PropertyName="Text"
                                                    DefaultValue=" " />
                                                <asp:ControlParameter Name="IDExpiryDate" Type="DateTime" ControlID="txtIDExpiryDate"
                                                    PropertyName="Text" DefaultValue="01/01/1900" />
                                                <asp:ControlParameter Name="NoExipryDate" Type="Boolean" ControlID="chkNoExpiryDate"
                                                    PropertyName="Checked" DefaultValue="0" />
                                                <asp:Parameter Name="Msg" Type="String" Direction="InputOutput" DefaultValue=" "
                                                    Size="255" />
                                                <asp:Parameter Name="Done" Type="Boolean" Direction="InputOutput" DefaultValue="false" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </asp:View>
                                    <asp:View ID="v_HoForwarding" runat="server">
                                        <div class="ViewPanel Shadow">
                                            <table>
                                                <tr>
                                                    <td>Ref:
                                                        <asp:Label ID="lblRefReport1" runat="server" Text="" Font-Bold="true"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtReference" runat="server" Width="100px" Font-Size="Larger"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator8" ControlToValidate="txtReference"
                                                            ValidationGroup="HoForwarding" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="cmdDownload" runat="server" Text="Download" Font-Bold="True" OnClick="cmdDownload_Click"
                                                            ValidationGroup="HoForwarding" Width="100px" /><asp:Button ID="cmdChange" runat="server"
                                                                Text="Change" Font-Bold="True" OnClick="cmdChange_Click" CausesValidation="false"
                                                                Width="100px" Visible="false" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td>
                                                        <asp:HyperLink ID="cmdReport1" runat="server" Target="_blank" Text="Download" Font-Bold="True"
                                                            Visible="False" />
                                                    </td>
                                                    <td></td>
                                                </tr>
                                            </table>
                                        </div>
                                    </asp:View>
                                    <asp:View ID="v_Forwarding" runat="server">
                                        <div class="ViewPanel Shadow">
                                            <table>
                                                <tr>
                                                    <td>Ref:
                                                        <asp:Label ID="lblRefReport2" runat="server" Text="" Font-Bold="true"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtReference2" runat="server" Width="100px" Font-Size="Larger"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" ControlToValidate="txtReference2"
                                                            runat="server" ErrorMessage="*" ValidationGroup="Forwarding"></asp:RequiredFieldValidator>
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="cmdDownload2" runat="server" Text="Download" Font-Bold="True" OnClick="cmdDownload_Click"
                                                            ValidationGroup="Forwarding" Width="100px" /><asp:Button ID="cmdChange2" runat="server"
                                                                Text="Change" Font-Bold="True" CausesValidation="false" Width="100px" Visible="false" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td>
                                                        <asp:HyperLink ID="cmdReport2" Target="_blank" runat="server" Text="Download" Font-Bold="True"
                                                            Visible="False" /><br />
                                                    </td>
                                                    <td></td>
                                                </tr>
                                            </table>
                                        </div>
                                    </asp:View>
                                    <asp:View ID="v_Unpaid" runat="server">
                                        <div class="ViewPanel Shadow">
                                            <table>
                                                <tr>
                                                    <td colspan="2">
                                                        <b>Reason of Unpaid:</b>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top">
                                                        <asp:GridView ID="GridViewReasonOfUnpaid" runat="server" CssClass="Grid" AutoGenerateColumns="False"
                                                            BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px"
                                                            CellPadding="3" DataSourceID="SqlDataSourceReasonOfUnpaid" GridLines="Vertical"
                                                            ShowHeader="False">
                                                            <RowStyle BackColor="#EEEEEE" ForeColor="Black" />
                                                            <Columns>
                                                                <asp:TemplateField>
                                                                    <ItemTemplate>
                                                                        <a style="cursor: pointer" onclick="javascript:setReason('<%# Eval("Reasons") %>')">
                                                                            <%# Eval("Reasons")%></a>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                            <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
                                                            <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                                                            <SelectedRowStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
                                                            <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
                                                            <AlternatingRowStyle BackColor="#DCDCDC" />
                                                        </asp:GridView>
                                                        <asp:SqlDataSource ID="SqlDataSourceReasonOfUnpaid" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                            SelectCommand="SELECT [Reasons] FROM [ReasonOfUnpaid] ORDER BY [Reasons]"></asp:SqlDataSource>
                                                        <asp:TextBox ID="txtUnpaidReason" runat="server" Width="400px" Font-Bold="true" Style="height: 22px"
                                                            MaxLength="255"></asp:TextBox>
                                                        <asp:DropDownExtender ID="DropDownExtendertxtUnpaidReason" runat="server" DropDownControlID="GridViewReasonOfUnpaid"
                                                            DynamicServicePath="" Enabled="True" TargetControlID="txtUnpaidReason">
                                                        </asp:DropDownExtender>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" ControlToValidate="txtUnpaidReason"
                                                            ValidationGroup="Unpaid" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                                                    </td>
                                                    <td valign="top">
                                                        <asp:Button ID="cmdUnpaid" runat="server" Text="Mark as Unpaid" Font-Bold="True"
                                                            Width="130px" Height="30px" ValidationGroup="Unpaid" OnClick="cmdUnpaid_Click" />
                                                        <asp:ConfirmButtonExtender ID="cmdUnpaid_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Mark as Unpaid?"
                                                            Enabled="True" TargetControlID="cmdUnpaid"></asp:ConfirmButtonExtender>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </asp:View>
                                    <asp:View ID="v_Return" runat="server">
                                        <div class="ViewPanel Shadow">
                                            <table>
                                                <tr>
                                                    <td colspan="2">
                                                        <b>Return Reason:</b>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top">
                                                        <asp:SqlDataSource ID="SqlDataSourceReasonOfReturn" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                            SelectCommand="s_ReasonReturn" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                                                        <asp:DropDownList ID="cboReturn" runat="server" AppendDataBoundItems="true" AutoPostBack="false" ValidationGroup="Return"
                                                            DataSourceID="SqlDataSourceReasonOfReturn" DataTextField="ReasonWithCode" DataValueField="ReturnReasonID">
                                                            <asp:ListItem Value="" Text=""></asp:ListItem>
                                                        </asp:DropDownList>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorReturnReason" ControlToValidate="cboReturn"
                                                            runat="server" ErrorMessage="*" ValidationGroup="Return"></asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top">
                                                        <asp:Button ID="cmdReturnReason" runat="server" Text="Mark as Return" Font-Bold="True"
                                                            Width="130px" Height="30px" ValidationGroup="Return" OnClick="cmdReturnReason_Click" />
                                                        <asp:ConfirmButtonExtender ID="ConfirmButtonExtenderReturnReason" runat="server" ConfirmText="Do you want to Mark as Return?"
                                                            Enabled="True" TargetControlID="cmdReturnReason"></asp:ConfirmButtonExtender>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </asp:View>
                                </asp:MultiView>
                            </td>
                            <td valign="top" style="padding: 30px">
                                <asp:Panel ID="PanelPaidToday" runat="server" Style="padding: 10px; border: 4px solid green; font-size: 200%; background-color: yellow; font-weight: bold; white-space: nowrap"
                                    Visible="false">
                                    <img src="Images/tick.png" />
                                    Paid on Today
                                </asp:Panel>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <asp:Panel ID="PanelPrintLog" runat="server" Visible="false" >
                        <table>
                            <tr>
                                <td>
                                    <asp:ImageButton ID="cmdRefrestPrintLog" runat="server" ImageUrl="~/Images/Print_Log.png"
                                        OnClick="cmdRefrestPrintLog_Click" ToolTip="Refresh" CausesValidation="false"
                                        Width="50px" />
                                </td>
                                <td style="font-size: large; font-weight: bold; padding: 0px 0px 5px 5px;" valign="bottom">Print Log
                                </td>
                            </tr>
                        </table>
                        <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" BackColor="White"
                            CssClass="Grid" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="2"
                            DataKeyNames="ID" DataSourceID="SqlDataSourcePrintLog" ForeColor="Black" GridLines="Both"
                            Style="font-size: 80%">
                            <RowStyle BackColor="#F7F7DE" HorizontalAlign="Center" VerticalAlign="Top" />
                            <Columns>
                                <asp:TemplateField HeaderText="#" SortExpression="SL">
                                    <ItemTemplate>
                                        <span title='<%# Eval("ID") %>'>
                                            <%# Eval("SL") %></span>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" BackColor="#6B696B" ForeColor="White" Width="15px" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Ref" HeaderText="Ref" SortExpression="Ref" ItemStyle-HorizontalAlign="Left"
                                    ItemStyle-Font-Bold="true" />
                                <asp:TemplateField HeaderText="Printed On" SortExpression="PrintDT" ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <div title='<%# Eval("PrintDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                            <%# TrustControl1.ToRecentDateTime(Eval("PrintDT"))%><br />
                                            <time class="timeago" datetime='<%# Eval("PrintDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Printed By">
                                    <ItemTemplate>
                                        <uc2:EMP ID="EMP4" runat="server" Username='<%# Eval("ByEmp") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="BranchName" HeaderText="Printed From" SortExpression="BranchName" />
                            </Columns>
                            <FooterStyle BackColor="#CCCC99" />
                            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                            <AlternatingRowStyle BackColor="White" />
                        </asp:GridView>
                        <asp:SqlDataSource ID="SqlDataSourcePrintLog" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                            SelectCommand="SELECT ROW_NUMBER() OVER(ORDER BY PrintDT) AS SL, * FROM [v_PrintLog] WHERE ([RID] = @RID) ORDER BY PrintDT"
                            OnSelected="SqlDataSourcePrintLog_Selected">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="RID" QueryStringField="id" Type="Int64" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </asp:Panel>
                    <asp:SqlDataSource ID="SqlDataSourceUnpaid" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                        ProviderName="<%$ ConnectionStrings:RemittanceConnectionString.ProviderName %>"
                        UpdateCommand="sp_Remittance_Unpaid" UpdateCommandType="StoredProcedure" OnUpdated="SqlDataSourceUnpaid_Updated">
                        <UpdateParameters>
                            <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                            <asp:QueryStringParameter Name="RID" QueryStringField="id" Type="Int64" />
                            <asp:SessionParameter Name="UnpaidBy" SessionField="EMPID" Type="String" />
                            <asp:ControlParameter ControlID="txtUnpaidReason" Name="UnpaidReason" PropertyName="Text"
                                Type="String" />
                            <asp:Parameter DefaultValue=" " Direction="InputOutput" Name="Msg" Type="String"
                                Size="255" />
                            <asp:Parameter DefaultValue="false" Direction="InputOutput" Name="Done" Type="Boolean" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="SqlDataSourceReturn" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                        ProviderName="<%$ ConnectionStrings:RemittanceConnectionString.ProviderName %>"
                        UpdateCommand="sp_Remittance_Return" UpdateCommandType="StoredProcedure" OnUpdated="SqlDataSourceReturn_Updated">
                        <UpdateParameters>
                            <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                            <asp:QueryStringParameter Name="RID" QueryStringField="id" Type="Int64" />
                            <asp:SessionParameter Name="ReturnBy" SessionField="EMPID" Type="String" />
                            <asp:ControlParameter ControlID="cboReturn" Name="ReturnReasonID" PropertyName="SelectedValue"
                                Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                            <asp:Parameter DefaultValue=" " Direction="InputOutput" Name="Msg" Type="String" Size="255" />
                            <asp:Parameter DefaultValue="false" Direction="InputOutput" Name="Done" Type="Boolean" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
                </asp:Panel>
                <asp:Panel runat="server" ID="PanelIncentive" CssClass="group" Style="margin-top: 20px">
                    <h2>Incentive Panel</h2>
                    <div class="group-body">
                        <asp:DetailsView ID="DetailsViewIncentive" runat="server" AutoGenerateRows="False"
                            BackColor="White" BorderColor="#DEDFDE" CssClass="Grid"
                            BorderStyle="None" BorderWidth="1px" CellPadding="2"
                            DataKeyNames="RID" DataSourceID="SqlDataSourceIncentive" ForeColor="Black" GridLines="Vertical" OnDataBound="DetailsViewIncentive_DataBound">
                            <AlternatingRowStyle BackColor="White" />
                            <EditRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                            <Fields>
                                <asp:TemplateField HeaderText="Incentive Amount">
                                    <ItemTemplate>
                                        <span style="font-weight: bold; font-size: 110%">
                                            <%# Eval("IncentiveAmount", "{0:N2}") %></span>
                                        <%# Eval("AmountInWord", "({0})")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="IncentiveCurrency" HeaderText="Currency" ItemStyle-CssClass="bold" />
                                <asp:TemplateField HeaderText="Incentive Paid">
                                    <ItemTemplate>
                                        <%# (Eval("Paid").ToString() == "True") ? "<img src='Images/tick.png' width='20' height='20'>" : ""%>
                                    </ItemTemplate>
                                    <HeaderStyle Font-Bold="true" />
                                </asp:TemplateField>


                                <asp:TemplateField HeaderText="Paid Branch">
                                    <ItemTemplate>
                                        <%# Eval("PaidBranchName")%><%# Eval("PaidBranch", " ({0})")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Paid By">
                                    <ItemTemplate>
                                        <uc2:EMP ID="EMPPaidBy" runat="server" Username='<%# Eval("PaidBy") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Paid On">
                                    <ItemTemplate>
                                        <%# ((Eval("PaidDT")).ToString() != "") ? "<div title='" + Eval("PaidDT", "{0:dddd \ndd MMMM, yyyy \nh:mm:ss tt}") + "'>" + Eval("PaidDT") + " <span class='time-small'>(<time class='timeago' datetime='" + Eval("PaidDT", "{0:yyyy-MM-dd HH:mm:ss}") + "'></time>)</span></div>" : ""%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" />
                                <asp:BoundField DataField="Paid_Batch" HeaderText="Paid_Batch" SortExpression="Paid_Batch" />
                                <asp:TemplateField HeaderText="Doc Required">
                                    <ItemTemplate>
                                        <%# (Eval("DocRequired").ToString() == "True") ? "<img src='Images/tick.png' width='20' height='20'>" : "No" %>
                                    </ItemTemplate>
                                    <HeaderStyle Font-Bold="true" />
                                </asp:TemplateField>


                                <asp:BoundField DataField="Remarks" HeaderText="Remarks" SortExpression="Remarks" />
                                <asp:BoundField DataField="PaymentMethod" HeaderText="PaymentMethod" SortExpression="PaymentMethod" />

                                <asp:TemplateField HeaderText="NID">
                                    <ItemTemplate>
                                        <%# (Eval("NID").ToString() == "True") ? "<img src='Images/tick.png' width='16' height='16'>" : ""%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Passport">
                                    <ItemTemplate>
                                        <%# (Eval("Passport").ToString() == "True") ? "<img src='Images/tick.png' width='16' height='16'>" : ""%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Emp Apoinment Letter">
                                    <ItemTemplate>
                                        <%# (Eval("EmpApoinmentLetter").ToString() == "True") ? "<img src='Images/tick.png' width='16' height='16'>" : ""%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="BMET Approval">
                                    <ItemTemplate>
                                        <%# (Eval("BMETApproval").ToString() == "True") ? "<img src='Images/tick.png' width='16' height='16'>" : ""%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Resident Permit Copy">
                                    <ItemTemplate>
                                        <%# (Eval("ResidentPermitCopy").ToString() == "True") ? "<img src='Images/tick.png' width='16' height='16'>" : ""%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Trade License">
                                    <ItemTemplate>
                                        <%# (Eval("TradeLicense").ToString() == "True") ? "<img src='Images/tick.png' width='16' height='16'>" : ""%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                 <asp:BoundField DataField="Instrument" HeaderText="Instrument" SortExpression="Instrument" />
                                 <asp:BoundField DataField="InstrumentDate" HeaderText="Instrument Date" SortExpression="InstrumentDate" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundField>
                                 <asp:BoundField DataField="IDType" HeaderText="ID Type" SortExpression="IDType" />
                                 <asp:BoundField DataField="IDNumber" HeaderText="ID Number" SortExpression="IDNumber" />
                                 <asp:BoundField DataField="IDExpityDate" HeaderText="ID Expity Date" SortExpression="IDExpityDate" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundField>
                                <asp:TemplateField HeaderText="Insert By">
                                    <ItemTemplate>
                                        <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("InsertBy") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Insert DT">
                                    <ItemTemplate>
                                        <%# ((Eval("InsertDT")).ToString() != "") ? "<div title='" + Eval("InsertDT", "{0:dddd \ndd MMMM, yyyy \nh:mm:ss tt}") + "'>" + Eval("InsertDT") + " <span class='time-small'>(<time class='timeago' datetime='" + Eval("InsertDT", "{0:yyyy-MM-dd HH:mm:ss}") + "'></time>)</span></div>" : ""%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Insert Branch">
                                    <ItemTemplate>
                                        <%# Eval("InsertBranchName")%><%# Eval("InsertBranch", " ({0})")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Fields>
                            <EmptyDataTemplate>
                                <asp:LinkButton runat="server" ID="lnlGenerateIncentive" Text="Generate Incentive Payment Info" CssClass="bold" CommandName="Delete"></asp:LinkButton>
                            </EmptyDataTemplate>
                            <FooterStyle BackColor="#CCCC99" />
                            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                            <RowStyle BackColor="#F7F7DE" />
                        </asp:DetailsView>
                        <asp:SqlDataSource ID="SqlDataSourceIncentive" runat="server"
                            ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                            SelectCommand="s_Incentive_Select" SelectCommandType="StoredProcedure"
                            DeleteCommand="s_Incentive_Generate" DeleteCommandType="StoredProcedure" OnDeleted="SqlDataSourceIncentive_Deleted" OnSelected="SqlDataSourceIncentive_Selected">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="RID" QueryStringField="id" Type="Int64" />
                                <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                                <asp:SessionParameter Name="BranchID" SessionField="BRANCHID" Type="Int16" />
                            </SelectParameters>
                            <DeleteParameters>
                                <asp:QueryStringParameter Name="RID" QueryStringField="id" Type="Int64" />
                                <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                                <asp:SessionParameter Name="BranchID" SessionField="BRANCHID" Type="Int16" />
                                <asp:Parameter Name="Msg" Size="255" Direction="InputOutput" DefaultValue=" " />
                            </DeleteParameters>
                        </asp:SqlDataSource>
                    </div>
                    <div class="group-body" style="display: inline-block">
                        <asp:Button ID="cmdIncentiveMakePayment" Visible="false" runat="server" Text="Make Payment" OnClick="cmdIncentiveMakePayment_Click" />
                        <asp:Panel runat="server" Visible="false" ID="PanelIncentivePayment" CssClass="group" Style="display: table">
                            <h5>Incentive Payment</h5>
                            <div class="group-body" style="line-height: 2; padding: 5px 50px 5px 10px">
                                Mark the required documents you received from customer:
                                <div style="padding-left:10px;border-left:1px solid #e8e8e8;margin-left:10px">                                    
                                    <asp:CheckBox ID="chkPassport" runat="server" Text="Passport" /><br />
                                    <asp:CheckBox ID="chkNID" runat="server" Text="NID" /><br />
                                    <asp:CheckBox ID="chkEmpApoinmentLetter" runat="server" Text="Emp Apoinment Letter" /><br />
                                    <asp:CheckBox ID="chkBMETApproval" runat="server" Text="BMET Approval" /><br />
                                    <asp:CheckBox ID="chkResidentPermitCopy" runat="server" Text="Resident Permit Copy" /><br />
                                    <asp:CheckBox ID="chkTradeLicense" runat="server" Text="Trade License" />
                                </div>

                                <div>
                                     <table>
                                                              <tr>
                            <td>Instrument No.
                            </td>
                            <td>
                                <asp:TextBox ID="txtInstumentNoI" runat="server" Width="200px" placeholder="instument no" MaxLength="50">
                                </asp:TextBox>
                                
                            </td>
                        </tr>
                        <tr>
                            <td>Instrument Date:
                            </td>
                            <td>
                                <asp:TextBox ID="txtInstrumentDateI" runat="server" CssClass="Watermark Date" Watermark="dd/mm/yyyy"
                                     MaxLength="10" Width="80px">
                                </asp:TextBox>
                               
                            </td>
                        </tr>
                        <tr>
                            <td >ID Type:
                            </td>
                            <td>
                                <asp:DropDownList ID="txtIDTypeI" runat="server" Font-Size="10pt" AppendDataBoundItems="true"
                                    Font-Bold="true" DataSourceID="SqlDataSourceIDTypeI" DataTextField="IDType" DataValueField="IDType"
                                    ><asp:ListItem></asp:ListItem>

                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlDataSourceIDTypeI" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                    SelectCommand="SELECT [IDType] FROM [IDType] with (nolock) WHERE ([Active] = @Active) ORDER BY [OrderCol]">
                                    <SelectParameters>
                                        <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </td>
                        </tr>
                        <tr >
                            <td>ID Number:
                            </td>
                            <td>
                                <asp:TextBox ID="txtIDNoI" runat="server" Width="200px" placeholder="id no" MaxLength="50"></asp:TextBox>
                            </td>
                        </tr>
                        <tr id="Tr1" runat="server">
                            <td>ID Expiry Date:</td>
                            <td>
                                <asp:TextBox ID="txtIDExpiryDateI" runat="server" CssClass="Watermark Date" Watermark="dd/mm/yyyy"
                                     MaxLength="10" Width="80px"></asp:TextBox>
                             
                            </td>
                        </tr>
                    </table>
                                </div>
                                <div>
                                    <asp:Button ID="cmdIncentivePay" runat="server" Text="Mark as Paid" OnClick="cmdIncentivePay_Click" />
                                </div>
                                <asp:Label ID="lblIncentiveStatus" runat="server" CssClass="bold"></asp:Label>
                            </div>
                        </asp:Panel>
                    </div>
                </asp:Panel>
            </div>
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
        UseAnimation="false" VerticalSide="Middle"></asp:AlwaysVisibleControlExtender>
</asp:Content>
