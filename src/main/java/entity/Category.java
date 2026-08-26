package entity;

import java.io.Serializable;

import jakarta.persistence.Table;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
@Table(name = "categories")
@NamedQuery(name = "Category.findAll", query = "SELECT c FROM Category c")

public class Category implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "categoryId")
	private int categoryId;

	@Column(name = "categoryname", columnDefinition = "NVARCHAR(255) NULL")
	private String categoryname;

	@Column(name = "images", columnDefinition = "NVARCHAR(255) NULL")
	private String images;

	@Column(name = "status")
	private int status;

	public Category() {
		super();
	}

	public Category(int categoryId, String categoryname, String images, int status) {
		super();
		this.categoryId = categoryId;
		this.categoryname = categoryname;
		this.images = images;
		this.status = status;
	}

	public int getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(int categoryId) {
		this.categoryId = categoryId;
	}

	public String getCategoryname() {
		return categoryname;
	}

	public void setCategoryname(String categoryname) {
		this.categoryname = categoryname;
	}

	public String getImages() {
		return images;
	}

	public void setImages(String images) {
		this.images = images;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	@Override
	public String toString() {
		return "Category [categoryId=" + categoryId + ", categoryname=" + categoryname + ", images=" + images
				+ ", status=" + status + "]";
	}

}
