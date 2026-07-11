package com.cloud.controller;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cloud.db.MemberDAO;

public class CheckIdService implements Command {

	public String execute(HttpServletRequest request, HttpServletResponse response) {

		String user_id = request.getParameter("user_id");

		MemberDAO dao = new MemberDAO();
		int count = dao.checkId(user_id);

		try {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/plain");
			PrintWriter out = response.getWriter();

			if (count > 0) {
				out.write("dup"); // 이미 있는 아이디
			} else {
				out.write("ok"); // 사용 가능
			}

			out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null; // 페이지 이동 없음 (AJAX)
	}

}
