package com.cloud.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// FC안에서 동작할 각각의 일반 POJO 클래스 파일들의 규격!
// 모든 POJO 부모 인터페이스
public interface Command {
    String execute(HttpServletRequest request, HttpServletResponse response);
}
