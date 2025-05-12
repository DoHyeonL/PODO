package com.cloud.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cloud.db.FacilityDAO;
import com.cloud.model.FacilityVO;
import com.google.gson.Gson;

public class FacilityService implements Command {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        try {
            // 카테고리 파라미터 가져오기
            int category = Integer.parseInt(request.getParameter("category"));
            
            // FacilityDAO 인스턴스를 통해 카테고리에 해당하는 시설 리스트를 가져오기
            FacilityDAO dao = new FacilityDAO();
            List<FacilityVO> list = dao.selectByCategory(category);

            // 각 시설의 아이콘 경로(URL) 인코딩 처리
            for (FacilityVO vo : list) {
                String rawPath = vo.getIcon_path();  // ex: /images/시설물/경찰서.png
                if (rawPath != null && !rawPath.isEmpty()) {
                    // 파일명만 추출
                    String fileName = rawPath.substring(rawPath.lastIndexOf("/") + 1);
                    // URL 인코딩
                    String encoded = URLEncoder.encode(fileName, "UTF-8");
                    // 경로를 '/deepsick' 루트를 기준으로 수정
                    vo.setIcon_path(request.getContextPath() + "/images/시설물/" + encoded);
                }
            }

            // JSON 응답 설정
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/json");

            // JSON으로 변환하여 클라이언트로 응답
            String json = new Gson().toJson(list);
            PrintWriter out = response.getWriter();
            out.write(json);
            out.flush();
            out.close();

            return null;  // 페이지 이동 없음 (AJAX 통신)
        } catch (Exception e) {
            e.printStackTrace();
            try {
                // 예외 발생 시 500 서버 오류 응답 전송
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"서버 오류\"}");
            } catch (IOException io) {
                io.printStackTrace();
            }
            return null;
        }
    }
}
