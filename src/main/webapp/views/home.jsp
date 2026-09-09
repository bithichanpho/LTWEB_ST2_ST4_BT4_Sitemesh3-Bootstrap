<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trang chủ</title>
<style>
* {
	box-sizing: border-box;
}

body {
	font-family: 'Helvetica Neue', Arial, sans-serif;
	margin: 0;
	color: #1a1a1a;
	background: #fff;
}

.hero {
	margin-top: calc(-1 * var(--nav-height, 72px));
}
@media (min-width: 992px) {
	#mainNav:not(.navbar-shrink) { background-color: transparent !important; }
}

/* Hero */
.hero {
	position: relative;
	width: 100%;
	height: 480px;
	overflow: hidden;
	background: linear-gradient(135deg, #2f3e46, #52796f);
}

.hero img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	opacity: 0.9;
}

.hero-overlay {
	position: absolute;
	inset: 0;
	background: rgba(0, 0, 0, 0.25);
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	text-align: center;
	color: #fff;
}

.hero-overlay h1 {
	font-size: 42px;
	letter-spacing: 3px;
	margin-bottom: 16px;
	text-transform: uppercase;
}

.hero-overlay a.btn {
	margin-top: 10px;
	padding: 12px 32px;
	border: 1.5px solid #fff;
	color: #fff;
	text-decoration: none;
	text-transform: uppercase;
	letter-spacing: 1px;
	font-size: 13px;
	font-weight: 600;
	transition: all .2s;
}

.hero-overlay a.btn:hover {
	background: #fff;
	color: #1a1a1a;
}

/* Danh sách sản phẩm mới nhất */
.container {
	padding: 50px 40px;
}

.section-title {
	text-align: center;
	font-size: 22px;
	letter-spacing: 2px;
	text-transform: uppercase;
	margin-bottom: 35px;
}

.grid {
	display: grid;
	grid-template-columns: repeat(5, 1fr);
	gap: 22px;
}

.card {
	text-decoration: none;
	color: #1a1a1a;
}

.card img {
	width: 100%;
	height: 220px;
	object-fit: cover;
	background: #f2f2f2;
}

.card .info {
	padding-top: 10px;
	text-align: center;
}

.card .name {
	font-size: 13px;
	font-weight: 600;
	height: 34px;
	overflow: hidden;
}

.card .price {
	font-size: 13px;
	color: #555;
	margin-top: 4px;
}

.empty {
	text-align: center;
	color: gray;
	font-style: italic;
}

.view-all {
	display: block;
	text-align: center;
	margin-top: 35px;
	font-weight: 600;
	letter-spacing: 1px;
	text-transform: uppercase;
	color: #1a1a1a;
	text-decoration: none;
	font-size: 13px;
}

.view-all:hover {
	color: #777;
}
</style>
</head>
<body>



	<div class="hero">
		<c:if
			test="${not empty latestProducts and not empty latestProducts[0].images}">
			<img
				src="${pageContext.request.contextPath}/image/${latestProducts[0].images}"
				alt="Hero">
		</c:if>
		<div class="hero-overlay">
			<h1>Bộ sưu tập mới</h1>
			<a class="btn" href="${pageContext.request.contextPath}/product">Khám
				phá ngay</a>
		</div>
	</div>

	<div class="container">
		<h2 class="section-title">Sản phẩm mới nhất</h2>

		<c:if test="${empty latestProducts}">
			<p class="empty">Chưa có sản phẩm nào.</p>
		</c:if>

		<div class="grid">
			<c:forEach items="${latestProducts}" var="p">
				<a class="card"
					href="${pageContext.request.contextPath}/product/detail?id=${p.productId}">
					<c:choose>
						<c:when test="${not empty p.images}">
							<img src="${pageContext.request.contextPath}/image/${p.images}"
								alt="${p.productName}">
						</c:when>
						<c:otherwise>
							<img src="https://via.placeholder.com/300x220?text=No+Image"
								alt="No image">
						</c:otherwise>
					</c:choose>
					<div class="info">
						<div class="name">${p.productName}</div>
						<div class="price">
							<fmt:formatNumber value="${p.price}" type="number"
								groupingUsed="true" />
							đ
						</div>
					</div>
				</a>
			</c:forEach>
		</div>

		<a class="view-all" href="${pageContext.request.contextPath}/product">Xem
			tất cả sản phẩm →</a>
	</div>

</body>
</html>