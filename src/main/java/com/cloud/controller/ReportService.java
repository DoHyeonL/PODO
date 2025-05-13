package com.cloud.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cloud.db.ReportDAO;
import com.cloud.model.MemberVO;
import com.cloud.model.ReportVO;

public class ReportService implements Command {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        try {
            // 🟨 로그인 객체 확인 전 로그 추가
            System.out.println("[ReportService] execute() 호출됨");

            HttpSession session = request.getSession();
            MemberVO loginUser = (MemberVO) session.getAttribute("loginvo");

            // 🟨 로그인 세션 확인 로그 추가
            if (loginUser == null) {
                System.out.println("[ReportService] 로그인 세션 없음 (loginvo == null)");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
                return null;
            }

            // 🟨 로그인 정보 출력
            String userId = loginUser.getUser_id();
            System.out.println("[ReportService] 로그인 사용자 ID: " + userId);

            // 🟨 신고 객체 생성 로그 추가
            ReportVO report = new ReportVO();
            report.setUser_id(userId);
            report.setReport_type("시설");
            report.setReport_content("사용자가 시설 신고 버튼을 클릭함.");
            report.setReport_status("처리중");

            System.out.println("[ReportService] 신고 객체 생성 완료");

            int result = new ReportDAO().insertReport(report);

            System.out.println("[ReportService] DAO 처리 결과: " + result);

            if (result > 0) {
                response.setStatus(HttpServletResponse.SC_OK); // 200 OK
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500
            }

        } catch (Exception e) {
            System.out.println("[ReportService] 예외 발생");
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500
        }

        System.out.println("[ReportService] execute() 종료");
        return null; // AJAX 요청이므로 JSP 이동 없음
    }
}
