<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đấu giá</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
</head>

<body>

<div class="container mt-5">

    <a href="${pageContext.request.contextPath}/auction"
       class="btn btn-secondary mb-3">
        ← Quay lại
    </a>

    <h2 class="mb-4">Chi tiết phiên đấu giá</h2>

    <div class="row">

        <div class="col-md-4">

            <img
                    src="${pageContext.request.contextPath}/${auction.product.image}"
                    class="img-fluid border">

        </div>

        <div class="col-md-8">

            <h3>${auction.product.name}</h3>

            <table class="table table-bordered mt-3">

                <tr>
                    <th>Giá khởi điểm</th>
                    <td>${auction.startPrice} đ</td>
                </tr>

                <tr>
                    <th>Giá hiện tại</th>
                    <td>${auction.currentPrice} đ</td>
                </tr>

                <tr>
                    <th>Bước giá</th>
                    <td>${auction.minIncrement} đ</td>
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
                        <span id="countdown" class="text-danger font-weight-bold"></span>
                    </td>
                </tr>
                <tr>
                    <th>Trạng thái</th>
                    <td>${auction.status}</td>
                </tr>

            </table>

            <c:if test="${not empty param.message}">
                <div class="alert alert-info">
                        ${param.message}
                </div>
            </c:if>

            <c:if test="${auction.status=='OPEN'}">

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

                    </div>

                    <button class="btn btn-primary">
                        Đặt giá
                    </button>

                </form>

            </c:if>

        </div>

    </div>

    <hr>

    <h4>Lịch sử đấu giá</h4>

    <table class="table table-bordered">

        <thead>

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

                        <td>${bid.customer.firstName} ${bid.customer.lastName}</td>

                        <td>${bid.bidPrice} đ</td>

                        <td>${bid.bidTime}</td>

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

</body>
</html>
<script>

    // Thời gian kết thúc lấy từ JSP
    const endTime = new Date("${auction.endTime}".replace(" ", "T")).getTime();

    function updateCountdown() {

        const now = new Date().getTime();

        const distance = endTime - now;

        if (distance <= 0) {

            document.getElementById("countdown").innerHTML = "Đã kết thúc";

            setTimeout(() => {
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
            days + " ngày "
            + hours + " giờ "
            + minutes + " phút "
            + seconds + " giây";
    }

    updateCountdown();

    setInterval(updateCountdown,1000);

</script>