package com.cloud.model;

public class ReportVO {
    private int report_idx;
    private String user_id;
    private String report_type;
    private String report_content;
    private String reg_date;
    private String report_status;

    public ReportVO() {
    	
    }
    
    public ReportVO(int report_idx, String user_id, String report_type, String report_content, String reg_date,
			String report_status) {
		super();
		this.report_idx = report_idx;
		this.user_id = user_id;
		this.report_type = report_type;
		this.report_content = report_content;
		this.reg_date = reg_date;
		this.report_status = report_status;
	}
	
    public int getReport_idx() {
        return report_idx;
    }
    public void setReport_idx(int report_idx) {
        this.report_idx = report_idx;
    }

    public String getUser_id() {
        return user_id;
    }
    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getReport_type() {
        return report_type;
    }
    public void setReport_type(String report_type) {
        this.report_type = report_type;
    }

    public String getReport_content() {
        return report_content;
    }
    public void setReport_content(String report_content) {
        this.report_content = report_content;
    }

    public String getReg_date() {
        return reg_date;
    }
    public void setReg_date(String reg_date) {
        this.reg_date = reg_date;
    }

    public String getReport_status() {
        return report_status;
    }
    public void setReport_status(String report_status) {
        this.report_status = report_status;
    }
}
