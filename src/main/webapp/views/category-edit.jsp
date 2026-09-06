<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Cập nhật Category</title>
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Helvetica Neue', Arial, sans-serif;
            margin: 0;
            background: #f7f7f8;
            color: #1a1a1a;
        }

        .page-wrap {
            max-width: 560px;
            margin: 40px auto 60px;
            padding: 0 20px;
        }

        .breadcrumb {
            font-size: 13px;
            margin-bottom: 18px;
        }

        .breadcrumb a {
            color: #777;
            text-decoration: none;
        }

        .breadcrumb a:hover { color: #1a1a1a; }

        .page-title {
            font-size: 24px;
            font-weight: 700;
            margin: 0 0 4px;
        }

        .page-subtitle {
            font-size: 14px;
            color: #777;
            margin: 0 0 24px;
        }

        .card {
            background: #fff;
            border: 1px solid #eee;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, .04);
            padding: 32px;
        }

        .alert-error {
            background: #fdecea;
            border: 1px solid #f5c2c0;
            color: #c0392b;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .field { margin-bottom: 20px; }

        .field label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 6px;
            color: #333;
        }

        .field .required { color: #e53935; }

        .field .hint {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }

        input[type="text"],
        input[type="number"] {
            width: 100%;
            padding: 10px 12px;
            font-size: 14px;
            font-family: inherit;
            border: 1px solid #ddd;
            border-radius: 8px;
            background: #fff;
            color: #1a1a1a;
            transition: border-color .15s, box-shadow .15s;
        }

        input[type="text"]:focus,
        input[type="number"]:focus {
            outline: none;
            border-color: #1a1a1a;
            box-shadow: 0 0 0 3px rgba(26, 26, 26, .06);
        }

        .status-input { max-width: 160px; }

        .current-img-box {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 12px;
            padding: 10px 12px;
            background: #fafafa;
            border: 1px solid #eee;
            border-radius: 8px;
        }

        .current-img-box img {
            width: 56px;
            height: 56px;
            object-fit: cover;
            border-radius: 6px;
            border: 1px solid #eee;
        }

        .current-img-box .current-label {
            font-size: 12px;
            color: #999;
        }

        .current-img-box .current-name {
            font-size: 13px;
            color: #333;
            word-break: break-all;
        }

        .upload-box {
            border: 1.5px dashed #ddd;
            border-radius: 8px;
            padding: 18px;
            text-align: center;
            cursor: pointer;
            transition: border-color .15s, background .15s;
            position: relative;
        }

        .upload-box:hover { border-color: #1a1a1a; background: #fafafa; }

        .upload-box input[type="file"] {
            position: absolute;
            inset: 0;
            opacity: 0;
            cursor: pointer;
        }

        .upload-box .upload-icon {
            font-size: 22px;
            margin-bottom: 4px;
        }

        .upload-box .upload-text {
            font-size: 13px;
            color: #555;
        }

        .upload-box .upload-text b {
            color: #1a1a1a;
        }

        .preview-wrap {
            display: none;
            margin-top: 14px;
            align-items: center;
            gap: 12px;
        }

        .preview-wrap img {
            width: 64px;
            height: 64px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #eee;
        }

        .preview-wrap .file-name {
            font-size: 13px;
            color: #333;
            word-break: break-all;
        }

        .actions {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-top: 28px;
            padding-top: 20px;
            border-top: 1px solid #f0f0f0;
        }

        .btn-primary {
            padding: 11px 24px;
            background: #1a1a1a;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background .15s;
        }

        .btn-primary:hover { background: #333; }

        .btn-cancel {
            text-decoration: none;
            color: #777;
            font-size: 14px;
            font-weight: 600;
            transition: color .15s;
        }

        .btn-cancel:hover { color: #e53935; }
    </style>
</head>

<body>
    <%@ include file="/views/common/navbar.jsp" %>

    <div class="page-wrap">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/categories">Danh mục</a> / Chỉnh sửa
        </div>
        <h2 class="page-title">Chỉnh sửa Category</h2>
        <p class="page-subtitle">Cập nhật thông tin của danh mục <b>${cate.categoryname}</b>.</p>

        <c:if test="${not empty error}">
            <div class="alert-error">${error}</div>
        </c:if>

        <div class="card">
            <form action="${pageContext.request.contextPath}/category/update" method="post"
                enctype="multipart/form-data">
                <input type="hidden" name="categoryId" value="${cate.categoryId}">

                <div class="field">
                    <label>Tên Category <span class="required">*</span></label>
                    <input type="text" name="categoryname" value="${cate.categoryname}" required>
                </div>

                <div class="field">
                    <label>Icon (ảnh đại diện)</label>

                    <c:if test="${not empty cate.images}">
                        <div class="current-img-box">
                            <img src="${pageContext.request.contextPath}/image/${cate.images}" alt="Ảnh hiện tại">
                            <div>
                                <div class="current-label">Đang sử dụng</div>
                                <div class="current-name">${cate.images}</div>
                            </div>
                        </div>
                    </c:if>

                    <div class="upload-box" id="uploadBox">
                        <input type="file" name="images" id="fileInput" accept="image/*">
                        <div class="upload-icon">🖼️</div>
                        <div class="upload-text"><b>Chọn ảnh mới</b> hoặc kéo thả vào đây</div>
                    </div>
                    <div class="preview-wrap" id="previewWrap">
                        <img id="previewImg" src="" alt="Xem trước">
                        <span class="file-name" id="previewName"></span>
                    </div>
                    <div class="hint">Để trống nếu muốn giữ nguyên ảnh cũ.</div>
                </div>

                <div class="field">
                    <label>Số lượng trong kho (Trạng thái) <span class="required">*</span></label>
                    <input type="number" name="status" value="${cate.status}" min="0" class="status-input" required>
                    <div class="hint">Nhập số lượng &gt; 0 là In stock, nhập 0 là Out of stock.</div>
                </div>

                <div class="actions">
                    <button type="submit" class="btn-primary">Cập nhật</button>
                    <a href="${pageContext.request.contextPath}/categories" class="btn-cancel">Hủy bỏ</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        var fileInput = document.getElementById('fileInput');
        var previewWrap = document.getElementById('previewWrap');
        var previewImg = document.getElementById('previewImg');
        var previewName = document.getElementById('previewName');

        fileInput.addEventListener('change', function () {
            if (this.files && this.files[0]) {
                var file = this.files[0];
                previewImg.src = URL.createObjectURL(file);
                previewName.textContent = file.name;
                previewWrap.style.display = 'flex';
            } else {
                previewWrap.style.display = 'none';
            }
        });
    </script>
</body>

</html>
