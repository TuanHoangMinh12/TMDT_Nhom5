<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
          integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css"
          integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/templates/styles/Login.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/templates/styles/Home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/templates/styles/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/templates/styles/Footer.css">
    <title>Thông báo của tôi</title>
    <style>
        .noti-page {
            max-width: 760px;
            margin: 24px auto 60px;
        }
        .noti-page_title {
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 16px;
        }
        .noti-card {
            display: block;
            background: #fff;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 14px 16px;
            margin-bottom: 10px;
            text-decoration: none;
            color: #333;
            transition: box-shadow .2s ease;
        }
        .noti-card:hover {
            box-shadow: 0 2px 8px rgba(0,0,0,.08);
            text-decoration: none;
            color: #333;
        }
        .noti-card.unread {
            background: #fff7e6;
            border-color: #ffd591;
        }
        .noti-card_title {
            font-weight: 700;
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .noti-card_title .dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #ff4d4f;
            display: inline-block;
        }
        .noti-card_content {
            font-size: 14px;
            color: #555;
            margin-bottom: 6px;
        }
        .noti-card_time {
            font-size: 12px;
            color: #999;
        }
        .noti-empty {
            text-align: center;
            color: #888;
            padding: 60px 0;
        }
    </style>
</head>

<body>
<%@include file="/common/web/header.jsp" %>

<div class="noti-page">
    <div class="noti-page_title">Thông báo của tôi</div>

    <c:choose>
        <c:when test="${not empty listNotification}">
            <c:forEach var="n" items="${listNotification}">
                <a class="noti-card ${n.isRead == 0 ? 'unread' : ''}"
                   href="${pageContext.request.contextPath}/notification/read?id=${n.id}">
                    <div class="noti-card_title">
                        <c:if test="${n.isRead == 0}"><span class="dot"></span></c:if>
                        <c:out value="${n.title}"/>
                    </div>
                    <div class="noti-card_content"><c:out value="${n.content}"/></div>
                    <div class="noti-card_time">
                        <fmt:formatDate value="${n.createdAt}" pattern="HH:mm dd/MM/yyyy"/>
                    </div>
                </a>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="noti-empty">
                <i class="fa-regular fa-bell-slash" style="font-size:40px;"></i>
                <p style="margin-top:10px;">Bạn chưa có thông báo nào.</p>
            </div>
        </c:otherwise>
    </c:choose>
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
