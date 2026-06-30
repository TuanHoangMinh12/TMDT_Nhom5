<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách đấu giá</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<c:url value='/templates/styles/Header.css'/>">
    <link rel="stylesheet" href="<c:url value='/templates/styles/Footer.css'/>">

    <style>
        body{ background:#f5f5f5; }
        .card{ margin-bottom:20px; }
        .card img{ height:250px; object-fit:cover; }

        .auction-price-wrap{
            display:flex;
            align-items:center;
            gap:8px;
        }
        .auction-price{
            color:#e53935;
            font-weight:bold;
            margin:0;
            white-space:normal;   /* không cắt chữ */
            overflow:visible;
            width:auto;
            max-width:none;
        }
    </style>
</head>
<body>
<%@include file="/common/web/header.jsp"%>
<div class="container" style="padding-top:120px;">
    <h2 class="text-center mb-4">DANH SÁCH ĐẤU GIÁ</h2>

    <div class="row">
        <c:forEach items="${listAuction}" var="auction">
            <div class="col-md-3">
                <div class="card">
                    <c:choose>
                        <c:when test="${fn:startsWith(auction.product.image, 'http')}">
                            <img class="card-img-top"
                                 src="${auction.product.image}"
                                 alt="${auction.product.name}">
                        </c:when>
                        <c:otherwise>
                            <img class="card-img-top"
                                 src="${pageContext.request.contextPath}/${auction.product.image}"
                                 alt="${auction.product.name}">
                        </c:otherwise>
                    </c:choose>

                    <div class="card-body">
                        <h5 class="card-title">${auction.product.name}</h5>

                        <p>
                            <strong>Giá hiện tại:</strong><br>
                            <span class="auction-price-wrap">
                                <span class="auction-price">
                                    <fmt:formatNumber value="${auction.currentPrice}" pattern="#,##0"/>đ
                                </span>
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

<%@include file="/common/web/footer.jsp"%>
<script src="${pageContext.request.contextPath}/templates/scripts/header.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
