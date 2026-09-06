package controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import dao.ICategoryDao;
import dao.IProductDao;
import dao.impl.CategoryDao;
import dao.impl.ProductDao;
import entity.Category;
import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/product", "/product/detail", "/product/stock-report"})
public class ProductController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final int PAGE_SIZE = 6;
	
	private IProductDao productDao = new ProductDao();
	private ICategoryDao categoryDao = new CategoryDao();
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");
		String url = req.getRequestURI();
		
		if (url.contains("/product/detail")) {
			try {
				int id = Integer.parseInt(req.getParameter("id"));
				Product product = productDao.findById(id);
				
				if (product == null) {
					resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm");
					return;
				}
				
				req.setAttribute("product", product);
				req.getRequestDispatcher("/views/product-detail.jsp").forward(req, resp);
			} catch (NumberFormatException e) {
				resp.sendRedirect(req.getContextPath() + "/product");
			}
			return;
		}

		if (url.contains("/product/stock-report")) {
			List<Product> all = productDao.findAll();

			// Thống kê tổng quan tính trên TOÀN BỘ sản phẩm (không phụ thuộc filter)
			int inStock = 0;
			int outStock = 0;
			int totalQuantity = 0;
			for (Product p : all) {
				if (p.getQuantity() > 0) {
					inStock++;
				} else {
					outStock++;
				}
				totalQuantity += p.getQuantity();
			}

			// Đọc tham số filter từ request, mặc định "all" (không lọc)
			String catParam = req.getParameter("catId");
			String statusParam = req.getParameter("status");
			String qtyParam = req.getParameter("qty");
			if (catParam == null || catParam.isEmpty()) catParam = "all";
			if (statusParam == null || statusParam.isEmpty()) statusParam = "all";
			if (qtyParam == null || qtyParam.isEmpty()) qtyParam = "all";

			// selectedCatIdNum dùng -1 để đại diện cho "Tất cả danh mục".
			// Dùng kiểu số (thay vì so sánh String "all" với int categoryId trong JSP EL)
			// để tránh lỗi ép kiểu khi so sánh trong JSP.
			int selectedCatIdNum = -1;
			if (!"all".equals(catParam)) {
				try {
					selectedCatIdNum = Integer.parseInt(catParam);
				} catch (NumberFormatException ignored) {
					selectedCatIdNum = -1;
				}
			}

			List<Product> filtered = new ArrayList<>();
			for (Product p : all) {
				// Lọc theo danh mục
				if (selectedCatIdNum != -1) {
					if (p.getCategory() == null || p.getCategory().getCategoryId() != selectedCatIdNum) {
						continue;
					}
				}

				// Lọc theo tình trạng còn hàng / hết hàng
				if ("in".equals(statusParam) && p.getQuantity() <= 0) continue;
				if ("out".equals(statusParam) && p.getQuantity() > 0) continue;

				// Lọc theo khoảng số lượng
				int q = p.getQuantity();
				if ("lt10".equals(qtyParam) && !(q < 10)) continue;
				if ("10to20".equals(qtyParam) && !(q >= 10 && q <= 20)) continue;
				if ("21to50".equals(qtyParam) && !(q >= 21 && q <= 50)) continue;
				if ("gt50".equals(qtyParam) && !(q > 50)) continue;

				filtered.add(p);
			}

			List<Category> categories = categoryDao.findAll();

			req.setAttribute("allCategories", categories);
			req.setAttribute("selectedCatIdNum", selectedCatIdNum);
			req.setAttribute("selectedStatus", statusParam);
			req.setAttribute("selectedQty", qtyParam);

			req.setAttribute("allProducts", filtered);
			req.setAttribute("filteredCount", filtered.size());

			req.setAttribute("totalCount", all.size());
			req.setAttribute("inStockCount", inStock);
			req.setAttribute("outStockCount", outStock);
			req.setAttribute("totalQuantity", totalQuantity);
			req.getRequestDispatcher("/views/product-stock-report.jsp").forward(req, resp);
			return;
		}
		
		int page = 1;
		try {
			page = Integer.parseInt(req.getParameter("page"));
			
		} catch (Exception ignored) {
			
		}
		if (page < 1) page = 1;
		
		int totalItems = productDao.count();
		int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
		if (totalPages == 0) totalPages = 1;
		if (page > totalPages) page = totalPages;
		
		List<Product> list = productDao.findAll(page - 1, PAGE_SIZE);
		
		req.setAttribute("productList", list);
		req.setAttribute("currentPage", page);
		req.setAttribute("totalPages", totalPages);
		req.getRequestDispatcher("/views/product-list.jsp").forward(req, resp);
	}
	
	
	
}

