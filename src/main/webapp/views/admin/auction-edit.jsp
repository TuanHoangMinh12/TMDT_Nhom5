<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Sửa Phiên Đấu Giá | Admin</title>
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
            <li class="breadcrumb-item active">
                <b>Sửa Phiên #${auction.id}</b>
            </li>
        </ul>
    </div>

    <c:if test="${not empty message}">
        <div class="alert alert-${alert}">${message}</div>
    </c:if>

    <div class="row">
        <div class="col-md-8">
            <div class="tile">
                <h3 class="tile-title">
                    <i class="fas fa-edit"></i>
                    Sửa Phiên Đấu Giá: <em>${auction.bookName}</em>
                </h3>
                <div class="tile-body">
                    <form action="${pageContext.request.contextPath}/admin-auction-edit"
                          method="post" class="row">

                        <%-- ID và action ẩn --%>
                        <input type="hidden" name="id"     value="${auction.id}">
                        <input type="hidden" name="action" value="update">

                        <%-- Thông tin sách (chỉ đọc, không sửa) --%>
                        <div class="form-group col-md-12">
                            <label class="control-label">Sách</label>
                            <input type="text" class="form-control"
                                   value="${auction.bookName}" readonly
                                   style="background:#f5f5f5; cursor:not-allowed;">
                            <small class="text-muted">Không thể đổi sách sau khi tạo phiên.</small>
                        </div>

                        <div class="form-group col-md-6">
                            <label class="control-label">
                                Giá khởi điểm (đ) <span class="text-danger">*</span>
                            </label>
                            <input name="startPrice" type="number" class="form-control"
                                   value="${auction.startPrice}" min="1000" step="1000" required>
                        </div>

                        <div class="form-group col-md-6">
                            <label class="control-label">
                                Bước giá tối thiểu (đ) <span class="text-danger">*</span>
                            </label>
                            <input name="minIncrement" type="number" class="form-control"
                                   value="${auction.minIncrement}" min="1000" step="1000" required>
                        </div>

                        <%--
                          Định dạng datetime-local cần "yyyy-MM-ddTHH:mm"
                          Dùng fmt:formatDate để chuyển từ Timestamp sang chuỗi đó
                        --%>
                        <div class="form-group col-md-6">
                            <label class="control-label">
                                Thời gian bắt đầu <span class="text-danger">*</span>
                            </label>
                            <input name="startTime" type="datetime-local" class="form-control"
                                   value="<fmt:formatDate value='${auction.startTime}' pattern='yyyy-MM-dd&apos;T&apos;HH:mm'/>"
                                   required>
                        </div>

                        <div class="form-group col-md-6">
                            <label class="control-label">
                                Thời gian kết thúc <span class="text-danger">*</span>
                            </label>
                            <input name="endTime" type="datetime-local" class="form-control"
                                   value="<fmt:formatDate value='${auction.endTime}' pattern='yyyy-MM-dd&apos;T&apos;HH:mm'/>"
                                   required>
                        </div>

                        <div class="form-group col-md-12">
                            <button class="btn btn-save" type="submit">
                                <i class="fas fa-save"></i> Lưu thay đổi
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
    </div>
</main>

<script src="${pageContext.request.contextPath}/templates/admin/doc/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/main.js"></script>
</body>
</html>
