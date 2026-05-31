package controllers; // Khai báo package chứa các Servlet điều khiển

import jakarta.servlet.ServletException; // Xử lý ngoại lệ Servlet
import jakarta.servlet.annotation.WebServlet; // Annotation ánh xạ URL cho Servlet
import jakarta.servlet.http.HttpServlet; // Lớp cha của các Servlet HTTP
import jakarta.servlet.http.HttpServletRequest; // Đối tượng nhận dữ liệu từ client
import jakarta.servlet.http.HttpServletResponse; // Đối tượng gửi phản hồi về client
import java.io.IOException; // Xử lý lỗi nhập xuất (I/O)
import java.sql.Connection; // Kết nối cơ sở dữ liệu
import java.sql.PreparedStatement; // Thực thi câu lệnh SQL có tham số
import java.sql.ResultSet; // Chứa kết quả truy vấn SQL
import models.DBConnection; // Lớp hỗ trợ kết nối MySQL
import models.SanPham; // Lớp mô hình sản phẩm

@WebServlet(name = "SuaSanPhamServlet", urlPatterns = {"/sua-san-pham"})
// Ánh xạ URL /sua-san-pham tới Servlet này

public class SuaSanPhamServlet extends HttpServlet {

    // ==================================================
    // HÀM GET: Hiển thị thông tin sản phẩm cần sửa
    // ==================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String maSP = request.getParameter("id");
        // Lấy mã sản phẩm từ URL
        // Ví dụ: sua-san-pham?id=5

        SanPham sp = null;
        // Khởi tạo biến sản phẩm để chứa dữ liệu lấy từ DB

        try {

            Connection conn = DBConnection.getConnection();
            // Mở kết nối tới cơ sở dữ liệu

            String sql = "SELECT * FROM SanPham WHERE MaSP = ?";
            // Truy vấn sản phẩm theo mã sản phẩm

            PreparedStatement ps = conn.prepareStatement(sql);
            // Tạo đối tượng PreparedStatement

            ps.setInt(1, Integer.parseInt(maSP));
            // Gán giá trị cho dấu ? trong SQL

            ResultSet rs = ps.executeQuery();
            // Thực hiện truy vấn SELECT

            if (rs.next()) {
                // Nếu tìm thấy sản phẩm

                sp = new SanPham(
                    rs.getInt("MaSP"),          // Mã sản phẩm
                    rs.getString("TenGundam"),  // Tên Gundam
                    rs.getString("PhanLoai"),   // Phân loại
                    rs.getDouble("GiaBan"),     // Giá bán
                    rs.getInt("SoLuongTon")     // Số lượng tồn kho
                );

                // Tạo đối tượng SanPham từ dữ liệu DB
            }

            conn.close();
            // Đóng kết nối cơ sở dữ liệu

        } catch (Exception e) {

            e.printStackTrace();
            // In lỗi ra Console nếu xảy ra lỗi
        }

        request.setAttribute("sanPhamEdit", sp);
        // Đưa đối tượng sản phẩm sang JSP

        request.getRequestDispatcher("suasanpham.jsp")
               .forward(request, response);
        // Chuyển dữ liệu tới trang suasanpham.jsp
    }

    // ==================================================
    // HÀM POST: Cập nhật sản phẩm vào cơ sở dữ liệu
    // ==================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        // Hỗ trợ nhập tiếng Việt có dấu

        int maSP =
                Integer.parseInt(request.getParameter("maSP"));
        // Lấy mã sản phẩm từ form

        String ten =
                request.getParameter("tenGundam");
        // Lấy tên Gundam

        String phanLoai =
                request.getParameter("phanLoai");
        // Lấy phân loại sản phẩm

        double gia =
                Double.parseDouble(request.getParameter("giaBan"));
        // Lấy giá bán và chuyển sang kiểu double

        int soLuong =
                Integer.parseInt(request.getParameter("soLuongTon"));
        // Lấy số lượng tồn kho và chuyển sang int

        try {

            Connection conn = DBConnection.getConnection();
            // Kết nối cơ sở dữ liệu

            String sql =
                "UPDATE SanPham "
              + "SET TenGundam = ?, "
              + "PhanLoai = ?, "
              + "GiaBan = ?, "
              + "SoLuongTon = ? "
              + "WHERE MaSP = ?";

            // Câu lệnh UPDATE cập nhật dữ liệu sản phẩm

            PreparedStatement ps = conn.prepareStatement(sql);
            // Tạo PreparedStatement

            ps.setString(1, ten);
            // Gán tên Gundam cho tham số thứ nhất

            ps.setString(2, phanLoai);
            // Gán phân loại cho tham số thứ hai

            ps.setDouble(3, gia);
            // Gán giá bán cho tham số thứ ba

            ps.setInt(4, soLuong);
            // Gán số lượng tồn kho cho tham số thứ tư

            ps.setInt(5, maSP);
            // Gán mã sản phẩm cho điều kiện WHERE

            ps.executeUpdate();
            // Thực hiện lệnh UPDATE

            conn.close();
            // Đóng kết nối cơ sở dữ liệu

        } catch (Exception e) {

            e.printStackTrace();
            // Hiển thị lỗi nếu có
        }

        response.sendRedirect("kho-hang");
        // Sau khi sửa thành công quay lại trang kho hàng
    }
}