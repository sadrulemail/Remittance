<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    Inherits="Remittance.ShowBatch" CodeFile="ShowBatch.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .style1 {
            height: 20px;
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
            <table>
                <tr>
                    <td>
                        <table class="SmallFont ui-corner-all Panel1">
                            <tr>
                                <td style="padding-left: 5px">Batch No:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtBatch" runat="server" onfocus="this.select()" Width="80px" Style="text-align: center"></asp:TextBox>
                                </td>
                                <td style="padding: 0px 5px 0px 5px">
                                    <asp:Button ID="cmdShow" runat="server" Text="Show" OnClick="cmdShow_Click" />
                                </td>
                        </table>
                    </td>
                    <td style="padding-left: 10px">

                        <asp:LinkButton ID="lnkUpdateRouting" runat="server" CssClass="Link"
                            OnClick="lnkUpdateRouting_Click">Update Routing Number</asp:LinkButton>

                        <asp:Literal runat="server" ID="litBatchHistory"></asp:Literal>
                    </td>
                </tr>
            </table>
            <asp:HiddenField runat="server" ID="hidExHouseType" />
            <asp:HiddenField runat="server" ID="hidExHouseCode" />
            <br />
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
                AllowSorting="True" AllowPaging="true" BorderColor="#DEDFDE" BorderStyle="Solid"
                BorderWidth="1px" CellPadding="2" CssClass="Grid" DataKeyNames="ID" DataSourceID="SqlDataSource1"
                PagerSettings-Position="TopAndBottom" Style="font-size: small" ForeColor="Black"
                OnDataBound="GridView1_DataBound" PagerSettings-PageButtonCount="30" OnRowDataBound="GridView1_RowDataBound"
                OnRowUpdated="GridView1_RowUpdated" OnRowEditing="GridView1_RowEditing" OnSelectedIndexChanged="GridView1_SelectedIndexChanged"
                OnPageIndexChanged="GridView1_PageIndexChanged" OnRowCommand="GridView1_RowCommand"
                OnSorted="GridView1_Sorted" OnSorting="GridView1_Sorting">
                <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                <Columns>
                    <asp:TemplateField HeaderText="#" SortExpression="#" ItemStyle-CssClass="SLCOL">
                        <ItemTemplate>
                            <%# Eval("#","{0}") %><br />
                            <asp:Label ID="lblSL" runat="server" Text="&raquo;" Visible="false"></asp:Label>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="RID" ItemStyle-HorizontalAlign="Center" SortExpression="ID">
                        <ItemTemplate>
                            <b><a href='Remittance_Show.aspx?id=<%# Eval("ID") %>' title="View Remittance" target="_blank">
                                <%# Eval("ID") %></a></b><a name='<%# Eval("ID","{0}") %>'></a>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="ExHouseCode" HeaderText="Ex-House" SortExpression="ExHouseCode"
                        ItemStyle-Wrap="false" ReadOnly="true">
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                        ItemStyle-HorizontalAlign="Right" ReadOnly="true">
                        <ItemStyle HorizontalAlign="Right" Font-Bold="true" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Currency" HeaderText="Currency" ReadOnly="true"
                        ItemStyle-HorizontalAlign="Center">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:CheckBoxField HeaderText="Paid" DataField="Paid" SortExpression="Paid" ItemStyle-HorizontalAlign="Center"
                        ReadOnly="true">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:CheckBoxField>
                    <asp:TemplateField HeaderText="ToBranch Name" SortExpression="ToBranchName">
                        <ItemTemplate>
                            <asp:LinkButton ID="cmdEditToBranch" runat="server" CausesValidation="False" CommandName="Select"
                                Text='<%# (Eval("ToBranchName").ToString() == "" ? "..." : Eval("ToBranchName")) %>'
                                ToolTip="Change" Visible='<%# isRowEditable(Eval("Paid"), Eval("Published"), Eval("ExHouse_Type")) %>'>
                            </asp:LinkButton>
                            <asp:Label ID="lblToBranchName" runat="server" Text='<%# Eval("ToBranchName") %>'
                                ToolTip="Change Not Possible" Visible='<%# !isRowEditable(Eval("Paid"), Eval("Published"), Eval("ExHouse_Type")) %>'>
                            </asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="cboToBranch" runat="server" DataSourceID="SqlDataSourceToBranch"
                                AppendDataBoundItems="true" DataTextField="BranchName" DataValueField="BranchID"
                                SelectedValue='<%# Bind("ToBranch") %>'>
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                <asp:ListItem Text="Any Branch" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Head Office" Value="1"></asp:ListItem>
                            </asp:DropDownList>
                            <br />
                            &nbsp;<asp:LinkButton ID="cmdUpdate" runat="server" CausesValidation="false" CommandName="Update"
                                Text="Save"></asp:LinkButton>&nbsp;<asp:LinkButton ID="cmdCancel" runat="server"
                                    CausesValidation="False" CommandName="Cancel" Text="Cancel"></asp:LinkButton><asp:SqlDataSource
                                        ID="SqlDataSourceToBranch" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="SELECT [BranchName], [BranchID] FROM [V_BranchOnly] ORDER BY [BranchName]"></asp:SqlDataSource>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Routing Number" SortExpression="RoutingNumber">
                        <EditItemTemplate>
                            <asp:TextBox AutoCompleteType="None" ID="txtRoutingNumber" onclick="this.select()"
                                Watermark="Routing No." Text='<%# Bind("RoutingNumber") %>' runat="server" Width="100px"
                                CausesValidation="false" CssClass="BEFTNSearchBox">
                            </asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <uc3:BEFTN ID="BEFTN1" runat="server" Code='<%# Eval("RoutingNumber") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Status" SortExpression="Status" ItemStyle-Wrap="false">

                        <EditItemTemplate>
                            <asp:DropDownList ID="cboStatus" runat="server" DataTextField="Status" SelectedValue='<%# Bind("Status") %>'>
                                <asp:ListItem>ACTIVE</asp:ListItem>
                                <asp:ListItem>ON HOLD</asp:ListItem>
                                <asp:ListItem>CANCEL</asp:ListItem>
                                <asp:ListItem>RETURN</asp:ListItem>
                                <asp:ListItem>REJECT</asp:ListItem>
                            </asp:DropDownList>

                        </EditItemTemplate>
                        <ItemStyle Wrap="False" HorizontalAlign="Center" />
                        <ItemTemplate>
                            <%# Eval("Status","<b>{0}</b>") %>
                            <div>
                                <asp:LinkButton ID="lnkStatusActive" runat="server" ToolTip="Set Active" CausesValidation="false" Visible='<%# (Eval("ExHouse_Type").ToString() == "W" ? false : true) %>'
                                    CommandName="A" CommandArgument='<%# Eval("ID") %>'>A</asp:LinkButton>
                                <asp:LinkButton ID="lnkStatusHold" runat="server" ToolTip="Set ON HOLD" CausesValidation="false" Visible='<%# (Eval("ExHouse_Type").ToString() == "W" ? false : true) %>'
                                    CommandName="H" CommandArgument='<%# Eval("ID") %>'>H</asp:LinkButton>
                                <asp:LinkButton ID="lnkStatusCancel" runat="server" ToolTip="Set CANCEL" CausesValidation="false" Visible='<%# (Eval("ExHouse_Type").ToString() == "W" ? false : true) %>'
                                    CommandName="C" CommandArgument='<%# Eval("ID") %>'>C</asp:LinkButton>
                            </div>
                        </ItemTemplate>
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
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("PaymentMethod") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Beneficiary Name" SortExpression="BeneficiaryName">
                        <ItemTemplate>
                            <%# Eval("BeneficiaryName")%>
                        </ItemTemplate>
                        <EditItemTemplate>

                            <asp:TextBox runat="server" ID="txtBeneficiaryName" Text='<%# Bind("BeneficiaryName") %>'
                                Width="200px" MaxLength="255" Watermark="Beneficiary Name"></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Beneficiary Account" SortExpression="Account">
                        <ItemTemplate>
                            <%# Eval("Account")%>
                        </ItemTemplate>
                        <ItemStyle Wrap="false" />
                        <EditItemTemplate>

                            <asp:TextBox runat="server" ID="txtAccount" Text='<%# Bind("Account") %>' Width="120px"
                                MaxLength="50" Watermark="Beneficiary A/C"></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="RemitterName" HeaderText="Remitter Name" SortExpression="RemitterName"
                        ReadOnly="true" HtmlEncode="false" />
                    <asp:BoundField DataField="RemitterAddress" HeaderText="Remitter Address" SortExpression="RemitterAddress"
                        ReadOnly="true" HtmlEncode="false" />
                    <asp:BoundField DataField="RemitterAccount" HeaderText="Remitter Account" SortExpression="RemitterAccount"
                        ReadOnly="true" HtmlEncode="false" ItemStyle-Wrap="false">
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="RemitterAccType" HeaderText="Remitter Acc Type" SortExpression="RemitterAccType"
                        ReadOnly="true" HtmlEncode="false" />
                    <asp:BoundField DataField="BeneficiaryAddress" HeaderText="Beneficiary Address" SortExpression="BeneficiaryAddress"
                        ReadOnly="true" HtmlEncode="false" />
                    <asp:BoundField DataField="BankName" HeaderText="Bank" SortExpression="BankName"
                        ReadOnly="true" HtmlEncode="false" />
                    <asp:BoundField DataField="BranchName" HeaderText="Branch" SortExpression="BranchName"
                        ReadOnly="true" HtmlEncode="false" />
                    <asp:BoundField DataField="Area" HeaderText="Area" SortExpression="Area" ReadOnly="true" />
                    <asp:BoundField DataField="District" HeaderText="District" SortExpression="District"
                        ReadOnly="true" HtmlEncode="false" />
                    <asp:BoundField DataField="AccountType" HeaderText="Acc Type" SortExpression="AccountType"
                        ReadOnly="true" HtmlEncode="false" />
                    <asp:BoundField DataField="PIN" HeaderText="PIN" SortExpression="PIN" ReadOnly="true" />
                    <asp:BoundField DataField="Password" HeaderText="Password" SortExpression="Password"
                        ReadOnly="true" HtmlEncode="false" />
                    <asp:BoundField DataField="RefOrderReceipt" HeaderText="Ref Order Receipt" SortExpression="RefOrderReceipt"
                        ReadOnly="true" HtmlEncode="false" />
                    <asp:BoundField DataField="Contact" HeaderText="Contact" SortExpression="Contact"
                        ReadOnly="true" HtmlEncode="false" />
                    <asp:BoundField DataField="Purpose" HeaderText="Purpose" SortExpression="Purpose"
                        ReadOnly="true" HtmlEncode="false" />
                    <asp:BoundField DataField="ValueDate" HeaderText="Value Date" SortExpression="ValueDate"
                        DataFormatString="{0:dd-MMM-yyyy}" ItemStyle-Wrap="false" ReadOnly="true">
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ExHouse_Type" HeaderText="ExHouse Type" SortExpression="ExHouse_Type" Visible="false"
                        DataFormatString="{0:dd-MMM-yyyy}" ItemStyle-Wrap="false" ReadOnly="true">
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="BeneficiaryID" HeaderText="Beneficiary ID" SortExpression="BeneficiaryID"
                        ReadOnly="true" />
                    <asp:CommandField Visible="false" ShowSelectButton="True" ButtonType="Link" />
                    <asp:TemplateField Visible="false">
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" CommandName="SELECT" CommandArgument='<%# Eval("ID") %>'
                                Height="20px" ToolTip="Open" CausesValidation="false">
                                <img alt="" height="16px" width="16px" src='Images/new_window.png' border="0" />
                            </asp:LinkButton>
                        </ItemTemplate>
                        <HeaderStyle Font-Bold="True" />
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:CheckBoxField HeaderText="Published" DataField="Published" SortExpression="Published"
                        ItemStyle-HorizontalAlign="Center" ReadOnly="true">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:CheckBoxField>
                </Columns>
                <FooterStyle BackColor="#CCCC99" Font-Bold="true" />
                <PagerSettings PageButtonCount="30" Position="TopAndBottom" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                <SelectedRowStyle BackColor="#FFA200" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" Font-Names="Arial Narrow" />
                <AlternatingRowStyle BackColor="White" />
            </asp:GridView>
            <br />
            <table>
                <tr>
                    <td valign="top">
                        <asp:GridView ID="GridView3" runat="server" AutoGenerateColumns="False" BackColor="White"
                            ShowFooter="true" CssClass="Grid" BorderColor="#DEDFDE" BorderStyle="Solid" BorderWidth="1px"
                            CellPadding="4" DataSourceID="SqlDataSource5" ForeColor="Black" GridLines="Both"
                            ShowHeader="true" AllowSorting="true" Font-Size="Small" Width="100%" OnDataBound="GridView3_DataBound">
                            <RowStyle BackColor="#F7F7DE" HorizontalAlign="Right" />
                            <Columns>
                                <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" ItemStyle-Font-Bold="true"
                                    SortExpression="PaymentMethod" ItemStyle-HorizontalAlign="Left" />
                                <asp:BoundField DataField="Total" HeaderText="Total" SortExpression="Total" DataFormatString="{0:N0}" />
                                <asp:BoundField DataField="Total_Amount" HeaderText="Total<br>Amount" HtmlEncode="false" SortExpression="Total Amount" DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="Paid" HeaderText="Paid" SortExpression="Paid" DataFormatString="{0:N0}" />
                                <asp:BoundField DataField="Paid_Amount" HeaderText="Paid<br>Amount" HtmlEncode="false" SortExpression="Paid Amount" DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="Notpaid" HeaderText="Not <br>Paid" HtmlEncode="false" SortExpression="Notpaid"
                                    DataFormatString="{0:N0}" />
                                <asp:BoundField DataField="Notpaid_Amount" HeaderText="Not Paid<br>Amount" HtmlEncode="false" SortExpression="Notpaid Amount"
                                    DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="Active" HeaderText="Active" SortExpression="Active" DataFormatString="{0:N0}" />
                                <asp:BoundField DataField="Active_Amount" HeaderText="Active<br>Amount" HtmlEncode="false" SortExpression="Active Amount" DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="Canceled" HeaderText="Cancel" SortExpression="Canceled"
                                    DataFormatString="{0:N0}" />
                                <asp:BoundField DataField="Canceled_Amount" HeaderText="Canceled<br>Amount" HtmlEncode="false" SortExpression="Canceled_Amount"
                                    DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="OnHold" HeaderText="On <br>Hold" HtmlEncode="false" SortExpression="OnHold" DataFormatString="{0:N0}" />
                                <asp:BoundField DataField="OnHold_Amount" HeaderText="On Hold<br>Amount" HtmlEncode="false" SortExpression="OnHold Amount" DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="Published" HeaderText="Published" SortExpression="Published"
                                    DataFormatString="{0:N0}" />
                                <asp:BoundField DataField="Published_Amount" HeaderText="Published<br>Amount" HtmlEncode="false" SortExpression="Published Amount"
                                    DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="NotPublished" HeaderText="Not <br>Published" HtmlEncode="false" SortExpression="NotPublished"
                                    DataFormatString="{0:N0}" />
                                <asp:BoundField DataField="NotPublished_Amount" HeaderText="Not Published<br>Amount" HtmlEncode="false" SortExpression="NotPublished Amount"
                                    DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="ReadyToPay" HeaderText="Ready <br>to Pay" HtmlEncode="false" SortExpression="ReadyToPay"
                                    DataFormatString="{0:N0}" />
                                <asp:BoundField DataField="ReadyToPay_Amount" HeaderText="Ready to Pay<br>Amount" HtmlEncode="false" SortExpression="ReadyToPay Amount"
                                    DataFormatString="{0:N2}" />
                            </Columns>
                            <FooterStyle BackColor="#CCCC99" HorizontalAlign="Right" Font-Bold="true" />
                            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#6B696B" Font-Bold="false" ForeColor="White" />
                            <AlternatingRowStyle BackColor="White" />
                        </asp:GridView>
                        <asp:SqlDataSource ID="SqlDataSource5" EnableCaching="true" CacheKeyDependency="ShowBatchCacheKey" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                            SelectCommand="s_Batch_Summary" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="Batch" QueryStringField="batch" Type="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:Button runat="server" ID="cmdPublish" Text="Publish Batch" Font-Bold="true"
                            Width="150px" Height="40px" OnClick="cmdPublish_Click" Visible="False" />
                        <asp:ConfirmButtonExtender ID="cmdPublish_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Publish?"
                            Enabled="True" TargetControlID="cmdPublish"></asp:ConfirmButtonExtender>
                        <div style="padding-top: 5px;">
                            <asp:Panel ID="panelRiaPaid" runat="server" Visible="false">
                                <asp:Button runat="server" ID="btnCancel" Text="Get Cancel Orders" Font-Bold="true"
                                    Width="150px" Height="40px" OnClick="btnCancel_Click" Visible="true" />
                                <asp:ConfirmButtonExtender ID="ConfirmButtonExtenderCancel" runat="server" ConfirmText="Do you want to download Cancel pending orders?"
                                    Enabled="True" TargetControlID="btnCancel"></asp:ConfirmButtonExtender>

                                <asp:Button runat="server" ID="btnPaid" Text="API Paid & Publish Batch" Font-Bold="true"
                                    Width="200px" Height="40px" OnClick="btnPaid_Click" Visible="true" />
                                <asp:ConfirmButtonExtender ID="ConfirmButtonExtenderPaid" runat="server" ConfirmText="Do you want to Paid and Publish Batch?"
                                    Enabled="True" TargetControlID="btnPaid"></asp:ConfirmButtonExtender>
                            </asp:Panel>
                        </div>

                    </td>
                </tr>
            </table>
            <table>
                <tr>
                    <td valign="top">
                        <asp:GridView ID="GridView4" runat="server" AutoGenerateColumns="False" Font-Size="Small"
                            DataKeyNames="Batch" DataSourceID="SqlDataSource6" AllowPaging="True" CssClass="Grid"
                            AllowSorting="True" BackColor="White" BorderColor="#DEDFDE" BorderStyle="Solid"
                            PagerSettings-Position="TopAndBottom" PageSize="30" PagerSettings-Mode="NumericFirstLast"
                            PagerSettings-PageButtonCount="30" BorderWidth="1px" CellPadding="4" ForeColor="Black">
                            <RowStyle BackColor="#F7F7DE" HorizontalAlign="Center" VerticalAlign="Top" />
                            <Columns>

                                <asp:BoundField DataField="TestNumber" HeaderText="Test<br>Number" SortExpression="TestNumber"
                                    ReadOnly="true" HtmlEncode="false" />

                                <asp:BoundField DataField="ExHouse" HeaderText="ExHouse" SortExpression="ExHouse"
                                    ItemStyle-Font-Bold="true" ReadOnly="true">
                                    <ItemStyle Font-Bold="True" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Cover Fund<br>Currency" SortExpression="CoverFundCurrency">
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("CoverFundCurrency") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="cboCoverFundCurrency" runat="server" DataSourceID="SqlDataSource3"
                                            DataTextField="Currency" DataValueField="Currency" SelectedValue='<%# Bind("CoverFundCurrency") %>'>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="cboCoverFundCurrency"
                                            ForeColor="Red" ErrorMessage="RequiredFieldValidator">*</asp:RequiredFieldValidator>
                                    </EditItemTemplate>
                                    <%--<asp:RequiredFieldValidator ID="reqCoverFundCurrency" runat="server" ErrorMessage="**" ForeColor="Red"></asp:RequiredFieldValidator>--%>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Cover Fund<br>Currency Rate" SortExpression="CoverFundCurrencyRate">
                                    <ItemTemplate>
                                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("CoverFundCurrencyRate") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtCoverFundCurrencyRate" runat="server" Width="70px" Text='<%# Bind("CoverFundCurrencyRate") %>'></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidatorCoverFundCurrencyRate"
                                            runat="server" ErrorMessage="Enter valid rate" ControlToValidate="txtCoverFundCurrencyRate"
                                            ValidationExpression="^\d{0,3}(\.\d{0,4})?$"></asp:RegularExpressionValidator>
                                        <asp:FilteredTextBoxExtender runat="server" ID="filCoverFundCurrencyRate" FilterMode="ValidChars"
                                            ValidChars="0123456789." TargetControlID="txtCoverFundCurrencyRate"></asp:FilteredTextBoxExtender>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorCoverFundCurrencyRate" runat="server"
                                            ControlToValidate="txtCoverFundCurrencyRate" ErrorMessage="*" ValidationGroup="Submit">*</asp:RequiredFieldValidator>
                                    </EditItemTemplate>
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Uploaded<br>By" SortExpression="EmpID">
                                    <ItemTemplate>
                                        <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("EmpID") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Uploaded<br>On" SortExpression="DT">
                                    <ItemTemplate>
                                        <div title='<%# Eval("DT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                            <%# TrustControl1.ToRecentDateTime(Eval("DT")) %><br />
                                            <time class="timeago" datetime='<%# Eval("DT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:CheckBoxField HeaderText="Published" DataField="Published" SortExpression="Published"
                                    Visible="false" />
                                <asp:TemplateField HeaderText="Published" SortExpression="Published">
                                    <ItemTemplate>
                                        <%# (Eval("Published").ToString() == "True") ? "<img src='Images/tick.png' width='20px' height='20px'>" : "" %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Published<br>By" SortExpression="PublishedBy">
                                    <ItemTemplate>
                                        <uc2:EMP ID="EMP2" runat="server" Username='<%# Eval("PublishedBy") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Published<br>On" SortExpression="PublishedDT">
                                    <ItemTemplate>
                                        <div title='<%# Eval("PublishedDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                            <%# TrustControl1.ToRecentDateTime(Eval("PublishedDT"))%><br />
                                            <time class="timeago" datetime='<%# Eval("PublishedDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <FooterStyle BackColor="#CCCC99" />
                            <PagerSettings Mode="NumericFirstLast" PageButtonCount="30" Position="TopAndBottom" />
                            <PagerStyle HorizontalAlign="Left" CssClass="PagerStyle" />
                            <SelectedRowStyle BackColor="#FFA200" />
                            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                            <AlternatingRowStyle BackColor="White" />
                        </asp:GridView>
                        <asp:SqlDataSource ID="SqlDataSource6" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                            SelectCommand="s_DataUploadLog_Select" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="Batch" QueryStringField="batch" Type="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </td>
                </tr>
            </table>
            <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                ProviderName="<%$ ConnectionStrings:RemittanceConnectionString.ProviderName %>"
                SelectCommand="s_DataUploadLog_Select" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="Batch" QueryStringField="batch" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource_RemiList_Batch_Publish" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                OnSelected="SqlDataSource_RemiList_Batch_Publish_Selected" ProviderName="<%$ ConnectionStrings:RemittanceConnectionString.ProviderName %>"
                SelectCommand="sp_RemiList_Batch_Publish" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="Batch" QueryStringField="batch" Type="Int32" />
                    <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                    <asp:Parameter Name="Msg" Type="String" DefaultValue=" " Size="255" Direction="InputOutput" />
                </SelectParameters>
            </asp:SqlDataSource>

            <br />
            <asp:HiddenField ID="hidLastCancelDate" runat="server" />
            <%--------------------------------------------ToBranch-----------------------------------------------------%>
            <asp:Panel runat="server" ID="panelbulk" Visible="false" CssClass="Panel1">
                <fieldset style="display: inline-block; padding: 10px" class="group">
                    <legend class="group" style="padding: 5px 10px; font-weight: bold;">Bulk Update Options</legend>
                    <asp:Panel runat="server" ID="Panel_BulkChangeToBranch" Visible="false" CssClass="Panel1">
                        ToBranch:
                        <asp:DropDownList ID="cboToBranchUpdate" runat="server" DataSourceID="SqlDataSourceToBranchUpdate"
                            AppendDataBoundItems="true" DataTextField="BranchName" DataValueField="BranchID">
                            <asp:ListItem Text="" Value=""></asp:ListItem>
                            <asp:ListItem Text="Any Branch" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Head Office" Value="1"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:Button ID="btn_ToBrancgUpdate" runat="server" Text="Update" OnClick="btn_ToBrancgUpdate_Click" />
                        <asp:ConfirmButtonExtender ID="ConfirmButtonExtender1" runat="server" ConfirmText="Do you want to Update?"
                            Enabled="True" TargetControlID="btn_ToBrancgUpdate"></asp:ConfirmButtonExtender>
                    </asp:Panel>
                    <asp:Panel runat="server" ID="Panel_BulkChangeStatus" Visible="false" CssClass="Panel1">
                        Change Status:
                        <asp:DropDownList ID="cboStatusChange" runat="server"
                            AppendDataBoundItems="true">
                            <asp:ListItem Text="" Value=""></asp:ListItem>
                            <asp:ListItem Text="ACTIVE to ON HOLD" Value="ON HOLD"></asp:ListItem>
                            <asp:ListItem Text="ON HOLD to ACTIVE" Value="ACTIVE"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:Button ID="btn_ChangeStatus" runat="server" Text="Update Status" OnClick="btn_ChangeStatus_Click" />
                        <asp:ConfirmButtonExtender ID="ConfirmButtonExtender2" runat="server" ConfirmText="Do you want to Update Status?"
                            Enabled="True" TargetControlID="btn_ChangeStatus"></asp:ConfirmButtonExtender>
                    </asp:Panel>
                </fieldset>
            </asp:Panel>
            <asp:SqlDataSource ID="SqlDataSourceToBranchUpdate" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="SELECT [BranchName], [BranchID] FROM [V_BranchOnly] ORDER BY [BranchName]"></asp:SqlDataSource>

            <br />
            <%--------------------------------------------End ToBranch-----------------------------------------------------%>
            <%-------------------------------Start Modal-----------------------------------------------------------%>
            <span style="visibility: hidden">
                <asp:Button runat="server" ID="cmdPopup" /></span>
            <asp:ModalPopupExtender ID="modal" runat="server" CancelControlID="ModalClose" TargetControlID="cmdPopup"
                PopupControlID="ModalPanel" BackgroundCssClass="ModalPopupBG" PopupDragHandleControlID="ModalTitleBar"
                RepositionMode="RepositionOnWindowResize" X="-1" Y="20" CacheDynamicResults="False"
                Drag="True">
            </asp:ModalPopupExtender>
            <asp:Panel ID="ModalPanel" runat="server" CssClass="Panel1 ui-corner-all">
                <div style="padding: 5px">
                    <table width="100%">
                        <tr>
                            <td></td>
                            <td align="right">
                                <asp:Image ID="ModalClose" runat="server" ImageUrl="~/Images/close.gif" ToolTip="Close"
                                    Style="cursor: pointer" Width="21px" Height="21px" />
                            </td>
                        </tr>
                    </table>
                    <asp:DetailsView ID="DetailsView1" runat="server" BackColor="White" BorderColor="#DEDFDE"
                        BorderStyle="Solid" BorderWidth="1px" CssClass="Grid" CellPadding="4" DataSourceID="SqlDataSource3"
                        ForeColor="Black" AutoGenerateRows="False" DataKeyNames="ID" OnItemUpdated="DetailsView1_ItemUpdated"
                        OnModeChanged="DetailsView1_ModeChanged" OnItemUpdating="DetailsView1_ItemUpdating">
                        <FooterStyle BackColor="#CCCC99" />
                        <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
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
                                    <asp:DropDownList ID="cboStatus" AutoPostBack="true" OnSelectedIndexChanged="cboStatus_SelectedIndexChanged" OnDataBound="cboStatus_OnDataBound" runat="server" DataTextField="Status" SelectedValue='<%# Bind("Status") %>'>
                                        <asp:ListItem>ACTIVE</asp:ListItem>
                                        <asp:ListItem>ON HOLD</asp:ListItem>
                                        <asp:ListItem>CANCEL</asp:ListItem>
                                        <asp:ListItem>RETURN</asp:ListItem>
                                        <asp:ListItem>REJECT</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:TextBox ID="txtReason" MaxLength="50" Width="250px" Watermark="Reason" Visible="false" runat="server"></asp:TextBox>
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
                                    <img id="imgLoadCbsAccName" alt="" src="Images/refresh.png" width="16" style="cursor: pointer" />
                                    <div id="divAccountNo" class="bold" style="height"></div>
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
                                    <asp:Button ID="cmdUpdateM" runat="server" CausesValidation="True" CommandName="Update"
                                        Text="Update" />
                                    <%--<asp:ConfirmButtonExtender ID="cmdUpdateM_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Update?"
                                        Enabled="True" TargetControlID="cmdUpdateM">
                                    </asp:ConfirmButtonExtender>--%>
                                    <asp:Button ID="Button2" runat="server" Text="Button" CausesValidation="false" OnClick="Button2_Click" Visible="false" />
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Button ID="Button1" runat="server" CausesValidation="False" CommandName="Edit"
                                        Text="Edit" />
                                </ItemTemplate>
                                <ControlStyle Width="100px" />
                            </asp:TemplateField>
                        </Fields>
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <AlternatingRowStyle BackColor="White" />
                    </asp:DetailsView>
                </div>
            </asp:Panel>
            <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                UpdateCommand="sp_RemiList_Update" UpdateCommandType="StoredProcedure" ProviderName="<%$ ConnectionStrings:RemittanceConnectionString.ProviderName %>"
                SelectCommand="sp_Remittance_Select" SelectCommandType="StoredProcedure" OnUpdated="SqlDataSource3_Updated" OnUpdating="SqlDataSource3_Updating">
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" Name="ID" PropertyName="SelectedValue" />
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
            <%-----------------------------------------------------End Modal------------------------------------------------%>
            <asp:Panel runat="server" ID="PanelCancel" Visible="false">
                <table class="ui-corner-all Panel1">
                    <tr>
                        <td>
                            <table class="SmallFont">
                                <tr>
                                    <td style="padding-left: 5px">
                                        <asp:Label ID="lblCancelText" runat="server" Text=""></asp:Label>
                                    </td>
                                    <td style="padding: 0px 5px 0px 5px">
                                        <asp:Button ID="cmdCancel" runat="server" Font-Bold="true" Text="Cancel All" Width="130px"
                                            OnClick="cmdCancel_Click" />
                                        <asp:ConfirmButtonExtender ID="cmdCancel_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Cancel All Items?"
                                            Enabled="True" TargetControlID="cmdCancel"></asp:ConfirmButtonExtender>
                                    </td>
                                    <td>
                                        <asp:LinkButton ID="lnkShowNotCancelable" runat="server" OnClick="lnkShowNotCancelable_Click"
                                            ToolTip="Show List" CssClass="Link"></asp:LinkButton>
                                    </td>
                            </table>
                        </td>
                    </tr>
                </table>
                <br />
                <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" BackColor="White"
                    AllowSorting="True" BorderColor="#DEDFDE" BorderStyle="Solid" BorderWidth="1px"
                    AllowPaging="true" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="30"
                    PagerSettings-Position="TopAndBottom" Visible="false" CellPadding="3" CssClass="Grid"
                    DataKeyNames="ID" DataSourceID="SqlDataSource2" Style="font-size: small" ShowFooter="false"
                    ForeColor="Black" OnRowDataBound="GridView2_RowDataBound" OnDataBound="GridView2_DataBound">
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                    <Columns>
                        <asp:TemplateField HeaderText="#" SortExpression="#" ItemStyle-CssClass="SLCOL">
                            <ItemTemplate>
                                <%# Eval("#","{0}") %><br />
                                <asp:Label ID="lblSL" runat="server" Text="&raquo;" Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="RID" ItemStyle-HorizontalAlign="Center" SortExpression="ID">
                            <ItemTemplate>
                                <b><a href='Remittance_Show.aspx?id=<%# Eval("ID") %>' title="View Remittance" target="_blank">
                                    <%# Eval("ID") %></a></b><a name='<%# Eval("ID","{0}") %>'></a>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="ExHouseCode" HeaderText="Ex-House" SortExpression="ExHouseCode"
                            ItemStyle-Wrap="false" ReadOnly="true">
                            <ItemStyle Wrap="False" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                            ItemStyle-HorizontalAlign="Right" ReadOnly="true">
                            <ItemStyle HorizontalAlign="Right" Font-Bold="true" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Currency" HeaderText="Currency" ReadOnly="true" ItemStyle-HorizontalAlign="Center" />
                        <asp:CheckBoxField HeaderText="Paid" DataField="Paid" SortExpression="Paid" ItemStyle-HorizontalAlign="Center"
                            ReadOnly="true">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:CheckBoxField>
                        <asp:TemplateField HeaderText="ToBranch Name" SortExpression="ToBranchName">
                            <ItemTemplate>
                                <%# Eval("ToBranchName") %>
                                <%--</asp:Label>--%>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="cboToBranch" runat="server" DataSourceID="SqlDataSourceToBranch"
                                    AppendDataBoundItems="true" DataTextField="BranchName" DataValueField="BranchID"
                                    SelectedValue='<%# Bind("ToBranch") %>'>
                                    <asp:ListItem Text="" Value=""></asp:ListItem>
                                    <asp:ListItem Text="Any Branch" Value="0"></asp:ListItem>
                                    <asp:ListItem Text="Head Office" Value="1"></asp:ListItem>
                                </asp:DropDownList>
                                <br />
                                &nbsp;<asp:LinkButton ID="cmdUpdate" runat="server" CausesValidation="false" CommandName="Update"
                                    Text="Save"></asp:LinkButton>&nbsp;<asp:LinkButton ID="cmdCancel" runat="server"
                                        CausesValidation="False" CommandName="Cancel" Text="Cancel"></asp:LinkButton><asp:SqlDataSource
                                            ID="SqlDataSourceToBranch" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                            SelectCommand="SELECT [BranchName], [BranchID] FROM [V_BranchOnly] ORDER BY [BranchName]"></asp:SqlDataSource>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Routing Number" SortExpression="RoutingNumber">
                            <EditItemTemplate>
                                <asp:TextBox AutoCompleteType="None" ID="txtRoutingNumber" onclick="this.select()"
                                    Watermark="Routing No." Text='<%# Bind("RoutingNumber") %>' runat="server" Width="100px"
                                    CausesValidation="false" CssClass="BEFTNSearchBox">
                                </asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <uc3:BEFTN ID="BEFTN1" runat="server" Code='<%# Eval("RoutingNumber") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" SortExpression="Status" ItemStyle-Wrap="false">
                            <ItemTemplate>
                                <%# Eval("Status") %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="cboStatus" runat="server" DataTextField="Status" SelectedValue='<%# Bind("Status") %>'>
                                    <asp:ListItem>ACTIVE</asp:ListItem>
                                    <asp:ListItem>ON HOLD</asp:ListItem>
                                    <asp:ListItem>CANCEL</asp:ListItem>
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <ItemStyle Wrap="False" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Payment Method" SortExpression="PaymentMethod">
                            <EditItemTemplate>
                                <asp:DropDownList ID="cboPaymentMethod" runat="server" AppendDataBoundItems="True"
                                    DataSourceID="SqlDataSourcePaymentMethod" DataTextField="PaymentMethodDetails"
                                    DataValueField="PaymentMethod" SelectedValue='<%# Bind("PaymentMethod") %>'>
                                    <asp:ListItem Text="Not Assigned" Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("PaymentMethod") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Beneficiary Name" SortExpression="BeneficiaryName">
                            <ItemTemplate>
                                <%# Eval("BeneficiaryName")%>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox runat="server" ID="txtBeneficiaryName" Text='<%# Bind("BeneficiaryName") %>'
                                    Width="200px" MaxLength="255" Watermark="Beneficiary Name"></asp:TextBox>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Beneficiary Account" SortExpression="Account">
                            <ItemTemplate>
                                <%# Eval("Account")%>
                            </ItemTemplate>
                            <ItemStyle Wrap="false" />
                            <EditItemTemplate>

                                <asp:TextBox runat="server" ID="txtAccount" Text='<%# Bind("Account") %>' Width="120px"
                                    MaxLength="50" Watermark="Beneficiary A/C"></asp:TextBox>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="RemitterName" HeaderText="Remitter Name" SortExpression="RemitterName"
                            ReadOnly="true" HtmlEncode="false" />
                        <asp:BoundField DataField="RemitterAddress" HeaderText="Remitter Address" SortExpression="RemitterAddress"
                            ReadOnly="true" HtmlEncode="false" />
                        <asp:BoundField DataField="RemitterAccount" HeaderText="Remitter Account" SortExpression="RemitterAccount"
                            ReadOnly="true" HtmlEncode="false" ItemStyle-Wrap="false" />
                        <asp:BoundField DataField="RemitterAccType" HeaderText="Remitter Acc Type" SortExpression="RemitterAccType"
                            ReadOnly="true" HtmlEncode="false" />
                        <asp:BoundField DataField="BeneficiaryAddress" HeaderText="Beneficiary Address" SortExpression="BeneficiaryAddress"
                            ReadOnly="true" HtmlEncode="false" />
                        <asp:BoundField DataField="BankName" HeaderText="Bank" SortExpression="BankName"
                            ReadOnly="true" HtmlEncode="false" />
                        <asp:BoundField DataField="BranchName" HeaderText="Branch" SortExpression="BranchName"
                            ReadOnly="true" HtmlEncode="false" />
                        <asp:BoundField DataField="Area" HeaderText="Area" SortExpression="Area" ReadOnly="true" />
                        <asp:BoundField DataField="District" HeaderText="District" SortExpression="District"
                            ReadOnly="true" HtmlEncode="false" />
                        <asp:BoundField DataField="AccountType" HeaderText="Acc Type" SortExpression="AccountType"
                            ReadOnly="true" HtmlEncode="false" />
                        <asp:BoundField DataField="PIN" HeaderText="PIN" SortExpression="PIN" ReadOnly="true" />
                        <asp:BoundField DataField="Password" HeaderText="Password" SortExpression="Password"
                            ReadOnly="true" HtmlEncode="false" />
                        <asp:BoundField DataField="RefOrderReceipt" HeaderText="Ref Order Receipt" SortExpression="RefOrderReceipt"
                            ReadOnly="true" HtmlEncode="false" />
                        <asp:BoundField DataField="Contact" HeaderText="Contact" SortExpression="Contact"
                            ReadOnly="true" HtmlEncode="false" />
                        <asp:BoundField DataField="Purpose" HeaderText="Purpose" SortExpression="Purpose"
                            ReadOnly="true" HtmlEncode="false" />
                        <asp:BoundField DataField="ValueDate" HeaderText="Value Date" SortExpression="ValueDate"
                            DataFormatString="{0:dd-MMM-yyyy}" ItemStyle-Wrap="false" ReadOnly="true">
                            <ItemStyle Wrap="False" />
                        </asp:BoundField>
                        <asp:BoundField DataField="BeneficiaryID" HeaderText="Beneficiary ID" SortExpression="BeneficiaryID"
                            ReadOnly="true" />
                        <asp:CheckBoxField HeaderText="Published" DataField="Published" SortExpression="Published"
                            ItemStyle-HorizontalAlign="Center" ReadOnly="true">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:CheckBoxField>
                    </Columns>
                    <EditRowStyle BackColor="#C5E2FD" />
                    <FooterStyle BackColor="#CCCC99" Font-Bold="true" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <AlternatingRowStyle BackColor="White" />
                </asp:GridView>
            </asp:Panel>
            <asp:HiddenField ID="hidRoutingMsg" runat="server" Value="" />
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_RemiList_Batch" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected"
                UpdateCommand="sp_RemiList_Update" UpdateCommandType="StoredProcedure" OnUpdated="SqlDataSource1_Updated"
                EnableCaching="true" CacheKeyDependency="ShowBatchCacheKey">
                <SelectParameters>
                    <asp:QueryStringParameter Name="Batch" QueryStringField="batch" Type="Int32" />
                    <asp:Parameter Name="TotalAmount" Type="Double" DefaultValue="0" Direction="InputOutput" />
                    <asp:Parameter Name="TotalCancable" Type="Int32" DefaultValue="0" Direction="InputOutput" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="ID" Type="Int32" Direction="InputOutput" DefaultValue="0" />
                    <asp:Parameter Name="ToBranch" Type="Int32" />
                    <asp:SessionParameter Name="ModifyBy" SessionField="EMPID" Type="String" />
                    <asp:Parameter Name="Msg" Type="String" Direction="InputOutput" DefaultValue="" Size="255" />
                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                    <asp:Parameter Name="RoutingNumber" Type="String" />
                    <asp:Parameter Name="Status" Type="String" />
                    <asp:Parameter Name="PaymentMethod" Type="String" DefaultValue="" />
                    <asp:Parameter Name="BeneficiaryName" Type="String" DefaultValue="" />
                    <asp:Parameter Name="Account" Type="String" DefaultValue="" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_RemiList_Batch" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="Batch" QueryStringField="batch" Type="Int32" />
                    <asp:Parameter Name="NotCancelable" Type="Boolean" DefaultValue="true" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSourceCancel" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                UpdateCommand="sp_RemiList_Batch_Cancel" UpdateCommandType="StoredProcedure"
                OnUpdated="SqlDataSourceCancel_Updated">
                <UpdateParameters>
                    <asp:QueryStringParameter Name="Batch" Type="Int32" QueryStringField="batch" />
                    <asp:SessionParameter Name="ModifyBy" SessionField="EMPID" Type="String" />
                    <asp:Parameter Name="Msg" Type="String" Size="255" DefaultValue=" " Direction="InputOutput" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSourcePaymentMethod" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="SELECT * FROM [v_PaymentMethods] ORDER BY OrderCol"></asp:SqlDataSource>
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
