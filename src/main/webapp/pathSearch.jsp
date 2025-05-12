<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>장소 검색</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <style>
    * { box-sizing: border-box; font-family: 'Apple SD Gothic Neo', 'Malgun Gothic', sans-serif; }
    html, body {
      margin: 0;
      padding: 0;
      width: 100vw;
      height: 100vh;
      background: #f9f9f9;
    }
    #container {
      width: 100%;
      max-width: 550px;
      margin: 0 auto;
    }
    header {
      padding: 16px;
      background: white;
      box-shadow: 0 1px 4px rgba(0,0,0,0.1);
    }
    .input-group {
      display: flex;
      gap: 8px;
      margin-bottom: 12px;
    }
    input[type="text"] {
      flex: 1;
      padding: 12px;
      font-size: 16px;
      border: 1px solid #ccc;
      border-radius: 6px;
    }
    button.search-btn {
      padding: 12px 16px;
      font-size: 16px;
      background-color: #2b80ff;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
    }
    #goBtn {
      margin: 16px;
      width: calc(100% - 32px);
      height: 48px;
      font-size: 18px;
      background-color: #ff5858;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
    }
    main {
      padding: 30px 16px 20px;
    }
    .result-item {
      display: flex;
      flex-direction: column;
      padding: 14px;
      background: #fff;
      border-radius: 6px;
      margin-bottom: 10px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.08);
      cursor: pointer;
      transition: background 0.2s;
    }
    .result-item:hover {
      background: #f0f0f0;
    }
    .poi-name {
      font-size: 16px;
      font-weight: bold;
      color: #333;
    }
    .poi-address {
      font-size: 14px;
      color: #666;
      margin-top: 4px;
    }
  </style>
</head>
<body>
  <div id="container">
    <header>
      <div class="input-group">
        <input type="text" id="startInput" placeholder="출발지를 입력하세요" oninput="debounceSearch(this.value, 'start')" />
        <button class="search-btn" onclick="searchAddress(document.getElementById('startInput').value, 'start')">검색</button>
      </div>
      <div class="input-group">
        <input type="text" id="endInput" placeholder="도착지를 입력하세요" oninput="debounceSearch(this.value, 'end')" />
        <button class="search-btn" onclick="searchAddress(document.getElementById('endInput').value, 'end')">검색</button>
      </div>
    </header>

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
