<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.List"%>
<%@page import="models.SanPham"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Kho Gundam</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Roboto', sans-serif; background-color: #f4f6f9; margin: 0; padding: 30px; color: #333; }
        .page-header { text-align: center; color: #2c3e50; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 30px; font-size: 26px; font-weight: 700; }
        .card { background: #ffffff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); padding: 25px; margin: 0 auto 30px auto; max-width: 1000px; }
        .card h3 { margin-top: 0; color: #16a085; border-bottom: 2px solid #ecf0f1; padding-bottom: 10px; font-size: 20px; }
        
        /* Form lọc và tìm kiếm */
        .search-box { display: flex; margin-bottom: 20px; gap: 10px; }
        .search-box input { flex: 1; padding: 10px 15px; border: 1px solid #bdc3c7; border-radius: 6px; font-size: 14px; outline: none; }
        .search-box button { padding: 10px 20px; background-color: #f39c12; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: bold; }
        .search-box button:hover { background-color: #e67e22; }

        .form-group { display: flex; flex-wrap: wrap; gap: 15px; align-items: flex-end; margin-bottom: 20px;}
        .input-box { display: flex; flex-direction: column; flex: 1; min-width: 150px; }
        .input-box label { font-size: 13px; font-weight: 600; color: #7f8c8d; margin-bottom: 5px; text-transform: uppercase; }
        .input-box input, .input-box select { padding: 10px; border: 1px solid #bdc3c7; border-radius: 6px; font-size: 14px; outline: none; }
        
        .btn-submit { background-color: #16a085; color: white; padding: 10px 20px; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; height: 40px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 12px 15px; text-align: center; border-bottom: 1px solid #ecf0f1; }
        th { background-color: #34495e; color: #ffffff; text-transform: uppercase; font-size: 14px; }
        .badge { padding: 5px 10px; border-radius: 12px; font-size: 12px; font-weight: bold; background: #e8f8f5; color: #1abc9c; }
        .action-btn { text-decoration: none; padding: 6px 12px; border-radius: 4px; font-size: 13px; font-weight: 500; color: white; margin: 0 2px; }
        .btn-edit { background-color: #3498db; }
        .btn-delete { background-color: #e74c3c; }
        /* Nút Quay lại Command Center siêu ngầu */
.btn-back { 
    display: inline-flex; 
    align-items: center; 
    gap: 8px; 
    margin-bottom: 20px; 
    padding: 12px 25px; 
    background: #2c3e50; /* Màu xanh thép */
    color: #ffffff; 
    text-decoration: none; 
    font-weight: 700; 
    font-size: 15px; 
    border-radius: 50px; /* Bo tròn dạng viên thuốc */
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.15); 
    transition: all 0.3s ease; 
    border: 2px solid transparent;
}

.btn-back:hover { 
    background: #34495e; 
    transform: translateY(-3px); /* Hiệu ứng nảy lên */
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3); 
    color: #f39c12; /* Đổi màu chữ sang vàng Gundam */
    border-color: #f39c12; /* Hiện viền vàng */
}
    </style>
</head>
<body>
    <% Locale localeVN = new Locale("vi", "VN"); NumberFormat moneyFormat = NumberFormat.getInstance(localeVN); %>
    <a href="index.html" class="btn-back">⬅ Quay Lại Command Center</a>
    <h1 class="page-header">Quản Lý Kho Hàng Gundam Store</h1>

    <div class="card">
        <h3>+ THÊM GUNDAM MỚI</h3>
        <form action="kho-hang" method="POST" class="form-group">
            <div class="input-box"><label>Tên</label><input type="text" name="tenGundam" required></div>
            <div class="input-box">
    <label>Loại (Chọn hoặc Nhập mới)</label>
    <input list="danhSachLoai" name="phanLoai" placeholder="VD: HG, Metal Build..." required>
    
    <datalist id="danhSachLoai">
        <option value="HG"></option>
        <option value="RG"></option>
        <option value="MG"></option>
        <option value="PG"></option>
        <option value="SD"></option>
        <option value="Mega Size"></option>
        <option value="Figure-rise"></option>
        <option value="30MS"></option>
        <option value="Chinese Kit"></option>
    </datalist>
</div>
            <div class="input-box"><label>Giá</label><input type="number" name="giaBan" required></div>
            <div class="input-box"><label>Tồn</label><input type="number" name="soLuongTon" required></div>
            <button type="submit" class="btn-submit">Thêm</button>
        </form>
    </div>

    <div class="card">
        <h3>🔍 TÌM KIẾM SẢN PHẨM</h3>
        <form action="kho-hang" method="GET" class="search-box">
            <input type="text" name="search" placeholder="Nhập tên..." value="<%= request.getAttribute("txtSearch") != null ? request.getAttribute("txtSearch") : "" %>">
            <button type="submit">🔍 Tìm</button>
            <a href="kho-hang" style="padding: 10px 15px; background: #95a5a6; color: white; text-decoration: none; border-radius: 6px; font-weight: bold;">Tất Cả</a>
        </form>
            <form action="kho-hang" method="GET" class="search-box">
    <input type="text" name="search" placeholder="Nhập tên..." value="<%= request.getAttribute("txtSearch") != null ? request.getAttribute("txtSearch") : "" %>">
    
    <select name="sort" style="padding: 10px; border: 1px solid #bdc3c7; border-radius: 6px;">
        <option value="">-- Mặc định --</option>
        <option value="name" <%= "name".equals(request.getParameter("sort")) ? "selected" : "" %>>Tên (A-Z)</option>
        <option value="price" <%= "price".equals(request.getParameter("sort")) ? "selected" : "" %>>Giá (Thấp - Cao)</option>
    </select>
    
    <button type="submit">🔍 Lọc/Sắp xếp</button>
    <a href="kho-hang" style="padding: 10px 15px; background: #95a5a6; color: white; text-decoration: none; border-radius: 6px; font-weight: bold;">Reset</a>
</form>

        <table>
            <thead>
                <tr><th>Mã</th><th>Tên Gundam</th><th>Loại</th><th>Giá</th><th>Tồn</th><th>Thao Tác</th></tr>
            </thead>
            <tbody>
                <% List<SanPham> danhSach = (List<SanPham>) request.getAttribute("danhSach");
                   if (danhSach != null) { for (SanPham sp : danhSach) { %>
                    <tr>
                        <td style="font-weight: bold;">#<%= sp.getMaSP() %></td>
                        <td><%= sp.getTenGundam() %></td>
                        <td><%= sp.getPhanLoai() %></td>
                        <td style="color: #e67e22; font-weight: bold;"><%= moneyFormat.format(sp.getGiaBan()) %> VNĐ</td>
                        <td><span class="badge"><%= sp.getSoLuongTon() %></span></td>
                        <td>
                            <a href="sua-san-pham?id=<%= sp.getMaSP() %>" class="action-btn btn-edit">Sửa</a>
                            <a href="xoa-san-pham?id=<%= sp.getMaSP() %>" class="action-btn btn-delete" onclick="return confirm('Xóa?');">Xóa</a>
                        </td>
                    </tr>
                <% }} %>
            </tbody>
        </table>
    </div>
</body>
</html>