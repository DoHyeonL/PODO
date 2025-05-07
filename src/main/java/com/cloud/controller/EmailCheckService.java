package com.cloud.controller;

import javax.servlet.http.HttpServletRequest;

public class EmailCheckService implements Command {

	public String execute(HttpServletRequest request) {
		
		// 요청데이터 꺼내오기
		String email = request.getParameter("receive_email");
		
		System.out.println("들어오니?" + email);
		return null;
	
		// DAO 꺼내오고 사용하기
		
		// 결과값을 비동기 통신으로 반환하고 싶다면?
		// --> 화면에 출력
		// --> PrintWriter
		
	}

}
