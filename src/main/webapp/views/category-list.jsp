<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý Category</title>
<style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    table { width: 100%; border-collapse: collapse; margin-top: 15px; }
    table, th, td { border: 1px solid #ddd; }
    th, td { padding: 12px; text-align: left; vertical-align: middle; }
    th { background-color: #f4f4f4; }
    .btn-add { display: inline-block; margin-bottom: 15px; padding: 10px 15px; background-color: #4CAF50; color: white; text-decoration: none; border-radius: 4px; font-weight: bold; }
    img { border-radius: 4px; object-fit: cover; }
</style>
</head>
<body>
    <h2>Danh sách Category</h2>
    
    <a href="${pageContext.request.contextPath}/category/add" class="btn-add">+ Thêm Category mới</a>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên Category</th>
                <th>Hình ảnh</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${cateList}" var="cate">
                <tr>
                    <td>${cate.categoryId}</td>
                    <td>${cate.categoryname}</td>
                    <td>
                        <!-- Hiển thị ảnh thông qua ImageController đã cấu hình -->
                        <c:if test="${not empty cate.images}">
                            <img src="${pageContext.request.contextPath}/image/${cate.images}" alt="Image" width="80" height="80">
                        </c:if>
                        <c:if test="${empty cate.images}">
                            <span style="color: gray; font-style: italic;">Chưa có ảnh</span>
                        </c:if>
                    </td>
                    <td>
                        <!-- Hiển thị trạng thái theo yêu cầu: In stock (kèm số lượng) hoặc Out of stock -->
                        <c:choose>
                            <%-- Giả sử status > 0 là còn hàng, hiển thị In stock kèm số lượng status --%>
                            <c:when test="${cate.status > 0}">
                                <span style="color: green; font-weight: bold;">In stock (${cate.status})</span>
                            </c:when>
                            <%-- Ngược lại status = 0 là hết hàng --%>
                            <c:otherwise>
                                <span style="color: red; font-weight: bold;">Out of stock</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/category/edit?id=${cate.categoryId}">Sửa</a> | 
                        <a href="${pageContext.request.contextPath}/category/delete?id=${cate.categoryId}" onclick="return confirm('Bạn có chắc chắn muốn xóa?');">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>