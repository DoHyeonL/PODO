<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>장소 검색</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <style>


    @font-face {
          font-family: 'yg-jalnan';
          src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_four@1.2/JalnanOTF00.woff') format('woff');
          font-weight: normal;
          font-style: normal;
      }
      
    html, body {
    margin: 0;
    height: 100%;
    background-color: #ccc;
    font-family: 'Helvetica Neue', sans-serif;
}

#container {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);

    width: 600px;
    height: 100%; /* 고정 높이 추천 */

    background-color: #ffffff;
    overflow: hidden;

    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

    .search-box {    
      margin-top: 50px;
      background: #fff;
      width: 62%;
      padding: 24px;
      border-radius: 12px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
      margin-bottom: 24px;
    }

    .input-group {
      display: flex;
      gap: 10px;
      margin-bottom: 16px;
    }

    input[type="text"] {
      flex: 1;
      padding: 12px 14px;
      font-size: 16px;
      border: 1px solid #ccc;
      border-radius: 8px;
      transition: border-color 0.2s;
    }

    input[type="text"]:focus {
      outline: none;
      border-color: #2b80ff;
    }

    .search-btn {
      font-family: 'yg-jalnan', sans-serif;
      padding: 12px 16px;
      font-size: 16px;
      background-color: #2b80ff;
      color: white;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      transition: background-color 0.2s;
    }

    .search-btn:hover {
      background-color: #1868d8;
    }

    #goBtn {
      font-family: 'yg-jalnan', sans-serif;
      width: 70%;
      height: 50px;
      font-size: 18px;
      background-color: #ff5858;
      color: white;
      border: none;
      border-radius: 10px;
      cursor: pointer;
      margin-top: 10px;
      transition: background-color 0.2s;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
      margin-bottom: 50px;
    }

    #goBtn:hover {
      background-color: #e74c3c;
    }

    main#result-wrap {
      max-height: 650px;
      overflow-y: auto;
    }

    #result-wrap::-webkit-scrollbar {
      display: none;               /* Chrome, Safari, Edge */
    }

    .result-item {
      background: white;
      width: 390px;
      padding: 16px;
      border-radius: 10px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.08);
      margin-bottom: 12px;
      cursor: pointer;
      transition: background-color 0.2s, transform 0.1s;
      
    }

    .result-item:hover {
      background-color: #f7f9fb;
      transform: scale(1.01);
    }

    .poi-name {
      font-size: 17px;
      font-weight: bold;
      color: #2c3e50;
    }

    .poi-address {
      font-size: 14px;
      color: #666;
      margin-top: 6px;
    }

    @media (max-width: 600px) {
      .input-group {
        flex-direction: column;
      }
      .search-btn {
        width: 100%;
      }
    }
  </style>
</head>
<body>
  <div id="container">
    <div class="search-box">
      <div class="input-group">
        <input type="text" id="startInput" placeholder="출발지를 입력하세요" oninput="debounceSearch(this.value, 'start')" />
        <button class="search-btn" onclick="searchAddress(document.getElementById('startInput').value, 'start')">검색</button>
      </div>
      <div class="input-group">
        <input type="text" id="endInput" placeholder="도착지를 입력하세요" oninput="debounceSearch(this.value, 'end')" />
        <button class="search-btn" onclick="searchAddress(document.getElementById('endInput').value, 'end')">검색</button>
      </div>
    </div>

    <main id="result-wrap">
      <!-- 검색 결과 출력 -->
    </main>

    <button id="goBtn" onclick="goToPath()">경로 안내 받기</button>
  </div>

  <script>
    let targetField = "";
    let debounceTimer;

    function debounceSearch(value, field) {
      clearTimeout(debounceTimer);
      debounceTimer = setTimeout(() => {
        searchAddress(value, field);
      }, 300);
    }

    function searchAddress(keyword, field) {
      targetField = field;

      if (keyword.trim().length < 2) {
        document.getElementById("result-wrap").innerHTML = "";
        return;
      }

      $.ajax({
        type: "GET",
        url: "https://apis.openapi.sk.com/tmap/pois",
        data: {
          version: 1,
          searchKeyword: keyword,
          resCoordType: "WGS84GEO",
          reqCoordType: "WGS84GEO",
          count: 10,
          appKey: "C0A4SwhCGE2ocuN4vTAeD7ClrI5Jb1Kk5nj6or4F"
        },
        success: function(response) {
          const pois = response?.searchPoiInfo?.pois?.poi;
          const resultWrap = document.getElementById("result-wrap");
          resultWrap.innerHTML = "";

          if (!pois || pois.length === 0) {
            const p = document.createElement("p");
            p.textContent = "검색 결과가 없습니다.";
            resultWrap.appendChild(p);
            return;
          }

          pois.forEach(poi => {
            const name = poi.name?.replace(/['"<>]/g, "") || "이름 없음";

            const addrParts = [
              poi.upperAddrName,
              poi.middleAddrName,
              poi.lowerAddrName,
              poi.detailAddrName
            ].filter(Boolean);
            let address = addrParts.join(" ");

            let roadPart = "";
            if (poi.roadName && poi.firstBuildNo) {
              roadPart = `${poi.roadName} ${poi.firstBuildNo}`;
              if (poi.secondBuildNo) {
                roadPart += `-${poi.secondBuildNo}`;
              }
            }

            if (roadPart) {
              address += address ? ` ${roadPart}` : roadPart;
            }

            if (!address.trim()) {
              address = "주소 정보 없음";
            }

            const item = document.createElement("div");
            item.className = "result-item";

            const nameDiv = document.createElement("div");
            nameDiv.className = "poi-name";
            nameDiv.textContent = name;

            const addrDiv = document.createElement("div");
            addrDiv.className = "poi-address";
            addrDiv.textContent = address;

            item.appendChild(nameDiv);
            item.appendChild(addrDiv);

            item.addEventListener("click", () => {
              document.getElementById(targetField === "start" ? "startInput" : "endInput").value = name;
              resultWrap.innerHTML = "";
            });

            resultWrap.appendChild(item);
          });
        },
        error: function(error) {
          console.log("API 요청 실패:", error);
          const resultWrap = document.getElementById("result-wrap");
          resultWrap.innerHTML = "<p>검색 실패</p>";
        }
      });
    }

    function goToPath() {
      const start = document.getElementById("startInput").value;
      const end = document.getElementById("endInput").value;
      if (!start || !end) {
        alert("출발지와 도착지를 모두 입력하세요.");
        return;
      }
      window.location.href = "pathSelect.jsp?start=" + encodeURIComponent(start) + "&end=" + encodeURIComponent(end);
    }
  </script>
</body>
</html>
