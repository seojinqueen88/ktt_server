package com.kttddnsapi.dao;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface DdnslogDao
{
	public int insertDdnslog(Map<String, Object> map);
}
