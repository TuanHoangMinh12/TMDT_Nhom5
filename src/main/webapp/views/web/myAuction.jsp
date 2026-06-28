<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>

<html>

<head>

    <title>Đấu giá của tôi</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

</head>

<body>

<div class="container mt-5">

    <h2>Đấu giá của tôi</h2>

    <table class="table table-bordered mt-4">

        <thead>

        <tr>

            <th>Ảnh</th>

            <th>Sách</th>

            <th>Giá thắng</th>

            <th>Trạng thái</th>

            <th></th>

        </tr>

        </thead>

        <tbody>

        <c:forEach items="${list}" var="a">

            <tr>

                <td width="120">

                    <img
                            src="${pageContext.request.contextPath}/${a.product.image}"
                            width="90">

                </td>

                <td>

                        ${a.product.name}

                </td>

                <td>

                        ${a.currentPrice} đ

                </td>

                <td>

                        ${a.status}

                </td>

                <td>

                    <a
                            class="btn btn-success"
                            href="${pageContext.request.contextPath}/auction-add-cart?id=${a.id}">

                        Thêm vào giỏ hàng

                    </a>

                </td>

            </tr>

        </c:forEach>

        <c:if test="${empty list}">

            <tr>

                <td colspan="5" align="center">

                    Bạn chưa thắng phiên đấu giá nào.

                </td>

            </tr>

        </c:if>

        </tbody>

    </table>

</div>

</body>

</html>