<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="vi">

<head>

    <meta charset="UTF-8">

    <title>Đấu giá của tôi</title>

    <!-- Bootstrap -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

    <!-- Header -->
    <link rel="stylesheet"
          href="<c:url value='/templates/styles/Header.css'/>">

    <!-- Footer -->
    <link rel="stylesheet"
          href="<c:url value='/templates/styles/Footer.css'/>">

    <style>

        body{
            background:#f5f5f5;
        }

        .card{
            border:none;
            box-shadow:0 2px 8px rgba(0,0,0,.1);
        }

        .table img{
            width:90px;
            height:120px;
            object-fit:cover;
            border-radius:5px;
        }

        h2{
            font-weight:bold;
        }

    </style>

</head>

<body>

<%@include file="/common/web/header.jsp"%>

<div class="container" style="padding-top:120px;padding-bottom:50px;">

    <div class="card p-4">

        <h2 class="text-center mb-4">
            ĐẤU GIÁ CỦA TÔI
        </h2>

        <table class="table table-bordered table-hover">

            <thead class="thead-dark">

            <tr>

                <th width="120">Ảnh</th>

                <th>Tên sách</th>

                <th width="180">Giá thắng</th>

                <th width="150">Trạng thái</th>

                <th width="220">Thao tác</th>

            </tr>

            </thead>

            <tbody>

            <c:choose>

                <c:when test="${not empty list}">

                    <c:forEach items="${list}" var="a">

                        <tr>

                            <td>

                                <c:choose>
                                    <c:when test="${fn:startsWith(a.product.image, 'http')}">
                                        <img
                                                src="${a.product.image}"
                                                alt="${a.product.name}">
                                    </c:when>
                                    <c:otherwise>
                                        <img
                                                src="${pageContext.request.contextPath}/${a.product.image}"
                                                alt="${a.product.name}">
                                    </c:otherwise>
                                </c:choose>

                            </td>

                            <td>

                                    ${a.product.name}

                            </td>

                            <td class="text-danger font-weight-bold">

                                    ${a.currentPrice} đ

                            </td>

                            <td>

                                    ${a.status}

                            </td>

                            <td>

                                <a class="btn btn-success btn-block"
                                   href="${pageContext.request.contextPath}/auction-add-cart?id=${a.id}">

                                    Thêm vào giỏ hàng

                                </a>

                            </td>

                        </tr>

                    </c:forEach>

                </c:when>

                <c:otherwise>

                    <tr>

                        <td colspan="5" class="text-center">

                            Bạn chưa thắng phiên đấu giá nào.

                        </td>

                    </tr>

                </c:otherwise>

            </c:choose>

            </tbody>

        </table>

    </div>

</div>

<%@include file="/common/web/footer.jsp"%>

<script src="${pageContext.request.contextPath}/templates/scripts/header.js"></script>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>
