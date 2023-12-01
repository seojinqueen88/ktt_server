package com.push.model;

import java.sql.Timestamp;

public class Mobile
{
	private int mobile_idx;
	private String token_id;
	private String user_id;
	private int mobile_type;
	private int lang_cd;
	private int app_num;
	private String app_ver;
	private Timestamp create_date;

	public Mobile()
	{
		super();
	}

	public Mobile(int mobile_idx, String token_id, String user_id, int mobile_type, int lang_cd, int app_num,
			String app_ver, Timestamp create_date)
	{
		super();
		this.mobile_idx = mobile_idx;
		this.token_id = token_id;
		this.user_id = user_id;
		this.mobile_type = mobile_type;
		this.lang_cd = lang_cd;
		this.app_num = app_num;
		this.app_ver = app_ver;
		this.create_date = create_date;
	}

	public int getMobile_idx() {
		return mobile_idx;
	}

	public void setMobile_idx(int mobile_idx) {
		this.mobile_idx = mobile_idx;
	}

	public String getToken_id() {
		return token_id;
	}

	public void setToken_id(String token_id) {
		this.token_id = token_id;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public int getMobile_type() {
		return mobile_type;
	}

	public void setMobile_type(int mobile_type) {
		this.mobile_type = mobile_type;
	}

	public int getLang_cd() {
		return lang_cd;
	}

	public void setLang_cd(int lang_cd) {
		this.lang_cd = lang_cd;
	}

	public int getApp_num() {
		return app_num;
	}

	public void setApp_num(int app_num) {
		this.app_num = app_num;
	}

	public String getApp_ver() {
		return app_ver;
	}

	public void setApp_ver(String app_ver) {
		this.app_ver = app_ver;
	}

	public Timestamp getCreate_date() {
		return create_date;
	}

	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}

	@Override
	public String toString() {
		return "Mobile [mobile_idx=" + mobile_idx + ", token_id=" + token_id + ", user_id=" + user_id + ", mobile_type="
				+ mobile_type + ", lang_cd=" + lang_cd + ", app_num=" + app_num + ", app_ver=" + app_ver
				+ ", create_date=" + create_date + "]";
	}
}
