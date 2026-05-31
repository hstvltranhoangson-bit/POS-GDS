<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.List"%>
<%@page import="models.KhachHang"%>
<%@page import="models.HoaDon"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Khách Hàng</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Roboto', sans-serif; background-color: #f4f6f9; margin: 0; padding: 30px; color: #333; }
        .page-header { text-align: center; color: #8e44ad; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 30px; font-size: 26px; font-weight: 700; }
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
        
        .container { display: flex; gap: 20px; max-width: 1200px; margin: 0 auto; }
        .col-left { width: 55%; background: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .col-right { width: 45%; background: #fdfefe; padding: 20px; border-radius: 10px; border: 2px solid #8e44ad; box-shadow: 0 4px 15px rgba(142,68,173,0.1); }
        
        h3 { margin-top: 0; color: #2c3e50; border-bottom: 2px solid #ecf0f1; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; font-size: 14px;}
        th, td { padding: 10px; text-align: center; border-bottom: 1px solid #ecf0f1; }
        th { background-color: #34495e; color: #ffffff; text-transform: uppercase; }
        tr:hover td { background-color: #f9fbfd; }
        
        .search-box { display: flex; gap: 10px; margin-bottom: 15px;}
        .search-box input { flex: 1; padding: 8px 12px; border: 1px solid #bdc3c7; border-radius: 4px; outline: none; }
        .search-box button { padding: 8px 15px; background: #8e44ad; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
        
        .btn-view { background: #3498db; color: white; padding: 5px 10px; text-decoration: none; border-radius: 4px; font-size: 12px; font-weight: bold;}
        .vip-badge { background: #e8f8f5; color: #27ae60; padding: 3px 8px; border-radius: 12px; font-size: 11px; font-weight: bold;}
    </style>
</head>
<body>
    <%
        Locale localeVN = new Locale("vi", "VN");
        NumberFormat moneyFormat = NumberFormat.getInstance(localeVN);
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    %>

    <div style="max-width: 1200px; margin: 0 auto;">
        <a href="index.html" class="btn-back">⬅ Quay Lại Command Center</a>
        <h1 class="page-header">👥 HỒ SƠ KHÁCH HÀNG (CRM)</h1>
        
        <div class="container">
            <div class="col-left">
                <h3>Danh Sách Khách Hàng</h3>
                <form action="khach-hang" method="GET" class="search-box">
                    <input type="text" name="search" placeholder="Nhập SĐT hoặc Tên..." value="<%= request.getAttribute("txtSearch") != null ? request.getAttribute("txtSearch") : "" %>">
                    <button type="submit">🔍 Tìm</button>
                    <a href="khach-hang" style="padding: 8px 15px; background: #95a5a6; color: white; text-decoration: none; border-radius: 4px; font-weight: bold;">Tất Cả</a>
                </form>

                <table>
                    <tr><th>Tên KH</th><th>Số Điện Thoại</th><th>Lượt Mua</th><th>Thao Tác</th></tr>
                    <% 
                        List<KhachHang> dsKH = (List<KhachHang>) request.getAttribute("danhSachKH");
                        if (dsKH != null) {
                            for (KhachHang kh : dsKH) {
                    %>
                        <tr>
                            <td style="font-weight: bold;"><%= kh.getTenKH() %></td>
                            <td><%= kh.getSdt() %></td>
                            <td>
                                <%= kh.getSoLanMua() %>
                                <% if(kh.getSoLanMua() >= 3) { %> <br><span class="vip-badge">VIP</span> <% } %>
                            </td>
                            <td>
                                <a href="khach-hang?maKH=<%= kh.getMaKH() %>" class="btn-view">👀 Xem Lịch Sử</a>
                            </td>
                        </tr>
                    <% }} %>
                </table>
            </div>

            <div class="col-right">
                <% 
                    KhachHang khChon = (KhachHang) request.getAttribute("khachHangDuocChon");
                    if (khChon != null) {
                %>
                    <h3 style="color: #8e44ad;">🧾 Lịch Sử Của: <%= khChon.getTenKH() %></h3>
                    <p>📞 <b>SĐT:</b> <%= khChon.getSdt() %></p>
                    <p>🛒 <b>Tổng số lần mua:</b> <%= khChon.getSoLanMua() %> lần</p>
                    
                    <table>
                        <tr><th>Mã HĐ</th><th>Thời Gian</th><th>Đã Thanh Toán</th></tr>
                        <% 
                            List<HoaDon> dsHD = (List<HoaDon>) request.getAttribute("danhSachHD");
                            if (dsHD != null && !dsHD.isEmpty()) {
                                for (HoaDon hd : dsHD) {
                        %>
                            <tr>
                                <td><b>#HD<%= hd.getMaHD() %></b></td>
                                <td><%= sdf.format(hd.getNgayLap()) %></td>
                                <td style="color: #c0392b; font-weight: bold;"><%= moneyFormat.format(hd.getTongTien()) %> đ</td>
                            </tr>
                        <% 
                                }
                            } else { 
                        %>
                            <tr><td colspan="3" style="color: gray;">Chưa có giao dịch nào!</td></tr>
                        <% } %>
                    </table>
                <% } else { %>
                    <div style="text-align: center; color: #7f8c8d; margin-top: 50px;">
                        <h1 style="font-size: 50px; margin: 0;">👤</h1>
                        <p>Hãy chọn một khách hàng bên trái<br>để xem lịch sử mua hàng.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>