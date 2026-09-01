<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thêm Category</title>
<style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    div { margin-bottom: 15px; }
    label { font-weight: bold; }
    .note { color: gray; font-size: 13px; font-style: italic; }
</style>
</head>
<body>
    <h2>Thêm Category mới</h2>

    <form action="${pageContext.request.contextPath}/category/insert" method="post" enctype="multipart/form-data">
        <div>
            <label>Tên Category:</label><br>
            <input type="text" name="categoryname" required>
        </div>

        <div>
            <label>Icon (ảnh đại diện):</label><br>
            <input type="file" name="images" required>
        </div>

        <div>
            <label>Số lượng trong kho (Trạng thái):</label><br>
            <input type="number" name="status" value="1" min="0" style="width: 100px; padding: 5px;" required>
            <span class="note">(Nhập số lượng > 0 là In stock, nhập 0 là Out of stock)</span>
        </div>

        <button type="submit" style="padding: 8px 15px; background-color: #4CAF50; color: white; border: none; cursor: pointer;">Lưu lại</button>
        <a href="${pageContext.request.contextPath}/categories" style="margin-left: 10px; text-decoration: none; color: red;">Hủy bỏ</a>
    </form>
</body>
</html>