<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>보호자 리스트</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
  		<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  		<script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=e2f8c6a2a365a29b77d9cbddcd5e491e&libraries=services"></script>
  <link rel="stylesheet" href="css/alarm.css"/>
</head>

<body>
	<c:if test="${not empty result}">
  		<script> Swal.fire({
  	      icon: 'success',
  	      title: '완료!',
  	      text: '${result}',
  	      confirmButtonColor: '#3085d6',
  	      confirmButtonText: '확인'
  	    });</script>
	</c:if>
	
 <main style="display: flex; flex-direction: column; align-items: center; width: 100%;">
    <section id="guardian-list-container">
      <c:choose>
        <c:when test="${empty guardianList}">
          <p>등록된 보호자가 없습니다.</p>
        </c:when>
        <c:otherwise>
          <c:forEach var="g" items="${guardianList}">
            <article class="guardian-box animate__animated animate__rollIn">
              <p>이름: ${g.g_name}</p>
              <p>관계: ${g.g_relationship}</p>
              <p>전화번호: ${g.g_phone}</p>
              <form action="SendAlarm.do" method="post" class="alarm-form">
                <input type="hidden" name="g_phone" value="${g.g_phone}">
                <input type="hidden" name="latitude">
 				<input type="hidden" name="longitude">
 				<input type="hidden" name="address">
                <button class="send-btn" type="submit">알림 보내기</button>
              </form>
            </article>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </section>

    <!--  버튼을 리스트 바로 아래 중앙 정렬 -->
    <div style="margin-top: 30px;">
      <button class="send-btn" type="button" style="background-color: #28a745;" onclick="location.href='main.jsp'">
        ⬅ 이전으로
      </button>
    </div>
    </main>
	<!--  현재 위치를 보여줄 지도 영역 -->
<div id="map" style="width: 100%; height: 300px; margin-top: 30px; display: none;"></div>
	
	<script>
	document.addEventListener("DOMContentLoaded", function () {
	    const forms = document.querySelectorAll(".alarm-form");
	    const geocoder = new kakao.maps.services.Geocoder();
	    const mapContainer = document.getElementById('map');
	    let map = null;
	    let marker = null;
	
	    forms.forEach(form => {
	        const submitBtn = form.querySelector("button[type='submit']");
	
	        form.addEventListener("submit", function (e) {
	            e.preventDefault();
	            submitBtn.disabled = true;
	
	            Swal.fire({
	                title: '위치 확인 중...',
	                text: '잠시만 기다려 주세요.',
	                didOpen: () => Swal.showLoading(),
	                allowOutsideClick: false
	            });
	
	            if (navigator.geolocation) {
	                navigator.geolocation.getCurrentPosition(function (position) {
	                    const lat = position.coords.latitude;
	                    const lng = position.coords.longitude;
	
	                    if (lat == null || lng == null) {
	                        Swal.fire("위치 오류", "정확한 위치를 가져오지 못했습니다.", "error");
	                        submitBtn.disabled = false;
	                        return;
	                    }
	
	                    // 지도 표시
	                    mapContainer.style.display = "block";
	                    if (!map) {
	                        map = new kakao.maps.Map(mapContainer, {
	                            center: new kakao.maps.LatLng(lat, lng),
	                            level: 3
	                        });
	                    } else {
	                        map.setCenter(new kakao.maps.LatLng(lat, lng));
	                    }
	
	                    if (!marker) {
	                        marker = new kakao.maps.Marker({
	                            map: map,
	                            position: new kakao.maps.LatLng(lat, lng)
	                        });
	                    } else {
	                        marker.setPosition(new kakao.maps.LatLng(lat, lng));
	                    }
	
	                    // 주소 변환
	                    geocoder.coord2Address(lng, lat, function(result, status) {
	                        if (status === kakao.maps.services.Status.OK) {
	                            const address = result[0].address.address_name;
	
	                            form.querySelector('input[name="latitude"]').value = lat;
	                            form.querySelector('input[name="longitude"]').value = lng;
	                            form.querySelector('input[name="address"]').value = address;
	
	                            Swal.close();
	                            form.submit();
	                        } else {
	                            Swal.fire("주소 변환 실패", "좌표를 주소로 변환할 수 없습니다.", "error");
	                            submitBtn.disabled = false;
	                        }
	                    });
	                }, function () {
	                    Swal.fire("위치 접근 실패", "위치 정보를 가져올 수 없습니다.", "error");
	                    submitBtn.disabled = false;
	                });
	            } else {
	                Swal.fire("지원 안됨", "이 브라우저는 위치 정보를 지원하지 않습니다.", "warning");
	                submitBtn.disabled = false;
	            }
	        });
	    });
	});
	</script>

</body>
</html>

