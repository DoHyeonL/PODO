<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");
    String routeType = request.getParameter("type");
    
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메인 화면</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link href="https://webfontworld.github.io/gmarket/GmarketSans.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
    <script src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=vD2v8S3ooW650frcHc8R91xdR9ea6EKKAsVFiLaj"></script>
    
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

    function initTmap(latitude = 35.160370, longitude = 126.851392) {
        map = new Tmapv2.Map("map_div", {
        center: new Tmapv2.LatLng(latitude, longitude),
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

        fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error("서버 응답 실패");
                }
                return response.json();
            })
            .then(data => {
                if (!Array.isArray(data) || data.length === 0) {
                    console.warn("해당 카테고리 마커 없음");
                    return;
                }

                // 기존 마커 삭제 (마커 리스트 초기화)
                categoryMarkers[category].forEach(m => m.setMap(null));
                categoryMarkers[category] = []; // 해당 카테고리 마커 리스트 초기화

                // 새로운 카테고리 데이터 마커 추가
                data.forEach(fac => {
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
    
    <link rel="stylesheet" href="css/main-page.css"/>
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


    <iframe src="title.html" class="text-bg-frame" frameborder="0" scrolling="no"></iframe>
    
   <main id="map-container">

      <c:choose>
          <c:when test="${isLoggedIn eq 'true'}">
              <nav id="sidebarMember">
                  <button class='textBtn' style="margin-top: 70px; margin-left: 40px;">
                      <span style="font-size: clamp(22px, 5vw, 28px); font-weight: bold;">
                          ${loginvo.name}님 안녕하세요
                      </span>
                  </button>
                  <hr style="margin-top: 20px; border: none; height: 1px; background-color: rgba(145, 136, 136, 0.2); width: 90%;">
                  <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="goToSearch()">
                      <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold;">안심길찾기</span>
                  </button>
                  <button class='textBtn' style="margin-top: 20px; margin-left: 40px;">
                      <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold;">자주가는 장소</span>
                  </button>
                  <button id="Gu" class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='Alarm.do'">
                      <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold;">함께하는 사람들</span>
                  </button>
                  <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='Alarm.do'">
                      <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold;">알리미</span>
                  </button>
                  <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='report.jsp'">
                      <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold;">신고함</span>
                  </button>
                  <button class='textBtn' style="margin-top: 30px; margin-left: 40px;" 
                        onclick="alert('로그아웃 되었습니다.'); location.href='Logout.do';">
                      <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold; color: red;">로그아웃</span>
                  </button>
              </nav>
          </c:when>
          <c:otherwise>
              <nav id="sidebarGuest" >
                <button id = "loginBtn" class='textBtn' style="margin-top: 100px; margin-left: 40px;">
                    <span style="font-size: clamp(22px, 5vw, 28px); font-weight: bold; ">
                        로그인을 해주세요
                    </span>    
                </button>
            
                <hr style="margin-top: 20px; border: none; height: 1px; background-color: rgba(145, 136, 136, 0.2); width: 90%;">
            
                <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="goToSearch()">
                    <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold; ">
                        안심길찾기
                    </span>
                </button>

            
                <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='report.jsp'">
                    <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold; ">
                        신고함
                    </span>
                </button>


            </nav>
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
            
            <button class="facilityBtn" onclick="alert('CCTV 위치 데이터는 아직 준비 중입니다.')">
                <img src="images/시설물/CCTV.png" alt="CCTV">
                <div class="facility">CCTV (준비중)</div>
            </button>
            
            <button class="facilityBtn" onclick="toggleMarkersByCategory(4)">
                <img src="images/시설물/안심시설.png" alt="안심시설">
                <div class="facility">안심시설</div>
            </button>

                 </div>
                 
                 
                 
                 

            <nav id="bottom-bar">

                <button class="bottom-button">
                    <img src="images/하단바/주변.png" alt="주변" style="width: 35px; height: 35px;">
                    <span>주변</span>
                </button>


                <button class="bottom-button" style="margin-left: 10px;" onclick="location.href='Alarm.do'">
                    <img src="images/하단바/알리미.png" alt="알리미" style="width: 35px; height: 35px;" >
                    <span style="margin-bottom: 4px;">알리미</span>
                </button>
                
                

                <button id="declare" class="bottom-button" style="margin-left: 12px;" >
                    <img src="images/하단바/신고.png" alt="신고" style="width: 38px; height: 38px;">
                    <span style="margin-bottom: 4px;">신고</span>
                </button>

                <button class="bottom-button">
                    <img src="images/하단바/자주가는경로.png" alt="즐겨찾기">
                    <span>즐겨찾기</span>
                </button>
                <button class="bottom-button" onclick="if (!isLoggedIn) { location.href='login.jsp'; }">
                    <img src="images/하단바/마이.png" alt="마이">
                    <span>마이</span>
                </button>
            </nav>
            
            
            
            
            
            

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
                        <button class="textBtn">
                            <span id="inputText">주소를 입력하세요</span>
                        </button>

                    </div>
                    <div id="inputPath"  style="display: none;">
                            <input type="text" class="inputAddres" id="keyword" placeholder="출발지를 입력하세요">
                    </div>

            </div>

            <div id="search-result-list"></div>

            <div id="roleSelectCard" class="shadow">
                <div id="roleSelectText"></div>
                <div class="roleBtnGroup">
                    <button class="roleBtn" id="setStartBtn">출발지로 설정</button>
                    <button class="roleBtn" id="setEndBtn">도착지로 설정</button>
                </div>
            </div>

            <div id="navInfoCard" class="shadow">
                <button id="navHomeBtn" onclick="exitNavigation()">✕</button>
                <div id="navInfoTitle"></div>
                <div id="navInfoDetail"></div>
                <div id="navInfoSafety"></div>
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
                 <img src="images/체크.png" alt="체크 완료" style="width: 35px; height: 35px;">
            </div>

            <div id="successMessage2" style="display: none;" class="animate__animated">
                <p>의심 신고가 완료되었습니다.<br>보호자에게 상황을 공유했어요.</p>
                 <img src="images/의심신고.png" alt="의심 신고" style="width: 75px; height: 75px;">
            </div>

            <div id="successMessage3" style="display: none; color: rgb(255, 255, 255);" class="animate__animated">
                <p>긴급 신고가 접수되었습니다.<br> 즉시 대응 중입니다. 안전을 확보해주세요.</p>
                 <img src="images/긴급신고.png" alt="긴급 신고" style="width: 75px; height: 75px;">
            </div>

        </main>


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

           // 신고 접수 창도 바깥 클릭하면 같이 닫히게
           if (declareModal.style.display === 'flex') {
               declareModal.style.display = 'none';
           }

           // 출발지/도착지 검색 중이었으면 같이 초기화
           roleSelectCard.style.display = 'none';
           resultList.style.display = 'none';
           firstPoint = null;
           firstRole = null;

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
           firstPoint = null;
           firstRole = null;
           keywordInput.placeholder = "출발지를 입력하세요";
           keywordInput.value = "";
           searchPath.style.zIndex = '3';
           searchPath.classList.add('expand');
           inputPath.style.display = 'block';
           menuIcon.style.display = 'none';
           inputText.style.display = 'none';
           overlay.style.visibility = 'visible';     // 오버레이 표시
           overlay.classList.add('show');
           bottomBar.classList.add('lower');
           keywordInput.focus();
       });

       // 사이드바에서 안심길찾기 눌렀을 때도 같은 검색창을 여는 함수
       function goToSearch() {
           if (isLoggedIn) {
               sidebarMember.classList.remove('show');
           } else {
               sidebarGuest.classList.remove('show');
           }

           firstPoint = null;
           firstRole = null;
           keywordInput.placeholder = "출발지를 입력하세요";
           keywordInput.value = "";

           searchPath.style.zIndex = '3';
           searchPath.classList.add('expand');
           inputPath.style.display = 'block';
           inputText.style.display = 'none';
           menuIcon.style.display = 'none';
           overlay.style.visibility = 'visible';
           overlay.classList.add('show');
           bottomBar.classList.add('lower');
           keywordInput.focus();
       }

       // 출발지/도착지 검색 상태 관리
       let searchDebounce;
       let firstPoint = null;   // 먼저 고른 장소 { name, lat, lon }
       let firstRole = null;    // 먼저 고른 장소가 출발지인지 도착지인지
       let searchMarker = null;

       const keywordInput = document.getElementById("keyword");
       const resultList = document.getElementById("search-result-list");
       const roleSelectCard = document.getElementById("roleSelectCard");
       const roleSelectText = document.getElementById("roleSelectText");
       const setStartBtn = document.getElementById("setStartBtn");
       const setEndBtn = document.getElementById("setEndBtn");

       keywordInput.addEventListener("input", function () {
           clearTimeout(searchDebounce);
           const keyword = keywordInput.value;
           searchDebounce = setTimeout(function () {
               searchAddressLive(keyword);
           }, 300);
       });

       // 입력할 때마다 실시간으로 검색 결과 리스트 보여주기
       function searchAddressLive(keyword) {
           if (keyword.trim().length < 2) {
               resultList.style.display = "none";
               resultList.innerHTML = "";
               return;
           }

           $.ajax({
               method: "GET",
               url: "https://apis.openapi.sk.com/tmap/pois",
               data: {
                   version: 1,
                   searchKeyword: keyword,
                   resCoordType: "WGS84GEO",
                   reqCoordType: "WGS84GEO",
                   count: 10,
                   appKey: "vD2v8S3ooW650frcHc8R91xdR9ea6EKKAsVFiLaj"
               },
               success: function (response) {
                   const pois = response.searchPoiInfo && response.searchPoiInfo.pois ? response.searchPoiInfo.pois.poi : [];
                   resultList.innerHTML = "";

                   if (!pois || pois.length === 0) {
                       resultList.innerHTML = "<div class='search-result-item'>검색 결과가 없습니다.</div>";
                       resultList.style.display = "block";
                       return;
                   }

                   pois.forEach(function (poi) {
                       const name = (poi.name || "이름 없음").replace(/['"<>]/g, "");
                       const addrParts = [poi.upperAddrName, poi.middleAddrName, poi.lowerAddrName].filter(Boolean);
                       const address = addrParts.join(" ");

                       const item = document.createElement("div");
                       item.className = "search-result-item";
                       item.innerHTML = "<div class='search-result-name'>" + name + "</div>"
                           + "<div class='search-result-address'>" + address + "</div>";

                       item.addEventListener("click", function () {
                           selectSearchResult(name, poi.frontLat, poi.frontLon);
                       });

                       resultList.appendChild(item);
                   });

                   resultList.style.display = "block";
               },
               error: function () {
                   resultList.innerHTML = "<div class='search-result-item'>검색에 실패했습니다.</div>";
                   resultList.style.display = "block";
               }
           });
       }

       // 검색 결과에서 장소를 골랐을 때
       function selectSearchResult(name, lat, lon) {
           resultList.style.display = "none";
           resultList.innerHTML = "";

           // 고른 장소로 지도 이동
           map.setCenter(new Tmapv2.LatLng(lat, lon));
           map.setZoom(17);

           if (searchMarker) {
               searchMarker.setMap(null);
           }
           searchMarker = new Tmapv2.Marker({
               position: new Tmapv2.LatLng(lat, lon),
               icon: "images/Marker/pin1.png",
               iconSize: new Tmapv2.Size(24, 38),
               map: map
           });

           if (!firstPoint) {
               // 처음 고른 장소 → 출발지/도착지 중 뭐로 할지 물어보기
               firstPoint = { name: name, lat: lat, lon: lon };

               roleSelectText.innerText = name + " (을)를 어디로 설정할까요?";
               roleSelectCard.style.display = "block";

               inputPath.style.display = "none";
               inputText.style.display = "block";
           } else {
               // 두 번째 장소까지 골랐으면 바로 경로탐색 화면으로 이동
               goToRoute({ name: name, lat: lat, lon: lon });
           }
       }

       setStartBtn.addEventListener("click", function () {
           firstRole = "start";
           askSecondPoint("도착지를 입력하세요");
       });

       setEndBtn.addEventListener("click", function () {
           firstRole = "end";
           askSecondPoint("출발지를 입력하세요");
       });

       // 두 번째 장소(출발지 또는 도착지)를 다시 검색창으로 물어보기
       function askSecondPoint(placeholderText) {
           roleSelectCard.style.display = "none";

           keywordInput.placeholder = placeholderText;
           keywordInput.value = "";

           searchPath.style.zIndex = "3";
           searchPath.classList.add("expand");
           inputPath.style.display = "block";
           inputText.style.display = "none";
           menuIcon.style.display = "none";
           overlay.style.visibility = "visible";
           overlay.classList.add("show");
           bottomBar.classList.add("lower");
           keywordInput.focus();
       }

       // 출발지/도착지가 다 정해졌으면 실제 경로 화면(pathSelect.jsp)으로 이동
       function goToRoute(secondPoint) {
           let start, end;
           if (firstRole === "start") {
               start = firstPoint;
               end = secondPoint;
           } else {
               start = secondPoint;
               end = firstPoint;
           }

           window.location.href = "pathSelect.jsp?start=" + encodeURIComponent(start.name)
               + "&end=" + encodeURIComponent(end.name)
               + "&startLat=" + start.lat + "&startLon=" + start.lon
               + "&endLat=" + end.lat + "&endLon=" + end.lon;
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

       let navMarkers = [];
       let navPolylines = [];
       let facilityMarkers = [];

       // pathSelect.jsp에서 안내 버튼 눌렀을 때 실제 좌표로 진짜 경로 그리기
       function showRoute(routeType) {
            initTmap();

            if (!routeType) {
                return; // 그냥 메인화면 접속한 경우 (안내 중이 아님)
            }

            const startLat = urlParams.get("startLat");
            const startLon = urlParams.get("startLon");
            const endLat = urlParams.get("endLat");
            const endLon = urlParams.get("endLon");

            if (!startLat || !startLon || !endLat || !endLon) {
                return; // 좌표 없이 들어온 경우
            }

            loadRealRouteOnMain(routeType, startLat, startLon, endLat, endLon);
        }

        function loadRealRouteOnMain(routeType, startLat, startLon, endLat, endLon) {
            $.ajax({
                method: "POST",
                url: "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json",
                headers: { "appKey": "vD2v8S3ooW650frcHc8R91xdR9ea6EKKAsVFiLaj" },
                data: {
                    startX: startLon,
                    startY: startLat,
                    endX: endLon,
                    endY: endLat,
                    reqCoordType: "WGS84GEO",
                    resCoordType: "WGS84GEO",
                    startName: "출발지",
                    endName: "도착지"
                },
                success: function (response) {
                    const features = response.features;
                    const coords = [];
                    features.forEach(function (f) {
                        if (f.geometry.type === "LineString") {
                            f.geometry.coordinates.forEach(function (c) { coords.push(c); });
                        }
                    });

                    drawPolyline(coords);
                    map.setCenter(new Tmapv2.LatLng(startLat, startLon));
                    map.setZoom(16);

                    const totalDistance = features[0].properties.totalDistance;
                    const totalTime = features[0].properties.totalTime;
                    const distanceKm = (totalDistance / 1000).toFixed(1);
                    const minutes = Math.round(totalTime / 60);

                    const routeLabel = routeType === "safe" ? "안전 경로" : "최단 경로";

                    document.getElementById("navInfoTitle").innerText = routeLabel + " 안내 중";
                    document.getElementById("navInfoDetail").innerText = minutes + "분 | " + distanceKm + "km";
                    document.getElementById("navInfoSafety").innerText = "";
                    document.getElementById("navInfoCard").style.display = "block";

                    if (routeType === "safe") {
                        calculateSafetyScore(coords);
                    }
                },
                error: function (request, status, error) {
                    console.error("경로 요청 실패:", request.responseText);
                }
            });
        }

        // 두 좌표 사이 거리 계산 (하버사인 공식, 단위: m)
        function haversineDistance(lat1, lon1, lat2, lon2) {
            const R = 6371000;
            const dLat = (lat2 - lat1) * Math.PI / 180;
            const dLon = (lon2 - lon1) * Math.PI / 180;
            const a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180)
                * Math.sin(dLon / 2) * Math.sin(dLon / 2);
            const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
            return R * c;
        }

        // 시설물이 경로 좌표들 중 하나와 반경 이내로 가까운지 확인
        function isNearRoute(lat, lon, coords, radiusM) {
            for (let i = 0; i < coords.length; i++) {
                const dist = haversineDistance(lat, lon, coords[i][1], coords[i][0]);
                if (dist <= radiusM) {
                    return true;
                }
            }
            return false;
        }

        // 경로 주변 200m 이내 안전시설(경찰서/소방서/편의점) 개수로 안전 점수 계산
        function calculateSafetyScore(coords) {
            const categories = [1, 2, 4]; // 경찰서, 소방서, 편의점
            const radius = 200;
            const counts = { 1: 0, 2: 0, 4: 0 };
            const nearbyFacilities = []; // 점수에 실제로 반영된 시설들 (지도에 마커로 보여줄 것)
            let requestsLeft = categories.length;

            categories.forEach(function (category) {
                fetch(contextPath + "/FacilityMap.do?category=" + category)
                    .then(function (response) { return response.json(); })
                    .then(function (data) {
                        if (Array.isArray(data)) {
                            data.forEach(function (fac) {
                                if (isNearRoute(fac.lat, fac.lon, coords, radius)) {
                                    counts[category]++;
                                    nearbyFacilities.push(fac);
                                }
                            });
                        }
                    })
                    .catch(function () {
                        console.error("시설 정보 불러오기 실패 (category " + category + ")");
                    })
                    .finally(function () {
                        requestsLeft--;
                        if (requestsLeft === 0) {
                            showSafetyResult(counts);
                            showNearbyFacilityMarkers(nearbyFacilities);
                        }
                    });
            });
        }

        function showSafetyResult(counts) {
            const total = counts[1] + counts[2] + counts[4];
            const score = Math.min(total * 10, 100);

            document.getElementById("navInfoSafety").innerText =
                "안전 점수 : " + score + "점 (경로 주변 200m 이내 경찰서 " + counts[1]
                + "곳, 소방서 " + counts[2] + "곳, 편의점 " + counts[4] + "곳)";
        }

        // 안전 점수 계산에 실제로 반영된 시설들을 지도 위에 마커로 표시
        function showNearbyFacilityMarkers(nearbyFacilities) {
            nearbyFacilities.forEach(function (fac) {
                const marker = new Tmapv2.Marker({
                    position: new Tmapv2.LatLng(fac.lat, fac.lon),
                    icon: fac.icon_path,
                    iconSize: new Tmapv2.Size(28, 28),
                    map: map
                });
                facilityMarkers.push(marker);
            });
        }

        // 경로를 그리는 함수 (출발/도착 마커만 표시)
        function drawPolyline(coords) {
            clearMap();

            if (coords.length > 0) {
                const startMarker = new Tmapv2.Marker({
                    position: new Tmapv2.LatLng(coords[0][1], coords[0][0]),
                    icon: "images/Marker/pin1.png",
                    iconSize: new Tmapv2.Size(24, 38),
                    map: map
                });
                navMarkers.push(startMarker);

                if (coords.length > 1) {
                    const endMarker = new Tmapv2.Marker({
                        position: new Tmapv2.LatLng(coords[coords.length - 1][1], coords[coords.length - 1][0]),
                        icon: "images/Marker/pin2.png",
                        iconSize: new Tmapv2.Size(24, 38),
                        map: map
                    });
                    navMarkers.push(endMarker);
                }
            }

            const latlngs = coords.map(c => new Tmapv2.LatLng(c[1], c[0]));
            const polyline = new Tmapv2.Polyline({
                path: latlngs,
                strokeColor: "#0000ff",
                strokeWeight: 6,
                map: map
            });
            navPolylines.push(polyline);
        }

        // 기존 경로 초기화
        function clearMap() {
            navPolylines.forEach(function (p) { p.setMap(null); });
            navPolylines = [];
            navMarkers.forEach(function (m) { m.setMap(null); });
            navMarkers = [];
            facilityMarkers.forEach(function (m) { m.setMap(null); });
            facilityMarkers = [];
        }

        // 경로 안내 중에 홈 화면으로 돌아가기 (X버튼)
        function exitNavigation() {
            window.location.href = "main.jsp";
        }

        // 페이지 로딩 시 경로 표시
        window.onload = function () {
            showRoute(routeType);
        };
       
   </script>

</body>
</html>