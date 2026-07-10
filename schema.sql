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
