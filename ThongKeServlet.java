package controllers; // Khai báo package chứa các Servlet điều khiển

import jakarta.servlet.ServletException; // Xử lý ngoại lệ Servlet
import jakarta.servlet.annotation.WebServlet; // Annotation ánh xạ URL tới Servlet
import jakarta.servlet.http.HttpServlet; // Lớp cha của các Servlet HTTP
import jakarta.servlet.http.HttpServletRequest; // Nhận dữ liệu từ client gửi lên
import jakarta.servlet.http.HttpServletResponse; // Gửi phản hồi về client
import java.io.IOException; // Xử lý lỗi nhập xuất
import java.sql.Connection; // Kết nối cơ sở dữ liệu
import java.sql.PreparedStatement; // Thực thi SQL có tham số
import java.sql.ResultSet; // Lưu kết quả truy vấn SQL
import java.util.ArrayList; // Danh sách động ArrayList
import java.util.List; // Interface List
import models.DBConnection; // Lớp hỗ trợ kết nối MySQL
import models.HoaDon; // Lớp đối tượng hóa đơn

@WebServlet(name = "ThongKeServlet", urlPatterns = {"/thong-ke"})
// Ánh xạ URL /thong-ke tới Servlet này

public class ThongKeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String loaiLoc = request.getParameter("loaiLoc");
        // Nhận loại lọc từ giao diện
        // Có thể là: thang, quy hoặc nam

        String giaTriLoc = request.getParameter("giaTriLoc");
        // Giá trị tương ứng
        // Ví dụ:
        // thang = 5
        // quy = 2

        String namLoc = request.getParameter("namLoc");
        // Năm cần thống kê
        // Ví dụ: 2026

        List<HoaDon> danhSachHD = new ArrayList<>();
        // Danh sách lưu các hóa đơn tìm được

        double tongDoanhThu = 0;
        // Biến lưu tổng doanh thu

        try {

            Connection conn = DBConnection.getConnection();
            // Mở kết nối cơ sở dữ liệu

            String sql = "SELECT * FROM HoaDon WHERE 1=1";
            // Khởi tạo câu lệnh SQL
            // WHERE 1=1 giúp nối thêm AND dễ dàng

            // ===================================
            // XÂY DỰNG CÂU LỆNH LỌC
            // ===================================

            if (loaiLoc != null
                    && !loaiLoc.isEmpty()
                    && namLoc != null
                    && !namLoc.isEmpty()) {

                // Nếu người dùng chọn lọc dữ liệu

                if (loaiLoc.equals("thang")) {

                    sql += " AND MONTH(NgayLap) = ? "
                         + "AND YEAR(NgayLap) = ?";
                    // Lọc theo tháng và năm

                } else if (loaiLoc.equals("quy")) {

                    sql += " AND QUARTER(NgayLap) = ? "
                         + "AND YEAR(NgayLap) = ?";
                    // Lọc theo quý và năm

                } else if (loaiLoc.equals("nam")) {

                    sql += " AND YEAR(NgayLap) = ?";
                    // Lọc theo năm
                }

            } else {

                sql += " AND YEAR(NgayLap) = YEAR(CURDATE())";
                // Nếu không chọn gì
                // Mặc định lấy hóa đơn của năm hiện tại
            }

            sql += " ORDER BY NgayLap DESC";
            // Sắp xếp hóa đơn mới nhất lên đầu

            PreparedStatement ps =
                    conn.prepareStatement(sql);
            // Tạo PreparedStatement

            // ===================================
            // GÁN GIÁ TRỊ CHO DẤU ?
            // ===================================

            if (loaiLoc != null
                    && !loaiLoc.isEmpty()
                    && namLoc != null
                    && !namLoc.isEmpty()) {

                if (loaiLoc.equals("nam")) {

                    ps.setInt(
                            1,
                            Integer.parseInt(namLoc));
                    // Gán năm cho dấu ?

                } else {

                    ps.setInt(
                            1,
                            Integer.parseInt(giaTriLoc));
                    // Gán tháng hoặc quý

                    ps.setInt(
                            2,
                            Integer.parseInt(namLoc));
                    // Gán năm
                }
            }

            ResultSet rs = ps.executeQuery();
            // Thực hiện truy vấn dữ liệu

            while (rs.next()) {
                // Duyệt từng dòng kết quả

                HoaDon hd = new HoaDon(
                        rs.getInt("MaHD"),          // Mã hóa đơn
                        rs.getTimestamp("NgayLap"), // Ngày lập
                        rs.getDouble("TongTien")    // Tổng tiền
                );

                danhSachHD.add(hd);
                // Thêm hóa đơn vào danh sách

                tongDoanhThu += hd.getTongTien();
                // Cộng dồn doanh thu
            }

            conn.close();
            // Đóng kết nối cơ sở dữ liệu

        } catch (Exception e) {

            e.printStackTrace();
            // Hiển thị lỗi nếu có
        }

        // ===================================
        // GIỮ LẠI GIÁ TRỊ ĐÃ CHỌN TRÊN FORM
        // ===================================

        request.setAttribute("loaiLoc", loaiLoc);
        // Gửi loại lọc sang JSP

        request.setAttribute("giaTriLoc", giaTriLoc);
        // Gửi giá trị tháng hoặc quý

        request.setAttribute("namLoc", namLoc);
        // Gửi năm được chọn

        // ===================================
        // GỬI KẾT QUẢ THỐNG KÊ
        // ===================================

        request.setAttribute("danhSachHD", danhSachHD);
        // Danh sách hóa đơn

        request.setAttribute("tongDoanhThu", tongDoanhThu);
        // Tổng doanh thu tính được

        request.getRequestDispatcher("thongke.jsp")
               .forward(request, response);
        // Chuyển dữ liệu sang trang thống kê
    }
}