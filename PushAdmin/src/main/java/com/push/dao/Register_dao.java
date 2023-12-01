package com.push.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface Register_dao
{
	public int count_register_all();
	public List<Map<String, Object>> select_register_all(Map<String, Object> map);

	public int count_register_where_register_name(String register_name);
	public List<Map<String, Object>> select_register_where_register_name(Map<String, Object> map);

	public int count_register_where_register_mac(String register_mac);
	public List<Map<String, Object>> select_register_where_register_mac(Map<String, Object> map);

	public int count_register_where_user_id(String user_id);
	public List<Map<String, Object>> select_register_where_user_id(Map<String, Object> map);

	public int count_register_where_push_yn(int push_yn);
	public List<Map<String, Object>> select_register_where_push_yn(Map<String, Object> map);

	public int count_register_where_create_date(Map<String, Object> map);
	public List<Map<String, Object>> select_register_where_create_date(Map<String, Object> map);

	public List<Map<String, Object>> select_register_all_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_register_where_register_name_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_register_where_register_mac_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_register_where_user_id_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_register_where_push_yn_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_register_where_create_date_excel(Map<String, Object> map);
}
