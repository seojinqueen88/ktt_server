package com.push.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.push.dao.Member_dao;
import com.push.model.Member;

@Service
public class Member_service
{
	@Autowired
	private Member_dao member_dao;

	public boolean insert_member(Member member)
	{
		if(member_dao.insert_member(member) > 0)
			return true;
		else
			return false;
	}

	public boolean update_member_last_login_date(Member member)
	{
		if(member_dao.update_member_last_login_date(member) > 0)
			return true;
		else
			return false;
	}

	public boolean delete_member(int member_idx)
	{
		if(member_dao.delete_member(member_idx) > 0)
			return true;
		else
			return false;
	}

	public Member select_member_where_member_id(String member_id)
	{
		return member_dao.select_member_where_member_id(member_id);
	}

	public int count_member_all()
	{
		return member_dao.count_member_all();
	}

	public List<Map<String, Object>> select_member_all(String sort, String direction, int page)
	{
		Map<String, Object> map = new HashMap<>();
		map.put("sort", sort);
		map.put("direction", direction);
		map.put("page", page);
		return member_dao.select_member_all(map);
	}
}
