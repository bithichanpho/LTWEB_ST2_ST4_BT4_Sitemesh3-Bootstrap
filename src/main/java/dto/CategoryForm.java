package dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class CategoryForm {

	@NotBlank(message = "Tên danh mục không được để trống")
	@Size(max = 255, message = "Tên danh mục tối đa 255 ký tự")
	private String categoryname;

	@NotNull(message = "Vui lòng chọn trạng thái")
	private Integer status;

	public String getCategoryname() {
		return categoryname;
	}

	public void setCategoryname(String categoryname) {
		this.categoryname = categoryname;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}
}