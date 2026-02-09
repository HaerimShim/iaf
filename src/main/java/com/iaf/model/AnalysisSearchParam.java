package com.iaf.model;

public class AnalysisSearchParam {
    private Long clientId;
    private String baseDate;
    private Integer recentDays;
    private String statusFilter;

    public Long getClientId() { return clientId; }
    public void setClientId(Long clientId) { this.clientId = clientId; }
    public String getBaseDate() { return baseDate; }
    public void setBaseDate(String baseDate) { this.baseDate = baseDate; }
    public Integer getRecentDays() { return recentDays; }
    public void setRecentDays(Integer recentDays) { this.recentDays = recentDays; }
    public String getStatusFilter() { return statusFilter; }
    public void setStatusFilter(String statusFilter) { this.statusFilter = statusFilter; }
}
