<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="UTF-8">
			<title>Xác thực OTP</title>
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
					text-align: center;
				}

				h2 {
					color: #333;
				}

				p.desc {
					color: #666;
				}

				input[name=otp] {
					width: 100%;
					padding: 10px;
					font-size: 20px;
					letter-spacing: 6px;
					text-align: center;
					box-sizing: border-box;
					border: 1px solid #ccc;
					border-radius: 4px;
					margin: 15px 0;
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

				form.resend {
					margin-top: 15px;
				}

				.resend button {
					background: none;
					border: none;
					color: #2196F3;
					cursor: pointer;
					text-decoration: underline;
					width: auto;
					padding: 0;
				}
			</style>
		</head>

		<body>
			<div class="box">
				<h2>Xác thực OTP</h2>
				<p class="desc">
					Mã OTP đã được gửi tới email: <b>${email}</b>
				</p>

				<c:if test="${not empty error}">
					<div class="error">${error}</div>
				</c:if>
				<c:if test="${not empty message}">
					<div class="message">${message}</div>
				</c:if>

				<form action="${pageContext.request.contextPath}/verify-otp" method="post">
					<input type="text" name="otp" maxlength="6" pattern="\d{6}" placeholder="------" required autofocus>
					<button type="submit">Xác nhận</button>
				</form>

				<form class="resend" action="${pageContext.request.contextPath}/resend-otp" method="post">
					<button type="submit">Gửi lại mã OTP</button>
				</form>
			</div>
		</body>

		</html>