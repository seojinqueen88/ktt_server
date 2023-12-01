package com.push.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface Allinone_dao
{
	public int delete_allinone(Map<String, Object> map);

	public int count_allinone_all();
	public List<Map<String, Object>> select_allinone_all(Map<String, Object> map);

	public int count_allinone_where_server_id(String server_id);
	public List<Map<String, Object>> select_allinone_where_server_id(Map<String, Object> map);

	public int count_allinone_where_user_id(String user_id);
	public List<Map<String, Object>> select_allinone_where_user_id(Map<String, Object> map);

	public int count_allinone_where_mobile_type(int mobile_type);
	public List<Map<String, Object>> select_allinone_where_mobile_type(Map<String, Object> map);

	public int count_allinone_where_create_date(Map<String, Object> map);
	public List<Map<String, Object>> select_allinone_where_create_date(Map<String, Object> map);

	public List<Map<String, Object>> select_allinone_all_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_allinone_where_server_id_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_allinone_where_user_id_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_allinone_where_mobile_type_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_allinone_where_create_date_excel(Map<String, Object> map);
}
