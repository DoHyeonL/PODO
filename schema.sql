-- 원본 DDL 파일이 저장소에 없어서 Mapper XML의 쿼리를 보고 역으로 추정한 테이블 구조입니다.
-- 실제 컬럼 타입/길이/제약조건과는 다를 수 있습니다.

CREATE TABLE tb_user (
  user_id VARCHAR(50) PRIMARY KEY,
  password VARCHAR(100) NOT NULL,
  name VARCHAR(50),
  email VARCHAR(100),
  phone VARCHAR(20),
  address VARCHAR(200)
);

CREATE TABLE tb_guardian (
  guardian_idx INT AUTO_INCREMENT PRIMARY KEY,
  user_id VARCHAR(50),
  g_name VARCHAR(50),
  g_phone VARCHAR(20),
  g_relationship VARCHAR(30),
  reg_date DATETIME,
  FOREIGN KEY (user_id) REFERENCES tb_user(user_id)
);

CREATE TABLE tb_report (
  report_idx INT AUTO_INCREMENT PRIMARY KEY,
  user_id VARCHAR(50),
  report_type VARCHAR(50),
  report_content VARCHAR(500),
  report_status VARCHAR(20),
  FOREIGN KEY (user_id) REFERENCES tb_user(user_id)
);

CREATE TABLE tb_ficility_result (
  fac_idx INT AUTO_INCREMENT PRIMARY KEY,
  fac_name VARCHAR(100),
  fac_category INT,
  fac_address VARCHAR(200),
  lat DOUBLE,
  lon DOUBLE,
  reg_date DATETIME,
  icon_path VARCHAR(200),
  is_visible CHAR(1) DEFAULT 'Y'
);

-- 지도에 마커 찍어볼 샘플 데이터 (광주 5개 구 실제 업체, T맵 검색으로 찾음)
-- fac_category: 1=경찰서, 2=소방서, 3=CCTV, 4=편의점
INSERT INTO tb_ficility_result (fac_name, fac_category, fac_address, lat, lon, reg_date, icon_path, is_visible) VALUES
-- 경찰서 (5개 구 전부)
('광주서부경찰서', 1, '전남광주 서구 치평동', 35.15075646, 126.84284748, NOW(), 'images/시설물/경찰서.png', 'Y'),
('광주북부경찰서', 1, '전남광주 북구 오치동', 35.18714219, 126.89923047, NOW(), 'images/시설물/경찰서.png', 'Y'),
('광주광산경찰서', 1, '전남광주 광산구 운수동', 35.15258858, 126.78332493, NOW(), 'images/시설물/경찰서.png', 'Y'),
('광주남부경찰서', 1, '전남광주 남구 봉선동', 35.12242764, 126.92103572, NOW(), 'images/시설물/경찰서.png', 'Y'),
('광주동부경찰서', 1, '전남광주 동구 대의동', 35.14917460, 126.91953519, NOW(), 'images/시설물/경찰서.png', 'Y'),
-- 소방서 (5개 구 본부 + 서구 안전센터 몇 곳)
('서부소방서', 2, '전남광주 서구 화정동', 35.15670079, 126.87634437, NOW(), 'images/시설물/소방서.png', 'Y'),
('북부소방서', 2, '전남광주 북구 오치동', 35.18653136, 126.91186826, NOW(), 'images/시설물/소방서.png', 'Y'),
('동부소방서', 2, '전남광주 동구 대인동', 35.15428505, 126.91475770, NOW(), 'images/시설물/소방서.png', 'Y'),
('남부소방서', 2, '전남광주 남구 송하동', 35.11031718, 126.87837313, NOW(), 'images/시설물/소방서.png', 'Y'),
('광산소방서', 2, '전남광주 광산구 하남동', 35.18577950, 126.79662848, NOW(), 'images/시설물/소방서.png', 'Y'),
('상무119안전센터', 2, '전남광주 서구 치평로 65', 35.15336735, 126.84729147, NOW(), 'images/시설물/소방서.png', 'Y'),
('금호119안전센터', 2, '전남광주 서구 운천로 112', 35.14261874, 126.85801301, NOW(), 'images/시설물/소방서.png', 'Y'),
-- 편의점 (5개 구 골고루)
('세븐일레븐 광주상무유탑점', 4, '전남광주 서구 시청로 92', 35.15647819, 126.85231872, NOW(), 'images/시설물/안심시설.png', 'Y'),
('GS25 상무S클래스점', 4, '전남광주 서구 시청로 97', 35.15775581, 126.85112435, NOW(), 'images/시설물/안심시설.png', 'Y'),
('GS25 광주장동점', 4, '전남광주 동구 장동', 35.14825812, 126.92445144, NOW(), 'images/시설물/안심시설.png', 'Y'),
('GS25 조대정문점', 4, '전남광주 동구 서석동', 35.14503627, 126.92497925, NOW(), 'images/시설물/안심시설.png', 'Y'),
('세븐일레븐 광주북구청점', 4, '전남광주 북구 중흥동', 35.17344953, 126.91350733, NOW(), 'images/시설물/안심시설.png', 'Y'),
('CU 전남대용봉문화관점', 4, '전남광주 북구 용봉동', 35.17547705, 126.91147968, NOW(), 'images/시설물/안심시설.png', 'Y'),
('GS25 백운사랑점', 4, '전남광주 남구 백운동', 35.13506477, 126.90139825, NOW(), 'images/시설물/안심시설.png', 'Y'),
('GS25 광산구청점', 4, '전남광주 광산구 송정동', 35.13867366, 126.79365769, NOW(), 'images/시설물/안심시설.png', 'Y');
