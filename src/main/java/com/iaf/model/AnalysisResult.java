package com.iaf.model;

public class AnalysisResult {
    private Long clientId;
    private String baseDate;
    private Integer daysRemaining;
    private String category;
    private String skuCode;
    private String skuName;
    private Integer availableQty;
    private Double avgDailyOutboundRecent7days;
    private Double avgDailyOutboundRecent28days;
    private String estimatedSoldOutDateRecent7days;
    private String estimatedSoldOutDateRecent28days;
    private String status;
    private String recommendation;
    private String omsStatus;

    public Long getClientId() { return clientId; }
    public void setClientId(Long clientId) { this.clientId = clientId; }
    public String getBaseDate() { return baseDate; }
    public void setBaseDate(String baseDate) { this.baseDate = baseDate; }
    public Integer getDaysRemaining() { return daysRemaining; }
    public void setDaysRemaining(Integer daysRemaining) { this.daysRemaining = daysRemaining; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getSkuCode() { return skuCode; }
    public void setSkuCode(String skuCode) { this.skuCode = skuCode; }
    public String getSkuName() { return skuName; }
    public void setSkuName(String skuName) { this.skuName = skuName; }
    public Integer getAvailableQty() { return availableQty; }
    public void setAvailableQty(Integer availableQty) { this.availableQty = availableQty; }
    public Double getAvgDailyOutboundRecent7days() { return avgDailyOutboundRecent7days; }
    public void setAvgDailyOutboundRecent7days(Double avgDailyOutboundRecent7days) { this.avgDailyOutboundRecent7days = avgDailyOutboundRecent7days; }
    public Double getAvgDailyOutboundRecent28days() { return avgDailyOutboundRecent28days; }
    public void setAvgDailyOutboundRecent28days(Double avgDailyOutboundRecent28days) { this.avgDailyOutboundRecent28days = avgDailyOutboundRecent28days; }
    public String getEstimatedSoldOutDateRecent7days() { return estimatedSoldOutDateRecent7days; }
    public void setEstimatedSoldOutDateRecent7days(String estimatedSoldOutDateRecent7days) { this.estimatedSoldOutDateRecent7days = estimatedSoldOutDateRecent7days; }
    public String getEstimatedSoldOutDateRecent28days() { return estimatedSoldOutDateRecent28days; }
    public void setEstimatedSoldOutDateRecent28days(String estimatedSoldOutDateRecent28days) { this.estimatedSoldOutDateRecent28days = estimatedSoldOutDateRecent28days; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getRecommendation() { return recommendation; }
    public void setRecommendation(String recommendation) { this.recommendation = recommendation; }
    public String getOmsStatus() { return omsStatus; }
    public void setOmsStatus(String omsStatus) { this.omsStatus = omsStatus; }
}
