<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="UTF-8">
			<title>Thêm Product</title>
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

				.error {
					color: red;
				}
			</style>
		</head>

		<body>
			<%@ include file="/views/common/navbar.jsp" %>
		
			<h2>Thêm Product mới</h2>

			<c:if test="${not empty error}">
				<p class="error">${error}</p>
			</c:if>

			<form action="${pageContext.request.contextPath}/admin/product/insert" method="post"
				enctype="multipart/form-data">
				<div>
					<label>Tên sản phẩm:</label><br> <input type="text" name="productName" style="width: 300px"
						required>
				</div>

				<div>
					<label>Danh mục:</label><br> <select name="categoryId" required>
						<c:forEach items="${cateList}" var="c">
							<option value="${c.categoryId}">${c.categoryname}</option>
						</c:forEach>
					</select>
				</div>

				<div>
					<label>Giá (VNĐ):</label><br> <input type="number" name="price" min="0" step="1000"
						style="width: 200px" required>
				</div>

				<div>
					<label>Số lượng trong kho:</label><br> <input type="number" name="quantity" min="0" value="0"
						style="width: 200px" required>
				</div>

				<div>
					<label>Mô tả:</label><br>
					<textarea name="description" rows="5" style="width: 500px"></textarea>
				</div>

				<div>
					<label>Hình ảnh:</label><br> <input type="file" name="images" required>
				</div>

				<button type="submit"
					style="padding: 8px 15px; background-color: #4CAF50; color: white; border: none; cursor: pointer;">Lưu
					lại</button>
				<a href="${pageContext.request.contextPath}/admin/products"
					style="margin-left: 10px; text-decoration: none; color: red;">Hủy
					bỏ</a>
			</form>
		</body>

		</html>