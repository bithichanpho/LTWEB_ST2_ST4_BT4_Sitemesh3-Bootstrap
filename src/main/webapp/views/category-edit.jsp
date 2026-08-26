<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cập nhật Category</title>
<style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    div { margin-bottom: 15px; }
    label { font-weight: bold; }
    .current-img { color: gray; font-size: 14px; margin-top: 5px; }
    .note { color: gray; font-size: 13px; font-style: italic; }
</style>
</head>
<body>
    <h2>Chỉnh sửa Category</h2>
    
    <c:set var="currentFolder" value="${fn:substringBefore(cate.images, '/')}" />

    <form action="${pageContext.request.contextPath}/category/update" method="post" enctype="multipart/form-data">
        <input type="hidden" name="categoryId" value="${cate.categoryId}">
        
        <div>
            <label>Tên Category:</label><br>
            <input type="text" name="categoryname" value="${cate.categoryname}" required>
        </div>
        
        <div>
            <label>Phân loại (Thư mục lưu ảnh):</label><br>
            <select name="folderName">
                <option value="female" <c:if test="${currentFolder == 'female'}">selected</c:if>>Female</option>
                <option value="male" <c:if test="${currentFolder == 'male'}">selected</c:if>>Male</option>
                <option value="accesories" <c:if test="${currentFolder == 'accesories'}">selected</c:if>>Accessories</option>
            </select>
        </div>
        
        <div>
            <label>Hình ảnh tải lên (Để trống nếu giữ nguyên ảnh cũ):</label><br>
            <input type="file" name="images">
            <c:if test="${not empty cate.images}">
                <div class="current-img">Đang sử dụng: <b>${cate.images}</b></div>
            </c:if>
        </div>
        
        <div>
            <label>Số lượng trong kho (Trạng thái):</label><br>
            <!-- Tự động điền số lượng cũ từ database (${cate.status}) -->
            <input type="number" name="status" value="${cate.status}" min="0" style="width: 100px; padding: 5px;" required>
            <span class="note">(Nhập số lượng > 0 là In stock, nhập 0 là Out of stock)</span>
        </div>
        
        <button type="submit" style="padding: 8px 15px; background-color: #4CAF50; color: white; border: none; cursor: pointer;">Cập nhật</button>
        <a href="${pageContext.request.contextPath}/categories" style="margin-left: 10px; text-decoration: none; color: red;">Hủy bỏ</a>
    </form>
</body>
</html>