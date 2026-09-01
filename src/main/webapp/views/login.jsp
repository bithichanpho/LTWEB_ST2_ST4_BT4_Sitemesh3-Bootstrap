<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="UTF-8">
			<title>Đăng nhập</title>
			<style>
				body {
					font-family: Arial, sans-serif;
					margin: 0;
					background: #f4f4f4;
				}

				.box {
					max-width: 380px;
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

				div.field {
					margin-bottom: 15px;
				}

				label {
					font-weight: bold;
					display: block;
					margin-bottom: 5px;
				}

				input[type=email],
				input[type=password] {
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

				.message {
					color: green;
					margin-bottom: 10px;
				}

				.links {
					display: flex;
					justify-content: space-between;
					margin-top: 15px;
					font-size: 14px;
				}
			</style>
		</head>

		<body>
			<div class="box">
				<h2>Đăng nhập</h2>

				<c:if test="${not empty error}">
					<div class="error">${error}</div>
				</c:if>
				<c:if test="${not empty message}">
					<div class="message">${message}</div>
				</c:if>

				<form action="${pageContext.request.contextPath}/login" method="post">
					<div class="field">
						<label>Email:</label> <input type="email" name="email" required>
					</div>
					<div class="field">
						<label>Mật khẩu:</label> <input type="password" name="password" required>
					</div>
					<button type="submit">Đăng nhập</button>
				</form>

				<div class="links">
					<a href="${pageContext.request.contextPath}/register">Đăng ký tài
						khoản</a> <a href="${pageContext.request.contextPath}/forgot-password">Quên
						mật khẩu?</a>
				</div>
			</div>
		</body>

		</html>