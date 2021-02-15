<%@ Control Language="C#" AutoEventWireup="true" Inherits="TrustControl" CodeFile="TrustControl.ascx.cs" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:ScriptManager 
    ID="TrustScriptManager" 
    runat="server" 
    ScriptMode="Release"
    CompositeScript-ScriptMode="Release"
    EnableHistory="True" EnableCdn="false"
    EnablePageMethods="True"
    AsyncPostBackTimeout="360000">
</asp:ScriptManager>