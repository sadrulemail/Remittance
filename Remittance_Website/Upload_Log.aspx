<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    Inherits="Remittance.Upload_Log" CodeFile="Upload_Log.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Upload Data Log
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <table style="font-size: small" class="ui-corner-all Panel1">
                            <tr>
                                <td>
                                    <table>
                                        <tr>
                                        <td>
                                                Batch
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtBatch" runat="server" Width="80px" Watermark="Batch ID"></asp:TextBox>
                                            </td>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                                Upload from
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtDateFrom" runat="server" Width="80px" CssClass="Watermark Date"
                                                    Watermark="dd/mm/yyyy" AutoPostBack="true"></asp:TextBox>
                                            </td>
                                            <td>
                                                to
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtDateTo" runat="server" Width="80px" CssClass="Watermark Date"
                                                    Watermark="dd/mm/yyyy" AutoPostBack="true"></asp:TextBox>
                                            </td>
                                            <td style="padding-left: 10px">
                                                Uploaded By
                                                <asp:TextBox ID="txtUploadBy" Width="60px" CssClass="emp-add-control-all" Watermark="Emp ID"
                                                    runat="server"></asp:TextBox>
                                            </td>
                                            <td style="padding-left: 10px">
                                                Published By
                                                <asp:TextBox ID="txtPublishedBy" Width="60px" CssClass="emp-add-control-all" Watermark="Emp ID"
                                                    runat="server"></asp:TextBox>
                                            </td>
                                            <td style="padding-left: 10px">
                                                Status
                                                <asp:DropDownList ID="dboPublished" AutoPostBack="true" runat="server">
                                                    <asp:ListItem Text="All" Value="-1"></asp:ListItem>
                                                    <asp:ListItem Text="Published" Value="1"></asp:ListItem>
                                                    <asp:ListItem Text="Not Published" Value="0"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                    <table>
                                        <tr>
                                        <td>Type
                                            <asp:DropDownList ID="cboExHouseType" runat="server" AutoPostBack="true">
                                                     <asp:ListItem Value="*" Text="ALL"></asp:ListItem>
                                                     <asp:ListItem Value="R" Text="Remittance"></asp:ListItem>
                                                     <asp:ListItem Value="W" Text="Web"></asp:ListItem>
                                                     <asp:ListItem Value="A" Text="Api"></asp:ListItem>
                                                 </asp:DropDownList>
                                            </td>
                                            <td style="padding-left: 10px">
                                                Ex-House
                                                <asp:DropDownList ID="cboExHouse" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                                    DataSourceID="SqlDataSource2" DataTextField="ExHouseName" DataValueField="ExHouseCode">
                                                    <asp:ListItem Value="-1" Text="All"></asp:ListItem>
                                                    <asp:ListItem Value="CUSTOM" Text="Custom Format"></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                    SelectCommand="SELECT [ExHouseCode],ExHouseCode+', '+[ExHouseName] as ExHouseName FROM [v_ExHouseListDetails] with (nolock) ORDER BY ExHouseName">
                                                </asp:SqlDataSource>
                                            </td>
                                            
                                            <td style="padding: 0px 10px 0px 10px">
                                                <asp:Button ID="cmdFilter" runat="server" Text="Show" 
                                                    onclick="cmdFilter_Click" />
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
            <div style="padding-left: 20px">
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" Font-Size="Small"
                    DataKeyNames="Batch" DataSourceID="SqlDataSource1" AllowPaging="True" CssClass="Grid"
                    AllowSorting="True" BackColor="White" BorderColor="#DEDFDE" BorderStyle="Solid"
                    PagerSettings-Position="TopAndBottom" PageSize="30" PagerSettings-Mode="NumericFirstLast"
                    PagerSettings-PageButtonCount="30" BorderWidth="1px" CellPadding="4" ForeColor="Black"
                    OnDataBound="GridView1_DataBound" OnRowDataBound="GridView1_RowDataBound" OnRowCommand="GridView1_RowCommand"
                    OnPageIndexChanged="GridView1_PageIndexChanged">
                    <RowStyle BackColor="#F7F7DE" HorizontalAlign="Center" VerticalAlign="Top" />
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <a href='ShowBatch.aspx?batch=<%# Eval("Batch") %>' title="View Batch Items" target="_blank">
                                    <img src='Images/open.png' width='16' height='16' border='0' title='View' />
                                </a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Batch ID" ItemStyle-Font-Bold="true" SortExpression="Batch">
                            <ItemTemplate>
                                <%# Eval("Batch") %>
                            </ItemTemplate>
                            <ItemStyle Font-Bold="True" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="Total" HeaderText="Total Items" SortExpression="Total"
                            ReadOnly="true" />
                        <asp:BoundField DataField="TestNumber" HeaderText="Test Number" SortExpression="TestNumber"
                            ReadOnly="true" />
                        <asp:BoundField DataField="Currency" HeaderText="Payment<br>Currency" SortExpression="Currency" HtmlEncode="false"
                            ReadOnly="true" />
                        <asp:TemplateField HeaderText="Total Amount" SortExpression="TotalAmount">
                            <ItemTemplate>
                                <%# Eval("TotalAmount","{0:N2}") %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Right" />
                            
                        </asp:TemplateField>
                        <asp:BoundField DataField="ExHouse" HeaderText="ExHouse" SortExpression="ExHouse"
                            ItemStyle-Font-Bold="true" ReadOnly="true">
                            <ItemStyle Font-Bold="True" />
                        </asp:BoundField>
                        
                         <asp:BoundField DataField="ExHouse_Type" HeaderText="Type" SortExpression="ExHouse_Type"
                            ItemStyle-Font-Bold="true" ReadOnly="true">
                            <ItemStyle Font-Bold="True" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Cover Fund<br>Currency" SortExpression="CoverFundCurrency">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("CoverFundCurrency") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="cboCoverFundCurrency" runat="server" AppendDataBoundItems="true"
                                    DataSourceID="SqlDataSource3" DataTextField="Currency" DataValueField="Currency"
                                    SelectedValue='<%# Bind("CoverFundCurrency") %>'>
                                    <asp:ListItem></asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="cboCoverFundCurrency"
                                    ForeColor="Red" ErrorMessage="RequiredFieldValidator">*</asp:RequiredFieldValidator>
                            </EditItemTemplate>
                            <%--<asp:RequiredFieldValidator ID="reqCoverFundCurrency" runat="server" ErrorMessage="**" ForeColor="Red"></asp:RequiredFieldValidator>--%>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Cover Fund<br>Currency Rate" SortExpression="CoverFundCurrencyRate" HeaderStyle-Width="75px">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Bind("CoverFundCurrencyRate") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtCoverFundCurrencyRate" runat="server" Width="70px" Text='<%# Bind("CoverFundCurrencyRate") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorCoverFundCurrencyRate" runat="server"
                                    ControlToValidate="txtCoverFundCurrencyRate" ErrorMessage="*" ValidationGroup="Submit">*</asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidatorCoverFundCurrencyRate"
                                    runat="server" ErrorMessage="Enter valid rate" ControlToValidate="txtCoverFundCurrencyRate"
                                    ValidationExpression="^\d{0,3}(\.\d{0,4})?$"></asp:RegularExpressionValidator>
                                <asp:FilteredTextBoxExtender runat="server" ID="filCoverFundCurrencyRate" FilterMode="ValidChars"
                                    ValidChars="0123456789." TargetControlID="txtCoverFundCurrencyRate">
                                </asp:FilteredTextBoxExtender>
                            </EditItemTemplate>
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Uploaded<br>By" SortExpression="EmpID">
                            <ItemTemplate>
                                <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("EmpID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Uploaded On" SortExpression="DT">
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
                        <asp:TemplateField HeaderText="Published On" SortExpression="PublishedDT">
                            <ItemTemplate>
                                <div title='<%# Eval("PublishedDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# TrustControl1.ToRecentDateTime(Eval("PublishedDT"))%><br />
                                    <time class="timeago" datetime='<%# Eval("PublishedDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ShowHeader="False">
                            <EditItemTemplate>
                                <asp:LinkButton ID="lnkUpdate" runat="server" CausesValidation="True" CommandName="Update"
                                    Text="Update"></asp:LinkButton>
                                <asp:ConfirmButtonExtender ID="lnkUpdate_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Update?"
                                    Enabled="True" TargetControlID="lnkUpdate">
                                </asp:ConfirmButtonExtender>
                                &nbsp;<asp:LinkButton ID="lnkCancel" runat="server" CausesValidation="False" CommandName="Cancel"
                                    Text="Cancel"></asp:LinkButton>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkEdit" runat="server" CausesValidation="False" CommandName="Edit"
                                    Text="Edit"></asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle Font-Bold="True" ForeColor="Blue" />
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <%--<a href='ShowBatch.aspx?batch=<%# Eval("Batch") %>' title="View History" target="_blank">--%>
                                <asp:LinkButton ID="cmdHistory" runat="server" CausesValidation="False" CommandName="Select"
                                    CommandArgument='<%# Eval("Batch") %>'>                                                           
                                <img src='Images/v_history.png' width='16' height='16' border='0' title='View History'/> 

                                </asp:LinkButton>
                                </a>
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
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                    SelectCommand="sp_DataUploadLog_Browse" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected"
                    UpdateCommand="s_DataUploadLog_Update" UpdateCommandType="StoredProcedure" OnUpdated="SqlDataSource1_Updated">
                    <SelectParameters>
                         <asp:ControlParameter ControlID="txtBatch" Name="Batch" PropertyName="Text"
                            Type="Int32" DefaultValue="-1" />
                        <asp:ControlParameter ControlID="dboPublished" Name="Published" DbType="String" PropertyName="SelectedValue"
                            DefaultValue="" />
                        <asp:ControlParameter ControlID="txtDateFrom" Name="DateFrom" DefaultValue='01/01/1900'
                            PropertyName="Text" Type="DateTime" />
                        <asp:ControlParameter ControlID="txtDateTo" Name="DateTo" DefaultValue='01/01/1900'
                            PropertyName="Text" Type="DateTime" />
                        <asp:ControlParameter ControlID="txtUploadBy" Name="UploadBy" PropertyName="Text"
                            Type="String" DefaultValue="" ConvertEmptyStringToNull="false" />
                        <asp:ControlParameter ControlID="txtPublishedBy" Name="PublishBy" PropertyName="Text"
                            Type="String" DefaultValue="" ConvertEmptyStringToNull="false" />
                        <asp:ControlParameter ControlID="cboExHouse" Name="ExHouse" PropertyName="SelectedValue"
                            Type="String" DefaultValue="" ConvertEmptyStringToNull="false" />
                        <asp:ControlParameter ControlID="cboExHouseType" Name="ExHouseType" Type="String" PropertyName="SelectedValue"
                            DefaultValue="*" />
                    </SelectParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="Batch" Type="Int32" />
                        <asp:Parameter Name="CoverFundCurrency" Type="String" />
                        <asp:Parameter Name="CoverFundCurrencyRate" Type="Decimal" />
                        <%--<asp:ControlParameter ControlID="txtCoverFundCurrencyRate" Name="CoverFundCurrencyRate" PropertyName="Text"
                        Type="Decimal" />--%>
                        <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                    </UpdateParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                    SelectCommand="SELECT * FROM v_Currency WHERE Currency<>'BDT'"></asp:SqlDataSource>
                <br />
                <asp:Label ID="lblStatus" runat="server" Text="" Font-Size="Small"></asp:Label>
                <br/>
                <br />
                <asp:Button ID="cmdDownload" runat="server" Text="Download as xlsx" 
                    onclick="cmdDownload_Click" />
            </div>
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
                            <td>
                            </td>
                            <td align="right">
                                <asp:Image ID="ModalClose" runat="server" ImageUrl="~/Images/close.gif" ToolTip="Close"
                                    Style="cursor: pointer" Width="21px" Height="21px" />
                            </td>
                        </tr>
                    </table>
                    <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" Font-Size="Small"
                        DataKeyNames="Batch" DataSourceID="SqlDataSource4" AllowPaging="True" CssClass="Grid"
                        AllowSorting="True" BackColor="White" BorderColor="#DEDFDE" BorderStyle="Solid"
                        PagerSettings-Position="TopAndBottom" PageSize="30" PagerSettings-Mode="NumericFirstLast"
                        PagerSettings-PageButtonCount="30" BorderWidth="1px" CellPadding="4" ForeColor="Black">
                        <RowStyle BackColor="#F7F7DE" HorizontalAlign="Center" VerticalAlign="Top" />
                        <Columns>
                            <asp:TemplateField HeaderText="#" ItemStyle-Font-Bold="true" SortExpression="SL1">
                                <ItemTemplate>
                                    <div title='<%# Eval("A_SL")%>'>
                                        <%# Eval("SL")%>
                                    </div>
                                    
                                </ItemTemplate>
                                <ItemStyle Font-Bold="True" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="Batch" HeaderText="Batch" SortExpression="Batch" ReadOnly="true" />
                            <asp:BoundField DataField="CoverFundCurrency" HeaderText="Cover Fund Currency" SortExpression="CoverFundCurrency"
                                ReadOnly="true" />
                            <asp:BoundField DataField="CoverFundCurrencyRate" HeaderText="Cover Fund Currency Rate"
                                SortExpression="CoverFundCurrencyRate" ReadOnly="true" />

                                <asp:BoundField DataField="Particulars" HeaderText="Particulars"
                                SortExpression="Particulars" ReadOnly="true" />
                            <asp:TemplateField HeaderText="Updated By" SortExpression="EmpID">
                                <ItemTemplate>
                                    <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("EmpID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Uploaded On" SortExpression="DT">
                                <ItemTemplate>
                                    <div title='<%# Eval("DT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                        <%# TrustControl1.ToRecentDateTime(Eval("DT")) %><br />
                                        <time class="timeago" datetime='<%# Eval("DT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div runat="server" style="width:300px;height:250px;text-align:center;">
                            No History Found.
                            </div>
                        </EmptyDataTemplate>
                        <EmptyDataRowStyle Font-Size="Medium" Width="500px" Height="200px" />
                        <FooterStyle BackColor="#CCCC99" />
                        <PagerSettings Mode="NumericFirstLast" PageButtonCount="30" Position="TopAndBottom" />
                        <PagerStyle HorizontalAlign="Left" CssClass="PagerStyle" />
                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <AlternatingRowStyle BackColor="White" />
                    </asp:GridView>
                </div>
            </asp:Panel>
            <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                ProviderName="<%$ ConnectionStrings:RemittanceConnectionString.ProviderName %>"
                SelectCommand="s_DataUploadLog_History_Browse" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" Name="Batch" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
            <br />
            <%-----------------------------------------------------End Modal------------------------------------------------%>
        </ContentTemplate>
        <Triggers>
        <asp:PostBackTrigger ControlID="cmdDownload" />
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
