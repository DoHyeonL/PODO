<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>POI 주소 검색으로 마커 표시</title>
  <script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
  <script src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=vD2v8S3ooW650frcHc8R91xdR9ea6EKKAsVFiLaj"></script>
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

    #controls {
      position: absolute;
      width: 450PX;
      height: 200PX;
      bottom: 0px;
      left: 50%;
      transform: translateX(-50%);
      color: #333;
      background-color: white;
      padding: 10px;
      border-top-left-radius: 20px;
      border-top-right-radius: 20px;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2); /* 선택사항: 보기 좋게 */
    }

    #result {
        position: absolute;
        margin-top: 0px;
        margin-left: 10px;
        font-size: 14px;
        color: #333;
        line-height: 1.6;
        background-color: #f8f8f8;
        padding: 8px 12px;
        border-radius: 8px;
        width: 90%;
        max-width: 400px;
        box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
    }

    .addressTitle{
        position: absolute;
        font-size: 20px;
        font-weight: bold;
        top:20px;
        left: 22px;
        display: block;
        color: rgba(78, 110, 255, 0.801);
    }

    .sub_addressTitle{
        position: absolute;
        font-size: 16px;
        left: 22px;
    }

    .selectBtn {
      position: absolute;
      right: 30px;
      bottom: 20px;
      display: flex;
      gap: 10px;
    }

    input, button {
      font-size: 16px;
      padding: 5px;
    }

    #map-input-popup {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      background-color: rgba(255, 255, 255, 0.95);
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.3);
      z-index: 1000;
      display: none;
    }

    #map-input-popup input {
      width: 250px;
      padding: 8px;
      margin-top: 10px;
      font-size: 16px;
    }

    #map-input-popup button {
      margin-top: 10px;
      padding: 6px 12px;
    }

    

  </style>
</head>
<body>

  <div id="map-container">
    <div id="map_div"></div>
    <div id="controls">
      <span id="full_address" class="addressTitle"></span>
      <hr style="margin-top:52px; opacity: 0.3; width: 425px;">
      <!-- <div id="sub_address" class="sub_addressTitle">
        서브주소
      </div>
      -->
      <div id="result"> </div>
      
      <div class="selectBtn">
        <button id="startBtn">출발</button>
        <button id="endBtn">도착</button>
      </div>  
    </div>

    <!-- 팝업 div (초기에는 숨겨짐) -->
    <div id="map-input-popup" style="display: none;">
        <div id="popupContent"></div> <!-- 여기서 동적으로 내용 생성 -->
        <input type="text" id="popupInput" placeholder="주소를 입력하세요" />
        <button id="submitBtn">확인</button>
    </div>

<!-- 버튼을 클릭하면 팝업이 나타나도록 트리거 -->
<button id="showPopupBtn">주소 입력</button>

    
  </div>

  <script>
    var map;

    function initTmap() {
      map = new Tmapv2.Map("map_div", {
        center: new Tmapv2.LatLng(37.5652045, 126.98702028),
        width: "100%",
        height: "100%",
        zoom: 17
      });
    }

    window.onload = function () {
      initTmap();

      const urlParams = new URLSearchParams(window.location.search);
      const addressFromQuery = urlParams.get("address");
      

      if (addressFromQuery) {
        // 주소로 위도, 경도 얻기
        $.ajax({
          method: "GET",
          url: "https://apis.openapi.sk.com/tmap/pois",
          data: {
            version: 1,
            format: "json",
            searchKeyword: addressFromQuery,
            resCoordType: "WGS84GEO",
            reqCoordType: "WGS84GEO",
            count: 1,
            appKey: "vD2v8S3ooW650frcHc8R91xdR9ea6EKKAsVFiLaj"
          },
          success: function (response) {
            if (response.searchPoiInfo.pois.poi.length > 0) {
              var poi = response.searchPoiInfo.pois.poi[0];
              var lat = poi.frontLat;
              var lon = poi.frontLon;
            

             

              // 지도 중심 위치 설정
              map.setCenter(new Tmapv2.LatLng(Number(lat), Number(lon)));

              // 마커 생성
              var position = new Tmapv2.LatLng(Number(lat), Number(lon));
              var marker = new Tmapv2.Marker({
                position: position,
                icon: "https://tmapapi.tmapmobility.com/upload/tmap/marker/pin_b_m_a.png",
                iconSize: new Tmapv2.Size(24, 38),
                map: map
              });

              // 텍스트로 주소 표시
              document.getElementById("full_address").innerText = poi.upperAddrName + " " + poi.middleAddrName + " "
                + addressFromQuery;
              /*document.getElementById("sub_address").innerText = poi.upperAddrName + " " + poi.middleAddrName + " " 
              + poi.roadName; + " " + poi.lowerAddrName + " " + poi.firstBuildNo;*/

              const roadAddress = `${poi.upperAddrName} ${poi.middleAddrName} ${poi.roadName} ${poi.firstBuildNo}`;
              getPostcode(roadAddress);

          
            
            } else {
              alert("검색 결과가 없습니다.");
            }
          },
          error: function (request, status, error) {
            console.error("요청 실패:", request.responseText);
          }
        });

         // 🟡 [2] 우편번호와 도로명 주소 가져오기
        getPostcode(addressFromQuery);
  
      }
    };

    function getPostcode(keyword) {
    $.ajax({
      method: "GET",
      url: "https://apis.openapi.sk.com/tmap/geo/postcode",
      headers: {
        "appKey": "vD2v8S3ooW650frcHc8R91xdR9ea6EKKAsVFiLaj"
      },
      data: {
        coordType: "WGS84GEO",
        addressFlag: "F00",
        format: "json",
        page: 1,
        count: 1,
        addr: keyword
      },
      success: function (data) {
        const results = data.coordinateInfo.coordinate;
        if (results.length > 0) {
          const item = results[0];
          const zipcode = item.zipcode;
          const address = `${item.city_do} ${item.gu_gun} ${item.eup_myun} ${item.newRoadName} ${item.newBuildingIndex}`;

          $('#result').html(
            `<strong>우편번호 : </strong> ${zipcode}<br><strong>도로명 주소 : </strong> ${address}`
          );
        } else {
          $('#result').html('검색 결과가 없습니다.');
        }
      },
      
    });
  }

    

     



      

      document.getElementById("popupInput").addEventListener("keydown", function (e) {
        if (e.key === "Enter") {
          const keyword = document.getElementById("popupInput").value.trim();
          
          if (keyword.length < 2) {
            alert("두 글자 이상 입력해주세요.");
            return;
          }

          const urlParams = new URLSearchParams(window.location.search);
          const startLat = urlParams.get("lat");
          const startLon = urlParams.get("lon");

          $.ajax({
            method: "GET",
            url: "https://apis.openapi.sk.com/tmap/pois",
            data: {
                version: 1,
                format: "json",
                searchKeyword: keyword,
                resCoordType: "WGS84GEO",
                reqCoordType: "WGS84GEO",
                count: 1,
                appKey: "vD2v8S3ooW650frcHc8R91xdR9ea6EKKAsVFiLaj"
            },
            success: function (response) {
                if (response.searchPoiInfo.pois.poi.length > 0) {
                    var poi = response.searchPoiInfo.pois.poi[0];
                    const endLat = poi.frontLat;
                    const endLon = poi.frontLon;

                    // 위도, 경도를 포함하여 페이지 전환
                     window.location.href = `addressNavigation.jsp?startLat=${startLat}&startLon=${startLon}&endLat=${endLat}&endLon=${endLon}`;
                    
                }else {
                 alert("검색 결과가 없습니다."); 
                 
                }
            },
            error: function (request, status, error) {
                console.error("요청 실패:", request.responseText);
            }
        });

          popup.style.display = "none";
        }
        
      });

    

    // 시작 버튼 누를시
    document.getElementById("startBtn").addEventListener("click", function () {
      const popup = document.getElementById("map-input-popup");
      popup.style.display = "block";  // 팝업 div 보이게 하기

    });




    // 도착 버튼 누를시
    document.getElementById("endBtn").addEventListener("click", function () {
	  const urlParams = new URLSearchParams(window.location.search);
	  
	  // 메인 페이지에서 받은 lat, lon 값 전달
	  var endLat = parseFloat(urlParams.get("lat"));
	  var endLon = parseFloat(urlParams.get("lon"));

	
	  // 현재 위치의 위도와 경도를 가져옵니다.
	  if (navigator.geolocation) {
	    navigator.geolocation.getCurrentPosition(function(position) {
	      const startLat = position.coords.latitude;
	      const startLon = position.coords.longitude;
	
	    
	
	      // 경로안내 페이지로 현재 위치(startLat, startLon)와 도착지(endLat, endLon) 전달
	      if (startLat && startLon && endLat && endLon) {
	          window.location.href = `addressNavigation.jsp?startLat=${startLat}&startLon=${startLon}&endLat=${endLat}&endLon=${endLon}`;
	        } else {
	          alert("위도와 경도를 모두 확인하고 다시 시도하세요.");
	        }
	      });
	    } else {
	    alert("이 브라우저에서는 위치 정보를 사용할 수 없습니다.");
	  }
	});



    
  </script>

</body>
</html>
