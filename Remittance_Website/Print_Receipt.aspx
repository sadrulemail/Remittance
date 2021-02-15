<%@ Page Language="C#" AutoEventWireup="true" Inherits="Print_Receipt" CodeFile="Print_Receipt.aspx.cs" EnableSessionState="ReadOnly" %>

<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304"
    Namespace="CrystalDecisions.Web" TagPrefix="CR" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <uc1:TrustControl ID="TrustControl1" runat="server" />
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
            ProviderName="<%$ ConnectionStrings:RemittanceConnectionString.ProviderName %>"
            SelectCommand="sp_Remi_Receipt" SelectCommandType="StoredProcedure" 
            onselecting="SqlDataSource1_Selecting">
            <SelectParameters>
                <asp:QueryStringParameter Name="RID" QueryStringField="id" Type="String" />
                <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                <asp:Parameter Name="isAdmin" Type="Boolean" DefaultValue="false" />
            </SelectParameters>
        </asp:SqlDataSource>
        <CR:CrystalReportViewer ID="CrystalReportViewer1" runat="server" AutoDataBind="True"
             Height="1077px" OnAfterRender="CrystalReportViewer1_AfterRender"
            ReportSourceID="CrystalReportSource1" Width="814px" DisplayToolbar="True" />
        <CR:CrystalReportSource ID="CrystalReportSource1" runat="server" EnableCaching="False">
            <Report FileName="Reports/Print_Receipt_IC.rpt">
                <Parameters>
                    <CR:Parameter Name="RID" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Branch" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Amount" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Currency" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Ex-House" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="RemitterName" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="BeneficiaryName" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="PaidOn" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="AmountInWord" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Paid By Emp Name" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Emp Designation" DefaultValue="" ConvertEmptyStringToNull="false" />
                </Parameters>
            </Report>
        </CR:CrystalReportSource>
        
        <asp:SqlDataSource ID="SqlDataSourcePrintLog_Insert" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
            SelectCommand="sp_PrintLog_Insert" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="RID" QueryStringField="id" Type="String" />
                <asp:Parameter Name="Ref" DefaultValue="Customer Receipt" Type="String" />
                <asp:SessionParameter Name="ByEmp" SessionField="EMPID" Type="String" />
                <asp:SessionParameter Name="ByBranch" SessionField="BRANCHID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
    </form>
</body>
</html>
