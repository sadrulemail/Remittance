using System;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ShowBatchHistory : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();

        if (!IsPostBack)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");

            lblTitle.Text = string.Format("Batch History (ID: {0})", Request.QueryString["batch"]);
            this.Title = string.Format("History # {0}", Request.QueryString["batch"]);
            txtBatch.Text = string.Format("{0}", Request.QueryString["batch"]);
            litBatchHistory.Text = string.Format("<a href='ShowBatch.aspx?batch={0}' class='Link' target='_blank'>Batch Details</a>", Request.QueryString["batch"]);

            if (txtBatch.Text == string.Empty)
            {
                string focusScript = "document.getElementById('" + txtBatch.ClientID + "').focus();";
                TrustControl1.ClientScriptStartup("setTimeout(\"" + focusScript + ";\",200);");
            }
            Cache["ShowBatchCacheKey"] = DateTime.Now;
        }
    }

    protected void cmdShow_Click(object sender, EventArgs e)
    {
        Response.Redirect(string.Format("ShowBatchHistory.aspx?batch={0}", txtBatch.Text));
    }

    protected void cboPaymentMethod_DataBound(object sender, EventArgs e)
    {
        DropDownList cboPaymentMethod = ((DropDownList)sender);
        for (int i = 0; i < cboPaymentMethod.Items.Count; i++)
        {
            cboPaymentMethod.Items[i].Attributes.Add("title", cboPaymentMethod.Items[i].Text);
            cboPaymentMethod.Items[i].Text = cboPaymentMethod.Items[i].Value;
        }
    }

    protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        lblStatus.Text = string.Format("Total: <b>{0:N0}</b>", e.AffectedRows);
        //lblTotalAmount.Text = string.Format("{0:N2}", e.Command.Parameters["@TotalAmount"].Value);
        //TotalRows = e.AffectedRows;
        //Cancelable = Convert.ToInt32(e.Command.Parameters["@TotalCancable"].Value.ToString());
    }
}