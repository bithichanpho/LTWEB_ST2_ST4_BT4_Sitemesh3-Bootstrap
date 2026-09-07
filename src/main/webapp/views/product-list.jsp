<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Tất cả sản phẩm</title>
	<style>
		body {
			font-family: Arial, sans-serif;
			margin: 0;
			background: #f9f9f9;
		}

		.container {
			padding: 30px;
		}

		.header-row {
			display: flex;
			justify-content: space-between;
			align-items: center;
		}

		h2 {
			color: #333;
		}

		.btn-add {
			display: inline-block;
			padding: 10px 15px;
			background-color: #4CAF50;
			color: white;
			text-decoration: none;
			border-radius: 4px;
			font-weight: bold;
		}

		.grid {
			display: grid;
			grid-template-columns: repeat(3, 1fr);
			gap: 18px;
			margin-top: 20px;
		}

		.card {
			background: #fff;
			border-radius: 8px;
			overflow: hidden;
			box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
			text-decoration: none;
			color: #333;
			transition: transform .15s;
		}

		.card:hover {
			transform: translateY(-4px);
			box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
		}

		.card img {
			width: 100%;
			height: 220px;
			object-fit: cover;
			display: block;
			background: #eee;
		}

		.card .info {
			padding: 12px;
		}

		.card .name {
			font-weight: bold;
			font-size: 15px;
			margin-bottom: 6px;
			height: 40px;
			overflow: hidden;
		}

		.card .price {
			color: #e53935;
			font-weight: bold;
		}

		.empty {
			color: gray;
			font-style: italic;
		}

		.pagination {
			display: flex;
			justify-content: center;
			gap: 8px;
			margin-top: 30px;
		}

		.pagination a,
		.pagination span {
			display: inline-block;
			padding: 8px 14px;
			border-radius: 4px;
			text-decoration: none;
			color: #333;
			background: #fff;
			border: 1px solid #ddd;
		}

		.pagination a:hover {
			background: #4CAF50;
			color: #fff;
			border-color: #4CAF50;
		}

		.pagination .active {
			background: #4CAF50;
			color: #fff;
			border-color: #4CAF50;
			font-weight: bold;
		}

		.pagination .disabled {
			color: #bbb;
			pointer-events: none;
		}
	</style>
</head>

<body>


	<div class="container">
		<div class="header-row">
			<h2>Tất cả sản phẩm</h2>

			<%-- Chỉ admin mới thấy nút thêm sản phẩm --%>
			<c:if test="${sessionScope.currentUser.role == 'admin'}">
				<a href="${pageContext.request.contextPath}/admin/product/add" class="btn-add">+ Thêm sản phẩm</a>
			</c:if>
		</div>

		<c:if test="${empty productList}">
			<p class="empty">Chưa có sản phẩm nào.</p>
		</c:if>

		<div class="grid">
			<c:forEach items="${productList}" var="p">
				<a class="card" href="${pageContext.request.contextPath}/product/detail?id=${p.productId}">
					<c:choose>
						<c:when test="${not empty p.images}">
							<img src="${pageContext.request.contextPath}/image/${p.images}" alt="${p.productName}">
						</c:when>
						<c:otherwise>
							<img src="https://via.placeholder.com/300x220?text=No+Image" alt="No image">
						</c:otherwise>
					</c:choose>
					<div class="info">
						<div class="name">${p.productName}</div>
						<div class="price">
							<fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" />
							đ
						</div>
					</div>
				</a>
			</c:forEach>
		</div>

		<c:if test="${totalPages > 1}">
			<div class="pagination">
				<c:choose>
					<c:when test="${currentPage <= 1}">
						<span class="disabled">&laquo; Trước</span>
					</c:when>
					<c:otherwise>
						<a href="${pageContext.request.contextPath}/product?page=${currentPage - 1}">&laquo; Trước</a>
					</c:otherwise>
				</c:choose>

				<c:forEach begin="1" end="${totalPages}" var="i">
					<c:choose>
						<c:when test="${i == currentPage}">
							<span class="active">${i}</span>
						</c:when>
						<c:otherwise>
							<a href="${pageContext.request.contextPath}/product?page=${i}">${i}</a>
						</c:otherwise>
					</c:choose>
				</c:forEach>

				<c:choose>
					<c:when test="${currentPage >= totalPages}">
						<span class="disabled">Sau &raquo;</span>
					</c:when>
					<c:otherwise>
						<a href="${pageContext.request.contextPath}/product?page=${currentPage + 1}">Sau &raquo;</a>
					</c:otherwise>
				</c:choose>
			</div>
		</c:if>
	</div>
</body>

</html>