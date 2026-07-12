<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
  <title>로그인</title>
  <style>


        @font-face {
          font-family: 'yg-jalnan';
          src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_four@1.2/JalnanOTF00.woff') format('woff');
          font-weight: normal;
          font-style: normal;
      }


        .text-bg-frame {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: 0;
            pointer-events: none; /* 클릭 방지 */
        }

        .background-frame {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: 0;
            pointer-events: none; /* 클릭 방지 - 지도 등 UI 방해 안 되게 */
        }





        html,body {
            margin-top: 0;
            height: 100%;
 
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Helvetica Neue', sans-serif;
            margin: 0;
        }

    
        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

 

    #form-container {
        
        background-color: #ffffff;
        width: 600px;
        height: 100%;
        position: absolute;
        margin-left: 50px;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        
        overflow: hidden;

        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
    }
    
    #ani-container{
      opacity: 0; /* 초기 상태 */
      animation: fadeIn 1s ease forwards;
      animation-delay: 0.3s;
    }


    .form-title {
      text-align: center;
      font-size: 33px;
      font-weight: bold;
      color: #333;
      margin-bottom: -30px;
      font-family: 'yg-jalnan';
    }

 

    .login-form {
      background: white;
      padding: 30px;
      border-radius: 12px;
      width: 100%;
      height: 400px;
      max-width: 400px;
      display: flex;
      flex-direction: column;


      opacity: 0; /* 초기 상태 */
      animation: fadeIn 1s ease forwards;
      animation-delay: 0.3s;
      
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
      margin-top: 8px;
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
      margin-top: 20px;
    }

    .extra-links a {
      text-decoration: none;
      color: #6e67cf;
    }

    
  </style>
</head>
<body>


    <iframe src="title.html" class="text-bg-frame" frameborder="0" scrolling="no"></iframe>
    

  <div id="form-container">
  
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
		
		  <div class="extra-links">
		    <a href="#" onclick="alert('아이디 찾기 기능은 아직 준비 중입니다.'); return false;">아이디 찾기</a>
		    <a href="#" onclick="alert('비밀번호 찾기 기능은 아직 준비 중입니다.'); return false;">비밀번호 찾기</a>
		    <a href="join.jsp">회원가입</a>
		  </div>

	</form>
</div>

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
