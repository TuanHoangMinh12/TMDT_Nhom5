<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
          integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css"
          integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/templates/styles/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/templates/styles/Author.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/templates/styles/Footer.css">
    <title>Tác giả</title>
    <style>
        .authors-page {
            margin: 24px 0 60px;
        }
        .authors-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 20px;
            margin-top: 16px;
        }
        @media (max-width: 992px) {
            .authors-grid { grid-template-columns: repeat(3, 1fr); }
        }
        @media (max-width: 600px) {
            .authors-grid { grid-template-columns: repeat(2, 1fr); }
        }
        .authors-grid .card_author {
            height: 100%;
        }
        .authors-grid .img_author {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        .authors-empty {
            text-align: center;
            color: #888;
            padding: 60px 0;
        }
    </style>
</head>

<body>
<%@include file="/common/web/header.jsp" %>

<div id="content">
    <div class="container">
        <nav id="breadcrumbbar">
            <ul class="breadcrumb">
                <li class="breadcrumb-item"><a class="chang_font" href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                <li class="breadcrumb-item active">Tác giả</li>
            </ul>
        </nav>

        <div class="authors-page">
            <div class="wrapper">
                <h1>Tất cả tác giả</h1>
            </div>

            <c:choose>
                <c:when test="${not empty listAuthor}">
                    <div class="authors-grid">
                        <c:forEach var="author" items="${listAuthor}">
                            <div class="card h-60 card_author">
                                <a href="${pageContext.request.contextPath}/author?id=${author.idAuthor}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(author.img, 'http')}">
                                            <img src="${author.img}" class="card-img-top img_author" alt="${author.name}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/${author.img}" class="card-img-top img_author" alt="${author.name}">
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="card-body">
                                        <h5 class="card-title title_author"><c:out value="${author.name}"/></h5>
                                    </div>
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="authors-empty">
                        <p>Hiện chưa có tác giả nào.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@include file="/common/web/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js"
        integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
        crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"
        crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/templates/scripts/header.js"></script>
</body>
</html>
