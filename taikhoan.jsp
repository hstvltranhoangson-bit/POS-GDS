<%@page import="java.util.List"%>
<%@page import="models.TaiKhoan"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Trị Nhân Sự (Admin Only)</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Roboto', sans-serif; background-color: #f4f6f9; margin: 0; padding: 30px; color: #333; }
        .page-header { text-align: center; color: #d35400; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 30px; font-size: 26px; font-weight: 900; }
        .card { background: #ffffff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); padding: 25px; margin: 0 auto 30px auto; max-width: 900px; }
        h3 { margin-top: 0; color: #d35400; border-bottom: 2px solid #ecf0f1; padding-bottom: 10px; font-size: 20px; }
        
        /* Form Thêm */
        .form-group { display: flex; flex-wrap: wrap; gap: 15px; align-items: flex-end; }
        .input-box { display: flex; flex-direction: column; flex: 1; min-width: 150px; }
        .input-box label { font-size: 13px; font-weight: 600; color: #7f8c8d; margin-bottom: 5px; text-transform: uppercase; }
        .input-box input, .input-box select { padding: 10px; border: 1px solid #bdc3c7; border-radius: 6px; font-size: 14px; outline: none; }
        .btn-submit { background-color: #d35400; color: white; padding: 10px 20px; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; height: 40px; }
        
        /* Bảng hiển thị */
        table { width: 100%; border-collapse: collapse; margin-top: 10px; font-size: 14px;}
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ecf0f1; }
        th { background-color: #2c3e50; color: #ffffff; text-transform: uppercase; }
        
        .role-badge { padding: 5px 10px; border-radius: 6px; font-size: 12px; font-weight: bold; display: inline-block;}
        .role-admin { background: #fdebd0; color: #d35400; }
        .role-ketoan { background: #e8f8f5; color: #1abc9c; }
        .role-thungan { background: #fadbd8; color: #c0392b; }
        .role-kiemkho { background: #ebf5fb; color: #2980b9; }
        
        .btn-delete { background-color: #e74c3c; text-decoration: none; padding: 6px 12px; border-radius: 4px; font-size: 13px; font-weight: bold; color: white; display: inline-block; }
        .btn-delete:hover { background-color: #c0392b; }

        /* Nút Quay lại 3D */
        .btn-back { display: inline-flex; align-items: center; gap: 8px; margin-bottom: 20px; padding: 12px 25px; background: #2c3e50; color: #ffffff; text-decoration: none; font-weight: 700; font-size: 15px; border-radius: 50px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.15); transition: all 0.3s ease; border: 2px solid transparent; }
        .btn-back:hover { background: #34495e; transform: translateY(-3px); box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3); color: #f39c12; border-color: #f39c12; }
    </style>
</head>
<body>
    <% TaiKhoan currentLogin = (TaiKhoan) session.getAttribute("userLogin"); %>

    <div style="max-width: 900px; margin: 0 auto;">
        <a href="index.html" class="btn-back">⬅ Quay Lại Command Center</a>
    </div>

    <h1 class="page-header">👑 HỆ THỐNG QUẢN TRỊ NHÂN SỰ</h1>

    <div class="card">
        <h3>+ CẤP TÀI KHOẢN MỚI</h3>
        <form action="tai-khoan" method="POST" class="form-group">
            <input type="hidden" name="action" value="add">
            <div class="input-box">
                <label>Tên Đăng Nhập</label>
                <input type="text" name="username" placeholder="VD: nhanvien1" required>
            </div>
            <div class="input-box">
                <label>Mật Khẩu</label>
                <input type="password" name="password" required>
            </div>
            <div class="input-box">
                <label>Họ & Tên Nhân Viên</label>
                <input type="text" name="hoTen" required>
            </div>
            <div class="input-box">
                <label>Chức Vụ</label>
                <select name="vaiTro">
                    <option value="ThuNgan">Thu Ngân (POS)</option>
                    <option value="KiemKho">Kiểm Kho</option>
                    <option value="KeToan">Kế Toán</option>
                    <option value="Admin">Quản Trị Viên (Admin)</option>
                </select>
            </div>
            <button type="submit" class="btn-submit">Tạo Tài Khoản</button>
        </form>
    </div>

    <div class="card">
        <h3>DANH SÁCH NHÂN SỰ HIỆN TẠI</h3>
        <table>
            <tr><th>Tài Khoản</th><th>Họ & Tên</th><th>Chức Vụ</th><th>Thao Tác</th></tr>
            <% 
                List<TaiKhoan> list = (List<TaiKhoan>) request.getAttribute("danhSachTaiKhoan");
                if(list != null) {
                    for(TaiKhoan tk : list) {
                        String roleClass = "";
                        if(tk.getVaiTro().equals("Admin")) roleClass = "role-admin";
                        else if(tk.getVaiTro().equals("KeToan")) roleClass = "role-ketoan";
                        else if(tk.getVaiTro().equals("ThuNgan")) roleClass = "role-thungan";
                        else if(tk.getVaiTro().equals("KiemKho")) roleClass = "role-kiemkho";
            %>
                <tr>
                    <td><b><%= tk.getUsername() %></b></td>
                    <td><%= tk.getHoTen() %></td>
                    <td><span class="role-badge <%= roleClass %>"><%= tk.getVaiTro() %></span></td>
                    <td>
                        <% if(currentLogin != null && tk.getUsername().equals(currentLogin.getUsername())) { %>
                            <span style="color: #27ae60; font-weight: bold; font-size: 12px;">(Bạn)</span>
                        <% } else { %>
                            <a href="tai-khoan?action=delete&id=<%= tk.getUsername() %>" class="btn-delete" onclick="return confirm('Chắc chắn muốn thu hồi tài khoản này?');">Thu Hồi</a>
                        <% } %>
                    </td>
                </tr>
            <% }} %>
        </table>
    </div>
</body>
</html>