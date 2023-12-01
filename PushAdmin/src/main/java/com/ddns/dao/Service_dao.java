package com.ddns.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface Service_dao
{
	public int count_service_all();
	public List<Map<String, Object>> select_service_all(Map<String, Object> map);

	public int count_service_where_search_type(Map<String, Object> map);
	public List<Map<String, Object>> select_service_where_search_type(Map<String, Object> map);

	public List<Map<String, Object>> select_service_all_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_service_where_search_type_excel(Map<String, Object> map);
}
