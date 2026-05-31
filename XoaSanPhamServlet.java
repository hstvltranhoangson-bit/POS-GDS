package controllers; // Khai báo package chứa các Servlet điều khiển

import jakarta.servlet.ServletException; // Xử lý ngoại lệ Servlet
import jakarta.servlet.annotation.WebServlet; // Annotation dùng để ánh xạ URL tới Servlet
import jakarta.servlet.http.HttpServlet; // Lớp cha của tất cả Servlet HTTP
import jakarta.servlet.http.HttpServletRequest; // Nhận dữ liệu từ client gửi lên
import jakarta.servlet.http.HttpServletResponse; // Gửi phản hồi về client
import java.io.IOException; // Xử lý lỗi nhập xuất
import java.sql.Connection; // Kết nối cơ sở dữ liệu
import java.sql.PreparedStatement; // Thực thi câu lệnh SQL có tham số
import models.DBConnection; // Lớp hỗ trợ kết nối MySQL

@WebServlet(name = "XoaSanPhamServlet", urlPatterns = {"/xoa-san-pham"})
// Ánh xạ URL "/xoa-san-pham" tới Servlet này

public class XoaSanPhamServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String maSP = request.getParameter("id");
        // Lấy mã sản phẩm từ URL
        // Ví dụ:
        // http://localhost:8080/qlsp/xoa-san-pham?id=5
        // => maSP = "5"

        try {

            Connection conn = DBConnection.getConnection();
            // Mở kết nối tới cơ sở dữ liệu MySQL

            String sql = "DELETE FROM SanPham WHERE MaSP = ?";
            // Câu lệnh SQL xóa sản phẩm theo mã sản phẩm

            PreparedStatement ps = conn.prepareStatement(sql);
            // Tạo đối tượng PreparedStatement

            ps.setInt(1, Integer.parseInt(maSP));
            // Gán giá trị cho dấu ?
            // Ví dụ:
            // DELETE FROM SanPham WHERE MaSP = 5

            ps.executeUpdate();
            // Thực hiện lệnh DELETE

            conn.close();
            // Đóng kết nối cơ sở dữ liệu

        } catch (Exception e) {

            e.printStackTrace();
            // In lỗi ra Console nếu có lỗi xảy ra
        }

        // Xóa xong thì load lại trang kho hàng
        response.sendRedirect("kho-hang");
        // Chuyển hướng về trang quản lý kho hàng
    }
}