<%@ Page Language="C#" AutoEventWireup="true" EnableSessionState="ReadOnly"
    Inherits="Remittance.CR_BR2_Form" CodeFile="CR_BR2.aspx.cs" %>
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
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetData"
            TypeName="Remittance.DataSet1TableAdapters.sp_Remittance_SelectTableAdapter" >
            <SelectParameters>
                <asp:QueryStringParameter Name="ID" QueryStringField="id" Type="Int32" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <CR:CrystalReportViewer ID="CrystalReportViewer1" runat="server" AutoDataBind="True"
            Height="1077px"  OnAfterRender="CrystalReportViewer1_AfterRender"
            ReportSourceID="CrystalReportSource1" Width="814px" DisplayToolbar="True"  />
        <CR:CrystalReportSource ID="CrystalReportSource1" runat="server">
            <Report FileName="Reports/CR_BR2.rpt">
                <Parameters>
                    <CR:Parameter Name="Reference" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Branch" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Bank" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="District" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Instrument" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Date" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Amount" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Beneficiary" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Account" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Emp Name" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Emp Designation" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Emp Branch" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Paid On" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Exchange House" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Ref" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="RID" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="Currency" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="PaymentMethod" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="PaymentMethodDetails" DefaultValue="" ConvertEmptyStringToNull="false" />
                    <CR:Parameter Name="RemitterName" DefaultValue="" ConvertEmptyStringToNull="false" />
                </Parameters>
            </Report>
        </CR:CrystalReportSource>
        
        <asp:SqlDataSource ID="SqlDataSourcePrintLog_Insert" runat="server" ConnectionString="<%$ ConnectionStrings:RemittanceConnectionString %>"
            SelectCommand="sp_PrintLog_Insert" SelectCommandType="StoredProcedure" >
            <SelectParameters>
                <asp:QueryStringParameter Name="RID" QueryStringField="id" Type="Int32" />
                <asp:QueryStringParameter Name="Ref" QueryStringField="ref" Type="String" />
                <asp:SessionParameter Name="ByEmp" SessionField="EMPID" Type="String" />
                <asp:SessionParameter Name="ByBranch" SessionField="BRANCHID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
    </form>
</body>
</html>