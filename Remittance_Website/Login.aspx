<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    Inherits="Remittance.Login" Title="Log In" CodeFile="Login.aspx.cs" EnableSessionState="True" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="CSS/StyleSheet.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        input
        {
            border-radius: 16px !important;
            padding-left: 10px !important;
            padding-right: 10px !important;
        }
        .TextBoxBig
        {
            font-size: small;
            padding: 5px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text="Login"></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="360000"
    ScriptMode="Release"
    EnablePartialRendering="true"></asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Always">
        <ContentTemplate>
            <div align="center" >
        <img src="Images/loading.gif" style="display: none" alt="" />
        <asp:Image runat="server" ID="imgApp" Height="128px" /><br />
        <br />
        <div class="Shadow" style="width: 400px; background-color: #8FAA4A; color: White; border: solid 1px #69812C; padding: 15px;border-radius:8px">
            <div style="padding-bottom: 15px">                
                <asp:Literal runat="server" ID="litEmpImage"></asp:Literal>
            </div>
            <asp:Panel runat="server" ID="PanelEmpID">
                <asp:TextBox ID="txtEmpID" 
                    runat="server" 
                    Width="200px" 
                    Font-Size="180%" 
                    placeholder="enter login id"
                    CssClass="TextBoxBig" 
                    onfocus="select()" 
                    MaxLength="20" 
                    OnTextChanged="txtEmpID_TextChanged" ></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtEmpID"
                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                <asp:Label ID="lblEmpID" runat="server" Font-Bold="true" Font-Size="Medium" Font-Names="Arial" ForeColor="white"
                    Text=""></asp:Label>
                <br />
            </asp:Panel>
            <asp:Panel runat="server" ID="PanelPassword" Visible="false">
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Width="200px" Font-Size="180%"
                    placeholder="enter password"
                    CssClass="TextBoxBig" onfocus="select()" MaxLength="255"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtPassword"
                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                <br />
            </asp:Panel>
            <div style="padding-top:10px">
                <asp:Label ID="lblError" runat="server" Font-Bold="true" Font-Size="Medium" ForeColor="white"
                    Text=""></asp:Label>
            </div>
            <div style="padding-top: 15px;">
                <table width="100%">
                    <td align="left">
                        <asp:LinkButton Style="float: left" runat="server" ID="lnkBack" ToolTip="Back" OnClick="lnkBack_Click" Visible="false" CausesValidation="false">
                    <img  src="Images/Back.png" width="32" />
                        </asp:LinkButton>
                    </td>
                    <td align="center" width="34%">
                        <asp:Button ID="cmdNext" runat="server" OnClick="cmdNext_Click" Text="Next" Width="100px"
                            Height="35px" />
                        <asp:Button ID="cmdLogin" runat="server" OnClick="cmdLogin_Click" Text="Login" Width="100px"
                            Height="35px" Visible="false" />
                    </td>
                    <td align="right" width="33%">
                        <asp:HyperLink runat="server" ID="hypForgetPass" NavigateUrl="../Password.aspx" style="color: white; text-decoration: none" Visible="false">Forget Password?
                        </asp:HyperLink>
                    </td>
                </table>
            </div>

        </div>
        
        <div style="padding-top: 30px">
            <a href="../Default.aspx" title="intraweb Home">
                <img src="Images/Home.jpg" style="border: none" alt="Home" />
            </a>
        </div>
    </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
