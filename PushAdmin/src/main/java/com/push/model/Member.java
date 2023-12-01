package com.push.model;

import java.sql.Timestamp;

public class Member
{
	private int member_idx;
	private String member_id;
	private String member_pw;
	private int member_auth;
	private Timestamp last_login_date;
	private Timestamp create_date;
	
	public Member()
	{
		super();
	}

	public int getMember_idx() {
		return member_idx;
	}

	public void setMember_idx(int member_idx) {
		this.member_idx = member_idx;
	}

	public String getMember_id() {
		return member_id;
	}

	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}

	public String getMember_pw() {
		return member_pw;
	}

	public void setMember_pw(String member_pw) {
		this.member_pw = member_pw;
	}

	public int getMember_auth() {
		return member_auth;
	}

	public void setMember_auth(int member_auth) {
		this.member_auth = member_auth;
	}
	public Timestamp getLast_login_date() {
		return last_login_date;
	}

	public void setLast_login_date(Timestamp last_login_date) {
		this.last_login_date = last_login_date;
	}

	public Timestamp getCreate_date() {
		return create_date;
	}

	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}

}
