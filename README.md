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
- `hibernate.hbm2ddl.auto=update` → Hibernate tự tạo/cập nhật 3 bảng `users`, `categories`,
  `products` theo entity khi ứng dụng khởi động lần đầu — chỉ cần tạo sẵn database trống
  tên `jakartaJPASample` (hoặc đổi tên database trong `url` theo ý muốn). Khi thêm field
  mới vào entity (ví dụ `phone`, `avatar` của `User` cho chức năng Profile), Hibernate sẽ
  tự `ALTER TABLE ... ADD` cột mới, không cần chạy tay script SQL.
- Sửa `jakarta.persistence.jdbc.user` / `jakarta.persistence.jdbc.password` khớp với tài
  khoản SQL Server thực tế của bạn.
- Đường dẫn lưu ảnh upload (không thuộc `persistence.xml`) được cấu hình riêng tại
  `src/main/java/configs/AppConfig.java` (`ROOT_UPLOAD_DIR = "/image"`) — ảnh được lưu
  theo 3 thư mục con: `image/products/`, `image/categories/`, `image/users/` (avatar),
  và đọc lại qua `ImageController` (`/image/...`).


## Tài khoản đăng nhập để test

Toàn bộ chức năng **thêm / sửa / xóa** (Category, Product) chỉ hoạt động khi đăng nhập
bằng tài khoản có `role = "admin"` trong bảng `users`. Hệ thống đã cấu hình sẵn một tài
khoản admin dùng để test:

- **Email:** `tranthiphuongtrang2711@gmail.com`
- **Mật khẩu:** `123456`

**Nếu không đăng nhập:** trang web chỉ cho phép **xem** dữ liệu (trang chủ, danh sách/chi
tiết sản phẩm, danh sách/chi tiết danh mục) với vai trò **user** thông thường.

**Sau khi đăng nhập (user thường hoặc admin):** có thể vào mục **"Hồ sơ"** trên navbar để
cập nhật họ tên, số điện thoại, ảnh đại diện (xem mục 8).
