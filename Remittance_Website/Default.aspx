<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="_Default" CodeFile="Default.aspx.cs" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .style2
        {
            font-size: x-large;
            font-weight: bold;
            color: silver;
        }
        .style3
        {
            font-size: small;
        }
        .style5
        {
            color: #666666;
        }
        .ROW2
        {
            background-image: url( 'Images/bg7.gif' );
            background-position: top;
            background-repeat: repeat-x;
            background-color: White;
            cursor: default;
        }
        .style6
        {
            width: 526px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Home
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:Panel ID="Panel1" runat="server" Style="text-align: left">
        <table>
            <tr>
                <td valign="top" style="padding: 10px 20px 50px 10px" class="style6">
                    <table style="font-weight: bold;" cellpadding="10px">
                        <tr>
                            <td align="center">
                                <a href="Remittance_Browse.aspx" class="Link" title="Remittance Browse/Search">
                                    <img src="Images/main_search_100.png" class="imagebutton" /><br />
                                    Browse</a>
                            </td>
                            <td align="center">
                                <a href="Paid_Grid.aspx" class="Link" title="Remittance Paid Grid">
                                    <img src="Images/paid.png" class="imagebutton" /><br />
                                    Paid Grid</a>
                            </td>
                        </tr>
                    </table>
                </td>
                <td rowspan="2" valign="top" style="padding: 40px 0px 0px 0px">
                    <img src="Images/rms.jpg" width="90px" height="90px" />
                </td>
            </tr>
            <tr>
                <td style="padding: 0px 50px 0px 0px" valign="bottom" class="style6">
                    <div class="style2">
                        you logged in as</div>
                    <table cellspacing="0" class="Panel1 ui-corner-all" cellpadding="10px">
                        <tr>
                            <td>
                                <b><span class="style3"><span class="style5">Branch:<br />
                                </span>
                                    <asp:DropDownList ID="cboBranch" runat="server" AppendDataBoundItems="True" DataSourceID="SqlDataSourceBranch"
                                        DataTextField="BranchName"
                                        DataValueField="BranchID" Enabled="False" OnDataBound="cboBranch_DataBound">
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:TblUserDBConnectionString %>"
                                        SelectCommand="SELECT [BranchID], [BranchName] FROM [ViewBranch] where branchid = @branchid">
                                        <SelectParameters>
                                            <asp:SessionParameter Name="branchid" SessionField="BRANCHID" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </span></b>
                            </td>
                            <td>
                                <b><span class="style3"><span class="style5">Department:<br />
                                </span>
                                    <asp:DropDownList ID="cboDept" runat="server" DataSourceID="SqlDataSourceDepartment"
                                        DataTextField="Department"
                                        DataValueField="DeptID" Enabled="False" OnDataBound="cboDept_DataBound">
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourceDepartment" runat="server" ConnectionString="<%$ ConnectionStrings:TblUserDBConnectionString %>"
                                        SelectCommand="SELECT [DeptID], [Department] FROM [Department] WHERE ([RevID] = @RevID and deptid=@deptid) ORDER BY [Department]">
                                        <SelectParameters>
                                            <asp:Parameter DefaultValue="9999" Name="RevID" Type="Int32" />
                                            <asp:SessionParameter Name="deptid" SessionField="DEPTID" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </span></b>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <p>
        <br />
    </p>
    <p>
    </p>
   
</asp:Content>
