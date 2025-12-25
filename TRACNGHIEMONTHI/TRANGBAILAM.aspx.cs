using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Services;

namespace TRACNGHIEMONTHI
{
    public partial class TRANGBAILAM : System.Web.UI.Page
    {
        SqlConnection conn = new SqlConnection(
            ConfigurationManager.ConnectionStrings["TracNghiemDB"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        public class CauHoiModel
        {
            public int MaCau { get; set; }
            public string NoiDung { get; set; }
            public List<DapAnModel> DapAn { get; set; }
        }

        public class DapAnModel
        {
            public int MaDA { get; set; }
            public string NoiDung { get; set; }
            public bool LaDung { get; set; }
        }

        // Hàm shuffle danh sách
        private static void Shuffle<T>(IList<T> list)
        {
            Random rng = new Random();
            int n = list.Count;
            while (n > 1)
            {
                n--;
                int k = rng.Next(n + 1);
                T value = list[k];
                list[k] = list[n];
                list[n] = value;
            }
        }

        [WebMethod]
        public static List<CauHoiModel> GetQuizData()
        {
            List<CauHoiModel> list = new List<CauHoiModel>();
            string connStr = ConfigurationManager.ConnectionStrings["TracNghiemDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM CauHoi WHERE MaDe = 1 ORDER BY NEWID()", conn);
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    var cauHoi = new CauHoiModel
                    {
                        MaCau = (int)reader["MaCau"],
                        NoiDung = reader["NoiDung"].ToString(),
                        DapAn = new List<DapAnModel>()
                    };
                    list.Add(cauHoi);
                }
                reader.Close();

                foreach (var cau in list)
                {
                    SqlCommand cmdDA = new SqlCommand("SELECT MaDA, NoiDung, LaDung FROM DapAn WHERE MaCau=@MaCau", conn);
                    cmdDA.Parameters.AddWithValue("@MaCau", cau.MaCau);
                    SqlDataReader drDA = cmdDA.ExecuteReader();
                    while (drDA.Read())
                    {
                        cau.DapAn.Add(new DapAnModel
                        {
                            MaDA = (int)drDA["MaDA"],
                            NoiDung = drDA["NoiDung"].ToString(),
                            LaDung = (bool)drDA["LaDung"]
                        });
                    }
                    drDA.Close();

                    // Xáo trộn đáp án trước khi trả về
                    Shuffle(cau.DapAn);
                }
                conn.Close();
            }

            return list;
        }
    }
}
