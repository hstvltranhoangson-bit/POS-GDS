
package models;


public class Voucher {
    private String maVoucher;
    private String tenDip;
    private int phanTramGiam;
    private int tienGiam;
    private String trangThai;
    

    public Voucher(String maVoucher, String tenDip, int phanTramGiam, int tienGiam, String trangThai ) {
        this.maVoucher = maVoucher;      
        this.tenDip = tenDip;
        this.phanTramGiam = phanTramGiam;
        this.tienGiam = tienGiam;
        this.trangThai = trangThai;    
    }
    public String getMaVoucher(){return maVoucher;}
    public String getTenDip(){return tenDip;}
    public int getPhanTramGiam(){return phanTramGiam;}
    public int getTienGiam(){return tienGiam;}
    public String getTrangThai(){return trangThai;}
}
