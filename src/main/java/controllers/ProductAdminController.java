package controllers;

import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

import configs.AppConfig;
import dao.ICategoryDao;
import dao.IProductDao;
import dao.impl.CategoryDao;
import dao.impl.ProductDao;
import dto.ProductForm;
import entity.Category;
import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import utils.ImageStorageUtil;
import utils.ValidationUtil;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxRequestSize = 1024 * 1024 * 5 * 5)
@WebServlet(urlPatterns = {"/admin/products", "/admin/product/add", "/admin/product/insert", "/admin/product/edit", "/admin/product/update", "/admin/product/delete", "/admin/product/check"})
public class ProductAdminController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
	private IProductDao productDao = new ProductDao();
	private ICategoryDao categoryDao = new CategoryDao();
	
	private final String ROOT_DIR = AppConfig.ROOT_UPLOAD_DIR;
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");
		String url = req.getRequestURI();
		
		if (url.contains("admin/products")) {
			List<Product> list = productDao.findAll();
			req.setAttribute("productList", list);
			req.getRequestDispatcher("/views/product-manage.jsp").forward(req, resp);
			
		} else if (url.contains("admin/product/add")) {
			req.setAttribute("cateList", categoryDao.findAll());
			req.getRequestDispatcher("/views/product-add.jsp").forward(req, resp);
			
		} else if (url.contains("admin/product/edit")) {
			int id = Integer.parseInt(req.getParameter("id"));
			Product product = productDao.findById(id);
			req.setAttribute("product", product);
			req.setAttribute("cateList", categoryDao.findAll());
			req.getRequestDispatcher("/views/product-edit.jsp").forward(req, resp);
			
		} else if (url.contains("admin/product/delete")) {
			int id = Integer.parseInt(req.getParameter("id"));
			try {
				productDao.delete(id);
			} catch (Exception e) {
				e.printStackTrace();
			}
			resp.sendRedirect(req.getContextPath() + "/admin/products");
			
		} else if (url.contains("admin/product/check")) {
		    // API dành cho AJAX kiểm tra trùng lặp
		    String name = req.getParameter("name");
		    int categoryId = 0;
		    try {
		        categoryId = Integer.parseInt(req.getParameter("categoryId"));
		    } catch (NumberFormatException e) {
		        categoryId = 0;
		    }
		    
		    boolean exists = productDao.checkExistByNameAndCategory(name, categoryId);
		    
		    // Trả về kết quả JSON
		    resp.setContentType("application/json");
		    resp.getWriter().write("{\"exists\": " + exists + "}");
		    return; // Dừng lại ở đây, không forward trang
		    
		}
		else {
			resp.sendRedirect(req.getContextPath() + "/admin/products");
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");
		String url = req.getRequestURI();
		
		if (url.contains("insert")) {
			String name = req.getParameter("productName");
			String priceStr = req.getParameter("price");
			String quantityStr = req.getParameter("quantity");
			String description = req.getParameter("description");
			String categoryIdStr = req.getParameter("categoryId");

			ProductForm form = new ProductForm();
			form.setProductName(name);
			form.setDescription(description);

			Map<String, String> errors = new java.util.LinkedHashMap<>();
			Double price = parseDouble(priceStr, "price", errors);
			Integer quantity = parseInt(quantityStr, "quantity", errors);
			Integer categoryId = parseInt(categoryIdStr, "categoryId", errors);
			form.setPrice(price);
			form.setQuantity(quantity);
			form.setCategoryId(categoryId);

			errors.putAll(ValidationUtil.validate(form));

			Part imagePart = req.getPart("images");
			if (imagePart == null || imagePart.getSize() == 0) {
				errors.putIfAbsent("images", "Vui lòng chọn hình ảnh sản phẩm");
			}

			if (!errors.isEmpty()) {
				req.setAttribute("fieldErrors", errors);
				req.setAttribute("cateList", categoryDao.findAll());
				req.getRequestDispatcher("/views/product-add.jsp").forward(req, resp);
				return;
			}

			try {
				Product existingProduct = productDao.findByName(name);
				if (existingProduct != null) {
				    req.setAttribute("error", "Tên sản phẩm đã tồn tại! Vui lòng nhập tên khác.");
				    req.setAttribute("cateList", categoryDao.findAll());
				    req.getRequestDispatcher("/views/product-add.jsp").forward(req, resp);
				    return; // Dừng lại, không cho thêm vào DB
				}

				String dbImageValue = "";
				Part part = req.getPart("images");
				if (part != null && part.getSize() > 0) {
					String originalFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
					String fileName = System.currentTimeMillis() + "_" + originalFileName;
					// Luu file vao thu muc external (persistent) va dong thoi copy vao
					// src/main/webapp/image/products de commit len Git - xem ImageStorageUtil.
					dbImageValue = ImageStorageUtil.store(part, "products", fileName);
 				}
				
				Category category = categoryDao.findById(categoryId);
				
				Product product = new Product();
				product.setProductName(name);
				product.setPrice(price);
				product.setQuantity(quantity);
				product.setDescription(description);
				product.setImages(dbImageValue);
				product.setCategory(category);
				// Trước đây không set trường này -> Hibernate insert NULL cho createdAt
				// mỗi lần thêm sản phẩm mới.
				product.setCreatedAt(java.time.LocalDateTime.now());
				
				productDao.insert(product);
				resp.sendRedirect(req.getContextPath() + "/admin/products");
				
			} catch (Exception e) {
				e.printStackTrace();
				req.setAttribute("error", "Thêm sản phẩm thất bại: " + e.getMessage());
				req.setAttribute("cateList", categoryDao.findAll());
				req.getRequestDispatcher("/views/product-add.jsp").forward(req, resp);
			}
			
		} else if (url.contains("update")) {
			int id = Integer.parseInt(req.getParameter("productId"));
			String name = req.getParameter("productName");
			String priceStr = req.getParameter("price");
			String quantityStr = req.getParameter("quantity");
			String description = req.getParameter("description");
			String categoryIdStr = req.getParameter("categoryId");

			ProductForm form = new ProductForm();
			form.setProductName(name);
			form.setDescription(description);

			Map<String, String> errors = new java.util.LinkedHashMap<>();
			Double price = parseDouble(priceStr, "price", errors);
			Integer quantity = parseInt(quantityStr, "quantity", errors);
			Integer categoryId = parseInt(categoryIdStr, "categoryId", errors);
			form.setPrice(price);
			form.setQuantity(quantity);
			form.setCategoryId(categoryId);

			errors.putAll(ValidationUtil.validate(form));

			if (!errors.isEmpty()) {
				req.setAttribute("fieldErrors", errors);
				req.setAttribute("product", productDao.findById(id));
				req.setAttribute("cateList", categoryDao.findAll());
				req.getRequestDispatcher("/views/product-edit.jsp").forward(req, resp);
				return;
			}

			try {
				Product product = new Product();
				product.setProductId(id);
				product.setProductName(name);
				product.setPrice(price);
				product.setQuantity(quantity);
				product.setDescription(description);
				product.setCategory(categoryDao.findById(categoryId));
				
				Product oldProduct = productDao.findById(id);
				product.setCreatedAt(oldProduct != null ? oldProduct.getCreatedAt() : null);
				
				Part part = req.getPart("images");
				if (part != null && part.getSize() > 0) {
					String originalFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
					String fileName = System.currentTimeMillis() + "_" + originalFileName;
					product.setImages(ImageStorageUtil.store(part, "products", fileName));
				} else {
					product.setImages(oldProduct != null ? oldProduct.getImages() : "");
				}
				
				productDao.update(product);
				resp.sendRedirect(req.getContextPath() + "/admin/products");
			} catch (Exception e ) {
				e.printStackTrace();
				req.setAttribute("error", "Cập nhật sản phẩm thất bại: " + e.getMessage());
				req.setAttribute("cateList", categoryDao.findAll());
				req.getRequestDispatcher("/views/product-edit.jsp").forward(req, resp);
			}
		}
	}

	// Parse an integer request param; nếu lỗi thì ghi vào map errors thay vì ném exception,
	// để trang có thể hiển thị lỗi rõ ràng thay vì crash 500.
	private Integer parseInt(String raw, String field, Map<String, String> errors) {
		if (raw == null || raw.trim().isEmpty()) {
			return null; // để @NotNull của bean validation bắt lỗi "không được để trống"
		}
		try {
			return Integer.parseInt(raw.trim());
		} catch (NumberFormatException e) {
			errors.put(field, "Giá trị không hợp lệ");
			return null;
		}
	}

	private Double parseDouble(String raw, String field, Map<String, String> errors) {
		if (raw == null || raw.trim().isEmpty()) {
			return null;
		}
		try {
			return Double.parseDouble(raw.trim());
		} catch (NumberFormatException e) {
			errors.put(field, "Giá trị không hợp lệ");
			return null;
		}
	}
	
	

}