package com.cloud.model;

public class FacilityVO {
    private int fac_idx;
    private String fac_name, fac_category, fac_address, reg_date, icon_path, is_visible;
    private double lat, lon;

    
    public FacilityVO(int fac_idx, String fac_name, String fac_category, String fac_address, String reg_date,
			String icon_path, String is_visible, double lat, double lon) {
		this.fac_idx = fac_idx;
		this.fac_name = fac_name;
		this.fac_category = fac_category;
		this.fac_address = fac_address;
		this.reg_date = reg_date;
		this.icon_path = icon_path;
		this.is_visible = is_visible;
		this.lat = lat;
		this.lon = lon;
	}

	public FacilityVO() {
    	
    }

    public int getFac_idx() {
        return fac_idx;
    }

    public void setFac_idx(int fac_idx) {
        this.fac_idx = fac_idx;
    }

    public String getFac_name() {
        return fac_name;
    }

    public void setFac_name(String fac_name) {
        this.fac_name = fac_name;
    }

    public String getFac_category() {
        return fac_category;
    }

    public void setFac_category(String fac_category) {
        this.fac_category = fac_category;
    }

    public String getFac_address() {
        return fac_address;
    }

    public void setFac_address(String fac_address) {
        this.fac_address = fac_address;
    }

    public double getLat() {
        return lat;
    }

    public void setLat(double lat) {
        this.lat = lat;
    }

    public double getLon() {
        return lon;
    }

    public void setLon(double lon) {
        this.lon = lon;
    }

    public String getReg_date() {
        return reg_date;
    }

    public void setReg_date(String reg_date) {
        this.reg_date = reg_date;
    }

    public String getIcon_path() {
        return icon_path;
    }

    public void setIcon_path(String icon_path) {
        this.icon_path = icon_path;
    }

    public String getIs_visible() {
        return is_visible;
    }

    public void setIs_visible(String is_visible) {
        this.is_visible = is_visible;
    }
}
