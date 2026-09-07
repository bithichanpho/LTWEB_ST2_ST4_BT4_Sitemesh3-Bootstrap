package controllers;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Map;

import configs.AppConfig;
import dao.IUserDao;
import dao.impl.UserDao;
import dto.ProfileForm;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import utils.ValidationUtil;

/**
 * Chức năng Profile của User: cho phép người dùng đã đăng nhập cập nhật
 * fullname, phone và ảnh đại diện (avatar). Dùng JPA (qua IUserDao/UserDao)
 * để đọc/ghi CSDL, giao diện được quản lý bởi Sitemesh (trang JSP nội dung
 * thuần, không tự vẽ layout/navbar - decorator /WEB-INF/decorators/main.jsp
 * lo phần đó).
 *
 * Quy ước lưu/đọc ảnh giống hệt Product/Category: file được lưu vào
 * {ROOT_UPLOAD_DIR}/users/xxx.jpg, giá trị lưu trong DB là "users/xxx.jpg",
 * và được đọc ra qua ImageController: /image/users/xxx.jpg
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5 * 5)
@WebServlet(urlPatterns = { "/profile", "/profile/update" })
public class ProfileController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private IUserDao userDao = new UserDao();

	// Thư mục cố định để lưu avatar của User (giống cách CategoryController dùng CATEGORY_IMG_FOLDER)
	private static final String AVATAR_FOLDER = "users";

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");

		User currentUser = getCurrentUser(req);
		if (currentUser == null) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}

		// Lấy lại bản mới nhất từ DB (tránh hiển thị dữ liệu cũ nếu session đã lệch)
		User freshUser = userDao.findById(currentUser.getUserId());
		req.setAttribute("profileUser", freshUser != null ? freshUser : currentUser);
		req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");

		User currentUser = getCurrentUser(req);
		if (currentUser == null) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}

		String url = req.getRequestURI();
		if (!url.contains("update")) {
			resp.sendRedirect(req.getContextPath() + "/profile");
			return;
		}

		String fullname = req.getParameter("fullname");
		String phone = req.getParameter("phone");

		ProfileForm form = new ProfileForm();
		form.setFullname(fullname);
		form.setPhone(phone);

		Map<String, String> errors = ValidationUtil.validate(form);

		// Lấy bản ghi mới nhất từ DB để không mất dữ liệu các field khác (email, password, role, ...)
		User user = userDao.findById(currentUser.getUserId());
		if (user == null) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}

		if (!errors.isEmpty()) {
			req.setAttribute("fieldErrors", errors);
			// Giữ lại avatar hiện tại, chỉ hiển thị lại giá trị vừa nhập để user không phải gõ lại
			user.setFullname(fullname);
			user.setPhone(phone);
			req.setAttribute("profileUser", user);
			req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
			return;
		}

		try {
			String uploadPath = req.getServletContext().getRealPath(AppConfig.ROOT_UPLOAD_DIR + "/" + AVATAR_FOLDER);
			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists()) uploadDir.mkdirs();

			Part part = req.getPart("avatar");
			if (part != null && part.getSize() > 0) {
				String originalFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
				String fileName = System.currentTimeMillis() + "_" + originalFileName;
				Path path = Paths.get(uploadPath, fileName);
				try (InputStream inputStream = part.getInputStream()) {
					Files.copy(inputStream, path, StandardCopyOption.REPLACE_EXISTING);
				}
				user.setAvatar(AVATAR_FOLDER + "/" + fileName);
			}
			// Nếu không chọn ảnh mới thì giữ nguyên avatar cũ (user.getAvatar() đã có sẵn từ findById)

			user.setFullname(fullname);
			user.setPhone(phone);

			userDao.update(user);

			// Đồng bộ lại session để navbar/các trang khác hiển thị đúng ngay lập tức
			HttpSession session = req.getSession();
			session.setAttribute("currentUser", user);

			req.setAttribute("message", "Cập nhật hồ sơ thành công");
			req.setAttribute("profileUser", user);
			req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
		} catch (Exception e) {
			e.printStackTrace();
			req.setAttribute("error", "Cập nhật hồ sơ thất bại: " + e.getMessage());
			req.setAttribute("profileUser", user);
			req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
		}
	}

	private User getCurrentUser(HttpServletRequest req) {
		HttpSession session = req.getSession(false);
		return session != null ? (User) session.getAttribute("currentUser") : null;
	}
}
