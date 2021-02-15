<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" 
    AutoEventWireup="true" CodeFile="ID_Wise_Summary_Report.aspx.cs" 
    Inherits="ID_Wise_Summary_Report" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    ID wise Summary Report
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="s_id_wise_summary_Reporting" SelectCommandType="StoredProcedure"
                OnSelected="SqlDataSource1_Selected"
                >
                <SelectParameters>
                    <asp:ControlParameter ControlID="txtDateFrom" Name="Fdate" PropertyName="Text" Type="DateTime"
                        ConvertEmptyStringToNull="true" DefaultValue="1/1/1900" />
                    <asp:ControlParameter ControlID="txtDateTo" Name="Tdate" PropertyName="Text" Type="DateTime"
                        ConvertEmptyStringToNull="true" DefaultValue="1/1/1900" />
                    <asp:ControlParameter ControlID="txtID" Name="ID" PropertyName="Text" Type="String"
                        DefaultValue="*"  />
                    <asp:ControlParameter ControlID="cboIDType" Name="IdType" PropertyName="SelectedValue" 
                        Type="String" DefaultValue="*"  />
                    <asp:ControlParameter ControlID="cboCountry" Name="Country" PropertyName="SelectedValue" 
                        Type="String" DefaultValue="*"  />
                    <asp:ControlParameter ControlID="cboDistrict" Name="DIST_CODE" PropertyName="SelectedValue" 
                        Type="String" DefaultValue="*"  />
                    <asp:ControlParameter ControlID="txtMinAmount" Name="MinAmount" PropertyName="Text" Type="Int32"
                        DefaultValue="0"  />
                    <asp:ControlParameter ControlID="txtMinCount" Name="MinCount" PropertyName="Text" Type="Int32"
                        DefaultValue="0"  />
                </SelectParameters>
            </asp:SqlDataSource>
            <table>
                <tr>
                    <td class="SmallFont Panel1">
                        <table >
                            <tr>
                                <td style="padding-left: 10px">
                                    Paid Date:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtDateFrom" runat="server" CssClass="Watermark Date" Watermark="dd/mm/yyyy"
                                        AutoPostBack="true" MaxLength="10" Width="80px"></asp:TextBox>
                                </td>
                                <td>
                                    to
                                </td>
                                <td>
                                    <asp:TextBox ID="txtDateTo" runat="server" CssClass="Watermark Date" Watermark="dd/mm/yyyy"
                                        AutoPostBack="true" MaxLength="10" Width="80px"></asp:TextBox>
                                </td>
                                <td>
                                    ID Type:
                                </td>
                                <td>

                                    <asp:DropDownList ID="cboIDType" runat="server" AppendDataBoundItems="true" AutoPostBack="false" ValidationGroup="Return"
                                                        DataSourceID="SqlDataSourceIDType" DataTextField="IDType" DataValueField="IDType">
                                                            <asp:ListItem Value="*" Text="Any ID"></asp:ListItem>                                                            
                                                        </asp:DropDownList>  
                                    <asp:SqlDataSource ID="SqlDataSourceIDType" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                            SelectCommand="SELECT DISTINCT
       IDType
FROM dbo.RemiList WITH (NOLOCK)
WHERE LEN(IDType) > 0
ORDER BY IDType;
--SELECT [IDType] FROM [IDType] with (nolock) ORDER BY [OrderCol]">
                                                            <SelectParameters>
                                                                <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
                                                            </SelectParameters>
                                                        </asp:SqlDataSource>
                                </td>
                                <td>
                                    ID:
                                </td>
                                <td>
                                   <asp:TextBox ID="txtID" runat="server" placeholder="id number"
                                        AutoPostBack="true" MaxLength="30" Width="130px"></asp:TextBox>
                                </td>
                                <td >
                                    Total Amount:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtMinAmount" runat="server" placeholder="0.00" 
                                        AutoPostBack="true" MaxLength="20" Width="100px" Text="100000"></asp:TextBox>
                                </td>
                                <td>
                                    Count:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtMinCount" runat="server" placeholder="0" 
                                        AutoPostBack="true" MaxLength="10" Width="50px" Text="2"></asp:TextBox>
                                </td>
                                
                            </tr>
                        </table>
                       
                        <table >
                            <tr>
                                
                                <td style="padding-left: 10px">
                                    Ex-House Country:
                                </td>
                                <td>

                                    <asp:DropDownList ID="cboCountry" runat="server" AppendDataBoundItems="true" AutoPostBack="false" ValidationGroup="Return"
                                                        DataSourceID="SqlDataSource2" DataTextField="ExHouseCountry" DataValueField="ExHouseCountry">
                                                            <asp:ListItem Value="*" Text="All"></asp:ListItem>                                                            
                                                        </asp:DropDownList>  
                                    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                            SelectCommand="SELECT DISTINCT ExHouseCountry FROM dbo.ExHouses WITH (NOLOCK) ORDER BY ExHouseCountry">
                                                            
                                                        </asp:SqlDataSource>
                                </td>
                                <td>
                                    District:
                                </td>
                                <td>
                                   <asp:DropDownList ID="cboDistrict" runat="server" AppendDataBoundItems="true" AutoPostBack="false" ValidationGroup="Return"
                                                        DataSourceID="SqlDataSource3" DataTextField="RIT_Dist_Name" DataValueField="DIST_CODE">
                                                            <asp:ListItem Value="*" Text="All"></asp:ListItem>                                                            
                                                        </asp:DropDownList>  
                                    <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                                            SelectCommand="SELECT DIST_CODE,
       RIT_Dist_Name
FROM TblUserDB.dbo.BD_District
--WHERE DIST_CODE <> 100
ORDER BY RIT_Dist_Name;">
                                                            
                                                        </asp:SqlDataSource>
                                </td>
                                <td style="padding-left: 2px">
                                    <asp:Button ID="cmdFilter" runat="server" Text="Show" OnClick="cmdFilter_Click" />
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
            <asp:GridView ID="GridView1" runat="server" BackColor="White" AllowPaging="true"
                PageSize="15" CssClass="Grid" AllowSorting="true" BorderColor="#DEDFDE" BorderStyle="None"
                BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Both" AutoGenerateColumns="False"
                PagerSettings-PageButtonCount="20" DataSourceID="SqlDataSource1" Style="font-size: small;
                font-family: Arial" OnDataBound="GridView1_DataBound">
                <RowStyle BackColor="#F7F7DE" CssClass="Grid" VerticalAlign="Top" />
                <Columns>
                    
                    
                    <asp:TemplateField HeaderText="Id Number" SortExpression="IDNumber">
                        <ItemTemplate>
                            <a href='Remittance_IDNum.aspx?idnum=<%# Eval("IDNumber") %>' target="_blank"><%# Eval("IDNumber") %></a>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="IdType" HeaderText="Id Type" SortExpression="IdType" />
                    <asp:BoundField DataField="ExHouseCountry" HeaderText="Ex-House Country" SortExpression="ExHouseCountry" />

                    <asp:BoundField DataField="RIT_Dist_Name" HeaderText="District" SortExpression="RIT_Dist_Name" />
                    
                    
                    
                    <asp:TemplateField HeaderText="Amount" ItemStyle-HorizontalAlign="Right" SortExpression="Amount">
                            <ItemTemplate>
                                <%# string.Format(TrustControl1.Bangla, "{0:N0}", Eval("Amount"))%>
                            </ItemTemplate>
                        </asp:TemplateField>
                    <asp:BoundField DataField="Total" HeaderText="Total" SortExpression="Total" ItemStyle-HorizontalAlign="Center"
                        DataFormatString="{0:N0}" />
                </Columns>
                <FooterStyle BackColor="#CCCC99" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                <PagerSettings Position="TopAndBottom" Mode="NumericFirstLast" />
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="false" ForeColor="White" Font-Names="Arial Narrow" />
                <AlternatingRowStyle BackColor="White" />
                <EmptyDataTemplate>
                    <div style="border: solid 1px silver; padding: 10px; background-color: #F6F6F6; width: 500px">
                        No Data Found.</div>
                </EmptyDataTemplate>
                <EditRowStyle BackColor="#C5E2FD" />
            </asp:GridView>
            <asp:HiddenField ID="hidRoutingMsg" runat="server" Value="" />
            <br />
            <asp:Label ID="lblStatus" runat="server" Text="" Style="font-size: small"></asp:Label><br />
            <br />
            <asp:Button ID="btn_xlsx" runat="server" Text="Download as xlsx" OnClick="btn_xlsx_Click" />
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btn_xlsx" />
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
