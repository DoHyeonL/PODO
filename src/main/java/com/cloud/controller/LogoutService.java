package com.cloud.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class LogoutService implements Command {

		public String execute(HttpServletRequest request) {

			HttpSession session = request.getSession();
			session.invalidate();
			return "redirect:/.jsp";
		
		}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
