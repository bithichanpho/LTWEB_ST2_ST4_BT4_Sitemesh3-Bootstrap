package utils;

import java.security.SecureRandom;

public class OtpUtil {
	private static final SecureRandom RANDOM = new SecureRandom();
	
	public static String generateOtp() {
		int otp = 100000 + RANDOM.nextInt(900000);
		return String.valueOf(otp);
	}
	
	public static final int OTP_EXPIRE_MINUTES = 5;
}
