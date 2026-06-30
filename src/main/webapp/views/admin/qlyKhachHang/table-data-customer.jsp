<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Danh sách khách hàng | Quản trị Admin</title>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/templates/admin/doc/css/main.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.js"></script>
  <style>
    .badge-status {
      display: inline-block;
      padding: 3px 10px;
      border-radius: 12px;
      font-size: 12px;
      font-weight: 600;
    }
    /* status = 1: Hoạt động */
    .badge-active { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    /* status = 2: Bị khóa */
    .badge-locked { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    /* status = 0: Chưa kích hoạt (email chưa xác nhận) */
    .badge-inactive { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
  </style>
</head>

<body onload="time()" class="app sidebar-mini rtl">
<%@include file="/common/admin/header.jsp"%>
<%@include file="/common/admin/aside.jsp"%>

<main class="app-content">
  <div class="app-title">
    <ul class="app-breadcrumb breadcrumb side">
      <li class="breadcrumb-item active"><a href="#"><b>Danh sách khách hàng</b></a></li>
    </ul>
    <div id="clock"></div>
  </div>

  <%-- Thông báo kết quả sau lock/unlock/update --%>
  <c:if test="${not empty message}">
    <div class="alert alert-${alert} alert-dismissible" role="alert" style="margin: 0 15px 10px;">
      <button type="button" class="close" data-dismiss="alert">&times;</button>
      <i class="fas ${alert == 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'}"></i>
        ${message}
    </div>
  </c:if>

  <div class="row">
    <div class="col-md-12">
      <div class="tile">
        <div class="tile-body">
          <table class="table table-hover table-bordered" id="sampleTable">
            <thead>
            <tr>
              <th>Mã KH</th>
              <th>Tên khách hàng</th>
              <th>Số điện thoại</th>
              <th>Địa chỉ</th>
              <th>Tổng đơn hàng</th>
              <th>Trạng thái</th><%-- CỘT MỚI --%>
              <th>Chức năng</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="customer" items="${listCustomer}">
              <tr>
                <td>${customer.idUser}</td>
                <td>${customer.fullName}</td>
                <td>${customer.phone}</td>
                <td>${customer.address}</td>
                <td>${customer.totalBill}</td>

                  <%--
                      STATUS trong bảng customer:
                        0 = Chưa kích hoạt (email chưa xác nhận)
                        1 = Hoạt động bình thường
                        2 = Bị khóa bởi Admin
                  --%>
                <td>
                  <c:choose>
                    <c:when test="${customer.status == 1}">
                      <span class="badge bg-success" style="padding: 5px 10px; border-radius: 5px;">Hoạt động</span>
                    </c:when>
                    <c:when test="${customer.status == 2}">
                      <span class="badge bg-danger" style="padding: 5px 10px; border-radius: 5px;">Bị khóa</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-secondary" style="padding: 5px 10px; border-radius: 5px;">Không xác định</span>
                    </c:otherwise>
                  </c:choose>
                </td>

                <td>
                  <button class="btn btn-danger btn-sm" type="button" title="Xóa"
                          onclick="confirmDelete(${customer.idUser}, '${customer.firstName} ${customer.lastName}')">
                    <i class="fas fa-trash-alt"></i>
                  </button>

                  <button class="btn btn-primary btn-sm edit-btn" type="button" title="Sửa"
                          data-id="${customer.idUser}"
                          data-fname="${customer.firstName}"
                          data-lname="${customer.lastName}"
                          data-phone="${customer.phone}"
                          data-address="${customer.address}"
                          data-toggle="modal" data-target="#editModal">
                    <i class="fas fa-edit"></i>
                  </button>

                  <c:if test="${customer.status == 1}">
                    <button class="btn btn-warning btn-sm" type="button" title="Khóa" onclick="confirmLock(${customer.idUser}, '${customer.firstName} ${customer.lastName}')">
                      <i class="fas fa-lock"></i>
                    </button>
                  </c:if>
                  <c:if test="${customer.status == 2}">
                    <button class="btn btn-success btn-sm" type="button" title="Mở khóa" onclick="confirmUnlock(${customer.idUser}, '${customer.firstName} ${customer.lastName}')">
                      <i class="fas fa-unlock"></i>
                    </button>
                  </c:if>
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

<%-- Form ẩn: submit POST tới /lock-customer --%>
<form id="lockForm" method="post"
      action="${pageContext.request.contextPath}/lock-customer">
  <input type="hidden" name="idUser" id="lockUserId" value="">
  <input type="hidden" name="action" id="lockAction" value="">
</form>

<div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title">Chỉnh Sửa Thông Tin Khách Hàng</h5>
        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form action="${pageContext.request.contextPath}/update-customer" method="POST">
        <div class="modal-body">
          <input type="hidden" name="idUser" id="edit-id">
          <div class="row">
            <div class="form-group col-md-6">
              <label class="control-label">Họ</label>
              <input class="form-control" type="text" name="firstName" id="edit-fname" required>
            </div>
            <div class="form-group col-md-6">
              <label class="control-label">Tên</label>
              <input class="form-control" type="text" name="lastName" id="edit-lname" required>
            </div>
          </div>
          <div class="form-group">
            <label class="control-label">Số điện thoại</label>
            <input class="form-control" type="text" name="phone" id="edit-phone" required>
          </div>
          <div class="form-group">
            <label class="control-label">Địa chỉ</label>
            <textarea class="form-control" name="address" id="edit-address" rows="3" required></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy bỏ</button>
          <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/templates/admin/doc/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/main.js"></script>
<script src="${pageContext.request.contextPath}/templates/admin/doc/js/plugins/pace.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/templates/admin/doc/js/plugins/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/templates/admin/doc/js/plugins/dataTables.bootstrap.min.js"></script>

<script>
  $('#sampleTable').DataTable({
    "language": {
      "search":     "Tìm kiếm:",
      "lengthMenu": "Hiển thị _MENU_ khách hàng",
      "info":       "Hiển thị _START_ đến _END_ trong _TOTAL_ khách hàng",
      "paginate":   { "previous": "Trước", "next": "Tiếp" }
    }
  });

  // Xác nhận KHÓA tài khoản
  function confirmLock(idUser, fullName) {
    swal({
      title: "Xác nhận khóa tài khoản?",
      text: "Bạn có chắc muốn KHÓA tài khoản của \"" + fullName + "\"?\n"
              + "Người này sẽ không thể đăng nhập cho đến khi được mở khóa.",
      icon: "warning",
      buttons: ["Hủy bỏ", "Đồng ý khóa"],
      dangerMode: true
    }).then(function(willLock) {
      if (willLock) {
        document.getElementById("lockUserId").value = idUser;
        document.getElementById("lockAction").value = "lock";
        document.getElementById("lockForm").submit();
      }
    });
  }

  // Xác nhận MỞ KHÓA tài khoản
  function confirmUnlock(idUser, fullName) {
    swal({
      title: "Mở khóa tài khoản?",
      text: "Bạn có chắc muốn MỞ KHÓA tài khoản của \"" + fullName + "\"?",
      icon: "info",
      buttons: ["Hủy bỏ", "Đồng ý mở khóa"]
    }).then(function(willUnlock) {
      if (willUnlock) {
        document.getElementById("lockUserId").value = idUser;
        document.getElementById("lockAction").value = "unlock";
        document.getElementById("lockForm").submit();
      }
    });
  }

  // 1. Đổ dữ liệu vào Modal khi bấm nút Sửa
  $(document).on('click', '.edit-btn', function() {
    $('#edit-id').val($(this).data('id'));
    $('#edit-fname').val($(this).data('fname'));
    $('#edit-lname').val($(this).data('lname'));
    $('#edit-phone').val($(this).data('phone'));
    $('#edit-address').val($(this).data('address'));
  });

  // 2. SweetAlert xác nhận XÓA
  function confirmDelete(idUser, fullName) {
    swal({
      title: "Cảnh báo Xóa!",
      text: "Bạn có chắc chắn muốn xóa khách hàng " + fullName + " vĩnh viễn? Dữ liệu không thể khôi phục!",
      icon: "warning",
      buttons: ["Hủy bỏ", "Đồng ý Xóa"],
      dangerMode: true,
    }).then((willDelete) => {
      if (willDelete) {
        // Chuyển hướng tới Servlet xóa
        window.location.href = "${pageContext.request.contextPath}/delete-customer?idUser=" + idUser;
      }
    });
  }

  // Đồng hồ (giữ nguyên từ code cũ)
  function time() {
    var today   = new Date();
    var weekday = ["Chủ Nhật","Thứ Hai","Thứ Ba","Thứ Tư","Thứ Năm","Thứ Sáu","Thứ Bảy"];
    var dd  = String(today.getDate()).padStart(2,'0');
    var mm  = String(today.getMonth()+1).padStart(2,'0');
    var h   = String(today.getHours()).padStart(2,'0');
    var m   = String(today.getMinutes()).padStart(2,'0');
    var s   = String(today.getSeconds()).padStart(2,'0');
    document.getElementById("clock").innerHTML =
            '<span class="date">' + weekday[today.getDay()] + ', '
            + dd + '/' + mm + '/' + today.getFullYear()
            + ' - ' + h + ' giờ ' + m + ' phút ' + s + ' giây</span>';
    setTimeout("time()", 1000);
  }
</script>
</body>
</html>
