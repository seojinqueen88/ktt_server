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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.intra.util.excel.CExcelDocBuild;
import com.push.service.Service_service;

@Controller
public class Service_controller
{
	@Autowired
	private Service_service service_service;

	@RequestMapping("service_page.do")
	public ModelAndView service_page(
			@RequestParam(defaultValue = "service", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "update_time", value = "sort") String sort,
			@RequestParam(defaultValue = "desc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "0", value = "search_type") int search_type,
			@RequestParam(required = false, defaultValue = "", value = "search_word") String search_word)
	{
		ModelAndView mv = new ModelAndView();

		List<Map<String, Object>> service_list = null;
		int total = 0;
	 
		switch(type)
		{
		case "service_search":
			String search_word_sql = "%" + search_word.trim() + "%";
			service_list = service_service.select_service_where_search_type(search_type, search_word_sql, sort, direction, page);
			total = service_service.count_service_where_search_type(search_type, search_word_sql);
			mv.addObject("search_type", search_type);
			mv.addObject("search_word", search_word);
			break;
		case "service":
		default:
			service_list = service_service.select_service_all(sort, direction, page);
			total = service_service.count_service_all();
			break;
		}

		int last_page = 0;
		if(total % 10 == 0)
			last_page = total / 10;
		else
			last_page = total / 10 + 1;
		
		
		mv.setViewName("service");
		mv.addObject("service_list", service_list);
		mv.addObject("direction", direction);
		mv.addObject("type", type);
		mv.addObject("sort", sort);
		mv.addObject("current_page", page);
		mv.addObject("start_page", (page - 1) / 10 * 10 + 1);
		mv.addObject("end_page", (page - 1) / 10 * 10 + 10);
		mv.addObject("last_page", last_page);
		
		return mv;
	}

	@RequestMapping("service_excel.xlsx")
	public ModelAndView service_excel(
			@RequestParam(defaultValue = "service", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "update_time", value = "sort") String sort,
			@RequestParam(defaultValue = "desc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "0", value = "search_type_excel") int search_type_excel,
			@RequestParam(required = false, defaultValue = "", value = "search_word_excel") String search_word_excel)
	{
		ModelAndView mv = new ModelAndView();
		int offset = 0;
		final String labels[] = {"No.","서비스 번호", "고객 번호", "계약 번호", "상호명", "관리 본부", "관리 지사", "시스템 아이디", "고객 상태", "서비스 소", "갱신 시간"};
		final int columnWidth[] = {10,15, 15, 15, 70, 15, 15, 20, 15, 15, 30};

		CExcelDocBuild excelBuilder = new CExcelDocBuild(labels, columnWidth , "Service");
		List<Map<String, Object>> service_list = null;
		String search_word_sql = "";
		long time = System.currentTimeMillis();
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyyMMddHHmmss");
		String str = dayTime.format(new Date(time));
		String fileName = str + ".xlsx";
		excelBuilder.createNewSheet(0);
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
		switch(type)
		{
		case "service_search_all":
			search_word_sql = search_word_excel.trim(); 
			//service_list = service_service.select_service_where_search_type_excel(search_type_excel, 
			//		search_word_sql, sort, direction ,-1);
			while ((service_list = service_service.select_service_where_search_type_excel
					(search_type_excel, 
							search_word_sql, sort, direction ,-1 , offset)) != null &&
									service_list.size() > 0) {
                offset += 100000;
                excelBuilder.addRowList(service_list);
              }
			break;
		case "service_search":
			search_word_sql = search_word_excel.trim() ;
			service_list = service_service.select_service_where_search_type_excel
					(search_type_excel, search_word_sql, sort, direction, page , -1);
			if(service_list != null && service_list.size() > 0) {
				//excelBuilder.createNewSheet(0);
				excelBuilder.addRowList(service_list);
			}
			break;
		case "service_all":
			//service_list = service_service.select_service_all_excel(sort, direction,-1);
				while ((service_list = service_service.select_service_all_excel(
								  sort, direction, -1, offset)) != null
						&& service_list.size() > 0) {
					offset += 100000;
					excelBuilder.addRowList(service_list);
				}
			break;
		case "service":
		default:
			service_list = service_service.select_service_all_excel(sort, direction, page , -1);
			if(service_list != null && service_list.size() > 0) {
				//excelBuilder.createNewSheet(0);
				excelBuilder.addRowList(service_list);
			}
			break;
		}
 		
		mv.addObject("dataMap", excelBuilder);
		mv.setViewName("excelXlsx");
		return mv;
	}
}
