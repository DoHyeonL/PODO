<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>보호자 리스트</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: 'Helvetica Neue', sans-serif;
      background: linear-gradient(to right, #d6e9e9, #c9d6ff);
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
    }

    .container {
      background: white;
      border-radius: 16px;
      padding: 30px;
      max-width: 500px;
      width: 90%;
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    }

    h2.title {
      text-align: center;
      font-size: 24px;
      margin-bottom: 30px;
      color: #333;
    }

    .guardian-card {
      display: flex;
      align-items: center;
      background-color: #f9f9f9;
      border-radius: 12px;
      padding: 16px;
      margin-bottom: 16px;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
    }

    .guardian-avatar {
      width: 100px;
      height: 100px;
      border-radius: 50%;
      background-color: #ccc;
      background-size: cover;
      background-position: center;
      margin-right: 16px;
    }

    .guardian-info {
      flex-grow: 1;
    }

    .guardian-name {
      font-size: 16px;
      font-weight: bold;
      color: #222;
      margin-bottom: 4px;
    }

    .guardian-location {
      display: inline-block;
      background-color: #d4f3e4;
      color: #097e45;
      font-size: 12px;
      padding: 4px 10px;
      border-radius: 20px;
    }

    .edit-btn, .remove-btn {
      background-color: #777;
      color: white;
      border: none;
      font-size: 12px;
      padding: 4px 8px;
      border-radius: 4px;
      cursor: pointer;
      margin-left: 5px;
    }

    .edit-btn {
      background-color: #2196F3;
      
    }

    .remove-btn {
      background-color: #f44336;
    }

    .button-group {
      display: flex;
      gap: 8px;
      margin-left: 250px;
    }
    
  </style>
</head>
<body>
  <div class="container">
    <h2 class="title">함께하는 사람들</h2>
    <div id="guardian-list">

      <div class="guardian-card">
        <div class="guardian-avatar" style="background-image: url('images/보호자 프로필/퉁사후르.jpg');"></div>
        <div class="guardian-info">
          <div class="guardian-name">이도현 보호자</div>
          <span class="guardian-location">광주 남구</span>
          <div class="button-group">
            <button class="edit-btn" onclick="editGuardian(this)">수정</button>
            <button class="remove-btn" onclick="removeGuardian(this)">삭제</button>
          </div>
        </div>
      </div>

      <div class="guardian-card">
        <div class="guardian-avatar" style="background-image: url('images/보호자 프로필/트랄라.jpg');"></div>
        <div class="guardian-info">
          <div class="guardian-name">박민혁 보호자</div>
          <span class="guardian-location">경기 광명</span>
          <div class="button-group">
            <button class="edit-btn" onclick="editGuardian(this)">수정</button>
            <button class="remove-btn" onclick="removeGuardian(this)">삭제</button>
          </div>
        </div>
      </div>

      <div class="guardian-card">
        <div class="guardian-avatar" style="background-image: url('images/보호자 프로필/봄바.jpg');"></div>
        <div class="guardian-info">
          <div class="guardian-name">이정민 보호자</div>
          <span class="guardian-location">전남 광양</span>
          <div class="button-group">
            <button class="edit-btn" onclick="editGuardian(this)">수정</button>
            <button class="remove-btn" onclick="removeGuardian(this)">삭제</button>
          </div>
        </div>
      </div>

    </div>
  </div>

  <script>
    function removeGuardian(button) {
      button.closest('.guardian-card').remove();
    }

    function editGuardian(button) {
  const card = button.closest('.guardian-card');
  const nameDiv = card.querySelector('.guardian-name');
  const locationSpan = card.querySelector('.guardian-location');

  if (button.innerText === '수정') {
    // 기존 텍스트 저장
    const name = nameDiv.innerText;
    const location = locationSpan.innerText;

    // input으로 변환
    nameDiv.innerHTML = `<input type="text" value="${name}" class="edit-name">`;
    locationSpan.innerHTML = `<input type="text" value="${location}" class="edit-location">`;

    // 버튼 텍스트만 저장으로 변경
    button.innerText = '저장';

  } else {
    // 저장 클릭 시 input 값을 가져옴
    const nameInput = card.querySelector('.edit-name');
    const locationInput = card.querySelector('.edit-location');
    const newName = nameInput.value;
    const newLocation = locationInput.value;

    // 다시 일반 텍스트로 표시
    nameDiv.innerText = newName;
    locationSpan.innerText = newLocation;

    // 버튼 원래대로
    button.innerText = '수정';
  }
}

  </script>
</body>
</html>
