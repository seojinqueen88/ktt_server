package com.push.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.push.controller.AccessLog_controller;
import com.push.dao.Allinone_dao;

@Service
public class Allinone_service
{
	@Autowired
	private Allinone_dao allinone_dao;

	public boolean delete_allinone(String server_id, String user_id)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("server_id", server_id);
		map.put("user_id", user_id);
		
		if(allinone_dao.delete_allinone(map) > 0)
			return true;
		else
			return false;
	}

	public int count_allinone_all()
	{
		return allinone_dao.count_allinone_all();
	}
	public List<Map<String, Object>> select_allinone_all(String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return allinone_dao.select_allinone_all(map);
	}

	public int count_allinone_where_server_id(String server_id)
	{
		return allinone_dao.count_allinone_where_server_id(server_id);
	}
	public List<Map<String, Object>> select_allinone_where_server_id(String server_id, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("server_id", server_id);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return allinone_dao.select_allinone_where_server_id(map);
	}

	public int count_allinone_where_user_id(String user_id)
	{
		return allinone_dao.count_allinone_where_user_id(user_id);
	}
	public List<Map<String, Object>> select_allinone_where_user_id(String user_id, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("user_id", user_id);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return allinone_dao.select_allinone_where_user_id(map);
	}

	public int count_allinone_where_mobile_type(int mobile_type)
	{
		return allinone_dao.count_allinone_where_mobile_type(mobile_type);
	}
	public List<Map<String, Object>> select_allinone_where_mobile_type(int mobile_type, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("mobile_type", mobile_type);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return allinone_dao.select_allinone_where_mobile_type(map);
	}

	public int count_allinone_where_create_date(String start_create_date, String end_create_date)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("start_create_date", start_create_date);
		map.put("end_create_date", end_create_date);
		return allinone_dao.count_allinone_where_create_date(map);
	}
	public List<Map<String, Object>> select_allinone_where_create_date(String start_create_date, String end_create_date, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("start_create_date", start_create_date);
		map.put("end_create_date", end_create_date);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return allinone_dao.select_allinone_where_create_date(map);
	}

	public List<Map<String, Object>> select_allinone_all_excel(String sort, String direction , int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		if(page > 0)
			map.put("page", page);
		return allinone_dao.select_allinone_all_excel(map);
	}
	public List<Map<String, Object>> select_allinone_where_server_id_excel(String server_id, 
			String sort, String direction , int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("server_id", server_id);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page > 0)
			map.put("page", page);
		return allinone_dao.select_allinone_where_server_id_excel(map);
	}
	public List<Map<String, Object>> select_allinone_where_user_id_excel(String user_id, String sort, String direction , int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("user_id", user_id);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page > 0) map.put("page", page);
		return allinone_dao.select_allinone_where_user_id_excel(map);
	}
	public List<Map<String, Object>> select_allinone_where_mobile_type_excel(int mobile_type, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("mobile_type", mobile_type);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page > 0) map.put("page", page);
		return allinone_dao.select_allinone_where_mobile_type_excel(map);
	}
	public List<Map<String, Object>> select_allinone_where_create_date_excel(String start_create_date, String end_create_date, String sort, String direction , int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("start_create_date", start_create_date);
		map.put("end_create_date", end_create_date);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page > 0) map.put("page", page);
		return allinone_dao.select_allinone_where_create_date_excel(map);

	}
}
