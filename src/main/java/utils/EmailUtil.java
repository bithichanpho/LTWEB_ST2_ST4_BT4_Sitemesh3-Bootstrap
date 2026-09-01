package utils;

import java.io.UnsupportedEncodingException;
import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtil {
	private static final String FROM_EMAIL = "tranthiphuongtrang2711@gmail.com";
	private static final String APP_PASSWORD = "iyqh vojp vaic szfn";
	private static final String FROM_NAME = "crud_catgory";
	
	private static Session getSession() {
		Properties props = new Properties();
		
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		
		return Session.getInstance(props, new Authenticator() {

			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
			}
			
		});
	}
	
	public static void sendOtpEmail(String toEmail, String otp, String purpose) {
		try {
			Session session = getSession();
			MimeMessage message = new MimeMessage(session);
			message.setFrom(new InternetAddress(FROM_EMAIL, FROM_NAME, "UTF-8"));
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
			
			String subject = "register".equals(purpose) ? "Xác thực tài khoản - Mã OTP của bạn" : "Đặt lại mật khẩu - Mã OTP của bạn";
			message.setSubject(subject, "UTF-8");
			
			
			String content = "<div style='font-family:Arial,sans-serif;max-width:480px'>"
					+ "<h2 style='color:#333'>" + subject + "</h2>"
					+ "<p>Xin chào,</p>"
					+ "<p>Mã OTP của bạn là:</p>"
					+ "<div style='font-size:28px;font-weight:bold;color:#4CAF50;letter-spacing:6px;"
					+ "background:#f4f4f4;padding:12px 20px;display:inline-block;border-radius:6px'>"
					+ otp + "</div>"
					+ "<p style='margin-top:16px'>Mã có hiệu lực trong <b>" + OtpUtil.OTP_EXPIRE_MINUTES
					+ " phut</b>. Vui lòng không chia sẻ mã này cho bất kì ai.</p>"
					+ "<p style='color:gray;font-size:12px'>Nếu bạn không yêu cầu, vui lòng bỏ qua email này.</p>"
					+ "</div>";
			message.setContent(content, "text/html; charset=UTF-8"); 
			
			Transport.send(message);
		 } catch (MessagingException | UnsupportedEncodingException e) {
			 e.printStackTrace();
			 throw new RuntimeException("Không thể gửi OTP: " + e.getMessage(), e);
			
		}
	}
}
