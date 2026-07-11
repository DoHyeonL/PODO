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

-- 지도에 마커 찍어볼 샘플 데이터 (광주 서구 시청 근처 실제 업체, T맵 검색으로 찾음)
-- fac_category: 1=경찰서, 2=소방서, 3=CCTV, 4=편의점
INSERT INTO tb_ficility_result (fac_name, fac_category, fac_address, lat, lon, reg_date, icon_path, is_visible) VALUES
('광주서부경찰서', 1, '전남광주 서구 상무공원로 71', 35.15075646, 126.84284748, NOW(), 'images/시설물/경찰서.png', 'Y'),
('소방안전본부', 2, '전남광주 서구 내방로 111', 35.16025552, 126.85120762, NOW(), 'images/시설물/소방서.png', 'Y'),
('상무119안전센터', 2, '전남광주 서구 치평로 65', 35.15336735, 126.84729147, NOW(), 'images/시설물/소방서.png', 'Y'),
('금호119안전센터', 2, '전남광주 서구 운천로 112', 35.14261874, 126.85801301, NOW(), 'images/시설물/소방서.png', 'Y'),
('세븐일레븐 광주상무유탑점', 4, '전남광주 서구 시청로 92', 35.15647819, 126.85231872, NOW(), 'images/시설물/안심시설.png', 'Y'),
('세븐일레븐 광주상무랜드피아점', 4, '전남광주 서구 상무중앙로 114', 35.15706141, 126.84934675, NOW(), 'images/시설물/안심시설.png', 'Y'),
('GS25 상무S클래스점', 4, '전남광주 서구 시청로 97', 35.15775581, 126.85112435, NOW(), 'images/시설물/안심시설.png', 'Y');
