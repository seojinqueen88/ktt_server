package com.push.model;

import java.sql.Timestamp;

public class Register
{
	private int register_idx;
	private int mobile_idx;
	private String register_name;
	private String register_mac;
	private int push_yn;
	private Timestamp modify_date;
	private Timestamp create_date;

	public Register()
	{
		super();
	}

	public Register(int register_idx, int mobile_idx, String register_name, String register_mac, int push_yn,
			Timestamp modify_date, Timestamp create_date)
	{
		super();
		this.register_idx = register_idx;
		this.mobile_idx = mobile_idx;
		this.register_name = register_name;
		this.register_mac = register_mac;
		this.push_yn = push_yn;
		this.modify_date = modify_date;
		this.create_date = create_date;
	}

	public int getRegister_idx() {
		return register_idx;
	}

	public void setRegister_idx(int register_idx) {
		this.register_idx = register_idx;
	}

	public int getMobile_idx() {
		return mobile_idx;
	}

	public void setMobile_idx(int mobile_idx) {
		this.mobile_idx = mobile_idx;
	}

	public String getRegister_name() {
		return register_name;
	}

	public void setRegister_name(String register_name) {
		this.register_name = register_name;
	}

	public String getRegister_mac() {
		return register_mac;
	}

	public void setRegister_mac(String register_mac) {
		this.register_mac = register_mac;
	}

	public int getPush_yn() {
		return push_yn;
	}

	public void setPush_yn(int push_yn) {
		this.push_yn = push_yn;
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
		return "Register [register_idx=" + register_idx + ", mobile_idx=" + mobile_idx + ", register_name="
				+ register_name + ", register_mac=" + register_mac + ", push_yn=" + push_yn + ", modify_date="
				+ modify_date + ", create_date=" + create_date + "]";
	}
}
