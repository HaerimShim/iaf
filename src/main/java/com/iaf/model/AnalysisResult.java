package com.iaf.model;

public class AnalysisResult {
    private String category;
    private String skuCode;
    private String skuName;
    private Integer inboundQty;
    private Integer outboundQty;
    private Integer onHandQty;
    private Double avgDailyOutbound;
    private String estimatedSoldOutDate;
    private String status;
    private String recommendation;

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getSkuCode() { return skuCode; }
    public void setSkuCode(String skuCode) { this.skuCode = skuCode; }
    public String getSkuName() { return skuName; }
    public void setSkuName(String skuName) { this.skuName = skuName; }
    public Integer getInboundQty() { return inboundQty; }
    public void setInboundQty(Integer inboundQty) { this.inboundQty = inboundQty; }
    public Integer getOutboundQty() { return outboundQty; }
    public void setOutboundQty(Integer outboundQty) { this.outboundQty = outboundQty; }
    public Integer getOnHandQty() { return onHandQty; }
    public void setOnHandQty(Integer onHandQty) { this.onHandQty = onHandQty; }
    public Double getAvgDailyOutbound() { return avgDailyOutbound; }
    public void setAvgDailyOutbound(Double avgDailyOutbound) { this.avgDailyOutbound = avgDailyOutbound; }
    public String getEstimatedSoldOutDateDate() { return estimatedSoldOutDate; }
    public void setEstimatedSoldOutDateDate(String estimatedDepletionDate) { this.estimatedSoldOutDate = estimatedDepletionDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getRecommendation() { return recommendation; }
    public void setRecommendation(String recommendation) { this.recommendation = recommendation; }
}
