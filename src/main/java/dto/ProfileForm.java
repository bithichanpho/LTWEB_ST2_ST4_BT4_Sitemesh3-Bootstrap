package dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class ProfileForm {

	@NotBlank(message = "Họ tên không được để trống")
	@Size(min = 2, max = 255, message = "Họ tên phải có từ 2 đến 255 ký tự")
	private String fullname;

	// Cho phép để trống, nhưng nếu nhập thì phải là số điện thoại VN hợp lệ (10-11 số, bắt đầu bằng 0)
	@Pattern(regexp = "^$|^0\\d{9,10}$", message = "Số điện thoại không hợp lệ (VD: 0912345678)")
	private String phone;

	public String getFullname() {
		return fullname;
	}

	public void setFullname(String fullname) {
		this.fullname = fullname;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}
}