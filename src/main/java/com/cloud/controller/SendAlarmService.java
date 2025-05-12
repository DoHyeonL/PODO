package com.cloud.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cloud.model.MemberVO;

public class SendAlarmService implements Command {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        // 로그인 사용자 확인 (선택)
        HttpSession session = request.getSession();
        MemberVO loginVO = (MemberVO) session.getAttribute("loginvo");

        if (loginVO == null) {
            request.setAttribute("msg", "로그인이 필요합니다.");
            return "login.jsp";
        }
        
        // 전달된 파라미터 받기
        String g_phone = request.getParameter("g_phone");
        String latitude = request.getParameter("latitude");
        String longitude = request.getParameter("longitude");
        String address = request.getParameter("address");

     // 메시지 구성
        String guardianEmail = g_phone;
        String subject = "[긴급 알림] " + loginVO.getName() + " 님의 도움 요청";

        String marker = latitude + "," + longitude;

     // 마커 파라미터는 URL 인코딩을 하지 말고 직접 넣되 정확히 구문 유지
     String mapImgUrl = "https://maps.googleapis.com/maps/api/staticmap"
         + "?center=" + marker
         + "&zoom=17"
         + "&size=600x300"
         + "&maptype=roadmap"
         + "&markers=color:red%7Clabel:S%7C" + marker
         + "&key=AIzaSyCA-9uMR6hh9gmYpMM9N_wyINPHGZd_jHA";


     // 지도 링크는 마커 위치를 정확히 포함하는 URL로
        String mapLink = "https://www.google.com/maps/place/" + marker;

        String htmlBody = ""
        	    + "<p><strong>" + loginVO.getName() + " 님이 도움을 요청했습니다.</strong></p>"
        	    + "<p>📍 현재 위치 주소: " + address + "</p>"
        	    + "<img src='" + mapImgUrl + "' style='width:100%; max-width:600px; margin-top:10px;' alt='위치 지도'>"
        	    + "<p style='margin-top:15px;'>"
        	    + "<a href='" + mapLink + "' target='_blank' style='display:inline-block; padding:10px 20px; background:#4285f4; color:#fff; border-radius:5px; text-decoration:none;'>"
        	    + "📍 구글 지도에서 위치 보기"
        	    + "</a></p>";

        System.out.println("위도: " + latitude + ", 경도: " + longitude);


        boolean success = sendEmail(guardianEmail, subject, htmlBody);

        if (success) {
            session.setAttribute("result", "알림이 이메일로 전송되었습니다.");
        } else {
            session.setAttribute("result", "이메일 전송 실패: 서버 오류");
        }

        return "redirect:/Alarm.do";
    }

    private boolean sendEmail(String to, String subject, String body) {
        final String from = "spit114@gmail.com";        // 발신자 이메일
        final String password = "rbzfazvosayoxezu";       // 앱 비밀번호

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
                return new javax.mail.PasswordAuthentication(from, password);
            }
        });

        try {
            javax.mail.Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from, MimeUtility.encodeText("안심 알림", "UTF-8", "B")));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(body, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("이메일 전송 완료");
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}