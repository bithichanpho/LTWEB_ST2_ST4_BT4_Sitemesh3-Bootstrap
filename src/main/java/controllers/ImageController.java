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


@WebServlet(urlPatterns = { "/image/*" })
public class ImageController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String relativePath = req.getPathInfo(); 

		if (relativePath == null || relativePath.isEmpty() || relativePath.equals("/")) {
			resp.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		// Chuan hoa, bo dau "/" dau tien
		relativePath = relativePath.replaceFirst("^/", "");

		String realRootDir = req.getServletContext().getRealPath(AppConfig.ROOT_UPLOAD_DIR);

		Path filePath = Paths.get(realRootDir, relativePath.split("/"));
		File file = filePath.toFile();

		// Chan path traversal (vd: ../../etc/passwd)
		String rootCanonical = new File(realRootDir).getCanonicalPath();
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