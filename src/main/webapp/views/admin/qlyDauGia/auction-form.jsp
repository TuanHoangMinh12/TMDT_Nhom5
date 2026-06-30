<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Tạo Phiên Đấu Giá | Admin</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/templates/admin/doc/css/main.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
</head>

<body class="app sidebar-mini rtl">
<%@include file="/common/admin/header.jsp"%>
<%@include file="/common/admin/aside.jsp"%>

<main class="app-content">
    <div class="app-title">
        <ul class="app-breadcrumb breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/admin-auction-list">Quản Lý Đấu Giá</a>
            </li>
            <li class="breadcrumb-item active"><b>Tạo Phiên Mới</b></li>
        </ul>
    </div>

    <!-- Thông báo lỗi -->
    <c:if test="${not empty message}">
        <div class="alert alert-${alert}">${message}</div>
    </c:if>

    <div class="row">
        <div class="col-md-8">
            <div class="tile">
                <h3 class="tile-title">
                    <i class="fas fa-gavel"></i> Tạo Phiên Đấu Giá Mới
                </h3>
                <div class="tile-body">

                    <%-- ACTION trỏ về servlet xử lý POST --%>
                    <form action="${pageContext.request.contextPath}/admin-auction-create"
                          method="post" class="row">

                        <%-- CHỌN SÁCH --%>
                        <div class="form-group col-md-12">
                            <label class="control-label">
                                <i class="fas fa-book"></i> Chọn sách đấu giá
                                <span class="text-danger">*</span>
                            </label>
                            <select name="bookId" class="form-control" required>
                                <option value="">-- Chọn sách --</option>
                                <c:forEach var="book" items="${listBook}">
                                    <option value="${book.id}">
                                        ${book.name}
                                        (Tồn kho: ${book.quantity} cuốn)
                                    </option>
                                </c:forEach>
                            </select>
                            <small class="text-muted">Chỉ chọn sách còn hàng để đấu giá.</small>
                        </div>

                        <%-- GIÁ KHỞI ĐIỂM --%>
                        <div class="form-group col-md-6">
                            <label class="control-label">
                                Giá khởi điểm (đ)
                                <span class="text-danger">*</span>
                            </label>
                            <input name="startPrice" type="number" class="form-control"
                                   placeholder="Ví dụ: 50000" min="1000" step="1000" required>
                            <small class="text-muted">Đây là mức giá tối thiểu để bắt đầu.</small>
                        </div>

                        <%-- BƯỚC GIÁ TỐI THIỂU --%>
                        <div class="form-group col-md-6">
                            <label class="control-label">
                                Bước giá tối thiểu (đ)
                                <span class="text-danger">*</span>
                            </label>
                            <input name="minIncrement" type="number" class="form-control"
                                   placeholder="Ví dụ: 5000" min="1000" step="1000" required>
                            <small class="text-muted">
                                Mỗi lần bid phải cao hơn giá hiện tại ít nhất bấy nhiêu.
                            </small>
                        </div>

                        <%-- THỜI GIAN BẮT ĐẦU --%>
                        <div class="form-group col-md-6">
                            <label class="control-label">
                                Thời gian bắt đầu
                                <span class="text-danger">*</span>
                            </label>
                            <input name="startTime" type="datetime-local" class="form-control" required>
                        </div>

                        <%-- THỜI GIAN KẾT THÚC --%>
                        <div class="form-group col-md-6">
                            <label class="control-label">
                                Thời gian kết thúc
                                <span class="text-danger">*</span>
                            </label>
                            <input name="endTime" type="datetime-local" class="form-control" required>
                        </div>

                        <%-- Hướng dẫn nhỏ --%>
                        <div class="col-md-12">
                            <div class="alert alert-info" style="font-size:13px;">
                                <i class="fas fa-info-circle"></i>
                                <strong>Lưu ý:</strong> Sau khi tạo, phiên sẽ ở trạng thái
                                <b>WAITING (Sắp diễn ra)</b>. Hệ thống tự động chuyển sang
                                <b>ACTIVE</b> khi đến giờ bắt đầu và <b>FINISHED</b> khi hết giờ.
                            </div>
                        </div>

                        <%-- NÚT BẤM --%>
                        <div class="form-group col-md-12">
                            <button class="btn btn-save" type="submit">
                                <i class="fas fa-save"></i> Tạo phiên đấu giá
                            </button>
                            <a class="btn btn-cancel"
                               href="${pageContext.request.contextPath}/admin-auction-list">
                                <i class="fas fa-times"></i> Hủy bỏ
                            </a>
                        </div>
                    </form>

                </div>
            </div>
        </div>

        <%-- Hướng dẫn bên phải --%>
        <div class="col-md-4">
            <div class="tile">
                <h3 class="tile-title"><i class="fas fa-question-circle"></i> Hướng dẫn</h3>
                <div class="tile-body">
                    <ul style="padding-left: 18px; font-size: 13px; line-height: 2;">
                        <li>Chọn sách cần đấu giá từ danh sách</li>
                        <li><b>Giá khởi điểm</b>: Mức giá tối thiểu để bắt đầu</li>
                        <li><b>Bước giá</b>: Mỗi lần bid tối thiểu phải tăng thêm giá trị này</li>
                        <li>Đặt thời gian hợp lý để người dùng kịp tham gia</li>
                        <li>Chỉ có thể sửa/xóa phiên khi còn <b>WAITING</b></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/templates/admin/doc/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/main.js"></script>
<script>
    // Đặt giá trị min cho datetime-local = thời điểm hiện tại
    window.onload = function() {
        var now = new Date();
        now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
        var nowStr = now.toISOString().slice(0, 16);
        document.querySelector('[name="startTime"]').min = nowStr;
        document.querySelector('[name="endTime"]').min = nowStr;

        // Khi chọn startTime -> tự cập nhật min của endTime
        document.querySelector('[name="startTime"]').addEventListener('change', function() {
            document.querySelector('[name="endTime"]').min = this.value;
        });
    };
</script>
</body>
</html>
