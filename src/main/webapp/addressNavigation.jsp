<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>simpleMap</title>
  <script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
  <script src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=C0A4SwhCGE2ocuN4vTAeD7ClrI5Jb1Kk5nj6or4F"></script>
  
  <style>
    html, body {
      margin-top: 0;
      height: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
      font-family: 'Helvetica Neue', sans-serif;
      margin: 0;
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

  </style>
</head>
<body onload="initTmap()">

  <div id="map-container">
    <div id="map_div" class="map-center"></div>
    <div id="result" style="position: absolute; top: 20px; left: 20px; background: white; padding: 8px; border-radius: 8px; box-shadow: 0 0 5px rgba(0,0,0,0.2); font-weight: bold;">
      경로 정보가 여기에 표시됩니다.
    </div>
  </div>

  <script type="text/javascript">
    var map;
    var marker_s, marker_e;
    var resultdrawArr = [];

    function initTmap() {
    	
      const urlParams = new URLSearchParams(window.location.search);
      // JSP에서 전달한 값들을 JavaScript 변수에 할당
      const startLat = parseFloat(urlParams.get("startLat")) || 37.5665;
      const startLon = parseFloat(urlParams.get("startLon")) || 126.9780;
      const endLat = parseFloat(urlParams.get("endLat")) || 37.5651;
      const endLon = parseFloat(urlParams.get("endLon")) || 126.9890;

      console.log("start:", startLat, startLon);
      console.log("end:", endLat, endLon);

      // 지도 초기화
      map = new Tmapv2.Map("map_div", {
        center: new Tmapv2.LatLng(startLat, startLon),
        width: "100%",
        height: "100%",
        zoom: 16,
        zoomControl: true,
        scrollwheel: true
      });

      // 시작 마커 설정
      if (!isNaN(startLat) && !isNaN(startLon)) {
        marker_s = new Tmapv2.Marker({
          position: new Tmapv2.LatLng(startLat, startLon),
          icon: "https://tmapapi.tmapmobility.com/upload/tmap/marker/pin_r_m_s.png",
          iconSize: new Tmapv2.Size(24, 38),
          map: map
        });
      } else {
        console.log("출발지 좌표가 잘못 전달되었습니다.");
      }

      // 도착 마커 설정
      if (!isNaN(endLat) && !isNaN(endLon)) {
        marker_e = new Tmapv2.Marker({
          position: new Tmapv2.LatLng(endLat, endLon),
          icon: "https://tmapapi.tmapmobility.com/upload/tmap/marker/pin_r_m_e.png",
          iconSize: new Tmapv2.Size(24, 38),
          map: map
        });
      } else {
        console.log("도착지 좌표가 잘못 전달되었습니다.");
      }

      // 도보 경로 요청
      $.ajax({
        method: "POST",
        url: "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json&callback=result",
        headers: { "appKey": "C0A4SwhCGE2ocuN4vTAeD7ClrI5Jb1Kk5nj6or4F" },
        data: {
          startX: startLon,
          startY: startLat,
          endX: endLon,
          endY: endLat,
          reqCoordType: "WGS84GEO",
          resCoordType: "EPSG3857",
          startName: "출발지",
          endName: "도착지"
        },
        success: function (response) {
          const resultData = response.features;
          const tDistance = "총 거리 : " + (resultData[0].properties.totalDistance / 1000).toFixed(1) + "km,";
          const tTime = " 총 시간 : " + (resultData[0].properties.totalTime / 60).toFixed(0) + "분";
          $("#result").text(tDistance + tTime);

          if (resultdrawArr.length > 0) {
            resultdrawArr.forEach(item => item.setMap(null));
            resultdrawArr = [];
          }

          let drawInfoArr = [];

          resultData.forEach(item => {
            if (item.geometry.type === "LineString") {
              item.geometry.coordinates.forEach(coord => {
                const latlng = new Tmapv2.Point(coord[0], coord[1]);
                const convert = Tmapv2.Projection.convertEPSG3857ToWGS84GEO(latlng);
                drawInfoArr.push(new Tmapv2.LatLng(convert._lat, convert._lng));
              });
            }
          });

          drawLine(drawInfoArr);
        },
        error: function (request, status, error) {
          console.log("code:" + request.status + "\nmessage:" + request.responseText + "\nerror:" + error);
        }
      });
    }

    function drawLine(arrPoint) {
      const polyline = new Tmapv2.Polyline({
        path: arrPoint,
        strokeColor: "#DD0000",
        strokeWeight: 6,
        map: map
      });
      resultdrawArr.push(polyline);
    }
  </script>

</body>
</html>
