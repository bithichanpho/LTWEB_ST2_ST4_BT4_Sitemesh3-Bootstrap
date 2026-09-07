# BaiTap04JSP/Servlet + JPA/Hibernate + Sitemesh 3 + Bootstrap


## Cấu hình kết nối Database (Persistence)

File: `src/main/resources/META-INF/persistence.xml`

```xml
<persistence-unit name="jpa-hibernate-sqlserver">
    <class>entity.Category</class>
    <class>entity.Product</class>
    <class>entity.User</class>

    <property name="jakarta.persistence.jdbc.url"
        value="jdbc:sqlserver://localhost:1433;databaseName=jakartaJPASample;encrypt=false;trustServerCertificate=true" />
    <property name="jakarta.persistence.jdbc.driver"
        value="com.microsoft.sqlserver.jdbc.SQLServerDriver" />
    <property name="jakarta.persistence.jdbc.user" value="sa" />
    <property name="jakarta.persistence.jdbc.password" value="123" />

    <property name="hibernate.show_sql" value="true" />
    <property name="hibernate.format_sql" value="true" />
    <property name="hibernate.hbm2ddl.auto" value="update" />
    <property name="hibernate.dialect" value="org.hibernate.dialect.SQLServerDialect" />
</persistence-unit>
```

**Lưu ý khi chạy trên máy khác:**
- Đảm bảo SQL Server đang chạy ở `localhost:1433` (hoặc sửa lại `url` cho đúng host/port của bạn).
- Sửa `jakarta.persistence.jdbc.user` / `jakarta.persistence.jdbc.password` khớp với tài
  khoản SQL Server thực tế của bạn.
- Đường dẫn lưu ảnh upload (không thuộc `persistence.xml`) được cấu hình riêng tại
  `src/main/java/configs/AppConfig.java` (`ROOT_UPLOAD_DIR = "/image"`).


## Tài khoản đăng nhập để test

Toàn bộ chức năng **thêm / sửa / xóa** (Category, Product) chỉ hoạt động khi đăng nhập
bằng tài khoản có `role = "admin"` trong bảng `users`. Hệ thống đã cấu hình sẵn một tài
khoản admin dùng để test:

- **Email:** `tranthiphuongtrang2711@gmail.com`
- **Mật khẩu:** `123456`

**Nếu không đăng nhập:** trang web chỉ cho phép **xem** dữ liệu (trang chủ, danh sách/chi
tiết sản phẩm, danh sách/chi tiết danh mục) với vai trò **user** thông thường.

**Sau khi đăng nhập (user thường hoặc admin):** có thể vào mục **"Hồ sơ"** trên navbar để
cập nhật họ tên, số điện thoại, ảnh đại diện.

## Sitemesh Decorator 3 + Template Bootstrap
 
- **Nguồn Template Bootstrap sử dụng:** [Start Bootstrap - Agency](https://startbootstrap.com/theme/agency)
 
| Từ Agency | Áp dụng vào project |
|---|---|
| `css/styles.css` | Nạp vào `<head>` của decorator `WEB-INF/decorators/main.jsp` → áp dụng cho **toàn bộ trang** trong site |
| `js/scripts.js` | Nạp ở cuối `<body>` trong decorator |
| Favicon gốc của theme | `<link rel="icon">` trong decorator |
| Bố cục & class `footer | Viết lại phần `<footer>` |



- Cấu hình mapping: `src/main/webapp/WEB-INF/sitemesh3.xml`
  - `<mapping path="/*" decorator="/WEB-INF/decorators/main.jsp" />` - áp dụng decorator
    dùng chung cho toàn bộ ứng dụng.
    
- Decorator: `src/main/webapp/WEB-INF/decorators/main.jsp` - dùng Template
  **Start Bootstrap - Agency**, đồng
  thời `<jsp:include>` navbar động sẵn có (`views/common/navbar.jsp`) để giữ nguyên logic cũ.
