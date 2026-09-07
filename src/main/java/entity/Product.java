package entity;

import java.io.Serializable;
import java.time.LocalDateTime;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "products")
@NamedQuery(name = "Product.findAll", query = "SELECT p FROM Product p ORDER BY p.productId DESC")
@NamedQuery(name = "Product.findLatest", query = "SELECT p FROM Product p ORDER BY p.createdAt DESC")
@NamedQuery(name = "Product.countAll", query = "SELECT COUNT(p) FROM Product p")

@AllArgsConstructor
@NoArgsConstructor
@Data
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

	
	@Transient
	public double getRevenue() {
		return sold * price;
	}

}
