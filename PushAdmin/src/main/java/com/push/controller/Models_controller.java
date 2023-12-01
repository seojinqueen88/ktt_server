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
import com.push.service.Models_service;

@Controller
public class Models_controller
{
	@Autowired
	private Models_service models_service;

	@RequestMapping("models_page.do")
	public String models_page(
			HttpServletRequest request,
			HttpSession session,
			Model model,
			@RequestParam(defaultValue = "models", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "model", value = "sort") String sort,
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

		List<Map<String, Object>> models_list = null;
		int total = 0;

		switch(type)
		{
		case "models_search":
			String search_word_sql = search_word;
			models_list = models_service.select_models_where_search_type(search_type, search_word_sql, sort, direction, page);
			total = models_service.count_models_where_search_type(search_type, search_word_sql);
			model.addAttribute("search_type", search_type);
			model.addAttribute("search_word", search_word);
			break;
		case "models":
		default:
			models_list = models_service.select_models_all(sort, direction, page);
			total = models_service.count_models_all();
			break;
		}

		int last_page = 0;
		if(total % 10 == 0)
			last_page = total / 10;
		else
			last_page = total / 10 + 1;

		model.addAttribute("models_list", models_list);
		model.addAttribute("direction", direction);
		model.addAttribute("type", type);
		model.addAttribute("sort", sort);
		model.addAttribute("current_page", page);
		model.addAttribute("start_page", (page - 1) / 10 * 10 + 1);
		model.addAttribute("end_page", (page - 1) / 10 * 10 + 10);
		model.addAttribute("last_page", last_page);

		return "models";
	}

	@RequestMapping("models_excel.xlsx")
	public ModelAndView models_excel(
			@RequestParam(defaultValue = "models", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "model", value = "sort") String sort,
			@RequestParam(defaultValue = "desc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "0", value = "search_type_excel") int search_type_excel,
			@RequestParam(required = false, defaultValue = "", value = "search_word_excel") String search_word_excel)
	{
		ModelAndView mv = new ModelAndView();
		
		final String labels[] = {"No." , "모델", "FW 버전", "OTP 지원 버전"};
		final int columnWidth[] = {10, 20, 20 ,20};
		CExcelDocBuild excelBuilder = new CExcelDocBuild(labels, columnWidth , "Model");
		List<Map<String, Object>> models_list = null;
		String search_word_sql = "";
		long time = System.currentTimeMillis();
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyyMMddHHmmss");
		String str = dayTime.format(new Date(time));
		String fileName = str + ".xlsx";
		switch(type)
		{
		case "models_search_all":
			search_word_sql = search_word_excel;
			models_list = models_service.select_models_where_search_type_excel(search_type_excel, search_word_sql, sort, direction , -1);
			break;
		case "models_search":
			search_word_sql = search_word_excel;
			models_list = models_service.select_models_where_search_type_excel(search_type_excel, search_word_sql, sort, direction, page);
			break;
		case "models_all":
			models_list = models_service.select_models_all_excel(sort, direction , -1);
			break;
		case "models":
		default:
			models_list = models_service.select_models_all_excel(sort, direction, page);
			break;
		}

	 
		if(models_list != null) {
			excelBuilder.createNewSheet(0);
			excelBuilder.addRowList(models_list);
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

	@RequestMapping("delete_models.do")
	@ResponseBody
	public String delete_models(
			@RequestBody Map<String, Object> request,
			HttpSession session)
	{
		@SuppressWarnings("unchecked")
		ArrayList<String> model_list = (ArrayList<String>)request.get("model_list");
		Member login_member = (Member)session.getAttribute("login_member");
		
		if(model_list == null)
			return "fail";

		if(login_member.getMember_auth() != 2)
			return "nopermission";

		String modelListString = "";
		for(int i = 0; i < model_list.size(); i++)
		{
			if(i == 0)
				modelListString += ("'" + model_list.get(i) + "'");
			else
				modelListString += (", '" + model_list.get(i) + "'");
		}

		if(!models_service.delete_models(modelListString))
			return "deletefail";

		return "success";
	}

	@RequestMapping("add_models_page.do")
	public ModelAndView add_models_page()
	{
		ModelAndView mv = new ModelAndView();
		mv.setViewName("models_popup_add");
		return mv;
	}

	@RequestMapping("add_models.do")
	@ResponseBody
	public String add_models(
			@RequestBody Map<String, Object> request,
			HttpSession session)
	{
		Member login_member = (Member)session.getAttribute("login_member");
		String model = (String)request.get("model");

		if(login_member.getMember_auth() != 2)
			return "nopermission";

		if(model == null)
			return "fail";

		if(model.length() < 1 || model.length() > 32)
			return "wrongmodel";

		if(models_service.select_models_where_model(model) != null)
			return "exist";

		if(!models_service.insert_models(model))
			return "fail";

		return "success";
	}
}
