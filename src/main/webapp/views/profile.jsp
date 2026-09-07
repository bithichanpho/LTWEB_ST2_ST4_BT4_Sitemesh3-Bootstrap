<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Hồ sơ cá nhân</title>
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Helvetica Neue', Arial, sans-serif;
            margin: 0;
            background: #f7f7f8;
            color: #1a1a1a;
        }

        .page-wrap {
            max-width: 640px;
            margin: 40px auto 60px;
            padding: 0 20px;
        }

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

        .alert-success {
            background: #eafaf0;
            border: 1px solid #b7ebc6;
            color: #1e7e34;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .avatar-row {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 28px;
        }

        .avatar-preview {
            width: 88px;
            height: 88px;
            border-radius: 50%;
            object-fit: cover;
            border: 1px solid #eee;
            background: #f0f0f0;
        }

        .avatar-placeholder {
            width: 88px;
            height: 88px;
            border-radius: 50%;
            background: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            font-weight: 700;
            color: #999;
            border: 1px solid #eee;
        }

        .avatar-meta .email {
            font-size: 14px;
            color: #333;
            font-weight: 600;
        }

        .avatar-meta .role {
            font-size: 12px;
            color: #999;
            text-transform: uppercase;
            letter-spacing: .5px;
            margin-top: 2px;
        }

        .field { margin-bottom: 20px; }

        .field label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 6px;
            color: #333;
        }

        .field .hint {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }

        .field-error {
            color: #e53935;
            font-size: 12px;
            margin-top: 5px;
        }

        input[type="text"],
        input[type="tel"] {
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
        input[type="tel"]:focus {
            outline: none;
            border-color: #1a1a1a;
            box-shadow: 0 0 0 3px rgba(26, 26, 26, .06);
        }

        input.invalid { border-color: #e53935 !important; }

        input[readonly] {
            background: #f4f4f4;
            color: #888;
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

        .upload-box .upload-icon { font-size: 22px; margin-bottom: 4px; }
        .upload-box .upload-text { font-size: 13px; color: #555; }
        .upload-box .upload-text b { color: #1a1a1a; }

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
            border-radius: 50%;
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

    <div class="page-wrap">
        <h2 class="page-title">Hồ sơ cá nhân</h2>
        <p class="page-subtitle">Cập nhật họ tên, số điện thoại và ảnh đại diện của bạn.</p>

        <c:if test="${not empty message}">
            <div class="alert-success">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert-error">${error}</div>
        </c:if>

        <div class="card">
            <div class="avatar-row">
                <c:choose>
                    <c:when test="${not empty profileUser.avatar}">
                        <img class="avatar-preview" id="currentAvatarImg"
                            src="${pageContext.request.contextPath}/image/${profileUser.avatar}" alt="Avatar">
                    </c:when>
                    <c:otherwise>
                        <div class="avatar-placeholder" id="currentAvatarPlaceholder">
                            ${fn:substring(profileUser.fullname, 0, 1)}
                        </div>
                    </c:otherwise>
                </c:choose>
                <div class="avatar-meta">
                    <div class="email">${profileUser.email}</div>
                    <div class="role">${profileUser.role}</div>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/profile/update" method="post"
                enctype="multipart/form-data">

                <div class="field">
                    <label>Họ tên <span style="color:#e53935">*</span></label>
                    <input type="text" name="fullname" value="${profileUser.fullname}"
                        class="${not empty fieldErrors.fullname ? 'invalid' : ''}" required minlength="2" maxlength="255">
                    <c:if test="${not empty fieldErrors.fullname}">
                        <div class="field-error">${fieldErrors.fullname}</div>
                    </c:if>
                </div>

                <div class="field">
                    <label>Email</label>
                    <input type="text" value="${profileUser.email}" readonly>
                    <div class="hint">Email không thể thay đổi.</div>
                </div>

                <div class="field">
                    <label>Số điện thoại</label>
                    <input type="tel" name="phone" value="${profileUser.phone}"
                        class="${not empty fieldErrors.phone ? 'invalid' : ''}" placeholder="VD: 0912345678">
                    <c:if test="${not empty fieldErrors.phone}">
                        <div class="field-error">${fieldErrors.phone}</div>
                    </c:if>
                </div>

                <div class="field">
                    <label>Ảnh đại diện</label>
                    <div class="upload-box" id="uploadBox">
                        <input type="file" name="avatar" id="fileInput" accept="image/*">
                        <div class="upload-icon">🖼️</div>
                        <div class="upload-text"><b>Chọn ảnh mới</b> hoặc kéo thả vào đây</div>
                    </div>
                    <div class="preview-wrap" id="previewWrap">
                        <img id="previewImg" src="" alt="Xem trước">
                        <span class="file-name" id="previewName"></span>
                    </div>
                    <div class="hint">Để trống nếu muốn giữ nguyên ảnh hiện tại. Định dạng JPG, PNG, tối đa 5MB.</div>
                </div>

                <div class="actions">
                    <button type="submit" class="btn-primary">Lưu thay đổi</button>
                    <a href="${pageContext.request.contextPath}/home" class="btn-cancel">Hủy bỏ</a>
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
