package controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import dao.ICategoryDao;
import dao.IProductDao;
import dao.impl.CategoryDao;
import dao.impl.ProductDao;
import dto.CategoryStat;
import entity.Category;
import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Dashboard thống kê doanh số cho admin: doanh thu theo từng Category,
 * sản phẩm bán chạy, tổng quan số lượng đã bán / doanh thu toàn cửa hàng.
 */
@WebServlet(urlPatterns = { "/admin/dashboard" })
public class DashboardController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private IProductDao productDao = new ProductDao();
	private ICategoryDao categoryDao = new CategoryDao();
	private Random random = new Random();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");

		List<Product> products = productDao.findAll();

		List<Category> categories = categoryDao.findAll();

		// ----- Tổng quan toàn cửa hàng -----
		double totalRevenue = 0;
		int totalSold = 0;
		for (Product p : products) {
			totalRevenue += p.getRevenue();
			totalSold += p.getSold();
		}

		double avgOrderValue = products.isEmpty() ? 0 : totalRevenue / products.size();

		// ----- Thống kê theo Category -----
		Map<Integer, CategoryStat> statMap = new HashMap<>();
		for (Category c : categories) {
			statMap.put(c.getCategoryId(), new CategoryStat(c));
		}

		for (Product p : products) {
			if (p.getCategory() == null) continue;
			CategoryStat stat = statMap.get(p.getCategory().getCategoryId());
			if (stat == null) continue;
			stat.setProductCount(stat.getProductCount() + 1);
			stat.setTotalSold(stat.getTotalSold() + p.getSold());
			stat.setTotalRevenue(stat.getTotalRevenue() + p.getRevenue());
		}

		List<CategoryStat> categoryStats = new ArrayList<>(statMap.values());
		for (CategoryStat stat : categoryStats) {
			double percent = totalRevenue > 0 ? (stat.getTotalRevenue() / totalRevenue) * 100.0 : 0;
			stat.setRevenuePercent(percent);
		}
		categoryStats.sort(Comparator.comparingDouble(CategoryStat::getTotalRevenue).reversed());

		CategoryStat topCategory = categoryStats.isEmpty() ? null : categoryStats.get(0);

		// ----- Sản phẩm bán chạy (sắp theo doanh thu giảm dần) -----
		List<Product> topProducts = new ArrayList<>(products);
		topProducts.sort(Comparator.comparingDouble(Product::getRevenue).reversed());

		req.setAttribute("totalRevenue", totalRevenue);
		req.setAttribute("totalSold", totalSold);
		req.setAttribute("totalProducts", products.size());
		req.setAttribute("totalCategories", categories.size());
		req.setAttribute("avgOrderValue", avgOrderValue);
		req.setAttribute("topCategory", topCategory);
		req.setAttribute("categoryStats", categoryStats);
		req.setAttribute("topProducts", topProducts);

		req.getRequestDispatcher("/views/admin-dashboard.jsp").forward(req, resp);
	}

}
