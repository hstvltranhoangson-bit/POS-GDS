package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import models.TaiKhoan;

@WebServlet(name = "UserInfoServlet", urlPatterns = {"/api/user-info"})
public class UserInfoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession();
        TaiKhoan user = (TaiKhoan) session.getAttribute("userLogin");
        
        if (user == null) {
            out.print("{\"status\":\"error\"}");
        } else {
            out.print("{\"status\":\"ok\", \"hoTen\":\"" + user.getHoTen() + "\", \"vaiTro\":\"" + user.getVaiTro() + "\"}");
        }
    }
}