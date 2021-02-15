<%@ Page Title="Incentive Ex-Rate" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="FxCurrency_Rate.aspx.cs" Inherits="FxCurrency_Rate" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Incentive Ex-Rate
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
           
            <asp:DetailsView ID="DetailsView1" runat="server" CssClass="Grid" AutoGenerateRows="False"
                BackColor="White" BorderColor="#DEDFDE" BorderStyle="Solid" BorderWidth="1px"
                CellPadding="4" DataKeyNames="CurrencyDate" DataSourceID="SqlDataSource2" ForeColor="Black"
                GridLines="Vertical" Style="font-size: small">
                <FooterStyle BackColor="#CCCC99" />
                <RowStyle BackColor="#F7F7DE" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                <Fields>

                    <%--<asp:BoundField DataField="CardType" HeaderText="Card Type" 
                        ReadOnly="True" SortExpression="CardType" ControlStyle-Width="400px" />--%>
                    <asp:TemplateField HeaderText="Currency Date" SortExpression="CurrencyDate">
                        <ItemTemplate>
                            <asp:Label ID="lblCurrencyDate" runat="server" Text='<%# Eval("CurrencyDate","{0:dd/MM/yyyy}") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtCurrencyDate" Class="Date" runat="server" Text='<%# Bind("CurrencyDate","{0:dd/MM/yyyy}") %>' Width="85px"
                                MaxLength="100"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtCurrencyDate"
                                ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="txtCurrencyDate" runat="server" DataFormatString="{0:dd/MM/yyyy}" Class="Date" Text='<%# Bind("CurrencyDate") %>' Width="85px"
                                MaxLength="100"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtCurrencyDate"
                                ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                        </InsertItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Currency Code" SortExpression="CurrencyCode">
                        <EditItemTemplate>
                             <asp:DropDownList ID="ddlCurrencyCode" runat="server"  
                                 AppendDataBoundItems="true" SelectedValue='<%# Bind("CurrencyCode") %>'
                                 DataSourceID="SqlDataSourceCurrecny" DataTextField="Currency" DataValueField="Currency"
                                 >
                              </asp:DropDownList>
                              <asp:RequiredFieldValidator ID="reqCurrencyCode" runat="server" ControlToValidate="ddlCurrencyCode" ErrorMessage="*" Font-Bold="true" ForeColor="Red"></asp:RequiredFieldValidator>   
                            <asp:SqlDataSource ID="SqlDataSourceCurrecny" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                SelectCommand="SELECT Currency FROM [v_Currency] WHERE Currency <> 'BDT' ORDER BY Currency DESC"></asp:SqlDataSource>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                              <asp:DropDownList ID="ddlCurrencyCode" runat="server"  
                                 AppendDataBoundItems="true" SelectedValue='<%# Bind("CurrencyCode") %>'
                                 DataSourceID="SqlDataSourceCurrecny" DataTextField="Currency" DataValueField="Currency"
                                 >
                              </asp:DropDownList>
                              <asp:RequiredFieldValidator ID="reqCurrencyCode" runat="server" ControlToValidate="ddlCurrencyCode" ErrorMessage="*" Font-Bold="true" ForeColor="Red"></asp:RequiredFieldValidator>   
                            <asp:SqlDataSource ID="SqlDataSourceCurrecny" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                SelectCommand="SELECT Currency FROM [v_Currency] WHERE Currency <> 'BDT' ORDER BY Currency DESC"></asp:SqlDataSource>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server"
                                Text='<%# Bind("CurrencyCode") %>'></asp:Label>
                        </ItemTemplate>
                        <ControlStyle Width="150px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Currency Rate" SortExpression="CurrencyRate">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtCurrencyRate" runat="server" Text='<%# Bind("CurrencyRate") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="txtCurrencyRate" runat="server"
                                Text='<%# Bind("CurrencyRate") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server"
                                Text='<%# Bind("CurrencyRate") %>'></asp:Label>
                        </ItemTemplate>
                        <ControlStyle Width="150px" />
                    </asp:TemplateField>


                    <%-- <asp:CheckBoxField DataField="HO" HeaderText="HO" SortExpression="HO" />
                    <asp:CheckBoxField DataField="BR" HeaderText="BR" SortExpression="BR" />--%>
                    <asp:CommandField ShowInsertButton="true" ButtonType="Button" ShowEditButton="True"
                        ControlStyle-Width="80px">
                        <ControlStyle Width="80px" />
                    </asp:CommandField>
                </Fields>
                <EmptyDataTemplate>
                     <asp:Button ID="cmdNew" runat="server" Text="Add New" Width="180px" CommandName="New" />
                </EmptyDataTemplate>
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                <AlternatingRowStyle BackColor="White" />
            </asp:DetailsView>
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                InsertCommand="INSERT INTO [Incentive_ExRate]([CurrencyDate],[CurrencyCode],[CurrencyRate],[InsertBy],[InsertDT]) VALUES (@CurrencyDate,@CurrencyCode,@CurrencyRate,@Emp,getdate())"
                SelectCommand="SELECT * FROM [Incentive_ExRate] where CurrencyDate=@CurrencyDate"
                UpdateCommand="s_FxServiceLog_Update" UpdateCommandType="StoredProcedure"
                OnInserted="SqlDataSource2_Inserted"
                OnUpdated="SqlDataSource2_Updated">
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" Name="CurrencyDate" PropertyName="SelectedValue"
                        Type="DateTime" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="CurrencyDate" Type="DateTime" />
                    <asp:Parameter Name="CurrencyCode" />
                    <asp:Parameter Name="CurrencyRate" />
                    <asp:SessionParameter Name="Emp" SessionField="EmpID" />

                </UpdateParameters>
                <InsertParameters>
                    <asp:Parameter Name="CurrencyDate" Type="DateTime" />
                    <asp:Parameter Name="CurrencyCode" />
                    <asp:Parameter Name="CurrencyRate" />
                    <asp:SessionParameter Name="Emp" SessionField="EmpID" />

                </InsertParameters>
            </asp:SqlDataSource>
            <br />
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="Grid"
                BackColor="White" BorderColor="#DEDFDE" BorderStyle="Solid" BorderWidth="1px"
                AllowPaging="true" PageSize="20" PagerSettings-Mode="NumericFirstLast"
                PagerSettings-Position="TopAndBottom"
                CellPadding="3" DataKeyNames="CurrencyDate" DataSourceID="SqlDataSource1" ForeColor="Black"
                GridLines="Vertical" Style="font-size: small" 
                AllowSorting="True" 
                OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
                <FooterStyle BackColor="#CCCC99" />
                <RowStyle BackColor="#F7F7DE" />
                <Columns>
                    <asp:CommandField ShowSelectButton="True" ButtonType="Link" ItemStyle-Font-Bold="true" ItemStyle-ForeColor="Blue" />
                    <asp:BoundField DataField="CurrencyDate" HeaderText="Currency Date" ReadOnly="True" SortExpression="CurrencyDate" ItemStyle-Font-Bold="true" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center" />
                    <asp:TemplateField HeaderText="Currency Code" SortExpression="CurrencyCode" ItemStyle-HorizontalAlign="Left">
                        <ItemTemplate>
                            <%# Eval("CurrencyCode")%>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="FxCurrency Rate" SortExpression="CurrencyRate" ItemStyle-HorizontalAlign="Right">
                        <ItemTemplate>
                            <%# Eval("CurrencyRate", "{0:N2}")%>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Insert By" SortExpression="InsertBY">
                        <ItemTemplate>
                            <uc2:emp id="EMP1" runat="server" username='<%# Eval("InsertBY")%>' position="Left" />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="On" SortExpression="InsertDt">
                        <ItemTemplate>
                            <div title='<%# Eval("InsertDt","{0:dddd \ndd, MMMM, yyyy \nh:mm:ss tt}") %>'>
                                <%# TrustControl1.ToRecentDateTime(Eval("InsertDt"))%><br />
                                <time class="timeago" datetime='<%# Eval("InsertDt","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                            </div>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Update By" SortExpression="UpdateBy">
                        <ItemTemplate>
                            <uc2:emp id="EMP2" runat="server" username='<%# Eval("UpdateBy")%>' position="Left" />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="On" SortExpression="UpdateDt">
                        <ItemTemplate>
                            <div title='<%# Eval("UpdateDt","{0:dddd \ndd, MMMM, yyyy \nh:mm:ss tt}") %>'>
                                <%# TrustControl1.ToRecentDateTime(Eval("UpdateDt"))%><br />
                                <time class="timeago" datetime='<%# Eval("UpdateDt","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                            </div>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>

                </Columns>
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                <SelectedRowStyle BackColor="#FFA200" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                <AlternatingRowStyle BackColor="White" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="SELECT top 10000 * FROM [Incentive_ExRate] with (nolock) ORDER BY [CurrencyDate] Desc"></asp:SqlDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="false"
        AssociatedUpdatePanelID="UpdatePanel1" DisplayAfter="10">
        <ProgressTemplate>
            <div class="TransparentGrayBackground"></div>
            <asp:Image ID="Image1" runat="server" alt="" ImageUrl="~/Images/processing.gif"
                CssClass="LoadingImage" Width="214" Height="138" />
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:AlwaysVisibleControlExtender ID="UpdateProgress1_AlwaysVisibleControlExtender"
        runat="server" Enabled="True" HorizontalSide="Center" TargetControlID="Image1"
        UseAnimation="false" VerticalSide="Middle"></asp:AlwaysVisibleControlExtender>
</asp:Content>
