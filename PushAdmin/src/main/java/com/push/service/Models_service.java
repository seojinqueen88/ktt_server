package com.push.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ddns.dao.Models_dao;

@Service
public class Models_service
{
	private static final int SEARCHTYPE_MODEL = 0;
	private static final int SEARCHTYPE_FWVER = 1;

	@Autowired
	private Models_dao models_dao;

	public boolean insert_models(String model)
	{
		if(models_dao.insert_models(model) > 0)
			return true;
		else
			return false;
	}

	public boolean delete_models(String modelListString)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("modelListString", modelListString);

		if(models_dao.delete_models(map) > 0)
			return true;
		else
			return false;
	}

	public int count_models_all()
	{
		return models_dao.count_models_all();
	}
	public List<Map<String, Object>> select_models_all(String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return models_dao.select_models_all(map);
	}

	public int count_models_where_search_type(int search_type, String search_word)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		return models_dao.count_models_where_search_type(map);
	}
	public List<Map<String, Object>> select_models_where_search_type(int search_type, String search_word, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return models_dao.select_models_where_search_type(map);
	}

	public List<Map<String, Object>> select_models_all_excel(String sort, String direction ,int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		if(page >0 )
			map.put("page", page);
		return models_dao.select_models_all_excel(map);
	}
	public List<Map<String, Object>> select_models_where_search_type_excel(int search_type, String search_word, String sort,
			String direction,int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page >0 )
			map.put("page", page);
		return models_dao.select_models_where_search_type_excel(map);
	}

	public Map<String, Object> select_models_where_model(String model)
	{
		return models_dao.select_models_where_model(model);
	}






	private String getSearchTypeStr(int search_type)
	{
		switch(search_type)
		{
		case SEARCHTYPE_MODEL:
			return "model";
		case SEARCHTYPE_FWVER:
			return "fw_version";
		}

		return "";
	}
}
