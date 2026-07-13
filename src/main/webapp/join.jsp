<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://webfontworld.github.io/gmarket/GmarketSans.css" rel="stylesheet">
  <link rel="stylesheet" href="css/join.css"/>
  <title>회원가입</title>
</head>
<body>


    <iframe src="title.html" class="text-bg-frame" frameborder="0" scrolling="no"></iframe>

   <main id="form-container">
      <form action="Join.do" method="post" class="signup-form">
      
        <h2 class="form-title">회원가입</h2>
      
        <div class="form-group">
         <label for="name">이름</label>
         <input type="text" id="name" name="name" class="input-field" placeholder="이름 입력">
        </div>
      
        <div class="form-group">
          <label for="id">아이디</label>
          <div class="input-with-button">
            <input type="text" id="id" name="user_id" class="input-field" placeholder="아이디 입력">
            <button type="button" id="checkIdBtn" class="check-btn">중복확인</button>
          </div>
          <p id="checkIdResult" style="margin-top: 5px; font-size: 13px;"></p>
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
            <select id="phone" name="phone1">
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
</main>
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
    const form = document.querySelector('.signup-form');
    const nameInput = document.getElementById('name');
    const user_idInput = document.getElementById('id'); // 원래 'user_id'로 찾고 있었는데 실제 input id는 'id'라서 못 찾고 있었음, 고침
    const passwordInput = document.getElementById('pw'); // 실제 input id는 'pw'라서 'password'로는 못 찾고 있었음, 고침
    const pwOkInput = document.getElementById('pw_ok');
    const addressInput = document.getElementById('ad'); // 실제 input id는 'ad'라서 'address'로는 못 찾고 있었음, 고침
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

    // 아이디 중복확인 버튼
    const checkIdBtn = document.getElementById('checkIdBtn');
    const checkIdResult = document.getElementById('checkIdResult');

    checkIdBtn.addEventListener('click', function () {
      const id = user_idInput.value.trim();

      if (!id) {
        checkIdResult.style.color = 'red';
        checkIdResult.innerText = '아이디를 먼저 입력해주세요.';
        return;
      }

      fetch('CheckId.do?user_id=' + encodeURIComponent(id))
        .then(function (res) {
          return res.text();
        })
        .then(function (result) {
          if (result === 'dup') {
            checkIdResult.style.color = 'red';
            checkIdResult.innerText = '이미 사용중인 아이디입니다.';
          } else {
            checkIdResult.style.color = 'green';
            checkIdResult.innerText = '사용 가능한 아이디입니다.';
          }
        });
    });



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

      // 검증을 다 통과했으면 Join.do로 실제 폼 제출이 그대로 진행됨
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
