package filters;

import java.io.IOException;

import entity.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(urlPatterns = {"/admin/*"})
public class AuthFilter implements Filter {

	@Override
	public void doFilter(ServletRequest request, ServletResponse respone, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse resp = (HttpServletResponse) respone;

		HttpSession session = req.getSession(false);
		User currentUser = session != null ? (User) session.getAttribute("currentUser") : null;

		// Không chỉ cần đăng nhập, mà còn phải đúng role admin mới vào được /admin/*
		if (currentUser == null) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		if (!"admin".equals(currentUser.getRole())) {
			resp.sendRedirect(req.getContextPath() + "/home");
			return;
		}

		chain.doFilter(request, respone);
	}
}