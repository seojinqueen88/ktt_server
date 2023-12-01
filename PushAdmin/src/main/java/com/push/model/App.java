package com.push.model;

public class App
{
	private int app_no;
	private String app_name;

	public App() {
		super();
	}

	public App(int app_no, String app_name) {
		super();
		this.app_no = app_no;
		this.app_name = app_name;
	}

	public int getApp_no() {
		return app_no;
	}

	public void setApp_no(int app_no) {
		this.app_no = app_no;
	}

	public String getApp_name() {
		return app_name;
	}

	public void setApp_name(String app_name) {
		this.app_name = app_name;
	}

	@Override
	public String toString() {
		return "App [app_no=" + app_no + ", app_name=" + app_name + "]";
	}
}
