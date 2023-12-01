package com.push.model;

import java.sql.Timestamp;

public class Allinone
{
	private int allinone_idx;
	private String server_id;
	private String user_id;
	private String token_id;
	private String app_ver;
	private int mobile_type;
	private int app_num;
	private Timestamp modify_date;
	private Timestamp create_date;

	public Allinone()
	{
		super();
	}

	public Allinone(int allinone_idx, String server_id, String user_id, String token_id, String app_ver,
			int mobile_type, int app_num, Timestamp modify_date, Timestamp create_date) {
		super();
		this.allinone_idx = allinone_idx;
		this.server_id = server_id;
		this.user_id = user_id;
		this.token_id = token_id;
		this.app_ver = app_ver;
		this.mobile_type = mobile_type;
		this.app_num = app_num;
		this.modify_date = modify_date;
		this.create_date = create_date;
	}

	public int getAllinone_idx() {
		return allinone_idx;
	}

	public void setAllinone_idx(int allinone_idx) {
		this.allinone_idx = allinone_idx;
	}

	public String getServer_id() {
		return server_id;
	}

	public void setServer_id(String server_id) {
		this.server_id = server_id;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public String getToken_id() {
		return token_id;
	}

	public void setToken_id(String token_id) {
		this.token_id = token_id;
	}

	public String getApp_ver() {
		return app_ver;
	}

	public void setApp_ver(String app_ver) {
		this.app_ver = app_ver;
	}

	public int getMobile_type() {
		return mobile_type;
	}

	public void setMobile_type(int mobile_type) {
		this.mobile_type = mobile_type;
	}

	public int getApp_num() {
		return app_num;
	}

	public void setApp_num(int app_num) {
		this.app_num = app_num;
	}

	public Timestamp getModify_date() {
		return modify_date;
	}

	public void setModify_date(Timestamp modify_date) {
		this.modify_date = modify_date;
	}

	public Timestamp getCreate_date() {
		return create_date;
	}

	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}

	@Override
	public String toString() {
		return "Allinone [allinone_idx=" + allinone_idx + ", server_id=" + server_id + ", user_id=" + user_id
				+ ", token_id=" + token_id + ", app_ver=" + app_ver + ", mobile_type=" + mobile_type + ", app_num="
				+ app_num + ", modify_date=" + modify_date + ", create_date=" + create_date + "]";
	}
}
