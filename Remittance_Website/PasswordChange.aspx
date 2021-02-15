<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    Inherits="ChangePassword" Title="Password Change" CodeFile="PasswordChange.aspx.cs" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .label
        {
            padding-left: 15px;
            padding-right: 5px;
            white-space: nowrap;
            text-align: right;
        }
        .label1
        {
            padding-right: 10px;
            white-space:nowrap;
        }
        .error-msg
        {
            text-align: center;
            padding: 0px 15px 20px 15px;
            text-shadow: 1px 1px 3px white;
            font-weight: bold;
            font-size: 130%;
            color: red;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    Password Change
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Always">
        <ContentTemplate>
            <table>
                <tr>
                    <td valign="top">
                        <img src="Images/keys.png" width="256" height="256" border="0" />
                    </td>
                    <td valign="top">
                        <asp:Panel ID="Panel2" runat="server" Visible="true">
                            <table style="border-collapse: collapse; min-width: " class="Panel1">
                                <tr>
                                    <td colspan="2">
                                        <div class="error-msg">
                                            <asp:Label ID="lblErrorMsg" runat="server" Text=""></asp:Label></div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        Current Password
                                    </td>
                                    <td >
                                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Width="140px"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPassword"
                                            ErrorMessage="RequiredFieldValidator">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        New Password
                                    </td>
                                    <td  class="label1">
                                        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" Width="140px"></asp:TextBox>
                                        <asp:PasswordStrength ID="txtNewPassword_PasswordStrength" runat="server" MinimumSymbolCharacters="1"
                                            MinimumUpperCaseCharacters="1" PreferredPasswordLength="6" TargetControlID="txtNewPassword"
                                            TextCssClass="Panel1 ui-corner-all" HelpHandlePosition="BelowRight">
                                        </asp:PasswordStrength>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtNewPassword"
                                            ErrorMessage="RequiredFieldValidator">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        Re-type New Password
                                    </td>
                                    <td class="label1">
                                        <asp:TextBox ID="txtRePassword" runat="server" TextMode="Password" Width="140px"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtRePassword"
                                            ErrorMessage="RequiredFieldValidator">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        &nbsp;
                                    </td>
                                    <td align="left">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        <a type="button" style="width: 80px; cursor: pointer; color: green; font-weight: bold"
                                            class="Link" onclick="location='Default.aspx'">Cancel</a>
                                    </td>
                                    <td class="label1">
                                        <asp:Button ID="cmdChangePassword" runat="server" OnClick="cmdChangePassword_Click"
                                            Text="Change Password" Height="30px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        &nbsp;
                                    </td>
                                    <td align="left">
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="Panel1" runat="server" Visible="false">
                            <div style="padding: 20px; text-align: center" class="Panel1">
                                <div style="margin-bottom: 30px; padding: 10px">
                                    <asp:Label ID="lblMsg" Font-Bold="true" Font-Size="Medium" runat="server" Text="Password has been changed successfull."></asp:Label></b>
                                </div>
                                <asp:Button ID="cmdLogin" runat="server" Text="Login Again" Width="120px" 
                                    Height="35px" onclick="cmdLogin_Click" CausesValidation="false" />
                            </div>
                        </asp:Panel>
                        <div align="center" style="margin-top: 30px">
                            <a href="Default.aspx" title="Home">
                                <img alt="" src="Images/Home.png" border="0" width="48" height="48" /></a>
                        </div>
                    </td>
                    <td valign="top" style="padding-left: 30px">
                        <div class="group" style="font-family: 'lucida grande',tahoma,verdana,arial,sans-serif;
                            background-color: LightYellow;">
                            <h5>
                                Password Policy</h5>
                            <div style="white-space: nowrap; padding: 0 10px">
                                <ul style="padding-left: 20px">
                                    <asp:SqlDataSource ID="SqlDataSourcePasswordPolicy" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:TblUserDBConnectionString %>"
                                    SelectCommand="SELECT dbo.PasswordPolicyText() as Policy"></asp:SqlDataSource>
                                <asp:FormView ID="FormView1" runat="server" DataSourceID="SqlDataSourcePasswordPolicy"
                                    RenderOuterTable="false">
                                    <ItemTemplate>
                                        <%# Eval("Policy")%>
                                    </ItemTemplate>
                                </asp:FormView>
                                </ul>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="cmdLogin" />
        </Triggers>
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
