<%@ Page Title="" Language="C#" AutoEventWireup="true"
    Inherits="Remittance.MM_Download" MasterPageFile="~/MasterPage.master" CodeFile="MM_Download.aspx.cs" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text=""></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:GridView ID="GridView1" runat="server" CssClass="Grid" AllowSorting="True" AutoGenerateColumns="False"
                BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                CellPadding="4" DataKeyNames="ID" DataSourceID="SqlDataSource1" ForeColor="Black"
                GridLines="Vertical">
                <RowStyle BackColor="#F7F7DE" />
                <Columns>
                    <asp:TemplateField HeaderText="RID" SortExpression="ID">
                        <ItemTemplate>
                            <a href='<%# Eval("ID","Remittance_Show.aspx?id={0}") %>' target="_blank">
                                <%# Eval("ID") %></a>
                        </ItemTemplate>
                        <ItemStyle Font-Bold="true" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="ExHouseCode" HeaderText="ExHouse Code" SortExpression="ExHouseCode" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="BeneficiaryName" HeaderText="Beneficiary Name" SortExpression="BeneficiaryName" />
                    <asp:BoundField DataField="Account" HeaderText="Account" SortExpression="Account" />
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                        ItemStyle-HorizontalAlign="Right" ItemStyle-Font-Bold="true" />
                    <asp:BoundField DataField="Currency" HeaderText="Currency" SortExpression="Currency"
                        ItemStyle-HorizontalAlign="Center" />
                </Columns>
                <FooterStyle BackColor="#CCCC99" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                <AlternatingRowStyle BackColor="White" />
            </asp:GridView>
            <asp:Label ID="lblStatus" runat="server" Text="" Font-Size="Small"></asp:Label>
            <br />
            <br />
            <asp:Panel runat="server" ID="PanelUnpaid" CssClass="group">
            <h2>Unpaid Mark History</h2>
            <div>
            <asp:GridView ID="GridView2" runat="server" AllowPaging="True" AllowSorting="True"
                AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None"
                BorderWidth="1px" CellPadding="4" DataKeyNames="ID" DataSourceID="SqlDataSourceCanceled"
                PagerSettings-PageButtonCount="30" PageSize="20" PagerSettings-Position="TopAndBottom"
                ForeColor="Black" CssClass="Grid" GridLines="Vertical">
                <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                <Columns>
                    <asp:TemplateField HeaderText="RID" SortExpression="ID">
                        <ItemTemplate>
                            <a href='Remittance_Show.aspx?id=<%# Eval("RID") %>' title='<%# Eval("ID") %>' target="_blank">
                                <%# Eval("RID") %></a></ItemTemplate>
                        <ItemStyle Font-Bold="True" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" ItemStyle-HorizontalAlign="Right"
                        DataFormatString="{0:N2}" ItemStyle-Font-Bold="true" />
                    <asp:BoundField DataField="Currency" HeaderText="Currency" SortExpression="Currency" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="BeneficiaryName" HeaderText="BeneficiaryName" SortExpression="BeneficiaryName" />
                    <asp:BoundField DataField="Account" HeaderText="Account" SortExpression="Account" />
                    
                    
                    
                   
                    <asp:TemplateField HeaderText="Unpaid By" SortExpression="UnpaidBy">
                        <ItemTemplate>
                            <uc2:EMP ID="EMP2" runat="server" Username='<%# Eval("UnpaidBy") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Unpaid On" SortExpression="UnpaidOn">
                        <ItemTemplate>
                            <span title='<%# Eval("UnpaidOn","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                <%# TrustControl1.ToRecentDateTime(Eval("UnpaidOn"))%></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="About" SortExpression="UnpaidOn">
                        <ItemTemplate>
                            <span title='<%# Eval("UnpaidOn","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                <%# TrustControl1.ToRelativeDate(Eval("UnpaidOn"))%></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="UnpaidReason" HeaderText="Unpaid Reason" SortExpression="UnpaidReason" ItemStyle-Font-Bold="true" />
                    
                </Columns>
                <FooterStyle BackColor="#CCCC99" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle"/>
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                <AlternatingRowStyle BackColor="White" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSourceCanceled" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_MM_History_Payment" SelectCommandType="StoredProcedure" 
                    onselected="SqlDataSourceCanceled_Selected">
                <SelectParameters>
                    <asp:QueryStringParameter Name="BatchNo" QueryStringField="batch" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            
                <asp:Label ID="lblStatusUnpaid" runat="server" Text=""></asp:Label>
                </div>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
        SelectCommand="SELECT * FROM [MM_Export_Log] with (nolock) WHERE ([BatchID] = @Batch)">
        <SelectParameters>
            <asp:QueryStringParameter Name="Batch" QueryStringField="batch" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
        SelectCommand="sp_RemiList_MM_Batch" 
        SelectCommandType="StoredProcedure" onselected="SqlDataSource1_Selected">
        <SelectParameters>
            <asp:QueryStringParameter Name="Batch" QueryStringField="batch" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
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
