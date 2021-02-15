<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="Remittance.Comments_Browse" CodeFile="Comments_Browse.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Browse Comments
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Timer ID="Timer1" runat="server" OnTick="Timer1_Tick" Interval="180000">
            </asp:Timer>
            <table >
                <tr>
                    <td>
                        <table class="SmallFont ui-corner-all Panel1">
                            <tr>
                                <td style="padding-left: 2px">
                                    <asp:TextBox ID="txtFilter" runat="server" Width="203px" onfocus="this.select()"
                                        AutoPostBack="True" CssClass="Watermark" Watermark="enter text to filter" OnTextChanged="txtFilter_TextChanged"></asp:TextBox>
                                </td>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    Posted From:
                                </td>
                                <td>
                                    <asp:DropDownList ID="cboBranch" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                        DataSourceID="SqlDataSourceBranch" DataTextField="BranchName" DataValueField="BranchID">
                                        <asp:ListItem Value="" Text="Any Branch"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Head Office"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="SELECT [BranchID], [BranchName] FROM [V_BranchOnly] ORDER by BranchName">
                                    </asp:SqlDataSource>
                                </td>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    Paid:
                                </td>
                                <td>
                                    <asp:DropDownList ID="cboPaid" runat="server" AppendDataBoundItems="true" AutoPostBack="true">
                                        <asp:ListItem Value="-1" Text="Show All"></asp:ListItem>
                                        <asp:ListItem Value="0" Text="Unpaid"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Paid"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    <asp:Button ID="cmdFilter" runat="server" Font-Bold="true" Text="Filter" Width="90px"
                                        OnClick="cmdFilter_Click" />
                                </td>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    Ex-House:
                                </td>
                                <td>
                                    <asp:DropDownList ID="cboExHouse" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                        DataSourceID="SqlDataSource2" DataTextField="ExHouseName" DataValueField="ExHouseCode">
                                        <asp:ListItem Value="" Text="All"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="SELECT [ExHouseCode],ExHouseCode+', '+[ExHouseName] as ExHouseName FROM [v_ExHouseListDetails] ORDER BY ExHouseName">
                                    </asp:SqlDataSource>
                                </td>
                                <td style="padding-left: 10px; white-space: nowrap; text-align: right">
                                    Staus:
                                </td>
                                <td>
                                    <asp:DropDownList ID="cboCommentStatus" runat="server" AppendDataBoundItems="true"
                                        AutoPostBack="true" DataSourceID="SqlDataSourceCommentStatus" DataTextField="CommentStatus"
                                        DataValueField="ID" ondatabound="cboCommentStatus_DataBound">
                                        
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourceCommentStatus" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                                        SelectCommand="SELECT * FROM [v_CommentStatus]"></asp:SqlDataSource>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <br />
            <asp:GridView ID="GridView1" runat="server" BackColor="White" AllowPaging="True" PageSize="15"
                CssClass="Grid" AllowSorting="True" BorderColor="#DEDFDE" BorderStyle="None"
                BorderWidth="1px" CellPadding="4" ForeColor="Black" AutoGenerateColumns="False"
                 PagerSettings-PageButtonCount="30" DataSourceID="SqlDataSource1"
                Style="font-size: small; font-family: Arial" DataKeyNames="CID" OnRowCommand="GridView1_RowCommand">
                <RowStyle BackColor="#F7F7DE" CssClass="Grid" VerticalAlign="Top" />
                <Columns>
                    <asp:BoundField DataField="CID" HeaderText="CID" SortExpression="CID" ItemStyle-HorizontalAlign="Center"
                        ReadOnly="true" InsertVisible="False"></asp:BoundField>
                    <asp:TemplateField HeaderText="RID" SortExpression="RID">
                        <ItemTemplate>
                            <a href='Remittance_Show.aspx?id=<%# Eval("RID") %>' title="View Remittance" target="_blank">
                                <%# Eval("RID") %></a></ItemTemplate>
                        <ItemStyle Font-Bold="True" Font-Size="Medium" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="Comment" HeaderText="Comment" SortExpression="Comment" ItemStyle-Font-Bold="true" />
                    <asp:TemplateField HeaderText="Posted On" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <div title='<%# Eval("DT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                <%# TrustControl1.ToRecentDateTime(Eval("DT")) %><br />
                                <time class="timeago" datetime='<%# Eval("DT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Posted By" SortExpression="PostedBy" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <uc2:EMP ID="EMP1" Username='<%# Eval("PostedBy") %>' Position="" runat="server" />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Posted From" SortExpression="Branch">
                        <ItemTemplate>
                            <span title='<%# Eval("Branch") %>'>
                                <%# Eval("BranchName") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:N2}"
                        SortExpression="Amount" ItemStyle-HorizontalAlign="Right"></asp:BoundField>
                    <asp:TemplateField HeaderText="Paid" SortExpression="Paid">
                        <ItemTemplate>
                            <%# (Eval("Paid").ToString() == "True") ? "<img src='Images/tick.png' width='20px' height='20px'>" : ""%>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Paid On" SortExpression="PaidOn">
                        <ItemTemplate>
                        <div title='<%# Eval("PaidOn","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                        <%# TrustControl1.ToRecentDateTime(Eval("PaidOn"))%><br />
                            <time class="timeago" datetime='<%# Eval("PaidOn","{0:yyyy-MM-dd HH:mm:ss}") %>'></time></div>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Paid By" SortExpression="Paid By" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <uc2:EMP ID="EMP2" Username='<%# Eval("PaidBy") %>' Position="Left" runat="server" />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="ExHouseCode" HeaderText="ExHouse" SortExpression="ExHouseCode"
                        ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="CommentStatus" HeaderText="Status" SortExpression="CommentStatus"
                        ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Center" ItemStyle-Font-Bold="true" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton CausesValidation="false" CommandArgument='<%# Eval("RID") %>' Visible='<%# (Eval("CommentStatus").ToString() == "Pending") ? true : false %>' 
                                CommandName="Completed" runat="server" ToolTip="Mark as Completed" >
                                <div class="Button">OK</div>
                                </asp:LinkButton>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" Font-Bold="true" />
                    </asp:TemplateField>
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
            <asp:Label ID="lblStatus" runat="server" Text=""></asp:Label>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_RemiList_Comments_Browse" SelectCommandType="StoredProcedure"
                OnSelected="SqlDataSource1_Selected">
                <SelectParameters>
                    <asp:ControlParameter ControlID="txtFilter" Name="Filter" PropertyName="Text" DefaultValue=" "
                        Type="String" Size="255" />
                    <asp:ControlParameter ControlID="cboBranch" Name="BranchID" PropertyName="SelectedValue"
                        DefaultValue="-1" Type="Int32" />
                    <asp:ControlParameter ControlID="cboPaid" Name="Paid" PropertyName="SelectedValue"
                        DefaultValue="-1" Type="Int32" />
                    <asp:ControlParameter ControlID="cboExHouse" Name="ExHouse" PropertyName="SelectedValue"
                        DefaultValue=" " Type="String" />
                    <asp:ControlParameter ControlID="cboCommentStatus" Name="CommentStatus" PropertyName="SelectedValue"
                        DefaultValue="0" Type="String" />
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
