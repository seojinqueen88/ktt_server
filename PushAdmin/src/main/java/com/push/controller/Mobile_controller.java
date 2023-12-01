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
import com.push.service.Mobile_service;

@Controller
public class Mobile_controller
{
	@Autowired
	private Mobile_service mobile_service;

	@RequestMapping("mobile_page.do")
	public String mobile_page(
			HttpServletRequest request,
			HttpSession session,
			Model model,
			@RequestParam(defaultValue = "mobile", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "create_date", value = "sort") String sort,
			@RequestParam(defaultValue = "desc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "", value = "user_id") String user_id,
			@RequestParam(required = false, defaultValue = "1", value = "mobile_type") int mobile_type,
			@RequestParam(required = false, defaultValue = "20150101", value = "start_create_date") String start_create_date,
			@RequestParam(required = false, defaultValue = "20401231", value = "end_create_date") String end_create_date)
	{
		Member login_member = (Member)session.getAttribute("login_member");
		if(login_member.getMember_auth() == 0)
		{
			String referer = request.getHeader("Referer");
			return "redirect:" + referer;
		}

		List<Map<String, Object>> mobile_list = null;
		int total = 0;

		switch(type)
		{
		case "mobile_search_user_id":
			String user_id_sql = "%" + user_id + "%";
			mobile_list = mobile_service.select_mobile_where_user_id(user_id_sql, sort, direction, page);
			total = mobile_service.count_mobile_where_user_id(user_id_sql);
			model.addAttribute("user_id", user_id);
			break;
		case "mobile_search_mobile_type":
			mobile_list = mobile_service.select_mobile_where_mobile_type(mobile_type, sort, direction, page);
			total = mobile_service.count_mobile_where_mobile_type(mobile_type);
			model.addAttribute("mobile_type", mobile_type);
			break;
		case "mobile_search_create_date":
			mobile_list = mobile_service.select_mobile_where_create_date(start_create_date, end_create_date, sort, direction, page);
			total = mobile_service.count_mobile_where_create_date(start_create_date, end_create_date);
			model.addAttribute("start_create_date", start_create_date);
			model.addAttribute("end_create_date", end_create_date);
			break;
		case "mobile":
		default:
			mobile_list = mobile_service.select_mobile_all(sort, direction, page);
			total = mobile_service.count_mobile_all();
			break;
		}

		int last_page = 0;
		if(total % 10 == 0)
			last_page = total / 10;
		else
			last_page = total / 10 + 1;

		model.addAttribute("mobile_list", mobile_list);
		model.addAttribute("direction", direction);
		model.addAttribute("type", type);
		model.addAttribute("sort", sort);
		model.addAttribute("current_page", page);
		model.addAttribute("start_page", (page - 1) / 10 * 10 + 1);
		model.addAttribute("end_page", (page - 1) / 10 * 10 + 10);
		model.addAttribute("last_page", last_page);

		return "mobile";
	}

	@RequestMapping("mobile_excel.xlsx")
	public ModelAndView mobile_excel(
			@RequestParam(defaultValue = "mobile", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "create_date", value = "sort") String sort,
			@RequestParam(defaultValue = "desc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "", value = "user_id_excel") String user_id_excel,
			@RequestParam(required = false, defaultValue = "1", value = "mobile_type_excel") int mobile_type_excel,
			@RequestParam(required = false, defaultValue = "20150101", value = "start_create_date_excel") String start_create_date_excel,
			@RequestParam(required = false, defaultValue = "20401231", value = "end_create_date_excel") String end_create_date_excel)
	{
		ModelAndView mv = new ModelAndView();
		List<Map<String, Object>> mobile_list = null;
		String user_id_sql = "";
		 
		final String labels[] = {"No.", "토큰", "사용자 아이디", "모바일 종류",
				"언어", "앱 종류", "앱 버전", "등록한 장비 개수", "등록일"};
		final int columnWidth[] = {10, 80, 20, 15, 15, 20, 10, 10, 30};

		CExcelDocBuild excelBuilder = new CExcelDocBuild(labels, columnWidth , "Mobile");
		long time = System.currentTimeMillis();
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyyMMddHHmmss");
		String str = dayTime.format(new Date(time));
		String fileName = str + ".xlsx";
		switch(type)
		{
		case "mobile_search_user_id":
			user_id_sql = user_id_excel ;
			//mobile_list = mobile_service.select_mobile_where_user_id(user_id_sql, sort, direction, page);
			mobile_list = mobile_service.select_mobile_where_user_id_excel(user_id_sql, sort, direction,page);
			break;
		case "mobile_search_user_id_all":
			user_id_sql = user_id_excel;
			//mobile_list = mobile_service.select_mobile_where_user_id_excel(user_id_sql, sort, direction);
			mobile_list = mobile_service.select_mobile_where_user_id_excel(user_id_sql, sort, direction , -1);
			break;
		case "mobile_search_mobile_type":
			//mobile_list = mobile_service.select_mobile_where_mobile_type(mobile_type_excel, sort, direction, page);
			mobile_list = mobile_service.select_mobile_where_mobile_type_excel(mobile_type_excel, sort, direction,page);
			break;
		case "mobile_search_mobile_type_all":
			//mobile_list = mobile_service.select_mobile_where_mobile_type_excel(mobile_type_excel, sort, direction);
			mobile_list = mobile_service.select_mobile_where_mobile_type_excel(mobile_type_excel, sort, direction , -1);
			break;
		case "mobile_search_create_date":
			//mobile_list = mobile_service.select_mobile_where_create_date(start_create_date_excel, end_create_date_excel, sort, direction, page);
			mobile_list = mobile_service.select_mobile_where_create_date_excel(start_create_date_excel, end_create_date_excel, sort, direction,page);
			
			break;
		case "mobile_search_create_date_all":
			//mobile_list = mobile_service.select_mobile_where_create_date_excel(start_create_date_excel, end_create_date_excel, sort, direction);
			mobile_list = mobile_service.select_mobile_where_create_date_excel(start_create_date_excel, end_create_date_excel, sort, direction,-1);
			
			break;
		case "mobile_all":
			//mobile_list = mobile_service.select_mobile_all_excel(sort, direction);
			mobile_list = mobile_service.select_mobile_all_excel(sort, direction,-1);
			break;
		case "mobile":
		default:
			//mobile_list = mobile_service.select_mobile_all(sort, direction, page);
			mobile_list = mobile_service.select_mobile_all_excel(sort, direction,page);
			break;
		}

		if(mobile_list != null) {
			excelBuilder.createNewSheet(0);
			excelBuilder.addRowList(mobile_list);
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
		response.setHeader("Content-Disposition",
				"attachment; filename=\"" + fileName + "\";");

		// response.setContentType("application/octect-stream; charset=utf-8");
		response.setContentType(
				"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		// response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Pragma", "public");
		response.setHeader("Expires", "0");
		response.setHeader("Cache-Control",
				"no-cache, no-store, must-revalidate");
		response.setHeader("Set-Cookie", "fileDownload=true; path=/");
		mv.addObject("dataMap", excelBuilder);
		mv.setViewName("excelXlsx");

		return mv;
	}
}
