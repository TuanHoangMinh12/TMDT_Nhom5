<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đấu giá</title>

    <!-- Bootstrap -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

    <!-- Header & Footer CSS -->
    <link rel="stylesheet"
          href="<c:url value='/templates/styles/Header.css'/>">

    <link rel="stylesheet"
          href="<c:url value='/templates/styles/Footer.css'/>">

    <style>
        body{
            background:#f5f5f5;
        }

        .product-img{
            width:100%;
            border:1px solid #ddd;
            border-radius:5px;
        }

        .card{
            border:none;
            box-shadow:0 2px 8px rgba(0,0,0,.1);
        }

        #countdown{
            font-size:18px;
        }
    </style>

</head>

<body>

<%@include file="/common/web/header.jsp"%>

<div class="container" style="padding-top:120px; padding-bottom:50px;">

    <a href="${pageContext.request.contextPath}/auction"
       class="btn btn-secondary mb-4">
        ← Quay lại
    </a>

    <div class="card p-4">

        <h2 class="mb-4 text-center">
            Chi tiết phiên đấu giá
        </h2>

        <div class="row">

            <div class="col-md-4">

                <img
                        src="${pageContext.request.contextPath}/${auction.product.image}"
                        class="product-img"
                        alt="${auction.product.name}">

            </div>

            <div class="col-md-8">

                <h3>${auction.product.name}</h3>

                <table class="table table-bordered mt-3">

                    <tr>
                        <th width="30%">Giá khởi điểm</th>
                        <td><fmt:formatNumber value="${auction.startPrice}" pattern="#,##0"/> đ</td>
                    </tr>

                    <tr>
                        <th>Giá hiện tại</th>
                        <td class="text-danger font-weight-bold">
                            <fmt:formatNumber value="${auction.currentPrice}" pattern="#,##0"/> đ
                        </td>
                    </tr>

                    <tr>
                        <th>Bước giá</th>
                        <td><fmt:formatNumber value="${auction.minIncrement}" pattern="#,##0"/> đ</td>
                    </tr>

                    <tr>
                        <th>Bắt đầu</th>
                        <td>${auction.startTime}</td>
                    </tr>

                    <tr>
                        <th>Kết thúc</th>
                        <td>${auction.endTime}</td>
                    </tr>

                    <tr>
                        <th>Thời gian còn lại</th>
                        <td>
                            <span id="countdown"
                                  class="text-danger font-weight-bold"></span>
                        </td>
                    </tr>

                    <tr>
                        <th>Trạng thái</th>
                        <td>${auction.status}</td>
                    </tr>

                </table>

                <c:if test="${auction.status=='FINISHED'}">

                    <div class="alert alert-success">

                        <h5>Phiên đấu giá đã kết thúc</h5>

                        <p>
                            Người thắng:
                            <strong>${auction.winnerName}</strong>
                        </p>

                        <p>
                            Giá thắng:
                            <strong><fmt:formatNumber value="${auction.currentPrice}" pattern="#,##0"/> đ</strong>
                        </p>

                    </div>

                </c:if>

                <c:if test="${not empty param.message}">
                    <div class="alert alert-info">
                            ${param.message}
                    </div>
                </c:if>

                <c:if test="${auction.status=='ACTIVE'}">

                    <form action="${pageContext.request.contextPath}/auction-bid"
                          method="post">

                        <input type="hidden"
                               name="auctionId"
                               value="${auction.id}">

                        <div class="form-group">

                            <label>Nhập giá đấu</label>

                            <input type="number"
                                   name="price"
                                   class="form-control"
                                   min="${auction.currentPrice + auction.minIncrement}"
                                   required>

                            <small class="form-text text-muted">
                                Giá tối thiểu:
                                <fmt:formatNumber value="${auction.currentPrice + auction.minIncrement}" pattern="#,##0"/> đ
                            </small>

                        </div>

                        <button class="btn btn-primary btn-block">
                            Đặt giá
                        </button>

                    </form>

                </c:if>

            </div>

        </div>

    </div>

    <hr class="my-5">

    <h4 class="mb-3">
        Lịch sử đấu giá
    </h4>

    <table class="table table-bordered table-hover bg-white">

        <thead class="thead-dark">

        <tr>

            <th>Người đấu giá</th>
            <th>Giá</th>
            <th>Thời gian</th>

        </tr>

        </thead>

        <tbody>

        <c:choose>

            <c:when test="${not empty bidHistory}">

                <c:forEach items="${bidHistory}" var="bid">

                    <tr>

                        <td>
                                ${bid.customer.firstName}
                                ${bid.customer.lastName}
                        </td>

                        <td class="text-danger">
                            <fmt:formatNumber value="${bid.bidPrice}" pattern="#,##0"/> đ
                        </td>

                        <td>
                                ${bid.bidTime}
                        </td>

                    </tr>

                </c:forEach>

            </c:when>

            <c:otherwise>

                <tr>

                    <td colspan="3" class="text-center">
                        Chưa có lượt đấu giá nào
                    </td>

                </tr>

            </c:otherwise>

        </c:choose>

        </tbody>

    </table>

</div>

<%@include file="/common/web/footer.jsp"%>

<!-- JS -->

<script src="${pageContext.request.contextPath}/templates/scripts/header.js"></script>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

<script>

    const endTime = new Date("${auction.endTime}".replace(" ", "T")).getTime();

    function updateCountdown() {

        const now = new Date().getTime();

        const distance = endTime - now;

        if (distance <= 0) {

            document.getElementById("countdown").innerHTML = "Đã kết thúc";

            setTimeout(function () {
                location.reload();
            }, 1000);

            return;
        }

        const days = Math.floor(distance / (1000 * 60 * 60 * 24));

        const hours = Math.floor(
            (distance % (1000 * 60 * 60 * 24))
            / (1000 * 60 * 60)
        );

        const minutes = Math.floor(
            (distance % (1000 * 60 * 60))
            / (1000 * 60)
        );

        const seconds = Math.floor(
            (distance % (1000 * 60))
            / 1000
        );

        document.getElementById("countdown").innerHTML =
            days + " ngày " +
            hours + " giờ " +
            minutes + " phút " +
            seconds + " giây";
    }

    updateCountdown();

    setInterval(updateCountdown, 1000);

</script>

</body>
</html>