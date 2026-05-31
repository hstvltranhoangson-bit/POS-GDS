<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="models.ItemGioHang"%>
<%@page import="java.util.List"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Biên Lai Mua Hàng - Gundam Store</title>
    <style>
        /* CSS Chuẩn form máy in hóa đơn siêu thị */
        body { font-family: 'Courier New', Courier, monospace; background: #eef2f5; display: flex; justify-content: center; padding: 40px; color: #000; }
        .receipt { background: white; width: 350px; padding: 20px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); border-top: 5px solid #2c3e50; border-radius: 4px; }
        .header { text-align: center; margin-bottom: 20px; border-bottom: 1px dashed #000; padding-bottom: 10px; }
        .header h2 { margin: 0; font-size: 22px; text-transform: uppercase; letter-spacing: 1px;}
        .item-table { width: 100%; border-collapse: collapse; font-size: 14px; margin-bottom: 15px; }
        .item-table th, .item-table td { text-align: left; padding: 8px 0; }
        .item-table th { border-bottom: 1px solid #000; font-weight: bold;}
        .right { text-align: right !important; }
        .totals { border-top: 1px dashed #000; padding-top: 15px; font-size: 14px; }
        .totals div { display: flex; justify-content: space-between; margin-bottom: 8px; }
        .final-total { font-size: 18px; font-weight: bold; margin-top: 10px; border-top: 2px solid #000; padding-top: 10px; }
        .footer { text-align: center; margin-top: 15px; font-size: 12px; font-style: italic; border-top: 1px dashed #000; padding-top: 15px; }
        
        /* Hình ảnh Mã vạch & Mã QR */
        .barcode-img { max-height: 45px; margin-top: 10px; width: 80%; }
        .qrcode-img { width: 80px; height: 80px; margin-top: 10px; }

        /* Cụm nút thao tác */
        .btn-print { display: block; width: 100%; text-align: center; background: #e74c3c; color: white; padding: 12px; text-decoration: none; margin-top: 20px; cursor: pointer; border: none; font-weight: bold; border-radius: 4px; font-size: 16px;}
        .btn-print:hover { background: #c0392b; }
        
        .btn-back { display: block; width: 100%; text-align: center; background: #7f8c8d; color: white; padding: 10px; text-decoration: none; margin-top: 10px; cursor: pointer; border: none; font-weight: bold; border-radius: 4px; font-size: 14px;}
        .btn-back:hover { background: #95a5a6; }
        
        /* Khi ấn in, máy in sẽ TỰ ĐỘNG ẨN các nút đi */
        @media print { 
            .btn-print, .btn-back { display: none; } 
            body { background: white; padding: 0; } 
            .receipt { box-shadow: none; width: 100%; border-top: none; } 
        }
    </style>
</head>
<body>
    <%
        // 1. Bắt dữ liệu an toàn từ Servlet
        Integer maHD = (Integer) request.getAttribute("maHD");
        Double tongTienGoc = (Double) request.getAttribute("tongTienGoc");
        Double tongTienGiam = (Double) request.getAttribute("tongTienGiam");
        Double khachPhaiTra = (Double) request.getAttribute("khachPhaiTra");
        List<ItemGioHang> chiTiet = (List<ItemGioHang>) request.getAttribute("hoaDonChiTiet");

        // 2. Format tiền tệ chuẩn Việt Nam
        Locale localeVN = new Locale("vi", "VN");
        NumberFormat moneyFormat = NumberFormat.getInstance(localeVN);
        
        // 3. Xử lý chống Null 
        String maHDStr = (maHD != null) ? String.valueOf(maHD) : "ERR";
        String tienGocStr = (tongTienGoc != null) ? moneyFormat.format(tongTienGoc) : "0";
        String tienGiamStr = (tongTienGiam != null) ? moneyFormat.format(tongTienGiam) : "0";
        String khachTraStr = (khachPhaiTra != null) ? moneyFormat.format(khachPhaiTra) : "0";
    %>

    <div class="receipt">
        <div class="header">
            <h2>GUNDAM STORE</h2>
            <p style="margin: 5px 0 0 0; font-size: 12px;">Đ/C: Trụ sở Command Center</p>
            <p style="margin: 5px 0 0 0; font-size: 12px;">Ngày: <%= new SimpleDateFormat("dd/MM/yyyy - HH:mm").format(new Date()) %></p>
            <p style="margin: 5px 0 0 0; font-size: 12px;">Hóa đơn: <b>#HD<%= maHDStr %></b></p>
            
            <img src="https://bwipjs-api.metafloor.com/?bcid=code128&text=HD<%= maHDStr %>&scale=2&height=10&includetext=true" alt="Barcode" class="barcode-img">
        </div>

        <table class="item-table">
            <thead>
                <tr>
                    <th>Tên Món</th>
                    <th style="width: 30px; text-align: center;">SL</th>
                    <th class="right">Thành Tiền</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    if (chiTiet != null && !chiTiet.isEmpty()) {
                        for (ItemGioHang item : chiTiet) {
                %>
                <tr>
                    <td><%= item.getTenGundam() %></td>
                    <td style="text-align: center;">x<%= item.getSoLuongMua() %></td>
                    <td class="right"><%= moneyFormat.format(item.getGiaBan() * item.getSoLuongMua()) %></td>
                </tr>
                <%      }
                    } else {
                %>
                <tr><td colspan="3" style="text-align: center;">Không có dữ liệu.</td></tr>
                <% } %>
            </tbody>
        </table>

        <div class="totals">
            <div>
                <span>Tạm tính:</span> 
                <span><%= tienGocStr %> đ</span>
            </div>
            <% if (tongTienGiam != null && tongTienGiam > 0) { %>
            <div style="color: #c0392b;">
                <span>Ưu đãi/Giảm giá:</span> 
                <span>- <%= tienGiamStr %> đ</span>
            </div>
            <% } %>
            
            <div class="final-total">
                <span>KHÁCH CẦN TRẢ:</span> 
                <span style="font-size: 20px;"><%= khachTraStr %> đ</span>
            </div>
        </div>

        <div class="footer">
            Cảm ơn quý khách đã mua sắm tại Gundam Store!<br>
            <i>Biên lai có giá trị đổi trả trong vòng 7 ngày.</i>
            <br>
            
            <img src="https://api.qrserver.com/v1/create-qr-code/?size=100x100&data=GundamStore-HD<%= maHDStr %>-Total:<%= khachPhaiTra != null ? khachPhaiTra.longValue() : 0 %>VND" alt="QR Code" class="qrcode-img">
            <br><span style="font-size: 10px; color: #7f8c8d;">Quét QR để tra cứu nhanh</span>
        </div>
        
        <button class="btn-print" onclick="window.print()">🖨️ IN BIÊN LAI NÀY</button>
        <button class="btn-back" onclick="smartBack()">⬅ XONG / QUAY LẠI</button>
    </div>

    <script>
        function smartBack() {
            // Kiểm tra xem trang này có được mở trong Tab mới không (Bởi Kế toán từ trang Thống kê)
            if (window.opener !== null || window.history.length === 1) {
                window.close(); // Chỉ cần đóng Tab là Kế toán sẽ nhìn thấy lại trang Thống kê
            } else {
                // Nếu được mở trực tiếp (Bởi Thu ngân thanh toán xong) -> Chuyển về POS
                window.location.href = 'ban-hang';
            }
        }
    </script>
</body>
</html>