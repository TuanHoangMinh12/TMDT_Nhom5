<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Chi Tiết Phiên Đấu Giá #${auction.id} | Admin</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/templates/admin/doc/css/main.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.js"></script>
    <style>
        /* Badge màu cho từng trạng thái */
        .badge-warning  { background-color: #ffc107; color: #333; }
        .badge-success  { background-color: #28a745; }
        .badge-secondary{ background-color: #6c757d; }
        .badge-primary  { background-color: #007bff; }
        /* Dòng highlight người thắng trong bảng bid */
        .winner-row { background-color: #e8f8e8 !important; font-weight: bold; }
        /* Thông tin sách bên trái */
        .book-info-card { border: 1px solid #ddd; border-radius: 6px; padding: 15px; }
        .book-info-card img { width: 100%; max-height: 200px; object-fit: cover; border-radius: 4px; }
    </style>
</head>

<body onload="time()" class="app sidebar-mini rtl">
<%@include file="/common/admin/header.jsp"%>
<%@include file="/common/admin/aside.jsp"%>

<main class="app-content">
    <!-- Breadcrumb -->
    <div class="app-title">
        <ul class="app-breadcrumb breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/admin-auction-list">Quản Lý Đấu Giá</a>
            </li>
            <li class="breadcrumb-item active">
                <b>Chi Tiết Phiên #${auction.id}</b>
            </li>
        </ul>
        <div id="clock"></div>
    </div>

    <!-- Thông báo -->
    <c:if test="${not empty message}">
        <div class="alert alert-${alert} alert-dismissible">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
            ${message}
        </div>
    </c:if>

    <div class="row">
        <!-- ===== CỘT TRÁI: THÔNG TIN PHIÊN ===== -->
        <div class="col-md-4">
            <div class="tile book-info-card">
                <%-- Ảnh sách --%>
                <c:if test="${not empty auction.bookImage}">
                    <img src="${pageContext.request.contextPath}${auction.bookImage}"
                         alt="${auction.bookName}">
                </c:if>
                <c:if test="${empty auction.bookImage}">
                    <div style="height:150px; background:#eee; display:flex; align-items:center;
                                justify-content:center; border-radius:4px; color:#aaa;">
                        <i class="fas fa-book fa-3x"></i>
                    </div>
                </c:if>

                <hr>
                <h5><strong>${auction.bookName}</strong></h5>
                <table class="table table-sm" style="font-size:13px;">
                    <tr>
                        <td>Trạng thái:</td>
                        <td>
                            <span class="badge ${auction.statusBadge}">
                                ${auction.statusLabel}
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td>Giá khởi điểm:</td>
                        <td>
                            <b><fmt:formatNumber value="${auction.startPrice}" pattern="#,###"/> đ</b>
                        </td>
                    </tr>
                    <tr>
                        <td>Giá hiện tại:</td>
                        <td>
                            <b style="color:#e44;">
                                <fmt:formatNumber value="${auction.currentPrice}" pattern="#,###"/> đ
                            </b>
                        </td>
                    </tr>
                    <tr>
                        <td>Bước giá:</td>
                        <td><fmt:formatNumber value="${auction.minIncrement}" pattern="#,###"/> đ</td>
                    </tr>
                    <tr>
                        <td>Bắt đầu:</td>
                        <td>
                            <fmt:formatDate value="${auction.startTime}" pattern="dd/MM/yyyy HH:mm"/>
                        </td>
                    </tr>
                    <tr>
                        <td>Kết thúc:</td>
                        <td>
                            <fmt:formatDate value="${auction.endTime}" pattern="dd/MM/yyyy HH:mm"/>
                        </td>
                    </tr>
                    <tr>
                        <td>Tổng lượt bid:</td>
                        <td><span class="badge badge-secondary">${auction.totalBids}</span></td>
                    </tr>
                    <c:if test="${not empty auction.winnerName}">
                        <tr>
                            <td>Người thắng:</td>
                            <td>
                                <span class="text-success">
                                    <i class="fas fa-trophy"></i>
                                    <b>${auction.winnerName}</b>
                                </span>
                            </td>
                        </tr>
                    </c:if>
                </table>

                <!-- ===== CÁC NÚT HÀNH ĐỘNG ===== -->
                <div style="display:flex; flex-direction:column; gap:8px;">

                    <%-- NÚT CHỐT PHIÊN: chỉ hiện khi FINISHED --%>
                    <c:if test="${auction.status == 'FINISHED' && empty auction.winnerName}">
                        <form method="post"
                              action="${pageContext.request.contextPath}/admin-auction-detail">
                            <input type="hidden" name="auctionId" value="${auction.id}">
                            <input type="hidden" name="action"    value="finalize">
                            <button type="button" class="btn btn-success btn-block"
                                    onclick="confirmFinalize()">
                                <i class="fas fa-gavel"></i> Chốt phiên & Gửi thông báo
                            </button>
                        </form>
                    </c:if>

                    <%-- NÚT ĐÁNH DẤU ĐÃ THANH TOÁN: chỉ hiện khi FINISHED và đã có winner --%>
                    <c:if test="${auction.status == 'FINISHED' && not empty auction.winnerName}">
                        <form method="post"
                              action="${pageContext.request.contextPath}/admin-auction-detail">
                            <input type="hidden" name="auctionId" value="${auction.id}">
                            <input type="hidden" name="action"    value="markPaid">
                            <button type="submit" class="btn btn-primary btn-block">
                                <i class="fas fa-check-circle"></i> Xác nhận đã thu tiền (PAID)
                            </button>
                        </form>
                    </c:if>

                    <%-- NÚT SỬA: chỉ hiện khi WAITING --%>
                    <c:if test="${auction.status == 'WAITING'}">
                        <a href="${pageContext.request.contextPath}/admin-auction-edit?id=${auction.id}"
                           class="btn btn-warning btn-block">
                            <i class="fas fa-edit"></i> Sửa thông tin phiên
                        </a>
                    </c:if>

                    <%-- Nút quay lại --%>
                    <a href="${pageContext.request.contextPath}/admin-auction-list"
                       class="btn btn-secondary btn-block">
                        <i class="fas fa-arrow-left"></i> Quay lại danh sách
                    </a>
                </div>

            </div>
        </div>

        <!-- ===== CỘT PHẢI: LỊCH SỬ BID ===== -->
        <div class="col-md-8">
            <div class="tile">
                <h3 class="tile-title">
                    <i class="fas fa-history"></i>
                    Lịch Sử Đặt Giá
                    <small class="text-muted">(${auction.totalBids} lượt)</small>
                </h3>
                <div class="tile-body">

                    <c:if test="${empty bidHistory}">
                        <div class="alert alert-info">
                            Chưa có ai đặt giá cho phiên này.
                        </div>
                    </c:if>

                    <c:if test="${not empty bidHistory}">
                        <table class="table table-hover table-bordered table-sm" id="bidTable">
                            <thead class="thead-light">
                            <tr>
                                <th>#</th>
                                <th>Người đặt</th>
                                <th>Email</th>
                                <th>Số tiền bid</th>
                                <th>Thời gian</th>
                                <th>Hành động</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="bid" items="${bidHistory}" varStatus="loop">
                                <%--
                                  Dòng đầu tiên (index=0) là bid cao nhất (do ORDER BY bid_price DESC)
                                  -> highlight dòng người thắng
                                --%>
                                <tr class="${loop.index == 0 && auction.status != 'WAITING' ? 'winner-row' : ''}">
                                    <td>${loop.count}</td>
                                    <td>
                                        <c:if test="${loop.index == 0 && auction.status != 'WAITING'}">
                                            <i class="fas fa-trophy text-warning"></i>
                                        </c:if>
                                        ${bid.userName}
                                        <br>
                                        <small class="text-muted">ID: ${bid.userId}</small>
                                    </td>
                                    <td>${bid.userEmail}</td>
                                    <td>
                                        <b style="color:#e44;">
                                            <fmt:formatNumber value="${bid.bidPrice}" pattern="#,###"/> đ
                                        </b>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${bid.bidTime}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                    </td>
                                    <td>
                                        <%-- Nút khóa/mở khóa tài khoản người đặt --%>
                                        <button class="btn btn-danger btn-xs"
                                                onclick="confirmLockUser(${bid.userId}, '${bid.userName}')"
                                                title="Khóa tài khoản người này">
                                            <i class="fas fa-ban"></i> Khóa
                                        </button>
                                        <button class="btn btn-success btn-xs"
                                                onclick="confirmUnlockUser(${bid.userId}, '${bid.userName}')"
                                                title="Mở khóa tài khoản">
                                            <i class="fas fa-unlock"></i> Mở
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Form ẩn để gửi POST action khóa/mở khóa user -->
<form id="lockForm" method="post"
      action="${pageContext.request.contextPath}/admin-auction-detail">
    <input type="hidden" name="auctionId" value="${auction.id}">
    <input type="hidden" name="action"    id="lockAction" value="">
    <input type="hidden" name="userId"    id="lockUserId" value="">
</form>

<!-- Form ẩn để chốt phiên -->
<form id="finalizeForm" method="post"
      action="${pageContext.request.contextPath}/admin-auction-detail">
    <input type="hidden" name="auctionId" value="${auction.id}">
    <input type="hidden" name="action"    value="finalize">
</form>

<script src="${pageContext.request.contextPath}/templates/admin/doc/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/main.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/plugins/jquery.dataTables.min.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/plugins/dataTables.bootstrap.min.js"></script>

<script>
    // DataTable cho bảng bid
    $('#bidTable').DataTable({
        "order": [],  // Giữ nguyên thứ tự từ server (bid_price DESC)
        "language": {
            "search": "Tìm kiếm:",
            "lengthMenu": "Hiển thị _MENU_ dòng",
            "paginate": {"previous": "Trước", "next": "Tiếp"}
        }
    });

    // Xác nhận chốt phiên
    function confirmFinalize() {
        swal({
            title: "Xác nhận chốt phiên?",
            text: "Hành động này sẽ xác định người thắng cuộc và gửi thông báo đến tất cả người tham gia.",
            icon: "warning",
            buttons: ["Hủy", "Đồng ý chốt phiên"],
        }).then(function(ok) {
            if (ok) document.getElementById("finalizeForm").submit();
        });
    }

    // Xác nhận khóa tài khoản
    function confirmLockUser(userId, userName) {
        swal({
            title: "Khóa tài khoản?",
            text: "Bạn có chắc muốn khóa tài khoản của \"" + userName + "\" (ID: " + userId + ")?\nNgười này sẽ không thể đăng nhập.",
            icon: "warning",
            buttons: ["Hủy", "Khóa tài khoản"],
            dangerMode: true
        }).then(function(ok) {
            if (ok) {
                document.getElementById("lockAction").value = "lockUser";
                document.getElementById("lockUserId").value = userId;
                document.getElementById("lockForm").submit();
            }
        });
    }

    // Xác nhận mở khóa tài khoản
    function confirmUnlockUser(userId, userName) {
        swal({
            title: "Mở khóa tài khoản?",
            text: "Bạn có chắc muốn mở khóa tài khoản của \"" + userName + "\" (ID: " + userId + ")?",
            icon: "info",
            buttons: ["Hủy", "Mở khóa"],
        }).then(function(ok) {
            if (ok) {
                document.getElementById("lockAction").value = "unlockUser";
                document.getElementById("lockUserId").value = userId;
                document.getElementById("lockForm").submit();
            }
        });
    }

    // Đồng hồ
    function time() {
        var today = new Date();
        var weekday = ["Chủ Nhật","Thứ Hai","Thứ Ba","Thứ Tư","Thứ Năm","Thứ Sáu","Thứ Bảy"];
        var dd = String(today.getDate()).padStart(2,'0');
        var mm = String(today.getMonth()+1).padStart(2,'0');
        var h  = String(today.getHours()).padStart(2,'0');
        var mi = String(today.getMinutes()).padStart(2,'0');
        var s  = String(today.getSeconds()).padStart(2,'0');
        document.getElementById("clock").innerHTML =
            '<span class="date">' + weekday[today.getDay()] + ', ' + dd + '/' + mm + '/' + today.getFullYear() +
            ' - ' + h + ':' + mi + ':' + s + '</span>';
        setTimeout("time()", 1000);
    }
</script>

<%--<script>--%>
<%--    <c:if test="${not empty message}">--%>
<%--    swal({--%>
<%--        title: "${alert == 'success' ? 'Thành công!' : 'Lỗi!'}",--%>
<%--        text: "${message}",--%>
<%--        icon: "${alert == 'success' ? 'success' : 'error'}",--%>
<%--        button: "Đóng"--%>
<%--    });--%>
<%--    </c:if>--%>
<%--</script>--%>


</body>
</html>
