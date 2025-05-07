package com.cloud.model;

public class GuardianVO {

	private String user_id, g_name, g_phone, g_relationship;

	
	
	public GuardianVO(String user_id, String g_name, String g_phone, String g_relationship) {
		this.user_id = user_id;
		this.g_name = g_name;
		this.g_phone = g_phone;
		this.g_relationship = g_relationship;
	}

	public GuardianVO() {
		
	}
	
	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public String getG_name() {
		return g_name;
	}

	public void setG_name(String g_name) {
		this.g_name = g_name;
	}

	public String getG_phone() {
		return g_phone;
	}

	public void setG_phone(String g_phone) {
		this.g_phone = g_phone;
	}

	public String getG_relationship() {
		return g_relationship;
	}

	public void setG_relationship(String g_relationship) {
		this.g_relationship = g_relationship;
	}
	
	
	
	
}
