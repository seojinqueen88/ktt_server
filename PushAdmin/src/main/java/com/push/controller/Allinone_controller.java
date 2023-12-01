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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.intra.util.excel.CExcelDocBuild;
import com.push.model.Member;
import com.push.service.Allinone_service;

@Controller
public class Allinone_controller {
	@Autowired
	private Allinone_service allinone_service;

	@RequestMapping("allinone_page.do")
	public String allinone_page(HttpServletRequest request, HttpSession session,
			Model model,
			@RequestParam(defaultValue = "allinone", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "create_date", value = "sort") String sort,
			@RequestParam(defaultValue = "desc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "", value = "server_id") String server_id,
			@RequestParam(required = false, defaultValue = "", value = "user_id") String user_id,
			@RequestParam(required = false, defaultValue = "1", value = "mobile_type") int mobile_type,
			@RequestParam(required = false, defaultValue = "20190101", value = "start_create_date") String start_create_date,
			@RequestParam(required = false, defaultValue = "20401231", value = "end_create_date") String end_create_date) {
		Member login_member = (Member) session.getAttribute("login_member");
		if (login_member.getMember_auth() == 0) {
			String referer = request.getHeader("Referer");
			return "redirect:" + referer;
		}

		List<Map<String, Object>> allinone_list = null;
		int total = 0;

		switch (type) {
			case "allinone_search_server_id" :
				String server_id_sql = "%" + server_id + "%";
				allinone_list = allinone_service
						.select_allinone_where_server_id(server_id_sql, sort,
								direction, page);
				total = allinone_service
						.count_allinone_where_server_id(server_id_sql);
				model.addAttribute("server_id", server_id);
				break;
			case "allinone_search_user_id" :
				String user_id_sql = "%" + user_id + "%";
				allinone_list = allinone_service.select_allinone_where_user_id(
						user_id_sql, sort, direction, page);
				total = allinone_service
						.count_allinone_where_user_id(user_id_sql);
				model.addAttribute("user_id", user_id);
				break;
			case "allinone_search_mobile_type" :
				allinone_list = allinone_service
						.select_allinone_where_mobile_type(mobile_type, sort,
								direction, page);
				total = allinone_service
						.count_allinone_where_mobile_type(mobile_type);
				model.addAttribute("mobile_type", mobile_type);
				break;
			case "allinone_search_create_date" :
				allinone_list = allinone_service
						.select_allinone_where_create_date(start_create_date,
								end_create_date, sort, direction, page);
				total = allinone_service.count_allinone_where_create_date(
						start_create_date, end_create_date);
				model.addAttribute("start_create_date", start_create_date);
				model.addAttribute("end_create_date", end_create_date);
				break;
			case "allinone" :
			default :
				allinone_list = allinone_service.select_allinone_all(sort,
						direction, page);
				total = allinone_service.count_allinone_all();
				break;
		}

		int last_page = 0;
		if (total % 10 == 0)
			last_page = total / 10;
		else
			last_page = total / 10 + 1;

		model.addAttribute("allinone_list", allinone_list);
		model.addAttribute("direction", direction);
		model.addAttribute("type", type);
		model.addAttribute("sort", sort);
		model.addAttribute("current_page", page);
		model.addAttribute("start_page", (page - 1) / 10 * 10 + 1);
		model.addAttribute("end_page", (page - 1) / 10 * 10 + 10);
		model.addAttribute("last_page", last_page);

		return "allinone";
	}

	@RequestMapping("allinone_excel.xlsx")
	public ModelAndView allinone_excel(
			@RequestParam(defaultValue = "allinone", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "create_date", value = "sort") String sort,
			@RequestParam(defaultValue = "desc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "", value = "server_id_excel") String server_id_excel,
			@RequestParam(required = false, defaultValue = "", value = "user_id_excel") String user_id_excel,
			@RequestParam(required = false, defaultValue = "1", value = "mobile_type_excel") int mobile_type_excel,
			@RequestParam(required = false, defaultValue = "20190101", value = "start_create_date_excel") String start_create_date_excel,
			@RequestParam(required = false, defaultValue = "20401231", value = "end_create_date_excel") String end_create_date_excel) {
		ModelAndView mv = new ModelAndView();

		final String labels[] = {"No.", "서버 아이디", "사용자 아이디", "토큰", "앱 버전",
				"모바일 종류", "앱 종류", "등록일"};
		final int columnWidth[] = {10, 20, 20, 80, 10, 15, 20, 30};

		CExcelDocBuild excelBuilder = new CExcelDocBuild(labels, columnWidth,
				"Allinone");
		List<Map<String, Object>> allinone_list = null;
		String server_id_sql = "";
		String user_id_sql = "";
		long time = System.currentTimeMillis();
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyyMMddHHmmss");
		String str = dayTime.format(new Date(time));
		String fileName = str + ".xlsx";

		switch (type) {
			case "allinone_search_server_id" :
				server_id_sql = server_id_excel;
				// allinone_list =
				// allinone_service.select_allinone_where_server_id(server_id_sql,
				// sort, direction, page);
				allinone_list = allinone_service
						.select_allinone_where_server_id_excel(server_id_sql,
								sort, direction, page);
				break;
			case "allinone_search_server_id_all" :
				server_id_sql = server_id_excel;
				// allinone_list =
				// allinone_service.select_allinone_where_server_id_excel(server_id_sql,
				// sort, direction);
				allinone_list = allinone_service
						.select_allinone_where_server_id_excel(server_id_sql,
								sort, direction, -1);
				break;
			case "allinone_search_user_id" :
				user_id_sql = user_id_excel;
				// allinone_list =
				// allinone_service.select_allinone_where_user_id(user_id_sql,
				// sort, direction, page);
				allinone_list = allinone_service
						.select_allinone_where_user_id_excel(user_id_sql, sort,
								direction, page);
				break;
			case "allinone_search_user_id_all" :
				user_id_sql = user_id_excel;
				// allinone_list =
				// allinone_service.select_allinone_where_user_id_excel(user_id_sql,
				// sort, direction);
				allinone_list = allinone_service
						.select_allinone_where_user_id_excel(user_id_sql, sort,
								direction, -1);
				break;
			case "allinone_search_mobile_type" :
				// allinone_list =
				// allinone_service.select_allinone_where_mobile_type(mobile_type_excel,
				// sort, direction, page);
				allinone_list = allinone_service
						.select_allinone_where_mobile_type_excel(
								mobile_type_excel, sort, direction, page);
				break;
			case "allinone_search_mobile_type_all" :
				// allinone_list =
				// allinone_service.select_allinone_where_mobile_type_excel(mobile_type_excel,
				// sort, direction);
				allinone_list = allinone_service
						.select_allinone_where_mobile_type_excel(
								mobile_type_excel, sort, direction, -1);
				break;
			case "allinone_search_create_date" :
				// allinone_list =
				// allinone_service.select_allinone_where_create_date(start_create_date_excel,
				// end_create_date_excel, sort, direction, page);
				allinone_list = allinone_service
						.select_allinone_where_create_date_excel(
								start_create_date_excel, end_create_date_excel,
								sort, direction, page);
				break;
			case "allinone_search_create_date_all" :
				allinone_list = allinone_service
						.select_allinone_where_create_date_excel(
								start_create_date_excel, end_create_date_excel,
								sort, direction, -1);
				// allinone_list =
				// allinone_service.select_allinone_where_create_date_excel(start_create_date_excel,
				// end_create_date_excel, sort, direction);
				break;
			case "allinone_all" :
				// allinone_list =
				// allinone_service.select_allinone_all_excel(sort, direction);
				allinone_list = allinone_service.select_allinone_all_excel(sort,
						direction, -1);
				break;
			case "allinone" :
			default :
				allinone_list = allinone_service.select_allinone_all_excel(sort,
						direction, page);
				// allinone_list = allinone_service.select_allinone_all(sort,
				// direction, page);
				break;
		}

		if (allinone_list != null) {
			excelBuilder.createNewSheet(0);
			excelBuilder.addRowList(allinone_list);
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

	@RequestMapping("delete_allinone.do")
	@ResponseBody
	public String delete_allinone(@RequestBody Map<String, Object> request,
			HttpSession session) {
		Member login_member = (Member) session.getAttribute("login_member");
		String server_id = (String) request.get("server_id");
		String user_id = (String) request.get("user_id");

		if (server_id == null || user_id == null)
			return "fail";

		if (login_member.getMember_auth() != 2)
			return "nopermission";

		if (!allinone_service.delete_allinone(server_id, user_id))
			return "fail";

		return "success";
	}
}
