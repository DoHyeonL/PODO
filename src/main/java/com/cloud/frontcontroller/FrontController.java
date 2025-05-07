package com.cloud.frontcontroller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cloud.controller.Command;
import com.cloud.controller.EmailCheckService;
import com.cloud.controller.JoinService;
import com.cloud.controller.LoginService;
import com.cloud.controller.LogoutService;
import com.cloud.controller.SelectAllService;
import com.cloud.controller.UpdateService;
import com.cloud.db.MemberDAO;
import com.cloud.model.MemberVO;

// client의 모든 요청을 처리해주는 FrontController
// * Servlet은 굉장히 무거운 파일이다. 여러개 둔다는건 좋은 개발방식 XXX
// * Servlet을 하나만 둘거다!
@WebServlet("*.do")
// 확장자 .do로 끝나는 모든 요청을 처리하겠다.
public class FrontController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// HashMap<Key,Value> --> 경로 - 실행해야하는 파일(V)
	// : 순서가 없는 자료구조 형태
	// : 안에 들어있는 데이터를 구분할 때, 중복이 없는 Key 값을 기준으로 구분
	private HashMap<String, Command> map = new HashMap<String, Command>();
	
	// Servlet 가장 먼저 실행되는 메소드 초기화
	@Override
	public void init() throws ServletException {

		map.put("Join.do" , new JoinService());
		map.put("Login.do" , new LoginService());
		map.put("SelectAll.do" , new SelectAllService());
		map.put("Logout.do" , new LogoutService());
		map.put("Update.do", new UpdateService());
		map.put("EmailCheck.do" , new EmailCheckService());
	
	}
	
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 요청 경로를 가져오는 방법
		String uri = request.getRequestURI();	
		// 2. ContextPath 가져오는 방법
		String cp = request.getContextPath();
		// 3. 경로 잘라내기 --> 우리가 필요한 값 >> Login.do Join,do
		String finalPath = uri.substring(cp.length()+1);
		// 중복코드(1)
		// 한글인코딩 잡아주기
		request.setCharacterEncoding("UTF-8");
		// 마지막에 이동해야되는 페이지 저장하는 변수
		String moveUrl = "";
		Command com = null;
			
		// 4. 최종 경로값에 따라 가능 수행 
		com = map.get(finalPath);
		if(com != null) {
		moveUrl = com.execute(request);
		}
		// 중복되는 코드(2)
		// 페이지 이동
		if(moveUrl == null) {
			// 비동기 통신이 동작하면 이동하는 행위를 하지 않겠다.
			    moveUrl = "error/404.jsp";
		}
		else if(moveUrl.contains("redirect:/")) {
			response.sendRedirect(moveUrl.substring(10));
			return;
		}
		RequestDispatcher rd = request.getRequestDispatcher(moveUrl);
		rd.forward(request, response);
	}
	
	}

	


