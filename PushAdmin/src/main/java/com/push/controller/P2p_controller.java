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
import com.push.service.P2p_service;
import com.push.util.Encryption;

@Controller
public class P2p_controller
{
	@Autowired
	private P2p_service p2p_service;

	@RequestMapping("p2p_page.do")
	public String p2p_page(
			HttpServletRequest request,
			HttpSession session,
			Model model,
			@RequestParam(defaultValue = "p2p", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "p2p_uid", value = "sort") String sort,
			@RequestParam(defaultValue = "asc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "", value = "mac") String mac,
			@RequestParam(required = false, defaultValue = "", value = "p2p_uid") String p2p_uid)
	{
		Member login_member = (Member)session.getAttribute("login_member");
		if(login_member.getMember_auth() == 0)
		{
			String referer = request.getHeader("Referer");
			return "redirect:" + referer;
		}

		List<Map<String, Object>> p2p_list = null;
		int total = 0;
		 
		switch(type)
		{
		case "p2p_search_mac":
			String mac_sql =  mac ;
			p2p_list = p2p_service.select_p2preserved_where_mac(mac_sql.trim().toUpperCase(), sort, direction, page);
			total = p2p_service.count_p2preserved_where_mac(mac_sql);
			model.addAttribute("mac", mac);
			model.addAttribute("p2p_uid", "");
			break;
		case "p2p_search_p2p_uid":
			String p2p_uid_sql = p2p_uid;
			p2p_list = p2p_service.select_p2preserved_where_p2p_uid_search(p2p_uid_sql.trim() , sort, direction, page);
			total = p2p_service.count_p2preserved_where_p2p_uid(p2p_uid_sql);
			model.addAttribute("mac", "");
			model.addAttribute("p2p_uid", p2p_uid);
			break;
		case "p2p":
		default:
			p2p_list = p2p_service.select_p2preserved_all(sort, direction, page);
			total = p2p_service.count_p2preserved_all();
			model.addAttribute("mac", "");
			model.addAttribute("p2p_uid", "");
			break;
		}

		int last_page = 0;
		if(total % 10 == 0)
			last_page = total / 10;
		else
			last_page = total / 10 + 1;

		model.addAttribute("p2p_list", p2p_list);
		model.addAttribute("direction", direction);
		model.addAttribute("type", type);
		model.addAttribute("sort", sort);
		model.addAttribute("current_page", page);
		model.addAttribute("start_page", (page - 1) / 10 * 10 + 1);
		model.addAttribute("end_page", (page - 1) / 10 * 10 + 10);
		model.addAttribute("last_page", last_page);

		return "p2p";
	}

	@RequestMapping("p2p_excel.xlsx")
	public ModelAndView p2pregister_excel(
			@RequestParam(defaultValue = "p2p", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "used", value = "sort") String sort,
			@RequestParam(defaultValue = "asc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "", value = "mac_excel") String mac_excel,
			@RequestParam(required = false, defaultValue = "", value = "p2p_uid_excel") String p2p_uid_excel)
	{
		ModelAndView mv = new ModelAndView();
		
		final String labels[] = {"No.", "맥 주소", "P2P UID", "접속 우선 순위", "사용 여부" ,"마지막 사용 시간"};
		final int columnWidth[] = {10 ,20, 30, 20, 20, 40};
		CExcelDocBuild excelBuilder = new CExcelDocBuild(labels, columnWidth , "P2P");
		long time = System.currentTimeMillis();
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyyMMddHHmmss");
		String str = "[" + type + "]" + dayTime.format(new Date(time));
		String fileName = str + ".xlsx";
		List<Map<String, Object>> p2p_list = null;
		String mac_sql = "";
		String p2p_uid_sql = "";
		excelBuilder.createNewSheet(0);
		switch(type)
		{
		case "p2p_search_mac":
			mac_sql = mac_excel.trim().toUpperCase();
			p2p_list = p2p_service.select_p2preserved_where_mac_excel(mac_sql, sort, direction, page);
			break;
		case "p2p_search_mac_all":
			mac_sql = mac_excel.trim().toUpperCase();
			p2p_list = p2p_service.select_p2preserved_where_mac_excel(mac_sql, sort, direction , -1);
			break;
		case "p2p_search_p2p_uid":
			p2p_uid_sql =  p2p_uid_excel;
			p2p_list = p2p_service.select_p2preserved_where_p2p_uid_excel(p2p_uid_sql, sort, direction, page);
			break;
		case "p2p_search_p2p_uid_all":
			p2p_uid_sql = p2p_uid_excel;
			p2p_list = p2p_service.select_p2preserved_where_p2p_uid_excel(p2p_uid_sql, sort, direction , -1);
			break;
		case "p2p_all":
			p2p_list = p2p_service.select_p2preserved_all_excel(sort, direction, -1);
			break;
		case "p2p":
		default:
			p2p_list = p2p_service.select_p2preserved_all_excel(sort, direction, page);
			break;
		}

		if(p2p_list != null && p2p_list.size() > 0) {
		
			excelBuilder.addRowList(p2p_list);
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

	@RequestMapping("add_p2p_page.do")
	public ModelAndView add_p2p_page()
	{
		ModelAndView mv = new ModelAndView();
		String p2p_uid = p2p_service.select_p2preserved_where_used_0();

		if(p2p_uid == null)
			mv.addObject("all_used", 1);
		else
			mv.addObject("all_used", 0);

		mv.setViewName("p2p_popup_add_p2p");
		return mv;
	}

	@RequestMapping(value = {"add_p2p.do", "add_p2p_ddns_serviceno.do"})
	@ResponseBody
	public String add_p2p(@RequestBody Map<String, Object> request)
	{
		String mac = ((String)request.get("mac")).toUpperCase();
		Integer p2p_priority = (Integer)request.get("p2p_priority");

		if(mac == null || p2p_priority == null)
			return "fail";

		String apiMac = Encryption.remakeMac(mac, false);
		if(apiMac.length() != 12)
			return "fail";
		String ddnsMac = Encryption.remakeMac(mac, true);

		String prev_p2p_uid = p2p_service.select_users_p2puid_where_mac(ddnsMac);
		if(prev_p2p_uid == null)
			return "nodevice";
		if(prev_p2p_uid.length() > 0)
			return "exist";

		String p2p_uid = "";
		p2p_uid = p2p_service.select_p2preserved_where_historymac(ddnsMac);
		if(p2p_uid == null || p2p_uid.length() == 0)
		{
			p2p_uid = p2p_service.select_p2preserved_where_used_0();
			if(p2p_uid == null || p2p_uid.length() == 0)
				return "nop2puid";
		}

		if(!p2p_service.update_users_p2p_insert(ddnsMac, p2p_uid, p2p_priority))
			return "fail";

		if(!p2p_service.update_p2preserved_used_where_p2puid(p2p_uid, ddnsMac))
		{
			p2p_service.update_users_p2p_delete(ddnsMac);
			return "fail";
		}

		return "success";
	}

	@RequestMapping("delete_p2p.do")
	@ResponseBody
	public String delete_p2p(
			@RequestBody Map<String, Object> request,
			HttpSession session)
	{
		Member login_member = (Member)session.getAttribute("login_member");
		@SuppressWarnings("unchecked")
		ArrayList<String> mac_list = (ArrayList<String>)request.get("mac_list");

		if(login_member.getMember_auth() != 2)
			return "nopermission";

		if(mac_list == null || mac_list.size() == 0)
			return "fail";

		String mac_list_string = "";
		for(int i = 0; i < mac_list.size(); i++)
		{
			if(i == 0)
				mac_list_string += ("'" + mac_list.get(i) + "'");
			else
				mac_list_string += (", '" + mac_list.get(i) + "'");
		}

		ArrayList<String> p2puid_list = p2p_service.select_users_p2puid_where_in_mac(mac_list_string);
		if(p2puid_list == null || p2puid_list.size() == 0)
			return "fail";

		if(!p2p_service.update_users_p2p_delete_where_in_mac(mac_list_string))
			return "deletefail";

		String p2puid_list_string = "";
		for(int i = 0; i < p2puid_list.size(); i++)
		{
			if(i == 0)
				p2puid_list_string += ("'" + p2puid_list.get(i) + "'");
			else
				p2puid_list_string += (", '" + p2puid_list.get(i) + "'");
		}

		if(!p2p_service.update_p2preserved_unused_where_in_p2puid(p2puid_list_string))
			return "unusedfail";

		return "success";
	}






	@RequestMapping("add_p2preserved_page.do")
	public String add_p2preserved_page()
	{
		return "p2p_popup_add_p2preserved";
	}

	@RequestMapping("add_p2preserved.do")
	@ResponseBody
	public String add_app(
			@RequestBody Map<String, Object> request,
			HttpSession session)
	{
		Member login_member = (Member)session.getAttribute("login_member");
		String start_p2p_uid = ((String)request.get("start_p2p_uid")).toUpperCase();
		String end_p2p_uid = ((String)request.get("end_p2p_uid")).toUpperCase();

		if(login_member.getMember_auth() != 2)
			return "nopermission";

		if(start_p2p_uid == null && end_p2p_uid == null)
			return "fail";

		if(start_p2p_uid == null)
			start_p2p_uid = new String(end_p2p_uid);
		else if(end_p2p_uid == null)
			end_p2p_uid = new String(start_p2p_uid);

		byte[] bytesStart = start_p2p_uid.getBytes(); 
		byte[] bytesEnd = end_p2p_uid.getBytes();

		if(bytesStart.length != bytesEnd.length)
			return "fail";

		int diff_index = 0;
		for(int i = 0; i < bytesStart.length; i++)
		{
			diff_index = i;
			if(bytesStart[i] != bytesEnd[i])
				break;
		}

		int diff_len = bytesStart.length - diff_index;
		String formatText = "%0" + diff_len + "X";
		String startString = start_p2p_uid.substring(0, diff_index);
		int start_uid = Integer.parseInt(start_p2p_uid.substring(diff_index), 16);
		int end_uid = Integer.parseInt(end_p2p_uid.substring(diff_index), 16);

		if((end_uid - start_uid) < 0)
			return "wrong";
		if((end_uid - start_uid) > 9999)
			return "toomany";

		for(int i = start_uid; i <= end_uid; i++)
		{
			String p2p_uid = startString + String.format(formatText, i);
			if(p2p_service.select_p2preserved_where_p2p_uid(p2p_uid) != null)
				return "exist";
		}

		for(int i = start_uid; i <= end_uid; i++)
		{
			String p2p_uid = startString + String.format(formatText, i);
			if(!p2p_service.insert_p2preserved(p2p_uid))
				return "insertfail";
		}

		return "success";
	}
}
