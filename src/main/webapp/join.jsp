<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://webfontworld.github.io/gmarket/GmarketSans.css" rel="stylesheet">
  <title>회원가입</title>
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

    .form-title {
      font-family: 'yg-jalnan', sans-serif;
      text-align: center;
      font-size: 24px;
      font-weight: bold;
      color: #333;
      margin-bottom: 24px;
    }


    html,body {
            margin-top: 0;
            height: 100%;
 
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Helvetica Neue', sans-serif;
            margin: 0;
            background-color: #ffffff;
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
        justify-content: center;
        align-items: center;
    }

    .signup-form {
      background: white;
      padding: 30px;
      border-radius: 12px;
      /*box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);*/
      width: 100%;
      max-width: 380px;
      display: flex;
      flex-direction: column;
      position: absolute;   
      overflow: hidden;


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

    .input-field, .phone-input select, .phone-input input[type="tel"] {
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

    .checkbox-group {
      display: flex;
      align-items: center;
      margin-bottom: 20px;
      gap: 8px;
      font-size: 14px;
    }

    .phone-input {
        display: flex;
        width: 100%;
        gap: 6px;
        box-sizing: border-box;
        }

        .input-with-button {
        display: flex;
        gap: 8px;
        }

        .input-with-button .input-field {
        flex: 1; /* 입력칸이 최대한 공간을 차지 */
        }

        .check-btn {
        height: 44px;
        padding: 12px;
        font-size: 14px;
        border: 1px solid #ccc;
        border-radius: 8px;
        background-color: #eee;
        cursor: pointer;
        transition: background 0.3s;
        }

        .check-btn:hover {
        background-color: #ddd;
        }

        .sub-checkbox-group {
          display: flex;
          flex-direction: column;
          gap: 8px;
          font-size: 13px;
          margin-bottom: 20px;
          color: #555;
        }
        .sub-checkbox-group input[type="checkbox"] {
          margin-right: 6px;
        }
        .sub-checkbox-group div {
          display: flex;
          align-items: center;
        }

        #myModal {
          position: absolute;
          background-color: rgba(255, 255, 255, 0.788);
          margin-left:95px;
          display: flex;
          align-items: center;
          top : 170px;
          height: 500px;
      }

      .guardian-form {
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 8px 24px rgba(1, 243, 142, 0.2);
        width: 100%;
        max-width: 340px;
        display: flex;
        flex-direction: column;
        justify-content: center;

   

      }

      .guardian-title {
        text-align: center;
        font-size: 24px;
        font-weight: bold;
        color: #333;
        top: 24px;
      }

    .formBtn {
      flex: 1;
      padding: 12px;
      font-size: 16px;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      transition: background 0.3s;
    }

    .formBtn-cancel {
      background-color: #ccc;
      color: #333;
    }

    .formBtn-save {
      background-color: #6e67cf;
      color: white;
    }
    .formBtn-save2 {
      background-color: #7bf577;
      color: white;
      align-items: center;
      justify-content: center;

    }

    .formBtn-save:hover {
      background-color: #8cd875;
    }

    .formBtn-add {
      background-color: #eee;
      color: #333;
      font-size: 14px;
      margin-bottom: 16px;
      padding: 8px;
      border-radius: 6px;
      cursor: pointer;
    }

    .guardian-entry {
      border: 1px solid #ccc;
      border-radius: 8px;
      padding: 16px;
      margin-bottom: 16px;
      position: relative;
    }

    .form-group {
      display: flex;
      flex-direction: column;
      margin-bottom: 12px;
    }

    .form-group label {
      font-size: 14px;
      margin-bottom: 6px;
      color: #333;
    }

    .input-field {
      height: 40px;
      padding: 0 10px;
      font-size: 15px;
      border: 1px solid #ccc;
      border-radius: 6px;
      outline: none;
      box-sizing: border-box;
    }

    .checkbox-inline {
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 13px;
    }

    .remove-btn {
      position: absolute;
      top: 8px;
      right: 8px;
      background: #f44336;
      color: white;
      border: none;
      padding: 4px 8px;
      font-size: 12px;
      border-radius: 4px;
      cursor: pointer;
    }

    .button-group {
      display: flex;
      justify-content: space-between;
      gap: 10px;
      margin-top: 24px;
    }

    .saved-list {
      margin-top: 20px;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .saved-item {
      width: 270px;
      padding: 12px;
      border: none;
      border-radius: 8px;
      background-color: #acaba69d;
      font-size: 16px;
      line-height: 1.5;
      display: flex;
      justify-content: space-between;
      margin-top: 15px;
    }
    
    .formRemove-btn {
      margin-right: 0px;
      background-color: #ff4d4d;
      border: none;
      color: white;
      padding: 4px 8px;
      border-radius: 4px;
      cursor: pointer;
    }

  .formRemove-btn:hover {
    background-color: #e60000;
  }
  

  </style>
</head>
<body>

   <iframe src="box.html" class="background-frame" frameborder="0" scrolling="no"></iframe>

    <iframe src="title.html" class="text-bg-frame" frameborder="0" scrolling="no"></iframe>

   <div id="form-container"> 
      <form action="Join.do" method="post" class="signup-form">
      
        <h2 class="form-title">회원가입</h2>
      
        <div class="form-group">
         <label for="id">이름</label>
         <input type="text" id="name" name="name" class="input-field" placeholder="이름 입력">
        </div>
      
        <div class="form-group">
          <label for="id">아이디</label>
          <div class="input-with-button">
            <input type="text" id="id" name="user_id" class="input-field" placeholder="아이디 입력">
            <button type="button" class="check-btn">중복확인</button>
          </div>
        </div>
        
      
        <div class="form-group">
          <label for="pw">비밀번호</label>
          <input type="password" id="pw" name="password" class="input-field" placeholder="비밀번호 입력">
        </div>
      
        <div class="form-group">
          <label for="pw_ok">비밀번호 확인</label>
          <input type="password" id="pw_ok" name="pw_ok" class="input-field" placeholder="비밀번호 재입력">
        </div>
      
        <div class="form-group">
          <label for="ad">주소</label>
          <input type="text" id="ad" name="address" class="input-field" placeholder="주소 입력">
        </div>
      
      
        <div class="form-group">
          <label for="phone">휴대폰 번호</label>
          <div class="phone-input">
            <select name="phone1">
              <option>010</option>
              <option>011</option>
              <option>016</option>
              <option>017</option>
              <option>018</option>
              <option>019</option>
            </select>
            <input type="tel" name="phone2" placeholder="12345678" maxlength="8">
        </div>
         </div>
      
        <div class="form-group" style="margin-top: 10px;">
          <label for="email">이메일</label>
          <input type="email" id="email" name="email" class="input-field" placeholder="이메일 입력">
        </div>
      
        <button type="button" class="btn" id="plusGuardian"
        style="background-color:#555;">
          보호자 추가하기 +
        </button>
      
        <div class="checkbox-group" style="margin-top: 15px;">
          <input type="checkbox" id="agree">
          <label for="agree">전체 동의</label>
        </div>
        
        <div class="sub-checkbox-group">
          <div>
            <input type="checkbox" id="privacy" required>
            <label for="privacy">[필수] 개인정보 보호를 위한 이용자 동의</label>
          </div>
          <div>
            <input type="checkbox" id="age" required>
            <label for="age">[필수] 만 14세 이상입니다.</label>
          </div>
        </div>
        <div id="guardian-hidden-inputs"></div>
        <button type="submit" class="btn">동의 후 가입하기</button>
      
      </form>
</div>
<div id="myModal" class="guardian-form" style="display: none;">
    <h2 class="guardian-title">보호자 리스트</h2>

    <div id="saved-list">
      <!-- 여기에 저장된 보호자 리스트가 표시됨 -->
      
    </div>

    <div id="guardian-list">
        <!-- 보호자 폼 div가 들어갈 곳 -->

    </div>
  
    <button id="addBtn" type="button" class="btn-add" style="margin-top: 20px;">+ 보호자 추가</button>
  
    <div class="button-group">
      <button type="button" class="formBtn formBtn-cancel" onclick="clearDataAndGoBack()">이전으로</button>
      <button type="button" class="formBtn formBtn-save" onclick="saveAndGoBack()">저장하기</button>
    </div>

</div>


<!--입력을 안 했을 때 가입이 안 되게 막기-->

<script>


  document.addEventListener('DOMContentLoaded', function () {
    const savedGuardianData = JSON.parse(localStorage.getItem("guardianDataList"));

    if (savedGuardianData && savedGuardianData.length > 0) {
      console.log("저장된 보호자 정보:", savedGuardianData);
    } else {
      console.log("저장된 보호자 정보 없음");
    }


    const form = document.querySelector('.signup-form');
    const nameInput = document.getElementById('name');
    const user_idInput = document.getElementById('user_id');
    const passwordInput = document.getElementById('password');
    const pwOkInput = document.getElementById('pw_ok');
    const addressInput = document.getElementById('address');
    const phone2Input = document.querySelector('input[name="phone2"]');
    const emailInput = document.getElementById('email');
    const agreeCheckbox = document.getElementById('agree');
    const plusGuardian = document.getElementById('plusGuardian');
    const addBtn = document.getElementById('addBtn');

    plusGuardian.addEventListener('click', function(){
      document.getElementById('myModal').style.display = 'flex';
    });

    const closeModalBtn = document.getElementById('closeModal');
    if (closeModalBtn) {
      closeModalBtn.addEventListener('click', function () {
        document.getElementById('myModal').style.display = 'none';
      });
    }
    
    

function removeGuardian(button) {
  button.parentElement.remove(); // 자기 부모(div 전체)를 삭제
}

    form.addEventListener('submit', function (e) {
      if (
        !nameInput.value.trim() ||
        !user_idInput.value.trim() ||
        !passwordInput.value.trim() ||
        !pwOkInput.value.trim() ||
        !addressInput.value.trim() ||
        !phone2Input.value.trim() ||
        !emailInput.value.trim()
      ) {
        e.preventDefault();
        alert('모든 필수 항목을 입력해주세요.');
        return;
      }

      if (passwordInput.value !== pwOkInput.value) {
        e.preventDefault();
        alert('비밀번호와 비밀번호 확인이 일치하지 않습니다.');
        return;
      }

      if (!agreeCheckbox.checked) {
        e.preventDefault();
        alert('회원가입을 위해 전체 동의에 체크해주세요.');
        return;
      }

      e.preventDefault(); // 기본 전송 막고
      window.location.href = 'main.html'; // 이동

    });
  });
</script>


  <!--메인 약관 체크했을 때 서브 약관도 체크, 모두 체크하지 않으면 가입 불가능-->

<script>
  document.addEventListener('DOMContentLoaded', function () {
    const form = document.querySelector('.signup-form');
    const agreeAll = document.getElementById('agree');
    const privacy = document.getElementById('privacy');
    const age = document.getElementById('age');
  
    // 전체 동의 체크 시 하위 필수 항목 체크/해제
    agreeAll.addEventListener('change', function () {
      privacy.checked = agreeAll.checked;
      age.checked = agreeAll.checked;
    });
  
    // 회원가입 폼 제출 시 필수 항목 체크 여부 검사
    form.addEventListener('submit', function (e) {
      if (!privacy.checked || !age.checked) {
        e.preventDefault(); // 전송 막기
        alert('필수 항목에 동의하셔야 가입할 수 있습니다.');
      }
    });
  });
  </script>
  
 <script>
  let guardianDataList = [];
  const MAX_GUARDIANS = 3;

  document.addEventListener('DOMContentLoaded', function () {
    const form = document.querySelector('.signup-form');
    const addBtn = document.getElementById('addBtn');
    const plusGuardian = document.getElementById('plusGuardian');

    // 보호자 추가 버튼 클릭 시 모달 열기
    plusGuardian.addEventListener('click', function () {
      document.getElementById('myModal').style.display = 'flex';
    });

    // 보호자 폼 추가
    addBtn.addEventListener('click', function () {
      const currentForms = document.querySelectorAll('.guardian-entry').length;
      const total = guardianDataList.length + currentForms;

      if (total >= MAX_GUARDIANS) {
        alert("보호자는 최대 3명까지 등록 가능합니다.");
        return;
      }

      const guardianList = document.getElementById('guardian-list');

      const div = document.createElement('div');
      div.classList.add('guardian-entry');
      div.innerHTML = `
        <button type="button" class="remove-btn" onclick="removeGuardian(this)">삭제</button>
        <div class="form-group">
          <label>이름</label>
          <input type="text" class="input-field g_name">
        </div>
        <div class="form-group">
          <label>관계</label>
          <input type="text" class="input-field g_relation">
        </div>
        <div class="form-group">
          <label>전화번호</label>
          <input type="tel" class="input-field g_phone">
        </div>
        <button type="button" class="formBtn formBtn-save2" onclick="saveGuardian(this)">등록</button>
      `;
      guardianList.appendChild(div);
    });

    // 폼 제출 시 hidden input 생성
    form.addEventListener('submit', function (e) {
      const hiddenContainer = document.getElementById('guardian-hidden-inputs');
      hiddenContainer.innerHTML = '';

      guardianDataList.forEach(g => {
        const inputName = document.createElement('input');
        inputName.type = 'hidden';
        inputName.name = 'g_name[]';
        inputName.value = g.name;
        hiddenContainer.appendChild(inputName);

        const inputRelation = document.createElement('input');
        inputRelation.type = 'hidden';
        inputRelation.name = 'g_relation[]';
        inputRelation.value = g.relation;
        hiddenContainer.appendChild(inputRelation);

        const inputPhone = document.createElement('input');
        inputPhone.type = 'hidden';
        inputPhone.name = 'g_phone[]';
        inputPhone.value = g.phone;
        hiddenContainer.appendChild(inputPhone);
      });
    });
  });

  function saveGuardian(button) {
     const entry = button.closest('.guardian-entry');
     if (!entry) return;

     const nameInput = entry.querySelector('.g_name');
     const relationInput = entry.querySelector('.g_relation');
     const phoneInput = entry.querySelector('.g_phone');

     const g_name = nameInput?.value?.trim();
     const g_relation = relationInput?.value?.trim();
     const g_phone = phoneInput?.value?.trim();

     console.log("🟨 g_name 값:", g_name);

     if (!g_name || !g_relation || !g_phone) {
       alert("모든 항목을 입력해주세요.");
       return;
     }

     const guardian = { name: g_name, relation: g_relation, phone: g_phone };
     guardianDataList.push(guardian);

     const savedList = document.getElementById('saved-list');
     const listItem = document.createElement('div');
     listItem.className = 'saved-item';

     const nameDiv = document.createElement('div');
     nameDiv.className = 'guardian-name';
     nameDiv.style.color = 'black';
     nameDiv.textContent = '👤 ' + g_name+'(보호자)'; // 👉 템플릿 리터럴 대신 단순 연결로 변경

     console.log("✅ guardian-name div (textContent):", nameDiv.textContent); // 실제 들어간 값 확인

     const removeBtn = document.createElement('button');
     removeBtn.type = 'button';
     removeBtn.className = 'formRemove-btn';
     removeBtn.textContent = '삭제';
     removeBtn.addEventListener('click', function () {
       const index = guardianDataList.findIndex(
         g => g.name === g_name && g.phone === g_phone
       );
       if (index !== -1) guardianDataList.splice(index, 1);
       listItem.remove();
     });

     listItem.appendChild(nameDiv);
     listItem.appendChild(removeBtn);
     savedList.appendChild(listItem);

     entry.remove();
   }

  // 보호자 입력폼 삭제
  function removeGuardian(button) {
    const entry = button.closest('.guardian-entry');
    if (entry) {
      entry.remove();
    }
  }

  function clearDataAndGoBack() {
    guardianDataList = [];
    document.getElementById('saved-list').innerHTML = '';
    document.getElementById('guardian-list').innerHTML = '';
    closeGuardianForm();
  }

  function saveAndGoBack() {
    closeGuardianForm();
  }

  function closeGuardianForm() {
    document.getElementById('myModal').style.display = 'none';
  }
</script>


    
</body>
</html>
