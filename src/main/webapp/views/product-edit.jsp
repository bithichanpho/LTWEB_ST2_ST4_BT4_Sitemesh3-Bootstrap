<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="UTF-8">
			<title>Cập nhật Product</title>
			<style>
				body {
					font-family: Arial, sans-serif;
					margin: 20px;
				}

				div {
					margin-bottom: 15px;
				}

				label {
					font-weight: bold;
				}

				input,
				select,
				textarea {
					padding: 6px;
					box-sizing: border-box;
				}

				.current-img {
					color: gray;
					font-size: 14px;
					margin-top: 5px;
				}

				.error {
					color: red;
				}
			</style>
		</head>

		<body>
			<h2>Chỉnh sửa Product</h2>

			<c:if test="${not empty error}">
				<p class="error">${error}</p>
			</c:if>

			<form action="${pageContext.request.contextPath}/admin/product/update" method="post"
				enctype="multipart/form-data">
				<input type="hidden" name="productId" value="${product.productId}">

				<div>
					<label>Tên sản phẩm:</label><br> <input type="text" name="productName"
						value="${product.productName}" style="width: 300px" required>
				</div>

				<div>
					<label>Danh mục:</label><br> <select name="categoryId" required>
						<c:forEach items="${cateList}" var="c">
							<option value="${c.categoryId}" <c:if test="${c.categoryId == product.category.categoryId}">
								selected</c:if>>${c.categoryname}</option>
						</c:forEach>
					</select>
				</div>

				<div>
					<label>Giá (VNĐ):</label><br> <input type="number" name="price" value="${product.price}" min="0"
						step="1000" style="width: 200px" required>
				</div>

				<div>
					<label>Số lượng trong kho:</label><br> <input type="number" name="quantity"
						value="${product.quantity}" min="0" style="width: 200px" required>
				</div>

				<div>
					<label>Mô tả:</label><br>
					<textarea name="description" rows="5" style="width: 500px">${product.description}</textarea>
				</div>

				<div>
					<label>Hình ảnh (để trống nếu giữ ảnh cũ):</label><br> <input type="file" name="images">
					<c:if test="${not empty product.images}">
						<div class="current-img">
							Đang sử dụng: <b>${product.images}</b>
						</div>
					</c:if>
				</div>

				<button type="submit"
					style="padding: 8px 15px; background-color: #4CAF50; color: white; border: none; cursor: pointer;">Cập
					nhật</button>
				<a href="${pageContext.request.contextPath}/admin/products"
					style="margin-left: 10px; text-decoration: none; color: red;">Hủy
					bỏ</a>
			</form>
		</body>

		</html>