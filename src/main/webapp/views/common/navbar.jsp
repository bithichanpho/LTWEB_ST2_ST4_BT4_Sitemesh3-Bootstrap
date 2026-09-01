<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>
    * { box-sizing: border-box; }
    html, body { margin: 0; padding: 0; }

    .navbar {
        background: #fff;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 22px 40px;
        border-bottom: 1px solid #eee;
        font-family: 'Helvetica Neue', Arial, sans-serif;
    }

    .nav-left, .nav-right {
        display: flex;
        align-items: center;
        gap: 26px;
        flex: 1;
    }

    .nav-right { justify-content: flex-end; }

    .navbar a {
        text-decoration: none;
        color: #1a1a1a;
        font-size: 13px;
        letter-spacing: 0.5px;
        text-transform: uppercase;
        font-weight: 600;
        transition: color .15s;
        white-space: nowrap;
    }

    .navbar a:hover { color: #777; }

    .logo {
        font-size: 26px;
        font-weight: 800;
        letter-spacing: 4px;
        text-transform: uppercase;
        text-align: center;
        color: #1a1a1a;
    }

    .user-info {
        font-size: 13px;
        color: #1a1a1a;
        text-transform: none;
        font-weight: normal;
        white-space: nowrap;
    }

    .nav-item { position: relative; display: inline-block; }

    .nav-dropdown {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        background: #fff;
        min-width: 240px;
        box-shadow: 0 8px 20px rgba(0,0,0,.12);
        border-radius: 4px;
        overflow: hidden;
        z-index: 100;
        margin-top: 10px;
    }

    .nav-item:hover .nav-dropdown { display: block; }

    .nav-dropdown a {
        display: flex;
        justify-content: space-between;
        align-items: center;
        color: #1a1a1a;
        padding: 12px 18px;
        margin: 0;
        font-weight: normal;
        font-size: 13px;
        text-transform: none;
        letter-spacing: normal;
        border-bottom: 1px solid #f0f0f0;
    }

    .nav-dropdown a:last-child { border-bottom: none; }
    .nav-dropdown a:hover { background: #f7f7f7; color: #1a1a1a; }
    .nav-dropdown .count { color: #999; font-size: 12px; }
</style>
<nav class="navbar">
    <div class="nav-left">
        <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
        <a href="${pageContext.request.contextPath}/product">Sản phẩm</a>
        <span class="nav-item">
            <a href="${pageContext.request.contextPath}/categories">Danh mục ▾</a>
            <div class="nav-dropdown">
                <c:forEach items="${navCategories}" var="nc">
                    <a href="${pageContext.request.contextPath}/category/detail?id=${nc.categoryId}">
                        <span>${nc.categoryname}</span>
                        <span class="count">${navCategoryCounts[nc.categoryId]} sản phẩm</span>
                    </a>
                </c:forEach>
            </div>
        </span>
    </div>

    <div class="logo">Shop</div>

    <div class="nav-right">
        <c:choose>
            <c:when test="${not empty sessionScope.currentUser}">
                <span class="user-info">Xin chào, <b>${sessionScope.currentUser.fullname}</b></span>
                <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>