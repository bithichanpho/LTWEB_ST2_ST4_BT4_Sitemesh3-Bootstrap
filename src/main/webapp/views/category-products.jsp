<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sản phẩm thuộc ${cate.categoryname}</title>
<style>
    body { font-family: Arial, sans-serif; margin: 0; background:#f9f9f9; }
    .container { padding: 30px; }
    .back { display:inline-block; margin-bottom:15px; color:#4CAF50; text-decoration:none; font-weight:bold; }
    .grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 18px; margin-top: 20px; }
    .card { background:#fff; border-radius:8px; overflow:hidden; box-shadow:0 2px 6px rgba(0,0,0,.08); text-decoration:none; color:#333; }
    .card img { width:100%; height:200px; object-fit:cover; background:#eee; }
    .card .info { padding:12px; }
    .card .name { font-weight:bold; font-size:14px; height:36px; overflow:hidden; }
    .card .price { color:#e53935; font-weight:bold; }
    .empty { color:gray; font-style:italic; }
</style>
</head>
<body>


    <div class="container">
        <a class="back" href="${pageContext.request.contextPath}/categories">← Quay lại danh sách Category</a>
        <h2>Sản phẩm thuộc: ${cate.categoryname} (${productList.size()} sản phẩm)</h2>

        <c:if test="${empty productList}">
            <p class="empty">Category này chưa có sản phẩm nào.</p>
        </c:if>

        <div class="grid">
            <c:forEach items="${productList}" var="p">
                <a class="card" href="${pageContext.request.contextPath}/product/detail?id=${p.productId}">
                    <c:choose>
                        <c:when test="${not empty p.images}">
                            <img src="${pageContext.request.contextPath}/image/${p.images}" alt="${p.productName}">
                        </c:when>
                        <c:otherwise>
                            <img src="https://via.placeholder.com/300x200?text=No+Image" alt="No image">
                        </c:otherwise>
                    </c:choose>
                    <div class="info">
                        <div class="name">${p.productName}</div>
                        <div class="price">
                            <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" /> đ
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>
    </div>
</body>
</html>