package com.push.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.intra.util.excel.CExcelDocBuild;
import com.push.model.Member;
import com.push.model.Mobile;
import com.push.service.Mobile_service;
import com.push.service.Register_service;

@Controller
public class Register_controller
{
	@Autowired
	private Register_service register_service;

	@Autowired
	private Mobile_service mobile_service;

	@RequestMapping("register_page.do")
	public String register_page(
			HttpServletRequest request,
			HttpSession session,
			Model model,
			@RequestParam(defaultValue = "register", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "create_date", value = "sort") String sort,
			@RequestParam(defaultValue = "desc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "", value = "register_name") String register_name,
			@RequestParam(required = false, defaultValue = "", value = "register_mac") String register_mac,
			@RequestParam(required = false, defaultValue = "", value = "user_id") String user_id,
			@RequestParam(required = false, defaultValue = "1", value = "push_yn") int push_yn,
			@RequestParam(required = false, defaultValue = "20150101", value = "start_create_date") String start_create_date,
			@RequestParam(required = false, defaultValue = "20401231", value = "end_create_date") String end_create_date)
	{
		Member login_member = (Member)session.getAttribute("login_member");
		if(login_member.getMember_auth() == 0)
		{
			String referer = request.getHeader("Referer");
			return "redirect:" + referer;
		}

		List<Map<String, Object>> register_list = null;
		int total = 0;
		try {
		switch(type)
		{
		case "register_search_register_name":
			String register_name_sql = "%" + register_name + "%";
			register_list = register_service.select_register_where_register_name(register_name_sql, sort, direction, page);
			total = register_service.count_register_where_register_name(register_name_sql);
			model.addAttribute("register_name", register_name);
			break;
		case "register_search_register_mac":
			String register_mac_sql = "%" + register_mac.toUpperCase() + "%";
			register_list = register_service.select_register_where_register_mac(register_mac_sql, sort, direction, page);
			total = register_service.count_register_where_register_mac(register_mac_sql);
			model.addAttribute("register_mac", register_mac);
			break;
		case "register_search_user_id":
			String user_id_sql = "%" + user_id + "%";
			register_list = register_service.select_register_where_user_id(user_id_sql, sort, direction, page);
			total = register_service.count_register_where_user_id(user_id_sql);
			model.addAttribute("user_id", user_id);
			break;
		case "register_search_push_yn":
			register_list = register_service.select_register_where_push_yn(push_yn, sort, direction, page);
			total = register_service.count_register_where_push_yn(push_yn);
			model.addAttribute("push_yn", push_yn);
			break;
		case "register_search_create_date":
			register_list = register_service.select_register_where_create_date(start_create_date, end_create_date, sort, direction, page);
			total = register_service.count_register_where_create_date(start_create_date, end_create_date);
			model.addAttribute("start_create_date", start_create_date);
			model.addAttribute("end_create_date", end_create_date);
			break;
		case "register":
		default:
			register_list = register_service.select_register_all(sort, direction, page);
			total = register_service.count_register_all();
			break;
		}

		int last_page = 0;
		if(total % 10 == 0)
			last_page = total / 10;
		else
			last_page = total / 10 + 1;

		model.addAttribute("register_list", register_list);
		model.addAttribute("direction", direction);
		model.addAttribute("type", type);
		model.addAttribute("sort", sort);
		model.addAttribute("current_page", page);
		model.addAttribute("start_page", (page - 1) / 10 * 10 + 1);
		model.addAttribute("end_page", (page - 1) / 10 * 10 + 10);
		model.addAttribute("last_page", last_page);
		return "register";
		}catch(Exception err ){
			String referer = request.getHeader("Referer");
			return "redirect:" + referer;
		}
		//return "register";
	}

	@RequestMapping("register_excel.xlsx")
	public ModelAndView regitser_excel(
			@RequestParam(defaultValue = "register", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "create_date", value = "sort") String sort,
			@RequestParam(defaultValue = "desc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "", value = "register_name_excel") String register_name_excel,
			@RequestParam(required = false, defaultValue = "", value = "register_mac_excel") String register_mac_excel,
			@RequestParam(required = false, defaultValue = "", value = "user_id_excel") String user_id_excel,
			@RequestParam(required = false, defaultValue = "1", value = "push_yn_excel") int push_yn_excel,
			@RequestParam(required = false, defaultValue = "20150101", value = "start_create_date_excel") String start_create_date_excel,
			@RequestParam(required = false, defaultValue = "20401231", value = "end_create_date_excel") String end_create_date_excel)
	{
		ModelAndView mv = new ModelAndView();
		List<Map<String, Object>> register_list = null;
		String register_name_sql = "";
		String register_mac_sql = "";
		String user_id_sql = "";
		final String labels[] = {"No.", "장비 이름", "맥 주소", "사용자 아이디", "푸시 수신여부", "수정일", "등록일"};
		final int columnWidth[] = {10, 30, 30, 20, 15, 30, 30};
		long time = System.currentTimeMillis();
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyyMMddHHmmss");
		String str = "[" + type + "]" + dayTime.format(new Date(time));
		String fileName = str + ".xlsx";
		CExcelDocBuild excelBuilder = new CExcelDocBuild(labels, columnWidth , "Register");
		switch(type)
		{

		case "register_search_register_name":
			register_name_sql = register_name_excel ;
			register_list = register_service.select_register_where_register_name_excel(register_name_sql, sort, direction, page);
			break;
		case "register_search_register_name_all":
			register_name_sql = register_name_excel;
			register_list = register_service.select_register_where_register_name_excel(register_name_sql, sort, direction,-1);
			break;
		case "register_search_register_mac":
			register_mac_sql = register_mac_excel ;
			register_list = register_service.select_register_where_register_mac_excel(register_mac_sql, sort, direction, page);
			break;
		case "register_search_register_mac_all":
			register_mac_sql = register_mac_excel;
			register_list = register_service.select_register_where_register_mac_excel(register_mac_sql, sort, direction , -1);
			break;
		case "register_search_user_id":
			user_id_sql = user_id_excel;
			register_list = register_service.select_register_where_user_id_excel(user_id_sql, sort, direction, page);
			break;
		case "register_search_user_id_all":
			user_id_sql = user_id_excel;
			register_list = register_service.select_register_where_user_id_excel(user_id_sql, sort, direction, -1);
			break;
		case "register_search_push_yn":
			register_list = register_service.select_register_where_push_yn_excel(push_yn_excel, sort, direction, page);
			break;
		case "register_search_push_yn_all":
			register_list = register_service.select_register_where_push_yn_excel(push_yn_excel, sort, direction,-1);
			break;
		case "register_search_create_date":
			register_list = register_service.select_register_where_create_date_excel(start_create_date_excel, end_create_date_excel, sort, direction, page);
			break;
		case "register_search_create_date_all":
			register_list = register_service.select_register_where_create_date_excel(start_create_date_excel, end_create_date_excel, sort, direction,-1);
			break;
		case "register_all":
			register_list = register_service.select_register_all_excel(sort, direction,-1);
			break;
		case "register":
		default:
			register_list = register_service.select_register_all_excel(sort, direction, page);
			break;
		}
		RequestAttributes requestAttributes = RequestContextHolder
				.getRequestAttributes();
		HttpServletRequest httpServletRequest = ((ServletRequestAttributes) requestAttributes)
				.getRequest();
		HttpServletResponse httpServelResponse = ((ServletRequestAttributes) requestAttributes)
				.getResponse();
		HttpServletResponse response = httpServelResponse;
		// response.setContentType(getContentType());
		response.setBufferSize(512 * 1024);

		excelBuilder.setExcelFileName(str);
		String userAgent = httpServletRequest.getHeader("User-Agent");
		// logger.debug(excelBuilder.getExcelFileName().toString());
		try {
			if (userAgent.indexOf("MSIE") > -1) {

				fileName = URLEncoder.encode(fileName, "utf-8");

			} else {

				fileName = new String(fileName.getBytes("utf-8"), "iso-8859-1");

			}
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
			//logger.debug(e.getLocalizedMessage());
		}

		if(register_list != null && register_list.size() > 0) {
			
			excelBuilder.createNewSheet(0);
			excelBuilder.addRowList(register_list);
		}
		// response.setContentType("application/octect-stream; charset=utf-8");
		response.setContentType(
				"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		// response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Pragma", "public");
		response.setHeader("Expires", "0");
		response.setHeader("Cache-Control",
				"no-cache, no-store, must-revalidate");
		response.setHeader("Set-Cookie", "fileDownload=true; path=/");
		response.setHeader("Content-Disposition",
				"attachment; filename=\"" + fileName + "\";");

	
		mv.addObject("dataMap", excelBuilder);
		mv.setViewName("excelXlsx");


		return mv;
	}


	@RequestMapping("detail_register_page.do")
	public ModelAndView detail_register_page(
			@RequestParam(required = false, defaultValue = "", value = "register_mac") String register_mac,
			@RequestParam(defaultValue = "0", value = "mobile_idx") int mobile_idx)
	{
		ModelAndView mv = new ModelAndView();
		Map<String, Object> register = register_service.select_users_where_register_mac(register_mac);
		Mobile mobile = mobile_service.select_mobile_where_mobile_idx(mobile_idx);

		mv.setViewName("register_popup_detail");
		mv.addObject("register", register);
		mv.addObject("mobile", mobile);
		return mv;
	}
}
