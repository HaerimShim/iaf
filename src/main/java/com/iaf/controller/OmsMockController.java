package com.iaf.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
public class OmsMockController {

    private static final Logger log = LoggerFactory.getLogger(OmsMockController.class);

    private final List<Map<String, Object>> receivedAlerts = new ArrayList<>();

    @PostMapping("/api/oms/alert")
    public ResponseEntity<Map<String, String>> receiveIafAlert(@RequestBody Map<String, Object> payload) {
        log.info("[OMS MOCK] 수신 - clientId: {}, baseDate: {}, alerts 건수: {}",
                payload.get("clientId"),
                payload.get("baseDate"),
                payload.get("alerts") instanceof java.util.List<?> list ? list.size() : 0);
        log.debug("[OMS MOCK] payload: {}", payload);

        receivedAlerts.add(payload);

        return ResponseEntity.ok(Map.of("result", "OK"));
    }

    @GetMapping("/api/oms/alert/history")
    public ResponseEntity<List<Map<String, Object>>> getReceivedAlerts() {
        return ResponseEntity.ok(receivedAlerts);
    }
}
