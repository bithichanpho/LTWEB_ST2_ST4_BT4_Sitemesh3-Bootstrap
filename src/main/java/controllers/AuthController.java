package controllers;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Map;

import dao.IUserDao;
import dao.impl.UserDao;
import dto.ForgotPasswordForm;
import dto.LoginForm;
import dto.RegisterForm;
import dto.ResetPasswordForm;
import dto.VerifyOtpForm;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.EmailUtil;
import utils.OtpUtil;
import utils.PasswordUtil;
import utils.ValidationUtil;

@WebServlet(urlPatterns = {"/register", "/verify-otp", "/resend-otp", "/login", "/logout", "/forgot-password", "/reset-password"})
public class AuthController extends HttpServlet{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private IUserDao userDao = new UserDao();
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");
		String url = req.getRequestURI();
		
		if (url.contains("register")) {
			req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
			
		} else if (url.contains("verify-otp")) {
			String email = (String) req.getSession().getAttribute("pendingEmail");
			if (email == null) {
				resp.sendRedirect(req.getContextPath() + "/register");
				return;
			}
			
			req.setAttribute("email", email);
			req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
		} else if (url.contains("login")) {
			req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
		} else if (url.contains("logout")) {
			HttpSession session = req.getSession(false);
			if (session != null) {
				session.invalidate();
			}
			resp.sendRedirect(req.getContextPath() + "/home");
		} else if (url.contains("forgot-password")) {
			req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
		} else if (url.contains("reset-password")) {
			String email = (String) req.getSession().getAttribute("resetEmail");
			if (email == null) {
				resp.sendRedirect(req.getContextPath() + "/forgot-password");
				return;
			}
			req.setAttribute("email", email);
			req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
		} else {
			resp.sendRedirect(req.getContextPath() + "/home");
		}
	}
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");
		String url = req.getRequestURI();
		
		if (url.contains("register")) {
			handleRegister(req, resp);
		} else if (url.contains("verify-otp")) {
			handleVerifyOtp(req, resp);
		} else if (url.contains("resend-otp")) {
			handleResendOtp(req, resp);
		} else if (url.contains("login")) {
			handleLogin(req, resp);
		} else if (url.contains("forgot-password")) {
			handleForgotPassword(req, resp);
		} else if (url.contains("reset-password")) {
			handleResetPassword(req, resp);
		} else {
			resp.sendRedirect(req.getContextPath() + "/login");
		}
	}

	private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String fullname = req.getParameter("fullname");
		String email = req.getParameter("email");
		String password = req.getParameter("password");
		String confirmPassword = req.getParameter("confirmPassword");

		RegisterForm form = new RegisterForm();
		form.setFullname(fullname);
		form.setEmail(email);
		form.setPassword(password);
		form.setConfirmPassword(confirmPassword);

		Map<String, String> errors = ValidationUtil.validate(form);
		if (password != null && confirmPassword != null && !password.equals(confirmPassword)) {
			errors.put("confirmPassword", "Mật khẩu không khớp");
		}

		if (!errors.isEmpty()) {
			req.setAttribute("fieldErrors", errors);
			req.setAttribute("fullname", fullname);
			req.setAttribute("email", email);
			req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
			return;
		}
		
		User existing = userDao.findByEmail(email);
		String otp = OtpUtil.generateOtp();
		LocalDateTime expiry = LocalDateTime.now().plusMinutes(OtpUtil.OTP_EXPIRE_MINUTES);
		
		try {
			if (existing != null) {
				if (existing.getStatus() == 1) {
					req.setAttribute("error", "Email đã được đăng ký. Vui lòng chọn email khác");
					req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
					return;
					
				}
				
				existing.setFullname(fullname);
				existing.setPassword(PasswordUtil.hashPassword(password));
				existing.setOtpCode(otp);
				existing.setOtpExpiry(expiry);
				userDao.update(existing);
			} else {
				User user = new User();
				user.setFullname(fullname);
				user.setEmail(email);
				user.setPassword(PasswordUtil.hashPassword(password));
				user.setStatus(0);
				user.setOtpCode(otp);
				user.setOtpExpiry(expiry);
				user.setCreatedAt(LocalDateTime.now());
				userDao.insert(user);
			}
			
			EmailUtil.sendOtpEmail(email, otp, "register");
			req.getSession().setAttribute("pendingEmail", email);
			resp.sendRedirect(req.getContextPath() + "/verify-otp");
		} catch (Exception e) {
			e.printStackTrace();
			req.setAttribute("error", "Đăng ký thất bại: " + e.getMessage());
			req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
		}
	}

	private void handleVerifyOtp(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String email = (String) req.getSession().getAttribute("pendingEmail");
		String otpInput = req.getParameter("otp");
		
		if (email == null) {
			resp.sendRedirect(req.getContextPath() + "/register");
			return;
			
		}

		VerifyOtpForm form = new VerifyOtpForm();
		form.setOtp(otpInput);
		Map<String, String> errors = ValidationUtil.validate(form);
		if (!errors.isEmpty()) {
			req.setAttribute("error", errors.values().iterator().next());
			req.setAttribute("email", email);
			req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
			return;
		}
		
		User user = userDao.findByEmail(email);
		if (user != null && user.getOtpCode() != null 
			&& user.getOtpCode().equals(otpInput)
			&& user.getOtpExpiry().isAfter(LocalDateTime.now())) {
			user.setStatus(1);
			user.setOtpCode(null);
			user.setOtpExpiry(null);
			userDao.update(user);
			
			req.getSession().removeAttribute("pendingEmail");
			req.setAttribute("message", "Kích hoạt tài khoản thành công. Vui lòng đăng nhập lại");
			req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
		} else {
			req.setAttribute("message", "Mã OTP không đúng hoặc đã hết hạn. Vui lòng thửu lại hoặc gửi lại mã");
			req.setAttribute("email", email);
			req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
		}
	}
	
	private void handleResendOtp(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String email = (String) req.getSession().getAttribute("pendingEmail");
		if (email == null) {
			resp.sendRedirect(req.getContextPath() + "/register");
			return;
		}
		User user = userDao.findByEmail(email);
		if (user != null && user.getStatus() == 0) {
			String otp = OtpUtil.generateOtp();
			user.setOtpCode(otp);
			user.setOtpExpiry(LocalDateTime.now().plusMinutes(OtpUtil.OTP_EXPIRE_MINUTES));
			userDao.update(user);
			EmailUtil.sendOtpEmail(email, otp, "register");
			req.setAttribute("message", "Đã gửi lại mã OTP, vui lòng kiểm tra email của bạn");
		}
		req.setAttribute("email", email);
		req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
		
	}
	
	private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String email = req.getParameter("email");
		String password = req.getParameter("password");

		LoginForm form = new LoginForm();
		form.setEmail(email);
		form.setPassword(password);
		Map<String, String> errors = ValidationUtil.validate(form);
		if (!errors.isEmpty()) {
			req.setAttribute("fieldErrors", errors);
			req.setAttribute("email", email);
			req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
			return;
		}
		
		User user = userDao.findByEmail(email);
		if (user == null || !PasswordUtil.checkPassword(password, user.getPassword())) {
			req.setAttribute("error", "Email hoặc mật khẩu không đúng");
			req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
			return;
		}
		
		if (user.getStatus() == 0) {
			req.setAttribute("error", "Tài khoản chưa được kích hoạt. Kiểm tra email để xác thực OTP");
			req.getSession().setAttribute("pendingEmail", email);
			req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
			return;
		}
		
		HttpSession session = req.getSession();
		session.setAttribute("currentUser", user);
		resp.sendRedirect(req.getContextPath() + "/home");
	}
	
	private void handleForgotPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String email = req.getParameter("email");

		ForgotPasswordForm form = new ForgotPasswordForm();
		form.setEmail(email);
		Map<String, String> errors = ValidationUtil.validate(form);
		if (!errors.isEmpty()) {
			req.setAttribute("fieldErrors", errors);
			req.setAttribute("email", email);
			req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
			return;
		}

		User user = userDao.findByEmail(email);
		
		if (user == null) {
			req.setAttribute("error", "Email không tồn tại");
			req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
			return;
		}
		
		String otp = OtpUtil.generateOtp();
		user.setOtpCode(otp);
		user.setOtpExpiry(LocalDateTime.now().plusMinutes(OtpUtil.OTP_EXPIRE_MINUTES));
		userDao.update(user);
		
		EmailUtil.sendOtpEmail(email, otp, "reset");
		req.getSession().setAttribute("resetEmail", email);
		resp.sendRedirect(req.getContextPath() + "/reset-password");
	}
	
	
	private void handleResetPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String email = (String) req.getSession().getAttribute("resetEmail");
		if (email == null) {
			resp.sendRedirect(req.getContextPath() + "/forgot-password");
			return;
		}
		
		String otpInput = req.getParameter("otp");
		String newPassword = req.getParameter("newPassword");
		String confirmPassword = req.getParameter("confirmPassword");

		ResetPasswordForm form = new ResetPasswordForm();
		form.setOtp(otpInput);
		form.setNewPassword(newPassword);
		form.setConfirmPassword(confirmPassword);

		Map<String, String> errors = ValidationUtil.validate(form);
		if (newPassword != null && confirmPassword != null && !newPassword.equals(confirmPassword)) {
			errors.put("confirmPassword", "Mật khẩu không khớp");
		}

		if (!errors.isEmpty()) {
			req.setAttribute("fieldErrors", errors);
			req.setAttribute("email", email);
			req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
			return;
		}
		
		User user = userDao.findByEmail(email);
		if (user != null 
				&& user.getOtpCode() != null && user.getOtpCode().equals(otpInput) 
				&& user.getOtpExpiry() != null && user.getOtpExpiry().isAfter(LocalDateTime.now())) {
			user.setPassword(PasswordUtil.hashPassword(newPassword));
			user.setOtpCode(null);
			user.setOtpExpiry(null);
			userDao.update(user);
			
			req.getSession().removeAttribute("resetEmail");
			req.setAttribute("message", "Đặt lại mật khẩu thành công. Vui lòng đăng nhập lại");
			req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
		} else {
			req.setAttribute("error", "Mã OTP không đúng hoặc đã hết hạn");
			req.setAttribute("email", email);
			req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
		}
	}
	
	
	
}