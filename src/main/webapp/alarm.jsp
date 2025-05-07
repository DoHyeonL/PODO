<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>보호자 리스트</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
  		<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  
  <style>
    body {
      font-family: Arial, sans-serif;
      height: 100vh;
      margin: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      background-color: #f0f0f0;
    }

    #guardian-list-container {
      display: flex;
      flex-direction: row;
      flex-wrap: wrap;
      justify-content: center;
      gap: 20px;
    }

    .guardian-box {
      background-color: #fff;
      border: 1px solid #ddd;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      text-align: center;
      width: 200px;
    }

    .send-btn {
      margin-top: 10px;
      padding: 5px 10px;
      background-color: #007BFF;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }

    .send-btn:disabled {
      background-color: gray;
      cursor: default;
    }
  </style>
</head>

<body>
	<c:if test="${not empty result}">
  		<script> Swal.fire({
  	      icon: 'success',
  	      title: '완료!',
  	      text: '${result}',
  	      confirmButtonColor: '#3085d6',
  	      confirmButtonText: '확인'
  	    });</script>
	</c:if>
	
 <div style="display: flex; flex-direction: column; align-items: center; width: 100%;">
    <div id="guardian-list-container">
      <c:choose>
        <c:when test="${empty guardianList}">
          <p>등록된 보호자가 없습니다.</p>
        </c:when>
        <c:otherwise>
          <c:forEach var="g" items="${guardianList}">
            <div class="guardian-box animate__animated animate__rollIn">
              <p>이름: ${g.g_name}</p>
              <p>관계: ${g.g_relationship}</p>
              <p>전화번호: ${g.g_phone}</p>
              <form action="SendAlarm.do" method="post">
                <input type="hidden" name="g_phone" value="${g.g_phone}">
                <button class="send-btn" type="submit">알림 보내기</button>
              </form>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- ✅ 버튼을 리스트 바로 아래 중앙 정렬 -->
    <div style="margin-top: 30px;">
      <button class="send-btn" type="button" style="background-color: #28a745;" onclick="location.href='main2.jsp'">
        ⬅ 이전으로
      </button>
    </div>
    </div>
</body>
</html>
