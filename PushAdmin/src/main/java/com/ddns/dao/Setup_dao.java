package com.ddns.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.ddns.model.Setup;

@Mapper
public interface Setup_dao
{
	public int update_setup_devplaykey(int int_value);
	public int update_setup_eventtime(int int_value);
	public List<Setup> select_setup();
}
