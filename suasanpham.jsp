<%@page import="models.SanPham"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sửa Thông Tin Gundam</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Roboto', sans-serif; background-color: #f4f6f9; margin: 0; padding: 40px; color: #333; }
        .card { background: #ffffff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); padding: 30px; max-width: 500px; margin: 0 auto; }
        .card h3 { margin-top: 0; color: #3498db; border-bottom: 2px solid #ecf0f1; padding-bottom: 10px; text-align: center;}
        .input-box { margin-bottom: 15px; }
        .input-box label { display: block; font-size: 13px; font-weight: 600; color: #7f8c8d; margin-bottom: 5px; text-transform: uppercase; }
        .input-box input, .input-box select { width: 100%; padding: 10px; border: 1px solid #bdc3c7; border-radius: 6px; font-size: 14px; box-sizing: border-box; }
        .input-box input:focus, .input-box select:focus { border-color: #3498db; outline: none;}
        .btn-group { display: flex; gap: 10px; margin-top: 20px; }
        .btn { padding: 12px 20px; border: none; border-radius: 6px; font-size: 14px; font-weight: bold; cursor: pointer; color: white; text-decoration: none; text-align: center; flex: 1; transition: 0.2s;}
        .btn-save { background-color: #3498db; }
        .btn-save:hover { background-color: #2980b9; }
        .btn-cancel { background-color: #95a5a6; }
        .btn-cancel:hover { background-color: #7f8c8d; }
    </style>
</head>
<body>
    <div class="card">
        <h3>✏️ CẬP NHẬT MÔ HÌNH</h3>
        <% 
            SanPham sp = (SanPham) request.getAttribute("sanPhamEdit");
            if (sp != null) {
        %>
        <form action="sua-san-pham" method="POST">
            <input type="hidden" name="maSP" value="<%= sp.getMaSP() %>">
            
            <div class="input-box">
                <label>Tên Gundam</label>
                <input type="text" name="tenGundam" value="<%= sp.getTenGundam() %>" required>
            </div>
            
            <div class="input-box">
                <label>Phân Loại (Đang chọn: <%= sp.getPhanLoai() %>)</label>
                <select name="phanLoai">
                    <option value="HG" <%= "HG".equals(sp.getPhanLoai()) ? "selected" : "" %>>HG</option>
                    <option value="RG" <%= "RG".equals(sp.getPhanLoai()) ? "selected" : "" %>>RG</option>
                    <option value="MG" <%= "MG".equals(sp.getPhanLoai()) ? "selected" : "" %>>MG</option>
                    <option value="PG" <%= "PG".equals(sp.getPhanLoai()) ? "selected" : "" %>>PG</option>
                    <option value="SD" <%= "SD".equals(sp.getPhanLoai()) ? "selected" : "" %>>SD</option>
                </select>
            </div>
            
            <div class="input-box">
                <label>Giá Bán (VNĐ)</label>
                <input type="number" name="giaBan" value="<%= sp.getGiaBan() %>" required>
            </div>
            
            <div class="input-box">
                <label>Số Lượng Tồn</label>
                <input type="number" name="soLuongTon" value="<%= sp.getSoLuongTon() %>" required>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-save">💾 Lưu Thay Đổi</button>
                <a href="kho-hang" class="btn btn-cancel">❌ Hủy Bỏ</a>
            </div>
        </form>
        <% } else { %>
            <p style="color:red; text-align:center; font-weight: bold;">Lỗi: Không tìm thấy thông tin sản phẩm!</p>
            <a href="kho-hang" class="btn btn-cancel" style="display:block;">⬅ Quay Lại Kho Hàng</a>
        <% } %>
    </div>
</body>
</html>