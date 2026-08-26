<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Tự động chuyển hướng người dùng sang trang danh sách category
    response.sendRedirect(request.getContextPath() + "/categories");
%>