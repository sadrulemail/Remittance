<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="Remittance.Branch_Mapping" CodeFile="Branch_Mapping.aspx.cs" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Branch Mapping for Exchange Houses
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="">
                <table>
                <tr>
                    <td>
                        <table class="ui-corner-all Panel1">
                            <tr>
                                <td>
                                    <table >
                                        <tr>                                            
                                            <td>Ex-House:
                                                <asp:DropDownList ID="cboExHouse" runat="server" AppendDataBoundItems="true" AutoPostBack="true"
                                                    DataSourceID="SqlDataSourceExHouse" DataTextField="ExHouseName" DataValueField="ExHouseCode" >                                                    
                                                </asp:DropDownList>                                                
                                            </td>
                                            <td style="padding: 0px 10px 0px 10px">
                                                <asp:Button ID="cmdFilter" runat="server" Text="Show" OnClick="cmdFilter_Click"/>
                                            </td>
                                            </tr></table>                                            
                                </td>
                            </tr>
                        </table>
                    </td>                    
                </tr>
            </table>              
                <br />
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
                    CssClass="Grid" BorderColor="#DEDFDE" BorderStyle="Solid" BorderWidth="1px"
                    CellPadding="4" DataSourceID="SqlDataSource2" ForeColor="Black" AllowSorting="True"
                    Font-Size="Small" DataKeyNames="BranchID" OnSelectedIndexChanging="GridView1_SelectedIndexChanging"
                    OnDataBound="GridView1_DataBound">
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                    <Columns>
                        <%--<asp:BoundField DataField="MappingID" HeaderText="Mapping ID" SortExpression="MappingID"
                           HeaderStyle-HorizontalAlign="left" Visible="false"  />--%>
                        <asp:TemplateField HeaderText="ID" SortExpression="MappingID">                            
                            <ItemTemplate>                                                                
                                <asp:Label runat="server" ID="lblMappingID" Text='<%#  Bind("MappingID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <%--<asp:BoundField DataField="MappingID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                            SortExpression="MappingID" ItemStyle-HorizontalAlign="Center">
                            <ItemStyle HorizontalAlign="Center" ForeColor="Silver" />
                        </asp:BoundField>--%>

                        <%--<asp:BoundField DataField="ExHouseCode" HeaderText="ExHouse Code" ReadOnly="True"
                            ItemStyle-Font-Bold="true" SortExpression="ExHouseCode" Visible="true">
                            <ItemStyle Font-Bold="True" />
                        </asp:BoundField>  --%>                      
                        <%--<asp:BoundField DataField="ExHouseName" HeaderText="ExHouse Name" SortExpression="ExHouseName"
                            HeaderStyle-HorizontalAlign="left" />--%>
                        <%--<asp:BoundField DataField="BranchID" HeaderText="BranchID" SortExpression="BranchID" />--%>
                        <asp:TemplateField HeaderText="Branch ID" SortExpression="BranchID">                            
                            <ItemTemplate>                                                                
                                <asp:Label runat="server" ID="lblBranchID" Text='<%#  Bind("BranchID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                       
                        <asp:TemplateField HeaderText="Branch Name" SortExpression="BranchName">                            
                            <ItemTemplate>
                                <%--<asp:DropDownList ID="cboBranch" runat="server" AppendDataBoundItems="true" DataSourceID="SqlDataSourceBranch"
                                    DataTextField="BranchName" DataValueField="BranchID" Width="300px">                                    
                                </asp:DropDownList>--%>
                                <%# Eval("BranchName")%>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Branch Mapping Code" SortExpression="Mapping_Code">
                            <EditItemTemplate>                                
                                <asp:TextBox ID="txt1" runat="server" Text='<%# Bind("Mapping_Code") %>' Width="80px"></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <%# Eval("Mapping_Code")%>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <%--<asp:BoundField DataField="Mapping_Code" HeaderText="Branch Mapping Code" SortExpression="Mapping_Code" /> --%>                                               
                        <asp:TemplateField HeaderText="By" SortExpression="UpdateBy" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <uc2:EMP ID="EMP2" runat="server" Username='<%# Eval("UpdateBy") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>                        
                        <asp:TemplateField HeaderText="About" SortExpression="UpdateDT" ItemStyle-Wrap="false">
                            <ItemTemplate>
                                <div class="time-small" title='<%# Eval("UpdateDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <time class="timeago" datetime='<%# Eval("UpdateDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time></div>
                            </ItemTemplate>
                        </asp:TemplateField>                                                
                        <asp:TemplateField HeaderText="" SortExpression="">
                            <EditItemTemplate>
                                <asp:LinkButton ID="LinkButton1" CommandName="update" CausesValidation="false" runat="server">Update</asp:LinkButton>
                                <asp:LinkButton ID="LinkButton2" CommandName="cancel" CausesValidation="false" runat="server">Cancel</asp:LinkButton>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:LinkButton ID="LinkButton1" CausesValidation="false" CommandName="Edit" runat="server">Edit</asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>

                    </Columns>
                    <FooterStyle BackColor="#CCCC99" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                    <SelectedRowStyle BackColor="#FFA200" ForeColor="Black" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="false" ForeColor="White" />
                    <AlternatingRowStyle BackColor="White" />
                </asp:GridView>
                <br />
                <asp:Label ID="lblStatus" runat="server" Text=""></asp:Label>
                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                    SelectCommand="sp_BranchMappingList_Select" OnSelected="SqlDataSource2_Selected" SelectCommandType="StoredProcedure"
                    UpdateCommand="sp_BranchMappingInsert" UpdateCommandType="StoredProcedure" OnUpdated="SqlDataSource2_Updated">
                    <SelectParameters>
                        <asp:ControlParameter Name="ExHouseCode" ControlID="cboExHouse" PropertyName="SelectedValue" />
                    </SelectParameters>
                    <UpdateParameters>        
                        <asp:Parameter Name="MappingID" Type="Int32" />
                        <asp:ControlParameter ControlID="cboExhouse" Name="ExHouseCode" PropertyName="SelectedValue" Type="String" />
                        <%--<asp:Parameter Name="ExHouseCode" Type="String"/>--%>
                        <asp:Parameter Name="BranchID" Type="Int32" />
                        <asp:Parameter Name="Mapping_Code" Type="String" />                        
                        <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />                        
                        <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                        <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                    </UpdateParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                    SelectCommand="SELECT * FROM [v_BranchMapping] WHERE MappingID=@MappingID" 
                    UpdateCommand="sp_sp_BranchMappingUpdate" UpdateCommandType="StoredProcedure"
                    OnUpdated="SqlDataSource1_Updated">
                    <SelectParameters>
                        <asp:ControlParameter Name="MappingID" ControlID="GridView1" PropertyName="SelectedValue" />
                    </SelectParameters>
                   <%-- <UpdateParameters>
                        <asp:Parameter Name="ExHouseCode" Type="String" />
                        <asp:Parameter Name="BranchID" Type="Int32" />                        
                        <asp:Parameter Name="Mapping_Code" Type="String" />                        
                        <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />                        
                        <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                        <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                    </UpdateParameters>--%>
                    
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"                     
                    SelectCommand="SELECT  BranchID, BranchName FROM v_Branch order by BranchName">                    
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSourceExHouse" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                    SelectCommand="SELECT [ExHouseCode], ExHouseCode + ', ' +[ExHouseName] as ExHouseName FROM [ExHouses] WHERE ([Active] = @Active AND ExHouse_Type='W') ORDER BY [ExHouseName]">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="True" Name="Active" Type="Boolean" />
                    </SelectParameters>
                </asp:SqlDataSource>
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
        UseAnimation="false" VerticalSide="Middle">
    </asp:AlwaysVisibleControlExtender>
</asp:Content>
