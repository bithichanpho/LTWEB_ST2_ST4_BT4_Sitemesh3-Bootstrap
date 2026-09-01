<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="UTF-8">
			<title>Đặt lại mật khẩu</title>
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

				input {
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
			</style>
		</head>

		<body>
			<div class="box">
				<h2>Đặt lại mật khẩu</h2>
				<p class="desc">Mã OTP đã được gửi tới email: <b>${email}</b></p>

				<c:if test="${not empty error}">
					<div class="error">${error}</div>
				</c:if>

				<form action="${pageContext.request.contextPath}/reset-password" method="post">
					<div class="field">
						<label>Mã OTP:</label>
						<input type="text" name="otp" maxlength="6" required>
					</div>
					<div class="field">
						<label>Mật khẩu mới:</label>
						<input type="password" name="newPassword" required minlength="6">
					</div>
					<div class="field">
						<label>Nhập lại mật khẩu mới:</label>
						<input type="password" name="confirmPassword" required minlength="6">
					</div>
					<button type="submit">Đặt lại mật khẩu</button>
				</form>
			</div>
		</body>

		</html>