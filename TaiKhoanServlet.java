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
import java.util.ArrayList;
import java.util.List;
import models.DBConnection;
import models.TaiKhoan;

@WebServlet(name = "TaiKhoanServlet", urlPatterns = {"/tai-khoan"})
public class TaiKhoanServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. BẢO MẬT: Chỉ Admin mới được phép truy cập trang này!
        HttpSession session = request.getSession();
        TaiKhoan user = (TaiKhoan) session.getAttribute("userLogin");
        if (user == null || !user.getVaiTro().equals("Admin")) {
            response.sendRedirect("index.html");
            return;
        }

        String action = request.getParameter("action");
        try {
            Connection conn = DBConnection.getConnection();
            
            // Xóa Tài Khoản
            if ("delete".equals(action)) {
                String id = request.getParameter("id");
                
                // BẢO VỆ CHỐNG "TỰ SÁT": Không cho phép Admin tự xóa chính mình
                if (!id.equals(user.getUsername())) {
                    PreparedStatement ps = conn.prepareStatement("DELETE FROM TaiKhoan WHERE Username = ?");
                    ps.setString(1, id);
                    ps.executeUpdate();
                }
                response.sendRedirect("tai-khoan");
                return;
            }

            // Load danh sách hiển thị
            List<TaiKhoan> list = new ArrayList<>();
            ResultSet rs = conn.prepareStatement("SELECT * FROM TaiKhoan").executeQuery();
            while(rs.next()){
                list.add(new TaiKhoan(rs.getString("Username"), rs.getString("Password"), rs.getString("HoTen"), rs.getString("VaiTro")));
            }
            request.setAttribute("danhSachTaiKhoan", list);
            conn.close();
        } catch(Exception e){ e.printStackTrace(); }
        
        request.getRequestDispatcher("taikhoan.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        // Thêm Tài Khoản mới
        if("add".equals(action)) {
            String u = request.getParameter("username").trim();
            String p = request.getParameter("password").trim();
            String ten = request.getParameter("hoTen");
            String vaiTro = request.getParameter("vaiTro");
            
            try {
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement("INSERT INTO TaiKhoan (Username, Password, HoTen, VaiTro) VALUES (?, ?, ?, ?)");
                ps.setString(1, u);
                ps.setString(2, p);
                ps.setString(3, ten);
                ps.setString(4, vaiTro);
                ps.executeUpdate();
                conn.close();
            } catch(Exception e){ e.printStackTrace(); }
        }
        response.sendRedirect("tai-khoan");
    }
}