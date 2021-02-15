<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="Remittance.ExHouse" CodeFile="ExHouse.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Exchange Houses
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="">
                <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" CssClass="Grid"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                    CellPadding="4" DataKeyNames="ExHouseCode" DataSourceID="SqlDataSource1" DefaultMode="ReadOnly"
                    ForeColor="Black" GridLines="Vertical" 
                    >
                    <FooterStyle BackColor="#CCCC99" />
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                    <EmptyDataTemplate>
                        <asp:Button ID="Button3" runat="server" Text="Add New" CommandName="New" Width="100px" />
                    </EmptyDataTemplate>
                    <Fields>
                        <asp:TemplateField HeaderText="ExHouse Code" SortExpression="ExHouseCode">
                            <ItemTemplate>
                                <asp:Label ID="lblExHouseCode" runat="server" Text='<%# Bind("ExHouseCode") %>' Font-Bold="true"></asp:Label>
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtExHouseCode" runat="server" MaxLength="50" Text='<%# Bind("ExHouseCode") %>'
                                    Width="100px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtExHouseCode"
                                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </InsertItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ExHouse Name" SortExpression="ExHouseName">
                            <ItemTemplate>
                                <asp:Label ID="lblExHouseName" runat="server" Text='<%# Bind("ExHouseName") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtExHouseName" runat="server" MaxLength="255" Text='<%# Bind("ExHouseName") %>'
                                    Width="400px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ControlToValidate="txtExHouseName"
                                    ErrorMessage="*"></asp:RequiredFieldValidator>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtExHouseName" runat="server" MaxLength="255" Text='<%# Bind("ExHouseName") %>'
                                    Width="400px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtExHouseName"
                                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </InsertItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="CBS ID" SortExpression="CBS_ID">
                            <EditItemTemplate>
                                <asp:TextBox ID="txtCBS_ID" runat="server" MaxLength="50" Text='<%# Bind("CBS_ID") %>'
                                    Width="100px"></asp:TextBox>
                                <asp:FilteredTextBoxExtender ID="txtCBS_ID_FilteredTextBoxExtender" runat="server"
                                    Enabled="True" TargetControlID="txtCBS_ID" ValidChars="0123456789">
                                </asp:FilteredTextBoxExtender>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="LabelCBS_ID" runat="server" Text='<%# Bind("CBS_ID") %>'></asp:Label>
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtCBS_ID" runat="server" MaxLength="50" Text='<%# Bind("CBS_ID") %>'
                                    Width="100px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtCBS_ID"
                                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </InsertItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Account No" SortExpression="AccountNo">
                            <EditItemTemplate>
                                <asp:TextBox ID="txtAccountNo" runat="server" MaxLength="20" Text='<%# Bind("AccountNo") %>'
                                    Width="120px"></asp:TextBox>
                                <asp:FilteredTextBoxExtender ID="txtAccountNo_FilteredTextBoxExtender" runat="server"
                                    Enabled="True" TargetControlID="txtAccountNo" ValidChars="0123456789-">
                                </asp:FilteredTextBoxExtender>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblAccount" runat="server" Text='<%# Bind("AccountNo") %>'></asp:Label>
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtAccountNo" runat="server" MaxLength="20" Text='<%# Bind("AccountNo") %>'
                                    Width="120px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator33" runat="server" ControlToValidate="txtAccountNo"
                                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </InsertItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Country" SortExpression="ExHouseCountry">
                            <EditItemTemplate>
                                <asp:TextBox ID="txtCountry" runat="server" MaxLength="255" Text='<%# Bind("ExHouseCountry") %>'
                                    Width="400px"></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblCountry" runat="server" Text='<%# Bind("ExHouseCountry") %>'></asp:Label>
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtCountry" runat="server" MaxLength="255" Text='<%# Bind("ExHouseCountry") %>'
                                    Width="400px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator331" runat="server" ControlToValidate="txtCountry"
                                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </InsertItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PIN Format" SortExpression="ExHousePIN">
                            <EditItemTemplate>
                                <asp:TextBox ID="txtPIN" runat="server" MaxLength="20" Text='<%# Bind("ExHousePIN") %>'
                                    Width="120px"></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblPIN" runat="server" Text='<%# Bind("ExHousePIN") %>'></asp:Label>
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtPIN" runat="server" MaxLength="50" Text='<%# Bind("ExHousePIN") %>'
                                    Width="120px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator330" runat="server" ControlToValidate="txtPIN"
                                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </InsertItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Comments" SortExpression="Comments">
                            <ItemTemplate>
                                <%# Eval("Comments").ToString().Replace("\n", "<br />") %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtComments" runat="server" Height="50px" MaxLength="255" Text='<%# Bind("Comments") %>'
                                    TextMode="MultiLine" Width="350px"></asp:TextBox>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtComments" runat="server" Height="50px" MaxLength="255" Text='<%# Bind("Comments") %>'
                                    TextMode="MultiLine" Width="350px"></asp:TextBox>
                            </InsertItemTemplate>
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Cover Fund Country">
		                    <ItemTemplate>
			                    <%#Eval("CoverFund_CountryName")%> <%#Eval("CoverFund_RitCountryCode", "({0})")%>
		                    </ItemTemplate>
		                    <InsertItemTemplate>
			                    <asp:DropDownList id="CountryList" datasourceid="CountrySqlDataSource" AppendDataBoundItems="true"
				                    datatextfield="RIT_Country_Name" DataValueField="RIT_Country_ID"  
				                    SelectedValue='<%# Bind("CoverFund_RitCountryCode") %>' runat="server">
                                    <asp:ListItem></asp:ListItem>
                                    </asp:DropDownList>
		                    </InsertItemTemplate>
		                    <EditItemTemplate>
			                    <asp:DropDownList id="CountryList" datasourceid="CountrySqlDataSource" AppendDataBoundItems="true"
			                    datatextfield="RIT_Country_Name" 	DataValueField="RIT_Country_ID"  
			                    SelectedValue='<%# Bind("CoverFund_RitCountryCode") %>'   runat="server">
                                
                                <asp:ListItem></asp:ListItem>
                                </asp:DropDownList>
		                    </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="ExHouse Type" SortExpression="ExHouse_Type" ItemStyle-Wrap="false">
                        <ItemTemplate>
                            <%# Eval("ExHouse_Type")%>
                        </ItemTemplate>
                        
                        <InsertItemTemplate>
                            <asp:DropDownList ID="cboExHouseType" runat="server" DataTextField="ExHouse_Type" SelectedValue='<%# Bind("ExHouse_Type") %>'>
                                
                                <asp:ListItem Text="Remittance" Value="R"></asp:ListItem>
                                <asp:ListItem Text="Web" Value="W"></asp:ListItem>
                                 <asp:ListItem Text="Api" Value="A"></asp:ListItem>
                            </asp:DropDownList>
                        </InsertItemTemplate>
                        <ItemStyle Wrap="False" />
                    </asp:TemplateField>
                    
                        <asp:CheckBoxField DataField="Active" HeaderText="Active" SortExpression="Active" />
                        <asp:TemplateField ShowHeader="False" ControlStyle-Width="80px">
                            <ItemTemplate>
                                <asp:Button ID="Button1" runat="server" CausesValidation="False" CommandName="Edit"
                                    Text="Edit" />
                                &nbsp;<asp:Button ID="Button2" runat="server" CausesValidation="False" CommandName="New"
                                    Text="New" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:Button ID="Button1" runat="server" CausesValidation="True" CommandName="Update"
                                    Text="Update" />
                                <asp:ConfirmButtonExtender ID="Button1_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Update?"
                                    Enabled="True" TargetControlID="Button1">
                                </asp:ConfirmButtonExtender>
                                &nbsp;<asp:Button ID="Button2" runat="server" CausesValidation="False" CommandName="Cancel"
                                    Text="Cancel" />
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:Button ID="Button1" runat="server" CausesValidation="True" CommandName="Insert"
                                    Text="Insert" />
                                <asp:ConfirmButtonExtender ID="Button1_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Save?"
                                    Enabled="True" TargetControlID="Button1">
                                </asp:ConfirmButtonExtender>
                                &nbsp;<asp:Button ID="Button2" runat="server" CausesValidation="False" CommandName="Cancel"
                                    Text="Cancel" />
                            </InsertItemTemplate>
                        </asp:TemplateField>
                       

                    </Fields>
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <AlternatingRowStyle BackColor="White" />
                </asp:DetailsView>
                <br />
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
                    CssClass="Grid" BorderColor="#DEDFDE" BorderStyle="Solid" BorderWidth="1px"
                    CellPadding="4" DataSourceID="SqlDataSource2" ForeColor="Black" AllowSorting="True"
                    Font-Size="Small" DataKeyNames="ExHouseCode" OnSelectedIndexChanging="GridView1_SelectedIndexChanging"
                    OnDataBound="GridView1_DataBound">
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                    <Columns>
                        <asp:BoundField DataField="ExHouseCode" HeaderText="ExHouse Code" ReadOnly="True"
                            ItemStyle-Font-Bold="true" SortExpression="ExHouseCode">
                            <ItemStyle Font-Bold="True" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="ExHouseName" HeaderText="ExHouse Name" SortExpression="ExHouseName"
                            HeaderStyle-HorizontalAlign="left" />
                        <asp:BoundField DataField="CBS_ID" HeaderText="CBS ID" SortExpression="CBS_ID" />
                        <asp:BoundField DataField="AccountNo" HeaderText="Account No" SortExpression="AccountNo" ItemStyle-Wrap="false" />
                        
                        <asp:BoundField DataField="ExHouseCountry" HeaderText="Country" SortExpression="ExHouseCountry" />
                        <asp:BoundField DataField="ExHousePIN" HeaderText="PIN Format" SortExpression="PIN" />
                        <asp:BoundField DataField="CoverFund_CountryName" HeaderText="Cover Fund Country" SortExpression="CoverFund_CountryName" />
                        <asp:TemplateField HeaderText="Comments" SortExpression="Comments">
                            <ItemTemplate>
                                <%# Eval("Comments").ToString().Replace("\n", "<br />") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="ExHouse_Type" HeaderText="Type" SortExpression="ExHouse_Type" ItemStyle-HorizontalAlign="Center" />
                        <asp:TemplateField HeaderText="Active" SortExpression="Active" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <%# (Eval("Active").ToString() == "True") ? "<img src='Images/tick.png' width='20px' height='20px'>" : ""%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="By" SortExpression="UpdateBy" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <uc2:EMP ID="EMP2" runat="server" Username='<%# Eval("UpdateBy") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <%--<asp:TemplateField HeaderText="Updated On" SortExpression="UpdateDT">
                        <ItemTemplate>
                            <span title='<%# Eval("UpdateDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                <%# TrustControl1.ToRecentDateTime(Eval("UpdateDT"))%></span>
                        </ItemTemplate>
                    </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="About" SortExpression="UpdateDT" ItemStyle-Wrap="false">
                            <ItemTemplate>
                                <div class="time-small" title='<%# Eval("UpdateDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <time class="timeago" datetime='<%# Eval("UpdateDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time></div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <%--<asp:CommandField ShowSelectButton="True" />                         --%>
                        <asp:TemplateField HeaderText="" InsertVisible="False" SortExpression="">
                            <ItemTemplate>
                                <asp:LinkButton ID="LinkButton1" runat="server" CommandName="SELECT" ToolTip="Open"
                                    CausesValidation="false">
                                <img alt=""  src="Images/new_window.png" width="16" height="16" border="0" />
                                </asp:LinkButton>
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
                    SelectCommand="SELECT * FROM [v_ExHouses] ORDER BY ExHouseCode" OnSelected="SqlDataSource2_Selected">
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                    SelectCommand="SELECT * FROM [v_ExHouses] WHERE ExHouseCode=@ExHouseCode" InsertCommand="sp_ExHouseInsert"
                    InsertCommandType="StoredProcedure" UpdateCommand="sp_ExHouseUpdate" UpdateCommandType="StoredProcedure"
                    OnUpdated="SqlDataSource1_Updated">
                    <SelectParameters>
                        <asp:ControlParameter Name="ExHouseCode" ControlID="GridView1" PropertyName="SelectedValue" />
                    </SelectParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="ExHouseCode" Type="String" />
                        <asp:Parameter Name="ExHouseName" Type="String" />
                        <asp:Parameter Name="Active" Type="Boolean" />
                        <asp:Parameter Name="AccountNo" Type="String" />
                        <asp:Parameter Name="CBS_ID" Type="String" />
                        <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                        <asp:Parameter Name="ExHouseCountry" Type="String" />
                        <asp:Parameter Name="ExHousePIN" Type="String" />
                        <asp:Parameter Name="Comments" Type="String" Size="255" DefaultValue="" />
                        <asp:Parameter Name="CoverFund_RitCountryCode" Type="Int32" DefaultValue="0" />
                        <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                        <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                    </UpdateParameters>
                    <InsertParameters>
                        <asp:Parameter Name="ExHouseCode" Type="String" />
                        <asp:Parameter Name="ExHouseName" Type="String" />
                        <asp:Parameter Name="Active" Type="Boolean" />
                        <asp:Parameter Name="AccountNo" Type="String" />
                        <asp:Parameter Name="CBS_ID" Type="String" />
                        <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                        <asp:Parameter Name="ExHouseCountry" Type="String" />
                        <asp:Parameter Name="ExHousePIN" Type="String" />
                        <asp:Parameter Name="Comments" Type="String" />
                        <asp:Parameter Name="CoverFund_RitCountryCode" Type="Int32" DefaultValue="0" />
                        <asp:Parameter Name="ExHouse_Type" Type="String" />
                        <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                        <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                    </InsertParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="CountrySqlDataSource" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>" 
                    OnUpdated="SqlDataSource1_Updated" 
                    SelectCommand="SELECT  RIT_Country_ID,RIT_Country_Name FROM v_RIT_CountryCodes order by RIT_Country_Name">
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
