package controllers;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

import dao.ICategoryDao;
import dao.impl.CategoryDao;
import entity.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5 * 5)
@WebServlet(urlPatterns = { "/categories", "/category/add", "/category/insert", "/category/edit", "/category/update", "/category/delete" })
public class CategoryController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private ICategoryDao categoryDao = new CategoryDao();

	// Cấu hình thư mục gốc lưu ảnh theo đúng máy tính của bạn
	private final String ROOT_DIR = "C:\\Users\\trant\\Documents\\WEB\\upload\\img";

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");

		String url = req.getRequestURI();

		// [READ] Lấy danh sách và hiển thị
		if (url.contains("categories")) {
			List<Category> list = categoryDao.findAll();
			req.setAttribute("cateList", list);
			req.getRequestDispatcher("/views/category-list.jsp").forward(req, resp);
			
		// [CREATE] Mở form thêm mới
		} else if (url.contains("category/add")) {
			req.getRequestDispatcher("/views/category-add.jsp").forward(req, resp);
			
		// [UPDATE] Mở form chỉnh sửa
		} else if (url.contains("category/edit")) {
			int id = Integer.parseInt(req.getParameter("id"));
			Category category = categoryDao.findById(id);
			req.setAttribute("cate", category);
			req.getRequestDispatcher("/views/category-edit.jsp").forward(req, resp);
			
		// [DELETE] Xóa dữ liệu
		} else if (url.contains("category/delete")) {
			int id = Integer.parseInt(req.getParameter("id"));
			try {
				categoryDao.delete(id);
			} catch (Exception e) {
				e.printStackTrace();
			}
			resp.sendRedirect(req.getContextPath() + "/categories");
			
		// Nếu truy cập sai link xử lý POST -> Điều hướng về danh sách an toàn
		} else {
			resp.sendRedirect(req.getContextPath() + "/categories");
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");
		String url = req.getRequestURI();

		// Lấy tên thư mục con (female, male, accesories)
		String folderName = req.getParameter("folderName");
		if (folderName == null || folderName.trim().isEmpty()) {
			folderName = "default";
		}

		// Tạo thư mục con nếu chưa tồn tại
		String uploadPath = ROOT_DIR + File.separator + folderName;
		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists()) uploadDir.mkdirs();

		if (url.contains("insert")) {
			String name = req.getParameter("categoryname");
			int status = Integer.parseInt(req.getParameter("status"));
			String dbImageValue = "";

			// Xử lý upload ảnh
			Part part = req.getPart("images");
			if (part != null && part.getSize() > 0) {
				String originalFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
				// Thêm timestamp vào trước tên file để tránh lỗi trùng lặp/khóa file
				String fileName = System.currentTimeMillis() + "_" + originalFileName;
				
				// SỬ DỤNG JAVA NIO ĐỂ LƯU FILE
				Path path = Paths.get(uploadPath, fileName);
				try (InputStream inputStream = part.getInputStream()) {
				    Files.copy(inputStream, path, StandardCopyOption.REPLACE_EXISTING);
				}
				
				dbImageValue = folderName + "/" + fileName; 
			}

			Category category = new Category();
			category.setCategoryname(name);
			category.setImages(dbImageValue);
			category.setStatus(status);

			categoryDao.insert(category);
			resp.sendRedirect(req.getContextPath() + "/categories");
			
		} else if (url.contains("update")) {
			int id = Integer.parseInt(req.getParameter("categoryId"));
			String name = req.getParameter("categoryname");
			int status = Integer.parseInt(req.getParameter("status"));

			Category category = new Category();
			category.setCategoryId(id);
			category.setCategoryname(name);
			category.setStatus(status);

			// Xử lý upload ảnh khi cập nhật
			Part part = req.getPart("images");
			if (part != null && part.getSize() > 0) {
				String originalFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
				// Thêm timestamp vào trước tên file để tránh lỗi trùng lặp/khóa file
				String fileName = System.currentTimeMillis() + "_" + originalFileName;
				
				// SỬ DỤNG JAVA NIO ĐỂ LƯU FILE
				Path path = Paths.get(uploadPath, fileName);
				try (InputStream inputStream = part.getInputStream()) {
				    Files.copy(inputStream, path, StandardCopyOption.REPLACE_EXISTING);
				}
				
				category.setImages(folderName + "/" + fileName);
			} else {
				Category oldCate = categoryDao.findById(id);
				category.setImages(oldCate.getImages());
			}

			categoryDao.update(category);
			resp.sendRedirect(req.getContextPath() + "/categories");
		}
	}
}