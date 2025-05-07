package com.cloud.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.cloud.controller.Command;
import com.cloud.model.MemberVO;

public class SendAlarmService implements Command {

    @Override
    public String execute(HttpServletRequest request) {
        // 로그인 사용자 확인 (선택)
        HttpSession session = request.getSession();
        MemberVO loginVO = (MemberVO) session.getAttribute("loginvo");

        if (loginVO == null) {
            request.setAttribute("msg", "로그인이 필요합니다.");
            return "login.jsp";
        }

        // 전달받은 보호자 전화번호 꺼내기
        String g_phone = request.getParameter("g_phone");
        // 실제 메시지 전송 로직 (예: 콘솔 출력 또는 API 호출)
        System.out.println("📢 보호자에게 알림 전송: " + g_phone);

        // 사용자가 다시 alarm.jsp로 돌아가도록 설정
        session.setAttribute("result", "알림이 전송되었습니다.");
        return "redirect:/Alarm.do";  // 다시 리스트로 리다이렉트
    }
}
