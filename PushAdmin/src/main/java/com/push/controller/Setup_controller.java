package com.push.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.push.model.Member;
import com.push.service.Setup_service;

@Controller
public class Setup_controller
{
	@Autowired
	private Setup_service setup_service;

	@RequestMapping("setup_page.do")
	public String setup_page(HttpServletRequest request, HttpSession session, Model model)
	{
		Member login_member = (Member)session.getAttribute("login_member");
		if(login_member.getMember_auth() == 0)
		{
			String referer = request.getHeader("Referer");
			return "redirect:" + referer;
		}

		Map<String, Object> setupMap = setup_service.select_setup();
		model.addAttribute("setupMap", setupMap);

		return "setup";
	}

	@RequestMapping("save_setup.do")
	@ResponseBody
	public String save_setup(
			@RequestBody Map<String, Object> request,
			HttpSession session)
	{
		Member login_member = (Member)session.getAttribute("login_member");
		Integer devplaykey_limit_min = Integer.parseInt((String)request.get("devplaykey_limit_min"));
		Integer eventtime_limit_day = Integer.parseInt((String)request.get("eventtime_limit_day"));

		if(login_member.getMember_auth() != 2)
			return "nopermission";

		if((devplaykey_limit_min != null && (devplaykey_limit_min < 1 || devplaykey_limit_min > 1440))
			|| (eventtime_limit_day != null && (eventtime_limit_day < 1 || eventtime_limit_day > 30)))
			return "fail";

		if(devplaykey_limit_min != null)
		{
			if(!setup_service.update_setup_devplaykey(devplaykey_limit_min))
				return "fail";
		}

		if(eventtime_limit_day != null)
		{
			if(!setup_service.update_setup_eventtime(eventtime_limit_day))
				return "fail";
		}

		return "success";
	}
}
