<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
  <link rel="stylesheet" href="css/login.css"/>
  <title>로그인</title>
</head>
<body>


    <iframe src="title.html" class="text-bg-frame" frameborder="0" scrolling="no"></iframe>
    

  <main id="form-container">

  <div id = "ani-container">

    <h2 class="form-title">로그인</h2>

    <iframe src="dog.html" width="250" height="270" style="border: none; background: transparent;" allowtransparency="true"></iframe>
    
    </div>
	<form action="Login.do" method="post" class="login-form">


	
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

		  <nav class="extra-links">
		    <a href="#" onclick="alert('아이디 찾기 기능은 아직 준비 중입니다.'); return false;">아이디 찾기</a>
		    <a href="#" onclick="alert('비밀번호 찾기 기능은 아직 준비 중입니다.'); return false;">비밀번호 찾기</a>
		    <a href="join.jsp">회원가입</a>
		  </nav>

	</form>
</main>

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
