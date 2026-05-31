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
import models.ItemGioHang;

@WebServlet(name = "InHoaDonServlet", urlPatterns = {"/in-hoa-don"})
public class InHoaDonServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String maHDStr = request.getParameter("maHD");
        if (maHDStr == null) {
            response.sendRedirect("thong-ke");
            return;
        }
        
        int maHD = Integer.parseInt(maHDStr);
        double khachPhaiTra = 0;
        double tongTienGiam = 0;
        List<ItemGioHang> danhSachChiTiet = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();
            
            // 1. Lấy thông tin tổng quát của Hóa Đơn
            String sqlHD = "SELECT TongTien, TienGiamGia FROM HoaDon WHERE MaHD = ?";
            PreparedStatement psHD = conn.prepareStatement(sqlHD);
            psHD.setInt(1, maHD);
            ResultSet rsHD = psHD.executeQuery();
            if (rsHD.next()) {
                khachPhaiTra = rsHD.getDouble("TongTien");
                tongTienGiam = rsHD.getDouble("TienGiamGia");
            }

            // 2. Lấy danh sách chi tiết các món đã mua trong Hóa Đơn đó
            String sqlCT = "SELECT ct.MaSP, sp.TenGundam, ct.SoLuongMua, (ct.ThanhTien / ct.SoLuongMua) AS GiaBan " +
                           "FROM ChiTietHoaDon ct JOIN SanPham sp ON ct.MaSP = sp.MaSP WHERE ct.MaHD = ?";
            PreparedStatement psCT = conn.prepareStatement(sqlCT);
            psCT.setInt(1, maHD);
            ResultSet rsCT = psCT.executeQuery();
            
            while (rsCT.next()) {
                danhSachChiTiet.add(new ItemGioHang(
                    rsCT.getInt("MaSP"),
                    rsCT.getString("TenGundam"),
                    rsCT.getDouble("GiaBan"),
                    rsCT.getInt("SoLuongMua")
                ));
            }
            conn.close();
            
        } catch (Exception e) { 
            e.printStackTrace(); 
        }

        double tongTienGoc = khachPhaiTra + tongTienGiam;

        // Đẩy toàn bộ dữ liệu sang trang invoice.jsp y hệt như lúc thanh toán POS
        request.setAttribute("maHD", maHD);
        request.setAttribute("hoaDonChiTiet", danhSachChiTiet);
        request.setAttribute("tongTienGoc", tongTienGoc);
        request.setAttribute("tongTienGiam", tongTienGiam);
        request.setAttribute("khachPhaiTra", khachPhaiTra);

        request.getRequestDispatcher("invoice.jsp").forward(request, response);
    }
}