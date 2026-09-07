<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="UTF-8">
			<title>Đăng ký tài khoản</title>
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

				div.field {
					margin-bottom: 15px;
				}

				label {
					font-weight: bold;
					display: block;
					margin-bottom: 5px;
				}

				input[type=text],
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

				.field-error {
					color: red;
					font-size: 12px;
					margin-top: 4px;
				}

				input.invalid {
					border-color: red;
				}

				.link {
					text-align: center;
					margin-top: 15px;
				}
			</style>
		</head>

		<body>
			<div class="box">
				<h2>Đăng ký tài khoản</h2>

				<c:if test="${not empty error}">
					<div class="error">${error}</div>
				</c:if>

				<form action="${pageContext.request.contextPath}/register" method="post">
					<div class="field">
						<label>Họ tên:</label>
						<input type="text" name="fullname" value="${fullname}"
							class="${not empty fieldErrors.fullname ? 'invalid' : ''}" required>
						<c:if test="${not empty fieldErrors.fullname}">
							<div class="field-error">${fieldErrors.fullname}</div>
						</c:if>
					</div>
					<div class="field">
						<label>Email:</label>
						<input type="email" name="email" value="${email}"
							class="${not empty fieldErrors.email ? 'invalid' : ''}" required>
						<c:if test="${not empty fieldErrors.email}">
							<div class="field-error">${fieldErrors.email}</div>
						</c:if>
					</div>
					<div class="field">
						<label>Mật khẩu:</label>
						<input type="password" name="password"
							class="${not empty fieldErrors.password ? 'invalid' : ''}" required minlength="6">
						<c:if test="${not empty fieldErrors.password}">
							<div class="field-error">${fieldErrors.password}</div>
						</c:if>
					</div>
					<div class="field">
						<label>Nhập lại mật khẩu:</label>
						<input type="password" name="confirmPassword"
							class="${not empty fieldErrors.confirmPassword ? 'invalid' : ''}" required minlength="6">
						<c:if test="${not empty fieldErrors.confirmPassword}">
							<div class="field-error">${fieldErrors.confirmPassword}</div>
						</c:if>
					</div>
					<button type="submit">Đăng ký</button>
				</form>

				<div class="link">
					Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng
						nhập</a>
				</div>
			</div>
		</body>

		</html>