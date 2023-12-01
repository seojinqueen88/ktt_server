package com.push.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.push.model.Mobile;

@Mapper
public interface Mobile_dao
{
	public int count_mobile_all();
	public List<Map<String, Object>> select_mobile_all(Map<String, Object> map);

	public int count_mobile_where_user_id(String user_id);
	public List<Map<String, Object>> select_mobile_where_user_id(Map<String, Object> map);

	public int count_mobile_where_mobile_type(int mobile_type);
	public List<Map<String, Object>> select_mobile_where_mobile_type(Map<String, Object> map);

	public int count_mobile_where_create_date(Map<String, Object> map);
	public List<Map<String, Object>> select_mobile_where_create_date(Map<String, Object> map);

	public List<Map<String, Object>> select_mobile_all_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_mobile_where_user_id_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_mobile_where_mobile_type_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_mobile_where_create_date_excel(Map<String, Object> map);

	public Mobile select_mobile_where_mobile_idx(int mobile_idx);
}
