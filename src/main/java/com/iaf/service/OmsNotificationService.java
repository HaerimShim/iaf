package com.iaf.service;

import tools.jackson.databind.ObjectMapper;
import com.iaf.mapper.AnalysisMapper;
import com.iaf.mapper.ClientMapper;
import com.iaf.mapper.OmsNotificationMapper;
import com.iaf.model.AnalysisResult;
import com.iaf.model.SearchParam;
import com.iaf.model.Client;
import com.iaf.model.OmsNotification;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.time.Duration;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class OmsNotificationService {

    private static final Logger log = LoggerFactory.getLogger(OmsNotificationService.class);
    private static final String BATCH_NAME = "IAF_OMS_NOTIFICATION";

    private final AnalysisMapper analysisMapper;
    private final ClientMapper clientMapper;
    private final OmsNotificationMapper omsNotificationMapper;
    private final ObjectMapper objectMapper;
    private final RestClient restClient;

    public OmsNotificationService(AnalysisMapper analysisMapper, ClientMapper clientMapper,
                                  OmsNotificationMapper omsNotificationMapper, ObjectMapper objectMapper) {
        this.analysisMapper = analysisMapper;
        this.clientMapper = clientMapper;
        this.omsNotificationMapper = omsNotificationMapper;
        this.objectMapper = objectMapper;
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(Duration.ofSeconds(5));
        factory.setReadTimeout(Duration.ofSeconds(10));
        this.restClient = RestClient.builder().requestFactory(factory).build();
    }

    public Map<String, Object> getStatusSummary(SearchParam param) {
        return omsNotificationMapper.selectStatusSummary(param);
    }

    public int countOmsNotification(SearchParam param) {
        return omsNotificationMapper.countOmsNotification(param);
    }

    public List<OmsNotification> getOmsNotification(SearchParam param) {
        return omsNotificationMapper.selectOmsNotification(param);
    }

    public void sendNotification(String baseDate) {
        List<Client> clients = clientMapper.selectClientList();
        for (Client client : clients) {
            sendToClient(baseDate, client);
        }
    }

    public void resendNotification(SearchParam param) {
        Client client = clientMapper.selectClientById(param.getClientId());
        if (client == null) {
            throw new IllegalArgumentException("클라이언트를 찾을 수 없습니다: " + param.getClientId());
        }
        sendToClient(param.getBaseDate(), client);
    }

    private void sendToClient(String baseDate, Client client) {
        Long clientId = client.getClientId();
        String clientName = client.getClientName();

        if (client.getOmsUrl() == null || client.getOmsUrl().isBlank()) {
            log.warn("[{}] 고객사 {}({}) - oms_url 미설정, 건너뜀", BATCH_NAME, clientName, clientId);
            saveOmsNotification(baseDate, clientId, null, null, "SKIP", "NO_URL", 0);
            return;
        }

        SearchParam param = new SearchParam();
        param.setClientId(clientId);
        param.setBaseDate(baseDate);
        List<AnalysisResult> alerts = analysisMapper.selectAlertsByClientAndBaseDate(param);

        if (alerts.isEmpty()) {
            log.info("[{}] 고객사 {}({}) - WARNING/DANGER 항목 없음, 발송 생략", BATCH_NAME, clientName, clientId);
            return;
        }

        String status = "FAIL";
        String errorMessage = null;
        String payloadJson = null;
        long startTime = System.currentTimeMillis();
        long elapsed = 0;

        try {
            Map<String, Object> payload = new HashMap<>();
            payload.put("baseDate", baseDate);
            payload.put("clientId", clientId);

            List<Map<String, Object>> alertList = alerts.stream().map(a -> {
                Map<String, Object> item = new HashMap<>();
                item.put("skuCode", a.getSkuCode());
                item.put("skuName", a.getSkuName());
                item.put("category", a.getCategory());
                item.put("availableQty", a.getAvailableQty());
                item.put("daysRemaining", a.getDaysRemaining());
                item.put("status", a.getStatus());
                item.put("recommendation", a.getRecommendation());
                return item;
            }).toList();
            payload.put("alerts", alertList);

            payloadJson = objectMapper.writeValueAsString(payload);

            restClient.post()
                    .uri(client.getOmsUrl())
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(payload)
                    .retrieve()
                    .toBodilessEntity();

            elapsed = System.currentTimeMillis() - startTime;
            status = "SUCCESS";
            log.info("[{}] 고객사 {}({}) - 발송 성공, {}건, {}ms", BATCH_NAME, clientName, clientId, alerts.size(), elapsed);

        } catch (Exception e) {
            elapsed = System.currentTimeMillis() - startTime;
            errorMessage = e.getMessage();
            log.error("[{}] 고객사 {}({}) - 발송 실패, {}ms", BATCH_NAME, clientName, clientId, elapsed, e);

        } finally {
            saveOmsNotification(baseDate, clientId, client.getOmsUrl(), payloadJson, status, errorMessage, elapsed);
        }
    }

    private void saveOmsNotification(String baseDate, Long clientId, String omsUrl,
                                    String requestPayload, String status, String errorMessage, long elapsedMs) {
        try {
            OmsNotification history = new OmsNotification();
            history.setBaseDate(baseDate);
            history.setClientId(clientId);
            history.setOmsUrl(omsUrl);
            history.setRequestPayload(requestPayload);
            history.setStatus(status);
            history.setErrorMessage(errorMessage);
            history.setElapsedMs(elapsedMs);
            omsNotificationMapper.insertOmsNotification(history);
        } catch (Exception e) {
            log.error("[{}] OMS 발송 이력 저장 실패 - clientId: {}", BATCH_NAME, clientId, e);
        }
    }
}
