package models; // Khai báo package tên là models để quản lý lớp

public class SanPham { // Khai báo lớp SanPham

    private int maSP; // Biến lưu mã sản phẩm
    private String tenGundam; // Biến lưu tên Gundam
    private String phanLoai; // Biến lưu phân loại sản phẩm
    private double giaBan; // Biến lưu giá bán sản phẩm
    private int soLuongTon; // Biến lưu số lượng tồn kho

    // Constructor trống
    public SanPham() { // Hàm khởi tạo không có tham số
    }

    // Constructor đầy đủ
    public SanPham(int maSP, String tenGundam, String phanLoai, double giaBan, int soLuongTon) {
        this.maSP = maSP; // Gán giá trị maSP vào biến của đối tượng
        this.tenGundam = tenGundam; // Gán tên Gundam
        this.phanLoai = phanLoai; // Gán phân loại sản phẩm
        this.giaBan = giaBan; // Gán giá bán
        this.soLuongTon = soLuongTon; // Gán số lượng tồn kho
    }

    // Getters và Setters

    public int getMaSP() { // Phương thức lấy mã sản phẩm
        return maSP; // Trả về mã sản phẩm
    }

    public void setMaSP(int maSP) { // Phương thức cập nhật mã sản phẩm
        this.maSP = maSP; // Gán giá trị mới cho mã sản phẩm
    }
    
    public String getTenGundam() { // Phương thức lấy tên Gundam
        return tenGundam; // Trả về tên Gundam
    }

    public void setTenGundam(String tenGundam) { // Phương thức cập nhật tên Gundam
        this.tenGundam = tenGundam; // Gán giá trị mới cho tên Gundam
    }
    
    public String getPhanLoai() { // Phương thức lấy phân loại sản phẩm
        return phanLoai; // Trả về phân loại
    }

    public void setPhanLoai(String phanLoai) { // Phương thức cập nhật phân loại
        this.phanLoai = phanLoai; // Gán giá trị mới cho phân loại
    }
    
    public double getGiaBan() { // Phương thức lấy giá bán
        return giaBan; // Trả về giá bán
    }

    public void setGiaBan(double giaBan) { // Phương thức cập nhật giá bán
        this.giaBan = giaBan; // Gán giá trị mới cho giá bán
    }
    
    public int getSoLuongTon() { // Phương thức lấy số lượng tồn kho
        return soLuongTon; // Trả về số lượng tồn kho
    }

    public void setSoLuongTon(int soLuongTon) { // Phương thức cập nhật số lượng tồn kho
        this.soLuongTon = soLuongTon; // Gán giá trị mới cho số lượng tồn kho
    }
}