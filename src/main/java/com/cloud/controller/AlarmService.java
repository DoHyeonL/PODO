package com.cloud.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.cloud.controller.Command;
import com.cloud.db.GuardianDAO;
import com.cloud.model.GuardianVO;
import com.cloud.model.MemberVO;

public class AlarmService implements Command {

    @Override
    public String execute(HttpServletRequest request) {
        HttpSession session = request.getSession();
        MemberVO loginVO = (MemberVO) session.getAttribute("loginvo");

        if (loginVO == null) {
            request.setAttribute("msg", "로그인이 필요합니다.");
            return "login.jsp";
        }

        // 로그인된 유저 ID로 보호자 리스트 조회
        String userId = loginVO.getUser_id();
        GuardianDAO dao = new GuardianDAO();
        List<GuardianVO> guardianList = dao.selectAllByUserId(userId);
        // request에 저장해서 JSP로 전달
        request.setAttribute("guardianList", guardianList);

        String result = (String) session.getAttribute("result");
        if (result != null) {
            request.setAttribute("result", result);
            session.removeAttribute("result"); // 1회용
        }
        
        return "alarm.jsp";
    }
}
