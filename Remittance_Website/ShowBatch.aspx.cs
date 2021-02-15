using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace Remittance
{
    public partial class ShowBatch : System.Web.UI.Page
    {
        int TotalRows;
        int Cancelable;
        bool Published;
        string FocusControl = "";
        bool RemittanceUpdated = false;


        protected void Page_Load(object sender, EventArgs e)
        {
            TrustControl1.getUserRoles();

            if (!IsPostBack)
            {
                cmdPublish.Visible = false;
                Page.Form.Attributes.Add("enctype", "multipart/form-data");

                lblTitle.Text = string.Format("Batch ID: {0}", Request.QueryString["batch"]);
                this.Title = string.Format("Batch # {0}", Request.QueryString["batch"]);
                txtBatch.Text = string.Format("{0}", Request.QueryString["batch"]);

                try
                {
                    long BatchID = long.Parse(txtBatch.Text);
                    if(BatchID == 0)
                    {
                        Response.End();
                    }
                }
                catch (Exception) { }

                litBatchHistory.Text = string.Format("| <a href='ShowBatchHistory.aspx?batch={0}' class='Link' target='_blank'>History</a>", Request.QueryString["batch"]);

                if (txtBatch.Text == string.Empty)
                {
                    string focusScript = "document.getElementById('" + txtBatch.ClientID + "').focus();";
                    TrustControl1.ClientScriptStartup("setTimeout(\"" + focusScript + ";\",200);");
                }
                Cache["ShowBatchCacheKey"] = DateTime.Now;
            }
        }

        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            Published = false;
           bool RiaPaidPublished = false;
            Cache["ShowBatchCacheKey"] = DateTime.Now;
            //hidExHouseType.Value = GridView1.Rows.ToString();
            if (GridView1.Rows.Count > 0 && GridView1.EditIndex < 0)
            {
                int AmountCol = 3;
                int PaidCol = 5;
                int StatusCol = 8;

                //PanelCancel.Visible = true;

                for (int c = 0; c < GridView1.Columns.Count; c++)
                    if (GridView1.HeaderRow.Cells[c].Text.Contains("Amount"))
                        AmountCol = c;

                double TotalAmount = 0;
                //Cancelable = 0;
                for (int i = 0; i < GridView1.Rows.Count; i++)
                {
                    string StatusText = "";
                    if (GridView1.Rows[i].Cells[StatusCol].HasControls())
                    {
                        try
                        {
                            StatusText = ((DataBoundLiteralControl)(GridView1.Rows[i].Cells[StatusCol].Controls[0])).Text.Trim().Replace("&nbsp;", "").Replace("\r\n", "").Replace(" ", "").Replace("()", "");
                        }
                        catch (Exception) { }
                    }
                    else
                        StatusText = GridView1.Rows[i].Cells[StatusCol].Text;

                    TotalAmount += double.Parse(GridView1.Rows[i].Cells[AmountCol].Text);
                    //if (!((CheckBox)GridView1.Rows[i].Cells[PaidCol].Controls[0]).Checked
                    //    && StatusText == "ACTIVE")
                    //    Cancelable++;

                    if (((CheckBox)GridView1.Rows[i].Cells[GridView1.Columns.Count - 1].Controls[0]).Checked)
                        Published = true;
                    else
                        RiaPaidPublished = true;
                }
                GridView1.FooterRow.Cells[AmountCol].Text = string.Format("{0:N2}", TotalAmount);
                GridView1.FooterRow.Cells[AmountCol].HorizontalAlign = HorizontalAlign.Right;

                cmdPublish.Visible = !Published;

                //PanelPublish.Visible = !Published;
                Panel_BulkChangeToBranch.Visible = !Published;
                if (hidExHouseType.Value == "A" && hidExHouseCode.Value== "Ria API")
                {
                    panelRiaPaid.Visible = RiaPaidPublished;
                    cmdPublish.Visible = false;
                }
                if (hidExHouseType.Value == "W")
                {
                    Panel_BulkChangeStatus.Visible = false;
                    panelbulk.Visible = false;
                    PanelCancel.Visible = false;
                }
                else
                {
                    Panel_BulkChangeStatus.Visible = true;
                    panelbulk.Visible = true;
                    PanelCancel.Visible = true;
                }
                //Hide Cells
                for (int c = 12; c < GridView1.Columns.Count; c++)
                {
                    bool isEmpty = true;
                    for (int r = 0; r < GridView1.Rows.Count; r++)
                    {
                        if (GridView1.Rows[r].Cells[c].Text.Trim() != "&nbsp;")
                        {
                            isEmpty = false;
                        }
                    }

                    if (isEmpty)
                        GridView1.Columns[c].Visible = false;
                }

                lblCancelText.Text = string.Format("You can Cancel <b>{0}</b> of <b>{1}</b> Rows of this Batch: <b>{2}</b>",
                     Cancelable, TotalRows, Request.QueryString["batch"]);

                if (TotalRows - Cancelable > 0)
                    lnkShowNotCancelable.Text = string.Format("(<b>{0}</b> rows can not be canceled)",
                        TotalRows - Cancelable);
                cmdCancel.Enabled = Cancelable > 0;
            }
        }

        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            //lblStatus.Text = string.Format("{0:N0}", e.AffectedRows);
            //lblTotalAmount.Text = string.Format("{0:N2}", e.Command.Parameters["@TotalAmount"].Value);
            TotalRows = e.AffectedRows;
            Cancelable = Convert.ToInt32(e.Command.Parameters["@TotalCancable"].Value.ToString());
        }

        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if ((bool)(DataBinder.Eval(e.Row.DataItem, "Paid")) == true)
                {
                    e.Row.ForeColor = System.Drawing.Color.Red;
                }
                if ((string)(DataBinder.Eval(e.Row.DataItem, "Status")) == "CANCEL")
                {
                    e.Row.BackColor = System.Drawing.Color.Tomato;
                }
                else if ((string)(DataBinder.Eval(e.Row.DataItem, "Status")) == "ON HOLD")
                {
                    e.Row.BackColor = System.Drawing.Color.CadetBlue;
                }
                hidExHouseType.Value = (string)(DataBinder.Eval(e.Row.DataItem, "ExHouse_Type"));
                hidExHouseCode.Value = (string)(DataBinder.Eval(e.Row.DataItem, "ExHouseCode"));
            }
        }

        protected void cmdShow_Click(object sender, EventArgs e)
        {
            Response.Redirect(string.Format("ShowBatch.aspx?batch={0}", txtBatch.Text));
        }

        protected void cmdCancel_Click(object sender, EventArgs e)
        {
            SqlDataSourceCancel.Update();
            //TrustControl1.ClientMsg("Sorry, No Command Assigned.");
        }

        protected void GridView2_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if ((bool)(DataBinder.Eval(e.Row.DataItem, "Paid")) == true)
                {
                    e.Row.ForeColor = System.Drawing.Color.Red;
                }
                if ((string)(DataBinder.Eval(e.Row.DataItem, "Status")) == "CANCEL")
                {
                    e.Row.BackColor = System.Drawing.Color.Tomato;
                }
                else if ((string)(DataBinder.Eval(e.Row.DataItem, "Status")) == "ON HOLD")
                {
                    e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml(TrustControl1.getValueOfKey("ON HOLD"));
                }
            }
        }

        protected void lnkShowNotCancelable_Click(object sender, EventArgs e)
        {
            GridView2.Visible = true;
        }
        protected void cboStatus_OnDataBound(object sender, EventArgs e)
        {
            TextBox txtReason = (TextBox)DetailsView1.FindControl("txtReason");
            string ExHouseCode = ((Label)DetailsView1.FindControl("lblExHouseCode")).Text;
            DropDownList cboStatus = (DropDownList)DetailsView1.FindControl("cboStatus");
            //   RequiredFieldValidator RequiredFieldValidatorReturnReason = (RequiredFieldValidator)DetailsView2.FindControl("RequiredFieldValidatorReturnReason");
            if (cboStatus.SelectedItem.Value == "REJECT" && ExHouseCode == "Ria API")
            {
                txtReason.Visible = true;
                // RequiredFieldValidatorReturnReason.Enabled = true;
            }
        }

        protected void cboStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            TextBox txtReason = (TextBox)DetailsView1.FindControl("txtReason");
            string ExHouseCode = ((Label)DetailsView1.FindControl("lblExHouseCode")).Text;
            DropDownList cboStatus = (DropDownList)DetailsView1.FindControl("cboStatus");
            //   RequiredFieldValidator RequiredFieldValidatorReturnReason = (RequiredFieldValidator)DetailsView2.FindControl("RequiredFieldValidatorReturnReason");
            if (cboStatus.SelectedItem.Value == "REJECT" && ExHouseCode == "Ria API")
            {
                txtReason.Visible = true;
            }
            else
            {
                txtReason.Visible = false;
               // cboStatus.SelectedValue = "ACTIVE";
            }
            modal.Show();
            txtReason.Text = "";
        }

        protected void GridView2_DataBound(object sender, EventArgs e)
        {
            if (GridView2.Rows.Count > 0)
            {
                int AmountCol = 3;


                for (int c = 0; c < GridView2.Columns.Count; c++)
                    if (GridView2.HeaderRow.Cells[c].Text.Contains("Amount"))
                        AmountCol = c;

                double TotalAmount = 0;
                for (int i = 0; i < GridView2.Rows.Count; i++)
                {
                    TotalAmount += double.Parse(GridView2.Rows[i].Cells[AmountCol].Text);
                }
                GridView2.FooterRow.Cells[AmountCol].Text = string.Format("{0:N2}", TotalAmount);
                GridView2.FooterRow.Cells[AmountCol].HorizontalAlign = HorizontalAlign.Right;

                //Hide Cells
                for (int c = 6; c < GridView2.Columns.Count; c++)
                {
                    bool isEmpty = true;
                    for (int r = 0; r < GridView2.Rows.Count; r++)
                    {
                        if (GridView2.Rows[r].Cells[c].Text.Trim() != "&nbsp;")
                        {
                            isEmpty = false;
                        }
                    }

                    if (isEmpty)
                        GridView2.Columns[c].Visible = false;

                }
            }
        }

        protected void SqlDataSource1_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            hidRoutingMsg.Value = Msg;
            //SqlDataSource1.DataBind();
        }

        protected void SqlDataSource3_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            hidRoutingMsg.Value = Msg;
            FocusControl = string.Format("{0}", e.Command.Parameters["@FocusControl"].Value);
            RemittanceUpdated = (bool)e.Command.Parameters["@Done"].Value;

            //TrustControl1.ClientMsg(Msg);
        }

        protected void SqlDataSource3_Updating(object sender, SqlDataSourceCommandEventArgs e)
        {
            long RID = long.Parse(DetailsView1.DataKey["ID"].ToString());
            string ExHouseCode = ((Label)DetailsView1.FindControl("lblExHouseCode")).Text;
            DropDownList cboStatus = (DropDownList)DetailsView1.FindControl("cboStatus");
            string status = "";
            TextBox txtReason = (TextBox)DetailsView1.FindControl("txtReason");
            // string status = cboStatus.SelectedValue.ToString();

            if (cboStatus.SelectedValue.ToString() == "REJECT" && ExHouseCode == "Ria API")
            {
                if (txtReason.Text.Trim() == "")
                {
                    e.Cancel = true;
                    RemittanceUpdated = false;
                    TrustControl1.ClientMsg("Please enter Reason.");
                    txtReason.Focus();
                    txtReason.BorderColor = System.Drawing.Color.Red;
                    //DetailsView2.ChangeMode(DetailsViewMode.Edit);
                    //DetailsView2.DefaultMode = DetailsViewMode.Edit;                  

                    modal.Show();
                    //  return;
                }
                if (RIDStatus(RID))
                {
                    RiaFxWebService.RiaFxGlobalService fxService = new RiaFxWebService.RiaFxGlobalService();
                    status = fxService.BD_InputOrderStatusNoticesCancelToRia(Session["BRANCHID"].ToString().PadLeft(4, '0'), Session["BRANCHNAME"].ToString(), RID, Session["EMPID"].ToString(), "REJECTED", txtReason.Text, getValueOfKey("Ria_KeyCode"));

                    if (status == "1")
                    {
                        TrustControl1.ClientMsg("Remittance ID " + RID.ToString() + " has been Rejected at Ria end Successfully.");
                        // gdvOrderStatus.DataBind();
                    }
                    else
                    {
                        TrustControl1.ClientMsg("Remittance ID " + RID.ToString() + " failed to mark Reject at Ria end.");
                        e.Cancel = true;
                    }
                }
                else
                {
                    TrustControl1.ClientMsg("Remittance ID " + RID.ToString() + " is not possible to Reject. Please check the Status.");
                    e.Cancel = true;
                }
            }


        }

        public bool RIDStatus(long RID)
        {

            bool Done = false;
            try
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_RiaRIDStatus";//***
                    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@RID", System.Data.SqlDbType.BigInt).Value = RID;


                        SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
                        sqlDone.Direction = ParameterDirection.InputOutput;
                        sqlDone.Value = 0;
                        cmd.Parameters.Add(sqlDone);


                        cmd.Connection = conn;
                        conn.Open();

                        cmd.ExecuteNonQuery();


                        Done = (bool)sqlDone.Value;



                    }

                }
            }
            catch (Exception ex)
            {
                Done = false;
            }

            return Done;
        }

        protected void cmdPublish_Click(object sender, EventArgs e)
        {
            SqlDataSource_RemiList_Batch_Publish.Select(DataSourceSelectArguments.Empty);
        }
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ServiceLockStatus objLockStatus = new ServiceLockStatus();
            try
            {
                objLockStatus = Common.CheckServiceLockStatus("Ria API", "BD_GetCancelationRequests", Session["EMPID"].ToString());
                if (!objLockStatus.Running)
                {
                    RiaFxWebService.RiaFxGlobalService fxService = new RiaFxWebService.RiaFxGlobalService();
                    string downloadStatus = fxService.BD_GetCancelationRequests(Session["BRANCHID"].ToString().PadLeft(4, '0'), Session["BRANCHNAME"].ToString(), Session["EMPID"].ToString(), getValueOfKey("Ria_KeyCode"));
                    if (downloadStatus == "1")
                        TrustControl1.ClientMsg("Cancel Pending Orders Downloaded Successfully.");
                    else if (downloadStatus == "5")
                        TrustControl1.ClientMsg("Have no Cancel Pending Orders for Downloading.");
                    else
                        TrustControl1.ClientMsg("Cancel Pending Orders Download Failed. Please try again..");
                    hidLastCancelDate.Value = DateTime.Now.ToString();
                }
                else
                    TrustControl1.ClientMsg(objLockStatus.Msg);
            }
            catch (Exception ex)
            { Common.WriteLog("", "Ria API", "BD_GetCancelationRequests UI", ex.Message); }
            finally
            {
                Common.UpdateServiceLockStatus("Ria API", "BD_GetCancelationRequests", Session["EMPID"].ToString());
            }
        }
        public string getValueOfKey(string KeyName)
        {
            try
            {
                return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
            }
            catch (Exception) { return string.Empty; }
        }

        protected void btnPaid_Click(object sender, EventArgs e)
        {

            if (!(DateTime.Parse(hidLastCancelDate.Value == "" ? "1990-01-01" : hidLastCancelDate.Value).AddMinutes(1) >= DateTime.Now))
            {
                TrustControl1.ClientMsg("Please Cancel first then Paid & Publish");
                return;
            }
            ServiceLockStatus objLockStatus = new ServiceLockStatus();
            try
            {
                objLockStatus = Common.CheckServiceLockStatus("Ria API", "BD_InputOrderStatusNoticesPaidPublish", Session["EMPID"].ToString());
                if (!objLockStatus.Running)
                {
                    //Incentive Fx-Rate Check
                    string strcon = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;
                    SqlConnection conn = new SqlConnection(strcon);
                    conn.Open();
                    SqlCommand cmd = new SqlCommand();
                    cmd.Connection = conn;
                    cmd.CommandText = "s_Incentice_FxRate_Check";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Batch", Request.QueryString["batch"].ToString());                   

                    SqlParameter sql_Msg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
                    sql_Msg.Direction = ParameterDirection.InputOutput;
                    sql_Msg.Value = "";
                    cmd.Parameters.Add(sql_Msg);

                    SqlParameter sql_Done = new SqlParameter("@Done", SqlDbType.Bit);
                    sql_Done.Direction = ParameterDirection.InputOutput;
                    sql_Done.Value = false;
                    cmd.Parameters.Add(sql_Done);

                    cmd.ExecuteNonQuery();

                    string msg = sql_Msg.Value.ToString();
                    bool Done = (bool)sql_Done.Value;
                    if (!Done)
                    {
                        TrustControl1.ClientMsg(msg);
                        return;
                    }

                    //Ria
                    RiaFxWebService.RiaFxGlobalService fxService = new RiaFxWebService.RiaFxGlobalService();
                    string downloadStatus = fxService.BD_InputOrderStatusNoticesPaidPublish(Session["BRANCHID"].ToString().PadLeft(4, '0'), Session["BRANCHNAME"].ToString(), int.Parse(Request.QueryString["batch"]), Session["EMPID"].ToString(), getValueOfKey("Ria_KeyCode"));
                    if (downloadStatus == "1")
                    {
                        //TrustControl1.ClientMsg("Batch No# " + Request.QueryString["batch"].ToString() + " has been Paid & Published Successfully.");
                        Response.Redirect("ShowBatch.aspx?batch=" + Request.QueryString["batch"].ToString() + "", true);
                    }
                    //else if (downloadStatus == "2")
                    //    TrustControl1.ClientMsg("Have no Cancel Pending Orders for Downloading.");
                    else
                        TrustControl1.ClientMsg("Batch No# " + Request.QueryString["batch"] + " has been Paid & Published  Failed. Please try again..");
                }
                else
                    TrustControl1.ClientMsg(objLockStatus.Msg);
            }
            catch (Exception ex)
            { Common.WriteLog("", "Ria API", "BD_GetCancelationRequests UI", ex.Message); }
            finally
            {
                Common.UpdateServiceLockStatus("Ria API", "BD_InputOrderStatusNoticesPaidPublish", Session["EMPID"].ToString());
            }
        }


        protected void SqlDataSource_RemiList_Batch_Publish_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            GridView1.DataBind();
            TrustControl1.ClientMsg(string.Format("{0}", e.Command.Parameters["@Msg"].Value));
        }

        protected void GridView1_RowUpdated(object sender, GridViewUpdatedEventArgs e)
        {
            if (hidRoutingMsg.Value != "")
            {
                e.KeepInEditMode = true;
                TrustControl1.ClientMsg(hidRoutingMsg.Value);
            }
        }

        protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
        {
            ((Label)GridView1.Rows[e.NewEditIndex].Cells[0].FindControl("lblSL")).Visible = false;
        }

        protected void SqlDataSourceCancel_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            TrustControl1.ClientMsg(e.Command.Parameters["@Msg"].Value.ToString());
            GridView1.DataBind();
            GridView2.DataBind();
        }

        public bool isRowEditable(object _Paid, object _Published, object _ExHouse_Type)
        {
            if (_ExHouse_Type.ToString() == "W") return false;

            bool Paid = (bool)_Paid;
            bool Published = (bool)_Published;

            if (!Paid && TrustControl1.isRole("ADMIN")
                ||
                !Paid && !Published && TrustControl1.isRole("UPLOAD")
                )
                return true;

            return false;
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

        protected void DetailsView1_ModeChanged(object sender, EventArgs e)
        {
            //modal.Show();
        }



        protected void DetailsView1_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
        {
            if (hidRoutingMsg.Value != "" || !RemittanceUpdated)
            {
                e.KeepInEditMode = true;
                if (FocusControl != "")
                    TrustControl1.ClientMsg(hidRoutingMsg.Value, DetailsView1.FindControl(FocusControl));
                else
                    TrustControl1.ClientMsg(hidRoutingMsg.Value);
                modal.Show();
            }
            else
            {
                //Cache["ShowBatchCacheKey"] = DateTime.Now;
                GridView1.DataBind();
                GridView3.DataBind();                
            }

            if (RemittanceUpdated) modal.Hide();
        }
        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
           // modal.Show();
        }

        protected void GridView1_PageIndexChanged(object sender, EventArgs e)
        {
            GridView1.SelectedIndex = -1;
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.ToUpper() == "SELECT")
            {
                DetailsView1.ChangeMode(DetailsViewMode.Edit);
                DetailsView1.DataBind();

                try
                {
                    ((TextBox)DetailsView1.FindControl("txtRoutingNumber")).Focus();
                }
                catch (Exception) { }

                modal.Show();
                return;
            }

            string Status = "";
            
            if (e.CommandName.ToUpper() == "A")
            {
                Status = "ACTIVE";
            }
            else if (e.CommandName.ToUpper() == "H")
            {
                Status = "ON HOLD";
            }
            else if (e.CommandName.ToUpper() == "C")
            {
                Status = "CANCEL";
            }
            else { return; }



            try
            {
                string strcon = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;
                SqlConnection conn = new SqlConnection(strcon);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandText = "sp_RemiList_Update_Status";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ID", e.CommandArgument.ToString());
                cmd.Parameters.AddWithValue("@ModifyBy", Session["EMPID"].ToString());
                cmd.Parameters.AddWithValue("@Status", Status);

                SqlParameter sql_Msg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
                sql_Msg.Direction = ParameterDirection.InputOutput;
                sql_Msg.Value = "";
                cmd.Parameters.Add(sql_Msg);

                cmd.ExecuteNonQuery();
                
                string msg = sql_Msg.Value.ToString();
                if (msg.Trim().Length > 0)
                    TrustControl1.ClientMsg(msg);
                GridView1.DataBind();
            }
            catch (Exception exx)
            {
                TrustControl1.ClientMsg(exx.Message.ToString());
            }

        }

        protected void DetailsView1_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
        {
            
        }

        protected void btn_ToBrancgUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                Int32 ToBranchID =Convert.ToInt32(cboToBranchUpdate.SelectedValue.ToString());
                
                //string strcon = ConfigurationSettings.AppSettings["RemittanceConnectionString"].ToString();// ConfigurationSettings.AppSettings["MyConstring"];
                string strcon = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;
                SqlConnection conn = new SqlConnection(strcon);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandText = "s_Remilist_ToBranch_Update";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("ToBranch",ToBranchID);
                cmd.Parameters.AddWithValue("Batch",txtBatch.Text);
                cmd.Parameters.AddWithValue("EmpID", Session["EMPID"].ToString());
                string numberOfRecords =Convert.ToString(cmd.ExecuteNonQuery());
                cmd.Dispose();
                string msg = numberOfRecords + " Rows Update Successfully.";
                TrustControl1.ClientMsg(msg);
                GridView1.DataBind();
            }
            catch(Exception exx)
            {
                TrustControl1.ClientMsg(exx.Message.ToString());
            }
        }

        protected void GridView1_Sorted(object sender, EventArgs e)
        {
           
        }

        protected void GridView1_Sorting(object sender, GridViewSortEventArgs e)
        {
            GridView1.SelectedIndex = -1;
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            System.Threading.Thread.Sleep(5000);
            modal.Show();
        }

        protected void GridView3_DataBound(object sender, EventArgs e)
        {
            double[] AL = new double[GridView3.Columns.Count];

            for (int r = 0; r < GridView3.Rows.Count; r++)
            {
                for (int c = 1; c < AL.Length; c++)
                {
                    AL[c] += double.Parse(GridView3.Rows[r].Cells[c].Text.Replace(",", ""));

                    if (c == 2 || c == 4 || c == 6 || c == 8 || c == 10 || c == 12 || c == 14 || c == 16 || c == 18)
                        GridView3.FooterRow.Cells[c].Text = string.Format("{0:N2}", AL[c]);
                    else
                        GridView3.FooterRow.Cells[c].Text = string.Format("{0:N0}", AL[c]);
                }
            }
        }

        protected void lnkUpdateRouting_Click(object sender, EventArgs e)
        {
            try
            {                
                string strcon = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;
                SqlConnection conn = new SqlConnection(strcon);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandText = "s_Batch_RoutingNumber_Update";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Batch", txtBatch.Text);
                cmd.Parameters.AddWithValue("@EmpID", Session["EMPID"].ToString());
                string numberOfRecords = Convert.ToString(cmd.ExecuteNonQuery());
                cmd.Dispose();
                string msg = numberOfRecords + " Rows Updated Successfully.";
                TrustControl1.ClientMsg(msg);
                GridView1.DataBind();
            }
            catch (Exception exx)
            {
                TrustControl1.ClientMsg(exx.Message.ToString());
            }
        }

        protected void btn_ChangeStatus_Click(object sender, EventArgs e)
        {
            try
            {
                string Status = cboStatusChange.SelectedItem.Value.ToString();

                if (Status.Length == 0) return;
                
                string strcon = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;
                SqlConnection conn = new SqlConnection(strcon);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandText = "s_Remilist_Batch_Update_Status";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("Status", Status);
                cmd.Parameters.AddWithValue("Batch", txtBatch.Text);
                cmd.Parameters.AddWithValue("EmpID", Session["EMPID"].ToString());
                string numberOfRecords = Convert.ToString(cmd.ExecuteNonQuery());
                cmd.Dispose();
                string msg = "Updated Successfully.";
                TrustControl1.ClientMsg(msg);
                GridView1.DataBind();
            }
            catch (Exception exx)
            {
                TrustControl1.ClientMsg(exx.Message.ToString());
            }
        }

}
    //public struct ServiceLockStatus
    //{
    //    public bool Running { get; set; }
    //    public string Msg { get; set; }
    //}
}