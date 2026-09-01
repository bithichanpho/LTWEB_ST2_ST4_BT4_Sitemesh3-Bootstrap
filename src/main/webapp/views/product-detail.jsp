<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>${product.productName}</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 0;
	background: #f9f9f9;
}

.container {
	padding: 30px;
	max-width: 1000px;
	margin: 0 auto;
}

.detail {
	background: #fff;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
	display: flex;
	gap: 30px;
	padding: 30px;
}

.detail img {
	width: 380px;
	height: 380px;
	object-fit: cover;
	border-radius: 8px;
	background: #eee;
}

.info h1 {
	margin-top: 0;
	color: #333;
}

.price {
	font-size: 26px;
	color: #e53935;
	font-weight: bold;
	margin: 15px 0;
}

.meta {
	color: #555;
	margin-bottom: 8px;
}

.desc {
	margin-top: 20px;
	line-height: 1.6;
	color: #333;
	white-space: pre-line;
}

.back {
	display: inline-block;
	margin-bottom: 15px;
	color: #4CAF50;
	text-decoration: none;
	font-weight: bold;
}

.stock-in {
	color: green;
	font-weight: bold;
}

.stock-out {
	color: red;
	font-weight: bold;
}
</style>
</head>

<body>

	<%@ include file="/views/common/navbar.jsp" %>

	<div class="container">
		<a class="back" href="${pageContext.request.contextPath}/product">←
			Quay lại danh sách sản phẩm</a>

		<div class="detail">
			<c:choose>
				<c:when test="${not empty product.images}">
					<img
						src="${pageContext.request.contextPath}/image/${product.images}"
						alt="${product.productName}">
				</c:when>
				<c:otherwise>
					<img src="https://via.placeholder.com/380x380?text=No+Image"
						alt="No image">
				</c:otherwise>
			</c:choose>

			<div class="info">
				<h1>${product.productName}</h1>
				<div class="meta">
					Danh mục: <b>${product.category.categoryname}</b>
				</div>
				<div class="price">
					<fmt:formatNumber value="${product.price}" type="number"
						groupingUsed="true" />
					đ
				</div>
				<div class="meta">
					<c:choose>
						<c:when test="${product.quantity > 0}">
							<span class="stock-in">Còn hàng (${product.quantity})</span>
						</c:when>
						<c:otherwise>
							<span class="stock-out">Hết hàng</span>
						</c:otherwise>
					</c:choose>
				</div>
				<div class="desc">${product.description}</div>
			</div>
		</div>
	</div>
</body>

</html>