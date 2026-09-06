<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Dashboard doanh số</title>
<!-- THÊM DÒNG NÀY -->
<script src="${pageContext.request.contextPath}/js/chart.umd.min.js"></script>
<style>
* {
	box-sizing: border-box;
}

body {
	font-family: 'Helvetica Neue', Arial, sans-serif;
	margin: 0;
	background: #f4f5f7;
	color: #1a1a1a;
}

.container {
	max-width: 1180px;
	margin: 0 auto;
	padding: 34px 24px 60px;
}

.page-title {
	font-size: 24px;
	font-weight: 700;
	margin: 0 0 4px;
}

.page-subtitle {
	font-size: 14px;
	color: #777;
	margin: 0 0 26px;
}

/* ---------- Summary cards (giống mẫu: icon tròn màu + số liệu + thanh màu) ---------- */
.summary {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 18px;
	margin-bottom: 24px;
}

.stat-card {
	background: #fff;
	border-radius: 12px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, .05);
	overflow: hidden;
}

.stat-card-body {
	display: flex;
	align-items: center;
	gap: 14px;
	padding: 20px 20px 16px;
}

.stat-icon {
	width: 46px;
	height: 46px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	flex-shrink: 0;
}

.stat-icon svg {
	width: 22px;
	height: 22px;
}

.stat-icon.pink {
	background: #fdeaf0;
	color: #e0577c;
}

.stat-icon.purple {
	background: #efeaf9;
	color: #8a6fd6;
}

.stat-icon.blue {
	background: #e6f4fb;
	color: #4aa8d8;
}

.stat-icon.green {
	background: #e8f6ec;
	color: #4caf7d;
}

.stat-text .stat-label {
	font-size: 13px;
	font-weight: 700;
	color: #333;
}

.stat-text .stat-sub {
	font-size: 11.5px;
	color: #999;
	margin-top: 1px;
}

.stat-value {
	padding: 0 20px 14px;
	font-size: 21px;
	font-weight: 700;
}

.stat-bar {
	height: 5px;
	width: 100%;
}

.stat-bar.pink {
	background: #ec6f92;
}

.stat-bar.purple {
	background: #9c86e0;
}

.stat-bar.blue {
	background: #5cbce8;
}

.stat-bar.green {
	background: #66c98a;
}

/* ---------- Chart panels ---------- */
.chart-row {
	display: grid;
	grid-template-columns: 1.6fr 1fr;
	gap: 18px;
	margin-bottom: 24px;
}

.panel {
	background: #fff;
	border-radius: 12px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, .05);
	padding: 20px 22px 12px;
}

.panel-title {
	font-size: 14.5px;
	font-weight: 700;
	margin: 0 0 2px;
}

.panel-subtitle {
	font-size: 12px;
	color: #999;
	margin: 0 0 12px;
}

.panel-chart-wrap {
	position: relative;
	height: 260px;
}

.panel-empty {
	color: #999;
	font-style: italic;
	font-size: 13.5px;
	padding: 30px 0;
	text-align: center;
}

/* ---------- Section (bảng sản phẩm bán chạy) ---------- */
.section {
	background: #fff;
	border-radius: 12px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, .05);
	padding: 24px 26px;
}

.section-title {
	font-size: 15px;
	font-weight: 700;
	margin: 0 0 2px;
}

.section-subtitle {
	font-size: 12.5px;
	color: #999;
	margin: 0 0 18px;
}

table {
	width: 100%;
	border-collapse: collapse;
}

th, td {
	padding: 12px 10px;
	text-align: left;
	vertical-align: middle;
	border-bottom: 1px solid #f0f0f0;
	font-size: 13.5px;
}

th {
	font-size: 11.5px;
	color: #999;
	font-weight: 700;
	text-transform: uppercase;
	letter-spacing: .3px;
}

th.sortable {
	cursor: pointer;
	user-select: none;
	white-space: nowrap;
}

th.sortable:hover {
	color: #333;
}

.sort-icon {
	margin-left: 4px;
	color: #ccc;
	font-size: 10px;
}

th.sortable.asc .sort-icon, th.sortable.desc .sort-icon {
	color: #1a1a1a;
}

.rank-badge {
	width: 24px;
	height: 24px;
	border-radius: 50%;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	font-size: 11px;
	font-weight: 700;
	background: #f4f4f4;
	color: #777;
}

.rank-badge.r1 {
	background: #ffd54f;
	color: #7a5c00;
}

.rank-badge.r2 {
	background: #e0e0e0;
	color: #555;
}

.rank-badge.r3 {
	background: #ffab91;
	color: #7a2e00;
}

.prod-cell {
	display: flex;
	align-items: center;
	gap: 10px;
}

.prod-thumb {
	width: 42px;
	height: 42px;
	object-fit: cover;
	border-radius: 6px;
	border: 1px solid #eee;
	flex-shrink: 0;
	background: #f4f4f4;
}

.no-thumb {
	width: 42px;
	height: 42px;
	border-radius: 6px;
	background: #f4f4f4;
	flex-shrink: 0;
}

.prod-name {
	font-weight: 600;
}

.cell-num {
	text-align: right;
}

.revenue-num {
	font-weight: 700;
	color: #2e7d32;
}

.cat-pill {
	display: inline-block;
	font-size: 11.5px;
	background: #f2f2f2;
	color: #555;
	padding: 3px 9px;
	border-radius: 10px;
}

.empty {
	color: #999;
	font-style: italic;
	font-size: 13.5px;
	padding: 10px 0;
}

@media ( max-width : 900px) {
	.summary {
		grid-template-columns: repeat(2, 1fr);
	}
	.chart-row {
		grid-template-columns: 1fr;
	}
}
</style>
</head>

<body>
	<%@ include file="/views/common/navbar.jsp"%>

	<div class="container">
		<h2 class="page-title">Dashboard doanh số</h2>

		<!-- ===== Thẻ tổng quan ===== -->
		<div class="summary">
			<div class="stat-card">
				<div class="stat-card-body">
					<span class="stat-icon pink"> <svg viewBox="0 0 24 24"
							fill="none" stroke="currentColor" stroke-width="2"
							stroke-linecap="round" stroke-linejoin="round">
							<line x1="12" y1="1" x2="12" y2="23"></line>
							<path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
					</span>
					<div class="stat-text">
						<div class="stat-label">Doanh thu</div>
						<div class="stat-sub">Tổng doanh thu</div>
					</div>
				</div>
				<div class="stat-value">
					<fmt:formatNumber value="${totalRevenue}" type="number"
						groupingUsed="true" />
					đ
				</div>
				<div class="stat-bar pink"></div>
			</div>

			<div class="stat-card">
				<div class="stat-card-body">
					<span class="stat-icon purple"> <svg viewBox="0 0 24 24"
							fill="none" stroke="currentColor" stroke-width="2"
							stroke-linecap="round" stroke-linejoin="round">
							<path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"></path>
							<path d="M3 6h18"></path>
							<path d="M16 10a4 4 0 0 1-8 0"></path></svg>
					</span>
					<div class="stat-text">
						<div class="stat-label">Đã bán</div>
						<div class="stat-sub">Sản phẩm đã bán</div>
					</div>
				</div>
				<div class="stat-value">
					<fmt:formatNumber value="${totalSold}" groupingUsed="true" />
				</div>
				<div class="stat-bar purple"></div>
			</div>

			<div class="stat-card">
				<div class="stat-card-body">
					<span class="stat-icon blue"> <svg viewBox="0 0 24 24"
							fill="none" stroke="currentColor" stroke-width="2"
							stroke-linecap="round" stroke-linejoin="round">
							<path
								d="M20.59 13.41 11 3.83A2 2 0 0 0 9.59 3.24H4a1 1 0 0 0-1 1v5.59a2 2 0 0 0 .59 1.41l9.58 9.58a2 2 0 0 0 2.83 0l4.59-4.59a2 2 0 0 0 0-2.83Z"></path>
							<circle cx="7.5" cy="7.5" r="1.5"></circle></svg>
					</span>
					<div class="stat-text">
						<div class="stat-label">Sản phẩm</div>
						<div class="stat-sub">Đang kinh doanh</div>
					</div>
				</div>
				<div class="stat-value">${totalProducts}</div>
				<div class="stat-bar blue"></div>
			</div>

			<div class="stat-card">
				<div class="stat-card-body">
					<span class="stat-icon green"> <svg viewBox="0 0 24 24"
							fill="none" stroke="currentColor" stroke-width="2"
							stroke-linecap="round" stroke-linejoin="round">
							<rect x="3" y="3" width="7" height="7"></rect>
							<rect x="14" y="3" width="7" height="7"></rect>
							<rect x="14" y="14" width="7" height="7"></rect>
							<rect x="3" y="14" width="7" height="7"></rect></svg>
					</span>
					<div class="stat-text">
						<div class="stat-label">Danh mục</div>
						<div class="stat-sub">${totalCategories}danh mục</div>
					</div>
				</div>
				<div class="stat-value">
					<c:choose>
						<c:when test="${not empty topCategory}">${topCategory.category.categoryname}</c:when>
						<c:otherwise>—</c:otherwise>
					</c:choose>
				</div>
				<div class="stat-bar green"></div>
			</div>
		</div>

		<!-- ===== Biểu đồ ===== -->
		<div class="chart-row">
			<div class="panel">
				<h3 class="panel-title">Doanh thu theo danh mục</h3>
				<p class="panel-subtitle">Đơn vị: VNĐ</p>
				<c:if test="${empty categoryStats}">
					<div class="panel-empty">Chưa có dữ liệu để hiển thị.</div>
				</c:if>
				<c:if test="${not empty categoryStats}">
					<div class="panel-chart-wrap">
						<canvas id="revenueBarChart"></canvas>
					</div>
				</c:if>
			</div>

			<div class="panel">
				<h3 class="panel-title">Tỷ trọng doanh thu</h3>
				<p class="panel-subtitle">Theo danh mục</p>
				<c:if test="${empty categoryStats}">
					<div class="panel-empty">Chưa có dữ liệu để hiển thị.</div>
				</c:if>
				<c:if test="${not empty categoryStats}">
					<div class="panel-chart-wrap">
						<canvas id="revenueDonutChart"></canvas>
					</div>
				</c:if>
			</div>
		</div>

		<!-- ===== Bảng sản phẩm bán chạy ===== -->
		<div class="section">
			<h3 class="section-title">Sản phẩm bán chạy</h3>

			<c:if test="${empty topProducts}">
				<p class="empty">Chưa có sản phẩm nào.</p>
			</c:if>

			<c:if test="${not empty topProducts}">
				<table id="topProductsTable">
					<thead>
						<tr>
							<th>#</th>
							<th class="sortable" data-column="1" data-type="text">Sản
								phẩm<span class="sort-icon">⇅</span>
							</th>
							<th class="sortable" data-column="2" data-type="text">Danh
								mục<span class="sort-icon">⇅</span>
							</th>
							<th class="sortable" data-column="3" data-type="number">Giá<span
								class="sort-icon">⇅</span></th>
							<th class="sortable" data-column="4" data-type="number">Đã
								bán<span class="sort-icon">⇅</span>
							</th>
							<th class="sortable" data-column="5" data-type="number">Doanh
								thu<span class="sort-icon">⇅</span>
							</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${topProducts}" var="p" varStatus="idx">
							<tr>
								<td><c:choose>
										<c:when test="${idx.index == 0}">
											<span class="rank-badge r1">1</span>
										</c:when>
										<c:when test="${idx.index == 1}">
											<span class="rank-badge r2">2</span>
										</c:when>
										<c:when test="${idx.index == 2}">
											<span class="rank-badge r3">3</span>
										</c:when>
										<c:otherwise>
											<span class="rank-badge">${idx.index + 1}</span>
										</c:otherwise>
									</c:choose></td>
								<td>
									<div class="prod-cell">
										<c:choose>
											<c:when test="${not empty p.images}">
												<img class="prod-thumb"
													src="${pageContext.request.contextPath}/image/${p.images}"
													alt="${p.productName}">
											</c:when>
											<c:otherwise>
												<div class="no-thumb"></div>
											</c:otherwise>
										</c:choose>
										<span class="prod-name">${p.productName}</span>
									</div>
								</td>
								<td><span class="cat-pill">${p.category.categoryname}</span></td>
								<td class="cell-num"><fmt:formatNumber value="${p.price}"
										type="number" groupingUsed="true" /> đ</td>
								<td class="cell-num"><fmt:formatNumber value="${p.sold}"
										groupingUsed="true" /></td>
								<td class="cell-num revenue-num"><fmt:formatNumber
										value="${p.revenue}" type="number" groupingUsed="true" /> đ</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>

				<script>
                    document.querySelectorAll('#topProductsTable th.sortable').forEach(function (header) {
                        header.addEventListener('click', function () {
                            var table = document.getElementById('topProductsTable');
                            var tbody = table.querySelector('tbody');
                            var column = Number(this.dataset.column);
                            var type = this.dataset.type;
                            var ascending = !this.classList.contains('asc');
                            var rows = Array.from(tbody.querySelectorAll('tr'));

                            rows.sort(function (rowA, rowB) {
                                var valueA = rowA.cells[column].textContent.trim();
                                var valueB = rowB.cells[column].textContent.trim();
                                var result;

                                if (type === 'number') {
                                    result = parseFloat(valueA.replace(/[^0-9.-]/g, '')) - parseFloat(valueB.replace(/[^0-9.-]/g, ''));
                                } else {
                                    result = valueA.localeCompare(valueB, 'vi', { sensitivity: 'base', numeric: true });
                                }

                                return ascending ? result : -result;
                            });

                            table.querySelectorAll('th.sortable').forEach(function (th) {
                                th.classList.remove('asc', 'desc');
                                th.querySelector('.sort-icon').textContent = '⇅';
                            });

                            this.classList.add(ascending ? 'asc' : 'desc');
                            this.querySelector('.sort-icon').textContent = ascending ? '▲' : '▼';
                            rows.forEach(function (row) { tbody.appendChild(row); });
                        });
                    });
                </script>
			</c:if>
		</div>
	</div>

	<c:if test="${not empty categoryStats}">
		<script>
            var categoryLabels = [
                <c:forEach items="${categoryStats}" var="stat" varStatus="idx">"${fn:escapeXml(stat.category.categoryname)}"<c:if test="${!idx.last}">,</c:if></c:forEach>
            ];
            var categoryRevenues = [
                <c:forEach items="${categoryStats}" var="stat" varStatus="idx">${stat.totalRevenue}<c:if test="${!idx.last}">,</c:if></c:forEach>
            ];
            var chartColors = ['#ec6f92', '#9c86e0', '#5cbce8', '#66c98a', '#f4b458', '#e0577c', '#7fd8c8', '#c98acb'];

            new Chart(document.getElementById('revenueBarChart'), {
                type: 'bar',
                data: {
                    labels: categoryLabels,
                    datasets: [{
                        data: categoryRevenues,
                        backgroundColor: categoryLabels.map(function (_, i) { return chartColors[i % chartColors.length]; }),
                        borderRadius: 6,
                        maxBarThickness: 46
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, ticks: { callback: function (v) { return (v / 1000000) + 'tr'; } } },
                        x: { grid: { display: false } }
                    }
                }
            });

            new Chart(document.getElementById('revenueDonutChart'), {
                type: 'doughnut',
                data: {
                    labels: categoryLabels,
                    datasets: [{
                        data: categoryRevenues,
                        backgroundColor: categoryLabels.map(function (_, i) { return chartColors[i % chartColors.length]; }),
                        borderWidth: 2,
                        borderColor: '#fff'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: '62%',
                    plugins: { legend: { position: 'bottom', labels: { boxWidth: 10, font: { size: 11 } } } }
                }
            });
        </script>
	</c:if>
</body>

</html>
