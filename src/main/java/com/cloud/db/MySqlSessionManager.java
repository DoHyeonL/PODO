package com.cloud.db;

import java.io.IOException;
import java.io.InputStream;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class MySqlSessionManager {
	
	// SqlSessionFactory > DBCP
	// SqlSession > Connection 1개
	public static SqlSessionFactory sqlSessionFactory;
	
	public static SqlSessionFactory getFactory() {
		return sqlSessionFactory;
	}
	
	// 인스턴스 생성
	// : java가 실행되면 바로 호출되는 메소드
	static {		
		// 설정파일 경로를 읽어서 DBCP 준비
		String resource = "com/cloud/db/mybatis-config.xml";
		InputStream inputStream;
		try {
			inputStream = Resources.getResourceAsStream(resource);
			 sqlSessionFactory =
					  new SqlSessionFactoryBuilder().build(inputStream);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
	
}
