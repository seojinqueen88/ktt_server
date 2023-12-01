package com.ddns.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface Models_dao
{
	public int insert_models(String model);

	public int delete_models(Map<String, Object> map);

	public int count_models_all();
	public List<Map<String, Object>> select_models_all(Map<String, Object> map);

	public int count_models_where_search_type(Map<String, Object> map);
	public List<Map<String, Object>> select_models_where_search_type(Map<String, Object> map);

	public List<Map<String, Object>> select_models_all_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_models_where_search_type_excel(Map<String, Object> map);

	public Map<String, Object> select_models_where_model(String model);
}
