package com.push.util;

import java.io.IOException;
import java.sql.Timestamp;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.push.model.Member;
import com.push.service.Member_service;

@Component
public class LoginCheckInterceptor extends HandlerInterceptorAdapter
{
	@Autowired
	private Member_service member_service;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws IOException
			 {
		try {
		if(request.getSession() != null && request.getSession().getAttribute("login_member") != null)
		{
			Member member = (Member)request.getSession().getAttribute("login_member");
		
			member.setLast_login_date(new Timestamp(System.currentTimeMillis()));
			if(!member_service.update_member_last_login_date(member))
				return false;
		}
		else
		{
			response.sendRedirect("/PushAdmin/main.do");
		}
		
		return super.preHandle(request, response, handler);
		}catch(Exception e)
		{
			response.sendRedirect("/PushAdmin/main.do");
		}
		return false;
	}
}
