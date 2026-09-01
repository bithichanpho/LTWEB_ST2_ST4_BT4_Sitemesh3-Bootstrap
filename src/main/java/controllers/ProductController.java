package controllers;

import java.io.IOException;
import java.util.List;

import dao.IProductDao;
import dao.impl.ProductDao;
import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/product", "/product/detail"})
public class ProductController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final int PAGE_SIZE = 6;
	
	private IProductDao productDao = new ProductDao();
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
