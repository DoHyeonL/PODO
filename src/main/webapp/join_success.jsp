<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="css/join_success.css"/>
  <title>회원가입 완료</title>
</head>

<body>

<main class="success-box">
  <h2>🎉 회원가입이 완료되었습니다!</h2>

  <c:if test="${loginvo!=null}">
    <p><strong>${email}</strong> 님, 환영합니다!</p>
  </c:if>

  <a href="login.jsp" class="btn">로그인 페이지로 이동</a>
</main>

</body>
</html>
