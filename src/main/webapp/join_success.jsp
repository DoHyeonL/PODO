<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>회원가입 완료</title>
  <style>
    body {
      background: linear-gradient(135deg, #98cebc5e, #ACB6E5);
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      font-family: 'Helvetica Neue', sans-serif;
      margin: 0;
      padding: 20px;
    }

    .success-box {
      background: white;
      padding: 40px 30px;
      border-radius: 12px;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
      text-align: center;
      max-width: 400px;
      width: 100%;
    }

    .success-box h2 {
      font-size: 24px;
      margin-bottom: 20px;
      color: #333;
    }

    .success-box p {
      font-size: 16px;
      color: #555;
      margin-bottom: 30px;
    }

    .btn {
      background-color: #6e67cf;
      color: white;
      border: none;
      padding: 12px 24px;
      border-radius: 8px;
      cursor: pointer;
      font-size: 16px;
      transition: background 0.3s;
      text-decoration: none;
      display: inline-block;
    }

    .btn:hover {
      background-color: #8cd875;
    }
  </style>
</head>

<body>

<div class="success-box">
  <h2>🎉 회원가입이 완료되었습니다!</h2>

  <c:if test="${loginvo!=null}">
    <p><strong>${email}</strong> 님, 환영합니다!</p>
  </c:if>

  <a href="login.jsp" class="btn">로그인 페이지로 이동</a>
</div>

</body>
</html>
