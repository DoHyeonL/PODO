package com.cloud.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.cloud.db.MemberDAO;
import com.cloud.model.MemberVO;

public class UpdateService implements Command {

	public String execute(HttpServletRequest request) {
	
		// 1. 요청 데이터 꺼내오기
		String user_id = request.getParameter("user_id");
		String password = request.getParameter("password");
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");
		
		// session에 저장된 email 정보를 하나 꺼내오기
		HttpSession session = request.getSession();
		MemberVO mvo = (MemberVO) session.getAttribute("loginvo");
		String uesr_id = mvo.getUser_id();
		
		// 2. 데이터를 하나로 묶어주기
		MemberVO paravo = new MemberVO(user_id, password, name, email, phone, address);
		// 3. DAO 생성하기
		MemberDAO dao = new MemberDAO();
		// 4. dao.update 기능을 실행하기
		int row = dao.update(paravo);
		
		if(row > 0) {
			// session 영역안에 저장된 로그인 정보를 업데이트한 정보로 변경
			session.setAttribute("loginvo", paravo);
		}
		
		// 5. main.jsp 이동
		return "redirect:/.jsp";
	
	}
}
