package com.ddns.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
 

@Mapper
public interface ClientAccesLogTBLDao {
	 
	
    public int count_ClientAccesLogTBL(Map<String, Object> map);
    public int count_ClientAccesLogTBL_all(Map<String, Object> map);
    public List<Map<String, Object>> select_ClientAccesLogTBL_all(Map<String, Object> map);
    public List<Map<String, Object>> select_ClientAccesLogTBL(Map<String, Object> map);
    public List<Map<String, Object>> select_ClientAccesLogTBL_forExcel(Map<String, Object> map);
    public List<Map<String, Object>> select_ClientAccesLogTBLAll_forExcel(Map<String, Object> map);

}
