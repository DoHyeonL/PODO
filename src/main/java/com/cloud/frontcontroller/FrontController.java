package com.cloud.frontcontroller;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cloud.controller.*;

@WebServlet("*.do")
public class FrontController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private HashMap<String, Command> map = new HashMap<>();

    @Override
    public void init() throws ServletException {
        map.put("Join.do", new JoinService());
        map.put("Login.do", new LoginService());
        map.put("Logout.do", new LogoutService());
        map.put("Update.do", new UpdateService());
        map.put("EmailCheck.do", new EmailCheckService());
        map.put("CheckId.do", new CheckIdService());
        map.put("Alarm.do", new AlarmService());
        map.put("SendAlarm.do", new SendAlarmService());
        map.put("FacilityMap.do", new FacilityService());
        map.put("FacilityReport.do", new ReportService());
    }

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();
        String cp = request.getContextPath();
        String finalPath = uri.substring(cp.length() + 1);

        System.out.println(">>> 요청 URI: " + finalPath);

        request.setCharacterEncoding("UTF-8");

        Command com = map.get(finalPath);
        String moveUrl = null;

        if (com != null) {
            moveUrl = com.execute(request, response);
        } else {
            System.out.println("[오류] 해당 URI에 매핑된 Command 없음: " + finalPath);
        }

        // 비동기 통신 등으로 페이지 이동이 필요 없는 경우
        if (moveUrl == null) {
            System.out.println("→ moveUrl이 null: 페이지 이동 없음 (AJAX 등)");
            return;
        }

        // redirect:/ 경로인 경우
        if (moveUrl.contains("redirect:/")) {
            String redirectPath = moveUrl.substring(10);
            response.sendRedirect(redirectPath);
            return;
        }

        // forward 이동
        RequestDispatcher rd = request.getRequestDispatcher(moveUrl);
        rd.forward(request, response);
    }
}
