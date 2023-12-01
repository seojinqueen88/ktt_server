package com.ddns.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface Ddnslog_dao
{
	public int count_ddnslog_all();
	public List<Map<String, Object>> select_ddnslog_all(Map<String, Object> map);

	public int count_ddnslog_where_search_type(Map<String, Object> map);
	public List<Map<String, Object>> select_ddnslog_where_search_type(Map<String, Object> map);

	public int count_ddnslog_where_create_date(Map<String, Object> map);
	public List<Map<String, Object>> select_ddnslog_where_create_date(Map<String, Object> map);

	public List<Map<String, Object>> select_ddnslog_all_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_ddnslog_where_search_type_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_ddnslog_where_create_date_excel(Map<String, Object> map);
}
