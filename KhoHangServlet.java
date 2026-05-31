package controllers; // Khai báo package chứa Servlet quản lý kho hàng

import jakarta.servlet.ServletException; // Xử lý ngoại lệ Servlet
import jakarta.servlet.annotation.WebServlet; // Annotation ánh xạ URL cho Servlet
import jakarta.servlet.http.HttpServlet; // Lớp cha của các Servlet HTTP
import jakarta.servlet.http.HttpServletRequest; // Nhận dữ liệu từ client gửi lên
import jakarta.servlet.http.HttpServletResponse; // Gửi dữ liệu phản hồi về client
import java.io.IOException; // Xử lý lỗi nhập xuất
import java.sql.Connection; // Kết nối cơ sở dữ liệu
import java.sql.PreparedStatement; // Thực thi câu lệnh SQL có tham số
import java.sql.ResultSet; // Lưu kết quả truy vấn SQL
import java.util.ArrayList; // Danh sách động ArrayList
import java.util.List; // Interface List
import models.DBConnection; // Lớp hỗ trợ kết nối CSDL
import models.SanPham; // Lớp đối tượng sản phẩm

@WebServlet(name = "KhoHangServlet", urlPatterns = {"/kho-hang"})
// Ánh xạ URL "/kho-hang" đến Servlet này

public class KhoHangServlet extends HttpServlet { // Kế thừa HttpServlet

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tuKhoa = request.getParameter("search");
        // Lấy từ khóa tìm kiếm từ ô search

        String sapXep = request.getParameter("sort");
        // Lấy tiêu chí sắp xếp từ giao diện

        List<SanPham> danhSach = new ArrayList<>();
        // Tạo danh sách lưu các sản phẩm lấy từ CSDL

        try {

            Connection conn = DBConnection.getConnection();
            // Mở kết nối tới cơ sở dữ liệu

            StringBuilder sql =
                    new StringBuilder("SELECT * FROM SanPham WHERE 1=1");
            // Khởi tạo câu lệnh SQL
            // WHERE 1=1 giúp dễ dàng nối thêm điều kiện AND phía sau

            if (tuKhoa != null && !tuKhoa.trim().isEmpty()) {
                // Nếu người dùng nhập từ khóa tìm kiếm

                sql.append(" AND TenGundam LIKE ?");
                // Tìm kiếm theo tên Gundam
            }

            if ("name".equals(sapXep)) {
                // Nếu chọn sắp xếp theo tên

                sql.append(" ORDER BY TenGundam ASC");
                // Sắp xếp tên A → Z

            } else if ("price".equals(sapXep)) {
                // Nếu chọn sắp xếp theo giá

                sql.append(" ORDER BY GiaBan ASC");
                // Sắp xếp giá tăng dần

            } else {
                // Trường hợp mặc định

                sql.append(" ORDER BY MaSP DESC");
                // Sản phẩm mới nhất hiển thị trước
            }

            PreparedStatement ps =
                    conn.prepareStatement(sql.toString());
            // Chuyển StringBuilder thành chuỗi SQL
            // và tạo PreparedStatement

            if (tuKhoa != null && !tuKhoa.trim().isEmpty()) {

                ps.setString(1, "%" + tuKhoa + "%");
                // Gán giá trị cho dấu ?
                // Ví dụ nhập Freedom → %Freedom%
            }

            ResultSet rs = ps.executeQuery();
            // Thực hiện truy vấn dữ liệu

            while (rs.next()) {
                // Duyệt từng dòng dữ liệu

                danhSach.add(
                        new SanPham(
                                rs.getInt("MaSP"),       // Mã sản phẩm
                                rs.getString("TenGundam"), // Tên Gundam
                                rs.getString("PhanLoai"),  // Phân loại
                                rs.getDouble("GiaBan"),    // Giá bán
                                rs.getInt("SoLuongTon")    // Số lượng tồn kho
                        )
                );
                // Tạo đối tượng SanPham và thêm vào danh sách
            }

            conn.close();
            // Đóng kết nối cơ sở dữ liệu

        } catch (Exception e) {

            e.printStackTrace();
            // Hiển thị lỗi trên Console
        }

        request.setAttribute("txtSearch", tuKhoa);
        // Gửi lại từ khóa tìm kiếm sang JSP

        request.setAttribute("danhSach", danhSach);
        // Gửi danh sách sản phẩm sang JSP

        request.getRequestDispatcher("khohang.jsp")
                .forward(request, response);
        // Chuyển dữ liệu sang giao diện khohang.jsp
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        // Hỗ trợ nhập tiếng Việt có dấu

        String ten = request.getParameter("tenGundam");
        // Lấy tên Gundam từ form

        String phanLoai = request.getParameter("phanLoai");
        // Lấy phân loại sản phẩm

        double gia =
                Double.parseDouble(request.getParameter("giaBan"));
        // Chuyển giá bán từ String sang double

        int soLuong =
                Integer.parseInt(request.getParameter("soLuongTon"));
        // Chuyển số lượng tồn từ String sang int

        try {

            Connection conn = DBConnection.getConnection();
            // Kết nối CSDL

            String sql =
                    "INSERT INTO SanPham (TenGundam, PhanLoai, GiaBan, SoLuongTon) "
                    + "VALUES (?, ?, ?, ?)";
            // Câu lệnh thêm sản phẩm mới vào bảng SanPham

            PreparedStatement ps =
                    conn.prepareStatement(sql);
            // Tạo PreparedStatement

            ps.setString(1, ten);
            // Gán tên Gundam cho tham số thứ nhất

            ps.setString(2, phanLoai);
            // Gán phân loại cho tham số thứ hai

            ps.setDouble(3, gia);
            // Gán giá bán cho tham số thứ ba

            ps.setInt(4, soLuong);
            // Gán số lượng tồn cho tham số thứ tư

            ps.executeUpdate();
            // Thực hiện lệnh INSERT

            conn.close();
            // Đóng kết nối CSDL

        } catch (Exception e) {

            e.printStackTrace();
            // Hiển thị lỗi nếu có
        }

        response.sendRedirect("kho-hang");
        // Sau khi thêm thành công quay lại trang kho hàng
    }
}