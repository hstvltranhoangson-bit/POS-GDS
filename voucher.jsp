<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.List"%>
<%@page import="models.Voucher"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Khuyến Mãi (Voucher)</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Roboto', sans-serif; background-color: #f4f6f9; margin: 0; padding: 30px; color: #333; }
        .page-header { text-align: center; color: #e67e22; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 30px; font-size: 26px; font-weight: 700; }
        .card { background: #ffffff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); padding: 25px; margin: 0 auto 30px auto; max-width: 900px; }
        h3 { margin-top: 0; color: #e67e22; border-bottom: 2px solid #ecf0f1; padding-bottom: 10px; font-size: 20px; }
        
        /* Form Thêm */
        .form-group { display: flex; flex-wrap: wrap; gap: 15px; align-items: flex-end; }
        .input-box { display: flex; flex-direction: column; flex: 1; min-width: 150px; }
        .input-box label { font-size: 13px; font-weight: 600; color: #7f8c8d; margin-bottom: 5px; text-transform: uppercase; }
        .input-box input { padding: 10px; border: 1px solid #bdc3c7; border-radius: 6px; font-size: 14px; outline: none; }
        .btn-submit { background-color: #e67e22; color: white; padding: 10px 20px; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; height: 40px; }
        
        /* Bảng hiển thị */
        table { width: 100%; border-collapse: collapse; margin-top: 10px; font-size: 14px;}
        th, td { padding: 12px 15px; text-align: center; border-bottom: 1px solid #ecf0f1; }
        th { background-color: #34495e; color: #ffffff; text-transform: uppercase; }
        
        .badge { padding: 5px 10px; border-radius: 12px; font-size: 12px; font-weight: bold; display: inline-block; width: 80px;}
        .bg-active { background: #e8f8f5; color: #27ae60; }
        .bg-expired { background: #fadbd8; color: #c0392b; }
        
        .action-btn { text-decoration: none; padding: 6px 12px; border-radius: 4px; font-size: 13px; font-weight: bold; color: white; margin: 0 2px; display: inline-block;}
        .btn-toggle { background-color: #f1c40f; color: #333;}
        .btn-delete { background-color: #e74c3c; }

        /* Nút Quay lại 3D */
        .btn-back { display: inline-flex; align-items: center; gap: 8px; margin-bottom: 20px; padding: 12px 25px; background: #2c3e50; color: #ffffff; text-decoration: none; font-weight: 700; font-size: 15px; border-radius: 50px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.15); transition: all 0.3s ease; border: 2px solid transparent; }
        .btn-back:hover { background: #34495e; transform: translateY(-3px); box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3); color: #f39c12; border-color: #f39c12; }
    </style>
</head>
<body>
    <% NumberFormat moneyFormat = NumberFormat.getInstance(new Locale("vi", "VN")); %>
    
    <div style="max-width: 900px; margin: 0 auto;">
        <a href="index.html" class="btn-back">⬅ Quay Lại Command Center</a>
    </div>

    <h1 class="page-header">🎟️ HỆ THỐNG PHÁT HÀNH VOUCHER</h1>

    <div class="card">
        <h3>+ TẠO MÃ KHUYẾN MÃI MỚI</h3>
        <form action="voucher" method="POST" class="form-group">
            <input type="hidden" name="action" value="add">
            <div class="input-box">
                <label>Mã Voucher (VD: TET2026)</label>
                <input type="text" name="maVoucher" required>
            </div>
            <div class="input-box">
                <label>Tên Dịp Lễ</label>
                <input type="text" name="tenDip" placeholder="Tết Nguyên Đán..." required>
            </div>
            <div class="input-box">
                <label>Giảm %</label>
                <input type="number" name="phanTramGiam" value="0" required>
            </div>
            <div class="input-box">
                <label>Giảm Tiền Mặt (VND)</label>
                <input type="number" name="tienGiam" value="0" required>
            </div>
            <button type="submit" class="btn-submit">Phát Hành</button>
        </form>
    </div>

    <div class="card">
        <h3>DANH SÁCH MÃ ƯU ĐÃI</h3>
        <table>
            <tr><th>Mã Voucher</th><th>Dịp Lễ</th><th>Mức Giảm</th><th>Trạng Thái</th><th>Thao Tác</th></tr>
            <% 
                List<Voucher> list = (List<Voucher>) request.getAttribute("danhSachVoucher");
                if(list != null) {
                    for(Voucher v : list) {
                        boolean isActive = v.getTrangThai().equals("HoatDong");
            %>
                <tr>
                    <td><b style="color: #8e44ad; font-size: 16px;"><%= v.getMaVoucher() %></b></td>
                    <td><%= v.getTenDip() %></td>
                    <td style="color: #e67e22; font-weight: bold;">
                        <%= v.getPhanTramGiam() > 0 ? v.getPhanTramGiam() + "% " : "" %>
                        <%= v.getTienGiam() > 0 ? moneyFormat.format(v.getTienGiam()) + "đ" : "" %>
                    </td>
                    <td>
                        <span class="badge <%= isActive ? "bg-active" : "bg-expired" %>">
                            <%= isActive ? "Đang Chạy" : "Hết Hạn" %>
                        </span>
                    </td>
                    <td>
                        <a href="voucher?action=toggle&id=<%= v.getMaVoucher() %>&current=<%= v.getTrangThai() %>" class="action-btn btn-toggle">
                            <%= isActive ? "Đóng Mã" : "Mở Lại" %>
                        </a>
                        <a href="voucher?action=delete&id=<%= v.getMaVoucher() %>" class="action-btn btn-delete" onclick="return confirm('Bạn có chắc chắn muốn xóa vĩnh viễn mã này?');">Xóa</a>
                    </td>
                </tr>
            <% }} %>
        </table>
    </div>
</body>
</html>