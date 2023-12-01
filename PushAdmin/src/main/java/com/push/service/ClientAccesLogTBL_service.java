package com.push.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ddns.dao.ClientAccesLogTBLDao;
 

@Service
public class ClientAccesLogTBL_service {
	@Autowired
	private ClientAccesLogTBLDao clientAccessTblDao;
			
	public int count_ClientAccesLogTBL_all(String mac_address, String search_type ) {
		  Map<String, Object> map = new HashMap<>();
		  map.put("mac_address",mac_address);
	      map.put("search_type",search_type);
		  return clientAccessTblDao.count_ClientAccesLogTBL_all(map);
		}
	
	public int count_ClientAccesLogTbl(Integer client_access_log_req_type , String mac_address, String search_type ) {
	  Map<String, Object> map = new HashMap<>();
	  map.put("client_access_log_req_type",client_access_log_req_type);
	  map.put("mac_address",mac_address);
      map.put("search_type",search_type);
	  return clientAccessTblDao.count_ClientAccesLogTBL(map);
	}
	
	public List<Map<String, Object>> select_ClientAccesLogTBL_all(String sort, String direction ,int page ,String mac_address, String search_type) {
			Map<String, Object> map = new HashMap<>();
		      map.put("mac_address",mac_address);
		      map.put("search_type",search_type);
		      map.put("sort", sort);
		      map.put("direction", direction);
    		  map.put("page", page);
			return clientAccessTblDao.select_ClientAccesLogTBL_all(map);
		}
	
	public List<Map<String, Object>> select_ClientAccesLogTbl(String sort, String direction ,int page ,Integer client_access_log_req_type , String mac_address,
		    String search_type) {
			Map<String, Object> map = new HashMap<>();
			  map.put("client_access_log_req_type",client_access_log_req_type);
		      map.put("mac_address",mac_address);
		      map.put("search_type",search_type);
		      map.put("sort", sort);
		      map.put("direction", direction);
    		  map.put("page", page);
			return clientAccessTblDao.select_ClientAccesLogTBL(map);
		}
	
	
	   public List<Map<String, Object>> select_ClientAccesLogTblExcel(String sort, String direction ,int page ,Integer client_access_log_req_type , String mac_address,
	        String search_type) {
	        Map<String, Object> map = new HashMap<>();
	          map.put("client_access_log_req_type",client_access_log_req_type);
	          map.put("mac_address", mac_address);
	          map.put("search_type", search_type);
	          map.put("sort", sort);
	          map.put("direction", direction);
    		  map.put("page", page);
	        return clientAccessTblDao.select_ClientAccesLogTBL_forExcel(map);
	    }
		
	   public List<Map<String, Object>> select_ClientAccesLogTblAll_Excel(String sort, String direction ,int page, int offset, Integer client_access_log_req_type , String mac_address,
	        String search_type) {
	        Map<String, Object> map = new HashMap<>();
	          map.put("client_access_log_req_type",client_access_log_req_type);
	          map.put("mac_address", mac_address);
	          map.put("search_type", search_type);
	          map.put("sort", sort);
	          map.put("direction", direction);
	          if(page > 0)
	        	  map.put("page" , page);
	          if(offset >= 0)
	        	  map.put("offset" , offset);
	        return clientAccessTblDao.select_ClientAccesLogTBLAll_forExcel(map);
	    }
	private static final int SEARCHTYPE_MAC = 0;
	private static final int SEARCHTYPE_APP_ACCESS_ID = 1;
	private static final int SEARCHTYPE_CMS_ACCESS_ID = 2;
	private static final int SEARCHTYPE_DEVICE_PROTOCOL_TYPE=3;
	 
	public String getSearchTypeStr(int search_type)
	{
		switch(search_type)
		{
		case SEARCHTYPE_MAC:
			return "mac_address";
		case SEARCHTYPE_APP_ACCESS_ID:
			return "app_access_id";
		case SEARCHTYPE_CMS_ACCESS_ID:
			return "cms_access_id";
		case SEARCHTYPE_DEVICE_PROTOCOL_TYPE:
			return "device_protocol_type";
		}
		return "";
		

	}
	
}
