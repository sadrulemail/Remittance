<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    Inherits="Remittance.Upload" CodeFile="Upload.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .AsyncFileUploadField input
        {
            width: 95% !important;
        }
    </style>
    <script type="text/javascript">
        function AssemblyFileUpload_Started(sender, args) {
            $('#ctl00_ContentPlaceHolder2_lblUploadStatus').html('');
            var filename = args.get_fileName();
            var ext = filename.substring(filename.lastIndexOf(".") + 1);
            if (ext.toLowerCase() != 'xlsx') {
                $('#ctl00_ContentPlaceHolder2_lblUploadStatus').html('Only XLSX files can be uploaded.');
                $('#UploadBtn').hide('Slow');
                throw {
                    name: "Invalid File Type",
                    level: "Error",
                    message: "Only <b>XLSX</b> files can be uploaded. ",
                    htmlMessage: "Only XLSX files can be uploaded. "
                }
                return false;
            }
            return true;
        }

        function UploadError(sender, args) {
            $('#ctl00_ContentPlaceHolder2_lblUploadStatus').html(args.get_errorMessage() + 'File Uploading Error. Please try again.');
            $('#UploadBtn').hide('Slow');
        }

        function UploadComplete(sender, args) {
            var filename = args.get_fileName();
            var contentType = args.get_contentType();
            var text = "Size of " + filename + " is " + args.get_length() + " bytes";
            if (contentType.length > 0) {
                text += " and content type is '" + contentType + "'.";
            }
            $('#ctl00_ContentPlaceHolder2_lblUploadStatus').html('<b>' + filename + '</b> is successfully uploaded.');
            $('#UploadBtn').show('Slow');
        }
    </script>
    <style type="text/css">
        .Border1
        {
            background-color: #FFFFB5;
            padding: 10px;
            border: solid 1px green;
            width: 200px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Upload Data File
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:HiddenField ID="HidPageID" runat="server" Value="" />
            <asp:HiddenField ID="HidUploadTempFile" runat="server" Value="" />
            <asp:Button ID="cmdClearData" runat="server" Text="Clear Data" OnClick="cmdClearData_Click"
                Visible="false" />
            <asp:Button ID="cmdDataBind" runat="server" Text="Data Bind" Visible="false" OnClick="cmdDataBind_Click" />
            <asp:Panel ID="Panel1" runat="server">
                <div class="Panel1 ui-corner-all" style="padding: 0 0 0 20px; width: 600px">
                    <div style="font-size: small; font-weight: bolder; padding: 10px 0px 3px 0px;">
                        Please select XLSX file to upload data:</div>
                    <asp:AsyncFileUpload ID="FileUpload1" runat="server" Width="550px" OnUploadedComplete="FileUpload1_UploadedComplete"
                        ThrobberID="myThrobber" OnClientUploadComplete="UploadComplete" OnClientUploadError="UploadError"
                        OnUploadedFileError="FileUpload1_UploadedFileError" UploaderStyle="Traditional"
                        CssClass="AsyncFileUploadField" OnClientUploadStarted="AssemblyFileUpload_Started" />
                    <asp:Image ImageUrl="~/Images/ajax-loader.gif" ID="myThrobber" runat="server" />
                    <div style="padding: 5px 0px 10px 0px">
                        <asp:Label ID="lblUploadStatus" runat="server" Text=""></asp:Label>
                    </div>
                </div>
                <table style="display: none;" id="UploadBtn">
                    <tr>
                        <td style="padding: 10px 0 0 0">
                            <div class="ui-corner-all Shadow Border">
                                <span style="font-size: larger; font-weight: bold"></span>
                                <table class="SmallFont" width="500px">
                                    <tr>
                                        <td nowrap="nowrap">
                                            Exchange House:
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="cboExHouse" runat="server" DataSourceID="SqlDataSourceExHouses"
                                                DataTextField="ExHouseName" DataValueField="ExHouseCode" AppendDataBoundItems="True" Width="500px">
                                                <asp:ListItem></asp:ListItem>
                                                <asp:ListItem Text="CUSTOM FORMAT" Value="CUSTOM" style="background-color: Yellow"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="cboExHouse"
                                                ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                            <asp:SqlDataSource ID="SqlDataSourceExHouses" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                SelectCommand="SELECT [ExHouseCode], ExHouseCode + ', ' +[ExHouseName] as ExHouseName FROM [ExHouses] WHERE ([Active] = @Active) ORDER BY [ExHouseName]">
                                                <SelectParameters>
                                                    <asp:Parameter DefaultValue="True" Name="Active" Type="Boolean" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Worksheet:
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="txtWorksheet" Text="1" Width="30px" MaxLength="2"
                                                onfocus="this.select()" Style="text-align: center"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="txtWorksheet_FilteredTextBoxExtender" runat="server"
                                                Enabled="True" TargetControlID="txtWorksheet" ValidChars="0123456789">
                                            </asp:FilteredTextBoxExtender>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            To Branch (All):
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="dboAnyBRanch" runat="server">
                                                <asp:ListItem Text="No Change" Value=""></asp:ListItem>
                                                <asp:ListItem Text="Any Branch (0)" Value="0"></asp:ListItem>
                                                <asp:ListItem Text="Dilkusha Corporate (17)" Value="17"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <asp:CheckBox ID="chkDoNotChangeAccountNumber" runat="server" Text=" Do Not Change Beneficiary A/C Number" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td style="padding-top: 20px">
                                            <asp:Button ID="cmdCheck" runat="server" Text="View Data" Width="120px" Height="30px"
                                                OnClick="cmdCheck_Click" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                        <td style="padding: 0 0 0 30px">
                            <img src="Images/rms.jpg" />
                        </td>
                    </tr>
                </table>
                <br />
            </asp:Panel>
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
                BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="3" CssClass="Grid"
                AllowPaging="false" DataKeyNames="ID" DataSourceID="SqlDataSource1" Style="font-size: small"
                ShowFooter="True" ForeColor="Black" GridLines="Vertical" OnDataBound="GridView1_DataBound">
                <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                <Columns>
                    <asp:TemplateField HeaderText="#" ItemStyle-BackColor="#6B696B" ItemStyle-ForeColor="White"
                        ItemStyle-Font-Size="Medium" ItemStyle-HorizontalAlign="Center" ItemStyle-Font-Bold="true">
                        <ItemTemplate>
                        </ItemTemplate>
                        <ItemStyle BackColor="#6B696B" Font-Bold="True" Font-Size="Medium" ForeColor="White"
                            HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="ExHouseCode" HeaderText="Ex-House" SortExpression="ExHouseCode"
                        ItemStyle-Wrap="false" ReadOnly="true">
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="SL" HeaderText="SL" SortExpression="SL" ItemStyle-HorizontalAlign="Center"
                        ReadOnly="true">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                        ItemStyle-HorizontalAlign="Right" ReadOnly="true">
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="RemitterName" HeaderText="Remitter Name" SortExpression="RemitterName"
                        ReadOnly="true" HtmlEncode="false" />
                    <asp:BoundField DataField="RemitterAddress" HeaderText="Remitter Address" SortExpression="RemitterAddress"
                        ReadOnly="true" HtmlEncode="false" />
                    <asp:BoundField DataField="RemitterAccount" HeaderText="Remitter Account" SortExpression="RemitterAccount"
                        ReadOnly="true" HtmlEncode="false" ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="RemitterAccType" HeaderText="Remitter Acc Type" SortExpression="RemitterAccType"
                        ReadOnly="true" HtmlEncode="false" />
                    <asp:BoundField DataField="BeneficiaryName" HeaderText="Beneficiary Name" SortExpression="BeneficiaryName"
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
                    <asp:BoundField DataField="Account" HeaderText="Account" SortExpression="Account"
                        ReadOnly="true" HtmlEncode="false" ItemStyle-Wrap="false" />
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
                    <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" SortExpression="PaymentMethod"
                        ReadOnly="true" HtmlEncode="false" />
                    <asp:BoundField DataField="ValueDate" HeaderText="Value Date" SortExpression="ValueDate"
                        DataFormatString="{0:dd-MMM-yyyy}" ItemStyle-Wrap="false" ReadOnly="true">
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>                    
                    <asp:BoundField DataField="BeneficiaryID" HeaderText="Beneficiary ID" SortExpression="BeneficiaryID"
                        ReadOnly="true" />
                    <asp:BoundField DataField="RoutingNumber" HeaderText="Routing Number" SortExpression="RoutingNumber"
                        ReadOnly="true" />
                    <asp:TemplateField HeaderText="To Branch" SortExpression="ToBranch" ItemStyle-HorizontalAlign="Left">
                        <ItemTemplate>
                            <%--<asp:LinkButton ID="LinkButtonToBranch" runat="server" CausesValidation="False" CommandName="Edit"
                                Text='<%# (Eval("ToBranch").ToString()!="") ? Eval("ToBranch") : "..." %>' ToolTip="Change"></asp:LinkButton>--%>
                                
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSourceToBranch"
                                DataTextField="BranchName" DataValueField="BranchID" SelectedValue='<%# Bind("ToBranch") %>'
                                AppendDataBoundItems="true">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                <asp:ListItem Text="Any Branch" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Head Office" Value="1"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSourceToBranch" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                SelectCommand="SELECT [BranchName], [BranchID] FROM [V_BranchOnly] ORDER BY [BranchName]">
                            </asp:SqlDataSource>
                            <br />
                            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update"
                                Text="Save"></asp:LinkButton>
                            &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel"
                                Text="Cancel"></asp:LinkButton>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Comment (HO)" SortExpression="CommentHO">
                        <ItemTemplate>
                            <asp:Label ID="Label2" runat="server" Text='<%# Bind("CommentHO") %>' BackColor="Yellow"></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBox1" runat="server" Rows="3" Font-Names="Arial" Font-Size="Small"
                                Text='<%# Bind("CommentHO") %>' TextMode="MultiLine" Width="150px"></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status"
                        ReadOnly="true" />
                </Columns>
                <EditRowStyle BackColor="#C5E2FD" />
                <FooterStyle BackColor="#CCCC99" Font-Bold="true" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle1" />
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                <AlternatingRowStyle BackColor="White" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" SelectCommand="s_TempUpload" SelectCommandType="StoredProcedure"
                UpdateCommand="UPDATE TempUpload SET ToBranch = @ToBranch, CommentHO = @CommentHO WHERE (ID = @ID)"
                ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>" ProviderName="<%$ ConnectionStrings:RemittanceConnectionString.ProviderName %>">
                <UpdateParameters>
                    <asp:Parameter Name="ToBranch" Type="Int32" DefaultValue="" ConvertEmptyStringToNull="true" />
                    <asp:Parameter Name="ID" Type="Int64" DefaultValue="" ConvertEmptyStringToNull="true" />
                    <asp:Parameter Name="CommentHO" Type="String" DefaultValue="" ConvertEmptyStringToNull="true" />
                </UpdateParameters>
                <SelectParameters>
                    <asp:ControlParameter Name="SessionID" ControlID="HidPageID" PropertyName="Value"
                        Type="String" />
                    <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:Panel ID="Panel2" runat="server">
                <asp:Label ID="lblStatus" runat="server" Text=""></asp:Label>
                <br />
                <br />
                <table>
                    <tr>
                        <td style="padding: 0 30px 0 20px">
                            <img src="Images/rms.jpg" width="90px" height="90px" />
                        </td>
                        <td class="ui-corner-all Shadow Border" width="360px">
                            <table>
                                <tr>
                                    <td nowrap="nowrap" style="padding-right: 10px">
                                        <span style="font-size: small;"><b>Test Number:</b></span>
                                    </td>
                                    <td style="margin-left: 40px">
                                        <asp:TextBox runat="server" ID="txtTestNo" Text="" Width="130" MaxLength="20"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtTestNo"
                                            ErrorMessage="*" ValidationGroup="Submit"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap" style="padding-right: 10px">
                                        <span style="font-size: small;"><b>Payment Currency:</b></span>&nbsp;
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="cboCurrency" runat="server" AppendDataBoundItems="true" DataSourceID="SqlDataSourceCurrency"
                                            DataTextField="Currency" DataValueField="Currency">
                                            <asp:ListItem Text="" Value=""></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorcboCurrency" runat="server"
                                            ControlToValidate="cboCurrency" ErrorMessage="*" ValidationGroup="Submit">*</asp:RequiredFieldValidator>
                                        <asp:SqlDataSource ID="SqlDataSourceCurrency" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                            SelectCommand="SELECT [Currency] FROM [CurrencyCodes] ORDER BY [Currency]"></asp:SqlDataSource>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap" style="padding-right: 10px">
                                        <span style="font-size: small;"><b>Cover Fund Currency:</b></span>
                                    </td>
                                    <td style="margin-left: 40px">
                                        <asp:DropDownList ID="cboCoverFundCurrency" runat="server" AppendDataBoundItems="true"
                                            DataSourceID="SqlDataSourceCoverFundCurrency" DataTextField="Currency" DataValueField="Currency">
                                            <asp:ListItem Text="" Value=""></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorCurrecny" runat="server" ControlToValidate="cboCoverFundCurrency"
                                            ErrorMessage="*" ValidationGroup="Submit">*</asp:RequiredFieldValidator>
                                        <asp:SqlDataSource ID="SqlDataSourceCoverFundCurrency" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                            SelectCommand="SELECT * FROM [v_Currency] WHERE Currency <> 'BDT'"></asp:SqlDataSource>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap" style="padding-right: 10px">
                                        <span style="font-size: small;"><b>Cover Fund Currency Rate:</b></span>
                                    </td>
                                    <td style="margin-left: 40px">
                                        <asp:TextBox ID="txtCoverFundCurrencyRate" runat="server" Text="0.00" Width="70px"
                                            CssClass="right"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidatorCoverFundCurrencyRate"
                                            runat="server" ErrorMessage="Enter valid rate" ControlToValidate="txtCoverFundCurrencyRate"
                                            ValidationExpression="^\d{0,3}(\.\d{0,4})?$"></asp:RegularExpressionValidator>
                                        <asp:FilteredTextBoxExtender runat="server" ID="filCoverFundCurrencyRate" FilterMode="ValidChars"
                                            ValidChars="0123456789." TargetControlID="txtCoverFundCurrencyRate">
                                        </asp:FilteredTextBoxExtender>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorCoverFundCurrencyRate" runat="server"
                                            ControlToValidate="txtCoverFundCurrencyRate" ErrorMessage="*" ValidationGroup="Submit">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        <asp:Button ID="cmdUpdate" runat="server" Font-Bold="true" Height="30px" 
                                            OnClick="cmdUpdate_Click"
                                            Text="Upload Data (Not Published)" ValidationGroup="Submit" Width="220px" />
                                        <asp:ConfirmButtonExtender ID="cmdUpdate_ConfirmButtonExtender" runat="server" ConfirmText="Are you sure?"
                                            Enabled="True" TargetControlID="cmdUpdate">
                                        </asp:ConfirmButtonExtender>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <br />
            <br />
            <asp:Label ID="Label3" runat="server" Text="" Font-Bold="true"></asp:Label>
            <br />
            <asp:Label ID="Label4" runat="server" Text="" Font-Size="Small"></asp:Label>
            <asp:SqlDataSource ID="SqlDataSourceRemiList_Add" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                ProviderName="<%$ ConnectionStrings:RemittanceConnectionString.ProviderName %>"
                SelectCommand="sp_RemiList_Add" SelectCommandType="StoredProcedure" OnSelected="SqlDataSourceRemiList_Add_Selected">
                <SelectParameters>
                    <asp:ControlParameter Name="SessionID" ControlID="HidPageID" PropertyName="Value"
                        Type="String" />
                    <asp:ControlParameter ControlID="txtTestNo" Name="TestNumber" PropertyName="Text"
                        Type="String" />
                    <asp:Parameter Direction="InputOutput" Name="Batch" Type="Int32" DefaultValue="0" />
                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                    <asp:ControlParameter ControlID="cboCurrency" Name="Currency" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="cboCoverFundCurrency" Name="CoverFundCurrency" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="txtCoverFundCurrencyRate" Name="CoverFundCurrencyRate"
                        PropertyName="Text" Type="Decimal" />
                    <asp:SessionParameter SessionField="EMPID" Type="String" Name="EmpID" />
                    <asp:ControlParameter Name="ExHouse" ControlID="cboExHouse" Type="String" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
            <br />
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
