package utils;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;

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