package com.cloud.db;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import com.cloud.model.ReportVO;

public class ReportDAO {
    private SqlSessionFactory factory = MySqlSessionManager.getFactory();

    public int insertReport(ReportVO vo) {
        SqlSession session = factory.openSession();
        int result = 0;
        try {
            result = session.insert("insertReport", vo);
            session.commit();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            session.close();
        }
        return result;
    }
}
