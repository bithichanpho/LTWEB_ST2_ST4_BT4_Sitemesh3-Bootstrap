<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Quản lý Product</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 20px;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 15px;
}

table, th, td {
	border: 1px solid #ddd;
}

th, td {
	padding: 12px;
	text-align: left;
	vertical-align: middle;
}

th {
	background-color: #f4f4f4;
}

/* Style cho nút Thêm mới */
.btn-add {
	display: inline-block;
	margin-bottom: 15px;
	padding: 10px 15px;
	background-color: #4CAF50;
	color: white;
	text-decoration: none;
	border-radius: 4px;
	font-weight: bold;
}

/* Style cho nút Quay lại */
.btn-back {
	display: inline-block;
	margin-bottom: 15px;
	margin-right: 10px;
	padding: 10px 15px;
	background-color: #6c757d; /* Màu xám */
	color: white;
	text-decoration: none;
	border-radius: 4px;
	font-weight: bold;
}

.btn-back:hover {
	background-color: #5a6268;
}

img {
	border-radius: 4px;
	object-fit: cover;
}
</style>
</head>

<body>
    <!-- NẾU BẠN CÓ NAVBAR CHUNG, BỎ COMMENT DÒNG DƯỚI ĐỂ INCLUDE VÀO (sửa lại đúng đường dẫn) -->
    <jsp:include page="/views/common/navbar.jsp"></jsp:include>

	<h2>Quản lý Product</h2>

    <!-- Các nút thao tác -->
    <div>
        <a href="${pageContext.request.contextPath}/categories" class="btn-back">← Quay lại danh sách Category</a>
        <a href="${pageContext.request.contextPath}/admin/product/add" class="btn-add">+ Thêm Product mới</a>
    </div>

	<table>
		<thead>
			<tr>
				<th>ID</th>
				<th>Tên sản phẩm</th>
				<th>Hình ảnh</th>
				<th>Danh mục</th>
				<th>Giá</th>
				<th>Số lượng</th>
				<th>Hành động</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${productList}" var="p">
				<tr>
					<td>${p.productId}</td>
					<td>${p.productName}</td>
					<td><c:if test="${not empty p.images}">
							<img src="${pageContext.request.contextPath}/image/${p.images}"
								alt="Image" width="80" height="80">
						</c:if> <c:if test="${empty p.images}">
							<span style="color: gray; font-style: italic;">Chưa có ảnh</span>
						</c:if></td>
					<td>${p.category.categoryname}</td>
					<td><fmt:formatNumber value="${p.price}" type="number"
							groupingUsed="true" /> đ</td>
					<td>${p.quantity}</td>
					<td><a
						href="${pageContext.request.contextPath}/admin/product/edit?id=${p.productId}">Sửa</a>
						| <a
						href="${pageContext.request.contextPath}/admin/product/delete?id=${p.productId}"
						onclick="return confirm('Bạn có chắc chắn muốn xóa?');">Xóa</a></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>

</html>