<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="Remittance.PaymentMethods_List" CodeFile="PaymentMethods_List.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Payment Methods
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table class="SmallFont" cellpadding="10">
                <tr>
                    <td valign="top">
                        <div class="Shadow" style="background-color: #FFFFB5; border: solid 1px silver;
                            padding: 15px">
                            <div class="Panel1 bold centertext" style="padding: 5px">
                                 Payment Methods</div>
                            <div style="padding-top: 15px">
                                <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" CssClass="Grid"
                                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                                    CellPadding="4" DataKeyNames="PaymentMethod" DataSourceID="SqlDataSource2" ForeColor="Black"
                                    GridLines="Vertical" Width="100%" onrowcommand="GridView2_RowCommand">
                                    <RowStyle BackColor="#F7F7DE" />
                                    <Columns>
                                        <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" ReadOnly="True"
                                            SortExpression="PaymentMethod" ItemStyle-Font-Bold="true" />
                                        <asp:BoundField DataField="PaymentMethodDetails" HeaderText="Details" SortExpression="PaymentMethodDetails" />
                                        <asp:BoundField DataField="OrderCol" HeaderText="Order Col" SortExpression="OrderCol"
                                            ItemStyle-HorizontalAlign="Center" Visible="false" />
                                        <asp:TemplateField HeaderText="Allow Payment" SortExpression="AllowPayment">
                                        <ItemTemplate>
                                            <%# (Eval("AllowPayment").ToString() == "True") ? "<img src='Images/tick.png' width='20px' height='20px' title='Allowed'>" : "<img src='Images/cross.png' width='20px' height='20px' title='Not Allowed'>"%>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" />                        
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Changed on" SortExpression="AllowDT">
                                            <ItemTemplate>
                                                <span title='<%# Eval("AllowDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                                    <%# TrustControl1.ToRecentDateTime(Eval("AllowDT"))%></span>
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="About" SortExpression="AllowDT">
                                            <ItemTemplate>
                                                <div class="time-small" title='<%# Eval("AllowDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                                    <time class="timeago" datetime='<%# Eval("AllowDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time></div>
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="By" SortExpression="AllowBy">
                                            <ItemTemplate>
                                                <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("AllowBy") %>' />
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Toggle/Change" >
                                            <ItemTemplate>
                                                <asp:LinkButton runat="server" ID="cmdToggle" CommandName="TOGGLE" CommandArgument='<%# Eval("PaymentMethod") %>' ToolTip="Change" CssClass="button1"><img src="Images/Switch_button.png" width="20" height="20" /></asp:LinkButton>
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>
                                    </Columns>
                                    <FooterStyle BackColor="#CCCC99" />
                                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                    <AlternatingRowStyle BackColor="White" />
                                </asp:GridView>
                                <br />
                                <asp:Button ID="cmdAllowAll" runat="server" Text="Allow All" Width="90px" 
                                    onclick="cmdAllowAll_Click" />
                                <asp:Button ID="cmdStopAll" runat="server" Text="Stop All" Width="90px" 
                                    onclick="cmdStopAll_Click" />
                                <a href="PaymentMethods_History.aspx" target="_blank" class="Link" style="color:Blue;">View History</a>    
                                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                    SelectCommand="SELECT * FROM [PaymentMethods] ORDER BY [OrderCol]">
                                </asp:SqlDataSource>
                                
                                <asp:SqlDataSource ID="SqlDataSourceToggle" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>" 
                                    UpdateCommand="sp_PaymentMethods_Toggle" UpdateCommandType="StoredProcedure">
                                    <UpdateParameters>
                                        <asp:Parameter Name="PaymentMethod" Type="String" />
                                        <asp:SessionParameter Name="ByEmp" SessionField="EMPID" Type="String" />
                                        <asp:Parameter Name="AllowPayment" Type="Boolean" DefaultValue="true" />
                                    </UpdateParameters>
                                </asp:SqlDataSource>
                                
                            </div>
                        </div>
                    </td>
                    
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
