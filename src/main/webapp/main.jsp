<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메인 화면</title>
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

    function initTmap() {
        map = new Tmapv2.Map("map_div", {
            center: new Tmapv2.LatLng(37.56520450, 126.98702028),
            width: "550px",
            height: "100%",
            zoom: 17
        });
    }

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

        /* HTML: <div class="loader"></div> */
        .loader {
            width: 320px;
            aspect-ratio: 1;
            border-radius: 60%;
            background: #e42525;
            box-shadow: 0 0 0 0 rgba(240, 34, 34, 0.267);
            animation: l2 1.5s infinite linear;
            position: relative;
            left: 21%;
            top:80%;
            opacity: 0;
            transition: transform 0.9s ease, opacity 0.8s ease;
            z-index: 1;
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
            left: 250px;
            width: 100%;
            min-width: 550px;
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
            position: fixed;
            left: 50%;           
            top: 50px;            
            width: 450px;  
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

       
        .expand {
            position: fixed !important;
            top: 50px !important;
            left: 500 !important;
            width: 85vw !important;
            height: 100px !important;
            background-color: #999595 !important;
            max-width: none;
            z-index: 1 !important;
            transition:
                top 0.6s ease,
                left 0.6s ease,
                width 0.7s ease,
                height 0.7s ease,
                background-color 0.6s ease ;
        }

        /*.expand.shadow {
            box-shadow: none;
        }*/


        #inputhBtn{
            width: 100%;
        }

        

        #menu-icon {
            cursor: pointer;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: center; /* 아이콘을 수직 중앙에 배치 */
            top: 25px; /* 아이콘 메뉴를 화면 위(top) 기준으로 25px 아래에 생성*/
            width: 30px; /*메뉴 아이콘이라는 컨테이너틀의 너비를 30px로 설정*/
            height: 20px; /*메뉴 아이콘이라는 컨테이너틀의 높이를 25px로 설정*/
        }

        #menu-icon .bar{
            height: 2px;
            width: 100%;
            background-color: #333;
            border-radius: 2px;
            transition: all 0.3s ease; /* 모든 변화(ex.100px 에서 300px로 변신)등을 자연스럽게 애니메이션 처리해줌*/
            transform-origin: center; /*요소 자체를 변형시킴(ex. transform: rotate(45deg); 45도 회전함)*/
        }


        #menu-icon.active .bar:nth-child(1){
            transform: rotate(-90deg) translate(5px, 5px);
            /*menu-icon에 active가 붙으면

            첫 번째 bar (햄버거 메뉴의 1번째 줄)을

            45도 회전시키고

            x축 +5px / y축 +5px로 이동
        
            그래서 첫 번째 줄이 대각선 방향으로 기울면서 움직임.*/
            opacity: 0;
         }

         #menu-icon.active .bar:nth-child(2){
            opacity: 0;
            /*완전히 투명하게 변경*/
         }

         #menu-icon.active .bar:nth-child(3){
            transform: rotate(90deg) translate(5px, -5px);
            opacity: 0;
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
            position: fixed;  /* 화면에 고정 */
            bottom: 0px;         /* 화면 세로 중앙 */
            left:50%;        /* 화면 가로 중앙 */
            width: 550px;     /* 고정된 너비 */
            min-width: 400px; /* 최소 너비 */
            height: 70px;
            margin-left: 250px;
            background-color: #fff;
            display: flex;
            justify-content: space-around;
            align-items: center;
            border-top: 1px solid #ccc;
            z-index: 2;

            /* 중앙 정렬을 위한 transform */
            transform: translate(-50%); /* 요소의 크기의 절반만큼 이동시켜 정확히 중앙에 배치 */
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
            width: 24px;
            height: 24px;
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
            z-index: 1;
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
        }

        .loginHidden{
            position: absolute;
            left: 550px;
            width: 550px;
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

<body onload="initTmap();">

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
		        <div id="sidebarMember" class="hidden">
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
		            <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='list.html'">
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
		        <div id="sidebarGuest" class="hidden">
		            <button id="loginBtn" class='textBtn' style="margin-top: 100px; margin-left: 40px;">
		                <span style="font-size: clamp(22px, 5vw, 28px); font-weight: bold;">로그인을 해주세요</span>
		            </button>
		            <hr style="margin-top: 20px; border: none; height: 1px; background-color: rgba(145, 136, 136, 0.2); width: 90%;">
		            <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='pathSearch.jsp'">
		                <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold;">안심길찾기</span>
		            </button>
		            <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='join.html'">
		                <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold;">신고함</span>
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
                <button class="bottom-button" onclick="location.href='index.html'">
                    <img src="images/하단바/내비게이션.png" alt="내비">
                    <span>내비</span>
                </button>
                
                <button class="bottom-button" style="margin-left: 12px;" onclick="location.href='mypage.html'">
                    <img src="images/하단바/로케이션.png" alt="주변">
                    <span>주변</span>
                </button>

                <button id="declare" class="bottom-button" style="margin-left: 12px;" >
                    <img src="images/하단바/신고.png" alt="신고" style="width: 35px; height: 35px;">
                    <span>신고</span>
                </button>

                <button class="bottom-button" onclick="location.href='mypage.html'">
                    <img src="images/하단바/즐겨찾기.png" alt="즐겨찾기">
                    <span>즐겨찾기</span>
                </button>
                <button class="bottom-button" onclick="location.href='로그인.html'">
                    <img src="images/하단바/프로필.png" alt="마이">
                    <span>마이</span>
                </button>
            </div>

            <div class="overlay" id="overlay"></div>

            <div id="emergency" class="loader"></div>

            
            <div id="map_div"  class="map-center" >

                

                <div id="search-path" class="shadow">
    
                    <div id="menu-icon">
                        <div class="bar"></div>
                        <div class="bar"></div>
                        <div class="bar"></div>    
                    </div>
                
                    <div id="inputBtn">
                        <button class="textBtn" onclick="toggleInputPath()">
                            <span id="inputText">주소를 입력하세요</span>
                        </button>
                        <div id="inputPath" style="display: none">
                                <form onsubmit="searchPlaces(); return false;" >
                                    <input type="text" class="textBtn" placeholder="출발지 주소를 입력하세요." id="keyword" size="15" style="margin-right: 10px;"> 
                                    <button type="submit" class="textBtn" style="display: flex;"></button>
                                    <hr style="width: 82vw; background-color: #fff;">
                                    <input type="text" class="textBtn" value="출발지" id="keyword" size="15" style="margin-right: 10px;"> 
                
                                </form>
                                <div class="map_wrap">
                                    <div id="menu_wrap" >
                                        <ul id="placesList" ></ul>
                                        <div id="pagination"></div>
                                    </div>
                                </div>
                                <input type="text" class="textBtn" style="font-size: 20px;">
                           
                        </div>
                    </div>
                
                </div>


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
	    const menuIcon = document.getElementById('menu-icon');
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
	    
	
	    menuIcon.addEventListener('click', function(event) {
	        event.stopPropagation();
	        if (isLoggedIn) {
	            sidebarMember.classList.add('show');
	        } else {
	            sidebarGuest.classList.add('show');
	        }
	        menuIcon.classList.toggle('active');
	        overlay.style.visibility = 'visible';
	        overlay.classList.add('show');
	        emergency.classList.remove('show');    
	    });
	
	    overlay.addEventListener('click', function () {
	        sidebarGuest.classList.remove('show');
	        overlay.classList.remove('show');
	        menuIcon.classList.remove('active');
	
	        setTimeout(() => {
	        overlay.style.visibility = 'hidden';
	        }, 400);
	    });
	
	    loginBtn.addEventListener('click', function(event) {
	        sidebarGuest.classList.remove('show');
	        overlay.classList.remove('show');
	        menuIcon.classList.remove('active');
	
	        joinBox.classList.add('show');
	
	
	        setTimeout(() => {
	            location.href = "login.jsp";
	        }, 800);
	    });
	
	    declare.addEventListener('click', function(event){
	        emergency.classList.add('show');
	        overlay.style.visibility = 'visible';     // 오버레이 표시
	        overlay.classList.add('show')
	    });
	
	    
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
	    
	</script>

</body>
</html>