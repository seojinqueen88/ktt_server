package com.push.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.push.model.Member;

@Mapper
public interface Member_dao
{
	public int insert_member(Member member);
	public int update_member_last_login_date(Member member);
	public int delete_member(int member_idx);
	public Member select_member_where_member_id(String member_id);
	public int count_member_all();
	public List<Map<String, Object>> select_member_all(Map<String, Object> map);
}
