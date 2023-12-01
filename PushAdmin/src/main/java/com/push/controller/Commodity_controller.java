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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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

import com.ddns.model.Commodity;
import com.intra.util.excel.CExcelDocBuild;
import com.push.model.Member;
import com.push.service.Commodity_service;

@Controller
public class Commodity_controller
{
	@Autowired
	private Commodity_service commodity_service;
	static Logger logger = LoggerFactory.getLogger(Commodity_controller.class);
	@RequestMapping("commodity_page.do")
	public String commodity_page(
			HttpServletRequest request,
			HttpSession session,
			Model model,
			@RequestParam(defaultValue = "commodity", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "code", value = "sort") String sort,
			@RequestParam(defaultValue = "desc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "0", value = "search_type") int search_type,
			@RequestParam(required = false, defaultValue = "", value = "search_word") String search_word)
	{
		Member login_member = (Member)session.getAttribute("login_member");
		if(login_member.getMember_auth() == 0)
		{
			String referer = request.getHeader("Referer");
			return "redirect:" + referer;
		}
		//logger.debug("TYPE : {} " , search_type);
		//logger.debug("commodity_search : {} " , search_word);
		List<Map<String, Object>> commodity_list = null;
		int total = 0;

		switch(type)
		{
		case "commodity_search":
			String search_word_sql = search_word;
			search_word_sql.trim();
			commodity_list = commodity_service.select_commodity_where_search_type(search_type, search_word_sql, 
					sort, direction, page);
			total = commodity_service.count_commodity_where_search_type(search_type, search_word_sql);
			model.addAttribute("search_type", search_type);
			model.addAttribute("search_word", search_word);
			break;
		case "commodity":
		default:
			commodity_list = commodity_service.select_commodity_all(sort, direction, page);
			total = commodity_service.count_commodity_all();
			break;
		}

		int last_page = 0;
		if(total % 10 == 0)
			last_page = total / 10;
		else
			last_page = total / 10 + 1;

		model.addAttribute("commodity_list", commodity_list);
		model.addAttribute("direction", direction);
		model.addAttribute("type", type);
		model.addAttribute("sort", sort);
		model.addAttribute("current_page", page);
		model.addAttribute("start_page", (page - 1) / 10 * 10 + 1);
		model.addAttribute("end_page", (page - 1) / 10 * 10 + 10);
		model.addAttribute("last_page", last_page);

		return "commodity";
	}

	@RequestMapping("commodity_excel.xlsx")
	public ModelAndView commodity_excel(
			@RequestParam(defaultValue = "commodity", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "code", value = "sort") String sort,
			@RequestParam(defaultValue = "desc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "0", value = "search_type_excel") int search_type_excel,
			@RequestParam(required = false, defaultValue = "", value = "search_word_excel") String search_word_excel)
	{
		ModelAndView mv = new ModelAndView();
		
		final String labels[] = {"No.", "코드", "SW 주장치 자동 등록"};
		final int columnWidth[] = {10, 30, 30};
		CExcelDocBuild excelBuilder = new CExcelDocBuild(labels, columnWidth , "Commodity");
		List<Map<String, Object>> commodity_list = null;
		String search_word_sql = "";
		long time = System.currentTimeMillis();
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyyMMddHHmmss");
		String str = dayTime.format(new Date(time));
		String fileName = str + ".xlsx";
		switch(type)
		{
		case "commodity_search_all":
			search_word_sql = search_word_excel;
			//commodity_list = commodity_service.select_commodity_where_search_type_excel(search_type_excel, search_word_sql, sort, direction);
			commodity_list = commodity_service.select_commodity_where_search_type_excel(search_type_excel, search_word_sql, sort, direction, -1);			
			break;
		case "commodity_search":
			search_word_sql = search_word_excel ;
			//commodity_list = commodity_service.select_commodity_where_search_type(search_type_excel, search_word_sql, sort, direction, page);
			commodity_list = commodity_service.select_commodity_where_search_type_excel(search_type_excel, search_word_sql, sort, direction,page);
			break;
		case "commodity_all":
			//commodity_list = commodity_service.select_commodity_all_excel(sort, direction);
			commodity_list = commodity_service.select_commodity_all_excel(sort, direction , -1);		
			break;
		case "commodity":
		default:
		//	commodity_list = commodity_service.select_commodity_all(sort, direction, page);
			commodity_list = commodity_service.select_commodity_all_excel(sort, direction, page);			
			break;
		}

		if(commodity_list != null) {
			excelBuilder.createNewSheet(0);
			excelBuilder.addRowList(commodity_list);
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

	@RequestMapping("delete_commodity.do")
	@ResponseBody
	public String delete_commodity(
			@RequestBody Map<String, Object> request,
			HttpSession session)
	{
		@SuppressWarnings("unchecked")
		ArrayList<String> code_list = (ArrayList<String>)request.get("code_list");
		Member login_member = (Member)session.getAttribute("login_member");
		
		if(code_list == null)
			return "fail";

		if(login_member.getMember_auth() != 2)
			return "nopermission";

		String codeListString = "";
		for(int i = 0; i < code_list.size(); i++)
		{
			if(i == 0)
				codeListString += ("'" + code_list.get(i) + "'");
			else
				codeListString += (", '" + code_list.get(i) + "'");
		}

		if(!commodity_service.delete_commodity(codeListString))
			return "deletefail";

		return "success";
	}

	@RequestMapping("add_commodity_page.do")
	public ModelAndView add_commodity_page()
	{
		ModelAndView mv = new ModelAndView();
		mv.setViewName("commodity_popup_add");
		return mv;
	}

	@RequestMapping("add_commodity.do")
	@ResponseBody
	public String add_commodity(
			@RequestBody Map<String, Object> request,
			HttpSession session)
	{
		Member login_member = (Member)session.getAttribute("login_member");
		String code = ((String)request.get("code")).toUpperCase();
		Integer auto_reg_swcontroller = (Integer)request.get("auto_reg_swcontroller");

		if(login_member.getMember_auth() != 2)
			return "nopermission";

		if(code == null || auto_reg_swcontroller == null)
			return "fail";

		if(code.length() < 1 || code.length() > 32)
			return "wrongcode";

		if(commodity_service.select_commodity_where_code(code) != null)
			return "exist";

		Commodity commodity = new Commodity();
		commodity.setCode(code);
		commodity.setAuto_reg_swcontroller(auto_reg_swcontroller);

		if(!commodity_service.insert_commodity(commodity))
			return "fail";

		return "success";
	}
}
