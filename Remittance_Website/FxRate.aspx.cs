﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Remittance
{
    public partial class FxRate : System.Web.UI.Page
    {
        bool Done = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");

            if (TrustControl1.getUserRoles() == "")
            {
                //if (Session["DEPTID"].ToString() != "7")    //Not IT & Cards
                {
                    Response.Write("No Permission.<br><br><a href=''>Home</a>");
                    Response.End();
                }
            }
            this.Title = "Daily FxRate";
        }

        protected void SqlDataSource2_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total : <b>{0:N0}</b>", e.AffectedRows);
        }

        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            if (!TrustControl1.isRole("ADMIN"))
                GridView1.Columns[GridView1.Columns.Count - 1].Visible = false;
        }
        protected void GridView1_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
        {
            DetailsView1.ChangeMode(DetailsViewMode.ReadOnly);
        }
        protected void SqlDataSource1_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            Done = (bool)e.Command.Parameters["@Done"].Value;
            GridView1.DataBind();
            TrustControl1.ClientMsg(string.Format("{0}", Msg));
        }
        protected void SqlDataSource1_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {


        }
        protected void SqlDataSource1_Inserted1(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            Done = (bool)e.Command.Parameters["@Done"].Value;
            GridView1.DataBind();
            TrustControl1.ClientMsg(string.Format("{0}", Msg));
        }
        protected void DetailsView1_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            if (!Done)
                e.KeepInInsertMode = true;
        }
        protected void DetailsView1_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
        {
            if (!Done)
                e.KeepInEditMode = true;
        }
    }
}