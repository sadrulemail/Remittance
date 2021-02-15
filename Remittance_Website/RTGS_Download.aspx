<%@ Page Title="" Language="C#" AutoEventWireup="true"
    Inherits="RTGS_Download" MasterPageFile="~/MasterPage.master" CodeFile="RTGS_Download.aspx.cs" %>

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
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="SELECT beftn_code FROM [v_RTGS_Export_Log] WHERE ([BatchID] = @Batch)">
                <SelectParameters>
                    <asp:QueryStringParameter Name="Batch" QueryStringField="batch" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_RemiList_RTGS_Batch" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected">
                <SelectParameters>
                    <asp:QueryStringParameter Name="Batch" QueryStringField="batch" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" Visible="false" AllowSorting="True"
                AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None"
                PagerSettings-PageButtonCount="30" BorderWidth="1px" CellPadding="4" DataKeyNames="ID"
                DataSourceID="SqlDataSource1" PageSize="20" ForeColor="Black" GridLines="Vertical"
                CssClass="Grid" PagerSettings-Position="TopAndBottom">
                <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                <Columns>
                    <asp:TemplateField HeaderText="RID" SortExpression="ID">
                        <ItemTemplate>
                            <a href='Remittance_Show.aspx?id=<%# Eval("ID") %>' title="View Remittance" target="_blank">
                                <%# Eval("ID") %></a></ItemTemplate>
                        <ItemStyle Font-Bold="True" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="dbtrName" SortExpression="dbtrName">
                        <ItemTemplate>
                            <span title='<%# Eval("ExHouseCode") %>'>
                                <%# Eval("dbtrName")%></span></ItemTemplate>
                        <ItemStyle HorizontalAlign="Left" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="dbtrAccountno" HeaderText="dbtrAccountno" SortExpression="dbtrAccountno"
                        ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="Currency" HeaderText="Currency" SortExpression="Currency"
                        ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" ItemStyle-HorizontalAlign="Right"
                        ItemStyle-Font-Bold="true" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="dbtrCountry" HeaderText="dbtrCountry" SortExpression="dbtrCountry"
                        ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="cdtrAccountno" HeaderText="cdtrAccountno" SortExpression="cdtrAccountno"
                        ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="cdtrName" HeaderText="cdtrName" ReadOnly="True"
                        SortExpression="cdtrName" />
                    <asp:BoundField DataField="cdtrAddress" HeaderText="cdtrAddress" ReadOnly="True" SortExpression="cdtrAddress" />
                   <asp:BoundField DataField="cdtrCountry" HeaderText="cdtrCountry" SortExpression="cdtrCountry"
                        ItemStyle-HorizontalAlign="Center" />
                    <asp:TemplateField HeaderText="toRoutingno" SortExpression="RoutingNumber">
                        <ItemTemplate>
                            <uc3:BEFTN ID="BEFTN1" runat="server" Code='<%# Eval("RoutingNumber") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    
                    <asp:BoundField DataField="PaymentDescription" HeaderText="Payment Description" ReadOnly="True"
                        SortExpression="PaymentDescription" ItemStyle-HorizontalAlign="Center" />
                    <asp:TemplateField HeaderText="Paid" SortExpression="Paid">
                        <ItemTemplate>
                            <%# (Eval("Paid").ToString() == "True") ? "<img src='Images/tick.png' width='20px' height='20px'>" : ""%>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" />
                </Columns>
                <FooterStyle BackColor="#CCCC99" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                <AlternatingRowStyle BackColor="White" />
            </asp:GridView>
             <br />
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
                    
                    <asp:TemplateField HeaderText="Routing Number" SortExpression="RoutingNumber">
                        <ItemTemplate>
                            <uc3:BEFTN ID="BEFTN2" runat="server" Code='<%# Eval("RoutingNumber") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
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
                            <span class="time-small" title='<%# Eval("UnpaidOn","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                <time class="timeago" datetime='<%# Eval("UnpaidOn","{0:yyyy-MM-dd HH:mm:ss}") %>'></time></span>
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
                SelectCommand="sp_RTGS_History_Payment" SelectCommandType="StoredProcedure" 
                    onselected="SqlDataSourceCanceled_Selected">
                <SelectParameters>
                    <asp:QueryStringParameter Name="BatchNo" QueryStringField="batch" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
             <br />
                <asp:Label ID="lblStatusUnpaid" runat="server" Text=""></asp:Label>
                </div>
            </asp:Panel>
        </ContentTemplate>
        <Triggers>
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