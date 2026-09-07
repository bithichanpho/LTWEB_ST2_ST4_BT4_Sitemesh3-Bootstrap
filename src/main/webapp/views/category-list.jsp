<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý Category</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 0;
	background: #f9f9f9;
}

.container {
	padding: 30px;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 15px;
	background: #fff;
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

img {
	border-radius: 4px;
	object-fit: cover;
}

.qty {
	font-weight: bold;
	color: #2196F3;
}

.flash-error {
	color: red;
	margin-bottom: 10px;
}

.cate-link {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	color: #1a1a1a;
	text-decoration: none;
	font-weight: 600;
}

.cate-link svg {
	flex-shrink: 0;
}

.cate-link:hover {
	color: #2196F3;
	text-decoration: underline;
}

.header-count {
	color: #777;
	font-weight: normal;
	font-size: 16px;
	margin-left: 6px;
}

.th-total {
	display: block;
	font-size: 11px;
	font-weight: normal;
	color: #777;
	margin-top: 2px;
}

.stock-breakdown {
	display: flex;
	gap: 12px;
	margin-top: 4px;
	font-size: 12px;
}

.in-stock {
	color: #2e7d32;
}

.out-stock {
	color: #c62828;
}

.stock-dot {
	display: inline-block;
	width: 8px;
	height: 8px;
	border-radius: 50%;
	margin-right: 4px;
}

.dot-in {
	background: #2e7d32;
}

.dot-out {
	background: #c62828;
}
</style>
</head>
<body>


	<div class="container">
		<h2>
			Danh sách Category <span class="header-count">(${fn:length(cateList)})</span>
		</h2>

		<c:if test="${not empty sessionScope.flashError}">
			<div class="flash-error">${sessionScope.flashError}</div>
			<c:remove var="flashError" scope="session" />
		</c:if>

		<c:if test="${sessionScope.currentUser.role == 'admin'}">
			<a href="${pageContext.request.contextPath}/category/add"
				class="btn-add">+ Thêm Category mới</a>
		</c:if>

		<table>
			<thead>
				<tr>
					<th>ID</th>
					<th>Tên Category</th>
					<th>Icon</th>
					<th>Số lượng sản phẩm<span class="th-total">Tổng:
							${totalProducts} sản phẩm</span></th>
					<c:if test="${sessionScope.currentUser.role == 'admin'}">
						<th>Hành động</th>
					</c:if>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${cateList}" var="cate">
					<tr>
						<td>${cate.categoryId}</td>
						<td><a class="cate-link"
							href="${pageContext.request.contextPath}/category/detail?id=${cate.categoryId}"
							title="Xem sản phẩm thuộc danh mục ${cate.categoryname}"> <svg
									width="18" height="18" viewBox="0 0 24 24" fill="none"
									stroke="currentColor" stroke-width="2" stroke-linecap="round"
									stroke-linejoin="round">
                                    <path
										d="M20.59 13.41 11 3.83A2 2 0 0 0 9.59 3.24L3 3a1 1 0 0 0-1 1l.24 6.59a2 2 0 0 0 .59 1.41l9.59 9.59a2 2 0 0 0 2.83 0l6.34-6.34a2 2 0 0 0 0-2.83Z" />
                                    <circle cx="7.5" cy="7.5" r="1.5"
										fill="currentColor" stroke="none" />
                                </svg> <span>${cate.categoryname}</span>
						</a></td>
						<td><c:if test="${not empty cate.images}">
								<img
									src="${pageContext.request.contextPath}/image/${cate.images}"
									alt="Icon" width="60" height="60">
							</c:if> <c:if test="${empty cate.images}">
								<span style="color: gray; font-style: italic;">Chưa có
									ảnh</span>
							</c:if></td>
						<td><span class="qty">${countMap[cate.categoryId]}</span> sản
							phẩm
							<div class="stock-breakdown">
								<span class="in-stock"><span class="stock-dot dot-in"></span>${inStockMap[cate.categoryId]}
									còn hàng</span> <span class="out-stock"><span
									class="stock-dot dot-out"></span>${outStockMap[cate.categoryId]}
									hết hàng</span>
							</div></td>
						<c:if test="${sessionScope.currentUser.role == 'admin'}">
							<td><a
								href="${pageContext.request.contextPath}/category/detail?id=${cate.categoryId}">Chi
									tiết</a> | <a
								href="${pageContext.request.contextPath}/category/edit?id=${cate.categoryId}">Sửa</a>
								| <a
								href="${pageContext.request.contextPath}/category/delete?id=${cate.categoryId}"
								onclick="return confirm('Bạn có chắc chắn muốn xóa?');">Xóa</a>
							</td>
						</c:if>
					</tr>
				</c:forEach>
			</tbody>
		</table>

	</div>
</body>
</html>