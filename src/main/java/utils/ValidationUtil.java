package utils;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;

/**
 * Dùng chung cho toàn bộ ứng dụng để validate các *Form (DTO) bằng Jakarta Bean
 * Validation (Hibernate Validator). Controller chỉ cần gọi:
 *
 *   Map<String, String> errors = ValidationUtil.validate(form);
 *   if (!errors.isEmpty()) { ... hiển thị lỗi ... }
 *
 * Key của Map là tên field (vd "email", "password"), value là message lỗi
 * (tiếng Việt, khai báo ngay trong DTO bằng thuộc tính message = "...").
 */
public class ValidationUtil {

	private static final ValidatorFactory FACTORY = Validation.buildDefaultValidatorFactory();
	private static final Validator VALIDATOR = FACTORY.getValidator();

	private ValidationUtil() {
	}

	public static <T> Map<String, String> validate(T form) {
		Map<String, String> errors = new LinkedHashMap<>();
		Set<ConstraintViolation<T>> violations = VALIDATOR.validate(form);
		for (ConstraintViolation<T> v : violations) {
			String field = v.getPropertyPath().toString();
			// Nếu 1 field có nhiều lỗi thì chỉ giữ lại lỗi đầu tiên để UI gọn hơn
			errors.putIfAbsent(field, v.getMessage());
		}
		return errors;
	}
}