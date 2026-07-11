package com.cloud.db;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import com.cloud.model.MemberVO;

public class MemberDAO {

	// 1. 필드
	private SqlSessionFactory factory = MySqlSessionManager.getFactory();
	
	// Mybatis 방식으로 DB 연결
	// 1. 회원가입 메소드
	public int join(MemberVO member) {
		// 1. 동적로딩 --> mybatis-config.xml
		// 2. 연결 --> MySqlSessionManager 
		// 3. sql구문 준비 --> MemberMapper.xml
		// 4. 실행
		// 4-1) factory에서 sqlSessoin 빌려오기
		// factory.openSession(true) --> auto commit 형태로 코드를 작동시키겠다.
		SqlSession sqlsession = factory.openSession(true);
		// 4-2) 사용
		// sqlsession.insert("태그의id값" ,매개변수)
		int row = sqlsession.insert("join", member);
		// 4-3) 반납
		sqlsession.close();
		
		return row;
	}

	public MemberVO login(MemberVO mvo) {
		// 1. sqlsession 빌려오기
		SqlSession sqlSession = factory.openSession(true);
		// 2. sqlsession 사용하기 --> select --> 데이터 1개 조회
		// (1) selectOne --> 1개의 데이터를 조회할 때 사용
		//				 --> return type T(어떤 자료형이든 들어올 수 있음)
		// (2) selectList --> 여러개의 데이터를 조회할 때 사용
		// 				 --> return Type List<T> (ArrayList 부모클래스)
		MemberVO resultVo = sqlSession.selectOne("login", mvo);
		// 3. sqlsession 반납하기
		sqlSession.close();
		// 4. 결과값 반환하기
		return resultVo;
	}

	public List<MemberVO> selectAll() {

		// 1. 빌려오기
		SqlSession sqlSession = factory.openSession(true);
		// 2. 사용하기
		List<MemberVO> list = sqlSession.selectList("selectALL");
		// 3. 반납하기
		sqlSession.close();
		// 4. 결과값 반환하기		
		
		return list;
	}

	public int update(MemberVO paravo) {

		SqlSession sqlSession = factory.openSession(true);
		int row = sqlSession.update("update", paravo);
		sqlSession.close();
		return row;
	}

	// 아이디 중복확인용, 같은 아이디 몇개 있는지 세서 반환
	public int checkId(String user_id) {
		SqlSession sqlSession = factory.openSession(true);
		int count = sqlSession.selectOne("checkId", user_id);
		sqlSession.close();
		return count;
	}


}
