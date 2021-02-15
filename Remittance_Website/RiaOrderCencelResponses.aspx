<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    Inherits="Remittance.RiaOrderCencelResponses" CodeFile="RiaOrderCencelResponses.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%--<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>--%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Ria Order Cancel
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
                                            <td>Filter
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtFilter" runat="server" Width="80px" Watermark="RID or Order No"></asp:TextBox>
                                            </td>
                                            <td style="padding-left: 10px; white-space: nowrap; text-align: right">Date
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtDateFrom" runat="server" Width="80px" CssClass="Watermark Date"
                                                    Watermark="dd/mm/yyyy" AutoPostBack="true"></asp:TextBox>
                                            </td>
                                            <td>to
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtDateTo" runat="server" Width="80px" CssClass="Watermark Date"
                                                    Watermark="dd/mm/yyyy" AutoPostBack="true"></asp:TextBox>
                                            </td>

                                            <td style="padding-left: 10px">Input Cancel Response Status
                                                <asp:DropDownList ID="ddlCancelReq" AutoPostBack="true" runat="server">
                                                    <asp:ListItem Text="All" Value="*"></asp:ListItem>
                                                    <asp:ListItem Text="New" Value="New"></asp:ListItem>
                                                    <asp:ListItem Text="Accepted" Value="Accepted"></asp:ListItem>
                                                    <asp:ListItem Text="Rejected" Value="Rejected"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td style="padding-left: 10px">Input Cancel Notice Status
                                                <asp:DropDownList ID="ddlCancelToRia" AutoPostBack="true" runat="server">
                                                    <asp:ListItem Text="All" Value="*"></asp:ListItem>
                                                    <asp:ListItem Text="Pending" Value="-1"></asp:ListItem>
                                                    <asp:ListItem Text="Canceled" Value="CANCELED"></asp:ListItem>

                                                </asp:DropDownList>
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
                <asp:GridView ID="gdvCancel" runat="server" AllowPaging="True" Visible="true" AllowSorting="True"
                    AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None"
                    PagerSettings-PageButtonCount="30" BorderWidth="1px" CellPadding="4" DataKeyNames="ID"
                    DataSourceID="SqlDataSource1" PageSize="20" ForeColor="Black" GridLines="Vertical"
                    CssClass="Grid" PagerSettings-Position="TopAndBottom">
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                    <Columns>
                        <asp:BoundField DataField="ExHouseCode" HeaderText="ExHouse Code" SortExpression="ExHouseCode" Visible="false" />
                        <%-- <asp:BoundField DataField="ID" HeaderText="RID" ReadOnly="True" SortExpression="ID" />--%>
                        <asp:TemplateField HeaderText="RID" ItemStyle-HorizontalAlign="Center" SortExpression="ID">
                            <ItemTemplate>
                                <b><a href='Remittance_Show.aspx?id=<%# Eval("ID") %>' title="View Remittance" target="_blank">
                                    <%# Eval("ID") %></a></b><a name='<%# Eval("ID","{0}") %>'></a>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="OrderNo" HeaderText="Order No" ReadOnly="True" SortExpression="OrderNo" />
                        <asp:BoundField DataField="CancelPendingStatus" HeaderText="Pending Status" SortExpression="CancelPendingStatus" ItemStyle-CssClass="center" />
                        <asp:BoundField DataField="InputOrderStatus" HeaderText="Input Order Status" SortExpression="InputOrderStatus" />

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
                         <asp:CheckBoxField HeaderText="Published" DataField="Published" SortExpression="Published" ItemStyle-HorizontalAlign="Center"
                            ReadOnly="true">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:CheckBoxField>
                         <asp:BoundField DataField="Status" HeaderText="Status" ReadOnly="true"
                            ItemStyle-HorizontalAlign="Center">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                    </Columns>
                    <FooterStyle BackColor="#CCCC99" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <AlternatingRowStyle BackColor="White" />
                </asp:GridView>
                <asp:Label ID="LabelCancel" runat="server" Text="" Font-Size="Small"></asp:Label>

                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                    SelectCommand="s_Ria_CancelOrderDownloadSelect" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected">
                          <SelectParameters>
                         <asp:ControlParameter ControlID="txtFilter" Name="Filter" PropertyName="Text"
                            Type="String" DefaultValue="*" />
                       <%-- <asp:ControlParameter ControlID="dboPublished" Name="Published" DbType="String" PropertyName="SelectedValue"
                            DefaultValue="" />--%>
                        <asp:ControlParameter ControlID="txtDateFrom" Name="FromDate" DefaultValue='01/01/1900'
                            PropertyName="Text" Type="DateTime" />
                        <asp:ControlParameter ControlID="txtDateTo" Name="ToDate" DefaultValue='01/01/1900'
                            PropertyName="Text" Type="DateTime" />
                      <%--  <asp:ControlParameter ControlID="txtUploadBy" Name="UploadBy" PropertyName="Text"
                            Type="String" DefaultValue="" ConvertEmptyStringToNull="false" />
                        <asp:ControlParameter ControlID="txtPublishedBy" Name="PublishBy" PropertyName="Text"
                            Type="String" DefaultValue="" ConvertEmptyStringToNull="false" />--%>
                        <asp:ControlParameter ControlID="ddlCancelReq" Name="CancelReq" PropertyName="SelectedValue"
                            Type="String" DefaultValue="*" ConvertEmptyStringToNull="false" />
                        <asp:ControlParameter ControlID="ddlCancelToRia" Name="CancelToRia" Type="String" PropertyName="SelectedValue"
                            DefaultValue="*" />
                    </SelectParameters>
               
                </asp:SqlDataSource>
                 <asp:Label ID="LabelCancelOrder" runat="server" Text="" Font-Size="Small"></asp:Label>
                <asp:Button ID="cmdDownload" runat="server" Text="Download as xlsx"
                    OnClick="cmdDownload_Click" Visible="false"/>
            </div>

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
        UseAnimation="false" VerticalSide="Middle"></asp:AlwaysVisibleControlExtender>
</asp:Content>
