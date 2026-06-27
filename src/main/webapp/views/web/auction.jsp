<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách đấu giá</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

    <style>
        body{
            background:#f5f5f5;
        }

        .card{
            margin-bottom:20px;
        }

        .card img{
            height:250px;
            object-fit:cover;
        }
    </style>
</head>

<body>

<div class="container mt-5">

    <h2 class="text-center mb-4">
        DANH SÁCH ĐẤU GIÁ
    </h2>

    <div class="row">

        <c:forEach items="${listAuction}" var="auction">

            <div class="col-md-3">

                <div class="card">

                    <img class="card-img-top"
                         src="${pageContext.request.contextPath}/${auction.product.image}"
                         alt="Book">

                    <div class="card-body">

                        <h5 class="card-title">
                                ${auction.product.name}
                        </h5>

                        <p>
                            <strong>Giá hiện tại:</strong><br>
                            <span class="text-danger">
                                ${auction.currentPrice} đ
                            </span>
                        </p>

                        <p>
                            <strong>Kết thúc:</strong><br>
                                ${auction.endTime}
                        </p>

                        <a href="${pageContext.request.contextPath}/auction-detail?id=${auction.id}"
                           class="btn btn-primary btn-block">
                            Xem chi tiết
                        </a>

                    </div>

                </div>

            </div>

        </c:forEach>

    </div>

    <c:if test="${empty listAuction}">
        <div class="alert alert-warning text-center">
            Chưa có phiên đấu giá nào.
        </div>
    </c:if>

</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>