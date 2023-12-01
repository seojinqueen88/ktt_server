package com.ddns.dao;

import java.util.List;
import java.util.Map;

public interface P2preserved_dao
{
	public int insert_p2preserved(String p2p_uid);

	public int update_p2preserved_used_where_p2puid(Map<String, Object> map);
	public int update_p2preserved_unused_where_in_p2puid(Map<String, Object> map);

	public Map<String, Object> select_p2preserved_where_p2p_uid(String p2p_uid);
	public String select_p2preserved_where_used_0();
	public String select_p2preserved_where_historymac(String history_mac);

	public int count_p2preserved_all();
	public List<Map<String, Object>> select_p2preserved_all(Map<String, Object> map);
	public int count_p2preserved_where_mac(String mac);
	public List<Map<String, Object>> select_p2preserved_where_mac(Map<String, Object> map);
	public int count_p2preserved_where_p2p_uid(String p2p_uid);
	public List<Map<String, Object>> select_p2preserved_where_p2p_uid_search(Map<String, Object> map);
	public List<Map<String, Object>> select_p2preserved_all_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_p2preserved_where_mac_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_p2preserved_where_p2p_uid_excel(Map<String, Object> map);
}
