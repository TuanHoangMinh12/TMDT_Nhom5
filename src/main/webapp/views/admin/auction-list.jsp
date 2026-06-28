<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản Lý Đấu Giá | Admin</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/templates/admin/doc/css/main.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.js"></script>
</head>

<body onload="time()" class="app sidebar-mini rtl">
<%@include file="/common/admin/header.jsp"%>
<%@include file="/common/admin/aside.jsp"%>

<main class="app-content">
    <!-- Breadcrumb -->
    <div class="app-title">
        <ul class="app-breadcrumb breadcrumb">
            <li class="breadcrumb-item"><b>Quản Lý Đấu Giá</b></li>
        </ul>
        <div id="clock"></div>
    </div>

    <!-- Thông báo thành công / lỗi -->
    <c:if test="${not empty message}">
        <div class="alert alert-${alert} alert-dismissible" role="alert">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
            ${message}
        </div>
    </c:if>

    <!-- ===== THỐNG KÊ NHANH (4 ô) ===== -->
    <div class="row">
        <div class="col-md-3">
            <div class="widget-small warning coloured-icon">
                <i class="icon bx bx-time fa-3x"></i>
                <div class="info">
                    <h4>Sắp diễn ra</h4>
                    <p><b>${countWaiting} phiên</b></p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="widget-small primary coloured-icon">
                <i class="icon bx bx-broadcast fa-3x"></i>
                <div class="info">
                    <h4>Đang diễn ra</h4>
                    <p><b>${countActive} phiên</b></p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="widget-small info coloured-icon">
                <i class="icon bx bx-check-circle fa-3x"></i>
                <div class="info">
                    <h4>Đã kết thúc</h4>
                    <p><b>${countFinished} phiên</b></p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="widget-small success coloured-icon">
                <i class="icon bx bx-money fa-3x"></i>
                <div class="info">
                    <h4>Đã thanh toán</h4>
                    <p><b>${countPaid} phiên</b></p>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== BẢNG DANH SÁCH PHIÊN ===== -->
    <div class="row">
        <div class="col-md-12">
            <div class="tile">
                <div class="tile-body">
                    <!-- Nút tạo mới -->
                    <div class="row element-button" style="margin-bottom: 15px;">
                        <div class="col-sm-3">
                            <a class="btn btn-add btn-sm"
                               href="${pageContext.request.contextPath}/admin-auction-create">
                                <i class="fas fa-plus"></i> Tạo phiên đấu giá mới
                            </a>
                        </div>
                        <div class="col-sm-3">
                            <a class="btn btn-info btn-sm"
                               href="${pageContext.request.contextPath}/admin-auction-stats">
                                <i class="fas fa-chart-bar"></i> Xem thống kê
                            </a>
                        </div>
                    </div>

                    <!-- Bảng dữ liệu -->
                    <table class="table table-hover table-bordered" id="sampleTable">
                        <thead>
                        <tr>
                            <th>STT</th>
                            <th>Sách</th>
                            <th>Giá khởi điểm</th>
                            <th>Giá hiện tại</th>
                            <th>Bước giá</th>
                            <th>Bắt đầu</th>
                            <th>Kết thúc</th>
                            <th>Lượt bid</th>
                            <th>Trạng thái</th>
                            <th>Chức năng</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="a" items="${listAuction}">
                            <tr>
                                <td>${a.id}</td>
                                <td>
                                    <c:if test="${not empty a.bookImage}">
                                        <img src="${pageContext.request.contextPath}${a.bookImage}"
                                             width="40" height="50"
                                             style="object-fit:cover; margin-right:6px; border-radius:3px;">
                                    </c:if>
                                    <strong>${a.bookName}</strong>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${a.startPrice}" pattern="#,###"/> đ
                                </td>
                                <td>
                                    <fmt:formatNumber value="${a.currentPrice}" pattern="#,###"/> đ
                                </td>
                                <td>
                                    <fmt:formatNumber value="${a.minIncrement}" pattern="#,###"/> đ
                                </td>
                                <td>
                                    <fmt:formatDate value="${a.startTime}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td>
                                    <fmt:formatDate value="${a.endTime}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td>
                                    <span class="badge badge-secondary">${a.totalBids} lượt</span>
                                </td>
                                <td>
                                    <!-- Badge màu theo trạng thái -->
                                    <span class="badge ${a.statusBadge}">${a.statusLabel}</span>
                                </td>
                                <td>
                                    <!-- Nút xem chi tiết (luôn hiện) -->
                                    <a href="${pageContext.request.contextPath}/admin-auction-detail?id=${a.id}"
                                       class="btn btn-primary btn-sm" title="Xem chi tiết">
                                        <i class="fas fa-eye"></i>
                                    </a>

                                    <!-- Nút sửa: chỉ hiện khi WAITING -->
                                    <c:if test="${a.status == 'WAITING'}">
                                        <a href="${pageContext.request.contextPath}/admin-auction-edit?id=${a.id}"
                                           class="btn btn-warning btn-sm" title="Sửa">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <!-- Nút xóa với confirm -->
                                        <button class="btn btn-danger btn-sm"
                                                onclick="confirmDelete(${a.id})"
                                                title="Xóa">
                                            <i class="fas fa-trash-alt"></i>
                                        </button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>

                        <!-- Nếu không có phiên nào -->
                        <c:if test="${empty listAuction}">
                            <tr>
                                <td colspan="10" class="text-center text-muted">
                                    Chưa có phiên đấu giá nào. Hãy tạo mới!
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>

                </div>
            </div>
        </div>
    </div>
</main>

<!-- Form xóa ẩn (POST request để xóa) -->
<form id="deleteForm" method="post"
      action="${pageContext.request.contextPath}/admin-auction-edit">
    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="id" id="deleteId" value="">
</form>

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/main.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/plugins/jquery.dataTables.min.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/plugins/dataTables.bootstrap.min.js"></script>

<script>
    // Kích hoạt DataTable để có tìm kiếm, phân trang
    $('#sampleTable').DataTable({
        "language": {
            "search": "Tìm kiếm:",
            "lengthMenu": "Hiển thị _MENU_ dòng",
            "info": "Hiển thị _START_ đến _END_ trong _TOTAL_ phiên",
            "paginate": {"previous": "Trước", "next": "Tiếp"}
        }
    });

    // Xác nhận trước khi xóa
    function confirmDelete(id) {
        swal({
            title: "Xác nhận xóa?",
            text: "Bạn có chắc muốn xóa phiên đấu giá #" + id + "?\nHành động này không thể hoàn tác!",
            icon: "warning",
            buttons: ["Hủy", "Đồng ý xóa"],
            dangerMode: true
        }).then(function(willDelete) {
            if (willDelete) {
                document.getElementById("deleteId").value = id;
                document.getElementById("deleteForm").submit();
            }
        });
    }

    // Đồng hồ góc trên phải
    function time() {
        var today = new Date();
        var weekday = ["Chủ Nhật","Thứ Hai","Thứ Ba","Thứ Tư","Thứ Năm","Thứ Sáu","Thứ Bảy"];
        var day = weekday[today.getDay()];
        var dd = String(today.getDate()).padStart(2,'0');
        var mm = String(today.getMonth()+1).padStart(2,'0');
        var yyyy = today.getFullYear();
        var h = String(today.getHours()).padStart(2,'0');
        var m = String(today.getMinutes()).padStart(2,'0');
        var s = String(today.getSeconds()).padStart(2,'0');
        document.getElementById("clock").innerHTML =
            '<span class="date">' + day + ', ' + dd + '/' + mm + '/' + yyyy +
            ' - ' + h + ' giờ ' + m + ' phút ' + s + ' giây</span>';
        setTimeout("time()", 1000);
    }
</script>
</body>
</html>
