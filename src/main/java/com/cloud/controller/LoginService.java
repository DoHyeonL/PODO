package com.cloud.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cloud.db.MemberDAO;
import com.cloud.model.MemberVO;

public class LoginService implements Command {

		public String execute(HttpServletRequest request, HttpServletResponse response) {

			String user_id = request.getParameter("user_id");
			String password = request.getParameter("password");
			MemberVO mvo = new MemberVO();
			mvo.setUser_id(user_id);
			mvo.setPassword(password);
			MemberDAO dao = new MemberDAO();
			MemberVO resultVo = dao.login(mvo);
			if(resultVo != null) {
				HttpSession session = request.getSession();
				session.setAttribute("loginvo", resultVo);
				return "redirect:/main.jsp";
			} else {
				request.setAttribute("errorMsg", "아이디 또는 비밀번호가 올바르지 않습니다.");
			    return "/login.jsp";  
			}
		} 
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
