package entity;

import java.io.Serializable;
import java.time.LocalDateTime;

import jakarta.persistence.*;

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
	
	public User() {
		super();
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getFullname() {
		return fullname;
	}

	public void setFullname(String fullname) {
		this.fullname = fullname;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public String getOtpCode() {
		return otpCode;
	}

	public void setOtpCode(String otpCode) {
		this.otpCode = otpCode;
	}

	public LocalDateTime getOtpExpiry() {
		return otpExpiry;
	}

	public void setOtpExpiry(LocalDateTime otpExpiry) {
		this.otpExpiry = otpExpiry;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	
	
	
	
}
