package controllers;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

import configs.AppConfig;
import dao.ICategoryDao;
import dao.IProductDao;
import dao.impl.CategoryDao;
import dao.impl.ProductDao;
import entity.Category;
import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxRequestSize = 1024 * 1024 * 5 * 5)
@WebServlet(urlPatterns = {"/admin/products", "/admin/product/add", "/admin/product/insert", "/admin/product/edit", "/admin/product/update", "/admin/product/delete", "/admin/product/check"})
public class ProductAdminController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
	private IProductDao productDao = new ProductDao();
	private ICategoryDao categoryDao = new CategoryDao();
	
	// Dùng chung 1 nơi cấu hình thư mục upload với ImageController/CategoryController
	// (configs.AppConfig) để ảnh lưu vào và ảnh đọc ra luôn khớp nhau.
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
		
		String uploadPath = ROOT_DIR + File.separator + "products";
		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists()) uploadDir.mkdirs();
		
		if (url.contains("insert")) {
			try {
				String name = req.getParameter("productName");
				Product existingProduct = productDao.findByName(name);
				if (existingProduct != null) {
				    req.setAttribute("error", "Tên sản phẩm đã tồn tại! Vui lòng nhập tên khác.");
				    req.setAttribute("cateList", categoryDao.findAll());
				    req.getRequestDispatcher("/views/product-add.jsp").forward(req, resp);
				    return; // Dừng lại, không cho thêm vào DB
				}
				double price = Double.parseDouble(req.getParameter("price"));
				int quantity = Integer.parseInt(req.getParameter("quantity"));
				String description = req.getParameter("description");
				int categoryId = Integer.parseInt(req.getParameter("categoryId"));
				
				String dbImageValue = "";
				Part part = req.getPart("images");
				if (part != null && part.getSize() > 0) {
					String originalFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
					String fileName = System.currentTimeMillis() + "_" + originalFileName;
					Path path = Paths.get(uploadPath, fileName);
					try (InputStream inputStream = part.getInputStream()) {
						Files.copy(inputStream, path, StandardCopyOption.REPLACE_EXISTING);
					}
					dbImageValue = "products/" + fileName; 
 				}
				
				Category category = categoryDao.findById(categoryId);
				
				Product product = new Product();
				product.setProductName(name);
				product.setPrice(price);
				product.setQuantity(quantity);
				product.setDescription(description);
				product.setImages(dbImageValue);
				product.setCategory(category);
				
				productDao.insert(product);
				resp.sendRedirect(req.getContextPath() + "/admin/products");
				
			} catch (Exception e) {
				e.printStackTrace();
				req.setAttribute("error", "Thêm sản phẩm thất bại: " + e.getMessage());
				req.setAttribute("cateList", categoryDao.findAll());
				req.getRequestDispatcher("/views/product-add.jsp").forward(req, resp);
			}
			
		} else if (url.contains("update")) {
			try {
				int id = Integer.parseInt(req.getParameter("productId"));
				String name = req.getParameter("productName");
				double price = Double.parseDouble(req.getParameter("price"));
				int quantity = Integer.parseInt(req.getParameter("quantity"));
				String description = req.getParameter("description");
				int categoryId = Integer.parseInt(req.getParameter("categoryId"));
				
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
					Path path = Paths.get(uploadPath, fileName);
					try (InputStream inputStream = part.getInputStream()) {
						Files.copy(inputStream, path, StandardCopyOption.REPLACE_EXISTING);
					}
					product.setImages("products/" + fileName);
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
	
	
	

}
