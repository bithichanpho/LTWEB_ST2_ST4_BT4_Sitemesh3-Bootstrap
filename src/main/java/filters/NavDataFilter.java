package filters;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dao.ICategoryDao;
import dao.IProductDao;
import dao.impl.CategoryDao;
import dao.impl.ProductDao;
import entity.Category;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;

@WebFilter("/*")
public class NavDataFilter implements Filter {

	private ICategoryDao categoryDao = new CategoryDao();
	private IProductDao productDao = new ProductDao();

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		String uri = req.getRequestURI();

		// Bỏ qua servlet đọc ảnh để tránh query DB không cần thiết mỗi lần tải ảnh
		if (!uri.contains("/image/")) {
			List<Category> categories = categoryDao.findAll();
			Map<Integer, Integer> counts = new HashMap<>();
			for (Category c : categories) {
				counts.put(c.getCategoryId(), productDao.countByCategory(c.getCategoryId()));
			}
			request.setAttribute("navCategories", categories);
			request.setAttribute("navCategoryCounts", counts);
			request.setAttribute("navTotalProducts", productDao.count());
		}

		chain.doFilter(request, response);
	}
}