package com.push.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.push.dao.Mobile_dao;
import com.push.model.Mobile;

@Service
public class Mobile_service
{
	@Autowired
	private Mobile_dao mobile_dao;

	public int count_mobile_all()
	{
		return mobile_dao.count_mobile_all();
	}
	public List<Map<String, Object>> select_mobile_all(String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return mobile_dao.select_mobile_all(map);
	}

	public int count_mobile_where_user_id(String user_id)
	{
		return mobile_dao.count_mobile_where_user_id(user_id);
	}
	public List<Map<String, Object>> select_mobile_where_user_id(String user_id, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("user_id", user_id);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return mobile_dao.select_mobile_where_user_id(map);
	}

	public int count_mobile_where_mobile_type(int mobile_type)
	{
		return mobile_dao.count_mobile_where_mobile_type(mobile_type);
	}
	public List<Map<String, Object>> select_mobile_where_mobile_type(int mobile_type, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("mobile_type", mobile_type);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return mobile_dao.select_mobile_where_mobile_type(map);
	}

	public int count_mobile_where_create_date(String start_create_date, String end_create_date)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("start_create_date", start_create_date);
		map.put("end_create_date", end_create_date);
		return mobile_dao.count_mobile_where_create_date(map);
	}
	public List<Map<String, Object>> select_mobile_where_create_date(String start_create_date, String end_create_date, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("start_create_date", start_create_date);
		map.put("end_create_date", end_create_date);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return mobile_dao.select_mobile_where_create_date(map);
	}

	public List<Map<String, Object>> select_mobile_all_excel(String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
			map.put("page", page);
		return mobile_dao.select_mobile_all_excel(map);
	}
	public List<Map<String, Object>> select_mobile_where_user_id_excel(String user_id, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("user_id", user_id);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
			map.put("page", page);
		return mobile_dao.select_mobile_where_user_id_excel(map);
	}
	public List<Map<String, Object>> select_mobile_where_mobile_type_excel(int mobile_type, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("mobile_type", mobile_type);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
			map.put("page", page);
		return mobile_dao.select_mobile_where_mobile_type_excel(map);
	}
	public List<Map<String, Object>> select_mobile_where_create_date_excel(String start_create_date, String end_create_date, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("start_create_date", start_create_date);
		map.put("end_create_date", end_create_date);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
			map.put("page", page);
		return mobile_dao.select_mobile_where_create_date_excel(map);
	}

	public Mobile select_mobile_where_mobile_idx(int mobile_idx)
	{
		return mobile_dao.select_mobile_where_mobile_idx(mobile_idx);
	}
}
