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
import models.Voucher;

@WebServlet(name = "VoucherServlet", urlPatterns = {"/voucher"})
public class VoucherServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. BẢO MẬT KÉP: Kiểm tra quyền trực tiếp tại Backend
        HttpSession session = request.getSession();
        TaiKhoan user = (TaiKhoan) session.getAttribute("userLogin");
        if (user == null || (!user.getVaiTro().equals("Admin") && !user.getVaiTro().equals("KeToan"))) {
            // Không phải Chủ hoặc Kế toán -> Đuổi về Command Center
            response.sendRedirect("index.html");
            return;
        }

        String action = request.getParameter("action");
        try {
            Connection conn = DBConnection.getConnection();
            
            // Xóa Voucher
            if ("delete".equals(action)) {
                String id = request.getParameter("id");
                PreparedStatement ps = conn.prepareStatement("DELETE FROM Voucher WHERE MaVoucher = ?");
                ps.setString(1, id);
                ps.executeUpdate();
                response.sendRedirect("voucher");
                return;
            } 
            // Đổi trạng thái (Hoạt động <-> Hết hạn)
            else if ("toggle".equals(action)) {
                String id = request.getParameter("id");
                String current = request.getParameter("current");
                String newStatus = current.equals("HoatDong") ? "HetHan" : "HoatDong";
                PreparedStatement ps = conn.prepareStatement("UPDATE Voucher SET TrangThai = ? WHERE MaVoucher = ?");
                ps.setString(1, newStatus);
                ps.setString(2, id);
                ps.executeUpdate();
                response.sendRedirect("voucher");
                return;
            }

            // Load danh sách hiển thị
            List<Voucher> list = new ArrayList<>();
            ResultSet rs = conn.prepareStatement("SELECT * FROM Voucher").executeQuery();
            while(rs.next()){
                list.add(new Voucher(rs.getString("MaVoucher"), rs.getString("TenDip"), rs.getInt("PhanTramGiam"), rs.getInt("TienGiam"), rs.getString("TrangThai")));
            }
            request.setAttribute("danhSachVoucher", list);
            conn.close();
        } catch(Exception e){ e.printStackTrace(); }
        
        request.getRequestDispatcher("voucher.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        // Thêm Voucher mới
        if("add".equals(action)) {
            String ma = request.getParameter("maVoucher").toUpperCase().replaceAll("\\s+", ""); // Ép viết hoa, xóa dấu cách
            String ten = request.getParameter("tenDip");
            int phanTram = Integer.parseInt(request.getParameter("phanTramGiam"));
            int tien = Integer.parseInt(request.getParameter("tienGiam"));
            
            try {
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement("INSERT INTO Voucher (MaVoucher, TenDip, PhanTramGiam, TienGiam, TrangThai) VALUES (?, ?, ?, ?, 'HoatDong')");
                ps.setString(1, ma);
                ps.setString(2, ten);
                ps.setInt(3, phanTram);
                ps.setInt(4, tien);
                ps.executeUpdate();
                conn.close();
            } catch(Exception e){ e.printStackTrace(); }
        }
        response.sendRedirect("voucher");
    }
}