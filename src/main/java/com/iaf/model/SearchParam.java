package com.iaf.model;

public class SearchParam {
    private Long clientId;
    private String category;
    private String baseDate;
    private String status;
    private int page = 1;
    private int pageSize = 12;
    private String search;
    private String batchName;
    private String baseDateFrom;
    private String baseDateTo;

    public Long getClientId() { return clientId; }
    public void setClientId(Long clientId) { this.clientId = clientId; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getBaseDate() { return baseDate; }
    public void setBaseDate(String baseDate) { this.baseDate = baseDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public int getPage() { return page; }
    public void setPage(int page) { this.page = page; }
    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = pageSize; }
    public int getOffset() { return (page - 1) * pageSize; }
    public String getSearch() { return search; }
    public void setSearch(String search) { this.search = search; }
    public String getBatchName() { return batchName; }
    public void setBatchName(String batchName) { this.batchName = batchName; }
    public String getBaseDateFrom() { return baseDateFrom; }
    public void setBaseDateFrom(String baseDateFrom) { this.baseDateFrom = baseDateFrom; }
    public String getBaseDateTo() { return baseDateTo; }
    public void setBaseDateTo(String baseDateTo) { this.baseDateTo = baseDateTo; }
}
