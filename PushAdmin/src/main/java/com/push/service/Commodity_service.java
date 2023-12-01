package com.push.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ddns.dao.Commodity_dao;
import com.ddns.model.Commodity;

@Service
public class Commodity_service
{
	private static final int SEARCHTYPE_CODE = 0;

	@Autowired
	private Commodity_dao commodity_dao;

	public boolean insert_commodity(Commodity commodity)
	{
		if(commodity_dao.insert_commodity(commodity) > 0)
			return true;
		else
			return false;
	}

	public boolean delete_commodity(String codeListString)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("codeListString", codeListString);

		if(commodity_dao.delete_commodity(map) > 0)
			return true;
		else
			return false;
	}

	public int count_commodity_all()
	{
		return commodity_dao.count_commodity_all();
	}
	public List<Map<String, Object>> select_commodity_all(String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return commodity_dao.select_commodity_all(map);
	}

	public int count_commodity_where_search_type(int search_type, String search_word)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		return commodity_dao.count_commodity_where_search_type(map);
	}
	public List<Map<String, Object>> select_commodity_where_search_type(int search_type, String search_word, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		map.put("sort", sort);
		map.put("direction", direction);
		
		return commodity_dao.select_commodity_where_search_type(map);
	}

	public List<Map<String, Object>> select_commodity_all_excel(String sort, String direction , int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
			map.put("page", page);
		return commodity_dao.select_commodity_all_excel(map);
	}
	public List<Map<String, Object>> select_commodity_where_search_type_excel(int search_type, String search_word, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
			map.put("page", page);
		return commodity_dao.select_commodity_where_search_type_excel(map);
	}

	public Commodity select_commodity_where_code(String code)
	{
		return commodity_dao.select_commodity_where_code(code);
	}





	private String getSearchTypeStr(int search_type)
	{
		switch(search_type)
		{
		case SEARCHTYPE_CODE:
			return "code";
		}

		return "";
	}
}
