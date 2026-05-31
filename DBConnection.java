package models; // Khai báo package models

import java.sql.Connection; // Import lớp Connection để làm việc với kết nối Database
import java.sql.DriverManager; // Import DriverManager để tạo kết nối tới Database
import java.sql.SQLException; // Import SQLException để xử lý lỗi SQL

public class DBConnection { // Khai báo lớp DBConnection
    
    // Đường dẫn tới Database gundam_shop trên localhost XAMPP
    private static final String URL = "jdbc:mysql://localhost:3306/gundam_shop?useUnicode=true&characterEncoding=UTF-8"; 
    // URL kết nối tới MySQL Database tên gundam_shop

    // Tài khoản mặc định của XAMPP
    private static final String USER = "root"; 
    // Username đăng nhập MySQL

    // Mật khẩu mặc định của XAMPP thường để trống
    private static final String PASSWORD = ""; 
    // Password đăng nhập MySQL

    public static Connection getConnection() { // Phương thức tạo kết nối Database
        Connection conn = null; // Khởi tạo đối tượng kết nối ban đầu là null

        try { // Bắt đầu khối xử lý ngoại lệ

            // Nạp Driver MySQL
            Class.forName("com.mysql.cj.jdbc.Driver"); 
            // Load thư viện Driver MySQL vào chương trình

            // Thực hiện kết nối
            conn = DriverManager.getConnection(URL, USER, PASSWORD); 
            // Tạo kết nối tới Database bằng URL, USER và PASSWORD

            System.out.println("Kết nối Database Gundam Shop thành công!"); 
            // In thông báo nếu kết nối thành công

        } catch (ClassNotFoundException | SQLException e) { 
            // Bắt lỗi nếu không tìm thấy Driver hoặc lỗi SQL

            System.out.println("Lỗi kết nối Database: " + e.getMessage()); 
            // In thông báo lỗi ra màn hình
        }

        return conn; 
        // Trả về đối tượng kết nối
    }

    // Hàm main để test thử xem kết nối có hoạt động không
    public static void main(String[] args) { // Hàm main chạy chương trình
        getConnection(); // Gọi hàm kết nối Database
    }
}