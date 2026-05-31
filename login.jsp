<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng Nhập Hệ Thống - Gundam Store</title>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Roboto', sans-serif; background: #1b2735; color: #fff; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-box { background: rgba(255, 255, 255, 0.05); padding: 40px; border-radius: 10px; border: 1px solid rgba(255,255,255,0.1); backdrop-filter: blur(10px); width: 350px; text-align: center; box-shadow: 0 10px 30px rgba(0,0,0,0.5);}
        h2 { font-family: 'Orbitron', sans-serif; color: #f39c12; margin-bottom: 30px; letter-spacing: 2px; }
        .input-group { margin-bottom: 20px; text-align: left; }
        .input-group label { display: block; font-size: 13px; color: #aaa; margin-bottom: 5px; text-transform: uppercase;}
        .input-group input { width: 100%; padding: 12px; border: none; border-radius: 4px; background: rgba(0,0,0,0.2); color: #fff; outline: none; border: 1px solid #34495e; box-sizing: border-box;}
        .input-group input:focus { border-color: #f39c12; }
        .btn-login { width: 100%; padding: 12px; background: #f39c12; color: #000; border: none; border-radius: 4px; font-family: 'Orbitron', sans-serif; font-weight: bold; cursor: pointer; transition: 0.3s; font-size: 16px;}
        .btn-login:hover { background: #e67e22; box-shadow: 0 0 15px #f39c12; }
        .error { color: #e74c3c; font-size: 13px; margin-bottom: 15px; font-weight: bold;}
    </style>
</head>
<body>
    <div class="login-box">
        <h2>SECURITY LOGIN</h2>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error">⚠️ <%= request.getAttribute("error") %></div>
        <% } %>
        <form action="dang-nhap" method="POST">
            <div class="input-group">
                <label>Username</label>
                <input type="text" name="username" required>
            </div>
            <div class="input-group">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit" class="btn-login">ACCESS SYSTEM</button>
        </form>
    </div>
</body>
</html>