package dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class ResetPasswordForm {

	@NotBlank(message = "Vui lòng nhập mã OTP")
	@Pattern(regexp = "\\d{6}", message = "Mã OTP gồm đúng 6 chữ số")
	private String otp;

	@NotBlank(message = "Mật khẩu mới không được để trống")
	@Size(min = 6, max = 255, message = "Mật khẩu phải có ít nhất 6 ký tự")
	private String newPassword;

	@NotBlank(message = "Vui lòng nhập lại mật khẩu mới")
	private String confirmPassword;

	public String getOtp() {
		return otp;
	}

	public void setOtp(String otp) {
		this.otp = otp;
	}

	public String getNewPassword() {
		return newPassword;
	}

	public void setNewPassword(String newPassword) {
		this.newPassword = newPassword;
	}

	public String getConfirmPassword() {
		return confirmPassword;
	}

	public void setConfirmPassword(String confirmPassword) {
		this.confirmPassword = confirmPassword;
	}
}