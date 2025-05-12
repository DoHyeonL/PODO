package com.cloud.db;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import com.cloud.model.FacilityVO;

public class FacilityDAO {
    private SqlSession sqlSession;

    public FacilityDAO(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }

    public FacilityDAO() {
    }

    public List<FacilityVO> selectByCategory(int category) {
        SqlSession session = MySqlSessionManager.getSqlSession();
        List<FacilityVO> list = session.selectList("facility.selectByCategory", category);
        session.close();
        return list;
    }
}

