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
import models.ItemGioHang;
import models.KhachHang;
import models.SanPham;
import models.Voucher;

@WebServlet(name = "BanHangServlet", urlPatterns = {"/ban-hang"})
public class BanHangServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tuKhoa = request.getParameter("search");
        List<SanPham> danhSachGundam = new ArrayList<>();
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM SanPham WHERE SoLuongTon > 0";
            if (tuKhoa != null && !tuKhoa.trim().isEmpty()) {
                sql += " AND TenGundam LIKE ?";
            }
            PreparedStatement ps = conn.prepareStatement(sql);
            if (tuKhoa != null && !tuKhoa.trim().isEmpty()) {
                ps.setString(1, "%" + tuKhoa + "%");
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                danhSachGundam.add(new SanPham(rs.getInt("MaSP"), rs.getString("TenGundam"), rs.getString("PhanLoai"), rs.getDouble("GiaBan"), rs.getInt("SoLuongTon")));
            }
            conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        
        request.setAttribute("txtSearch", tuKhoa);
        request.setAttribute("danhSach", danhSachGundam);
        request.getRequestDispatcher("banhang.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<ItemGioHang> gioHang = (List<ItemGioHang>) session.getAttribute("cart");
        String action = request.getParameter("action");
        
        // ==========================================
        // NHÁNH 1: XỬ LÝ TRA CỨU KHÁCH HÀNG & VOUCHER
        // ==========================================
        if ("apply_discount".equals(action)) {
            String sdt = request.getParameter("sdt");
            String maVoucher = request.getParameter("maVoucher");
            
            KhachHang kh = null;
            Voucher v = null;
            
            try {
                Connection conn = DBConnection.getConnection();
                
                // Tra cứu Khách hàng bằng SDT
                if (sdt != null && !sdt.trim().isEmpty()) {
                    String sqlKH = "SELECT * FROM KhachHang WHERE SDT = ?";
                    PreparedStatement psKH = conn.prepareStatement(sqlKH);
                    psKH.setString(1, sdt);
                    ResultSet rsKH = psKH.executeQuery();
                    if (rsKH.next()) {
                        kh = new KhachHang(rsKH.getInt("MaKH"), rsKH.getString("TenKH"), rsKH.getString("SDT"), rsKH.getInt("SoLanMua"));
                    }
                }
                
                // Tra cứu Voucher (Chỉ lấy mã còn HoatDong)
                if (maVoucher != null && !maVoucher.trim().isEmpty()) {
                    String sqlV = "SELECT * FROM Voucher WHERE MaVoucher = ? AND TrangThai = 'HoatDong'";
                    PreparedStatement psV = conn.prepareStatement(sqlV);
                    psV.setString(1, maVoucher);
                    ResultSet rsV = psV.executeQuery();
                    if (rsV.next()) {
                        v = new Voucher(rsV.getString("MaVoucher"), rsV.getString("TenDip"), rsV.getInt("PhanTramGiam"), rsV.getInt("TienGiam"), rsV.getString("TrangThai"));
                    }
                }
                conn.close();
            } catch (Exception e) { e.printStackTrace(); }
            
            // Lưu kết quả tra cứu vào Session để JSP tự tính toán
            session.setAttribute("currentKhachHang", kh);
            session.setAttribute("currentVoucher", v);
            
            response.sendRedirect("ban-hang");
            return;
        }

        // ==========================================
        // NHÁNH 2: XỬ LÝ THÊM/XÓA SẢN PHẨM KHỎI GIỎ
        // ==========================================
        if (gioHang == null) { gioHang = new ArrayList<>(); }
        int maSP = Integer.parseInt(request.getParameter("maSP"));
        
        if ("remove".equals(action)) {
            gioHang.removeIf(item -> item.getMaSP() == maSP);
        } else if ("add".equals(action)) {
            String ten = request.getParameter("tenGundam");
            double gia = Double.parseDouble(request.getParameter("giaBan"));
            boolean daCo = false;
            for (ItemGioHang item : gioHang) {
                if (item.getMaSP() == maSP) {
                    item.setSoLuongMua(item.getSoLuongMua() + 1);
                    daCo = true; break;
                }
            }
            if (!daCo) { gioHang.add(new ItemGioHang(maSP, ten, gia, 1)); }
        }
        
        session.setAttribute("cart", gioHang);
        response.sendRedirect("ban-hang");
    }
}