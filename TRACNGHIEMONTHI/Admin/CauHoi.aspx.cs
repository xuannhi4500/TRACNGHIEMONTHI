using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace TRACNGHIEMONTHI.Admin
{

    public partial class CauHoi : System.Web.UI.Page
    {
        SqlConnection conn = new SqlConnection(
      ConfigurationManager.ConnectionStrings["TracNghiemDB"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadData();
        }
        void LoadData()
        {
            SqlDataAdapter da = new SqlDataAdapter(
                "SELECT * FROM CauHoi WHERE MaDe = 1", conn);

            DataTable dt = new DataTable();
            da.Fill(dt);

            gvCauHoi.DataSource = dt;
            gvCauHoi.DataBind();
        }

        // THÊM
        protected void btnThem_Click(object sender, EventArgs e)
        {
            SqlCommand cmd = new SqlCommand(
                "INSERT INTO CauHoi VALUES (1, @nd)", conn);

            cmd.Parameters.AddWithValue("@nd", txtNoiDung.Text);

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();

            txtNoiDung.Text = "";
            LoadData();
        }

        // SỬA
        protected void gvCauHoi_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int macau = (int)gvCauHoi.DataKeys[e.RowIndex].Value;
            string nd = ((TextBox)gvCauHoi.Rows[e.RowIndex].Cells[1].Controls[0]).Text;

            SqlCommand cmd = new SqlCommand(
                "UPDATE CauHoi SET NoiDung=@nd WHERE MaCau=@ma", conn);

            cmd.Parameters.AddWithValue("@nd", nd);
            cmd.Parameters.AddWithValue("@ma", macau);

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();

            gvCauHoi.EditIndex = -1;
            LoadData();
        }

        protected void gvCauHoi_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvCauHoi.EditIndex = e.NewEditIndex;
            LoadData();
        }

        protected void gvCauHoi_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvCauHoi.EditIndex = -1;
            LoadData();
        }

        // XÓA
        protected void gvCauHoi_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int macau = (int)gvCauHoi.DataKeys[e.RowIndex].Value;

            SqlCommand cmd = new SqlCommand(
                "DELETE FROM CauHoi WHERE MaCau=@ma", conn);

            cmd.Parameters.AddWithValue("@ma", macau);

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();

            LoadData();
        }
    }
}