<%--
  Created by IntelliJ IDEA.
  User: ndl22
  Date: 12/11/2022
  Time: 8:44 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
        integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css"
        integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
  <link
          href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;0,800;1,300;1,400;1,500;1,600;1,700&display=swap"
          rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick.min.css"
        integrity="sha512-yHknP1/AwR+yx26cB1y0cjvQUMvEa2PFzt1c9LlS4pRQ5NOTZFWbhBig+X9G9eYW/8m0/4OXNx8pxJ6z57x0dw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/templates/styles/Header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/templates/styles/Author.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/templates/styles/Footer.css">
  <title><c:out value="${authorModel.name}"/></title>
</head>

<body>
<!-- -----------phần header----------------  -->
<%@include file="/common/web/header.jsp"%>
<!--------- end header---------- -->
<div id="content">
  <div class="container">
    <nav id="breadcrumbbar">
      <ul class="breadcrumb">
        <li class="breadcrumb-item"><a class="chang_font" href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
        <li class="breadcrumb-item active"><c:out value="${authorModel.name}"/></li>
      </ul>
    </nav>
    <div class="wrapper">
      <h1>TÁC GIẢ</h1>
    </div>
    <div class="content_container">
      <h1><c:out value="${authorModel.name}"/></h1>
      <div class="content_author">
        <div class="img_author">
          <c:choose>
            <c:when test="${not empty authorModel.img}">
              <c:choose>
                <c:when test="${fn:startsWith(authorModel.img, 'http')}">
                  <img src="${authorModel.img}" alt="${authorModel.name}">
                </c:when>
                <c:otherwise>
                  <img src="${pageContext.request.contextPath}/${authorModel.img}" alt="${authorModel.name}">
                </c:otherwise>
              </c:choose>
            </c:when>
            <c:otherwise>
              <img src="${pageContext.request.contextPath}/templates/images/author/default-author.png" alt="${authorModel.name}">
            </c:otherwise>
          </c:choose>
        </div>
        <div class="author_info">
          <c:choose>
            <c:when test="${not empty listInformation}">
              <c:forEach var="doan" items="${listInformation}">
                <p><c:out value="${doan}"/></p>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <p>Hiện chưa có thông tin giới thiệu cho tác giả này.</p>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <c:if test="${not empty listBookOfAuthor}">
        <div class="wrapper" style="margin-top: 32px;">
          <h1>Sách của <c:out value="${authorModel.name}"/></h1>
        </div>
        <div class="row" style="margin-top: 16px;">
          <c:forEach var="book" items="${listBookOfAuthor}">
            <div class="col-6 col-md-3 col-lg-2" style="margin-bottom: 24px;">
              <div class="card h-100">
                <a href="${pageContext.request.contextPath}/products/product-detail?id=${book.idBook}">
                  <c:if test="${book.discount != 0}">
                    <span class="card_sale active_sale">-${book.discount}%</span>
                  </c:if>
                  <c:choose>
                    <c:when test="${fn:startsWith(book.image, 'http')}">
                      <img src="${book.image}" class="card-img-top" alt="...">
                    </c:when>
                    <c:otherwise>
                      <img src="${pageContext.request.contextPath}/${book.image}" class="card-img-top" alt="...">
                    </c:otherwise>
                  </c:choose>
                  <div class="card-body">
                    <h5 class="card-title title_book"><c:out value="${book.name}"/></h5>
                    <div class="container_price">
                      <p class="card-text_price">${book.priceDiscount}đ</p>
                      <c:if test="${book.discount != 0}">
                        <p style="text-decoration: line-through;" class="card-text_price--sale">${book.price}đ</p>
                      </c:if>
                    </div>
                  </div>
                </a>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:if>

      <c:if test="${empty listBookOfAuthor}">
        <p class="text-muted" style="margin-top: 24px;">Hiện chưa có sách nào của tác giả này.</p>
      </c:if>
    </div>
  </div>
</div>
<!-----footer------>

<%@include file="/common/web/footer.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js"
        integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
        crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"
        integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN"
        crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js"
        integrity="sha384-+sLIOodYLS7CIrQpBjl+C7nPvqq+FbNUBDunl/OZv93DB7Ln/533i8e/mZXLi/P+"
        crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct"
        crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/templates/scripts/header.js"></script>

</body>

</html>