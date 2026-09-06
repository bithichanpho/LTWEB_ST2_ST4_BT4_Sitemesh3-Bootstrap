package entity;

import java.io.Serializable;
import java.time.LocalDateTime;

import jakarta.persistence.*;

@Entity
@Table(name = "products")
@NamedQuery(name = "Product.findAll", query = "SELECT p FROM Product p ORDER BY p.productId DESC")
@NamedQuery(name = "Product.findLatest", query = "SELECT p FROM Product p ORDER BY p.createdAt DESC")
@NamedQuery(name = "Product.countAll", query = "SELECT COUNT(p) FROM Product p")

public class Product implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "productId")
	private int productId;
	
	@Column(name = "productName", columnDefinition = "NVARCHAR(255) NULL")
	private String productName;
	
	@Column(name = "price")
	private double price;

	@Column(name = "description", columnDefinition = "NVARCHAR(MAX) NULL")
	private String description;
	
	@Column(name = "images", columnDefinition = "NVARCHAR(255) NULL")
	private String images;
	
	@Column(name = "quantity")
	private int quantity;
	
	// Số lượng sản phẩm đã bán được. Dùng để tính doanh thu (sold * price) cho Dashboard thống kê.
	// columnDefinition đặt NOT NULL DEFAULT 0 để khi Hibernate tự ALTER TABLE thêm cột này
	// vào các bản ghi Product đã tồn tại từ trước, cột sẽ được điền sẵn giá trị 0 thay vì NULL
	// (nếu để NULL, việc map NULL vào kiểu int primitive sẽ làm crash ứng dụng khi đọc dữ liệu).
	@Column(name = "sold", columnDefinition = "INT NOT NULL DEFAULT 0")
	private int sold;
	
	@Column(name = "createdAt")
	private LocalDateTime createdAt;

	
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "categoryId", nullable = false)
	private Category category;

	public Product() {
		super();
	}
	
	@PrePersist
	protected void onCreate() {
		if (this.createdAt == null) {
			this.createdAt = LocalDateTime.now();
		}
	}

	public Product(int productId, String productName, double price, String images, LocalDateTime createdAt,
			Category category) {
		super();
		this.productId = productId;
		this.productName = productName;
		this.price = price;
		this.images = images;
		this.createdAt = createdAt;
		this.category = category;
	}

	public int getProductId() {
		return productId;
	}

	public void setProductId(int productId) {
		this.productId = productId;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getImages() {
		return images;
	}

	public void setImages(String images) {
		this.images = images;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public int getSold() {
		return sold;
	}

	public void setSold(int sold) {
		this.sold = sold;
	}

	
	@Transient
	public double getRevenue() {
		return sold * price;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public Category getCategory() {
		return category;
	}

	public void setCategory(Category category) {
		this.category = category;
	}
	
	
	


	
}
