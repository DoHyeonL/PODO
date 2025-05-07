<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>로그인</title>
  <style>

    .form-title {
      text-align: center;
      font-size: 24px;
      font-weight: bold;
      color: #333;
      margin-bottom: 24px;
    }

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

    .login-form {
      background: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
      width: 100%;
      max-width: 400px;
      display: flex;
      flex-direction: column;
    }

    .form-group {
      display: flex;
      flex-direction: column;
      margin-bottom: 16px;
    }

    .form-group label {
      font-size: 14px;
      margin-bottom: 8px;
      color: #333;
    }

    .input-field {
      height: 44px;
      padding: 0 12px;
      font-size: 16px;
      border: 1px solid #ccc;
      border-radius: 8px;
      outline: none;
      box-sizing: border-box;
      transition: border-color 0.3s, box-shadow 0.3s;
      background: white;
    }

    .btn {
      background-color: #6e67cf;
      color: white;
      border: none;
      padding: 12px;
      border-radius: 8px;
      cursor: pointer;
      transition: background 0.3s;
      font-size: 16px;
    }

    .btn:hover {
      background-color: #8cd875;
    }

    .extra-links {
      display: flex;
      justify-content: space-between;
      font-size: 14px;
      margin-top: 10px;
    }

    .extra-links a {
      text-decoration: none;
      color: #6e67cf;
    }

    
  </style>
</head>
<body>

<form action="Login.do" method="post" class="login-form">

  <h2 class="form-title">로그인</h2>

  <div class="form-group">
    <label for="id">아이디</label>
    <input type="text" id="user_id" name="user_id" class="input-field" placeholder="아이디 입력">
  </div>

  <div class="form-group">
    <label for="password">비밀번호</label>
    <input type="password" id="password" name="password" class="input-field" placeholder="비밀번호 입력">
  </div>

  <button type="submit" class="btn">로그인</button>
  <c:if test="${loginv!=errorMsg}">
  <div style="color: red; margin-bottom: 10px;">
    ${errorMsg}
  </div>
</c:if>

  <div class="extra-links">
    <a href="#">아이디 찾기</a>
    <a href="#">비밀번호 찾기</a>
    <a href="join.jsp">회원가입</a>
  </div>

</form>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    const form = document.querySelector('.login-form');
    const user_idInput = document.getElementById('user_id');
    const passwordInput = document.getElementById('password');

    form.addEventListener('submit', function (e) {
      if (!user_idInput.value.trim() || !passwordInput.value.trim()) {
        e.preventDefault(); // 폼 전송 막기
        alert('아이디와 비밀번호를 모두 입력해주세요.');
      }
    });
  });

  
</script>
</body>
</html>
