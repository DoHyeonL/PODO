package com.cloud.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.cloud.db.MemberDAO;
import com.cloud.model.MemberVO;

public class SelectAllService implements Command {

	public String execute(HttpServletRequest request) {

		MemberDAO dao = new MemberDAO();
		List<MemberVO> list = dao.selectAll();
		request.setAttribute("list" , list);
		return "select.jsp";
	
	}
	
	
	
	
	
	
	
	
}
