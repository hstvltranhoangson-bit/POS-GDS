package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import models.DBConnection;
import models.KhachHang;
import models.HoaDon;

@WebServlet(name = "KhachHangServlet", urlPatterns = {"/khach-hang"})
public class KhachHangServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String search = request.getParameter("search");
        String maKHStr = request.getParameter("maKH"); // Bắt ID khách khi người dùng click Xem Lịch Sử
        
        List<KhachHang> danhSachKH = new ArrayList<>();
        List<HoaDon> danhSachHD = new ArrayList<>();
        KhachHang khachHangDuocChon = null;

        try {
            Connection conn = DBConnection.getConnection();
            
            // 1. Load danh sách toàn bộ khách hàng (có hỗ trợ tìm kiếm bằng SĐT hoặc Tên)
            String sqlKH = "SELECT * FROM KhachHang WHERE 1=1";
            if (search != null && !search.trim().isEmpty()) {
                sqlKH += " AND (TenKH LIKE ? OR SDT LIKE ?)";
            }
            PreparedStatement psKH = conn.prepareStatement(sqlKH);
            if (search != null && !search.trim().isEmpty()) {
                psKH.setString(1, "%" + search + "%");
                psKH.setString(2, "%" + search + "%");
            }
            ResultSet rsKH = psKH.executeQuery();
            while (rsKH.next()) {
                danhSachKH.add(new KhachHang(rsKH.getInt("MaKH"), rsKH.getString("TenKH"), rsKH.getString("SDT"), rsKH.getInt("SoLanMua")));
            }
            
            // 2. Nếu thu ngân click vào nút "Xem lịch sử" của 1 khách hàng
            if (maKHStr != null && !maKHStr.isEmpty()) {
                int maKH = Integer.parseInt(maKHStr);
                
                // Lấy chi tiết thông tin khách đó
                String sqlKHChon = "SELECT * FROM KhachHang WHERE MaKH = ?";
                PreparedStatement psKHChon = conn.prepareStatement(sqlKHChon);
                psKHChon.setInt(1, maKH);
                ResultSet rsKHChon = psKHChon.executeQuery();
                if (rsKHChon.next()) {
                    khachHangDuocChon = new KhachHang(rsKHChon.getInt("MaKH"), rsKHChon.getString("TenKH"), rsKHChon.getString("SDT"), rsKHChon.getInt("SoLanMua"));
                }
                
                // Lấy toàn bộ Hóa đơn của khách đó
                String sqlHD = "SELECT * FROM HoaDon WHERE MaKH = ? ORDER BY NgayLap DESC";
                PreparedStatement psHD = conn.prepareStatement(sqlHD);
                psHD.setInt(1, maKH);
                ResultSet rsHD = psHD.executeQuery();
                while (rsHD.next()) {
                    danhSachHD.add(new HoaDon(rsHD.getInt("MaHD"), rsHD.getTimestamp("NgayLap"), rsHD.getDouble("TongTien")));
                }
            }
            
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("txtSearch", search);
        request.setAttribute("danhSachKH", danhSachKH);
        request.setAttribute("khachHangDuocChon", khachHangDuocChon);
        request.setAttribute("danhSachHD", danhSachHD);
        
        request.getRequestDispatcher("khachhang.jsp").forward(request, response);
    }
}