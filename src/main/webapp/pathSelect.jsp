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
        body {
            font-family: 'Helvetica Neue', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            padding: 20px;
        }
        .path-header {
            text-align: center;
            margin-bottom: 20px;
        }
        .path-card-container {
            display: flex;
            overflow-x: auto;
            gap: 16px;
            scroll-snap-type: x mandatory;
            padding: 0 10px;
        }
        .path-card {
            background: #fff;
            border-radius: 10px;
            padding: 20px;
            min-width: 280px;
            flex: 0 0 auto;
            scroll-snap-align: start;
            box-shadow: 0 3px 8px rgba(0,0,0,0.15);
        }
        .path-title {
            font-size: 18px;
            font-weight: bold;
        }
        .path-detail {
            margin-top: 10px;
            color: #666;
        }
        .select-btn {
            margin-top: 15px;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
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
<div class="container">
    <div class="path-header">
        <h2>출발지: <%= startAddress %> → 도착지: <%= endAddress %></h2>
    </div>

    <div id="map"></div>

    <div class="path-card-container">
        <div class="path-card" onclick="showRoute('safe')">
            <div class="path-title">안전 경로</div>
            <div class="path-detail"><span id="safe-score1">분석 중</span></div></div>
            <div class="path-detail">안전 점수: <span id="safe-score2">분석 중</span></div>
            <button class="select-btn" onclick="selectRoute(event, 'safe')">이 경로로 안내받기</button>
        </div>

        <div class="path-card" onclick="showRoute('mainroad')">
            <div class="path-title">큰길 위주 경로</div>
            <div class="path-detail">33분 | 1.9km | 3,319 걸음</div>
            <button class="select-btn" onclick="selectRoute(event, 'mainroad')">이 경로로 안내받기</button>
        </div>

        <div class="path-card" onclick="showRoute('shortest')">
            <div class="path-title">최단 경로</div>
            <div class="path-detail">19분 | 1.3km | 1,953걸음</div>
            <button class="select-btn" onclick="selectRoute(event, 'shortest')">이 경로로 안내받기</button>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=C0A4SwhCGE2ocuN4vTAeD7ClrI5Jb1Kk5nj6or4F"></script>

<script>
    const map = new Tmapv2.Map("map", {
        center: new Tmapv2.LatLng(35.150523, 126.858611),
        width: "100%",
        height: "300px",
        zoom: 15
    });

    const startX = "126.858611", startY = "35.150523";
    const endX = "126.859754", endY = "35.161202";

    function clearMap() {
        // 기존 경로를 모두 제거
        if (window.resultInfoArr) {
            window.resultInfoArr.forEach(polyline => polyline.setMap(null));  // 경로 초기화
            window.resultInfoArr = [];  // 배열 초기화
        }

        // 기존 마커를 모두 제거
        if (window.resultMarkerArr) {
            window.resultMarkerArr.forEach(marker => marker.setMap(null));  // 마커 초기화
            window.resultMarkerArr = [];  // 배열 초기화
        }
    }


    function showRoute(type) {
        clearMap();  // 기존 경로를 모두 제거
        if (type === "safe") safe();
        else if (type === "mainroad") mainroad();
        else if (type === "shortest") shortest();
    }


    function selectRoute(event, type) {
        event.stopPropagation();
        window.location.href = `main.jsp?route=${type}`;
    }

    function fetchSafetyScore() {
    	const coords = [
    	    [parseFloat(startX), parseFloat(startY)],  // 경도, 위도 순서 (수정됨)
    	    [126.855978, 35.150195], 
    	    [126.855084, 35.151578],
    	    [126.855029, 35.153864],
    	    [126.855114, 35.156109],
    	    [126.855890, 35.158766],
    	    [126.857705, 35.158824],
    	    [126.859307, 35.158822],
    	    [parseFloat(endX), parseFloat(endY)]  // 경도, 위도 순서 (수정됨)
    	];

        fetch("http://localhost:5000/analyze_path", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                coords: coords,
                cctv_images: [
                    "CCTV0-1.png", "CCTV1-2.png", null,
                    "CCTV3-4.png", "CCTV4-5.png", "CCTV5-6.png",
                    "CCTV6-7.png", "CCTV7-8.png"
                ]
            })
        })
        .then(res => res.json())
        .then(data => {
            
        	document.getElementById("safe-score1").innerText = "29분 | 1.9km | 2,950 걸음";
        	document.getElementById("safe-score2").innerText = data.average_score + "점";
            
        })
        .catch(err => {
            console.error("안전 점수 요청 실패:", err);
            document.getElementById("safe-score").innerText = "분석 실패";
        });
    }

    // ▶▶▶ 경로 함수들
	function safe() {
	    drawPolyline([
	        [126.858611, 35.150523],
	        [126.855978, 35.150195],
	        [126.855084, 35.151578],
	        [126.855029, 35.153864],
	        [126.855114, 35.156109],
	        [126.855890, 35.158766],
	        [126.857705, 35.158824],
	        [126.859307, 35.158822],
	        [126.859754, 35.161202]
	    ]);
	}
	
	function mainroad() {
	    drawPolyline([
	        [126.858611, 35.150523],
	        [126.856078, 35.150105],
	        [126.855062, 35.151707],
	        [126.855035, 35.155882],
	        [126.855833, 35.157958],
	        [126.855933, 35.161888],
	        [126.859543, 35.161806],
	        [126.859534, 35.161228],
	        [126.859754, 35.161202]
	    ]);
	}
	
	function shortest() {
	    drawPolyline([
	        [126.858611, 35.150523],
	        [126.858441, 35.151739],
	        [126.858355, 35.152844],
	        [126.858465, 35.153630],
	        [126.859365, 35.155500],
	        [126.859395, 35.158741],
	        [126.859597, 35.161201],
	        [126.859754, 35.161202]
	    ]);
	}

    // 공통 경로 그리기 함수
    let resultMarkerArr = [], resultInfoArr = [];

    function drawPolyline(coords) {
        clearMap();
        coords.forEach((coord, idx) => {
            const marker = new Tmapv2.Marker({
                position: new Tmapv2.LatLng(coord[1], coord[0]),
                icon: idx === 0 ? "/upload/tmap/marker/pin_r_m_s.png" :
                      idx === coords.length - 1 ? "/upload/tmap/marker/pin_r_m_e.png" :
                      "null",
                iconSize: new Tmapv2.Size(24, 48),
                map: map
            });
            resultMarkerArr.push(marker);
        });

        const latlngs = coords.map(c => new Tmapv2.LatLng(c[1], c[0]));
        const polyline = new Tmapv2.Polyline({
            path: latlngs,
            strokeColor: "#FF0000",
            strokeWeight: 6,
            map: map
        });
        resultInfoArr.push(polyline);
    }

    // 최초 로딩 시 안전 경로 + 안전 점수 실행
    window.onload = function () {
        showRoute("shortest");
        fetchSafetyScore();
    };
</script>
</body>
</html>
