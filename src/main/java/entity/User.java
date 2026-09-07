package entity;

import java.io.Serializable;
import java.time.LocalDateTime;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@Table(name = "users")
@NamedQuery(name = "User.findAll", query = "SELECT u FROM User u")
public class User implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "userId")
	private int userId;
	
	@Column(name = "fullname", columnDefinition = "NVARCHAR(255) NULL")
	private String fullname;
	
	@Column(name = "email", unique = true, nullable = false, columnDefinition = "NVARCHAR(255)")
	private String email;
	
	@Column(name = "password", nullable = false, columnDefinition = "NVARCHAR(255)")
	private String password;
	
	// 0 = chua kich hoat, 1 = da kich hoat
	@Column(name = "status")
	private int status;
	
	@Column(name = "otpCode", columnDefinition = "NVARCHAR(10) NULL")
	private String otpCode;
	
	@Column(name = "otpExpiry")
	private LocalDateTime otpExpiry;
	
	@Column(name = "createdAt")
	private LocalDateTime createdAt;
	
	@Column(name = "role", nullable = false)
	private String role = "user";

	@Column(name = "phone", columnDefinition = "NVARCHAR(20) NULL")
	private String phone;

	// Đường dẫn ảnh đại diện, cùng cơ chế lưu/đọc với images của Product/Category
	// (lưu dạng "users/xxx.jpg", đọc ra qua ImageController: /image/users/xxx.jpg)
	@Column(name = "avatar", columnDefinition = "NVARCHAR(255) NULL")
	private String avatar;

	

}