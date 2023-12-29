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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.intra.util.excel.CExcelDocBuild;
import com.push.service.Ddnslog_service;

@Controller
public class Ddnslog_controller
{
	@Autowired
	private Ddnslog_service ddnslog_service;

	@RequestMapping("ddnslog_page.do")
	public ModelAndView ddnslog_page(
			@RequestParam(defaultValue = "ddnslog", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "create_time", value = "sort") String sort,
			@RequestParam(defaultValue = "desc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "0", value = "search_type") int search_type,
			@RequestParam(required = false, defaultValue = "", value = "search_word") String search_word,
			@RequestParam(required = false, defaultValue = "20190101", value = "start_create_date") String start_create_date,
			@RequestParam(required = false, defaultValue = "20401231", value = "end_create_date") String end_create_date)
	{
		ModelAndView mv = new ModelAndView();

		List<Map<String, Object>> ddnslog_list = null;
		int total = 0;

		switch(type)
		{
		case "ddnslog_search":
			String search_word_sql = search_word.trim();
			ddnslog_list = ddnslog_service.select_ddnslog_where_search_type(search_type, search_word_sql, sort, direction, page);
			total = ddnslog_service.count_ddnslog_where_search_type(search_type, search_word_sql);
			mv.addObject("search_type", search_type);
			mv.addObject("search_word", search_word);
			break;
		case "ddnslog_search_create_date":
			ddnslog_list = ddnslog_service.select_ddnslog_where_create_date(start_create_date, end_create_date, sort, direction, page);
			total = ddnslog_service.count_ddnslog_where_create_date(start_create_date, end_create_date);
			mv.addObject("start_create_date", start_create_date);
			mv.addObject("end_create_date", end_create_date);
			break;
		case "ddnslog":
		default:
			ddnslog_list = ddnslog_service.select_ddnslog_all(sort, direction, page);
			total = ddnslog_service.count_ddnslog_all();
			break;
		}

		int last_page = 0;
		if(total % 10 == 0)
			last_page = total / 10;
		else
			last_page = total / 10 + 1;

		mv.setViewName("ddnslog");
		mv.addObject("ddnslog_list", ddnslog_list);
		mv.addObject("direction", direction);
		mv.addObject("type", type);
		mv.addObject("sort", sort);
		mv.addObject("current_page", page);
		mv.addObject("start_page", (page - 1) / 10 * 10 + 1);
		mv.addObject("end_page", (page - 1) / 10 * 10 + 10);
		mv.addObject("last_page", last_page);

		return mv;
	}

	@RequestMapping("ddnslog_excel.xlsx")
	public ModelAndView ddnslog_excel(
			@RequestParam(defaultValue = "ddnslog", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "create_time", value = "sort") String sort,
			@RequestParam(defaultValue = "desc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "0", value = "search_type_excel") int search_type_excel,
			@RequestParam(required = false, defaultValue = "", value = "search_word_excel") String search_word_excel,
			@RequestParam(required = false, defaultValue = "20190101", value = "start_create_date_excel") String start_create_date_excel,
			@RequestParam(required = false, defaultValue = "20401231", value = "end_create_date_excel") String end_create_date_excel)
	{
		ModelAndView mv = new ModelAndView();
		final String labels[] = {"No,", "맥 주소", "메시지", "시간"};
		final int columnWidth[] = {10, 30, 150, 30};
		
		CExcelDocBuild excelBuilder = new CExcelDocBuild(labels, columnWidth , "DDNS Log");
		List<Map<String, Object>> ddnslog_list = null;
		long time = System.currentTimeMillis();
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyyMMddHHmmss");
		String str = "[" + type + "]" + dayTime.format(new Date(time));
		String fileName = str + ".xlsx";
		String search_word_sql = "";
		try {
		switch(type)
		{
		case "ddnslog_search_create_date_all":
			ddnslog_list = ddnslog_service.select_ddnslog_where_create_date_excel(start_create_date_excel, end_create_date_excel,
					sort, direction);
			break;
		case "ddnslog_search_create_date":
			ddnslog_list = ddnslog_service.select_ddnslog_where_create_date(start_create_date_excel, end_create_date_excel,
					sort, direction, page);
			break;
		case "ddnslog_search_all":
			search_word_sql = search_word_excel;
			ddnslog_list = ddnslog_service.select_ddnslog_where_search_type_excel(search_type_excel, search_word_sql, sort, 
					direction);
			break;
		case "ddnslog_search":
			search_word_sql = search_word_excel;
			ddnslog_list = ddnslog_service.select_ddnslog_where_search_type(search_type_excel, search_word_sql, sort,
					direction, page);
			break;
		case "ddnslog_all":
			ddnslog_list = ddnslog_service.select_ddnslog_all_excel(sort, direction);
			break;
		case "ddnslog":
		default:
			ddnslog_list = ddnslog_service.select_ddnslog_all(sort, direction, page);
			break;
		}
		}catch(Exception e)
		{
		//	e.printStackTrace();
		}
		
		if(ddnslog_list != null) {
		//	System.out.println(" \n" + ddnslog_list.size());
			excelBuilder.createNewSheet(0);
			excelBuilder.addRowList(ddnslog_list);
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

		// response.setContentType("application/octect-stream; charset=utf-8");
		response.setHeader("Content-Disposition",
				"attachment; filename=\"" + fileName + "\";");

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
