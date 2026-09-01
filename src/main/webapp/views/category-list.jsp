<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý Category</title>
<style>
    body { font-family: Arial, sans-serif; margin: 0; background:#f9f9f9; }
    .container { padding: 30px; }
    table { width: 100%; border-collapse: collapse; margin-top: 15px; background:#fff; }
    table, th, td { border: 1px solid #ddd; }
    th, td { padding: 12px; text-align: left; vertical-align: middle; }
    th { background-color: #f4f4f4; }
    .btn-add { display: inline-block; margin-bottom: 15px; padding: 10px 15px; background-color: #4CAF50; color: white; text-decoration: none; border-radius: 4px; font-weight: bold; }
    img { border-radius: 4px; object-fit: cover; }
    .qty { font-weight:bold; color:#2196F3; }
    .flash-error { color:red; margin-bottom:10px; }
</style>
</head>
<body>

<%@ include file="/views/common/navbar.jsp" %>

    <div class="container">
        <h2>Danh sách Category</h2>

        <c:if test="${not empty sessionScope.flashError}">
            <div class="flash-error">${sessionScope.flashError}</div>
            <c:remove var="flashError" scope="session"/>
        </c:if>

        <c:if test="${sessionScope.currentUser.role == 'admin'}">
            <a href="${pageContext.request.contextPath}/category/add" class="btn-add">+ Thêm Category mới</a>
        </c:if>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên Category</th>
                    <th>Icon</th>
                    <th>Số lượng sản phẩm</th>
                    <c:if test="${sessionScope.currentUser.role == 'admin'}">
                        <th>Hành động</th>
                    </c:if>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${cateList}" var="cate">
                    <tr>
                        <td>${cate.categoryId}</td>
                        <td>${cate.categoryname}</td>
                        <td>
                            <c:if test="${not empty cate.images}">
                                <img src="${pageContext.request.contextPath}/image/${cate.images}" alt="Icon" width="60" height="60">
                            </c:if>
                            <c:if test="${empty cate.images}">
                                <span style="color: gray; font-style: italic;">Chưa có ảnh</span>
                            </c:if>
                        </td>
                        <td><span class="qty">${countMap[cate.categoryId]}</span> sản phẩm</td>
                        <c:if test="${sessionScope.currentUser.role == 'admin'}">
                            <td>
                                <a href="${pageContext.request.contextPath}/category/detail?id=${cate.categoryId}">Chi tiết</a> |
                                <a href="${pageContext.request.contextPath}/category/edit?id=${cate.categoryId}">Sửa</a> |
                                <a href="${pageContext.request.contextPath}/category/delete?id=${cate.categoryId}" onclick="return confirm('Bạn có chắc chắn muốn xóa?');">Xóa</a>
                            </td>
                        </c:if>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <c:if test="${sessionScope.currentUser.role != 'admin'}">
            <p style="margin-top:20px; color:gray; font-style:italic;">
                Nhấp vào tên danh mục trên thanh điều hướng để xem sản phẩm.
            </p>
        </c:if>
    </div>
</body>
</html>