<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CauHoi.aspx.cs" Inherits="TRACNGHIEMONTHI.Admin.CauHoi" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h2>QUẢN LÝ CÂU HỎI</h2>

<asp:GridView ID="gvCauHoi" runat="server" AutoGenerateColumns="False"
    DataKeyNames="MaCau"
    OnRowEditing="gvCauHoi_RowEditing"
    OnRowUpdating="gvCauHoi_RowUpdating"
    OnRowDeleting="gvCauHoi_RowDeleting"
    OnRowCancelingEdit="gvCauHoi_RowCancelingEdit">

    <Columns>
        <asp:BoundField DataField="MaCau" HeaderText="Mã" ReadOnly="True" />
        <asp:BoundField DataField="NoiDung" HeaderText="Nội dung câu hỏi" />

        <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" />
    </Columns>
</asp:GridView>

<br />

<h3>Thêm câu hỏi mới</h3>
<asp:TextBox ID="txtNoiDung" runat="server" Width="400"></asp:TextBox>
<asp:Button ID="btnThem" runat="server" Text="Thêm"
    OnClick="btnThem_Click" />

        </div>
    </form>
</body>
</html>
