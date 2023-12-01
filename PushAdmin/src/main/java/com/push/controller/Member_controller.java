package com.push.controller;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.push.model.Member;
import com.push.service.Member_service;
import com.push.util.Encryption;

@Controller
public class Member_controller
{	  
	@Autowired
	private Member_service member_service;

	@RequestMapping("main.do")
	public String main()
	{
		return "main";
	}

	@RequestMapping("login_check.do")
	@ResponseBody
	public String login_check(
			@RequestBody Map<String, Object> request,
			HttpSession session)
	{
		String member_id = (String)request.get("member_id");
		String member_pw = (String)request.get("member_pw");
		
		if(member_id == null || member_pw == null) {
			session.invalidate();
			return "fail";
		}
		
		if(session.isNew() == false)
			session.removeAttribute("login_member");
		
		Member member = member_service.select_member_where_member_id(member_id);
		if(member == null)
			return "incorrect";

		if(!member.getMember_pw().equals(Encryption.sha256(member_pw))) {
		  member = null;
		  return "incorrect";
		}
		session.setAttribute("login_member", member);
		int maxsesion_time = session.getMaxInactiveInterval();
		try {
		if(maxsesion_time == -1)
			session.setMaxInactiveInterval(-1);
		else if(maxsesion_time > 50000)
			session.setMaxInactiveInterval(50000); //session time set..(SEC) / 	web-xml <session-timeout> 의 경우 분단위 
		
		}catch(Exception e)
		{
		 
			session.setMaxInactiveInterval(36000);
		}member = null;
		return "success";
	}

	@RequestMapping("logout.do")
	public String logout(
			HttpSession session)
	{
		session.removeAttribute("login_member");
		session.invalidate();//clear session
		return "redirect:main.do";
	}

	@RequestMapping("member_page.do")
	public String member_page(
			HttpServletRequest request,
			HttpSession session,
			Model model,
			@RequestParam(defaultValue = "create_date", value = "sort") String sort,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "desc", value = "direction") String direction)
	{
		Member login_member = (Member)session.getAttribute("login_member");
		if(login_member == null) {
			return "redirect:" + "main.do";
		}else if(!login_member.getMember_id().equals("admin"))
		{
			String referer = request.getHeader("Referer");
			return "redirect:" + referer;
		}

		List<Map<String, Object>> member_list = member_service.select_member_all(sort, direction, page);

		int total_count = member_service.count_member_all();
		int last_page = 0;
		if(total_count % 10 == 0)
			last_page = total_count / 10;
		else
			last_page = total_count / 10 + 1;
		
		model.addAttribute("member_list", member_list);
		model.addAttribute("direction", direction);
		model.addAttribute("sort", sort);
		model.addAttribute("current_page", page);
		model.addAttribute("start_page", (page - 1) / 10 * 10 + 1);
		model.addAttribute("end_page", (page - 1) / 10 * 10 + 10);
		model.addAttribute("last_page", last_page);
				
		return "member";
	}

	@RequestMapping("id_duplicate_ck.do")
	@ResponseBody
	public String id_duplicate_ck(
			@RequestBody Map<String, Object> request,
			HttpSession session)
	{
		Member login_member = (Member)session.getAttribute("login_member");
		String member_id = (String)request.get("member_id");

		if(!login_member.getMember_id().equals("admin"))
			return  "nopermission";

		if(member_id == null)
			return "fail";

		Member member = member_service.select_member_where_member_id(member_id);
		if(member != null)
			return "exist";

		return "success";
	}

	@RequestMapping("add_member.do")
	@ResponseBody
	public String add_member(
			@RequestBody Map<String, Object> request,
			HttpSession session)
	{
		Member login_member = (Member)session.getAttribute("login_member");
		String member_id = (String)request.get("member_id");
		String member_pw = (String)request.get("member_pw");
		Integer member_auth = (Integer)request.get("member_auth"); // DDNS : 0, 조회 : 1, 조회 + 수정 : 2

		if(!login_member.getMember_id().equals("admin"))
			return "nopermission";

		if(member_id == null || member_pw == null || member_auth == null)
			return "fail";

		Member member = new Member();
		member.setMember_id(member_id);
		member.setMember_pw(Encryption.sha256(member_pw));
		member.setMember_auth(member_auth);
		member.setCreate_date(new Timestamp(System.currentTimeMillis()));
		if(!member_service.insert_member(member))
			return "fail";

		return "success";
	}

	@RequestMapping("delete_member.do")
	@ResponseBody
	public String delete_member(
			@RequestBody Map<String, Object> request,
			HttpSession session)
	{
		Member login_member = (Member)session.getAttribute("login_member");
		Integer member_idx = (Integer)request.get("member_idx");

		if(member_idx == null)
			return "fail";

		if(!login_member.getMember_id().equals("admin"))
			return "nopermission";

		if(!member_service.delete_member(member_idx))
			return "fail";

		return "success";
	}
}
