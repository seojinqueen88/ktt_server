package com.push.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ddns.dao.Users_dao;
import com.push.dao.Register_dao;

@Service
public class Register_service
{
	@Autowired
	private Register_dao register_dao;

	@Autowired
	private Users_dao ddns_dao;

	public int count_register_all()
	{
		return register_dao.count_register_all();
	}
	public List<Map<String, Object>> select_register_all(String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return register_dao.select_register_all(map);
	}

	public int count_register_where_register_name(String register_name)
	{
		return register_dao.count_register_where_register_name(register_name);
	}
	public List<Map<String, Object>> select_register_where_register_name(String register_name, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("register_name", register_name);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return register_dao.select_register_where_register_name(map);
	}

	public int count_register_where_register_mac(String register_mac)
	{
		return register_dao.count_register_where_register_mac(register_mac);
	}
	public List<Map<String, Object>> select_register_where_register_mac(String register_mac, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("register_mac", register_mac);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return register_dao.select_register_where_register_mac(map);
	}

	public int count_register_where_user_id(String user_id)
	{
		return register_dao.count_register_where_user_id(user_id);
	}
	public List<Map<String, Object>> select_register_where_user_id(String user_id, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("user_id", user_id);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return register_dao.select_register_where_user_id(map);
	}

	public int count_register_where_push_yn(int push_yn)
	{
		return register_dao.count_register_where_push_yn(push_yn);
	}
	public List<Map<String, Object>> select_register_where_push_yn(int push_yn, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("push_yn", push_yn);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return register_dao.select_register_where_push_yn(map);
	}

	public int count_register_where_create_date(String start_create_date, String end_create_date)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("start_create_date", start_create_date);
		map.put("end_create_date", end_create_date);
		return register_dao.count_register_where_create_date(map);
	}
	public List<Map<String, Object>> select_register_where_create_date(String start_create_date, String end_create_date, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("start_create_date", start_create_date);
		map.put("end_create_date", end_create_date);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return register_dao.select_register_where_create_date(map);
	}

	public List<Map<String, Object>> select_register_all_excel(String sort, String direction , int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		if(page >0)
			map.put("page", page);
		return register_dao.select_register_all_excel(map);
	}
	public List<Map<String, Object>> select_register_where_register_name_excel(String register_name, String sort,
			String direction , int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("register_name", register_name);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
			map.put("page", page);
		return register_dao.select_register_where_register_name_excel(map);
	}
	public List<Map<String, Object>> select_register_where_register_mac_excel(String register_mac, String sort, 
			String direction ,int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("register_mac", register_mac);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
			map.put("page", page);
		return register_dao.select_register_where_register_mac_excel(map);
	}
	public List<Map<String, Object>> select_register_where_user_id_excel(String user_id, String sort, 
			String direction , int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("user_id", user_id);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
			map.put("page", page);
		return register_dao.select_register_where_user_id_excel(map);
	}
	public List<Map<String, Object>> select_register_where_push_yn_excel(int push_yn, String sort, 
			String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("push_yn", push_yn);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
			map.put("page", page);
		return register_dao.select_register_where_push_yn_excel(map);
	}
	public List<Map<String, Object>> select_register_where_create_date_excel(String start_create_date, String end_create_date, 
			String sort, String direction , int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("start_create_date", start_create_date);
		map.put("end_create_date", end_create_date);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
			map.put("page", page);
		return register_dao.select_register_where_create_date_excel(map);
	}

	public Map<String, Object> select_users_where_register_mac(String register_mac)
	{
		return ddns_dao.select_users_where_register_mac(register_mac);
	}
}
