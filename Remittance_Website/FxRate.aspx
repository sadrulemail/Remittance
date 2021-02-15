<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="Remittance.FxRate" CodeFile="FxRate.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Daily Fx Rate
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="">
                <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" CssClass="Grid"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" 
                    BorderWidth="1px" DataKeyNames="ID"
                    CellPadding="4" DataSourceID="SqlDataSource1" DefaultMode="ReadOnly"
                    ForeColor="Black" GridLines="Vertical" 
                    oniteminserted="DetailsView1_ItemInserted" 
                    onitemupdated="DetailsView1_ItemUpdated">
                    <FooterStyle BackColor="#CCCC99" />
                    <RowStyle BackColor="#F7F7DE" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                    <EmptyDataTemplate>
                        <asp:Button ID="Button3" runat="server" Text="Add New" CommandName="New" Width="100px" />
                    </EmptyDataTemplate>
                    <Fields>
                        
                        <asp:TemplateField HeaderText="Fx Date" SortExpression="FxDate">
                            <ItemTemplate>
                                <asp:Label ID="lblExHouseName" runat="server" Font-Bold="true" Font-Size="Medium" Text='<%# Bind("FxDate", "{0:dd/MM/yyyy}") %>'></asp:Label>
                                <span style="margin-left:10px"><%# Eval("FxDate", "{0:dddd}") %></span>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:Label ID="lblExHouseName" runat="server" Font-Bold="true" Font-Size="Medium" Text='<%# Bind("FxDate", "{0:dd/MM/yyyy}") %>'></asp:Label>
                                <span style="margin-left:10px"><%# Eval("FxDate", "{0:dddd}") %></span>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtDate" runat="server" CssClass="Watermark Date" Watermark="dd/mm/yyyy"
                                     Text='<%# Bind("FxDate") %>' MaxLength="10" Width="80px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorDate" runat="server" ControlToValidate="txtDate"
                                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </InsertItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="EUR" SortExpression="EUR">
                            <EditItemTemplate>
                                <asp:TextBox ID="txtEUR" runat="server" MaxLength="20" Text='<%# Bind("EUR_Rate") %>'
                                    Width="100px"></asp:TextBox>
                                <asp:FilteredTextBoxExtender ID="txtEUR_FilteredTextBoxExtender" runat="server"
                                    Enabled="True" TargetControlID="txtEUR" ValidChars="0123456789.">
                                </asp:FilteredTextBoxExtender>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="LabelEUR" runat="server" Text='<%# Bind("EUR_Rate") %>'></asp:Label>
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtEUR" runat="server" MaxLength="20" Text='<%# Bind("EUR_Rate") %>'
                                    Width="100px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorEUR" runat="server" ControlToValidate="txtEUR"
                                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </InsertItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="GBP" SortExpression="GBP">
                            <EditItemTemplate>
                                <asp:TextBox ID="txtGBP" runat="server" MaxLength="20" Text='<%# Bind("GBP_Rate") %>'
                                    Width="100px"></asp:TextBox>
                                <asp:FilteredTextBoxExtender ID="txtGBP_FilteredTextBoxExtender" runat="server"
                                    Enabled="True" TargetControlID="txtGBP" ValidChars="0123456789.">
                                </asp:FilteredTextBoxExtender>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblGBP" runat="server" Text='<%# Bind("GBP_Rate") %>'></asp:Label>
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtGBP" runat="server" MaxLength="20" Text='<%# Bind("GBP_Rate") %>'
                                    Width="100px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorGBP" runat="server" ControlToValidate="txtGBP"
                                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </InsertItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="USD" SortExpression="USD">
                            <EditItemTemplate>
                                <asp:TextBox ID="txtUSD" runat="server" MaxLength="20" Text='<%# Bind("USD_Rate") %>'
                                    Width="100px"></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblUSD" runat="server" Text='<%# Bind("USD_Rate") %>'></asp:Label>
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtUSD" runat="server" MaxLength="255" Text='<%# Bind("USD_Rate") %>'
                                    Width="100px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorUSD" runat="server" ControlToValidate="txtUSD"
                                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </InsertItemTemplate>
                        </asp:TemplateField>                        
                        <asp:TemplateField ShowHeader="False" ControlStyle-Width="80px">
                            <ItemTemplate>
                                <asp:Button ID="cmdEditFxRate" runat="server" CausesValidation="False" CommandName="Edit"
                                    Text="Edit" />
                                &nbsp;<asp:Button ID="cmdNewFx" runat="server" CausesValidation="False" CommandName="New"
                                    Text="New" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:Button ID="cmdUpdateFXRate" runat="server" CausesValidation="True" CommandName="Update"
                                    Text="Update" />
                                <asp:ConfirmButtonExtender ID="cmdUpdateFXRate_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Update?"
                                    Enabled="True" TargetControlID="cmdUpdateFXRate">
                                </asp:ConfirmButtonExtender>
                                &nbsp;<asp:Button ID="cmdCancelFX" runat="server" CausesValidation="False" CommandName="Cancel"
                                    Text="Cancel" />
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:Button ID="cmdInsertFX" runat="server" CausesValidation="True" CommandName="Insert"
                                    Text="Insert" />
                                <asp:ConfirmButtonExtender ID="cmdInsertFX_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Save?"
                                    Enabled="True" TargetControlID="cmdInsertFX">
                                </asp:ConfirmButtonExtender>
                                &nbsp;<asp:Button ID="cmdCancelFx" runat="server" CausesValidation="False" CommandName="Cancel"
                                    Text="Cancel" />
                            </InsertItemTemplate>
                        </asp:TemplateField>
                    </Fields>
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <AlternatingRowStyle BackColor="White" />
                </asp:DetailsView>
                <br />
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White" AllowPaging="true"
                    CssClass="Grid" BorderColor="#DEDFDE" BorderStyle="Solid" BorderWidth="1px" PageSize="20" PagerSettings-PageButtonCount="30" PagerSettings-Position="TopAndBottom"
                    CellPadding="4" DataSourceID="SqlDataSource2" ForeColor="Black" AllowSorting="True"
                    Font-Size="Small" DataKeyNames="ID" OnSelectedIndexChanging="GridView1_SelectedIndexChanging"
                    OnDataBound="GridView1_DataBound">
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                    <Columns>
                        <asp:BoundField DataField="ID" HeaderText="#" ReadOnly="True"
                            SortExpression="ID">
                            <ItemStyle ForeColor="Silver" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Fx Rate Date" SortExpression="FxDate" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <%# Eval("FxDate", "{0:dd/MM/yyyy}")%> 
                            </ItemTemplate>
                            <ItemStyle Font-Bold="true" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Day" SortExpression="FxDate" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <%# Eval("FxDate", "{0:ddd}")%> 
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:BoundField DataField="EUR_Rate" HeaderText="EUR" SortExpression="EUR_Rate" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="GBP_Rate" HeaderText="GBP" SortExpression="GBP_Rate" ItemStyle-HorizontalAlign="Right" />                        
                        <asp:BoundField DataField="USD_Rate" HeaderText="USD" SortExpression="USD_Rate" ItemStyle-HorizontalAlign="Right" />                        
                        <asp:TemplateField HeaderText="Insert By" SortExpression="InsertBy" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <uc2:EMP ID="EMP" runat="server" Username='<%# Eval("InsertBy") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>                        
                        <asp:TemplateField HeaderText="About" SortExpression="InsertDT" ItemStyle-Wrap="false">
                            <ItemTemplate>
                                <div class="time-small" title='<%# Eval("InsertDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <time class="timeago" datetime='<%# Eval("InsertDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time></div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Update By" SortExpression="UpdateBy" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <uc2:EMP ID="EMP2" runat="server" Username='<%# Eval("UpdateBy") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>                        
                        <asp:TemplateField HeaderText="About" SortExpression="UpdateDT" ItemStyle-Wrap="false">
                            <ItemTemplate>
                                <div class="time-small" title='<%# Eval("UpdateDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <time class="timeago" datetime='<%# Eval("UpdateDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time></div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <%--<asp:CommandField ShowSelectButton="True" />                         --%>
                        <asp:TemplateField HeaderText="" InsertVisible="False" SortExpression="">
                            <ItemTemplate>
                                <asp:LinkButton ID="LinkButton1" runat="server" CommandName="SELECT" ToolTip="Open"
                                    CausesValidation="false">
                                <img alt=""  src="Images/new_window.png" width="16" height="16" border="0" />
                                </asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                    </Columns>
                    <FooterStyle BackColor="#CCCC99" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                    <SelectedRowStyle BackColor="#FFA200" ForeColor="Black" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="false" ForeColor="White" />
                    <AlternatingRowStyle BackColor="White" />
                </asp:GridView>
                <br />
                <asp:Label ID="lblStatus" runat="server" Text=""></asp:Label>
                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                    SelectCommand="SELECT * FROM [Remi_FxRate] ORDER BY ID DESC" OnSelected="SqlDataSource2_Selected">
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                    SelectCommand="SELECT * FROM [Remi_FxRate] WHERE ID=@ID" InsertCommand="sp_FxRateInsert"
                    InsertCommandType="StoredProcedure" UpdateCommand="sp_FxRateUpdate" UpdateCommandType="StoredProcedure"
                    OnUpdated="SqlDataSource1_Updated" oninserted="SqlDataSource1_Inserted1">
                    <SelectParameters>
                        <asp:ControlParameter Name="ID" ControlID="GridView1" PropertyName="SelectedValue" />
                    </SelectParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="ID" Type="Int32" />
                        <asp:Parameter Name="FxDate" Type="DateTime" />
                        <asp:Parameter Name="EUR_Rate" Type="String" />
                        <asp:Parameter Name="GBP_Rate" Type="String" />
                        <asp:Parameter Name="USD_Rate" Type="String" />                        
                        <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                        <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                        <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                    </UpdateParameters>
                    <InsertParameters>
                        <asp:Parameter Name="FxDate" Type="DateTime" />
                        <asp:Parameter Name="EUR_Rate" Type="String" />
                        <asp:Parameter Name="GBP_Rate" Type="String" />
                        <asp:Parameter Name="USD_Rate" Type="String" />                        
                        <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />                        
                        <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                        <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                    </InsertParameters>
                </asp:SqlDataSource>
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
        UseAnimation="false" VerticalSide="Middle">
    </asp:AlwaysVisibleControlExtender>
</asp:Content>
