package com.push.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ddns.dao.P2preserved_dao;
import com.ddns.dao.Users_dao;

@Service
public class P2p_service
{
	@Autowired
	private P2preserved_dao p2preserved_dao;

	@Autowired
	private Users_dao users_dao;

	public boolean insert_p2preserved(String p2p_uid)
	{
		if(p2preserved_dao.insert_p2preserved(p2p_uid) > 0)
			return true;
		else
			return false;
	}



	public boolean update_p2preserved_used_where_p2puid(String p2p_uid, String history_mac)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("p2p_uid", p2p_uid);
		map.put("history_mac", history_mac);

		if(p2preserved_dao.update_p2preserved_used_where_p2puid(map) > 0)
			return true;
		else
			return false;
	}

	public boolean update_p2preserved_unused_where_in_p2puid(String p2puid_list_string)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("p2puid_list_string", p2puid_list_string);

		if(p2preserved_dao.update_p2preserved_unused_where_in_p2puid(map) > 0)
			return true;
		else
			return false;
	}




	public Map<String, Object> select_p2preserved_where_p2p_uid(String p2p_uid)
	{
		return p2preserved_dao.select_p2preserved_where_p2p_uid(p2p_uid);
	}

	public String select_p2preserved_where_used_0()
	{
		return p2preserved_dao.select_p2preserved_where_used_0();
	}

	public String select_p2preserved_where_historymac(String history_mac)
	{
		return p2preserved_dao.select_p2preserved_where_historymac(history_mac);
	}





	public int count_p2preserved_all()
	{
		return p2preserved_dao.count_p2preserved_all();
	}

	public List<Map<String, Object>> select_p2preserved_all(String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return p2preserved_dao.select_p2preserved_all(map);
	}

	public int count_p2preserved_where_mac(String mac)
	{
		return p2preserved_dao.count_p2preserved_where_mac(mac);
	}

	public List<Map<String, Object>> select_p2preserved_where_mac(String mac, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("mac", mac);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return p2preserved_dao.select_p2preserved_where_mac(map);
	}

	public int count_p2preserved_where_p2p_uid(String p2p_uid)
	{
		return p2preserved_dao.count_p2preserved_where_p2p_uid(p2p_uid);
	}

	public List<Map<String, Object>> select_p2preserved_where_p2p_uid_search(String p2p_uid, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("p2p_uid", p2p_uid);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return p2preserved_dao.select_p2preserved_where_p2p_uid_search(map);
	}
	public List<Map<String, Object>> select_p2preserved_where_p2p_uid_search_excel(
			String p2p_uid, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("p2p_uid", p2p_uid);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
		map.put("page", page);
		return p2preserved_dao.select_p2preserved_where_p2p_uid_search(map);
	}
	public List<Map<String, Object>> select_p2preserved_all_excel(String sort, String direction,int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
			map.put("page", page);
		return p2preserved_dao.select_p2preserved_all_excel(map);
	}

	public List<Map<String, Object>> select_p2preserved_where_mac_excel(String mac, String sort, String direction , int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("mac", mac);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
			map.put("page", page);
		return p2preserved_dao.select_p2preserved_where_mac_excel(map);
	}

	public List<Map<String, Object>> select_p2preserved_where_p2p_uid_excel(String p2p_uid, String sort, String direction ,int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("p2p_uid", p2p_uid);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
			map.put("page", page);
		return p2preserved_dao.select_p2preserved_where_p2p_uid_excel(map);
	}






	public boolean update_users_p2p_insert(String mac, String p2p_uid, int p2p_priority)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("mac", mac);
		map.put("p2p_uid", p2p_uid);
		map.put("p2p_priority", p2p_priority);

		if(users_dao.update_users_p2p_insert(map) > 0)
			return true;
		else
			return false;
	}

	public boolean update_users_p2p_delete(String mac)
	{
		if(users_dao.update_users_p2p_delete(mac) > 0)
			return true;
		else
			return false;
	}

	public boolean update_users_p2p_delete_where_in_mac(String mac_list_string)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("mac_list_string", mac_list_string);

		if(users_dao.update_users_p2p_delete_where_in_mac(map) > 0)
			return true;
		else
			return false;
	}

	public String select_users_p2puid_where_mac(String mac)
	{
		return users_dao.select_users_p2puid_where_mac(mac);
	}

	public ArrayList<String> select_users_p2puid_where_in_mac(String mac_list_string)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("mac_list_string", mac_list_string);

		return users_dao.select_users_p2puid_where_in_mac(map);
	}
}
