package com.push.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ddns.dao.Users_dao;

@Service
public class Users_service
{
	public static final int SEARCHTYPE_DOMAIN = 0; ///도메인
	public static final int SEARCHTYPE_MAKER = 1;///제조사
	public static final int SEARCHTYPE_MODEL = 2; ///모델
	public static final int SEARCHTYPE_PUBLICIP = 3;///외부 IP
	public static final int SEARCHTYPE_P2PUID = 4; ///P2P 라이선스
	public static final int SEARCHTYPE_REGISTERTYPE = 5;///등록 타입
	public static final int SEARCHTYPE_MAC = 6;
	public static final int SEARCHTYPE_VERSION = 7;
	public static final int SEARCHTYPE_EMPLOYEENO = 8;
	public static final int SEARCHTYPE_SERVICENO = 9;
	public static final int SEARCHTYPE_OTP_YN = 10; //OTP_YN
	public static final int SEARCHTYPE_APP_ACCESS_ID = 11;
	public static final int SEARCHTYPE_CMS_ACCESS_ID = 12;
	   public static final int SEARCHTYPE_DEVICE_PROTOCOL_FROM_RECORDER = 13;
	    public static final int SEARCHTYPE_DEVICE_PROTOCOL_FROM_WEBVIEWER = 14;
	@Autowired
	private Users_dao users_dao;

	public int count_users_all()
	{
		return users_dao.count_users_all();
	}
	public List<Map<String, Object>> select_users_all_excel_current_page(String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort); // privateip
		map.put("direction", direction); // direction
		map.put("page", page); // page
		return users_dao.select_users_all_excel_current_page(map);
	}
	public List<Map<String, Object>> select_users_all(String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort); // privateip
		map.put("direction", direction); // direction
		map.put("page", page); // page
		return users_dao.select_users_all(map);
	}

	public int count_users_where_search_type(int search_type, String search_word)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		return users_dao.count_users_where_search_type(map);
	}
	public List<Map<String, Object>> select_users_where_search_type(int search_type, String search_word, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return users_dao.select_users_where_search_type(map);
	}

	public int count_users_where_registertype(int search_type, int search_word)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		return users_dao.count_users_where_registertype(map);
	}
	public List<Map<String, Object>> select_users_where_registertype(int search_type, int search_word, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return users_dao.select_users_where_registertype(map);
	}

	public int count_users_where_otp_yn(int search_type, int search_word)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		return users_dao.count_users_where_otp_yn(map);
	}
	public List<Map<String, Object>> select_users_where_otp_yn(int search_type, int search_word, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return users_dao.select_users_where_otp_yn(map);
	}

	
	public int count_users_where_serviceno(String service_no)
	{
		return users_dao.count_users_where_serviceno(service_no);
	}
	
	public List<Map<String, Object>> select_users_where_serviceno(String service_no, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("service_no", service_no);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return users_dao.select_users_where_serviceno(map);
	}
	public int update_service_user_where_mac(String mac, int service_user) 
	{
		Map<String, Object> map = new HashMap<>();
		map.put("jumin", mac);
		map.put("service_user", service_user);
		return users_dao.update_users_service_user_where_jumin(map);
	}
	public int delete_ddns_where_domain_jumin(String jumin)
	{
		return users_dao.delete_ddns_where_domain_jumin(jumin);
	}

	public int count_users_where_serviceno_and_search_type(String service_no, int search_type, String search_word)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("service_no", service_no);
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		return users_dao.count_users_where_serviceno_and_search_type(map);
	}
	public List<Map<String, Object>> select_users_where_serviceno_and_search_type(String service_no, int search_type, String search_word, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("service_no", service_no);
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return users_dao.select_users_where_serviceno_and_search_type(map);
	}

	public int count_users_where_serviceno_and_registertype(String service_no, int search_type, int search_word)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("service_no", service_no);
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		return users_dao.count_users_where_serviceno_and_registertype(map);
	}
	public List<Map<String, Object>> select_users_where_serviceno_and_registertype(String service_no, int search_type, int search_word, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("service_no", service_no);
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return users_dao.select_users_where_serviceno_and_registertype(map);
	}

	public List<Map<String, Object>> select_users_all_excel(String sort, String direction , int offset)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("offset" , offset);
		return users_dao.select_users_all_excel(map);
	}
	public List<Map<String, Object>> select_users_where_search_type_excel(int search_type, String search_word, 
			String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
			map.put("page",page);
		return users_dao.select_users_where_search_type_excel(map);
	}
	public List<Map<String, Object>> select_users_where_registertype_excel(int search_type,
			int search_word, String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page>0)
			map.put("page", page);
		return users_dao.select_users_where_registertype_excel(map);
	}
	public List<Map<String, Object>> select_users_where_serviceno_excel(String service_no, String sort,
			String direction , int offset , int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("service_no", service_no);
		map.put("sort", sort);
		map.put("direction", direction);
		if(offset >= 0)
		map.put("offset" , offset);
		if(page > 0)
			map.put("page", page);
		return users_dao.select_users_where_serviceno_excel(map);
	}
	public List<Map<String, Object>> select_users_where_serviceno_and_search_type_excel(String service_no,
			int search_type, String search_word, String sort, String direction , int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("service_no", service_no);
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page >0)
			map.put("page", page);
		return users_dao.select_users_where_serviceno_and_search_type_excel(map);
	}
	public List<Map<String, Object>> select_users_where_serviceno_and_registertype_excel(String service_no, 
			int search_type, int search_word, String sort, String direction , int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("service_no", service_no);
		map.put("search_type", getSearchTypeStr(search_type));
		map.put("search_word", search_word);
		map.put("sort", sort);
		map.put("direction", direction);
		if(page >0)
			map.put("page", page);
		return users_dao.select_users_where_serviceno_and_registertype_excel(map);
	}

	public Map<String, Object> select_users_network_where_mac(String mac)
	{
		return users_dao.select_users_network_where_mac(mac);
	}
	
	public int select_user_registerType_where_mac(String mac) 
	{
		return users_dao.select_user_registerType_where_mac(mac);
	}
	
	public int select_user_registerType_where_otp_yn(String mac)
	{
		return users_dao.select_user_registerType_where_otp_yn(mac);
	}
	public boolean update_users_service_no_otp_yn(String id , String mac , Integer otp_yn)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("mac", mac);
		map.put("otp_yn", otp_yn);
		map.put("OTP_ADMIN_ID", id);
		return users_dao.update_users_service_no_otp_yn(map) > 0 ? true : false;
	}
	public boolean update_users_service_no_access_rule(String id , String mac , Integer access_rule)
    {
        Map<String, Object> map = new HashMap<>();
        map.put("mac", mac);
        map.put("access_rule", access_rule);
        //map.put("ADMIN_ID", id);
        return users_dao.update_users_service_access_rule(map) > 0 ? true : false;
    }
	public Map<String, Object> select_users_p2p_where_mac(String mac)
	{
		return users_dao.select_users_p2p_where_mac(mac);
	}

	public boolean update_users_p2ppriority_where_p2puid(String p2p_uid, int p2p_priority)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("p2p_uid", p2p_uid);
		map.put("p2p_priority", p2p_priority);

		if(users_dao.update_users_p2ppriority_where_p2puid(map) > 0)
			return true;
		else
			return false;
	}

	/*
	 * 20220525 / 추가 / 서비스 번호 웹 내 수정 기능 추가
	 */
	public String update_service_no_where_mac(String jumin, String serviceNo, String empNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("jumin", jumin);
		map.put("serviceNo", serviceNo);
		map.put("empNo", empNo);
		int result_modify = users_dao.update_users_service_no_where_mac(map);
		String result = null;
		if(result_modify == 1)
		{
			result = "success";
		}
		else if(result_modify == 0)
		{
			result = "failed";
		}
		else
		{
			result = "checked";
		}
		return result;
	}

	// END

	
	private String getSearchTypeStr(int search_type)
	{
		switch(search_type)
		{
		case SEARCHTYPE_DOMAIN:
			return "domain";
		case SEARCHTYPE_MAKER:
			return "maker";
		case SEARCHTYPE_MODEL:
			return "empty2";
		case SEARCHTYPE_PUBLICIP:
			return "addr";
		case SEARCHTYPE_P2PUID:
			return "p2p_uid";
		case SEARCHTYPE_REGISTERTYPE:
			return "register_type";
		case SEARCHTYPE_MAC:
			return "jumin";
		case SEARCHTYPE_VERSION:
			return "empty3";
		case SEARCHTYPE_EMPLOYEENO:
			return "employee_no";
		case SEARCHTYPE_SERVICENO:
			return "service_no";
		case SEARCHTYPE_OTP_YN:
			return "otp_yn";
		case SEARCHTYPE_APP_ACCESS_ID:
		  return "app_access_id";
		case SEARCHTYPE_CMS_ACCESS_ID:
		  return "cms_access_id";
		case SEARCHTYPE_DEVICE_PROTOCOL_FROM_RECORDER :
		  return "device_accesslog_type_t0";
		case SEARCHTYPE_DEVICE_PROTOCOL_FROM_WEBVIEWER :
		  return "device_accesslog_type_t1";
		}
		return "";
	}
	
	
}
