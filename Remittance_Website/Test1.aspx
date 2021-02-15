<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test1.aspx.cs" Inherits="Test1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="font-size:400%;text-align:center">
        <asp:Button ID="Button1" runat="server" Text="Generate New ID" OnClick="Button1_Click" Width="200px" Height="40px" Font-Bold="true" /><br /><br /><br />
        <asp:Label ID="Label1" runat="server" Text="Label1" Font-Names="Courier" Font-Bold="true"></asp:Label><br />
        <asp:Label ID="Label2" runat="server" Text="Label2" Font-Names="Courier" Font-Bold="true"></asp:Label><br />
        <asp:Label ID="Label3" runat="server" Text="Label3" Font-Names="Courier" Font-Bold="true"></asp:Label>
    </div>
    </form>
</body>
</html>
