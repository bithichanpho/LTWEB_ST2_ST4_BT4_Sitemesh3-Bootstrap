package controllers;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = "/image/*")
public class ImageController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	// CỰC KỲ QUAN TRỌNG: Bạn hãy click vào thanh địa chỉ của thư mục 'img' trên máy bạn, 
	// copy toàn bộ đường dẫn và dán vào đây (nhớ dùng 2 dấu gạch chéo \\)
	private final String ROOT_DIR = "C:\\Users\\trant\\Documents\\WEB\\upload\\img"; 

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// pathInfo sẽ lấy phần phía sau chữ /image (Ví dụ: /female/ao-thun.jpg)
		String pathInfo = req.getPathInfo(); 

		if (pathInfo == null || pathInfo.equals("/")) {
			resp.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		// Đường dẫn thực tế trỏ tới file trong máy tính
		File file = new File(ROOT_DIR + pathInfo);

		if (file.exists()) {
			// Set kiểu dữ liệu trả về là hình ảnh
			resp.setContentType(getServletContext().getMimeType(file.getName()));
			resp.setContentLength((int) file.length());
			
			// Đọc file và xuất ra trình duyệt
			try (FileInputStream in = new FileInputStream(file);
				 OutputStream out = resp.getOutputStream()) {
				byte[] buffer = new byte[4096];
				int bytesRead;
				while ((bytesRead = in.read(buffer)) != -1) {
					out.write(buffer, 0, bytesRead);
				}
			}
		} else {
			resp.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}
}