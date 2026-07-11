<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    request.setCharacterEncoding("UTF-8");
    String startAddress = request.getParameter("start");
    String endAddress = request.getParameter("end");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>경로 선택</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        html,body {
            margin-top: 0;
            height: 103%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Helvetica Neue', sans-serif;
            margin: 0;
        }

        #map-container {          
            position: relative;
            top:-50px;
            left: 50px;
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
        .path-header {
            position: absolute;

            align-items: center;
            top: 14%;
            left: 85px;
            text-align: center;
            width: 400px;
            height: 120px;
            border-radius: 50px;
            background-color: #fffffffd;
            display: flex; /* flexbox 활성화 */
            flex-direction: column; /* 세로 방향으로 정렬 */
            justify-content: space-between;
            font-weight: bold;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
        }
        .startAd{
            position: absolute;
            top:20px;
        }

        .endAd{
            position: absolute;
            top:75px;
        }
        

        .path-header hr {
            position: absolute;
            top: 60px;
            width: 80%; /* hr의 너비 조정 */
            margin: 0 10px; /* hr 주변 여백 조정 */
            background-color: rgba(0, 86, 179, 0.5); /* 50% 투명도 적용 */
        }


        .path-card-container {
            display: flex;
            overflow-x: hidden; /* 가로 스크롤바 숨기기 */
            gap: 18px;
            padding: 20px 10px;
            position: absolute;
            bottom: 20px;  /* 지도 아래에 경로 카드 배치 */
            left: 10px;
            width: 100%;
            justify-content: space-between;
            cursor: grab; /* 마우스 커서를 '잡기'로 변경 */
            box-sizing: border-box; /* padding 포함해서 크기 계산 */
            padding-right: 30px; /* 오른쪽 휠 영역 확장 */
            
        }

        .path-card {
            position: relative;
            background: #ffffffef;
            border-radius: 10px;
            padding: 20px;
            min-width: 280px;
            height: 100px;
            flex: 0 0 auto;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
            
        }

    .path-title {
        position: absolute;
        top: 15px;
        font-size: 18px;
        font-weight: bold;
    }

    .path-detail {
        position: absolute;
        margin-top: 25px;
        color: #666;
    }

    .select-btn {
        position: absolute;
        bottom: 20px;
        right: 5px;

        padding: 10px 20px;
        background-color: #007bff59;
        color: rgba(255, 255, 255, 0.658);
        border: none;
        border-radius: 6px;
        cursor: pointer;
    }

    .select-btn:hover {
        background-color: #0056b3;
    }

    /* 경로 카드가 너무 길지 않도록 텍스트 overflow 처리 */
    .path-card-container::-webkit-scrollbar {
        height: 10px;
    }

    .path-card-container::-webkit-scrollbar-thumb {
        background-color: #007bff;
        border-radius: 5px;
    }

    .path-card-container::-webkit-scrollbar-track {
        background-color: #f1f1f1;
    }

    .select-btn {
        bottom:10px;
        padding: 10px 20px;
        width: 70px;
        height: 40px;
        right: 10px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
    }

    .select-btn:hover {
            background-color: #0056b3;
    }


    #map {
        width: 100%;
        height: 300px;
        margin-top: 20px;
    }
    </style>
</head>
<body>
<div id="map-container">
    <div id="map"></div>
    <div class="path-header">
         <div class="startAd">
        출발지 : <%= startAddress %>
        </div>
        <hr>
        <div class="endAd">
        도착지 : <%= endAddress %>
        </div>
    </div>

    <div class="path-card-container">
        <div class="path-card" onclick="showRoute('safe')">
            <div class="path-title">안전 경로</div>
            <div class="path-detail">
                <span id="safe-score1">분석 중</span>
                
            </div>
            <br>
            <div id="safe-score2" class="path-detail">안전 점수 : 분석 중</div>
            <button class="select-btn" onclick="selectRoute(event, 'safe')">안내</button>
        </div>
       

        <div class="path-card" onclick="showRoute('shortest')">
            <div class="path-title">최단 경로</div>
            <div class="path-detail">19분 | 1.3km | 1,953걸음</div>
            <button class="select-btn" onclick="selectRoute(event, 'shortest')">안내</button>
        </div>
        </div>
    </div>

    
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=vD2v8S3ooW650frcHc8R91xdR9ea6EKKAsVFiLaj"></script>

<script>
    // 메인 화면 검색창에서 넘겨준 실제 좌표 받기
    const urlParams = new URLSearchParams(window.location.search);
    const startX = urlParams.get("startLon");
    const startY = urlParams.get("startLat");
    const endX = urlParams.get("endLon");
    const endY = urlParams.get("endLat");

    const map = new Tmapv2.Map("map", {
        center: new Tmapv2.LatLng(startY, startX),
        width: "100%",
        height: "100%",
        zoom: 15
    });

    const container = document.querySelector('.path-card-container');

    let isMouseDown = false;
    let startDragX;
    let scrollLeft;

    container.addEventListener('mousedown', (e) => {
    isMouseDown = true;
    startDragX = e.pageX - container.offsetLeft; // 마우스 클릭 위치 저장
    scrollLeft = container.scrollLeft; // 현재 스크롤 위치 저장
    container.style.cursor = 'grabbing'; // 마우스 커서를 '잡고 있는' 상태로 변경
    });

    container.addEventListener('mouseleave', () => {
        isMouseDown = false;
        container.style.cursor = 'grab'; // 마우스가 벗어나면 원래 상태로 돌아감
    });

    container.addEventListener('mouseup', () => {
        isMouseDown = false;
        container.style.cursor = 'grab'; // 마우스 버튼을 떼면 원래 커서로 복원
    });

    container.addEventListener('mousemove', (e) => {
        if (!isMouseDown) return; // 마우스를 누르고 있을 때만 동작
        e.preventDefault();
        const x = e.pageX - container.offsetLeft;
        const walk = (x - startDragX) * 1; // 이동 속도 조정 (2배 빠르게 이동)
        container.scrollLeft = scrollLeft - walk; // 스크롤 이동
    });

    let resultInfoArr = [];
    let markers = []; // 마커들을 저장할 배열
    
    function clearMap() {
        // 기존 경로를 모두 제거
        if (resultInfoArr) {
            resultInfoArr.forEach(polyline => polyline.setMap(null));
            resultInfoArr.length = 0; // 배열의 length 속성을 0으로 설정하여 비움
        }

        // 기존 마커를 모두 제거
        markers.forEach(marker => marker.setMap(null));
        markers.length = 0; // 마커 배열도 비움
    }

    // 카드 눌렀을 때 실행 (지금은 안전경로/최단경로 둘 다 똑같이 실제 T맵 경로를 불러옴)
    function showRoute(type) {
        clearMap();
        loadRealRoute();
    }

    function selectRoute(event, type) {
        event.stopPropagation();
        window.location.href = "main.jsp?type=" + encodeURIComponent(type)
            + "&start=" + encodeURIComponent(urlParams.get("start") || "")
            + "&end=" + encodeURIComponent(urlParams.get("end") || "")
            + "&startLat=" + startY + "&startLon=" + startX
            + "&endLat=" + endY + "&endLon=" + endX;
    }

    // 실제 출발지/도착지 좌표로 T맵 보행자 경로 API 호출해서 진짜 경로 그리기
    function loadRealRoute() {
        $.ajax({
            method: "POST",
            url: "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json",
            headers: { "appKey": "vD2v8S3ooW650frcHc8R91xdR9ea6EKKAsVFiLaj" },
            data: {
                startX: startX,
                startY: startY,
                endX: endX,
                endY: endY,
                reqCoordType: "WGS84GEO",
                resCoordType: "WGS84GEO",
                startName: "출발지",
                endName: "도착지"
            },
            success: function (response) {
                const features = response.features;

                // 경로 좌표만 모으기 (LineString인 것만)
                const coords = [];
                features.forEach(function (f) {
                    if (f.geometry.type === "LineString") {
                        f.geometry.coordinates.forEach(function (c) {
                            coords.push(c); // [경도, 위도]
                        });
                    }
                });

                drawPolyline(coords);

                // 첫번째 feature에 총 거리/시간 정보가 들어있음
                const totalDistance = features[0].properties.totalDistance; // m
                const totalTime = features[0].properties.totalTime; // 초

                const distanceKm = (totalDistance / 1000).toFixed(1);
                const minutes = Math.round(totalTime / 60);
                const steps = Math.round(totalDistance / 0.7); // 대충 보폭 70cm로 계산

                document.getElementById("safe-score1").innerText = minutes + "분 | " + distanceKm + "km | " + steps + " 걸음";
                document.getElementById("safe-score2").innerText = "안전 점수 : 계산 예정";
            },
            error: function (request, status, error) {
                console.error("경로 요청 실패:", request.responseText);
                document.getElementById("safe-score1").innerText = "경로를 찾지 못했습니다.";
            }
        });
    }

   
    function drawPolyline(coords) {
    	// 경로를 새로 그리기 전에 기존 경로와 마커를 삭제
    	console.log("drawPolyline 함수 호출됨", coords);
        clearMap();

        // 새로운 경로 그리기
        const latlngs = coords.map(c => new Tmapv2.LatLng(c[1], c[0]));
        const polyline = new Tmapv2.Polyline({
            path: latlngs,
            strokeColor: "#FF0000",
            strokeWeight: 6,
            map: map
        });
        resultInfoArr.push(polyline);
        
        if (coords.length > 0) {
        	const startMarker = new Tmapv2.Marker({
                position: new Tmapv2.LatLng(coords[0][1], coords[0][0]), // 출발지
                icon : "images/Marker/pin1.png",
                iconSize: new Tmapv2.Size(24, 38),
                map: map
            });
            startMarker.setMap(map);
            markers.push(startMarker); // 생성된 마커를 배열에 추가

            
            if (coords.length > 1) {
            	const endMarker = new Tmapv2.Marker({
                    position: new Tmapv2.LatLng(coords[coords.length - 1][1], coords[coords.length - 1][0]), // 도착지
                    icon : "images/Marker/pin2.png",
                    iconSize: new Tmapv2.Size(24, 38),
                    map: map
                });
                endMarker.setMap(map);
                markers.push(endMarker); // 생성된 마커를 배열에 추가
            }
        }
        
    }

    // 최초 로딩 시 실제 경로 불러오기
    window.onload = function () {
        loadRealRoute();
    };

    
</script>
</body>
</html>