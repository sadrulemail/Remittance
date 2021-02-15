<%@ Page Language="C#" AutoEventWireup="true" ValidateRequest="false" CodeFile="T_RSA.aspx.cs" Inherits="T_RSA" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Button ID="Button3" runat="server" Text="Key Pair Generate" OnClick="Button3_Click" />
            <br />
            <asp:Label ID="Label1" runat="server" Text="Key Pair"></asp:Label>
            <br />
            <asp:TextBox ID="TextBox2" TextMode="multiline" Columns="100" Rows="10" runat="server"></asp:TextBox>
            <br />
            <asp:TextBox ID="TextBox3" TextMode="multiline" Columns="100" Rows="10" runat="server"></asp:TextBox>
            <br />
            <asp:TextBox ID="TextBox1" runat="server" Text="123"></asp:TextBox>
            <br />

            <asp:Button ID="Button1" runat="server" Text="Encript" OnClick="Button1_Click" />
            <br />
            <asp:Label ID="Label2" runat="server" Text="Label"></asp:Label>
            <br />
            <asp:Button ID="Button2" runat="server" Text="Decript" OnClick="Button2_Click" />
            <br />
            <asp:Label ID="Label3" runat="server" Text="Label"></asp:Label>

            <fieldset>
                <legend>Token Generation</legend>

                <div>
                    <asp:TextBox ID="txtSystemID" Width="250px" runat="server" placeholder="System ID"></asp:TextBox>
                    <asp:TextBox ID="txtUser" runat="server" placeholder="User Name"></asp:TextBox>
                    <asp:TextBox ID="txtPassword" runat="server" placeholder="Password"></asp:TextBox>
                     <asp:TextBox ID="txtBranchID" runat="server" placeholder="Branch ID"></asp:TextBox>
                     <br />
                      <div style="padding-top:5px;">
            <asp:TextBox ID="txtPublickey" TextMode="multiline" Columns="100" Rows="10" runat="server"></asp:TextBox>
                          </div>
                </div>
               
                <div style="padding-top:5px;">
                    <asp:Button ID="btnToken" runat="server" Text="Token" OnClick="btnToken_Click" />
                </div>
            </fieldset>
        </div>
    </form>
</body>
</html>
