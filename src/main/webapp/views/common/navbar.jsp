<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="uri" value="${pageContext.request.servletPath}" />

<style>
    #mainNav .dropdown-menu {
        border: none;
        box-shadow: 0 8px 20px rgba(0, 0, 0, .15);
    }
    #mainNav .dropdown-item:hover,
    #mainNav .dropdown-item:focus {
        background-color: #fff8e1;
        color: #212529;
    }
    #mainNav .badge-count {
        font-weight: 400;
        font-size: 11px;
    }
    #mainNav .navbar-avatar {
        width: 26px;
        height: 26px;
        object-fit: cover;
    }
</style>

<nav class="navbar navbar-expand-lg navbar-dark fixed-top" id="mainNav">

    <div class="container-fluid px-3 px-lg-4">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">SHOP</a>

        <button class="navbar-toggler navbar-toggler-right" type="button" data-bs-toggle="collapse"
            data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false"
            aria-label="Toggle navigation">
            Menu
            <i class="fas fa-bars ms-1"></i>
        </button>

        <div class="collapse navbar-collapse" id="navbarResponsive">
            <ul class="navbar-nav text-uppercase ms-auto py-4 py-lg-0 align-items-lg-center">

                <li class="nav-item">
                    <a class="nav-link ${uri == '/home' ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/home">Trang chủ</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link ${fn:startsWith(uri, '/product') ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/product">Sản phẩm</a>
                </li>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle ${fn:startsWith(uri, '/categor') ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/categories" id="navCategoryDropdown" role="button"
                        data-bs-toggle="dropdown" aria-expanded="false">
                        Danh mục
                    </a>
                    <ul class="dropdown-menu dropdown-menu-lg-end" aria-labelledby="navCategoryDropdown">
                        <c:forEach items="${navCategories}" var="nc">
                            <li>
                                <a class="dropdown-item d-flex justify-content-between align-items-center gap-3"
                                    href="${pageContext.request.contextPath}/category/detail?id=${nc.categoryId}">
                                    <span>${nc.categoryname}</span>
                                    <span class="badge bg-secondary badge-count">${navCategoryCounts[nc.categoryId]} sản phẩm</span>
                                </a>
                            </li>
                        </c:forEach>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item d-flex justify-content-between align-items-center gap-3"
                                href="${pageContext.request.contextPath}/product/stock-report">
                                <span>Thống kê tổng số lượng</span>
                                <span class="badge bg-secondary badge-count">${navTotalProducts} sản phẩm</span>
                            </a>
                        </li>

                        <c:if test="${sessionScope.currentUser.role == 'admin'}">
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <a class="dropdown-item ${uri == '/admin/products' ? 'active' : ''}"
                                    href="${pageContext.request.contextPath}/admin/products">
                                    Quản lý sản phẩm (Admin)
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </li>

                <c:if test="${sessionScope.currentUser.role == 'admin'}">
                    <li class="nav-item">
                        <a class="nav-link ${fn:startsWith(uri, '/admin') ? 'active' : ''}"
                            href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                    </li>
                </c:if>

                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center gap-2 ${uri == '/profile' ? 'active' : ''}"
                                href="#" id="navUserDropdown" role="button" data-bs-toggle="dropdown"
                                aria-expanded="false">
                                <c:if test="${not empty sessionScope.currentUser.avatar}">
                                    <img class="rounded-circle navbar-avatar"
                                        src="${pageContext.request.contextPath}/image/${sessionScope.currentUser.avatar}"
                                        alt="Avatar">
                                </c:if>
                                <span>${sessionScope.currentUser.fullname}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-lg-end" aria-labelledby="navUserDropdown">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Hồ sơ</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link ${uri == '/login' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary btn-sm ms-lg-2"
                                href="${pageContext.request.contextPath}/register">Đăng ký</a>
                        </li>
                    </c:otherwise>
                </c:choose>

            </ul>
        </div>
    </div>
</nav>
