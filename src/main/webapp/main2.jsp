<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메인 화면</title>
    <script src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=qjdtka4as3"></script>
    <style>

.map_wrap, .map_wrap * {margin:0;padding:0;font-family:'Malgun Gothic',dotum,'돋움',sans-serif;font-size:12px;}
.map_wrap a, .map_wrap a:hover, .map_wrap a:active{color:#000;text-decoration: none;}

.bg_white {background:#fff;}
#menu_wrap hr {display: block; height: 1px;border: 0; border-top: 2px solid #5F5F5F;margin:3px 0;}
#menu_wrap .option{text-align: center;}
#menu_wrap .option p {margin:10px 0;}  
#menu_wrap .option button {margin-left:5px;}
#placesList li {list-style: none;}
#placesList .item {position:relative;border-bottom:1px solid #888;overflow: hidden;cursor: pointer;min-height: 65px;}
#placesList .item span {display: block;margin-top:4px;}
#placesList .item h5, #placesList .item .info {text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}
#placesList .item .info{padding:10px 0 10px 55px;}
#placesList .info .gray {color:#8a8a8a;}
#placesList .info .jibun {padding-left:26px;background:url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/places_jibun.png) no-repeat;}
#placesList .info .tel {color:#009900;}
#placesList .item .markerbg {float:left;position:absolute;width:36px; height:37px;margin:10px 0 0 10px;background:url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png) no-repeat;}
#placesList .item .marker_1 {background-position: 0 -10px;}
#placesList .item .marker_2 {background-position: 0 -56px;}
#placesList .item .marker_3 {background-position: 0 -102px}
#placesList .item .marker_4 {background-position: 0 -148px;}
#placesList .item .marker_5 {background-position: 0 -194px;}
#placesList .item .marker_6 {background-position: 0 -240px;}
#placesList .item .marker_7 {background-position: 0 -286px;}
#placesList .item .marker_8 {background-position: 0 -332px;}
#placesList .item .marker_9 {background-position: 0 -378px;}
#placesList .item .marker_10 {background-position: 0 -423px;}
#placesList .item .marker_11 {background-position: 0 -470px;}
#placesList .item .marker_12 {background-position: 0 -516px;}
#placesList .item .marker_13 {background-position: 0 -562px;}
#placesList .item .marker_14 {background-position: 0 -608px;}
#placesList .item .marker_15 {background-position: 0 -654px;}
#pagination {margin:10px auto;text-align: center;}
#pagination a {display:inline-block;margin-right:10px;}
#pagination .on {font-weight: bold; cursor: default;color:#777;}



        #map {
            width: 100%;
            height: 100vh; 
            z-index: 0;

        }

        #search-path{
            position: fixed;
            left : 7.5%;
            top: 50px;      
            width: 85vw;
            height: 45px;

            min-width: 300px;
            max-width: 100%;

            padding: 0 10px;
            display: flex;
            align-items: center;
            box-sizing: border-box;
            border-radius: 6px;
            background-color: #ffffff;
            gap: 9px;
            
        }

        .map_wrap {
            position: fixed;
            bottom: 80px; /* search-path과 같은 위치로 조정 */
            left: 7.0%; /* search-path와 동일한 왼쪽 위치 */
            width: 80vw; /* search-path의 너비와 동일하게 설정 */
            height: 300px; /* search-path의 높이와 동일하게 설정 */
        }

        #menu_wrap {
            position: absolute;
            top: 0;
            left: 0;
            bottom: 0;
            width: 85vw; /* map_wrap 너비와 동일하게 설정 */
            margin: 10px 0 30px 10px;
            padding: 5px;
            overflow-y: auto;
            background: rgb(255, 255, 255);
            z-index: 1;
            font-size: 12px;
            border-radius: 10px;
        }

        /*.map_wrap {position:fixed; top: 150px ; left: 6.8%; width: 500px; height:200px;}
        #menu_wrap {position:absolute;top:0;left:0;bottom:0;width:500px;
        margin:10px 0 30px 10px;padding:5px;overflow-y:auto;
        background:rgba(255, 255, 255, 0.7);z-index: 1;font-size:12px;border-radius: 10px;}*/

            
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

        #sidebarMember{  
            width: 60vw;
            min-width: 250px;        /* 최소 너비: 250px 이하로 줄어들지 않음 */
            max-width: 350px;

            height: 100%; /* 화면 넓이의 60%, 높이 100%를 차지하는 사이드바 */
            background-color: #fff;
            z-index: 9999; /* 화면 제일 앞으로 고정 */    
            overflow-x: hidden; /*가로 방향(x축)**으로 요소 내부 내용이 넘칠 경우 넘친 부분을 보이지 않게 숨김.*/
            overflow-y: auto;  /*세로 방향(y축)**으로 내용이 넘칠 경우 필요할 때만 스크롤바를 자동 생성.*/
            word-break: keep-all; /*영어나 숫자 단어는 잘라도 되지만, 한글은 한 글자씩 자르지 않고 단어 단위로 줄바꿈.*/     
         }

         #sidebarGuest{  
            position: fixed;
            width: 60vw;
            min-width: 250px;        /* 최소 너비: 250px 이하로 줄어들지 않음 */
            max-width: 350px;

            height: 100%; /* 화면 넓이의 60%, 높이 100%를 차지하는 사이드바 */
            background-color: #fff;
            z-index: 9999; /* 화면 제일 앞으로 고정 */    
            overflow-x: hidden; /*가로 방향(x축)**으로 요소 내부 내용이 넘칠 경우 넘친 부분을 보이지 않게 숨김.*/
            overflow-y: auto;  /*세로 방향(y축)**으로 내용이 넘칠 경우 필요할 때만 스크롤바를 자동 생성.*/
            word-break: keep-all; /*영어나 숫자 단어는 잘라도 되지만, 한글은 한 글자씩 자르지 않고 단어 단위로 줄바꿈.*/     
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

         .hidden{
            transform: translateX(-100%) ; /* 왼쪽으로 숨기기 */
            transition: transform 0.6s ease;
            position: fixed;
            top: 0;
            left: 0;
         }

         .loginHidden{
            transform: translateX(100%);
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 999;
            background-color: #fff;
         }

         

         .show {
            transform: translateX(0); /* 다시 제자리로 나오게 */
            transition: transform 0.7s ease;
            position: fixed;
            top: 0;
            left: 0;
            box-shadow: 3px 5px 5px rgb(168, 166, 166);
        }

        #bottom-bar {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100vw;
            min-width: 400px;
            height: 70px;
            background-color: #fff;
            display: flex;
            justify-content: space-around;
            align-items: center;
            border-top: 1px solid #ccc;
        }


        .bottom-button {
            background: none;
            border: none;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: #333;
            cursor: pointer;
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
            z-index: 0;
        }
        

        .overlay.show {
            opacity: 1; /* 보일 때 불투명도 1 */
            visibility: visible; /* 보일 때 보이도록 설정 */
        }

        .overlay.hidden {
            opacity: 0; /* 숨길 때 불투명도 0 */
            transition: opacity 0.6s ease; /* opacity 애니메이션만 적용 */
        }

        .fade-out{
            opacity: 0; /* 숨길 때 불투명도 0 */
            transition: opacity 0.3s ease; /* opacity 애니메이션만 적용 */
            visibility: hidden;
            display: none;
        }

        .fade-out.hidden {
            transition: opacity 0.3s ease;
            visibility: hidden; /* opacity가 0으로 변경된 후에 hidden 처리 */
        }

        .fade-in{
            opacity: 0; /* 숨길 때 불투명도 0 */
            transition: opacity 0.3s ease; /* opacity 애니메이션만 적용 */
            visibility: hidden;
        }
        
        .textBtn{
            all: unset;
            width: 100%;
            z-index: 2 !important;
        }

        .position{
            position: fixed;

        }

    </style>  
</head>



<body>



<div id="map" ></div>


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




<div id="sidebarMember" class="hidden">
    <button class='textBtn' style="margin-top: 70px; margin-left: 40px;" onclick="location.href='login.html'">
        <span style="font-size: clamp(22px, 5vw, 28px); font-weight: bold; ">
            <c:if test="${loginvo!=null}">
				<h3>${loginvo.name}님 안녕하세요</h3>
			</c:if>
        </span>    
    </button>

    <hr style="margin-top: 20px; border: none; height: 1px; background-color: rgba(145, 136, 136, 0.2); width: 90%;">

    <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='join.html'">
        <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold; ">
            안심길찾기
        </span>    
    </button>

    <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='join.html'">
        <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold; ">
            자주가는 장소
        </span>    
    </button>

    <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='list.html'">
        <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold; ">
            함께하는 사람들
        </span>    
    </button>

    <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='Alarm.do'">
        <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold; ">
            알리미
        </span>    
    </button>

    <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='join.html'">
        <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold; ">
            신고함
        </span>    
    </button>
	 <button class='textBtn' style="margin-top: 30px; margin-left: 40px; color: red;" 
    onclick="alert('로그아웃 되었습니다.'); location.href='Logout.do';">
    <span style="font-size: clamp(14px, 3vw, 18px); font-weight: bold;">로그아웃</span>
</button>

</div>

<div id="sidebarGuest" class="hidden">
    <button id = "login" class='textBtn' style="margin-top: 70px; margin-left: 40px;">
        <span style="font-size: clamp(22px, 5vw, 28px); font-weight: bold; ">
            로그인하세요
        </span>    
    </button>

    <hr style="margin-top: 20px; border: none; height: 1px; background-color: rgba(145, 136, 136, 0.2); width: 90%;">

    <button class='textBtn' style="margin-top: 20px; margin-left: 40px;" onclick="location.href='join.html'">
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

<div id="joinBox" class="loginHidden">

</div>





<div id="bottom-bar">
    <button class="bottom-button" onclick="location.href='index.html'" >
        <img src="images/하단바/내비게이션.png" alt="내비">
        <span>내비</span>
    </button>
    <button class="bottom-button" onclick="location.href='map.html'">
        <img src="images/하단바/버스.png" alt="버스">
        <span>버스</span>
    </button>
    <button class="bottom-button" onclick="location.href='mypage.html'">
        <img src="images/하단바/로케이션.png" alt="주변">
        <span>주변</span>
    </button>
    <button class="bottom-button" onclick="location.href='mypage.html'">
        <img src="images/하단바/즐겨찾기.png" alt="즐겨찾기">
        <span>즐겨찾기</span>
    </button>
    <button class="bottom-button" onclick="location.href='login.html'">
        <img src="images/하단바/프로필.png" alt="마이">
        <span>마이</span>
    </button>
</div>




<div class="overlay" id="overlay"></div>




<script>
    const isLoggedIn = false;

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
</script>

<!-- 2. 사이드바 및 검색창 토글 기능 처리 -->
<script>
    const menuIcon = document.getElementById('menu-icon');
    const sidebarMember = document.getElementById('sidebarMember');
    const sidebarGuest = document.getElementById('sidebarGuest');
    const overlay = document.getElementById('overlay');
    const searchPath = document.getElementById('search-path');
    const inputBtn = document.getElementById('inputBtn');
    const inputText = document.getElementById('inputText');
    const login = document.getElementById('login');
    const joinBox = document.getElementById('joinBox');
    const inputPath = document.getElementById('inputPath');

    menuIcon.addEventListener('click', function(event) {
        event.stopPropagation();
        sidebarMember.classList.toggle('show');
        sidebarMember.classList.remove('hidden');
        menuIcon.classList.toggle('active');
        overlay.classList.remove('hidden');
        overlay.style.visibility = 'visible';
        overlay.classList.add('show');
    });

    inputBtn.addEventListener('click', function(event) {
        event.stopPropagation();
        searchPath.classList.add("expand");
        menuIcon.classList.toggle("fade-out");
        inputBtn.classList.toggle("fade-out");
        overlay.classList.remove('hidden');
        overlay.style.visibility = 'visible';
        overlay.classList.add('show');

        if (searchPath.classList.contains('expand')) {
            inputText.style.display = 'none';
            inputPath.style.display = 'inline-block';
            inputPath.focus();
        }
    });

    inputText.addEventListener('click', function(event) {
        event.stopPropagation();
        if (!searchPath.classList.contains('expand')) {
            searchPath.classList.add("expand");
        }

        /*overlay.classList.remove('hidden');
        overlay.style.visibility = 'visible';
        overlay.classList.add('show');*/

        inputText.style.display = 'none';
        inputPath.style.display = 'inline-block';
        inputPath.focus();

        menuIcon.classList.add("fade-out");
        menuIcon.style.display = 'none';
    });

    searchPath.addEventListener('click', function(event) {
        event.stopPropagation();
    });

    inputPath.addEventListener('click', function(event) {
        event.stopPropagation();
    });

    document.addEventListener('click', function(event) {
        if (!searchPath.contains(event.target)) {
            searchPath.classList.remove('expand');
            menuIcon.classList.remove('fade-out');
            menuIcon.style.display = '';
            inputBtn.classList.remove('fade-out');
            inputText.classList.remove('fade-out');
            searchPath.classList.add('shadow');
            overlay.classList.remove('show');
            overlay.classList.add('hidden');

            setTimeout(() => {
                overlay.style.visibility = 'hidden';
            }, 600);

            inputPath.style.display = 'none';
            inputText.style.display = 'inline';
        }
    });

    document.addEventListener('click', function(event) {
        if (!sidebarMember.contains(event.target) && !menuIcon.contains(event.target)) {
            sidebarMember.classList.remove('show');
            sidebarMember.classList.add('hidden');
            menuIcon.classList.remove('active');
            overlay.classList.add('hidden');

            setTimeout(() => {
                overlay.style.visibility = 'hidden';
            }, 600);
        }

        login.addEventListener('click', function(event) {
            sidebarGuest.classList.remove('show');
            sidebarGuest.classList.add('hidden');
            menuIcon.classList.remove('active');
            overlay.classList.add('hidden');
            joinBox.classList.add('show');

            setTimeout(() => {
                location.href = "login.html";
            }, 800);
        });
    });
</script>

<!-- 3. 카카오맵 API 로드 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=762faf7625dc5a4b85148f6c11470e12&libraries=services"></script>

<!-- 4. 지도 초기화 -->
<script>
    var markers = [];

    var mapContainer = document.getElementById('map'),
        mapOption = {
            center: new kakao.maps.LatLng(37.566826, 126.9786567),
            level: 3
        };

    var map = new kakao.maps.Map(mapContainer, mapOption);
    var ps = new kakao.maps.services.Places();
    var infowindow = new kakao.maps.InfoWindow({ zIndex: 1 });
</script>

<!-- 5. 키워드 장소 검색 기능 -->
<script>
    function searchPlaces() {
        var keyword = document.getElementById('keyword').value;

        if (!keyword.replace(/^\s+|\s+$/g, '')) {
            alert('키워드를 입력해주세요!');
            return false;
        }

        ps.keywordSearch(keyword, placesSearchCB);
    }

    function placesSearchCB(data, status, pagination) {
        if (status === kakao.maps.services.Status.OK) {
            displayPlaces(data);
            displayPagination(pagination);
        } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
            alert('검색 결과가 존재하지 않습니다.');
        } else if (status === kakao.maps.services.Status.ERROR) {
            alert('검색 결과 중 오류가 발생했습니다.');
        }
    }

    function displayPlaces(places) {
        var listEl = document.getElementById('placesList'),
            menuEl = document.getElementById('menu_wrap'),
            fragment = document.createDocumentFragment(),
            bounds = new kakao.maps.LatLngBounds();

        removeAllChildNods(listEl);
        removeMarker();

        for (let i = 0; i < places.length; i++) {
            let placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
                marker = addMarker(placePosition, i),
                itemEl = getListItem(i, places[i]);

            bounds.extend(placePosition);

            (function (marker, title) {
                /*kakao.maps.event.addListener(marker, 'mouseover', function () {
                    displayInfowindow(marker, title);
                });
                kakao.maps.event.addListener(marker, 'mouseout', function () {
                    infowindow.close();
                });*/
                itemEl.onmouseover = function () {
                    displayInfowindow(marker, title, false);
                };
                itemEl.onmouseout = function () {
                    infowindow.close();
                };

                itemEl.onclick = function() {
                    map.setLevel(3);  
                    displayInfowindow(marker, title, true);   // 인포윈도우 열기
                };

            })(marker, places[i].place_name);

            fragment.appendChild(itemEl);
        }

        listEl.appendChild(fragment);
        map.setBounds(bounds);
    }

    function addMarker(position, idx) {
        var marker = new kakao.maps.Marker({
            position: position
        });
        marker.setMap(map);
        markers.push(marker);
        return marker;
    }

    function removeMarker() {
        for (var i = 0; i < markers.length; i++) {
            markers[i].setMap(null);
        }
        markers = [];
    }

    function removeAllChildNods(el) {
        while (el.hasChildNodes()) {
            el.removeChild(el.lastChild);
        }
    }

    function displayInfowindow(marker, title, moveMap = false) {
        var content = '<div style="padding:5px;font-size:12px;">' + title + '</div>';
        infowindow.setContent(content);
        infowindow.open(map, marker);

        if (moveMap) {
            map.setCenter(marker.getPosition());
        }
    }

    function getListItem(index, place) {
        var el = document.createElement('li'),
            itemStr = '<span class="markerbg marker_' + (index + 1) + '"></span>' +
                      '<div class="info">' +
                      '   <h5>' + place.place_name + '</h5>';

        if (place.road_address_name) {
            itemStr += '    <span>' + place.road_address_name + '</span>' +
                       '   <span class="jibun gray">' + place.address_name + '</span>';
        } else {
            itemStr += '    <span>' + place.address_name + '</span>';
        }

        itemStr += '  <span class="tel">' + place.phone + '</span>' +
                   '</div>';

        el.innerHTML = itemStr;
        el.className = 'item';

        return el;
    }

    // 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
    function addMarker(position, idx, title) {
    var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
        imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
        imgOptions =  {
            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
            spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
        },
        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
            marker = new kakao.maps.Marker({
            position: position, // 마커의 위치
            image: markerImage 
        });

    marker.setMap(map); // 지도 위에 마커를 표출합니다
    markers.push(marker);  // 배열에 생성된 마커를 추가합니다

    return marker;
    }

    // 지도 위에 표시되고 있는 마커를 모두 제거합니다
    function removeMarker() {
    for ( var i = 0; i < markers.length; i++ ) {
        markers[i].setMap(null);
    }   
    markers = [];
    }

    // 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
    function displayPagination(pagination) {
    var paginationEl = document.getElementById('pagination'),
        fragment = document.createDocumentFragment(),
        i; 

    // 기존에 추가된 페이지번호를 삭제합니다
    while (paginationEl.hasChildNodes()) {
        paginationEl.removeChild (paginationEl.lastChild);
    }

    for (i=1; i<=pagination.last; i++) {
        var el = document.createElement('a');
        el.href = "#";
        el.innerHTML = i;

        if (i===pagination.current) {
            el.className = 'on';
        } else {
            el.onclick = (function(i) {
                return function() {
                    pagination.gotoPage(i);
                }
            })(i);
        }

        fragment.appendChild(el);
    }
    paginationEl.appendChild(fragment);
    }

    // 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
    // 인포윈도우에 장소명을 표시합니다
    /*function displayInfowindow(marker, title) {
    var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';

    infowindow.setContent(content);
    infowindow.open(map, marker);
    }*/

    // 검색결과 목록의 자식 Element를 제거하는 함수입니다
    function removeAllChildNods(el) {   
    while (el.hasChildNodes()) {
        el.removeChild (el.lastChild);
    }
    }

    var geocoder = new kakao.maps.services.Geocoder();

    geocoder.addressSearch('계림동 647', function(result, status) {

    // 정상적으로 검색이 완료됐으면 
    if (status === kakao.maps.services.Status.OK) {

        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

        // 결과값으로 받은 위치를 마커로 표시합니다
        var marker = new kakao.maps.Marker({
            map: map,
            position: coords
        });

        // 인포윈도우로 장소에 대한 설명을 표시합니다
        var infowindow = new kakao.maps.InfoWindow({
            content: '<div style="width:150px;text-align:center;padding:6px 0;">우리집</div>'
        });
        infowindow.open(map, marker);

        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
        map.setCenter(coords);
    } 
    }); 
</script>
<script>
function showLogoutAlert() {
    const alertBox = document.getElementById('logout-alert');
    alertBox.style.display = 'block';

    setTimeout(() => {
        location.href = 'Logout.do';
    }, 1000); // 1초 후 이동
}
</script>

</body>
</html>
