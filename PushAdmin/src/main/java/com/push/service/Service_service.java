package com.push.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ddns.dao.Service_dao;

@Service
public class Service_service
{
	private static final int SEARCHTYPE_SERVICENO = 0;
	private static final int SEARCHTYPE_FIRMNM = 1;
	private static final int SEARCHTYPE_SYSID = 2;
	private static final int SEARCHTYPE_CUSTSTS = 3;

	@Autowired
	private Service_dao service_dao;

	public int count_service_all()
	{
		return service_dao.count_service_all();
	}
	public List<Map<String, Object>> select_service_all(String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return service_dao.select_service_all(map);
	}

	public int count_service_where_search_type(int search_type, String search_word)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		return service_dao.count_service_where_search_type(map);
	}
	public List<Map<String, Object>> select_service_where_search_type(int search_type, String search_word, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return service_dao.select_service_where_search_type(map);
	}

	public List<Map<String, Object>> select_service_all_excel(String sort, String direction , int page , int offset)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		if(page > 0)
			map.put("page", page);
		if(offset >= 0)
			map.put("offset" , offset);
		return service_dao.select_service_all_excel(map);
	}
	public List<Map<String, Object>> select_service_where_search_type_excel(int search_type, String search_word, String sort, 
			String direction , int page , int offset)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
			map.put("page" , page);
		if(offset >= 0)
			map.put("offset" , offset);
		return service_dao.select_service_where_search_type_excel(map);
	}






	private String getSearchTypeStr(int search_type)
	{
		switch(search_type)
		{
		case SEARCHTYPE_SERVICENO:
			return "service_no";
		case SEARCHTYPE_FIRMNM:
			return "firm_nm";
		case SEARCHTYPE_SYSID:
			return "sys_id";
		case SEARCHTYPE_CUSTSTS:
			return "cust_sts";
		}

		return "";
	}
}
