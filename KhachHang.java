
package models;

public class KhachHang {
    private int maKH;
    private String tenKH;
    private String sdt;
    private int soLanMua;
    
    public KhachHang(int maKH, String tenKH, String sdt,int soLanMua){
      this.maKH = maKH;
      this.tenKH = tenKH;
      this.sdt = sdt;
      this.soLanMua = soLanMua;
      
    }
    
    public int getMaKH(){return maKH; }
    public String getTenKH(){return tenKH; }
    public String getSdt(){return sdt; }
    public int getSoLanMua(){return soLanMua; }
}
