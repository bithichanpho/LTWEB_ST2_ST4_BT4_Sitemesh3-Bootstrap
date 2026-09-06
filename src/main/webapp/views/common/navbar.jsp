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
        min-width: 260px;
        padding-top: 10px; /* vùng đệm vô hình, vẫn tính là hover */
        z-index: 100;
    }

    .nav-item:hover .nav-dropdown,
    .nav-dropdown:hover { display: block; }

    .nav-dropdown-inner {
        background: #fff;
        border-radius: 4px;
        box-shadow: 0 8px 20px rgba(0,0,0,.12);

    }

    .nav-dropdown-inner > *:first-child { border-top-left-radius: 4px; border-top-right-radius: 4px; }
    .nav-dropdown-inner > *:last-child { border-bottom-left-radius: 4px; border-bottom-right-radius: 4px; }

    .nav-dropdown a,
    .nav-dropdown .nav-row {
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

    .nav-dropdown a:last-child,
    .nav-dropdown .nav-row:last-child { border-bottom: none; }
    .nav-dropdown a:hover { background: #f7f7f7; color: #1a1a1a; }
    .nav-dropdown .count { color: #999; font-size: 12px; }

    /* --- Menu con cấp 2 (flyout sang phải khi hover "Danh mục hàng hóa") --- */
    .nav-subitem { position: relative; }
    .nav-subitem .nav-row { cursor: default; }
    .nav-subitem:hover .nav-row { background: #f7f7f7; }
    .nav-subitem .arrow { color: #bbb; font-size: 11px; margin-left: 8px; }

    .nav-flyout {
        display: none;
        position: absolute;
        left: 100%;
        top: 0;
        min-width: 240px;
        padding-left: 10px; /* vùng đệm vô hình theo chiều ngang, giữ hover liên tục */
        z-index: 110;
    }

    .nav-subitem:hover .nav-flyout,
    .nav-flyout:hover { display: block; }

    .nav-flyout-inner {
        background: #fff;
        border-radius: 4px;
        box-shadow: 0 8px 20px rgba(0,0,0,.12);
        overflow: hidden;
    }

    .nav-flyout a {
        border-bottom: 1px solid #f0f0f0;
    }
    .nav-flyout a:last-child { border-bottom: none; }
</style>
<nav class="navbar">
    <div class="nav-left">
        <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
        <a href="${pageContext.request.contextPath}/product">Sản phẩm</a>
        <span class="nav-item">
            <a href="${pageContext.request.contextPath}/categories">Danh mục ▾</a>
            <div class="nav-dropdown">
                <div class="nav-dropdown-inner">
                    <div class="nav-subitem">
                        <span class="nav-row">
                            <span>Danh mục hàng hóa</span>
                            <span class="arrow">▸</span>
                        </span>
                        <div class="nav-flyout">
                            <div class="nav-flyout-inner">
                                <c:forEach items="${navCategories}" var="nc">
                                    <a href="${pageContext.request.contextPath}/category/detail?id=${nc.categoryId}">
                                        <span>${nc.categoryname}</span>
                                        <span class="count">${navCategoryCounts[nc.categoryId]} sản phẩm</span>
                                    </a>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/product/stock-report">
                        <span>Thống kê tổng số lượng</span>
                        <span class="count">${navTotalProducts} sản phẩm</span>
                    </a>
                </div>
            </div>
        </span>
        <c:if test="${sessionScope.currentUser.role == 'admin'}">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        </c:if>
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