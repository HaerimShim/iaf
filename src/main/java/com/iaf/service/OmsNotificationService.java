package com.iaf.service;

import com.iaf.mapper.AnalysisMapper;
import com.iaf.model.AnalysisResult;
import com.iaf.model.AnalysisSearchParam;
import com.iaf.model.Client;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class OmsNotificationService {

    private static final Logger log = LoggerFactory.getLogger(OmsNotificationService.class);
    private static final String BATCH_NAME = "IAF_OMS_NOTIFICATION";

    private final AnalysisMapper analysisMapper;
    private final BatchLogService batchLogService;
    private final RestClient restClient;

    public OmsNotificationService(AnalysisMapper analysisMapper, BatchLogService batchLogService) {
        this.analysisMapper = analysisMapper;
        this.batchLogService = batchLogService;
        this.restClient = RestClient.create();
    }

    public void sendAlerts(String baseDate) {
        List<Client> clients = analysisMapper.selectClientList();

        for (Client client : clients) {

            Long clientId = client.getClientId();
            String clientName = client.getClientName();

            if (client.getOmsUrl() == null || client.getOmsUrl().isBlank()) {
                log.debug("[{}] 고객사 {}({}) - oms_url 미설정, 건너뜀", BATCH_NAME, clientName, clientId);
                continue;
            }

            long startTime = System.currentTimeMillis();
            try {
                AnalysisSearchParam param = new AnalysisSearchParam();
                param.setClientId(clientId);
                param.setBaseDate(baseDate);
                List<AnalysisResult> alerts = analysisMapper.selectAlertsByClientAndBaseDate(param);

                if (alerts.isEmpty()) {
                    log.info("[{}] 고객사 {}({}) - WARNING/DANGER 항목 없음, 발송 생략", BATCH_NAME, clientName, clientId);
                    continue;
                }

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

                restClient.post()
                        .uri(client.getOmsUrl())
                        .contentType(MediaType.APPLICATION_JSON)
                        .body(payload)
                        .retrieve()
                        .toBodilessEntity();

                long elapsed = System.currentTimeMillis() - startTime;
                log.info("[{}] 고객사 {}({}) - 발송 성공, {}건, {}ms", BATCH_NAME, clientName, clientId, alerts.size(), elapsed);

                batchLogService.save(BATCH_NAME, baseDate, "SUCCESS", alerts.size(), elapsed, null);

            } catch (Exception e) {
                long elapsed = System.currentTimeMillis() - startTime;
                log.error("[{}] 고객사 {}({}) - 발송 실패, {}ms", BATCH_NAME, clientName, clientId, elapsed, e);

                batchLogService.save(BATCH_NAME, baseDate, "FAIL", 0, elapsed, e.getMessage());
            }
        }
    }
}
