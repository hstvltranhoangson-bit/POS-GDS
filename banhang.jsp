<%@page import="java.util.List"%>
<%@page import="models.SanPham"%>
<%@page import="models.ItemGioHang"%>
<%@page import="models.KhachHang"%>
<%@page import="models.Voucher"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>POS Bán Hàng Gundam</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        /* CSS Cơ bản */
        body { font-family: 'Roboto', sans-serif; background-color: #eef2f5; margin: 0; padding: 40px 20px; color: #333; }
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
        .page-title { text-align: center; color: #0a3d62; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 30px; font-size: 28px; font-weight: 700; }
        .container { display: flex; width: 100%; max-width: 1200px; margin: 0 auto; background: #ffffff; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); overflow: hidden; }
        .sanpham { width: 55%; padding: 30px; }
        .giohang { width: 45%; background-color: #f8f9fa; padding: 30px; border-left: 2px dashed #dcdde1; }
        h2 { color: #2c3e50; font-size: 22px; border-bottom: 3px solid #e74c3c; padding-bottom: 10px; margin-top: 0; margin-bottom: 20px; display: inline-block; }
        
        table { width: 100%; border-collapse: collapse; margin-bottom: 20px; background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.05); font-size: 14px;}
        th, td { padding: 12px; text-align: center; border-bottom: 1px solid #f1f2f6; }
        th { background-color: #0a3d62; color: white; text-transform: uppercase; letter-spacing: 1px; }
        
        .btn { padding: 8px 16px; background-color: #3498db; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: 500; }
        .btn-pay { width: 100%; padding: 18px; background-color: #e74c3c; color: #fff; font-size: 18px; font-weight: bold; border-radius: 8px; cursor: pointer; margin-top: 15px; border: none;}
        .search-box { display: flex; margin-bottom: 20px; gap: 10px; }
        .search-box input { flex: 1; padding: 10px 15px; border: 1px solid #bdc3c7; border-radius: 6px; outline: none; }
        .search-box button { padding: 10px 20px; background-color: #f39c12; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: bold; }
        .btn-remove { padding: 5px 8px; background: #e74c3c; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; }
        
        /* Box hiển thị thông tin khách */
        .info-box { background: #fdfefe; border-left: 4px solid #8e44ad; padding: 12px; margin-bottom: 15px; font-size: 13px; border-radius: 0 4px 4px 0; box-shadow: 0 2px 5px rgba(0,0,0,0.02);}
        .vip-badge { color: #27ae60; font-weight: bold; padding: 2px 6px; background: #e8f8f5; border-radius: 4px; margin-left: 5px;}
        .normal-badge { color: #7f8c8d; font-style: italic; margin-left: 5px;}
    </style>
</head>
<body>
    <%
        Locale localeVN = new Locale("vi", "VN");
        NumberFormat moneyFormat = NumberFormat.getInstance(localeVN);
    %>

    <div style="max-width: 1200px; margin: 0 auto;">
        <a href="index.html" class="btn-back">⬅ Quay Lại Command Center</a>
        
        <a href="khach-hang" style="background: #8e44ad; color: white; padding: 10px 20px; text-decoration: none; border-radius: 6px; font-weight: bold; margin-bottom: 20px; box-shadow: 0 4px 10px rgba(142,68,173,0.3);">
            👥 Quản Lý & Lịch Sử Khách Hàng
        </a>
    </div>
    <h1 class="page-title">Hệ Thống Bán Hàng Gundam Store</h1>
    
    <div class="container">
        <div class="sanpham">
            <h2>DANH SÁCH MÔ HÌNH</h2>
            <form action="ban-hang" method="GET" class="search-box">
                <input type="text" name="search" placeholder="Nhập tên Gundam..." value="<%= request.getAttribute("txtSearch") != null ? request.getAttribute("txtSearch") : "" %>">
                <button type="submit">🔍 Tìm Kiếm</button>
            </form>

            <table>
                <tr><th>Tên Gundam</th><th>Giá Bán</th><th>Tồn</th><th>Thao Tác</th></tr>
                <% 
                    List<SanPham> danhSach = (List<SanPham>) request.getAttribute("danhSach");
                    if (danhSach != null) {
                        for (SanPham sp : danhSach) {
                %>
                    <tr>
                        <td style="font-weight: 500; color: #2c3e50;"><%= sp.getTenGundam() %></td>
                        <td style="color: #e67e22; font-weight: bold;"><%= moneyFormat.format(sp.getGiaBan()) %></td>
                        <td><b><%= sp.getSoLuongTon() %></b></td>
                        <td>
                            <form action="ban-hang" method="POST">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="maSP" value="<%= sp.getMaSP() %>">
                                <input type="hidden" name="tenGundam" value="<%= sp.getTenGundam() %>">
                                <input type="hidden" name="giaBan" value="<%= sp.getGiaBan() %>">
                                <button type="submit" class="btn">+ Thêm</button>
                            </form>
                        </td>
                    </tr>
                <% }} %>
            </table>
        </div>

        <div class="giohang">
            <h2>GIỎ HÀNG</h2>
            <table>
                <tr><th>Tên Món</th><th>SL</th><th>Thành Tiền</th><th>Bỏ</th></tr>
                <% 
                    List<ItemGioHang> cart = (List<ItemGioHang>) session.getAttribute("cart");
                    double tongTien = 0;
                    if (cart != null && !cart.isEmpty()) {
                        for (ItemGioHang item : cart) {
                            double thanhTienItem = item.getSoLuongMua() * item.getGiaBan();
                            tongTien += thanhTienItem;
                %>
                    <tr>
                        <td><%= item.getTenGundam() %></td>
                        <td><b><%= item.getSoLuongMua() %></b></td>
                        <td style="color: #e67e22; font-weight: bold;"><%= moneyFormat.format(thanhTienItem) %></td>
                        <td>
                            <form action="ban-hang" method="POST">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="maSP" value="<%= item.getMaSP() %>">
                                <button type="submit" class="btn-remove">🗑️</button>
                            </form>
                        </td>
                    </tr>
                <% }} else { %>
                    <tr><td colspan="4" style="color: #7f8c8d;">Giỏ hàng đang trống...</td></tr>
                <% } %>
            </table>
            
            <%
                double tienGiamT1 = 0, tienGiamT2 = 0, tienGiamT3 = 0;
                // Lấy thông tin Khách Hàng và Voucher từ Session
                KhachHang kh = (KhachHang) session.getAttribute("currentKhachHang");
                Voucher v = (Voucher) session.getAttribute("currentVoucher");

                if (tongTien > 0) {
                    // Tầng 1: Áp dụng Voucher
                    if (v != null) {
                        tienGiamT1 = (tongTien * v.getPhanTramGiam() / 100.0) + v.getTienGiam();
                        if (tienGiamT1 > tongTien) tienGiamT1 = tongTien;
                    }
                    
                    // Tầng 2: Áp dụng Khách VIP (Mua từ 3 lần trở lên giảm 10%)
                    double sauT1 = tongTien - tienGiamT1;
                    if (kh != null && kh.getSoLanMua() >= 3) {
                        tienGiamT2 = sauT1 * 0.10;
                    }
                    
                    // Tầng 3: Khuyến mãi lũy tiến (Cứ vượt 1 triệu giảm 100k)
                    double sauT2 = sauT1 - tienGiamT2;
                    tienGiamT3 = Math.floor(sauT2 / 1000000.0) * 100000.0;
                }
                
                double tongGiamGia = tienGiamT1 + tienGiamT2 + tienGiamT3;
                double khachPhaiTra = tongTien - tongGiamGia;
                if (khachPhaiTra < 0) khachPhaiTra = 0;
            %>

            <div style="background: #fff; padding: 15px; border-radius: 8px; border: 1px solid #dcdde1;">
                <h4 style="margin-top:0; color: #8e44ad;">🎁 THÔNG TIN ƯU ĐÃI</h4>
                
                <form action="ban-hang" method="POST" style="display: flex; gap: 10px; margin-bottom: 15px;">
                    <input type="hidden" name="action" value="apply_discount">
                    <input type="text" name="sdt" placeholder="SĐT Khách" value="<%= kh != null ? kh.getSdt() : "" %>" style="flex: 1; padding: 8px; border: 1px solid #bdc3c7; border-radius: 4px; outline: none;">
                    <input type="text" name="maVoucher" placeholder="Mã Voucher" value="<%= v != null ? v.getMaVoucher() : "" %>" style="flex: 1; padding: 8px; border: 1px solid #bdc3c7; border-radius: 4px; outline: none;">
                    <button type="submit" style="background: #8e44ad; color: white; border: none; border-radius: 4px; padding: 0 15px; font-weight: bold; cursor: pointer;">Kiểm Tra</button>
                </form>

                <% if (kh != null || v != null) { %>
                <div class="info-box">
                    <% if (kh != null) { %>
                        <div style="margin-bottom: 6px;">
                            👤 <b>Khách hàng:</b> <%= kh.getTenKH() %>
                            <br>
                            🛒 <b>Số lần mua trước đây:</b> <%= kh.getSoLanMua() %> lần 
                            <% if (kh.getSoLanMua() >= 3) { %>
                                <span class="vip-badge">✔️ ĐẠT CHUẨN VIP</span>
                            <% } else { %>
                                <span class="normal-badge">(Cần 3 lần để lên VIP)</span>
                            <% } %>
                        </div>
                    <% } %>
                    
                    <% if (v != null) { %>
                        <div style="margin-top: 5px; border-top: 1px dashed #dcdde1; padding-top: 5px;">
                            🎟️ <b>Mã Voucher:</b> <span style="background:#8e44ad; color:white; padding: 2px 6px; border-radius: 4px; font-weight: bold;"><%= v.getMaVoucher() %></span> 
                            - <%= v.getTenDip() %> 
                        </div>
                    <% } %>
                </div>
                <% } %>

                <div style="font-size: 15px; color: #34495e; line-height: 1.8;">
                    <div style="display: flex; justify-content: space-between;">
                        <span>Tạm tính:</span> <b><%= moneyFormat.format(tongTien) %> đ</b>
                    </div>
                    <% if (tienGiamT1 > 0) { %>
                    <div style="display: flex; justify-content: space-between; color: #27ae60;">
                        <span>- Voucher [<%= v.getMaVoucher() %>]:</span> <b>- <%= moneyFormat.format(tienGiamT1) %> đ</b>
                    </div>
                    <% } %>
                    <% if (tienGiamT2 > 0) { %>
                    <div style="display: flex; justify-content: space-between; color: #27ae60;">
                        <span>- Khách VIP [<%= kh.getTenKH() %>]:</span> <b>- <%= moneyFormat.format(tienGiamT2) %> đ</b>
                    </div>
                    <% } %>
                    <% if (tienGiamT3 > 0) { %>
                    <div style="display: flex; justify-content: space-between; color: #27ae60;">
                        <span>- Lũy tiến (100k/1tr):</span> <b>- <%= moneyFormat.format(tienGiamT3) %> đ</b>
                    </div>
                    <% } %>
                </div>
            </div>
            
            <div style="margin-top: 15px; text-align: right;">
                <div style="font-size: 16px; font-weight: bold;">KHÁCH CẦN TRẢ:</div>
                <div style="color: #c0392b; font-size: 32px; font-weight: 900;"><%= moneyFormat.format(khachPhaiTra) %> VNĐ</div>
            </div>
            
            <% if (tongTien > 0) { %>
                <form action="thanh-toan" method="POST">
                    <input type="hidden" name="tongTienGoc" value="<%= tongTien %>">
                    <input type="hidden" name="tongTienGiam" value="<%= tongGiamGia %>">
                    <input type="hidden" name="khachPhaiTra" value="<%= khachPhaiTra %>">
                    <button type="submit" class="btn-pay">🚀 Thanh Toán & In Biên Lai</button>
                </form>
            <% } %>
        </div>
    </div>
</body>
</html>