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
import java.sql.Statement;
import java.util.List;
import models.DBConnection;
import models.ItemGioHang;
import models.KhachHang;
import models.Voucher;

@WebServlet(name = "ThanhToanServlet", urlPatterns = {"/thanh-toan"})
public class ThanhToanServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        List<ItemGioHang> gioHang = (List<ItemGioHang>) session.getAttribute("cart");
        KhachHang kh = (KhachHang) session.getAttribute("currentKhachHang");
        Voucher v = (Voucher) session.getAttribute("currentVoucher");
        
        double tongTienGoc = Double.parseDouble(request.getParameter("tongTienGoc"));
        double tongTienGiam = Double.parseDouble(request.getParameter("tongTienGiam"));
        double khachPhaiTra = Double.parseDouble(request.getParameter("khachPhaiTra"));
        
        if (gioHang != null && !gioHang.isEmpty()) {
            int maHD = 0; 
            try {
                Connection conn = DBConnection.getConnection();
                
                // 1. Insert Hóa Đơn kèm theo MaKH, MaVoucher và Tiền Giảm
                String sqlHoaDon = "INSERT INTO HoaDon (TongTien, MaKH, MaVoucher, TienGiamGia) VALUES (?, ?, ?, ?)";
                PreparedStatement psHoaDon = conn.prepareStatement(sqlHoaDon, Statement.RETURN_GENERATED_KEYS);
                psHoaDon.setDouble(1, khachPhaiTra); // Lưu số tiền THỰC TẾ thu của khách
                
                if (kh != null) psHoaDon.setInt(2, kh.getMaKH());
                else psHoaDon.setNull(2, java.sql.Types.INTEGER);
                
                if (v != null) psHoaDon.setString(3, v.getMaVoucher());
                else psHoaDon.setNull(3, java.sql.Types.VARCHAR);
                
                psHoaDon.setDouble(4, tongTienGiam); // Lưu vết số tiền đã giảm
                psHoaDon.executeUpdate();
                
                ResultSet rs = psHoaDon.getGeneratedKeys();
                if (rs.next()) { maHD = rs.getInt(1); }
                
                // 2. Insert Chi Tiết Hóa Đơn và Trừ Kho
                String sqlChiTiet = "INSERT INTO ChiTietHoaDon (MaHD, MaSP, SoLuongMua, ThanhTien) VALUES (?, ?, ?, ?)";
                String sqlTruKho = "UPDATE SanPham SET SoLuongTon = SoLuongTon - ? WHERE MaSP = ?";
                PreparedStatement psChiTiet = conn.prepareStatement(sqlChiTiet);
                PreparedStatement psTruKho = conn.prepareStatement(sqlTruKho);
                
                for (ItemGioHang item : gioHang) {
                    psChiTiet.setInt(1, maHD);
                    psChiTiet.setInt(2, item.getMaSP());
                    psChiTiet.setInt(3, item.getSoLuongMua());
                    psChiTiet.setDouble(4, item.getSoLuongMua() * item.getGiaBan());
                    psChiTiet.executeUpdate();
                    
                    psTruKho.setInt(1, item.getSoLuongMua());
                    psTruKho.setInt(2, item.getMaSP());
                    psTruKho.executeUpdate();
                }

                // 3. Cộng thêm 1 vào "Số lần mua" cho Khách Hàng thân thiết
                if (kh != null) {
                    String sqlUpdateKH = "UPDATE KhachHang SET SoLanMua = SoLanMua + 1 WHERE MaKH = ?";
                    PreparedStatement psUpdateKH = conn.prepareStatement(sqlUpdateKH);
                    psUpdateKH.setInt(1, kh.getMaKH());
                    psUpdateKH.executeUpdate();
                }
                
                conn.close();
                
                // Đẩy dữ liệu sang trang hóa đơn (invoice.jsp)
                request.setAttribute("maHD", maHD);
                request.setAttribute("hoaDonChiTiet", gioHang);
                request.setAttribute("tongTienGoc", tongTienGoc);
                request.setAttribute("tongTienGiam", tongTienGiam);
                request.setAttribute("khachPhaiTra", khachPhaiTra);

                // Dọn dẹp Session sau khi thanh toán thành công
                session.removeAttribute("cart");
                session.removeAttribute("currentKhachHang");
                session.removeAttribute("currentVoucher");

                request.getRequestDispatcher("invoice.jsp").forward(request, response);
                return; 
                
            } catch (Exception e) { e.printStackTrace(); }
        }
        response.sendRedirect("ban-hang");
    }
}