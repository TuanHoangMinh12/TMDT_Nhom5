<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Thống Kê Đấu Giá | Admin</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/templates/admin/doc/css/main.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
    <%-- Chart.js để vẽ biểu đồ --%>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body onload="time()" class="app sidebar-mini rtl">
<%@include file="/common/admin/header.jsp"%>
<%@include file="/common/admin/aside.jsp"%>

<main class="app-content">
    <div class="app-title">
        <ul class="app-breadcrumb breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/admin-auction-list">Quản Lý Đấu Giá</a>
            </li>
            <li class="breadcrumb-item active"><b>Thống Kê Doanh Thu</b></li>
        </ul>
        <div id="clock"></div>
    </div>

    <!-- ===== 4 Ô TỔNG QUAN ===== -->
    <div class="row">
        <div class="col-md-3">
            <div class="widget-small success coloured-icon">
                <i class="icon bx bx-money fa-3x"></i>
                <div class="info">
                    <h4>Tổng doanh thu đấu giá</h4>
                    <p>
                        <b>
                            <fmt:formatNumber value="${totalRevenue}" pattern="#,###"/> đ
                        </b>
                    </p>
                </div>
            </div>
        </div>
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
                    <h4>Đã hoàn thành (PAID)</h4>
                    <p><b>${countPaid} phiên</b></p>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== BIỂU ĐỒ + BẢNG ===== -->
    <div class="row">
        <!-- Biểu đồ Donut phân bố trạng thái -->
        <div class="col-md-4">
            <div class="tile">
                <h3 class="tile-title">Phân bố phiên theo trạng thái</h3>
                <div class="tile-body" style="text-align:center;">
                    <canvas id="statusChart" style="max-height:250px;"></canvas>
                </div>
            </div>
        </div>

        <!-- Bảng tóm tắt -->
        <div class="col-md-8">
            <div class="tile">
                <h3 class="tile-title">Danh sách tất cả phiên đấu giá</h3>
                <div class="tile-body">
                    <table class="table table-hover table-bordered table-sm" id="statsTable">
                        <thead class="thead-light">
                        <tr>
                            <th>#ID</th>
                            <th>Sách</th>
                            <th>Giá khởi điểm</th>
                            <th>Giá chốt</th>
                            <th>Số bid</th>
                            <th>Người thắng</th>
                            <th>Trạng thái</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="a" items="${allAuctions}">
                            <tr>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin-auction-detail?id=${a.id}">
                                        #${a.id}
                                    </a>
                                </td>
                                <td>${a.bookName}</td>
                                <td>
                                    <fmt:formatNumber value="${a.startPrice}" pattern="#,###"/> đ
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${a.currentPrice > a.startPrice}">
                                            <b style="color:#28a745;">
                                                <fmt:formatNumber value="${a.currentPrice}" pattern="#,###"/> đ
                                            </b>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Chưa có bid</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${a.totalBids}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty a.winnerName}">
                                            <i class="fas fa-trophy text-warning"></i>
                                            ${a.winnerName}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">—</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="badge ${a.statusBadge}">${a.statusLabel}</span>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/templates/admin/doc/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/main.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/plugins/jquery.dataTables.min.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/plugins/dataTables.bootstrap.min.js"></script>

<script>
    // Vẽ biểu đồ Donut phân bố trạng thái
    var ctx = document.getElementById('statusChart').getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Sắp diễn ra', 'Đang diễn ra', 'Đã kết thúc', 'Đã thanh toán'],
            datasets: [{
                data: [${countWaiting}, ${countActive}, ${countFinished}, ${countPaid}],
                backgroundColor: ['#ffc107', '#007bff', '#6c757d', '#28a745'],
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { position: 'bottom' }
            }
        }
    });

    // DataTable
    $('#statsTable').DataTable({
        "language": {
            "search": "Tìm kiếm:",
            "lengthMenu": "Hiển thị _MENU_ dòng",
            "paginate": {"previous": "Trước", "next": "Tiếp"}
        }
    });

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
</body>
</html>
