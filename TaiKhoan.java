package models;

public class TaiKhoan {
    private String username;
    private String password;
    private String hoTen;
    private String vaiTro;

    public TaiKhoan(String username, String password, String hoTen, String vaiTro) {
        this.username = username;
        this.password = password;
        this.hoTen = hoTen;
        this.vaiTro = vaiTro;
    }

    public String getUsername() { return username; }
    public String getPassword() { return password; }
    public String getHoTen() { return hoTen; }
    public String getVaiTro() { return vaiTro; }
}