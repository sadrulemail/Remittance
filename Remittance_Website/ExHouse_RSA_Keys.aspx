<%@ Page Title="RSA Keys" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="ExHouse_RSA_Keys.aspx.cs" Inherits="ExHouse_RSA_Keys_Page"
    EnableViewState="true" EnableSessionState="True" ValidateRequest="false" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        legend {
            font-weight: bold;
            font-size: 120%;
        }

        fieldset {
            margin: 20px;
            border: 1px solid gray;
            border-radius: 8px;
            padding: 10px 20px;
            margin-bottom: 30px;
            width: 950px;
        }

        input {
            font-size: 120%;
        }

        .data {
            font-family: 'Courier New';
            font-size: 120%;
            font-weight: bold;
        }
        .Grid {
            border-collapse:collapse;
        }
            .Grid td {
                padding:5px;
                white-space:nowrap
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Ex-House RSA Keys
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Always">
        <ContentTemplate>
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
                SelectCommand="SELECT [ExHouseCode], ExHouseCode + ', ' + [ExHouseName] as ExHouseName FROM [v_ExHouseListDetails] with (nolock) WHERE ExHouse_Type = 'A' ORDER BY ExHouseName"></asp:SqlDataSource>
            <fieldset>
                <legend>Ex-House (API)</legend>
                <table class="Grid">
                    <tr>
                        <td>Ex-House:</td>
                        <td>
                            <asp:DropDownList ID="DropDownList1" runat="server"
                                AppendDataBoundItems="true" EnableViewState="true"
                                DataSourceID="SqlDataSource2" DataTextField="ExHouseName"
                                DataValueField="ExHouseCode">
                                <asp:ListItem Value="" Text=""></asp:ListItem>
                            </asp:DropDownList>

                        </td>
                        <td>
                            <asp:Button ID="cmdShowKey" runat="server" Text="Show RSA Key Info" OnClick="cmdShowKey_Click" />
                        </td>
                        <td>
                            <asp:Button ID="cmdGeneratePrivateKey" runat="server" Text="Generate New Private Key" OnClick="cmdGeneratePrivateKey_Click" />
                        </td>
                    </tr>
                </table>

            </fieldset>


            <fieldset>
                <legend>Token Generation (for test)</legend>
                <table class="Grid">
                    <tr>
                        <td>User Name:</td>
                        <td>
                            <asp:Label CssClass="data" ID="txtUser" Width="400px" ReadOnly="true" runat="server" placeholder="User Name"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Password:</td>
                        <td>
                            <asp:Label CssClass="data" ID="txtPassword" Width="400px" ReadOnly="true" runat="server" placeholder="Password"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>System ID:</td>
                        <td>
                            <asp:Label CssClass="data" ID="txtSystemID" Width="400px" ReadOnly="true" runat="server" placeholder="System ID"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Branch ID:</td>
                        <td>
                            <asp:Label CssClass="data" ID="txtBranchID" runat="server" ReadOnly="true" Text="1" placeholder="Branch ID"></asp:Label></td>
                    </tr>
                    <tr>
                        <td valign="top">Public Key:</td>
                        <td>
                            <div class="bold data" style="width: 800px; height: 70px; overflow: scroll; overflow-y: hidden; border: 1px solid silver; padding: 3px; border-radius: 4px">
                                <asp:Label ID="txtPublickey" runat="server" Text=""></asp:Label>
                                <%--<asp:TextBox ID="txtPublickey" runat="server" ReadOnly="true" Width="800px" Rows="7" TextMode="MultiLine"
                                placeholder="Branch ID"></asp:TextBox>--%>
                            </div>

                        </td>




                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:Button ID="btnToken" runat="server" Text="Generate Token" OnClick="btnToken_Click" />
                            <div>
                                <asp:Literal ID="litToken" runat="server"></asp:Literal>
                            </div>
                        </td>
                    </tr>
                </table>



            </fieldset>



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

