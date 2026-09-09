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

/* --nav-height được scripts.js đo và cập nhật đúng bằng chiều cao thật
   của #mainNav (khác nhau giữa trạng thái bình thường và navbar-shrink,
   và giữa mobile/desktop), nên nội dung luôn được đẩy xuống vừa đủ,
   không bị navbar đè lên hay để dư khoảng trắng. 76px/104px chỉ là giá
   trị dự phòng cho lần render đầu tiên trước khi JS kịp chạy. */
/* Navbar giờ cố định height: 72px (xem #mainNav trong styles.css), giống
   nhau ở mọi breakpoint và mọi trạng thái shrink, nên chỉ cần 1 giá trị. */
.sm-main { padding-top: var(--nav-height, 72px); }

/* Mặc định (các trang KHÔNG có hero ảnh full-width, ví dụ login, product...):
   giữ navbar nền tối liền mạch ngay từ đầu, không để trong suốt.
   Trang home.jsp tự override lại thành transparent để navbar "nổi" trên
   ảnh hero (xem <style> trong home.jsp) — style đó nằm sau đoạn này trong
   HTML nên sẽ được áp dụng đè lên, đúng ý đồ ban đầu. */
@media (min-width: 992px) {
	#mainNav:not(.navbar-shrink) { background-color: rgba(33, 37, 41, .92) !important; }
}

/* Footer theo style của Template Agency, tái sử dụng lại cho toàn site */
.sm-footer.footer {
	background: #212529;
	/* Gọn lại (thay vì py-4 mặc định) + chữ to hơn "small" cũ */
	padding-top: 0.75rem;
	padding-bottom: 0.75rem;
	font-size: 1.05rem;
}
.sm-footer.footer, .sm-footer.footer a.link-light { color: #f8f9fa; }
</style>

<!-- head do trang content khai báo (title phụ, meta, css riêng của từng trang, ...) -->
<sitemesh:write property='head'/>
</head>

<body id="page-top">

	<!-- Navbar dùng thành phần Bootstrap của Template Agency (#mainNav) -->
	<jsp:include page="/views/common/navbar.jsp" />

	<main class="sm-main">
		<sitemesh:write property='body'/>
	</main>

	<!-- Footer theo Template Agency -->
	<footer class="sm-footer footer">
		<div class="container">
			<div class="row">
				<div class="col-12 text-center">
					&copy; Bài tập lập trình Web - Sitemesh Decorator 3 + Bootstrap (Start Bootstrap - Agency)
				</div>
			</div>
		</div>
	</footer>

	<!-- Bootstrap core JS đã bundle sẵn trong Template Agency -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Core theme JS của Template Agency (navbar shrink, scrollspy, ...) -->
	<script src="${pageContext.request.contextPath}/theme/agency/js/scripts.js"></script>
</body>
</html>
