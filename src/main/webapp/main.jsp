<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");
    String routeType = request.getParameter("type");
    
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메인 화면</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link href="https://webfontworld.github.io/gmarket/GmarketSans.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
    <script src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=C0A4SwhCGE2ocuN4vTAeD7ClrI5Jb1Kk5nj6or4F"></script>
    
    <script type="text/javascript">
    const contextPath = "<%= request.getContextPath() %>";
    
    var map;
    var markerList = []; // 지도에 표시된 마커들 보관
    var markerVisibility = {
        1: false,  // 경찰서 (초기에는 숨김)
        2: false,  // 소방서
        3: false,   // CCTV
        4: false   // 편의점
    };
    var categoryMarkers = {
        1: [],  // 경찰서
        2: [],  // 소방서
        3: [],   // CCTV
        4: []   // 편의점
    };

    function initTmap(latitude = 35.164710, longitude = 126.918015) {
        map = new Tmapv2.Map("map_div", {
        center: new Tmapv2.LatLng(35.160370, 126.851392),
        width: "600px",
        height: "100%",
        zoom: 17
     });
   }
    
    function geoFindMe() {
        const status = document.querySelector("#status");
        const location = document.querySelector("#location");


        function success(position) {
            const latitude = position.coords.latitude;
            const longitude = position.coords.longitude;


            initTmap(latitude, longitude);
        }

        function error() {
            // 실패 시 기본 좌표로 지도 생성
            initTmap();
        }

        if (!navigator.geolocation) {
          
            initTmap();
        } else {
            navigator.geolocation.getCurrentPosition(success, error);
        }
    }

        window.onload = geoFindMe;

    // 카테고리별로 마커 표시/숨기기 기능
    function toggleMarkersByCategory(category) {
        if (markerVisibility[category]) {
            // 마커 숨기기
            categoryMarkers[category].forEach(marker => {
                marker.setMap(null);  // 지도에서 마커 제거
            });
            markerVisibility[category] = false;  // 숨김 상태로 변경
        } else {
            // 마커 표시하기
            showMarkersByCategory(category);  // 카테고리별 마커 새로 불러오기
            markerVisibility[category] = true;  // 표시 상태로 변경
        }
    }

    // 카테고리별 마커 불러오기
    function showMarkersByCategory(category) {
        const url = contextPath + "/FacilityMap.do?category=" + category;
        console.log("요청 URL:", url);  // 요청 URL 확인

        fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error("서버 응답 실패");
                }
                return response.json();
            })
            .then(data => {
                console.log("시설 데이터 수신됨:", data);  // 데이터 확인
                if (!Array.isArray(data) || data.length === 0) {
                    console.warn("해당 카테고리 마커 없음");
                    return;
                }

                // 기존 마커 삭제 (마커 리스트 초기화)
                categoryMarkers[category].forEach(m => m.setMap(null));
                categoryMarkers[category] = []; // 해당 카테고리 마커 리스트 초기화

                // 새로운 카테고리 데이터 마커 추가
                data.forEach(fac => {
                    console.log("마커 생성:", fac);  // 마커 생성 전 값 확인
                    const marker = new Tmapv2.Marker({
                        position: new Tmapv2.LatLng(fac.lat, fac.lon),
                        icon: fac.icon_path,  // 아이콘 경로 확인
                        iconSize: new Tmapv2.Size(30, 30),
                        map: map
                    });
                    categoryMarkers[category].push(marker); // 해당 카테고리 마커 리스트에 추가
                });

                if (categoryMarkers[category].length === 0) {
                    console.warn("해당 카테고리 마커 없음");
                }
            })
            .catch(err => {
                console.error("시설 정보 불러오기 실패:", err);
            });
    }

   </script>
    
    <style>

        @font-face {
            font-family: 'YOnepickTTF-Bold';
            src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/2410-1@1.0/YOnepickTTF-Bold.woff2') format('woff2');
            font-weight: 700;
            font-style: normal;
        }
        @font-face {
            font-family: 'Freesentation-9Black';
            src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/2404@1.0/Freesentation-9Black.woff2') format('woff2');
            font-weight: 900;
            font-style: normal;
        }
        
        @font-face {
          font-family: 'yg-jalnan';
          src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_four@1.2/JalnanOTF00.woff') format('woff');
          font-weight: normal;
          font-style: normal;
      }
        

        body {
            font-family: 'yg-jalnan', sans-serif !important;
        }

        #declareBtn1{
            position: absolute;
            top: 60px;
            left:15px;
            font-weight: bold;
            font-size: 25px;
            color: #ffffff;
            z-index: 3;
        }

        #declareBtn2{
            position: absolute;
            top: 0px;
            left:110px;
            font-weight: bold;
            font-size: 25px;
            color: #ffffff;
            z-index: 3;
            display: none;
        }

        #declareBtn3{
            position: absolute;
            top: 60px;
            left:200px;
            font-weight: bold;
            font-size: 25px;
            color: #ffffff;
            z-index: 3;
            display: none;
        }
        
        #declareModal {
            border-radius: 20px;
            position: absolute;
            top: 20%;
            left: 10%;
            background-color: rgb(255, 255, 255);
            display: flex;
            flex-direction: column;   /* 위에서 아래로 정렬 */
            align-items: center;      /* 가로 중앙 정렬 */
            padding: 30px 20px;
            height: auto;
            width: 450px;
            z-index: 10;
            box-shadow: 0 .5px 2px 0 hsla(0, 0%, 0%, 0.2);
            display: none;
            }

            .declare-title {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 40px;
                text-align: center;
                
            }

            .report-form {
                display: flex;
                flex-direction: column;
                width: 100%;
                gap: 10px;
                margin-bottom: 20px;
                font-family: 'Helvetica Neue', sans-serif;
                font-weight: bold;
            }

            .form-input {
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 8px;
                font-size: 14px;
                width: 100%;
                box-sizing: border-box;
            }

            .button-group {
                display: flex;
                justify-content: center;
                width: 100%;
                gap: 10px;
            }

            .formBtn {
                padding: 10px 15px;
                border: none;
                border-radius: 8px;
                font-weight: bold;
                cursor: pointer;
                width: 120px;
            }

            .formBtn-cancel {
                background-color: #ddd;
            }

            .formBtn-save {
                background-color: #4CAF50;
                color: white;
            }

            #successMessage {
                position: absolute;
                top: 40%;
                left: 33%;
                background-color: white;
                padding: 20px 30px;
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.2);
                display: none;
                z-index: 3;
                text-align: center;
            }

            #successMessage2 {
                position: absolute;
                top: 40%;
                left: 28%;
                background-color: white;
                padding: 20px 30px;
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.2);
                display: none;
                z-index: 3;
                text-align: center;
            }

            #successMessage3 {
                position: absolute;
                top: 40%;
                left: 21%;
                background-color: rgba(255, 64, 64, 0.904);
                padding: 20px 30px;
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.2);
                display: none;
                z-index: 3;
                text-align: center;
            }
            
        .loader1 {
            position: absolute;
            
            width: 100%;
            height: 100%;
            border-radius: 50%;
            transition: transform 0.9s ease, opacity 0.8s ease;
            animation: rotation_51512 1.2s infinite cubic-bezier(0.785, 0.135, 0.15, 0.86);
            z-index: 1;
        }

        @keyframes rotation_51512 {
        70% {
            box-shadow: 0px 0px 10px 50px rgba(253, 32, 32, 0.658);
        }

        90% {
            box-shadow: 0px 0px 10px 50px rgba(241, 57, 57, 0.04);
        }

        100% {
            opacity: 0.5;
            transform: rotate(360deg);
        }
        }

        /* HTML: <div class="loader"></div> */
        .loader {
            width: 320px;
            aspect-ratio: 1;
            border-radius: 60%;
            background: #e42525f3;
            box-shadow: 0 0 0 0 rgba(240, 34, 34, 0.267);
            animation: l2 1.5s infinite linear;
            position: absolute;
            left: 24%;
            bottom: -120px;
            opacity: 0;
            transition: transform 0.5s ease, opacity 0.6s ease;
            z-index: 2;
            visibility: hidden;
        }

        .loader:before,
        .loader:after {
            content: "";
            position: absolute;
            inset: 0;
            border-radius: inherit;
            box-shadow: 0 0 0 0 rgba(255, 4, 4, 0.267);
            animation: inherit;
            animation-delay: -0.5s;
        }

        .loader:after {
        animation-delay: -1s;
        }

        .loader.show{
            opacity: 1;
            
        }

        @keyframes l2 {
            100% {box-shadow: 0 0 0 60px #0000}
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
            pointer-events: none;
        }


        #map-container {          
            position: relative;
            left: 50px;
            width: 100%;
            min-width: 600px;
            height: 100%;
            overflow: hidden; 
            margin: 0 auto;

            
        }

        .map-center {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            border: 1px solid #ccc;
            overflow: hidden;
        }

        #sidebarMember {
            position: absolute;
            margin-left: 120px;
            left: 10%;
            width: 330px;
            height: 100%;
            background-color: white;
            transform: translateX(-160%);

            opacity: 1;

            pointer-events: none;
            transition: transform 0.5s ease, opacity 0.3s ease;
            z-index: 10;
        }

        
        #sidebarMember.show {
            transform: translateX(-55%);
            opacity: 1;
            visibility: visible;
            pointer-events: auto;
        }
        
        

        #sidebarMember.expand {
            transform: translateX(-30%);
            width: 100%;
            height: 100%;
        }

        #sidebarMember .textBtn {
            opacity: 1;
            transform: translateY(0);
            transition: opacity 0.8s ease, transform 0.8s ease;
        }

        #sidebarMember.expand .textBtn {
            opacity: 0;
            pointer-events: none;
        }

        #sidebarMember hr {
            opacity: 1;
            transform: translateY(0);
            transition: opacity 0.8s ease, transform 0.8s ease;
        }

        #sidebarMember.expand hr {
            opacity: 0;
            transform: translateY(-20px); /* 위로 사라지게 */
            pointer-events: none;
        }

        #sidebarGuest {
            position: absolute;
            margin-left: 120px;
            left: 10%;
            width: 330px;
            height: 100%;
            background-color: white;
            transform: translateX(-160%);

            opacity: 1;

            pointer-events: none;
            transition: transform 0.6s ease, opacity 0.3s ease;
            z-index: 5;
        }

        
        #sidebarGuest.show {
            transform: translateX(-55%);
            opacity: 1;
            visibility: visible;
            pointer-events: auto;
        }
     

        #search-path {
            position: absolute;
            left: 50%;           
            top: 50px;            
            width: 490px;  
            min-width: 450px;        
            height: 45px;
            
            transform: translate(-50%);
            
            padding: 0 10px;
            display: flex;
            align-items: center;
            box-sizing: border-box;
            border-radius: 6px;
            background-color: #ffffff;
            gap: 9px;
            z-index: 1;
        }

       
        /*.expand {
            position: absolute;
            top: 280px !important;
            left: 50%;
            width: 450px;
            height: 45px; 
            background-color: #fffbfb;
            max-width: none;
            z-index: 1;
            transition:
                top 0.6s ease,
                left 0.6s ease,
                width 0.7s ease,
                height 0.7s ease,
                background-color 0.6s ease ;
        }*/



        #inputhBtn{
            width: 100%;
        }

        

                /* <reset-style> ============================ */
        button {
            border: none;
            background: none;
            padding: 0;
            margin: 0;
            cursor: pointer;
            font-family: inherit;
        }
        

        /* <style for menu__icon> ======== */
        .menu__icon {
            width: 32px;
            height: 32px;
            padding: 4px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: end;
            transition: opacity 0.3s ease, transform 0.3s ease;
            opacity: 1;
        }

        .menu__icon span {
            width: 100%;
            height: 0.25rem;
            border-radius: 0.125rem;
            background-color: rgba(15, 15, 15, 0.822);
            box-shadow: 0 .5px 2px 0 hsla(0, 0%, 0%, .2);
            transition: width .4s, transform .4s, background-color .4s;
        }

        .menu__icon :nth-child(2) {
            width: 75%;
        }

        .menu__icon :nth-child(3) {
            width: 50%;
        }

        .menu__icon:hover {
            transform: rotate(-90deg);
        }

        .menu__icon:hover span {
        width: .25rem;
        transform: translateX(-10px);
        background-color: rgb(255, 59, 48);
        }


        

     


         #inputBtn{
            opacity: 1;
            transition: all 0.3s ease;
         }

         

         #inputText{
            transition: all 0.3s ease;
        }
        
        

        .hidden {
            transform: translateX(-100%);
            opacity: 0;
            visibility: hidden;
            pointer-events: none;
            transition: transform 0.6s ease, opacity 0.6s ease;
            position: fixed;
            top: 0;
            left: 0;
        }

         
        #bottom-bar {
            position: absolute;  /* 화면에 고정 */
            bottom: 0px; 
            left: 50px;        /* 화면 세로 중앙 */       /* 화면 가로 중앙 */
            width: 600px;     /* 고정된 너비 */
            min-width: 400px; /* 최소 너비 */
            height: 75px;
            margin-left: 250px;
            background-color: #ffffff;
            display: flex;
            justify-content: space-around;
            align-items: center;
            border-top: 1px solid #ccccccc7;
            z-index: 3;

            /* 중앙 정렬을 위한 transform */
            transform: translate(-50%); /* 요소의 크기의 절반만큼 이동시켜 정확히 중앙에 배치 */
        }
        
        #bottom-bar.lower {
            z-index: 1;  /* 낮은 z-index */
        }


        .bottom-button {
            background: none;
            border: none;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: #333;
        }

        .bottom-button img {
            width: 32px;
            height: 32px;
            margin-bottom: 4px;
        }

        .bottom-button span {
            font-size: 12px;
        }

        


        .shadow {
            box-shadow: 5px 5px 5px rgb(168, 166, 166); /*그림자 효과*/
            transition: 0.5s ease;
        }

        .line-shadow {
            box-shadow: 1px 1px 1px rgb(168, 166, 166); /*그림자 효과*/
        }

        .overlay{
            position: fixed;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            opacity: 0; /* 숨김 상태에서 불투명도 0 */
            
            visibility: hidden; /* 숨김 상태에서 보이지 않음 */
            transition: opacity 0.6s ease;
            z-index: 2;
        }
        

        .overlay.show {
            opacity: 1; /* 보일 때 불투명도 1 */
            visibility: visible; /* 보일 때 보이도록 설정 */
        }

        .overlay.hidden {
            opacity: 0; /* 숨길 때 불투명도 0 */
            transition: opacity 0.6s ease; /* opacity 애니메이션만 적용 */
        }

        
        .textBtn{
            all: unset;
            width: 100%;
            z-index: 2 !important;
            display: flex;
            align-items: center;
            height: 45px;
        }

        .inputAddres{
            position: absolute;
            top: 10px;
            border: none;          /* 테두리 제거 */
            background: none;
            outline: none;         /* 포커스 시 생기는 파란 테두리 제거 */
            box-shadow: none; 
            width: 80%;
            display: flex;
            align-items: center;
            height: 25px;
            font-size: 1rem;
        }


        .loginHidden{
            position: absolute;
            left: 600px;
            width: 600px;
            height: 100%;
            opacity: 1;
            z-index: 11;
            background-color: #ffffff;
         }

         .loginHidden.show {
            transform: translateX(-100%);
            opacity: 1;
            visibility: visible;
            pointer-events: auto;
            transition: transform 0.6s ease, opacity 0.3s ease;
        }

        #facility-container{
            position: absolute; /* 위치를 본인이 속한 부모 요소에 의존하게 함*/
            padding-left: 58px;
            width: 100%;
            height: 50px;
            display: flex;
            justify-content: space-around;
            align-items: center;
           
            top:110px;

            z-index: 1;

            gap:30px;

            overflow-x: auto;        /* 가로 스크롤 활성화 */
            overflow-y: hidden;      /* 세로 스크롤 막기 */
            white-space: nowrap;
            scroll-behavior: smooth; 
             
            scrollbar-width: none; /* 스크롤 바 스타일 감추기 */

            cursor: grab; /* 기본 커서 */
            user-select: none; /* 텍스트 선택 방지 */

            box-sizing: border-box; /* box-sizing을 적용해 padding을 포함 */
            padding-right: 50px; /* 오른쪽 패딩을 추가하여 휠 영역 확장 */
             

        }

        #facility-container:active {
            cursor: grabbing;        /* 드래그할 때의 커서 */
        }

        .facility{
            
            padding: 5px;
            width: 70px;
            height: 22px;
            display: flex;
            justify-content: center;
            align-items: center; 
            white-space: nowrap;
            text-align: center;
            font-size: 16px;
            
            
        }
        .facilityBtn{
            padding-left: 12px;
            background-color: #ffffff;
            border-radius: 25px;
            width: 170px;

            display: flex;
            border: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);

        }

        .facilityBtn img{
            width: 29px;
            height: 29px;
        }

        



    </style>  
</head>

<c:set var="jsLoginCheck" value="${not empty loginvo}" />

<body>

   <c:choose>
       <c:when test="${not empty loginvo}">
           <c:set var="isLoggedIn" value="true"/>
       </c:when>
       <c:otherwise>
           <c:set var="isLoggedIn" value="false"/>
       </c:otherwise>
   </c:choose>


    <iframe src="box.html" class="background-frame" frameborder="0" scrolling="no"></iframe>
    <iframe src="title.html" class="text-bg-frame" frameborder="0" scrolling="no"></iframe>
    
   <div id="map-container">

      <c:choose>
          <c:when test="${isLoggedIn eq 'true'}">
              <div id="sidebarMember">
                  <button class='textBtn' style="margin-top: 70px; margin-left: 40px;">
                      <span style="font-size: clamp(22px, 5vw, 28px); font-weight: bold;">
                          ${loginvo.name}님 안녕하세요
                      </span>
                  </button>
                  <hr style="margin-top: 20px; border: none; height: 1px; background-color: rgba(145, 136, 136, 0.2); width: 90%;">
                  <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='pathSearch.jsp'">
                      <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold;">안심길찾기</span>
                  </button>
                  <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='join.html'">
                      <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold;">자주가는 장소</span>
                  </button>
                  <button id="Gu" class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='guardian.jsp'">
                      <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold;">함께하는 사람들</span>
                  </button>
                  <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='Alarm.do'">
                      <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold;">알리미</span>
                  </button>
                  <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='join.html'">
                      <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold;">신고함</span>
                  </button>
                  <button class='textBtn' style="margin-top: 30px; margin-left: 40px;" 
                        onclick="alert('로그아웃 되었습니다.'); location.href='Logout.do';">
                      <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold; color: red;">로그아웃</span>
                  </button>
              </div>
          </c:when>
          <c:otherwise>
              <div id="sidebarGuest" >
                <button id = "loginBtn" class='textBtn' style="margin-top: 100px; margin-left: 40px;">
                    <span style="font-size: clamp(22px, 5vw, 28px); font-weight: bold; ">
                        로그인을 해주세요
                    </span>    
                </button>
            
                <hr style="margin-top: 20px; border: none; height: 1px; background-color: rgba(145, 136, 136, 0.2); width: 90%;">
            
                <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='pathSearch.jsp'">
                    <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold; ">
                        안심길찾기
                    </span>    
                </button>

            
                <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='join.html'">
                    <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold; ">
                        신고함
                    </span>    
                </button>
           
            
            </div>
          </c:otherwise>
      </c:choose>



        <div id="joinBox" class="loginHidden"></div>

            
   
                <div id="facility-container">
                      <button class="facilityBtn" onclick="toggleMarkersByCategory(1)">
                <img src="images/시설물/경찰서.png" alt="경찰서">
                <div class="facility">경찰서</div>
            </button>
            
            <button class="facilityBtn" onclick="toggleMarkersByCategory(2)">
                <img src="images/시설물/소방서.png" alt="소방서">
                <div class="facility">소방서</div>
            </button>
            
            <button class="facilityBtn" onclick="toggleMarkersByCategory(3)">
                <img src="images/시설물/CCTV.png" alt="CCTV">
                <div class="facility">CCTV</div>
            </button>
            
            <button class="facilityBtn" onclick="toggleMarkersByCategory(4)">
                <img src="images/시설물/안심시설.png" alt="안심시설">
                <div class="facility">안심시설</div>
            </button>

                 </div>
                 
                 
                 
                 

            <div id="bottom-bar">

                <button class="bottom-button"  onclick="location.href='mypage.html'">
                    <img src="images/하단바/주변.png" alt="주변" style="width: 35px; height: 35px;">
                    <span>주변</span>
                </button>


                <button class="bottom-button" style="margin-left: 10px;" onclick="location.href='guardian.jsp'">
                    <img src="images/하단바/알리미.png" alt="알리미" style="width: 35px; height: 35px;" >
                    <span style="margin-bottom: 4px;">알리미</span>
                </button>
                
                

                <button id="declare" class="bottom-button" style="margin-left: 12px;" >
                    <img src="images/하단바/신고.png" alt="신고" style="width: 38px; height: 38px;">
                    <span style="margin-bottom: 4px;">신고</span>
                </button>

                <button class="bottom-button" onclick="location.href='mypage.html'">
                    <img src="images/하단바/자주가는경로.png" alt="즐겨찾기">
                    <span>즐겨찾기</span>
                </button>
                <button class="bottom-button" onclick="location.href='login.jsp'">
                    <img src="images/하단바/마이.png" alt="마이">
                    <span>마이</span>
                </button>
            </div>
            
            
            
            
            
            

            <div class="overlay" id="overlay"></div>
            
            
            
            
            
            

            <div id="emergency" class="loader">
                <div class="loader1"></div>
                <button id="declareBtn1">의심신고</button>
                <button id="declareBtn2">시설신고</button>
                <button id="declareBtn3">긴급신고</button>
               
            </div>
            

            
            <div id="map_div"  class="map-center" ></div>

            <div id="search-path" class="shadow">

                        <button id="menu" class="menu__icon">
                            <span></span>
                            <span></span>
                            <span></span>
                        </button>
                
                    <div id="inputBtn">
                        <button class="textBtn" onclick="toggleInputPath()">
                            <span id="inputText">주소를 입력하세요</span>
                        </button>
                        
                    </div>
                    <div id="inputPath"  style="display: none;">
                            <input type="text" class="inputAddres" id="keyword"> 
                    </div>
                
            </div>
            
            
            <div id="declareModal" >
                        <h2 class="declare-title">신고 접수</h2>

                        <form class="report-form">
                            <label for="report-title">제목</label>
                            <input type="text" id="report-title" class="form-input" placeholder="제목을 입력하세요">

                            <label for="reporter">접수자</label>
                            <input type="text" id="reporter" class="form-input" placeholder="접수자 이름">

                            <label for="location">위치</label>
                            <input type="text" id="location" class="form-input" placeholder="위치를 입력하세요">

                            <label for="content">내용</label>
                            <textarea id="content" class="form-input" rows="8" placeholder="신고 내용을 입력하세요"></textarea>
                        </form>

                        <div class="button-group">
                            <!--  <button type="button" class="formBtn formBtn-cancel" onclick="clearDataAndGoBack()">이전으로</button>-->
                            <button type="button" id="btn" class="formBtn formBtn-save" onclick="saveAndGoBack()">접수하기</button>
                        </div>
            </div>
            <div id="successMessage" style="display: none;" class="animate__animated">
                <p>접수가 완료되었습니다!</p>
                 <img src="images/체크.png" style="width: 35px; height: 35px;">
            </div>

            <div id="successMessage2" style="display: none;" class="animate__animated">
                <p>의심 신고가 완료되었습니다.<br>보호자에게 상황을 공유했어요.</p>
                 <img src="images/의심신고.png" style="width: 75px; height: 75px;">
            </div>

            <div id="successMessage3" style="display: none; color: rgb(255, 255, 255);" class="animate__animated">
                <p>긴급 신고가 접수되었습니다.<br> 즉시 대응 중입니다. 안전을 확보해주세요.</p>
                 <img src="images/긴급신고.png" style="width: 75px; height: 75px;">
            </div>

        </div>
    

   <script>
   
      const isLoggedIn = ${jsLoginCheck};
      
      window.addEventListener('DOMContentLoaded', () => {
          const buttons = document.querySelectorAll('.text-button span');
      
          buttons.forEach(span => {
              const text = span.textContent.trim();
              const parentButton = span.closest('button');
              const restrictedForGuests = ['자주가는 장소', '함께하는 사람들', '알리미'];
      
              if (!isLoggedIn && restrictedForGuests.includes(text)) {
                  parentButton.addEventListener('click', (event) => {
                      event.preventDefault();
                      alert('로그인이 필요한 서비스입니다.');
                  });
              }
          });
      });
   
      
      <!-- 2. 사이드바 및 검색창 토글 기능 처리 -->
      const menuIcon = document.getElementById('menu');
       const sidebarMember = document.getElementById('sidebarMember');
       const sidebarGuest = document.getElementById('sidebarGuest');
       const overlay = document.getElementById('overlay');
       const searchPath = document.getElementById('search-path');
       const inputBtn = document.getElementById('inputBtn');
       const inputText = document.getElementById('inputText');
       const loginBtn = document.getElementById('loginBtn');
       const joinBox = document.getElementById('joinBox');
       const inputPath = document.getElementById('inputPath');
       const declare = document.getElementById('declare');
       const emergency = document.getElementById('emergency');
       const bottomBar = document.getElementById('bottom-bar');
       const declareBtn1 = document.getElementById('declareBtn1');
       const declareBtn3 = document.getElementById('declareBtn3');
       const declareModal = document.getElementById('declareModal');
       const successMessage = document.getElementById('successMessage');
       const successMessage2 = document.getElementById('successMessage2');
       const successMessage3 = document.getElementById('successMessage3');
       const Gu = document.getElementById('Gu');
       

   
       
       function animateCSS(element, animationName) {
           return new Promise((resolve) => {
               element.classList.remove(
                   'animate__fadeInBottomRight',
                   'animate__fadeInBottomLeft',
                   'animate__fadeInUp',
                   'animate__fadeOutBottomRight',
                   'animate__fadeOutDown',
                   'animate__fadeOutBottomLeft',
                   'animate__animated',
                   'animate__faster'
               );

               element.style.display = 'block';
               element.classList.add('animate__animated', animationName, 'animate__faster');

               function handleAnimationEnd() {
                   element.classList.remove('animate__animated', animationName, 'animate__faster');
                   element.removeEventListener('animationend', handleAnimationEnd);
                   resolve();
               }

               element.addEventListener('animationend', handleAnimationEnd);
           });
           }
       
    

       menuIcon.addEventListener('click', function(event) {
           event.stopPropagation();

        
           
           if (isLoggedIn) {
                  sidebarMember.classList.add('show');
              } else {
                  sidebarGuest.classList.add('show');
              }   // 사이드바가 보이도록 전환    
           overlay.style.visibility = 'visible';     // 오버레이 표시
           overlay.classList.add('show');
           emergency.classList.remove('show');    
           bottomBar.classList.add('lower');
           
       });
       
       declareBtn1.addEventListener('click', function(event){
           successMessage2.classList.remove('animate__fadeOut');

           successMessage2.style.display = 'block';
           successMessage2.classList.remove('animate__fadeOutDown');
           successMessage2.classList.add('animate__fadeInUp');

               // 메시지가 1초 후 자동으로 사라지도록 설정
           setTimeout(function() {
           successMessage2.classList.remove('animate__fadeInUp');
           successMessage2.classList.add('animate__fadeOut');
           emergency.classList.remove('show');
               
               // 1초 후에 완전히 숨기기
           setTimeout(function() {
               successMessage2.style.display = 'none';
               overlay.style.zIndex = '1';
               overlay.classList.remove('show');
                    
               }, 100);  // 1초 후 완전히 숨기기
           }, 1000);  // 1초 후 사라지게 설정
       });

       declareBtn3.addEventListener('click', function(event){
           successMessage3.classList.remove('animate__fadeOut');

           successMessage3.style.display = 'block';
           successMessage3.classList.remove('animate__fadeOutDown');
           successMessage3.classList.add('animate__fadeInUp');

               // 메시지가 1초 후 자동으로 사라지도록 설정
           setTimeout(function() {
           successMessage3.classList.remove('animate__fadeInUp');
           successMessage3.classList.add('animate__fadeOut');
           emergency.classList.remove('show');
               
               // 1초 후에 완전히 숨기기
           setTimeout(function() {
               successMessage3.style.display = 'none';
               overlay.style.zIndex = '1';
               overlay.classList.remove('show');
                    
               }, 100);  // 1초 후 완전히 숨기기
           }, 1000);  // 1초 후 사라지게 설정
       });
       
       declareBtn2.addEventListener('click', function(event) {
           // 이전 애니메이션 클래스 제거
           declareModal.classList.remove('animate__fadeOutDown');
           declareModal.classList.remove('animate__fadeInUp');
           void declareModal.offsetWidth; // 강제 리플로우로 초기화

           // 다시 보여주기
           declareModal.style.display = 'flex';
           declareModal.classList.add('animate__animated', 'animate__fadeInUp');

           overlay.style.zIndex = '3';
       });

           function saveAndGoBack(){
               const successMessage = document.getElementById('successMessage');

               

           // 기존 등장 애니메이션 제거 후 강제 리플로우
               successMessage.classList.remove('animate__fadeOut');
               declareModal.classList.remove('animate__fadeInUp');
               declareModal.classList.remove('animate__fadeOutDown');
               void declareModal.offsetWidth;

               // 사라지는 애니메이션 적용
               declareModal.classList.add('animate__fadeOutDown');

               // 애니메이션 끝나면 실행
               declareModal.addEventListener('animationend', function handler() {
                   declareModal.style.display = 'none';
                   successMessage.style.display = 'block';
                   successMessage.classList.remove('animate__fadeOutDown');
                   successMessage.classList.add('animate__fadeInUp');

                   // 메시지가 1초 후 자동으로 사라지도록 설정
                   setTimeout(function() {
                   successMessage.classList.remove('animate__fadeInUp');
                   successMessage.classList.add('animate__fadeOut');
                   emergency.classList.remove('show');
                   
                   // 1초 후에 완전히 숨기기
                   setTimeout(function() {
                       successMessage.style.display = 'none';
                       overlay.style.zIndex = '1';
                       overlay.classList.remove('show');
                        
                   }, 100);  // 1초 후 완전히 숨기기
               }, 1000);  // 1초 후 사라지게 설정

               // 이벤트 리스너 중복 방지
               declareModal.removeEventListener('animationend', handler);
               });
           }
           
           window.addEventListener("DOMContentLoaded", () => {
               const declareBtn2 = document.getElementById("declareBtn2");
               if (declareBtn2) {
                 declareBtn2.addEventListener("click", () => {
                   fetch(contextPath + "/FacilityReport.do", { method: "POST" })
                     .then(res => {
                     })
                     .catch(err => {
                       console.error("신고 실패:", err);
                       alert("신고 중 오류가 발생했습니다.");
                     });
                 });
               }
             });
            



        

       overlay.addEventListener('click', function () {
           searchPath.style.zIndex = '1';
           if (isLoggedIn) {
                  sidebarMember.classList.remove('show');
              } else {
                  sidebarGuest.classList.remove('show');
              }
           overlay.classList.remove('show');
           
           emergency.classList.remove('show');  
           searchPath.classList.remove('expand');
           inputText.style.display = 'block';  // 인풋 텍스트 보이기
           inputPath.style.display = 'none';

           setTimeout(() => {
           emergency.style.visibility = 'hidden';
           }, 400);


           menuIcon.style.display = 'flex';
           void menuIcon.offsetWidth;  // 강제 리렌더링

           // 👇 아이콘 내부 span들 초기화
           const bars = menuIcon.querySelectorAll('span');
           bars.forEach((bar, index) => {
               bar.style.width = index === 0 ? '100%' : index === 1 ? '75%' : '50%';
               bar.style.transform = 'none';
               bar.style.backgroundColor = 'rgba(15, 15, 15, 0.822)';
           });
           

           setTimeout(() => {
           overlay.style.visibility = 'hidden';
           }, 400);
           
           declareBtn1.classList.add('animate__animated', 'animate__fadeOutBottomRight', 'animate__faster');
           setTimeout(() => {
               declareBtn2.classList.add('animate__animated', 'animate__fadeOutDown', 'animate__faster');
           }, 50);
           setTimeout(() => {          
               declareBtn3.classList.add('animate__animated', 'animate__fadeOutBottomLeft', 'animate__faster');
           }, 100);
           
       });
       
       

       declare.addEventListener('click', function(event){
           emergency.classList.add('show');
           emergency.style.visibility = 'visible';
           overlay.style.visibility = 'visible';     // 오버레이 표시
           overlay.classList.add('show')
           bottomBar.classList.remove('lower');


           animateCSS(declareBtn1, 'animate__fadeInBottomRight');
           setTimeout(() => {
               animateCSS(declareBtn2, 'animate__fadeInUp');
           }, 100);
           setTimeout(() => {
               animateCSS(declareBtn3, 'animate__fadeInBottomLeft');
           }, 200);
       });
       
       
       

       if (loginBtn) {
    	    loginBtn.addEventListener('click', function(event) {
    	        sidebarGuest.classList.remove('show');
    	        overlay.classList.remove('show');
    	        menuIcon.classList.remove('active');

    	        joinBox.classList.add('show');

    	        setTimeout(() => {
    	            location.href = "login.jsp";
    	        }, 800);
    	    });
    	}

       

       inputText.addEventListener('click', function(event){
          event.stopPropagation();
           searchPath.style.zIndex = '3';
           searchPath.classList.add('expand');
           inputPath.style.display = 'block';
           menuIcon.style.display = 'none';
           inputText.style.display = 'none';
           overlay.style.visibility = 'visible';     // 오버레이 표시
           overlay.classList.add('show');
           bottomBar.classList.add('lower');
       });

       

       document.getElementById("keyword").addEventListener("keydown", function(event) {
           if (event.key === "Enter") {
               event.preventDefault(); // 폼 제출 방지 (있을 경우)
               goToNextPage();
           }
       });



       function goToNextPage() {
          var address = document.getElementById("keyword").value;
          if (address) {
           // 주소로 위도, 경도 얻기
           $.ajax({
               method: "GET",
               url: "https://apis.openapi.sk.com/tmap/pois",
               data: {
                   version: 1,
                   format: "json",
                   searchKeyword: address,
                   resCoordType: "WGS84GEO",
                   reqCoordType: "WGS84GEO",
                   count: 1,
                   appKey: "C0A4SwhCGE2ocuN4vTAeD7ClrI5Jb1Kk5nj6or4F"
               },
               success: function (response) {
                   if (response.searchPoiInfo.pois.poi.length > 0) {
                       var poi = response.searchPoiInfo.pois.poi[0];
                       var lat = poi.frontLat;
                       var lon = poi.frontLon;

                       // 위도, 경도를 포함하여 페이지 전환
                       window.location.href = "searchAddress.jsp?address=" + encodeURIComponent(address) + "&lat=" + lat + "&lon=" + lon;
                   } else {
                       alert("검색 결과가 없습니다.");
                   }
               },
               error: function (request, status, error) {
                   console.error("요청 실패:", request.responseText);
               }
           });
       } else {
           alert("주소를 입력해주세요.");
       }
       }
   
       const container = document.getElementById("facility-container");

       let isDown = false;
       let startX;
       let scrollLeft;

       // 마우스를 클릭했을 때
       container.addEventListener("mousedown", (e) => {
           isDown = true;
           container.classList.add('active');
           startX = e.pageX - container.offsetLeft;  // 클릭한 위치
           scrollLeft = container.scrollLeft;        // 현재 스크롤 위치
       });

       // 마우스가 떠났을 때
       container.addEventListener("mouseleave", () => {
           isDown = false;
           container.classList.remove('active');
       });

       // 마우스를 뗐을 때
       container.addEventListener("mouseup", () => {
           isDown = false;
           container.classList.remove('active');
       });

       // 마우스를 움직일 때
       container.addEventListener("mousemove", (e) => {
           if (!isDown) return;  // 마우스를 누르고 있지 않으면 안 움직임
           e.preventDefault();
           const x = e.pageX - container.offsetLeft; // 현재 마우스 위치
           const walk = (x - startX) * 1;  // 드래그 감도 (조절 가능)
           container.scrollLeft = scrollLeft - walk;  // 스크롤을 움직임
       });
       
       
       const urlParams = new URLSearchParams(window.location.search);
       const routeType = urlParams.get('type');
         
       function showRoute(routeType) {
            initTmap(); // 기존 경로와 마커 제거
            
                        
            switch(routeType) {
                case 'safe':
                    safeRoute(); // 안전 경로
                    map.setCenter(new Tmapv2.LatLng(35.150509, 126.858589)); // 운천역 중심
                    map.setZoom(17);
                    break;
                case 'mainroad':
                    mainroadRoute(); // 큰길 경로
                    map.setCenter(new Tmapv2.LatLng(35.150509, 126.858589)); // 시청 중심
                    map.setZoom(17);
                    break;
                case 'shortest':
                    shortestRoute(); // 최단 경로
                    map.setCenter(new Tmapv2.LatLng(35.150509, 126.858589)); // 시청 중심
                    map.setZoom(17);
                    break;
            }
        }

        // 각 경로 함수 (안전 경로, 큰길 경로, 최단 경로)
        function safeRoute() {
            drawPolyline([
                [126.858611, 35.150523],
                [126.856079, 35.150154],
                [126.855123, 35.151668],
                [126.855112, 35.155585],
                [126.855273, 35.156358],
                [126.855930, 35.158026],
                [126.855988, 35.158737],
                [126.859261, 35.158764],
                [126.859362, 35.160187],
                [126.859581 ,35.160189],
                [126.859636 ,35.161182],
                [126.859754, 35.161202]
            ]);
        }

        function mainroadRoute() {
            drawPolyline([
               [126.858611, 35.150523],
                [126.856079, 35.150154],
                [126.855123, 35.151668],
                [126.855112, 35.155585],
                [126.855273, 35.156358],
                [126.855930, 35.158026],
                [126.855988, 35.158737],
                [126.856007, 35.161697],
                [126.856446, 35.161876],
                [126.859402, 35.161725],
                [126.859407, 35.161912],
                [126.859709, 35.161906],
                [126.859646, 35.161232],
                [126.859754, 35.161202]
            ]);
        }

        function shortestRoute() {
            drawPolyline([
                [126.858611, 35.150523],
                [126.858722, 35.150680],
                [126.858456, 35.151829],
                [126.858397, 35.152876],
                [126.858511, 35.153662],
                [126.858737, 35.154284],
                [126.859450, 35.155639],
                [126.859446, 35.158785],
                [126.859628, 35.161163],
                [126.859754, 35.161202]
            ]);
        }

        // 경로를 그리는 함수
        function drawPolyline(coords) {
            const resultMarkerArr = [], resultInfoArr = [];
            coords.forEach((coord, idx) => {
                const marker = new Tmapv2.Marker({
                    position: new Tmapv2.LatLng(coord[1], coord[0]),
                    icon: idx === 0 ? "images/Marker/pin1.png" :
                          idx === coords.length - 1 ? "images/Marker/pin2.png" :
                          "null",
                    iconSize: new Tmapv2.Size(24, 48),
                    map: map
                });
                resultMarkerArr.push(marker);
            });

            const latlngs = coords.map(c => new Tmapv2.LatLng(c[1], c[0]));
            const polyline = new Tmapv2.Polyline({
                path: latlngs,
                strokeColor: "#0000ff",
                strokeWeight: 6,
                map: map
            });
            resultInfoArr.push(polyline);
        }

        // 기존 경로 초기화
        function clearMap() {
            if (window.resultInfoArr) {
                window.resultInfoArr.forEach(polyline => polyline.setMap(null));
                window.resultInfoArr = [];
            }
            if (window.resultMarkerArr) {
                window.resultMarkerArr.forEach(marker => marker.setMap(null));
                window.resultMarkerArr = [];
            }
        }

        // 페이지 로딩 시 경로 표시
        window.onload = function () {
            showRoute(routeType);
        };
       
   </script>

</body>
</html>