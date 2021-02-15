<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="Remittance.PaymentMethod_Status" CodeFile="PaymentMethod_Status.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Payment Method Status
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table class="SmallFont" cellpadding="10">
                <tr>
                    
                    <td valign="top">
                        <div class="ui-corner-all Shadow" style="background-color: #FFFFB5; border: solid 1px silver;
                            padding: 15px">
                            <div class="Panel1 ui-corner-all bold centertext" style="padding: 5px">
                                Found in Remittance Data</div>
                            <div style="padding-top: 15px">
                                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
                                    ShowFooter="true" CssClass="Grid" BorderColor="#DEDFDE" 
                                    BorderStyle="Solid" BorderWidth="1px"
                                    CellPadding="4" DataSourceID="SqlDataSource1" ForeColor="Black" GridLines="Both"
                                    ShowHeader="true" AllowSorting="true" Font-Size="Small" Width="100%" 
                                    ondatabound="GridView1_DataBound">
                                    <RowStyle BackColor="#F7F7DE" HorizontalAlign="Center" />
                                    <Columns>
                                        <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" ItemStyle-Font-Bold="true"
                                            SortExpression="PaymentMethod" ItemStyle-HorizontalAlign="Left" />
                                        <asp:BoundField DataField="Total" HeaderText="Total" SortExpression="Total" DataFormatString="{0:N0}" />
                                        <asp:BoundField DataField="Paid" HeaderText="Paid" SortExpression="Paid" DataFormatString="{0:N0}" />
                                        <asp:BoundField DataField="Notpaid" HeaderText="Not Paid" SortExpression="Notpaid" DataFormatString="{0:N0}" />
                                        <asp:BoundField DataField="Active" HeaderText="Active" SortExpression="Active" DataFormatString="{0:N0}" />
                                        <asp:BoundField DataField="Canceled" HeaderText="Cancel" SortExpression="Canceled" DataFormatString="{0:N0}" />
                                        <asp:BoundField DataField="OnHold" HeaderText="On Hold" SortExpression="OnHold" DataFormatString="{0:N0}" />
                                        <asp:BoundField DataField="Published" HeaderText="Published" SortExpression="Published" DataFormatString="{0:N0}" />
                                        <asp:BoundField DataField="NotPublished" HeaderText="Not Published" SortExpression="NotPublished" DataFormatString="{0:N0}" />
                                        <asp:BoundField DataField="ReadyToPay" HeaderText="Ready to Pay" SortExpression="ReadyToPay" DataFormatString="{0:N0}" />
                                    </Columns>
                                    <FooterStyle BackColor="#CCCC99" HorizontalAlign="Center" Font-Bold="true" />
                                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                    <HeaderStyle BackColor="#6B696B" Font-Bold="false" ForeColor="White" />
                                    <AlternatingRowStyle BackColor="White" />
                                </asp:GridView>
                                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                    SelectCommand="sp_PaymentMethod_All" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
