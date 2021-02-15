<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    Inherits="Remittance.RiaSummaryReport" CodeFile="RiaSummaryReport.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%--<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>--%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Ria Summary Report
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

                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">Report Date
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtDateFrom" runat="server" Width="80px" CssClass="Watermark Date"
                                                    Watermark="dd/mm/yyyy" AutoPostBack="true"></asp:TextBox>
                                            </td>

                                        </tr>
                                    </table>

                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="padding-left: 10px">
                        <asp:Button ID="btnSummaryReport" runat="server" OnClick="btnSummaryReport_Click" Text="Summary Report"></asp:Button>
                    </td>
                    <td style="padding-left: 10px">
                        <asp:Button ID="btndailyReport" runat="server" OnClick="btndailyReport_Click" Text="Daily Report"></asp:Button>
                    </td>

                </tr>
            </table>
            <br />
            <div style="padding-left: 20px">
                <div class="group" style="display: table;">

                    <h2>Summary Report</h2>
                    <%--  <div>--%>
                    <asp:GridView ID="gdvSummaryReport" runat="server" AllowPaging="True" Visible="true" AllowSorting="True"
                        AutoGenerateColumns="true" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None"
                        PagerSettings-PageButtonCount="30" BorderWidth="1px" CellPadding="4"
                        PageSize="20" ForeColor="Black" GridLines="Vertical"
                        CssClass="Grid" PagerSettings-Position="TopAndBottom">
                        <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />

                        <FooterStyle BackColor="#CCCC99" />
                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <AlternatingRowStyle BackColor="White" />
                    </asp:GridView>


                </div>
            </div>
            <div style="padding-left: 20px">
                <div class="group" style="display: table;">

                    <h2>Daily Report</h2>
                    <asp:GridView ID="gdvDailyReport" runat="server" AllowPaging="True" Visible="true" AllowSorting="True"
                        AutoGenerateColumns="false" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None"
                        PagerSettings-PageButtonCount="30" BorderWidth="1px" CellPadding="4"
                        PageSize="20" ForeColor="Black" GridLines="Vertical"
                        CssClass="Grid" PagerSettings-Position="TopAndBottom">
                        <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                        <Columns>
                            <asp:BoundField DataField="SCOrderNo" HeaderText="Order No" ReadOnly="True" SortExpression="SCOrderNo" />
                      
                              <asp:TemplateField HeaderText="Pin No" HeaderStyle-HorizontalAlign="Center" >
                            <ItemTemplate>
                                <asp:Label ID="lblPin1" runat="server" Text='<%#Eval("PIN").ToString().Substring(0,5)+"******" %>'></asp:Label>
                            </ItemTemplate>
                             
                            <ItemStyle/>
                        </asp:TemplateField>
                         
                           <asp:BoundField DataField="EffectiveDate"  HeaderText="Effective Date" HtmlEncode="false" DataFormatString="{0:MM/dd/yyyy}" />
                            <asp:BoundField DataField="EffectiveTime" HeaderText="Effective Time" ReadOnly="True" SortExpression="EffectiveTime" />
                            <asp:BoundField DataField="OrderStatus" HeaderText="Order Status" ReadOnly="True" SortExpression="OrderStatus" />
                             <asp:BoundField DataField="Amount" HeaderText="Amount" ReadOnly="True" SortExpression="Amount" />
                             <asp:BoundField DataField="Type_Id" HeaderText="Type_Id" ReadOnly="True" SortExpression="Type_Id" />
                        </Columns>
                        <FooterStyle BackColor="#CCCC99" />
                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <AlternatingRowStyle BackColor="White" />
                    </asp:GridView>
                    <asp:Label ID="LabelDailyReport" runat="server" Text="" Font-Size="Small"></asp:Label>



                </div>
            </div>

        </ContentTemplate>
        <%--<Triggers>
            <asp:PostBackTrigger ControlID="cmdDownload" />
        </Triggers>--%>
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
