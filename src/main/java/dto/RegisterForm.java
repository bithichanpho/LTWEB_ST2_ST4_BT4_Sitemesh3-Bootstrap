package dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class RegisterForm {

	@NotBlank(message = "Họ tên không được để trống")
	@Size(min = 2, max = 255, message = "Họ tên phải có từ 2 đến 255 ký tự")
	private String fullname;

	@NotBlank(message = "Email không được để trống")
	@Email(message = "Email không đúng định dạng")
	private String email;

	@NotBlank(message = "Mật khẩu không được để trống")
	@Size(min = 6, max = 255, message = "Mật khẩu phải có ít nhất 6 ký tự")
	private String password;

	@NotBlank(message = "Vui lòng nhập lại mật khẩu")
	private String confirmPassword;

	public String getFullname() {
		return fullname;
	}

	public void setFullname(String fullname) {
		this.fullname = fullname;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getConfirmPassword() {
		return confirmPassword;
	}

	public void setConfirmPassword(String confirmPassword) {
		this.confirmPassword = confirmPassword;
	}
}