<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    Inherits="Remittance.SummaryHO_View" CodeFile="SummaryHO_View.aspx.cs" EnableViewState="false" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        .WaterMark
        {
            color: Silver;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Remittance Payment Details Report for Head Office
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:GridView ID="GridView2" runat="server" BackColor="White" AllowPaging="false" DataKeyNames="Batch"
                ShowFooter="true" PageSize="15" CssClass="Grid" AllowSorting="true" BorderColor="#DEDFDE"
                BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Both"
                AutoGenerateColumns="False" PagerSettings-PageButtonCount="30" DataSourceID="SqlDataSource2"
                Style="font-size: small; font-family: Arial" 
                ondatabound="GridView2_DataBound">
                <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                <Columns>
                    <asp:TemplateField HeaderText="Batch" SortExpression="Batch">
                        <ItemTemplate>
                            <a href='ShowBatch.aspx?batch=<%# Eval("Batch") %>' target="_blank">
                                <%# Eval("Batch") %></a>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                        ReadOnly="true" ItemStyle-HorizontalAlign="Right">
                        <ItemStyle HorizontalAlign="Right" Font-Bold="true" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Currency" HeaderText="Currency" ReadOnly="true" ItemStyle-HorizontalAlign="Center">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Total" HeaderText="Total" SortExpression="Total" DataFormatString="{0:N0}"
                        ItemStyle-HorizontalAlign="Center">
                    </asp:BoundField>
                    <asp:CommandField ShowSelectButton="true" />
                    
                </Columns>
                <FooterStyle BackColor="#CCCC99" HorizontalAlign="Right" Font-Bold="true" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                <PagerSettings Position="TopAndBottom" Mode="NumericFirstLast" />
                <SelectedRowStyle BackColor="#FFA200" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="false" ForeColor="White" Font-Names="Arial Narrow" />
                <AlternatingRowStyle BackColor="White" />
                <EmptyDataTemplate>
                    <div style="border: solid 1px silver; padding: 10px; background-color: #F6F6F6; width: 500px">
                        No Data Found.</div>
                </EmptyDataTemplate>
                <EditRowStyle BackColor="#C5E2FD" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_RemiList_Summary_HO_View_Summary" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="PaidBranch" QueryStringField="PaidBranch" Type="Int32" />
                    <asp:QueryStringParameter Name="Currency" QueryStringField="Currency" Type="String" />
                    <asp:QueryStringParameter Name="PaymentMethod" QueryStringField="PaymentMethod" Type="String" />
                    <asp:QueryStringParameter Name="ExHouseCode" QueryStringField="ExHouseCode" Type="String" />
                    <asp:QueryStringParameter Name="Status" QueryStringField="Status" Type="String" />
                    <asp:QueryStringParameter Name="SDate" QueryStringField="SDate" Type="DateTime" />
                    <asp:QueryStringParameter Name="EDate" QueryStringField="EDate" Type="DateTime" />
                </SelectParameters>
            </asp:SqlDataSource>
            <br />
            <asp:GridView ID="GridView1" runat="server" BackColor="White" AllowPaging="true"
                PageSize="15" CssClass="Grid" AllowSorting="true" BorderColor="#DEDFDE" BorderStyle="None"
                BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Both" AutoGenerateColumns="False"
                PagerSettings-PageButtonCount="30" DataSourceID="SqlDataSource1" Style="font-size: small;
                font-family: Arial">
                <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                <Columns>
                    <asp:TemplateField HeaderText="RID" SortExpression="ID">
                        <ItemTemplate>
                            <a href='Remittance_Show.aspx?id=<%# Eval("ID") %>' title="View Remittance" target="_blank">
                                <%# Eval("ID") %></a></ItemTemplate>
                        <EditItemTemplate>
                            <asp:HyperLink runat="server" ID="cmdID" Text='<%# Bind("ID") %>' Target="_blank"
                                NavigateUrl='<%# "Remittance_Show.aspx?id=" + Eval("ID") %>'></asp:HyperLink></EditItemTemplate>
                        <ItemStyle Font-Bold="True" Font-Size="Medium" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                        ReadOnly="true" ItemStyle-HorizontalAlign="Right">
                        <ItemStyle HorizontalAlign="Right" Font-Bold="true" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Currency" HeaderText="Currency" ReadOnly="true" ItemStyle-HorizontalAlign="Center">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Batch" SortExpression="Batch">
                        <ItemTemplate>
                            <a href='ShowBatch.aspx?batch=<%# Eval("Batch") %>' target="_blank">
                                <%# Eval("Batch") %></a>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Paid" SortExpression="Paid">
                        <ItemTemplate>
                            <%# (Eval("Paid").ToString() == "True") ? "<img src='Images/tick.png' width='20px' height='20px'>" : ""%>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Paid On" SortExpression="PaidOn" ItemStyle-Wrap="false"
                        ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <span title='<%# Eval("PaidOn", "{0:dddd, dd MMMM yyyy, hh:mm:ss tt}")%>'>
                                <%# TrustControl1.ToRecentDateTime(Eval("PaidOn")) %></span>
                            <br />
                            <span class="time-small" title='<%# Eval("PaidOn", "{0:dddd, dd MMMM yyyy, hh:mm:ss tt}")%>'>
                                <%# TrustControl1.ToRelativeDate(Eval("PaidOn")) %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="PaidBy" SortExpression="Paid By" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <uc2:EMP ID="EMP1" Username='<%# Eval("PaidBy") %>' runat="server" />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Paid Branch" SortExpression="PaidBranch" ItemStyle-Font-Bold="true">
                        <ItemTemplate>
                            <span title='<%# Eval("PaidBranch")%>'>
                                <%# Eval("PaidBranchName")%></span></ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" SortExpression="PaymentMethod"
                        ReadOnly="true" ItemStyle-HorizontalAlign="Center" />
                    <asp:TemplateField HeaderText="ExHouse Code" SortExpression="ExHouseCode">
                        <ItemTemplate>
                            <span title='<%# Eval("ExHouseName") %>'>
                                <%# Eval("ExHouseCode") %></span>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="ToBranchName" SortExpression="ToBranchName">
                        <ItemTemplate>
                            <span title='<%# Eval("ToBranch") %>'>
                                <%# Eval("ToBranchName") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Routing Number" SortExpression="RoutingNumber">
                        <ItemTemplate>
                            <uc3:BEFTN ID="BEFTN1" runat="server" Code='<%# Eval("RoutingNumber") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Status" SortExpression="Status" ItemStyle-Wrap="false"
                        Visible="false">
                        <ItemTemplate>
                            <%# Eval("Status") %></ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="RemitterName" HeaderText="Remitter Name" SortExpression="RemitterName"
                        ReadOnly="true" />
                    <asp:BoundField DataField="BeneficiaryName" HeaderText="Beneficiary Name" SortExpression="BeneficiaryName"
                        ReadOnly="true" />
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
            <br />
            <asp:Label ID="lblStatus" runat="server" Text="" Style="font-size: small"></asp:Label>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                OnSelected="SqlDataSource1_Selected" SelectCommand="sp_RemiList_Summary_HO_View"
                SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="PaidBranch" QueryStringField="PaidBranch" Type="Int32" />
                    <asp:QueryStringParameter Name="Currency" QueryStringField="Currency" Type="String" />
                    <asp:QueryStringParameter Name="PaymentMethod" QueryStringField="PaymentMethod" Type="String" />
                    <asp:QueryStringParameter Name="ExHouseCode" QueryStringField="ExHouseCode" Type="String" />
                    <asp:QueryStringParameter Name="Status" QueryStringField="Status" Type="String" />
                    <asp:QueryStringParameter Name="SDate" QueryStringField="SDate" Type="DateTime" />
                    <asp:QueryStringParameter Name="EDate" QueryStringField="EDate" Type="DateTime" />
                    <asp:ControlParameter ControlID="GridView2" DefaultValue="0" Name="Batch" 
                        PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
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
