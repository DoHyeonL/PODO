package com.cloud.db;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import com.cloud.model.GuardianVO;

public class GuardianDAO {

    // MyBatis 세션 팩토리 가져오기
    private SqlSessionFactory factory = MySqlSessionManager.getFactory();

    // 보호자 정보 INSERT
    public int insertGuardian(GuardianVO guardian) {
        SqlSession sqlSession = factory.openSession(true); // Auto Commit ON
        int row = sqlSession.insert("insertGuardian", guardian); // mapper id 사용
        sqlSession.close();
        return row;
    }

    // (선택) 보호자 조회 메서드도 추가 가능
    public GuardianVO selectByUserId(String user_id) {
        SqlSession sqlSession = factory.openSession(true);
        GuardianVO vo = sqlSession.selectOne("selectByUserId", user_id);
        sqlSession.close();
        return vo;
    }
    
    // 보호자 정보 수정
    public int updateGuardian(GuardianVO guardian) {
        SqlSession sqlSession = factory.openSession(true); // auto commit
        int row = sqlSession.update("updateGuardian", guardian); // mapper id 사용
        sqlSession.close();
        return row;
    }
    
    
}
