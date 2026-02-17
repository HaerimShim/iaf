package com.iaf.model;

public class Client {
    private Long clientId;
    private String clientName;
    private String status;
    private String omsUrl;

    public Long getClientId() {
        return clientId;
    }

    public void setClientId(Long clientId) {
        this.clientId = clientId;
    }

    public String getClientName() {
        return clientName;
    }

    public void setClientName(String clientName) {
        this.clientName = clientName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getOmsUrl() {
        return omsUrl;
    }

    public void setOmsUrl(String omsUrl) {
        this.omsUrl = omsUrl;
    }
}
