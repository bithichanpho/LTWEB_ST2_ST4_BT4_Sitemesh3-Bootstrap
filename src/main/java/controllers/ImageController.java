package controllers;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import configs.AppConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet nay truoc day KHONG TON TAI trong project (day la 1 trong nhung
 * nguyen nhan chinh khien anh san pham/danh muc khong bao gio hien thi duoc,
 * du code JSP da viet dung the <img src="${pageContext.request.contextPath}/image/...">).
 *
 * Servlet nay doc file anh tu thu muc AppConfig.ROOT_UPLOAD_DIR (nam ngoai
 * project) va tra ve cho trinh duyet khi truy cap URL: /image/<duong-dan-luu-trong-db>
 * Vi du: /image/products/1710000000000_abc.jpg
 */
@WebServlet(urlPatterns = { "/image/*" })
public class ImageController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String relativePath = req.getPathInfo(); // vi du: /products/xxx.jpg

		if (relativePath == null || relativePath.isEmpty() || relativePath.equals("/")) {
			resp.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		// Chuan hoa, bo dau "/" dau tien
		relativePath = relativePath.replaceFirst("^/", "");

		Path filePath = Paths.get(AppConfig.ROOT_UPLOAD_DIR, relativePath.split("/"));
		File file = filePath.toFile();

		// Chan path traversal (vd: ../../etc/passwd)
		String rootCanonical = new File(AppConfig.ROOT_UPLOAD_DIR).getCanonicalPath();
		String fileCanonical = file.getCanonicalPath();
		if (!fileCanonical.startsWith(rootCanonical)) {
			resp.sendError(HttpServletResponse.SC_FORBIDDEN);
			return;
		}

		if (!file.exists() || !file.isFile()) {
			resp.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		String mimeType = Files.probeContentType(filePath);
		resp.setContentType(mimeType != null ? mimeType : "application/octet-stream");
		resp.setContentLengthLong(file.length());

		Files.copy(filePath, resp.getOutputStream());
	}
}
