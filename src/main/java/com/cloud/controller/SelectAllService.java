package com.cloud.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cloud.db.MemberDAO;
import com.cloud.model.MemberVO;

public class SelectAllService implements Command {

	public String execute(HttpServletRequest request, HttpServletResponse response) {

		MemberDAO dao = new MemberDAO();
		List<MemberVO> list = dao.selectAll();
		request.setAttribute("list" , list);
		return "select.jsp";
	
	}
	
	
	
	
	
	
	
	
}
