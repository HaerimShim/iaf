package com.iaf.scheduler;

import com.iaf.service.BatchLogService;
import com.iaf.service.OmsNotificationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

@Component
public class OmsScheduler {

    private static final Logger log = LoggerFactory.getLogger(OmsScheduler.class);
    private static final String BATCH_NAME = "IAF_OMS_NOTIFICATION";
    private static final String BATCH_NAME_ANALYSIS = "IAF_ANALYSIS_RESULT";

    private final OmsNotificationService omsNotificationService;
    private final BatchLogService batchLogService;

    public OmsScheduler(OmsNotificationService omsNotificationService, BatchLogService batchLogService) {
        this.omsNotificationService = omsNotificationService;
        this.batchLogService = batchLogService;
    }

    @Scheduled(cron = "0 0 5 * * *", zone = "Asia/Seoul")
    public void runDailyOmsNotification() {
        String baseDate = LocalDate.now().toString();

        if (!batchLogService.isCompleted(BATCH_NAME_ANALYSIS, baseDate)) {
            log.warn("[{}] baseDate: {} - ANALYSIS_RESULT 적재 미완료, OMS 발송 생략", BATCH_NAME, baseDate);
            batchLogService.save(BATCH_NAME, baseDate, "SKIP", 0, 0, "ANALYSIS_RESULT 적재 미완료");
            return;
        }

        log.info("[{} START] baseDate: {}", BATCH_NAME, baseDate);
        long startTime = System.currentTimeMillis();
        try {
            omsNotificationService.sendNotification(baseDate);
            long elapsed = System.currentTimeMillis() - startTime;
            log.info("[{} END] baseDate: {}, 소요시간: {}ms", BATCH_NAME, baseDate, elapsed);
            batchLogService.save(BATCH_NAME, baseDate, "SUCCESS", 0, elapsed, null);
        } catch (Exception e) {
            long elapsed = System.currentTimeMillis() - startTime;
            log.error("[{} ERROR] baseDate: {}, 소요시간: {}ms", BATCH_NAME, baseDate, elapsed, e);
            batchLogService.save(BATCH_NAME, baseDate, "FAIL", 0, elapsed, e.getMessage());
        }
    }
}