package models; // Khai báo package models

import java.sql.Timestamp; // Import lớp Timestamp để lưu ngày giờ

public class HoaDon { // Khai báo lớp HoaDon

    private int maHD; // Biến lưu mã hóa đơn
    private Timestamp ngayLap; // Biến lưu ngày lập hóa đơn
    private double tongTien; // Biến lưu tổng tiền hóa đơn

    public HoaDon(int maHD, Timestamp ngayLap, double tongTien) { 
        // Constructor dùng để khởi tạo đối tượng HoaDon

        this.maHD = maHD; // Gán mã hóa đơn
        this.ngayLap = ngayLap; // Gán ngày lập hóa đơn
        this.tongTien = tongTien; // Gán tổng tiền hóa đơn
    }

    public int getMaHD() { // Phương thức lấy mã hóa đơn
        return maHD; // Trả về mã hóa đơn
    }

    public Timestamp getNgayLap() { // Phương thức lấy ngày lập hóa đơn
        return ngayLap; // Trả về ngày lập
    }

    public double getTongTien() { // Phương thức lấy tổng tiền
        return tongTien; // Trả về tổng tiền hóa đơn
    }
}