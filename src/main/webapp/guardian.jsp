<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <link href="https://webfontworld.github.io/gmarket/GmarketSans.css" rel="stylesheet">
  <title>보호자 리스트</title>
  <style>


        @font-face {
          font-family: 'yg-jalnan';
          src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_four@1.2/JalnanOTF00.woff') format('woff');
          font-weight: normal;
          font-style: normal;
      }

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

    html, body {
    margin-top: 0;
    
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    font-family: 'Helvetica Neue', sans-serif;
    margin: 0;
    }

    .container {
        background: white;
        margin-left:100px;
        height: 100%;
        width: 600px;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
        display: flex;
        flex-direction: column;  /* 세로 방향으로 내용 배치 */
        align-items: center;     /* 중앙 정렬 */
        justify-content: flex-start;  /* 내용이 위에서부터 쌓이도록 */
    }

    h2.title {
        font-family: 'yg-jalnan', sans-serif;
        text-align: center;     
        margin-top: 80px;
        font-size: 35px;
        margin-bottom: 30px;
        color: #8c33df;
    }

    .cards-container {
        margin-top: -15px;
        border-radius: 10%;
        width: 500px;
        height: 100%;
        overflow: hidden;
        overflow-y: auto;
        flex-grow: 1;
        display: flex;
        flex-direction: column; /* 카드들을 세로로 배치 */
        align-items: center; /* 카드들을 수평 중앙 정렬 */
        gap: 16px;
    }

    .cards-container::-webkit-scrollbar {
        display: none; /* 스크롤바 숨기기 */
    }

    .guardian-card {
        margin-top: 40px;    /* 카드 사이 간격 */
        display: flex;
        justify-content: center;
        align-items: center;
        height: 440px;
        width: 370px;
        background-color: #e5f8ed;
        border-radius: 12px;
        padding: 16px;
        margin-bottom: 16px;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
        flex-direction: column;  /* 카드 내부 내용도 세로로 나열 가능 */
    }

    .guardian-avatar {
      margin-top: 20px;
      width: 280px;
      height: 320px;
      border-radius: 50%;
      /*background-color: #3053f1c2;*/
      background-color: #ffaf53c2;
      background-size: cover;
      background-position: center;
      margin-right: 16px;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.4);
    }

    .guardian-info {
      flex-grow: 1;
      display: flex;
      flex-direction: column;
      align-items: center; /* 내부 요소들 중앙 정렬 */
    }

    .guardian-name {
      font-family: 'yg-jalnan', sans-serif;
      margin-top: 18px;
      font-size: 25px;
      font-weight: bold;
      color: #222;
      margin-bottom: 8px;
      text-align: center;
    }

    .guardian-location {
      background-color: #d4f3e4;
      color: #097e45;
      font-size: 12px;
      padding: 4px 10px;
      border-radius: 20px;
      margin-bottom: 10px;
      text-align: center;
    }

    .button-group {
      
      display: flex;
      justify-content: center;
      gap: 8px; /* 버튼 간격 */
    }

    .edit-btn, .remove-btn {
      font-family: 'yg-jalnan', sans-serif;
      background-color: #777;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.4);
      color: white;
      border: none;
      font-size: 14px;
      padding: 4px 8px;
      border-radius: 4px;
      cursor: pointer;
    }

    .edit-btn {
      background-color: #2196F3;
      width: 160px;
      height: 40px;
      
    }

    .remove-btn {
      background-color: #fa5d52;
      margin-left: 10px;
      width: 160px;
      height: 40px;
    }

    .button-group {
      display: flex;
      margin-top: 15px;
      justify-content: center; /* 가운데 정렬 */
      gap: 8px; /* 버튼 사이 간격 */
      width: 100%; /* 전체 너비 확보 */
    }
    
    .button {
      font-family: 'yg-jalnan';
      display: flex;
      margin-top: 30px;
      width: 75%;
      justify-content: space-between;
      gap: 10px;
      
    }

    .btn-guardian {
      background-color: #8c33df;
      color: white;
      text-align: center;
      text-decoration: none;
      display: inline-block;
      flex: 1; /* 버튼 그룹 안에서 동일한 너비 확보 */
      padding: 12px;
      border-radius: 8px;
      font-size: 16px;
      transition: background 0.3s;
      text-align: center;
      margin-bottom: 20px;
    }
  </style>
</head>
<body>
  <div class="container">
    <h2 class="title">함께하는 사람들</h2>

    <div class="cards-container">
        <div id="guardian-list">

          <div class="guardian-card">
            <div class="guardian-avatar" style="background-image: url('images/보호자 프로필/보호자1.png');"></div>
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
            <div class="guardian-avatar" style="background-image: url('images/보호자 프로필/보호자2.png');"></div>
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
            <div class="guardian-avatar" style="background-image: url('images/보호자 프로필/보호자3.png');"></div>
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
      <div class="button">
            <a href="main.jsp" class="btn btn-guardian">이전으로</a>
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
