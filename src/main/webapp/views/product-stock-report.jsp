<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thống kê số lượng sản phẩm</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 0;
	background: #f9f9f9;
}

.container {
	padding: 30px;
}

h2 {
	color: #333;
	margin-bottom: 6px;
}

.summary {
	display: flex;
	flex-wrap: wrap;
	gap: 16px;
	margin: 18px 0 24px;
	font-weight: bold;
}

.summary-card {
	flex: 1;
	min-width: 200px;
	background: #fff;
	border-radius: 8px;
	padding: 16px 20px;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
}

.summary-card .label {
	font-size: 13px;
	color: #777;
	font-weight: bold;
}

.summary-card .value {
	font-size: 26px;
	margin-top: 4px;
	font-weight: normal;
}

.summary-card.total .value, .summary-card.in .value, .summary-card.qty .value {
	color: black;
}

.summary-card.out .value {
	color: #c62828;
}

/* ----- Bộ lọc ----- */
.filter-toggle-row {
	display: flex;
	align-items: center;
	gap: 12px;
	margin-bottom: 14px;
}

.btn-toggle-filter {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	padding: 10px 18px;
	border: 1px solid #ddd;
	border-radius: 6px;
	background: #fff;
	color: #333;
	font-weight: bold;
	font-size: 13px;
	cursor: pointer;
}

.btn-toggle-filter:hover {
	background: #f4f4f4;
}

.btn-toggle-filter.active {
	background: #2196F3;
	border-color: #2196F3;
	color: #fff;
}

.btn-toggle-filter .chevron {
	transition: transform .15s;
	font-size: 11px;
}

.btn-toggle-filter.active .chevron {
	transform: rotate(180deg);
}

.active-filter-tag {
	background: #e3f2fd;
	color: #1565C0;
	font-size: 12px;
	font-weight: bold;
	padding: 5px 10px;
	border-radius: 12px;
}

.filter-bar {
	display: none;
	flex-wrap: wrap;
	align-items: flex-end;
	gap: 14px;
	background: #fff;
	border-radius: 8px;
	padding: 16px 20px;
	margin-bottom: 20px;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
}

.filter-bar.show {
	display: flex;
}

.filter-field {
	display: flex;
	flex-direction: column;
	gap: 6px;
}

.filter-field label {
	font-size: 12px;
	color: #777;
	font-weight: 600;
}

.filter-field select {
	padding: 8px 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
	font-size: 13px;
	min-width: 170px;
	background: #fff;
	color: #333;
}

.filter-actions {
	display: flex;
	gap: 8px;
}

.btn-filter {
	padding: 9px 18px;
	border: none;
	border-radius: 4px;
	font-weight: bold;
	background: #2196F3;
	color: #fff;
	cursor: pointer;
	font-size: 13px;
}

.btn-filter:hover {
	background: #1976D2;
}

.btn-reset {
	padding: 9px 18px;
	border: 1px solid #ddd;
	border-radius: 4px;
	font-weight: bold;
	background: #fff;
	color: #555;
	text-decoration: none;
	font-size: 13px;
	display: inline-block;
}

.btn-reset:hover {
	background: #f4f4f4;
}

.filter-result {
	color: #555;
	font-size: 13px;
	margin: -8px 0 16px;
	font-weight: normal;
}

.filter-result b {
	color: #2196F3;
}

table {
	width: 100%;
	border-collapse: collapse;
	background: #fff;
}

table, th, td {
	border: 1px solid #ddd;
}

th, td {
	padding: 12px;
	text-align: left;
	vertical-align: middle;
}

th {
	background-color: #f4f4f4;
}

th.sortable {
	cursor: pointer;
	user-select: none;
	white-space: nowrap;
}

th.sortable:hover {
	background-color: #e8e8e8;
}

.sort-icon {
	display: inline-block;
	margin-left: 6px;
	color: #999;
	font-size: 11px;
}

th.sortable.asc .sort-icon,
th.sortable.desc .sort-icon {
	color: #2196F3;
}

.thumb {
	width: 60px;
	height: 60px;
	object-fit: cover;
	border-radius: 4px;
	display: block;
	background: #eee;
}

.no-thumb {
	color: gray;
	font-style: italic;
	font-size: 12px;
}

.badge {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	padding: 4px 10px;
	border-radius: 12px;
	font-size: 12px;
	font-weight: 600;
}

.badge-in {
	background: #e8f5e9;
	color: #2e7d32;
}

.badge-out {
	background: #ffebee;
	color: #c62828;
}

.badge-dot {
	width: 8px;
	height: 8px;
	border-radius: 50%;
	display: inline-block;
}

.badge-in .badge-dot {
	background: #2e7d32;
}

.badge-out .badge-dot {
	background: #c62828;
}

.qty-num {
	font-weight: bold;
}

.empty {
	color: gray;
	font-style: italic;
}
</style>
</head>
<body>

	<%@ include file="/views/common/navbar.jsp"%>

	<div class="container">
		<h2>Thống kê số lượng sản phẩm</h2>

		<div class="summary">
			<div class="summary-card total">
				<div class="label">Tổng số sản phẩm</div>
				<div class="value">${totalCount}</div>
			</div>
			<div class="summary-card in">
				<div class="label">Còn hàng (In stock)</div>
				<div class="value">${inStockCount}</div>
			</div>
			<div class="summary-card out">
				<div class="label">Hết hàng (Out of stock)</div>
				<div class="value">${outStockCount}</div>
			</div>
			<div class="summary-card qty">
				<div class="label">Tổng số lượng còn (tất cả sản phẩm)</div>
				<div class="value">${totalQuantity}</div>
			</div>
		</div>

		<c:set var="hasActiveFilter"
			value="${selectedCatIdNum != -1 or selectedStatus != 'all' or selectedQty != 'all'}" />

		<div class="filter-toggle-row">
			<button type="button" id="filterToggleBtn"
				class="btn-toggle-filter ${hasActiveFilter ? 'active' : ''}"
				onclick="toggleFilterPanel()">
				<svg width="15" height="15" viewBox="0 0 24 24" fill="none"
					stroke="currentColor" stroke-width="2" stroke-linecap="round"
					stroke-linejoin="round">
					<polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3" />
				</svg>
				<span>Lọc sản phẩm</span>
				<span class="chevron">▾</span>
			</button>
			<c:if test="${hasActiveFilter}">
				<span class="active-filter-tag">Đang áp dụng bộ lọc</span>
				<a class="btn-reset"
					href="${pageContext.request.contextPath}/product/stock-report">Xóa
					lọc</a>
			</c:if>
		</div>

		<form id="filterPanel" class="filter-bar ${hasActiveFilter ? 'show' : ''}"
			method="get" action="${pageContext.request.contextPath}/product/stock-report">
			<div class="filter-field">
				<label for="catId">Danh mục</label>
				<select id="catId" name="catId">
					<option value="all" ${selectedCatIdNum == -1 ? 'selected' : ''}>Tất
						cả danh mục</option>
					<c:forEach items="${allCategories}" var="c">
						<option value="${c.categoryId}"
							${selectedCatIdNum == c.categoryId ? 'selected' : ''}>${c.categoryname}</option>
					</c:forEach>
				</select>
			</div>

			<div class="filter-field">
				<label for="status">Tình trạng</label>
				<select id="status" name="status">
					<option value="all" ${selectedStatus == 'all' ? 'selected' : ''}>Tất
						cả</option>
					<option value="in" ${selectedStatus == 'in' ? 'selected' : ''}>Còn
						hàng (In stock)</option>
					<option value="out" ${selectedStatus == 'out' ? 'selected' : ''}>Hết
						hàng (Out of stock)</option>
				</select>
			</div>

			<div class="filter-field">
				<label for="qty">Khoảng số lượng</label>
				<select id="qty" name="qty">
					<option value="all" ${selectedQty == 'all' ? 'selected' : ''}>Tất
						cả</option>
					<option value="lt10" ${selectedQty == 'lt10' ? 'selected' : ''}>Dưới
						10</option>
					<option value="10to20"
						${selectedQty == '10to20' ? 'selected' : ''}>10 - 20</option>
					<option value="21to50"
						${selectedQty == '21to50' ? 'selected' : ''}>21 - 50</option>
					<option value="gt50" ${selectedQty == 'gt50' ? 'selected' : ''}>Trên
						50</option>
				</select>
			</div>

			<div class="filter-actions">
				<button type="submit" class="btn-filter">Áp dụng lọc</button>
			</div>
		</form>

		<script>
			function toggleFilterPanel() {
				var panel = document.getElementById('filterPanel');
				var btn = document.getElementById('filterToggleBtn');
				panel.classList.toggle('show');
				btn.classList.toggle('active');
			}
		</script>

		<p class="filter-result">
			Hiển thị <b>${filteredCount}</b> / ${totalCount} sản phẩm theo bộ lọc
			đã chọn.
		</p>

		<c:if test="${empty allProducts}">
			<p class="empty">Chưa có sản phẩm nào phù hợp với bộ lọc đã chọn.</p>
		</c:if>

		<c:if test="${not empty allProducts}">
			<table id="stockTable">
				<thead>
					<tr>
						<th>Hình ảnh</th>
						<th class="sortable" data-column="1" data-type="text">Tên sản phẩm<span class="sort-icon">⇅</span></th>
						<th class="sortable" data-column="2" data-type="text">Tên danh mục<span class="sort-icon">⇅</span></th>
						<th class="sortable" data-column="3" data-type="number">Số lượng<span class="sort-icon">⇅</span></th>
						<th class="sortable" data-column="4" data-type="text">Tình trạng<span class="sort-icon">⇅</span></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${allProducts}" var="p">
						<tr>
							<td><c:choose>
									<c:when test="${not empty p.images}">
										<img class="thumb"
											src="${pageContext.request.contextPath}/image/${p.images}"
											alt="${p.productName}">
									</c:when>
									<c:otherwise>
										<span class="no-thumb">Chưa có ảnh</span>
									</c:otherwise>
								</c:choose></td>
							<td>${p.productName}</td>
							<td>${p.category.categoryname}</td>
							<td class="qty-num">${p.quantity}</td>
							<td><c:choose>
									<c:when test="${p.quantity > 0}">
										<span class="badge badge-in"><span class="badge-dot"></span>In
											stock</span>
									</c:when>
									<c:otherwise>
										<span class="badge badge-out"><span class="badge-dot"></span>Out
											of stock</span>
									</c:otherwise>
								</c:choose></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>

			<script>
				document.querySelectorAll('#stockTable th.sortable').forEach(function(header) {
					header.addEventListener('click', function() {
						var table = document.getElementById('stockTable');
						var tbody = table.querySelector('tbody');
						var column = Number(this.dataset.column);
						var type = this.dataset.type;
						var ascending = !this.classList.contains('asc');
						var rows = Array.from(tbody.querySelectorAll('tr'));

						rows.sort(function(rowA, rowB) {
							var valueA = rowA.cells[column].textContent.trim();
							var valueB = rowB.cells[column].textContent.trim();
							var result;

							if (type === 'number') {
								result = Number(valueA) - Number(valueB);
							} else {
								result = valueA.localeCompare(valueB, 'vi', {
									sensitivity: 'base',
									numeric: true
								});
							}

							return ascending ? result : -result;
						});

						table.querySelectorAll('th.sortable').forEach(function(th) {
							th.classList.remove('asc', 'desc');
							th.querySelector('.sort-icon').textContent = '⇅';
						});

						this.classList.add(ascending ? 'asc' : 'desc');
						this.querySelector('.sort-icon').textContent = ascending ? '▲' : '▼';
						rows.forEach(function(row) { tbody.appendChild(row); });
					});
				});
			</script>
		</c:if>
	</div>
</body>
</html>
