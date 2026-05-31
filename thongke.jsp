<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.List"%>
<%@page import="models.HoaDon"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thống Kê Doanh Thu</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Roboto', sans-serif; background-color: #f4f6f9; margin: 0; padding: 30px; color: #333; }
        .page-header { text-align: center; color: #2c3e50; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 30px; font-size: 26px; font-weight: 700; }
        .card { background: #ffffff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); padding: 25px; margin: 0 auto 30px auto; max-width: 1000px; }
        .card h3 { margin-top: 0; color: #8e44ad; border-bottom: 2px solid #ecf0f1; padding-bottom: 10px; font-size: 20px; }
        
        /* Nút Quay lại Command Center siêu ngầu */
        .btn-back { display: inline-flex; align-items: center; gap: 8px; margin-bottom: 20px; padding: 12px 25px; background: #2c3e50; color: #ffffff; text-decoration: none; font-weight: 700; font-size: 15px; border-radius: 50px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.15); transition: all 0.3s ease; border: 2px solid transparent; }
        .btn-back:hover { background: #34495e; transform: translateY(-3px); box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3); color: #f39c12; border-color: #f39c12; }
        
        /* Nút In */
        .btn-print { background-color: #8e44ad; color: white; padding: 6px 12px; text-decoration: none; border-radius: 4px; font-size: 12px; font-weight: bold; display: inline-block; transition: 0.3s; }
        .btn-print:hover { background-color: #9b59b6; transform: scale(1.05); }
        
        /* Form lọc */
        .filter-form { display: flex; gap: 15px; align-items: flex-end; margin-bottom: 20px; background: #fdfefe; padding: 15px; border: 1px solid #ebedef; border-radius: 8px;}
        .filter-box { display: flex; flex-direction: column; }
        .filter-box label { font-size: 12px; font-weight: bold; color: #7f8c8d; text-transform: uppercase; margin-bottom: 5px; }
        .filter-box select, .filter-box input { padding: 8px; border: 1px solid #bdc3c7; border-radius: 4px; outline: none; }
        .btn-filter { background: #8e44ad; color: white; padding: 9px 20px; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; }
        .btn-filter:hover { background: #9b59b6; }

        /* Bảng dữ liệu */
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px 15px; text-align: center; border-bottom: 1px solid #ecf0f1; }
        th { background-color: #34495e; color: #ffffff; text-transform: uppercase; font-size: 14px; }
        tr:hover td { background-color: #f9fbfd; }
        .total-row { font-size: 22px; font-weight: bold; color: #d35400; text-align: right; padding-top: 20px; border-top: 2px solid #ecf0f1; margin-top: 20px;}
    </style>
</head>
<body>
    <a href="index.html" class="btn-back">⬅ Quay Lại Command Center</a>
    <h1 class="page-header">BÁO CÁO DOANH THU GUNDAM STORE</h1>

    <div class="card">
        <h3>📊 BỘ LỌC THỐNG KÊ</h3>
        <%
            String loaiLoc = (String) request.getAttribute("loaiLoc");
            String giaTriLoc = (String) request.getAttribute("giaTriLoc");
            String namLoc = (String) request.getAttribute("namLoc");
            
            // Xử lý null để Form không bị lỗi hiển thị
            if(loaiLoc == null) loaiLoc = "nam";
            if(giaTriLoc == null) giaTriLoc = "";
            if(namLoc == null) namLoc = "2024";
        %>
        <form action="thong-ke" method="GET" class="filter-form">
            <div class="filter-box">
                <label>Loại Lọc</label>
                <select name="loaiLoc" id="loaiLocSelect" onchange="toggleInput()">
                    <option value="thang" <%= loaiLoc.equals("thang") ? "selected" : "" %>>Theo Tháng</option>
                    <option value="quy" <%= loaiLoc.equals("quy") ? "selected" : "" %>>Theo Quý</option>
                    <option value="nam" <%= loaiLoc.equals("nam") ? "selected" : "" %>>Cả Năm</option>
                </select>
            </div>
            
            <div class="filter-box" id="giaTriBox" style="<%= loaiLoc.equals("nam") ? "display:none;" : "" %>">
                <label>Nhập Tháng / Quý</label>
                <input type="number" name="giaTriLoc" placeholder="VD: 5" value="<%= giaTriLoc %>">
            </div>

            <div class="filter-box">
                <label>Năm</label>
                <input type="number" name="namLoc" value="<%= namLoc %>" required>
            </div>

            <button type="submit" class="btn-filter">LỌC DỮ LIỆU</button>
        </form>

        <h3>🧾 DANH SÁCH HÓA ĐƠN ĐÃ BÁN</h3>
        <table>
            <thead>
                <tr>
                    <th>Mã Hóa Đơn</th>
                    <th>Ngày Bán (Giờ:Phút)</th>
                    <th>Tổng Tiền Thu Vào</th>
                    <th>Thao Tác</th> 
                </tr>
            </thead>
            <tbody>
                <% 
                    List<HoaDon> danhSach = (List<HoaDon>) request.getAttribute("danhSachHD");
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy - HH:mm:ss");
                    
                    // Thiết lập chuẩn Tiền tệ Việt Nam
                    Locale localeVN = new Locale("vi", "VN");
                    NumberFormat moneyFormat = NumberFormat.getInstance(localeVN);
                    
                    if (danhSach != null && !danhSach.isEmpty()) {
                        for (HoaDon hd : danhSach) {
                %>
                    <tr>
                        <td style="font-weight: bold; color: #7f8c8d;">#HD<%= hd.getMaHD() %></td>
                        <td><%= sdf.format(hd.getNgayLap()) %></td>
                        <td style="color: #27ae60; font-weight: bold;"><%= moneyFormat.format(hd.getTongTien()) %> VNĐ</td>
                        <td>
                            <a href="in-hoa-don?maHD=<%= hd.getMaHD() %>" target="_blank" class="btn-print">🖨️ In Lại</a>
                        </td>
                    </tr>
                <% 
                        }
                    } else {
                %>
                    <tr><td colspan="4" style="color: red; font-weight: bold; padding: 20px;">Chưa có giao dịch nào trong khoảng thời gian này!</td></tr>
                <% } %>
            </tbody>
        </table>
        
        <div class="total-row">
            <%
                Double tongDT = (Double) request.getAttribute("tongDoanhThu");
                String hienThiTong = (tongDT != null && tongDT > 0) ? moneyFormat.format(tongDT) : "0";
            %>
            TỔNG DOANH THU: <%= hienThiTong %> VNĐ
        </div>
    </div>

    <script>
        function toggleInput() {
            var loai = document.getElementById("loaiLocSelect").value;
            var box = document.getElementById("giaTriBox");
            if(loai === "nam") { box.style.display = "none"; } 
            else { box.style.display = "flex"; }
        }
    </script>
</body>
</html>