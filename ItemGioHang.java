package models; // Khai báo package chứa lớp ItemGioHang

public class ItemGioHang { // Khai báo lớp ItemGioHang dùng để lưu thông tin một sản phẩm trong giỏ hàng

    private int maSP; // Mã sản phẩm (ID của sản phẩm)
    
    private String tenGundam; // Tên sản phẩm Gundam
    
    private double giaBan; // Giá bán của sản phẩm
    
    private int soLuongMua; // Số lượng khách hàng mua

    // Constructor dùng để khởi tạo đối tượng ItemGioHang
    public ItemGioHang(int maSP, String tenGundam, double giaBan, int soLuongMua) {
        
        this.maSP = maSP; // Gán giá trị tham số maSP cho thuộc tính maSP của đối tượng
        
        this.tenGundam = tenGundam; // Gán tên Gundam cho thuộc tính tenGundam
        
        this.giaBan = giaBan; // Gán giá bán cho thuộc tính giaBan
        
        this.soLuongMua = soLuongMua; // Gán số lượng mua cho thuộc tính soLuongMua
    }

    // Getter lấy mã sản phẩm
    public int getMaSP() {
        return maSP; // Trả về giá trị mã sản phẩm
    }

    // Getter lấy tên Gundam
    public String getTenGundam() {
        return tenGundam; // Trả về tên sản phẩm
    }

    // Getter lấy giá bán
    public double getGiaBan() {
        return giaBan; // Trả về giá bán của sản phẩm
    }

    // Getter lấy số lượng mua
    public int getSoLuongMua() {
        return soLuongMua; // Trả về số lượng sản phẩm được mua
    }

    // Setter cập nhật số lượng mua
    public void setSoLuongMua(int soLuongMua) {
        this.soLuongMua = soLuongMua; // Gán giá trị mới cho thuộc tính soLuongMua
    }
}