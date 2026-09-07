<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title><sitemesh:write property='title'/></title>

<!-- Favicon của Template Agency -->
<link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/theme/agency/assets/favicon.ico">

<!-- Font Awesome icons (dùng chung cho toàn site, kể cả các trang cũ) -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<!-- Google Fonts do Template Agency yêu cầu (Montserrat, Roboto Slab) -->
<link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css">
<link href="https://fonts.googleapis.com/css?family=Roboto+Slab:400,100,300,700" rel="stylesheet" type="text/css">

<!-- Template Bootstrap dùng chung: Start Bootstrap - Agency-->
<link href="${pageContext.request.contextPath}/theme/agency/css/styles.css" rel="stylesheet">

<style>
html, body { height: 100%; }
body { display: flex; flex-direction: column; min-height: 100vh; }
.sm-main { flex: 1 0 auto; }

/* Footer theo style của Template Agency, tái sử dụng lại cho toàn site */
.sm-footer.footer { background: #212529; }
.sm-footer.footer, .sm-footer.footer a.link-light { color: #f8f9fa; }
</style>

<!-- head do trang content khai báo (title phụ, meta, css riêng của từng trang, ...) -->
<sitemesh:write property='head'/>
</head>

<body id="page-top">

	<!-- Giữ nguyên navbar cũ -->
	<jsp:include page="/views/common/navbar.jsp" />

	<main class="sm-main">
		<sitemesh:write property='body'/>
	</main>

	<!-- Footer theo Template Agency -->
	<footer class="sm-footer footer py-4">
		<div class="container">
			<div class="row align-items-center">
				<div class="col-lg-6 text-center text-lg-start small">
					&copy; Bài tập lập trình Web - Sitemesh Decorator 3 + Bootstrap (Start Bootstrap - Agency)
				</div>
				<div class="col-lg-6 text-center text-lg-end small mt-2 mt-lg-0">
					<a class="link-light text-decoration-none me-3" href="${pageContext.request.contextPath}/home">Trang chủ</a>
					<a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/categories">Danh mục</a>
				</div>
			</div>
		</div>
	</footer>

	<!-- Bootstrap core JS đã bundle sẵn trong Template Agency -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Core theme JS của Template Agency (navbar shrink, scrollspy, ...) -->
	<script src="${pageContext.request.contextPath}/theme/agency/js/scripts.js"></script>
</body>
</html>
