using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Remittance
{
    public partial class Remittance_Show : System.Web.UI.Page
    {
        string FocusControl = "";
        bool RemittanceUpdated = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");
            if (TrustControl1.getUserRoles(false) == "")
            {
                Response.End();
            }
            else
            {
                TrustControl1.LoadEmpToSession(false);
                string RID = string.Format("{0}", Request.QueryString["id"]);

                if (RID == "")
                {
                    lblTitle.Text = this.Title = "Goto Remittance";
                    PanelRemittance.Visible = false;
                    PanelIncentive.Visible = false;
                }
                else
                {
                    lblTitle.Text = string.Format("Remittance ID: {0}", RID);
                    hypPrintReceipt.NavigateUrl = string.Format("Print_Receipt.aspx?id={0}", Request.QueryString["id"]);
                    this.Title = string.Format("RID # {0}", RID);

                    GridView1.DataBind();
                    GridView2.DataBind();
                }
            }

            if (!IsPostBack)
            {
                string focusScript = "document.getElementById('" + txtRID.ClientID + "').focus();";
                TrustControl1.ClientScriptStartup("setTimeout(\"" + focusScript + ";\",200);");
            }

            //string focusScript = "document.getElementById('" + txtComment.ClientID + "').focus();";
            //TrustControl1.ClientScriptStartup("setTimeout(\"" + focusScript + ";\",200);");
        }

        public bool isRowEditable(object _Paid, object _Published)
        {
            bool Paid = (bool)_Paid;
            bool Published = (bool)_Published;

            if (!Paid && TrustControl1.isRole("ADMIN")
                ||
                !Paid && !Published && TrustControl1.isRole("UPLOAD")
                )
                return true;

            return false;
        }

        protected void DetailsView2_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
        {
            //hidRoutingMsg.Value != ""
            if (!RemittanceUpdated)
            {
                e.KeepInEditMode = true;
                if (FocusControl != "")
                {
                    TrustControl1.ClientMsg(hidRoutingMsg.Value, DetailsView2.FindControl(FocusControl));
                }
                else
                {
                    if (hidRoutingMsg.Value != "")
                        TrustControl1.ClientMsg(hidRoutingMsg.Value);
                    DetailsView1.Visible = false;
                    DetailsView2.Visible = true;
                }
            }
            else
            {
                DetailsView1.Visible = true;
                DetailsView2.Visible = false;
            }
            //else
            //{
            //    //Cache["ShowBatchCacheKey"] = DateTime.Now;
            //    GridView1.DataBind();
            //    GridView3.DataBind();
            //}

            ////-------------
            //if (!RemittanceUpdated)
            //{       
            //    e.KeepInEditMode = true; 
            //}

            //if (FocusControl.Length > 0)
            //{                    
            //    DetailsView2.ChangeMode(DetailsViewMode.Edit);
            //    TrustControl1.ClientMsg(hidRoutingMsg.Value, DetailsView2.FindControl(FocusControl));
            //}
            //else
            //{
            //    if (hidRoutingMsg.Value.Length > 0)
            //        TrustControl1.ClientMsg(hidRoutingMsg.Value);
            //    DetailsView1.Visible = true;
            //    DetailsView2.Visible = false;                    
            //}

            DataListHistory.DataBind();
            DetailsView1.DataBind();
        }        

        protected void SqlDataSource1_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            hidRoutingMsg.Value = Msg;
            FocusControl = string.Format("{0}", e.Command.Parameters["@FocusControl"].Value);
            RemittanceUpdated = (bool)e.Command.Parameters["@Done"].Value;
            //TrustControl1.ClientMsg(Msg);            
        }

        protected void cboStatus_OnDataBound(object sender, EventArgs e)
        {
            TextBox txtReason = (TextBox)DetailsView2.FindControl("txtReason");
            string ExHouseCode = ((Label)DetailsView2.FindControl("lblExHouseCode")).Text;
            DropDownList cboStatus = (DropDownList)DetailsView2.FindControl("cboStatus");
            //   RequiredFieldValidator RequiredFieldValidatorReturnReason = (RequiredFieldValidator)DetailsView2.FindControl("RequiredFieldValidatorReturnReason");
            if (cboStatus.SelectedItem.Value == "REJECT" && ExHouseCode == "Ria API")
            {
                txtReason.Visible = true;
                // RequiredFieldValidatorReturnReason.Enabled = true;
            }

        }

        protected void cboStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            TextBox txtReason = (TextBox)DetailsView2.FindControl("txtReason");
            string ExHouseCode = ((Label)DetailsView2.FindControl("lblExHouseCode")).Text;
            DropDownList cboStatus = (DropDownList)DetailsView2.FindControl("cboStatus");
            //   RequiredFieldValidator RequiredFieldValidatorReturnReason = (RequiredFieldValidator)DetailsView2.FindControl("RequiredFieldValidatorReturnReason");
            if (cboStatus.SelectedItem.Value == "REJECT" && ExHouseCode == "Ria API")
            {
                txtReason.Visible = true;
                // RequiredFieldValidatorReturnReason.Enabled = true;
            }
            else
            {
               // cboStatus.SelectedValue = "ACTIVE";
                txtReason.Visible = false;
            }
                txtReason.Text = "";
        }

        protected void SqlDataSource1_Updating(object sender, SqlDataSourceCommandEventArgs e)
        {
            long RID = long.Parse(DetailsView2.DataKey["ID"].ToString());
            string ExHouseCode = ((Label)DetailsView2.FindControl("lblExHouseCode")).Text;
            DropDownList cboStatus = (DropDownList)DetailsView2.FindControl("cboStatus");
            TextBox txtReason = (TextBox)DetailsView2.FindControl("txtReason");
            string status = "";
           // string status = cboStatus.SelectedValue.ToString();

            if (cboStatus.SelectedValue.ToString() == "REJECT" && ExHouseCode == "Ria API")
            {
                if (txtReason.Text.Trim() == "")
                {
                    RemittanceUpdated = false;
                    TrustControl1.ClientMsg("Please enter Reason.");
                    txtReason.Focus();
                    txtReason.BorderColor = System.Drawing.Color.Red;
                    //DetailsView2.ChangeMode(DetailsViewMode.Edit);
                    //DetailsView2.DefaultMode = DetailsViewMode.Edit;
                    e.Cancel = true;
                }
                if (RIDStatus(RID))
                {
                    RiaFxWebService.RiaFxGlobalService fxService = new RiaFxWebService.RiaFxGlobalService();
                    status = fxService.BD_InputOrderStatusNoticesCancelToRia(Session["BRANCHID"].ToString().PadLeft(4, '0'), Session["BRANCHNAME"].ToString(), RID, Session["EMPID"].ToString(), "REJECTED", txtReason.Text.Trim(), getValueOfKey("Ria_KeyCode"));

                    if (status == "1")
                    {
                        TrustControl1.ClientMsg("Remittance ID " + RID.ToString() + " has been Rejected at Ria end Successfully.");
                        gdvOrderStatus.DataBind();
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

        public string getValueOfKey(string KeyName)
        {
            try
            {
                return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
            }
            catch (Exception) { return string.Empty; }
        }

        protected void cmdPay_Click(object sender, EventArgs e)
        {
            SqlDataSourcePay.Select(DataSourceSelectArguments.Empty);
        }
        
        protected void SqlDataSourceOrderStatus_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            LabelOrderStatus.Text = string.Format("Total Order Status: <b>{0:N0}</b>", e.AffectedRows);
            if (e.AffectedRows > 0)
            panelNotice.Visible =true;
            else
                panelNotice.Visible = false;
        }
        protected void SqlDataSourceReqResp_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            LabelReqResp.Text = string.Format("Total Cancel Req Response: <b>{0:N0}</b>", e.AffectedRows);
            if (e.AffectedRows > 0)
                panelCancel.Visible = true;
            else
                panelCancel.Visible = false;
        }

        protected void SqlDataSourceTfCancelReq_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            LabelTfCancelReq.Text = string.Format("Total Cancel Request: <b>{0:N0}</b>", e.AffectedRows);
            if (e.AffectedRows > 0)
                panelTfCancelReq.Visible = true;
            else
                panelTfCancelReq.Visible = false;
        }

        protected void cmdRemiEdit_Click(object sender, EventArgs e)
        {
            DetailsView1.Visible = false;
            DetailsView2.Visible = true;
            DetailsView2.ChangeMode(DetailsViewMode.Edit);
            try
            {
                ((TextBox)DetailsView2.FindControl("txtRoutingNumber")).Focus();
            }
            catch (Exception) { }
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

        protected void SqlDataSourcePay_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            if ((bool)(e.Command.Parameters["@Done"].Value) == true)
            {

                cmdPay.Enabled = false;
                txtInstumentNo.Enabled = false;
                DetailsView1.DataBind();
                cmdView_Pay.Visible = false;
                cmdView_Comment_Click(sender, e);
            }
            lblStatus.Text = string.Format("<span style='padding:3px 15px 3px 15px;background-color:Yellow;border:solid 1px black'>{0}</span><br />", e.Command.Parameters["@Msg"].Value);

            //TabContainer1.Focus();
        }

        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            if (e.AffectedRows == 0)
            {
                MultiView1.Visible = false;
                cmdView_Comment.Visible = false;
                PanelHistory.Visible = false;
                PanelPaymentHistory.Visible = false;
                PanelStatus.Visible = false;
            }
        }

        protected void DetailsView1_DataBound(object sender, EventArgs e)
        {
            DetailsViewIncentive.DataBind();

            if (DetailsView1.Rows.Count < 3)
            {
                cmdView_Comment.Visible = false;
                cmdView_Pay.Visible = false;
                cmdView_HoForwarding.Visible = false;
                cmdView_Forwarding.Visible = false;
                cmdView_Unpaid.Visible = false;
                cmdView_Return.Visible = false;
                return;
            }

            string ToBranch = "";
            bool Paid = false;
            string Status = "";
            bool hasRoutingNumber = false;
            bool Published = false;
            string CommentStatus = "";
            //string Flora_IC_BatchID = "";
            string PaymentMethod = "";
            string RoutingNumber = "";
            bool AllowPayment = false;
            DateTime PaidOn;

            ToBranch = string.Format("{0}", DataBinder.Eval(DetailsView1.DataItem, "ToBranch"));
            Paid = (bool)DataBinder.Eval(DetailsView1.DataItem, "Paid");
            Published = (bool)DataBinder.Eval(DetailsView1.DataItem, "Published");
            Status = string.Format("{0}", DataBinder.Eval(DetailsView1.DataItem, "Status"));
            PaymentMethod = string.Format("{0}", DataBinder.Eval(DetailsView1.DataItem, "PaymentMethod"));
            RoutingNumber = string.Format("{0}", DataBinder.Eval(DetailsView1.DataItem, "RoutingNumber"));
            CommentStatus = string.Format("{0}", DataBinder.Eval(DetailsView1.DataItem, "CommentStatus"));
            AllowPayment = (bool)DataBinder.Eval(DetailsView1.DataItem, "AllowPayment");
            
            //Flora_IC_BatchID = string.Format("{0}", DataBinder.Eval(DetailsView1.DataItem, "Flora_IC_BatchID"));

            try
            {
                PaidOn = (DateTime)DataBinder.Eval(DetailsView1.DataItem, "PaidOn");
                if (PaidOn.Date == DateTime.Now.Date) PanelPaidToday.Visible = true;
            }
            catch (Exception) { }

            if (RoutingNumber.Trim().Length > 0)
                hasRoutingNumber = true;

            for (int i = 0; i < DetailsView1.Rows.Count; i++)
            {
                //if (DetailsView1.Rows[i].Cells[0].Text == "To Branch")            
                //    ToBranch = DetailsView1.Rows[i].Cells[1].Text;                   

                //if (DetailsView1.Rows[i].Cells[0].Text == "Paid")
                //    Paid = ((CheckBox)DetailsView1.Rows[i].Cells[1].Controls[0]).Checked;

                //if (DetailsView1.Rows[i].Cells[0].Text == "Published")
                //{
                //    Published = ((CheckBox)DetailsView1.Rows[i].Cells[1].Controls[0]).Checked;
                //    if(Session["BRANCHID"].ToString() != "1")
                //        DetailsView1.Rows[i].Visible = false;
                //}

                //if (DetailsView1.Rows[i].Cells[0].Text == "Status")
                //    Status = DetailsView1.Rows[i].Cells[1].Text;

                //if (DetailsView1.Rows[i].Cells[0].Text == "Routing Code")
                //{
                //    hasRoutingNumber = ((BEFTN)DetailsView1.Rows[i].Cells[1].FindControl("BEFTN1")).Code.Length > 0;
                //}

                //if (DetailsView1.Rows[i].Cells[0].Text == "Comment Status")
                //{
                //    CommentStatus = DetailsView1.Rows[i].Cells[1].Text.Trim();                
                //    DetailsView1.Rows[i].Visible = false;
                //}

                //if (DetailsView1.Rows[i].Cells[0].Text == "Flora IC BatchID")
                //{
                //    Flora_IC_BatchID = DetailsView1.Rows[i].Cells[1].Text.Replace("&nbsp;", "").Trim();                
                //    DetailsView1.Rows[i].Visible = false;
                //}

                if (DetailsView1.Rows[i].Cells[0].Text == "Allow Payment" && Paid)
                {
                    DetailsView1.Rows[i].Visible = false;
                }
            }

            RefreshTabs(ToBranch, Paid, AllowPayment, Status, hasRoutingNumber, Published, CommentStatus, PaymentMethod.ToUpper(), DetailsView1.Rows.Count);
            
            //Hide Emply Rows
            for (int r = 0; r < DetailsView1.Rows.Count; r++)
            {
                if (DetailsView1.Rows[r].Cells.Count > 1)
                {
                    if (!DetailsView1.Rows[r].Cells[1].HasControls())
                    {
                        //DetailsView1.Rows[r].Cells[0].Text += "|" + DetailsView1.Rows[r].Cells[1].Text + "|";
                        if (DetailsView1.Rows[r].Cells[1].Text.Trim().Replace("&nbsp;", "").Replace("(", "").Replace(")", "").Replace(" ", "") == string.Empty)
                            DetailsView1.Rows[r].Visible = false;
                    }
                    else
                    {
                        try
                        {
                            string HeaderText = DetailsView1.Rows[r].Cells[0].Text;

                            if (((DataBoundLiteralControl)(DetailsView1.Rows[r].Cells[1].Controls[0])).Text.Trim().Replace("&nbsp;", "").Replace("\r\n", "").Replace(" ", "").Replace("()", "") == string.Empty)
                                DetailsView1.Rows[r].Visible = false;
                        }
                        catch (Exception) { }
                        try
                        {
                            if (((EMP)(DetailsView1.Rows[r].Cells[1].Controls[1])).Username == "")
                                DetailsView1.Rows[r].Visible = false;
                        }
                        catch (Exception) { }
                        try
                        {
                            if (((BEFTN)(DetailsView1.Rows[r].Cells[1].Controls[1])).Code == "")
                                DetailsView1.Rows[r].Visible = false;
                        }
                        catch (Exception) { }
                    }
                    //DetailsView1.Rows[r].Cells[0].Text += ">" + DetailsView1.Rows[r].Cells[1].Text.Trim().Replace("&nbsp;","") + "<";
                }
            }

            if (DetailsView1.Rows.Count == 1)
            {
                MultiView1.Visible = false;
                GridView1.Visible = false;
            }
        }

        private void RefreshTabs(string ToBranch,
            bool Paid,
            bool AllowPayment,
            string Status,
            bool hasRoutingNumber,
            bool Published,
            string CommentStatus,
            string PaymentMethod,
            int Rows)
        {
            if (!IsPostBack)
            {
                txtInstrumentDate.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);
                lblRefReport1.Text = string.Format("ID/REM/{0}/", DateTime.Now.Year);
                lblRefReport2.Text = string.Format("TBL/{1}/FX/REM/{0}/", DateTime.Now.Year, Session["BranchPrefix"]);

                if (PaymentMethod == "FDD" || PaymentMethod == "PO")
                {
                    IdTypeTr.Visible = false;
                    IdNumberTr.Visible = false;
                    IdExpiryDateTr.Visible = false;
                    RemittancePinTr.Visible = false;
                }
            }

            if ((ToBranch == Session["BRANCHID"].ToString() //Same Branch
                || ToBranch == "0")
                && !Paid     //Not Paid
                && Status == "ACTIVE"
                && Published
                )
            {
                cmdPay.Enabled = true;
                txtInstumentNo.Enabled = true;
                cmdView_Pay.Visible = false;
                cmdView_Return.Visible = false;
            }

            //Remittance Payment
            cmdView_Pay.Visible = ((ToBranch == Session["BRANCHID"].ToString()
                || ToBranch == "0")
                && !Paid && Status == "ACTIVE"
                && !hasRoutingNumber
                && PaymentMethod != ""
                //&& (PaymentMethod == "IC" 
                //    || PaymentMethod == "FDD"
                //    || PaymentMethod == "PO"
                //    )
                && Published
                && AllowPayment);

            //HO Forwarding
            cmdView_HoForwarding.Visible = ((ToBranch == Session["BRANCHID"].ToString()
                || ToBranch == "0")
                && Paid
                && ToBranch == "1"
                && Published);

            //Forwarding
            cmdView_Forwarding.Visible = ((ToBranch == Session["BRANCHID"].ToString()
                || ToBranch == "0")
                && Paid
                && ToBranch != "1"
                && Published);

            //Unpaid
            cmdView_Unpaid.Visible = Paid
                && Session["BRANCHID"].ToString() == "1";

            PanelPrintReceipt.Visible = Paid;

            //Return            
            cmdView_Return.Visible = (Paid
                && Session["BRANCHID"].ToString() == "1"  && PaymentMethod=="BEFTN");

            PanelPrintReceipt.Visible = Paid;

            if (Status == "CANCEL")
            {
                //DetailsView1.ForeColor = System.Drawing.Color.White;
                DetailsView1.BackColor = System.Drawing.Color.Tomato;
            }
            else if (Status == "ON HOLD")
            {
                //DetailsView1.ForeColor = System.Drawing.Color.White;
                DetailsView1.BackColor = System.Drawing.Color.CadetBlue;
            }
            else if (Status == "RETURN")
            {
                //DetailsView1.ForeColor = System.Drawing.Color.White;
                DetailsView1.BackColor = System.Drawing.Color.Goldenrod;
            }
            else if (Status == "REJECT")
            {
                //DetailsView1.ForeColor = System.Drawing.Color.White;
                DetailsView1.BackColor = System.Drawing.Color.Teal;
            }

            if (!Published)
            {
                DetailsView1.BackColor = System.Drawing.Color.SlateGray;
                PanelStatus.Visible = true;
                lblRemittanceStatus.Text = "Remittance is not published.";

                if (Rows < 3) PanelStatus.Visible = false;


                if (Session["BRANCHID"].ToString() != "1")
                {
                    MultiView1.Visible = false;
                    cmdView_Comment.Visible = false;
                    cmdView_Return.Visible = false;
                    PanelHistory.Visible = false;
                    PanelPaymentHistory.Visible = false;
                    DetailsView1.Visible = false;
                }
            }
            if (Session["BRANCHID"].ToString() != "1")
            {
                PanelCommentStatus.Visible = false;
                lblCommentStatus.Visible = false;
            }
            lblCommentStatus.Text = string.Format("(Status: {0})", CommentStatus);
        }

        private void UnselectAllTabs()
        {
            cmdView_Comment.CssClass = "ViewTitle";
            cmdView_Pay.CssClass = "ViewTitle";
            cmdView_HoForwarding.CssClass = "ViewTitle";
            cmdView_Forwarding.CssClass = "ViewTitle";
            cmdView_Unpaid.CssClass = "ViewTitle";
            cmdView_Return.CssClass = "ViewTitle";
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            //MultiView1.ActiveViewIndex = 0;
        }

        protected void cmdCancel_Click(object sender, EventArgs e)
        {
            DetailsView1.Visible = true;
            DetailsView2.Visible = false;
        }

        protected void cmdCommentPost_Click(object sender, EventArgs e)
        {
            if (txtComment.Text.Trim().Length == 0)
            {
                txtComment.Text = "";
                TrustControl1.ClientMsg("Please enter comment to post.");
                return;
            }

            SqlDataSourceComment.Select(DataSourceSelectArguments.Empty);
            GridView1.DataBind();
            GridView2.DataBind();
            DetailsView1.DataBind();
            txtComment.Text = "";

            cmdView_Comment_Click(sender, e);
        }

        protected void SqlDataSourceComment_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            TrustControl1.ClientMsg("Successfully Comment Added.");
        }

        protected void cmdReport1_Click(object sender, EventArgs e)
        {
            Response.Redirect("CR_BR1.aspx?id=1", true);
            Response.End();
        }

        protected void cmdReport2_Click(object sender, EventArgs e)
        {

        }

        protected void cmdDownload_Click(object sender, EventArgs e)
        {
            cmdReport1.NavigateUrl = string.Format("~/CR_BR1.aspx?id={0}&ref={1}{2}", Request.QueryString["id"], lblRefReport1.Text, txtReference.Text.Trim());
            cmdReport2.NavigateUrl = string.Format("~/CR_BR2.aspx?id={0}&ref={1}{2}", Request.QueryString["id"], lblRefReport2.Text, txtReference2.Text.Trim());

            txtReference.Enabled = false;
            txtReference2.Enabled = false;
            cmdDownload.Visible = false;
            cmdDownload2.Visible = false;
            cmdReport1.Visible = true;
            cmdReport2.Visible = true;
            cmdChange.Visible = true;
            cmdChange2.Visible = true;
        }

        protected void cmdChange_Click(object sender, EventArgs e)
        {
            txtReference.Enabled = true;
            txtReference2.Enabled = true;
            cmdDownload.Visible = true;
            cmdDownload2.Visible = true;
            cmdReport1.Visible = false;
            cmdReport2.Visible = false;
            cmdChange.Visible = false;
            cmdChange2.Visible = false;
        }

        protected void SqlDataSourcePrintLog_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            PanelPrintLog.Visible = e.AffectedRows > 0;
        }

        protected void cmdRefrestPrintLog_Click(object sender, ImageClickEventArgs e)
        {
            GridView2.DataBind();
        }

        protected void SqlDataSourceComments_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            PanelRefreshComment.Visible = e.AffectedRows > 0;
        }

        protected void cmdRefreshComment_Click(object sender, ImageClickEventArgs e)
        {
            GridView1.DataBind();
        }

        protected void cmdView_Comment_Click(object sender, EventArgs e)
        {
            MultiView1.ActiveViewIndex = 0;
            UnselectAllTabs();
            cmdView_Comment.CssClass = "ViewTitleSelected";

            string focusScript = "document.getElementById('" + txtComment.ClientID + "').focus();";
            TrustControl1.ClientScriptStartup("setTimeout(\"" + focusScript + ";\",200);");
        }

        protected void cmdView_Pay_Click(object sender, EventArgs e)
        {
            MultiView1.ActiveViewIndex = 1;
            UnselectAllTabs();
            cmdView_Pay.CssClass = "ViewTitleSelected";

            string focusScript = "document.getElementById('" + txtPIN.ClientID + "').focus();";

            if (!RemittancePinTr.Visible)
                focusScript = "document.getElementById('" + txtInstumentNo.ClientID + "').focus();";

            TrustControl1.ClientScriptStartup("setTimeout(\"" + focusScript + ";\",200);");
        }

        protected void cmdView_HoForwarding_Click(object sender, EventArgs e)
        {
            MultiView1.ActiveViewIndex = 2;
            UnselectAllTabs();
            cmdView_HoForwarding.CssClass = "ViewTitleSelected";

            string focusScript = "document.getElementById('" + txtReference.ClientID + "').focus();";
            TrustControl1.ClientScriptStartup("setTimeout(\"" + focusScript + ";\",200);");
        }

        protected void cmdView_Forwarding_Click(object sender, EventArgs e)
        {
            MultiView1.ActiveViewIndex = 3;
            UnselectAllTabs();
            cmdView_Forwarding.CssClass = "ViewTitleSelected";

            string focusScript = "document.getElementById('" + txtReference2.ClientID + "').focus();";
            TrustControl1.ClientScriptStartup("setTimeout(\"" + focusScript + ";\",200);");
        }

        protected void cmdView_Unpaid_Click(object sender, EventArgs e)
        {
            MultiView1.ActiveViewIndex = 4;
            UnselectAllTabs();
            cmdView_Unpaid.CssClass = "ViewTitleSelected";

            string focusScript = "document.getElementById('" + txtUnpaidReason.ClientID + "').focus();";
            TrustControl1.ClientScriptStartup("setTimeout(\"" + focusScript + ";\",200);");
        }

        protected void cmdView_Return_Click(object sender, EventArgs e)
        {
            MultiView1.ActiveViewIndex = 5;
            UnselectAllTabs();
            cmdView_Return.CssClass = "ViewTitleSelected";

            string focusScript = "document.getElementById('" + cboReturn.ClientID + "').focus();";
            TrustControl1.ClientScriptStartup("setTimeout(\"" + focusScript + ";\",200);");
        }

        protected void chkNoExpiryDate_CheckedChanged(object sender, EventArgs e)
        {
            txtIDExpiryDate.Visible = !chkNoExpiryDate.Checked;
        }

        protected void SqlDataSourceRemilistHistory_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            //Visible at only Head Office
            PanelHistory.Visible = (Session["BRANCHID"].ToString() == "1") && e.AffectedRows > 0;
        }

        protected void SqlDataSourceReturnHistory_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            //Visible at only Head Office
            PanelReturnHistory.Visible = (Session["BRANCHID"].ToString() == "1") && e.AffectedRows > 0;
        }

        protected void SqlDataSourcePaymentHistory_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            //Visible at only Head Office
            PanelPaymentHistory.Visible = (Session["BRANCHID"].ToString() == "1") && e.AffectedRows > 0;
        }
        protected void cmdUnpaid_Click(object sender, EventArgs e)
        {
            //TrustControl1.ClientMsg("No Command Assigned.");
            SqlDataSourceUnpaid.Update();
        }
        
        protected void SqlDataSourceUnpaid_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            TrustControl1.ClientMsg(e.Command.Parameters["@Msg"].Value.ToString());
            if ((bool)e.Command.Parameters["@Done"].Value)
            {
                DataListPaymentHistory.DataBind();
                DataListHistory.DataBind();
                DetailsView1.DataBind();
                cmdView_Comment_Click(sender, e);
            }
        }
        protected void cmdReturnReason_Click(object sender, EventArgs e)
        {
            //TrustControl1.ClientMsg("No Command Assigned.");
            SqlDataSourceReturn.Update();
        }
        protected void SqlDataSourceReturn_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            TrustControl1.ClientMsg(e.Command.Parameters["@Msg"].Value.ToString());
            if ((bool)e.Command.Parameters["@Done"].Value)
            {
                DataListPaymentHistory.DataBind();
                DataListHistory.DataBind();
                DetailsView1.DataBind();                
                DataListReturnHistory.DataBind();
                cmdView_Comment_Click(sender, e);
            }
        }
        protected void cmdOK_Click(object sender, EventArgs e)
        {
            if (txtRID.Text.Trim() != "")
            {
                Response.Redirect(string.Format("Remittance_Show.aspx?id={0}", txtRID.Text.Trim()), true);
            }
            else
            {
                string focusScript = "document.getElementById('" + txtRID.ClientID + "').focus();";
                TrustControl1.ClientScriptStartup("setTimeout(\"" + focusScript + ";\",200);");
            }
        }

        public bool FieldToShow(object obj)
        {
            if (obj.ToString() == "") return false;
            else return true;
        }

        protected void SqlDataSourceIncentive_Deleted(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            TrustControl1.ClientMsg(Msg);
        }

        protected void cmdIncentiveMakePayment_Click(object sender, EventArgs e)
        {
            cmdIncentiveMakePayment.Visible = false;
            PanelIncentivePayment.Visible = true;
            txtInstrumentDateI.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
        }

        protected void cmdIncentivePay_Click(object sender, EventArgs e)
        {
            string RID = Request.QueryString["id"].ToString();
            bool Done = false;
            string Msg = "";

            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Incentive_Paid";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RemittanceConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RID", System.Data.SqlDbType.BigInt).Value = RID;
                    cmd.Parameters.AddWithValue("@EmpID", Session["EmpID"]);
                    cmd.Parameters.AddWithValue("@BranchID", Session["BRANCHID"]);
                    cmd.Parameters.AddWithValue("@NID", chkNID.Checked);
                    cmd.Parameters.AddWithValue("@Passport", chkPassport.Checked);
                    cmd.Parameters.AddWithValue("@EmpApoinmentLetter", chkEmpApoinmentLetter.Checked);
                    cmd.Parameters.AddWithValue("@BMETApproval", chkBMETApproval.Checked);
                    cmd.Parameters.AddWithValue("@ResidentPermitCopy", chkResidentPermitCopy.Checked);
                    cmd.Parameters.AddWithValue("@TradeLicense", chkTradeLicense.Checked);
                    cmd.Parameters.AddWithValue("@Instrument", System.Data.SqlDbType.VarChar).Value = txtInstumentNoI.Text.Trim();
                    if (txtInstrumentDateI.Text.Trim().Length > 0)
                        cmd.Parameters.AddWithValue("@InstrumentDate", SqlDbType.DateTime).Value = DateTime.Parse(txtInstrumentDateI.Text);
                    cmd.Parameters.AddWithValue("@IDType", System.Data.SqlDbType.VarChar).Value = txtIDTypeI.Text.Trim();
                    cmd.Parameters.AddWithValue("@IDNumber", System.Data.SqlDbType.VarChar).Value = txtIDNoI.Text.Trim();

                    if (txtIDExpiryDateI.Text.Trim().Length > 0)
                        cmd.Parameters.AddWithValue("@IDExpiryDate", SqlDbType.DateTime).Value = DateTime.Parse(txtIDExpiryDateI.Text);




                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = 0;
                    cmd.Parameters.Add(sqlDone);

                    SqlParameter sqlMsg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
                    sqlMsg.Direction = ParameterDirection.InputOutput;
                    sqlMsg.Value = " ";
                    cmd.Parameters.Add(sqlMsg);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();

                    Done = (bool)sqlDone.Value;
                    Msg = string.Format("{0}", sqlMsg.Value);
                }

            }
            if (Done)
            {
                PanelIncentivePayment.Visible = false;
                DetailsViewIncentive.DataBind();
                cmdIncentiveMakePayment.Visible = false;
                
            }

            TrustControl1.ClientMsg(Msg);
        }

        protected void SqlDataSourceIncentive_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            //cmdIncentiveMakePayment.Visible = (e.AffectedRows == 1);
        }

        protected void DetailsViewIncentive_DataBound(object sender, EventArgs e)
        {
            bool Paid = false;
            try
            {
                Paid = (bool)(DataBinder.Eval(DetailsViewIncentive.DataItem, "Paid"));
                cmdIncentiveMakePayment.Visible = !Paid;
            }
            catch (Exception) { }
            
        }
    }
}