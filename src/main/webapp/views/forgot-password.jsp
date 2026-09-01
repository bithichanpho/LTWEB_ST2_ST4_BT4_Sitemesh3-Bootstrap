<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="UTF-8">
			<title>Quên mật khẩu</title>
			<style>
				body {
					font-family: Arial, sans-serif;
					margin: 0;
					background: #f4f4f4;
				}

				.box {
					max-width: 400px;
					margin: 60px auto;
					background: #fff;
					padding: 30px;
					border-radius: 8px;
					box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
				}

				h2 {
					text-align: center;
					color: #333;
				}

				p.desc {
					color: #666;
					text-align: center;
				}

				div.field {
					margin: 15px 0;
				}

				label {
					font-weight: bold;
					display: block;
					margin-bottom: 5px;
				}

				input[type=email] {
					width: 100%;
					padding: 8px;
					box-sizing: border-box;
					border: 1px solid #ccc;
					border-radius: 4px;
				}

				button {
					width: 100%;
					padding: 10px;
					background-color: #4CAF50;
					color: white;
					border: none;
					border-radius: 4px;
					cursor: pointer;
					font-size: 15px;
				}

				.error {
					color: red;
					margin-bottom: 10px;
				}

				.link {
					text-align: center;
					margin-top: 15px;
				}
			</style>
		</head>

		<body>
			<div class="box">
				<h2>Quên mật khẩu</h2>
				<p class="desc">Nhập email đã đăng ký, hệ thống sẽ gửi mã OTP để
					đặt lại mật khẩu.</p>

				<c:if test="${not empty error}">
					<div class="error">${error}</div>
				</c:if>

				<form action="${pageContext.request.contextPath}/forgot-password" method="post">
					<div class="field">
						<label>Email:</label> <input type="email" name="email" required>
					</div>
					<button type="submit">Gửi mã OTP</button>
				</form>

				<div class="link">
					<a href="${pageContext.request.contextPath}/login">Quay lại đăng
						nhập</a>
				</div>
			</div>
		</body>

		</html>