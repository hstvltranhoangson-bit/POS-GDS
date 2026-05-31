package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import models.DBConnection;
import models.TaiKhoan;

@WebServlet(name = "DangNhapServlet", urlPatterns = {"/dang-nhap", "/dang-xuat"})
public class DangNhapServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý Đăng xuất
        if (request.getServletPath().equals("/dang-xuat")) {
            request.getSession().invalidate(); // Hủy thẻ ra vào
            response.sendRedirect("dang-nhap");
            return;
        }
        // Hiển thị trang đăng nhập
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String u = request.getParameter("username");
        String p = request.getParameter("password");
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM TaiKhoan WHERE Username = ? AND Password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, u);
            ps.setString(2, p);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // Đăng nhập thành công -> Tạo đối tượng và lưu vào Session
                TaiKhoan tk = new TaiKhoan(rs.getString("Username"), rs.getString("Password"), rs.getString("HoTen"), rs.getString("VaiTro"));
                HttpSession session = request.getSession();
                session.setAttribute("userLogin", tk);
                
                response.sendRedirect("index.html"); // Vào Command Center
            } else {
                // Sai Pass
                request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            conn.close();
        } catch (Exception e) { e.printStackTrace(); }
    }
}