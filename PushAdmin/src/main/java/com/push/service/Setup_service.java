package com.push.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ddns.dao.Setup_dao;
import com.ddns.model.Setup;

@Service
public class Setup_service
{
	@Autowired
	private Setup_dao setup_dao;

	public boolean update_setup_devplaykey(int int_value)
	{
		if(setup_dao.update_setup_devplaykey(int_value) > 0)
			return true;
		else
			return false;
	}

	public boolean update_setup_eventtime(int int_value)
	{
		if(setup_dao.update_setup_eventtime(int_value) > 0)
			return true;
		else
			return false;
	}

	public Map<String, Object> select_setup()
	{
		List<Setup> setupList = setup_dao.select_setup();
		Map<String, Object> setup = new HashMap<>();
		
		for(Setup setupItem : setupList)
		{
			switch(setupItem.getSetup_key())
			{
			case "devplaykey_limit_min":
			case "eventtime_limit_day":
				setup.put(setupItem.getSetup_key(), setupItem.getInt_value());
				break;
			default:
				break;
			}
		}

		return setup;
	}
}
