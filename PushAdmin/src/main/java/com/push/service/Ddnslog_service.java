package com.push.service;

import java.util.*;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ddns.dao.Ddnslog_dao;
import java.util.*;
@Service
public class Ddnslog_service
{
	private static final int SEARCHTYPE_MAC = 0;
	private static final int SEARCHTYPE_MESSAGE = 1;

	@Autowired
	private Ddnslog_dao ddnslog_dao;

	public int count_ddnslog_all()
	{
		return ddnslog_dao.count_ddnslog_all();
	}
	public List<Map<String, Object>> select_ddnslog_all(String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return ddnslog_dao.select_ddnslog_all(map);
	}

	public int count_ddnslog_where_search_type(int search_type, String search_word)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		return ddnslog_dao.count_ddnslog_where_search_type(map);
	}
	public List<Map<String, Object>> select_ddnslog_where_search_type(int search_type, String search_word, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return ddnslog_dao.select_ddnslog_where_search_type(map);
	}

	public int count_ddnslog_where_create_date(String start_create_date, String end_create_date)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("start_create_date", start_create_date);
		map.put("end_create_date", end_create_date);
		return ddnslog_dao.count_ddnslog_where_create_date(map);
	}
	public List<Map<String, Object>> select_ddnslog_where_create_date(String start_create_date, String end_create_date, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("start_create_date", start_create_date);
		map.put("end_create_date", end_create_date);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return ddnslog_dao.select_ddnslog_where_create_date(map);
	}

	public List<Map<String, Object>> select_ddnslog_all_excel(String sort, String direction)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		return ddnslog_dao.select_ddnslog_all_excel(map);
	}
	public List<Map<String, Object>> select_ddnslog_where_search_type_excel(int search_type, String search_word, String sort, String direction)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		map.put("sort", sort);
		map.put("direction", direction);
		return ddnslog_dao.select_ddnslog_where_search_type_excel(map);
	}
	public List<Map<String, Object>> select_ddnslog_where_create_date_excel(String start_create_date, String end_create_date, String sort, String direction)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("start_create_date", start_create_date);
		map.put("end_create_date", end_create_date);
		map.put("sort", sort);
		map.put("direction", direction);
		return ddnslog_dao.select_ddnslog_where_create_date_excel(map);
	}

 
	private String getSearchTypeStr(int search_type)
	{
		switch(search_type)
		{
		case SEARCHTYPE_MAC:
			return "mac";
		case SEARCHTYPE_MESSAGE:
			return "message";
		}

		return "";
	}
}
