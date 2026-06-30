<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thông báo</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

</head>
<body>

<div class="container mt-5">

    <h3>Thông báo đấu giá</h3>

    <table class="table table-bordered">

        <tr>
            <th>Tiêu đề</th>
            <th>Nội dung</th>
            <th>Thời gian</th>
        </tr>

        <c:forEach items="${notifications}" var="n">

            <tr>

                <td>${n.title}</td>

                <td>${n.content}</td>

                <td>${n.createdAt}</td>

            </tr>

        </c:forEach>

    </table>

</div>

</body>
</html>