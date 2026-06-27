<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>--%>

<%--<!DOCTYPE html>--%>
<%--<html lang="vi">--%>
<%--<head>--%>

<%--    <meta charset="UTF-8">--%>
<%--    <title>${auction.book.name}</title>--%>

<%--    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css">--%>
<%--    <link rel="stylesheet"--%>
<%--          href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">--%>

<%--</head>--%>

<%--<body>--%>

<%--<%@include file="/common/web/header.jsp"%>--%>

<%--<div class="container mt-5 mb-5">--%>

<%--    <div class="row">--%>

<%--        <!-- Ảnh sách -->--%>
<%--        <div class="col-md-5">--%>

<%--            <img class="img-fluid border rounded"--%>
<%--                 src="${pageContext.request.contextPath}/${pageContext.request.contextPath}/${auction.product.image}">--%>

<%--        </div>--%>

<%--        <!-- Thông tin -->--%>
<%--        <div class="col-md-7">--%>

<%--            <h2>${auction.product.name}</h2>--%>

<%--            <hr>--%>

<%--            <h4 class="text-danger">--%>

<%--                Giá hiện tại:--%>
<%--                ${auction.currentPrice} đ--%>

<%--            </h4>--%>
<%--            <c:if test="${message!=null}">--%>

<%--                <div class="alert alert-danger">--%>

<%--                        ${message}--%>

<%--                </div>--%>

<%--            </c:if>--%>
<%--            <c:if test="${auction.status=='OPEN'}">--%>

<%--                <form action="${pageContext.request.contextPath}/auction/bid"--%>
<%--                      method="post">--%>

<%--                    <input--%>
<%--                            type="hidden"--%>
<%--                            name="auctionId"--%>
<%--                            value="${auction.id}">--%>

<%--                    <div class="form-group mt-3">--%>

<%--                        <label>Nhập giá đấu</label>--%>

<%--                        <input--%>
<%--                                type="number"--%>
<%--                                name="price"--%>
<%--                                class="form-control"--%>
<%--                                step="1000"--%>
<%--                                min="${auction.currentPrice + auction.minIncrement}"--%>
<%--                                required>--%>

<%--                    </div>--%>

<%--                    <button--%>
<%--                            class="btn btn-danger mt-2">--%>

<%--                        Đấu giá--%>

<%--                    </button>--%>

<%--                </form>--%>

<%--            </c:if>--%>

<%--            <p>--%>
<%--                <b>Giá khởi điểm:</b>--%>
<%--                ${auction.startPrice} đ--%>
<%--            </p>--%>

<%--            <p>--%>
<%--                <b>Bước giá:</b>--%>
<%--                ${auction.minIncrement} đ--%>
<%--            </p>--%>

<%--            <p>--%>
<%--                <b>Bắt đầu:</b>--%>
<%--                ${auction.startTime}--%>
<%--            </p>--%>

<%--            <p>--%>
<%--                <b>Kết thúc:</b>--%>
<%--                ${auction.endTime}--%>
<%--            </p>--%>

<%--            <c:choose>--%>

<%--                <c:when test="${auction.status == 'RUNNING'}">--%>

<%--                    <span class="badge badge-success p-2">--%>
<%--                        Đang diễn ra--%>
<%--                    </span>--%>

<%--                </c:when>--%>

<%--                <c:when test="${auction.status == 'WAITING'}">--%>

<%--                    <span class="badge badge-warning p-2">--%>
<%--                        Chưa bắt đầu--%>
<%--                    </span>--%>

<%--                </c:when>--%>

<%--                <c:otherwise>--%>

<%--                    <span class="badge badge-danger p-2">--%>
<%--                        Đã kết thúc--%>
<%--                    </span>--%>

<%--                </c:otherwise>--%>

<%--            </c:choose>--%>

<%--            <hr>--%>

<%--            <!-- Giai đoạn 7 sẽ submit vào đây -->--%>
<%--            <form action="${pageContext.request.contextPath}/auction/bid"--%>
<%--                  method="post">--%>

<%--                <input type="hidden"--%>
<%--                       name="auctionId"--%>
<%--                       value="${auction.id}">--%>

<%--                <div class="form-group">--%>

<%--                    <label>Nhập giá đấu</label>--%>

<%--                    <input--%>
<%--                            type="number"--%>
<%--                            class="form-control"--%>
<%--                            name="price"--%>
<%--                            min="${auction.currentPrice + auction.minIncrement}"--%>
<%--                            required>--%>

<%--                </div>--%>

<%--                <button class="btn btn-danger">--%>

<%--                    Đặt giá--%>

<%--                </button>--%>

<%--            </form>--%>

<%--        </div>--%>

<%--    </div>--%>

<%--    <hr class="mt-5">--%>

<%--    <h3>Lịch sử đấu giá</h3>--%>

<%--    <table class="table table-bordered table-hover mt-3">--%>

<%--        <thead class="thead-dark">--%>

<%--        <tr>--%>

<%--            <th>Người đấu</th>--%>

<%--            <th>Giá</th>--%>

<%--            <th>Thời gian</th>--%>

<%--        </tr>--%>

<%--        </thead>--%>

<%--        <tbody>--%>

<%--        <c:forEach items="${bidHistory}" var="bid">--%>

<%--            <tr>--%>

<%--                <td>--%>

<%--                        ${bid.customer.firstName}--%>
<%--                        ${bid.customer.lastName}--%>

<%--                </td>--%>

<%--                <td class="text-danger">--%>

<%--                        ${bid.bidPrice} đ--%>

<%--                </td>--%>

<%--                <td>--%>

<%--                        ${bid.bidTime}--%>

<%--                </td>--%>

<%--            </tr>--%>

<%--        </c:forEach>--%>

<%--        <c:if test="${empty bidHistory}">--%>

<%--            <tr>--%>

<%--                <td colspan="3" class="text-center">--%>

<%--                    Chưa có ai đấu giá--%>

<%--                </td>--%>

<%--            </tr>--%>

<%--        </c:if>--%>

<%--        </tbody>--%>

<%--    </table>--%>

<%--</div>--%>

<%--<%@include file="/common/web/footer.jsp"%>--%>

<%--</body>--%>
<%--</html>--%>