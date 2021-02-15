<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="Remittance.Upload_Summary" CodeFile="Upload_Summary.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Upload Data Log Summary
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <table class="ui-corner-all Panel1">
                            <tr>
                                <td>
                                    <table>
                                        <tr>
                                            <td>Upload from
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
                                            <td>Ex-House:
                                                <asp:DropDownList ID="cboExHouse" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                                    DataSourceID="SqlDataSource2" DataTextField="ExHouseName" DataValueField="ExHouseCode">
                                                    <asp:ListItem Value="-1" Text="All"></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                    SelectCommand="SELECT [ExHouseCode],ExHouseCode+', '+[ExHouseName] as ExHouseName FROM [v_ExHouseListDetails] ORDER BY ExHouseName"></asp:SqlDataSource>
                                            </td>
                                        </tr>
                                    </table>
                                    <table>
                                        <tr>
                                            <td>Published:
                                                <asp:DropDownList ID="dboPublished" AutoPostBack="true" runat="server">
                                                    <asp:ListItem Text="All" Value="-1"></asp:ListItem>
                                                    <asp:ListItem Text="Published" Value="1"></asp:ListItem>
                                                    <asp:ListItem Text="Not Published" Value="0"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>Paid:
                                                <asp:DropDownList ID="cboPaid" runat="server" AutoPostBack="true">
                                                    <asp:ListItem Value="-1" Text="Show All"></asp:ListItem>
                                                    <asp:ListItem Value="0" Text="Unpaid"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Paid"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>Status:
                                                <asp:DropDownList ID="cboStatus" runat="server" AutoPostBack="true">
                                                    <asp:ListItem Value="*" Text="ALL"></asp:ListItem>
                                                    <asp:ListItem Value="ACTIVE" Text="ACTIVE"></asp:ListItem>
                                                    <asp:ListItem Value="ON HOLD" Text="ON HOLD"></asp:ListItem>
                                                    <asp:ListItem Value="CANCEL" Text="CANCEL"></asp:ListItem>
                                                    <asp:ListItem Value="RETURN" Text="RETURN"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>Method:
                                                <asp:DropDownList ID="cboPaymentMethod" AutoPostBack="True" runat="server" AppendDataBoundItems="true"
                                                    DataSourceID="SqlDataSourcePaymentMethod" DataTextField="PaymentMethod" DataValueField="PaymentMethod">
                                                    <asp:ListItem Text="ALL" Value="-1"></asp:ListItem>
                                                    <asp:ListItem Text="" Value="-2"></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDataSourcePaymentMethod" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                    SelectCommand="SELECT * FROM [v_PaymentMethods] ORDER BY OrderCol"></asp:SqlDataSource>
                                            </td>
                                            <td>Type:
                                                 <asp:DropDownList ID="cboExHouseType" runat="server" AutoPostBack="true">
                                                     <asp:ListItem Value="*" Text="ALL"></asp:ListItem>
                                                     <asp:ListItem Value="R" Text="Remittance"></asp:ListItem>
                                                     <asp:ListItem Value="W" Text="Web"></asp:ListItem>
                                                 </asp:DropDownList>
                                            </td>
                                            <td style="padding: 0px 10px 0px 10px">
                                                <asp:Button ID="cmdFilter" runat="server" Text="Show" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="padding-left: 10px">
                        <asp:LinkButton ID="cmdPreviousDay" runat="server" OnClick="cmdPreviousDay_Click" CssClass="button1"><img src="Images/Previous.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                        <asp:LinkButton ID="cmdNextDay" runat="server" OnClick="cmdNextDay_Click" CssClass="button1"><img src="Images/Next.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                    </td>
                </tr>
            </table>
            <div style="margin: 0px 0px 50px 10px">
                <table class="Panel1">
                    <tr>
                        <td>Currency:</td>
                        <td>
                            <asp:RadioButtonList ID="radioCurrency" runat="server" AutoPostBack="true"
                                DataSourceID="SqlDataSourceCurrecny" DataTextField="Currency"
                                DataValueField="Currency" RepeatDirection="Horizontal"
                                OnDataBound="radioCurrency_DataBound">
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                </table>
                <asp:SqlDataSource ID="SqlDataSourceCurrecny" runat="server"
                    ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                    SelectCommand="SELECT * FROM [v_Currency]"></asp:SqlDataSource>
                <br />
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" Font-Size="Small"
                    DataSourceID="SqlDataSource1" CssClass="Grid" AllowSorting="True" BackColor="White"
                    BorderColor="#DEDFDE" BorderStyle="Solid" PagerSettings-Position="TopAndBottom"
                    PageSize="30" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="30"
                    Width="600px" BorderWidth="1px" CellPadding="4" ForeColor="Black" OnDataBound="GridView1_DataBound"
                    OnRowDataBound="GridView1_RowDataBound" ShowFooter="True">
                    <PagerSettings Mode="NumericFirstLast" PageButtonCount="30" Position="TopAndBottom" />
                    <RowStyle BackColor="#F7F7DE" HorizontalAlign="Center" />
                    <Columns>
                        <asp:BoundField DataField="ExHouseCode" HeaderText="ExHouseCode" SortExpression="ExHouseCode"
                            ItemStyle-HorizontalAlign="Left">
                            <ItemStyle HorizontalAlign="Left" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Total" HeaderText="Total" SortExpression="Total" ReadOnly="True" />
                        <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" ReadOnly="True"
                            ItemStyle-HorizontalAlign="Right" DataFormatString="{0:N2}">
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Currency" HeaderText="Currency" SortExpression="Currency" />
                    </Columns>
                    <FooterStyle BackColor="#CCCC99" Font-Bold="true" />
                    <PagerStyle HorizontalAlign="Left" CssClass="PagerStyle" />
                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <AlternatingRowStyle BackColor="White" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                    SelectCommand="sp_DataUploadLog_Summary" SelectCommandType="StoredProcedure"
                    OnSelected="SqlDataSource1_Selected">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="cboExHouse" Name="ExHouse" Type="String" PropertyName="SelectedValue"
                            DefaultValue="" />
                        <asp:ControlParameter ControlID="cboPaid" Name="Paid" Type="String" PropertyName="SelectedValue"
                            DefaultValue="" />
                        <asp:ControlParameter ControlID="cboPaymentMethod" Name="PaymentMethod" Type="String"
                            PropertyName="SelectedValue" DefaultValue="" />
                        <asp:ControlParameter ControlID="cboStatus" Name="Status" Type="String" PropertyName="SelectedValue"
                            DefaultValue="" Size="10" />
                        <asp:ControlParameter ControlID="dboPublished" Name="Published" Type="String" PropertyName="SelectedValue"
                            DefaultValue="" Size="2" />
                        <asp:ControlParameter ControlID="txtDateFrom" Name="DateFrom" DefaultValue='01/01/1900'
                            PropertyName="Text" Type="DateTime" />
                        <asp:ControlParameter ControlID="txtDateTo" Name="DateTo" DefaultValue='01/01/1900'
                            PropertyName="Text" Type="DateTime" />
                        <asp:ControlParameter ControlID="radioCurrency" Name="Currency" Type="String" PropertyName="SelectedValue"
                            DefaultValue="" />
                        <asp:ControlParameter ControlID="cboExHouseType" Name="ExHouseType" Type="String" PropertyName="SelectedValue"
                            DefaultValue="*" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <br />
                <asp:Label ID="lblStatus" runat="server" Text="" Font-Size="Small"></asp:Label>
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
