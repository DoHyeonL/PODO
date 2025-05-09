<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>로그인</title>
  <style>


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
        width: 550px;
        height: 100%;
        position: absolute;
        margin-left: 250px;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        
        overflow: hidden;

        display: flex;
        justify-content: center;
        align-items: center;
    }


    .form-title {
      text-align: center;
      font-size: 24px;
      font-weight: bold;
      color: #333;
      margin-bottom: 50px;
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

    <iframe src="box.html" class="background-frame" frameborder="0" scrolling="no"></iframe>

    <iframe src="title.html" class="text-bg-frame" frameborder="0" scrolling="no"></iframe>

  <div id="form-container">

    <form action="#" method="post" class="login-form">

        <h2 class="form-title">로그인</h2>

            <div class="form-group">
                <label for="id">아이디</label>
                <input type="text" id="id" name="id" class="input-field" placeholder="아이디 입력">
            </div>

            <div class="form-group">
                <label for="pw">비밀번호</label>
                <input type="password" id="pw" name="pw" class="input-field" placeholder="비밀번호 입력">
            </div>

            <button type="submit" class="btn">로그인</button>

            <div class="extra-links">
                <a href="#">아이디 찾기</a>
                <a href="#">비밀번호 찾기</a>

            <a href="join.jsp">회원가입</a>
        </div>

    </form>
    
  </div>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    const form = document.querySelector('.login-form');
    const idInput = document.getElementById('id');
    const pwInput = document.getElementById('pw');

    form.addEventListener('submit', function (e) {
      if (!idInput.value.trim() || !pwInput.value.trim()) {
        e.preventDefault(); // 폼 전송 막기
        alert('아이디와 비밀번호를 모두 입력해주세요.');
      }
    });
  });

  
</script>
</body>
</html>
