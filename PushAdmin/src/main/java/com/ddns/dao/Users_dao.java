package com.ddns.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

/// 차후 작업 예정 : ResultHandler 등을 이용한 대용량 리스트 핸들링
/// 쿼리문을 정리를 통한 함수 갯수의 축소
/// 페치 등 속도 및 디비의 입출력 풋프린트 정리

/// 2022-09-06 작업 내역
/// 액셀관련 쿼리문 기존 user테이블에서 user_table_0 view로 정리
/// 모델뷰 방식에서 단순 서비스 방식으로 변경
@Mapper
public interface Users_dao
{
	public int update_users_p2p_insert(Map<String, Object> map);
	public int update_users_p2p_delete(String mac);
	public int update_users_p2p_delete_where_in_mac(Map<String, Object> map);
	public int update_users_p2ppriority_where_p2puid(Map<String, Object> map);

	public int update_users_service_user_where_jumin(Map<String, Object> map);
	public int delete_ddns_where_domain_jumin(String jumin);
	
	public int count_users_all();
	public List<Map<String, Object>>  select_users_all_excel_current_page(Map<String, Object> map);
	public List<Map<String, Object>> select_users_all(Map<String, Object> map);

	public int count_users_where_search_type(Map<String, Object> map);
	public List<Map<String, Object>> select_users_where_search_type(Map<String, Object> map);

	public int count_users_where_registertype(Map<String, Object> map);
	public List<Map<String, Object>> select_users_where_registertype(Map<String, Object> map);

	public int count_users_where_otp_yn(Map<String, Object> map);
	public List<Map<String, Object>> select_users_where_otp_yn(Map<String, Object> map);
	
	public int count_users_where_serviceno(String service_no);
	public List<Map<String, Object>> select_users_where_serviceno(Map<String, Object> map);

	public int count_users_where_serviceno_and_search_type(Map<String, Object> map);
	public List<Map<String, Object>> select_users_where_serviceno_and_search_type(Map<String, Object> map);

	public int count_users_where_serviceno_and_registertype(Map<String, Object> map);
	public List<Map<String, Object>> select_users_where_serviceno_and_registertype(Map<String, Object> map);

	public List<Map<String, Object>> select_users_all_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_users_where_search_type_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_users_where_registertype_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_users_where_serviceno_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_users_where_serviceno_and_search_type_excel(Map<String, Object> map);
	public List<Map<String, Object>> select_users_where_serviceno_and_registertype_excel(Map<String, Object> map);

	public Map<String, Object> select_users_network_where_mac(String mac);
	public Map<String, Object> select_users_p2p_where_mac(String mac);
	public String select_users_p2puid_where_mac(String mac);
	public ArrayList<String> select_users_p2puid_where_in_mac(Map<String, Object> map);

	public Map<String, Object> select_users_where_register_mac(String register_mac);
	public int select_user_registerType_where_mac(String mac);
	
	//20220525 / 추가 / 서비스 번호 웹 내 수정 기능 추가	
	public int update_users_service_no_where_mac(Map<String, Object> map);
	//20221138 OTP_YN 인증 시나리오에 따른 OTP_YN 변경
	public int select_user_registerType_where_otp_yn(String mac);
	public int update_users_service_no_otp_yn(Map<String,Object>map);
	public int update_users_service_access_rule(Map<String,Object>map);
}
