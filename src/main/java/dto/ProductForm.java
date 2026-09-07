package dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class ProductForm {

	@NotBlank(message = "Tên sản phẩm không được để trống")
	@Size(max = 255, message = "Tên sản phẩm tối đa 255 ký tự")
	private String productName;

	@NotNull(message = "Giá sản phẩm không được để trống")
	@DecimalMin(value = "0", inclusive = true, message = "Giá sản phẩm phải >= 0")
	private Double price;

	@NotNull(message = "Số lượng không được để trống")
	@Min(value = 0, message = "Số lượng phải >= 0")
	private Integer quantity;

	@Size(max = 4000, message = "Mô tả tối đa 4000 ký tự")
	private String description;

	@NotNull(message = "Vui lòng chọn danh mục")
	@Min(value = 1, message = "Vui lòng chọn danh mục")
	private Integer categoryId;

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public Double getPrice() {
		return price;
	}

	public void setPrice(Double price) {
		this.price = price;
	}

	public Integer getQuantity() {
		return quantity;
	}

	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Integer getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(Integer categoryId) {
		this.categoryId = categoryId;
	}
}