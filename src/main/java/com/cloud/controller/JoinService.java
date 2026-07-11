package com.cloud.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cloud.db.GuardianDAO;
import com.cloud.db.MemberDAO;
import com.cloud.model.GuardianVO;
import com.cloud.model.MemberVO;

public class JoinService implements Command {

			public String execute(HttpServletRequest request, HttpServletResponse response ) {

			      String user_id = request.getParameter("user_id");
			      String password = request.getParameter("password");
			      String name = request.getParameter("name");
			      String email = request.getParameter("email");
			      String phone = request.getParameter("phone1") + request.getParameter("phone2");
			      String address = request.getParameter("address");
			      
			      MemberVO member = new MemberVO(user_id, password, name, email, phone, address);
			      MemberDAO dao = new MemberDAO();
			       int row = dao.join(member);
			       
			    // 보호자 정보 받기
			        String[] g_names = request.getParameterValues("g_name[]");
			        String[] g_phones = request.getParameterValues("g_phone[]");
			        String[] g_relations = request.getParameterValues("g_relation[]");

			        boolean allSuccess = true;

			        if (g_names != null && g_phones != null && g_relations != null) {
			            GuardianDAO guardianDao = new GuardianDAO();
			            for (int i = 0; i < g_names.length; i++) {
			                GuardianVO guardian = new GuardianVO(user_id, g_names[i], g_phones[i], g_relations[i]);
			                int result = guardianDao.insertGuardian(guardian);
			                if (result <= 0) {
			                    allSuccess = false;
			                    break;
			                }
			            }
			        }

			        // 결과 분기
			        if (row > 0 && allSuccess) {
			            request.setAttribute("user_id", user_id);
			            return "join_success.jsp";
			        } else if (row <= 0) {
			            return "redirect:/main.jsp";
			        } else {
			            return "redirect:/login.jsp"; // 보호자 저장 실패 시
			        }
			    }
			}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

