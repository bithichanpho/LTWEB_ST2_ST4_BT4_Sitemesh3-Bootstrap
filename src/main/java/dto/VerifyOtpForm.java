package dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public class VerifyOtpForm {

	@NotBlank(message = "Vui lòng nhập mã OTP")
	@Pattern(regexp = "\\d{6}", message = "Mã OTP gồm đúng 6 chữ số")
	private String otp;

	public String getOtp() {
		return otp;
	}

	public void setOtp(String otp) {
		this.otp = otp;
	}
}