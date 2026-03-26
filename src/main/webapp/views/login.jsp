<%@ include file="/common/taglib.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<head>
    <title>Login</title>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
          integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
    <link
            href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;0,800;1,300;1,400;1,500;1,600;1,700&display=swap"
            rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css" />


    <style>
        ._4z_d ._4z_f {
            font-size: 16px!important;
            line-height: 14px;
            padding: 2px 6px;
        }
    </style>
</head>


<!--------- login form---------- -->
<div class="login">
    <div class="login-title">Đăng nhập</div>
    <form  class="form_login"  method="post">
        <div class="input ">
            <label>Email</label>
            <input type="text" name="email" placeholder="Nhập vào email" id="email" onchange="emailOnChange(this.value)">
            <i class="fa-solid fa-circle-check"></i>
            <i class="fa-solid fa-circle-xmark"></i>
            <small>Error</small>
        </div>
        <div class="input ">
            <label>Mật khẩu</label>
            <input type="password" name="password" placeholder="Nhập vào mật khẩu" id="password"
                 >
            <i class="fa-solid fa-circle-check"></i>
            <i class="fa-solid fa-circle-xmark"></i>
            <small>Error</small>
        </div>

    </form>
</div>
<!-----end login---->
<!-----footer------>



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
<script src="/templates/scripts/login.js"></script>
<script src="/templates/scripts/header.js"></script>
<script>

</script>


</html>