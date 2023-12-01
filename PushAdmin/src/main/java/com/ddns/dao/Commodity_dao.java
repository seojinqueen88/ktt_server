package com.ddns.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.ddns.model.Commodity;

@Mapper
public interface Commodity_dao
{
	public int insert_commodity(Commodity commodity);

	public int delete_commodity(Map<String, Object> map);

	public int count_commodity_all();
	public List<Map<String, Object>> select_commodity_all(Map<String, Object> map);

	public int count_commodity_where_search_type(Map<String, Object> map);
	public List<Map<String, Object>> select_commodity_where_search_type(Map<String, Object> map);

	public List<Map<String, Object>> select_commodity_all_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_commodity_where_search_type_excel(Map<String, Object> map);

	public Commodity select_commodity_where_code(String code);
}
