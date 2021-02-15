<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ShowBatchHistory.aspx.cs" Inherits="ShowBatchHistory" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="BEFTN.ascx" TagName="BEFTN" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .style1
        {
            height: 20px;
        }
        .upload {
        background-color:#EEE;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text=""></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <table class="SmallFont ui-corner-all Panel1">
                            <tr>
                                <td style="padding-left: 5px">
                                    Batch No:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtBatch" runat="server" onfocus="this.select()" Width="80px" Style="text-align: center"></asp:TextBox>
                                </td>
                                <td style="padding: 0px 5px 0px 5px">
                                    <asp:Button ID="cmdShow" runat="server" Text="Show" OnClick="cmdShow_Click" />
                                </td>
                        </table>
                    </td>
                    <td style="padding-left:10px">

                        
                        
                        <asp:Literal runat="server" ID="litBatchHistory"></asp:Literal>
                    </td>
                </tr>
            </table>
            <asp:HiddenField runat="server" ID="hidExHouseType" />
            <br />
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
                AllowSorting="True" AllowPaging="true" BorderColor="#DEDFDE" BorderStyle="Solid"
                BorderWidth="1px" CellPadding="2" CssClass="Grid" DataKeyNames="ID" DataSourceID="SqlDataSource1"
                PagerSettings-Position="TopAndBottom" Style="font-size: small" ForeColor="Black"
                PagerSettings-PageButtonCount="30" 
                >
                <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                <Columns>
                    <asp:TemplateField HeaderText="#" SortExpression="#" ItemStyle-CssClass="SLCOL">
                        <ItemTemplate>
                            <%# Eval("#","{0}") %><br />
                            <asp:Label ID="lblSL" runat="server" Text="&raquo;" Visible="false"></asp:Label>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="RID" ItemStyle-HorizontalAlign="Center" SortExpression="ID">
                        <ItemTemplate>
                            <b><a href='Remittance_Show.aspx?id=<%# Eval("ID") %>' title="View Remittance" target="_blank">
                                <%# Eval("ID") %></a></b><a name='<%# Eval("ID","{0}") %>'></a>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="ExHouseCode" HeaderText="Ex-House" SortExpression="ExHouseCode"
                        ItemStyle-Wrap="false" ReadOnly="true">
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                        ItemStyle-HorizontalAlign="Right" ReadOnly="true">
                        <ItemStyle HorizontalAlign="Right" Font-Bold="true" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Currency" HeaderText="Curr" ReadOnly="true" 
                        ItemStyle-HorizontalAlign="Center" >
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Paid" SortExpression="Paid">
                        <ItemTemplate>
                            <%# (Eval("Paid").ToString() == "True" ? "<img src='Images/tick.png' width='16' height='16' />" : "") %></ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                   
                   
                    <asp:TemplateField HeaderText="Status" SortExpression="Status" ItemStyle-Wrap="false">
                        
                       
                        <ItemStyle Wrap="False" HorizontalAlign="Center" />
                        <ItemTemplate>
                            <%# Eval("Status","<b>{0}</b>") %>
                            
                        </ItemTemplate>
                    </asp:TemplateField>
					
					<asp:TemplateField HeaderText="Pub" SortExpression="Published">
                        <ItemTemplate>
                            <%# (Eval("Published").ToString() == "True" ? "<img src='Images/tick.png' width='16' height='16' />" : "") %></ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
					
                    <asp:TemplateField HeaderText="Payment Method" SortExpression="PaymentMethod">
                        
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("PaymentMethod") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>


                    <asp:TemplateField HeaderText="Upload Beneficiary Name" SortExpression="Upload_BeneficiaryName">
                        <ItemTemplate>
                            <%# Eval("Upload_BeneficiaryName")%>
                        </ItemTemplate>  
                        <ItemStyle CssClass="upload" />                      
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Beneficiary Name" SortExpression="BeneficiaryName">
                        <ItemTemplate>
                            <%# Eval("BeneficiaryName")%>
                        </ItemTemplate>                        
                    </asp:TemplateField>

                    
                    <asp:TemplateField HeaderText="Upload Beneficiary Account" SortExpression="Upload_Account">
                        <ItemTemplate>
                            <%# Eval("Upload_Account")%>
                        </ItemTemplate>  
                        <ItemStyle CssClass="upload" />                      
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Beneficiary Account" SortExpression="Account">
                        <ItemTemplate>
                            <%# Eval("Account")%>
                        </ItemTemplate>
                        <ItemStyle Wrap="false" />
                        
                    </asp:TemplateField>
                   
                   <asp:BoundField DataField="Upload_BankName" HeaderText="Upload Bank" SortExpression="Upload_BankName"
                        ReadOnly="true" HtmlEncode="false" ItemStyle-CssClass="upload" />
                   
                 
                    <asp:BoundField DataField="BankName" HeaderText="Bank" SortExpression="BankName"
                        ReadOnly="true" HtmlEncode="false" />

                     <asp:BoundField DataField="Upload_BranchName" HeaderText="Upload Branch Name" SortExpression="Upload_BranchName"
                        ReadOnly="true" HtmlEncode="false" ItemStyle-CssClass="upload" />
                    <asp:BoundField DataField="BranchName" HeaderText="Branch" SortExpression="BranchName"
                        ReadOnly="true" HtmlEncode="false" />
                    
                   
                   
                    
                    <asp:CommandField Visible="false" ShowSelectButton="True" ButtonType="Link" />
                    <asp:TemplateField Visible="false">
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" CommandName="SELECT" CommandArgument='<%# Eval("ID") %>'
                                Height="20px" ToolTip="Open" CausesValidation="false">
                                <img alt="" height="16px" width="16px" src='Images/new_window.png' border="0" />
                            </asp:LinkButton>
                        </ItemTemplate>
                        <HeaderStyle Font-Bold="True" />
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    
					<asp:TemplateField HeaderText="Data Changed" SortExpression="DataChanged">
                        <ItemTemplate>
                            <%# (Eval("DataChanged").ToString() == "True" ? "<img src='Images/pencil.png' width='20px' height='20px' />" : "") %></ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                </Columns>
                <FooterStyle BackColor="#CCCC99" Font-Bold="true" />
                <PagerSettings PageButtonCount="30" Position="TopAndBottom" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                <SelectedRowStyle BackColor="#FFA200" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" Font-Names="Arial Narrow" />
                <AlternatingRowStyle BackColor="White" />
            </asp:GridView>
           
            <div style="padding:10px">
                <asp:Label ID="lblStatus" runat="server" Text=""></asp:Label>
            </div>
                    
           
            
            
            
           
           
            <asp:HiddenField ID="hidRoutingMsg" runat="server" Value="" />
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="sp_RemiList_Batch_History" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected"
                
                EnableCaching="true" CacheKeyDependency="ShowBatchCacheKey">
                <SelectParameters>
                    <asp:QueryStringParameter Name="Batch" QueryStringField="batch" Type="Int32" />
                    
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
