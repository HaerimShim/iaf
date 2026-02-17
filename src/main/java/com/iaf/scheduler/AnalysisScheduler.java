package com.iaf.scheduler;

import com.iaf.model.AnalysisSearchParam;
import com.iaf.service.AnalysisService;
import com.iaf.service.BatchLogService;
import com.iaf.service.OmsNotificationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

@Component
public class AnalysisScheduler {

    private static final Logger log = LoggerFactory.getLogger(AnalysisScheduler.class);
    private static final String BATCH_NAME = "IAF_ANALYSIS_RESULT";

    private final AnalysisService analysisService;
    private final BatchLogService batchLogService;
    private final OmsNotificationService omsNotificationService;

    public AnalysisScheduler(AnalysisService analysisService, BatchLogService batchLogService, OmsNotificationService omsNotificationService) {
        this.analysisService = analysisService;
        this.batchLogService = batchLogService;
        this.omsNotificationService = omsNotificationService;
    }

    @Scheduled(cron = "0 30 2 * * *", zone = "Asia/Seoul")
    public void runDailyAnalysis() {
        runAnalysis(LocalDate.now().toString());
    }

    public void runAnalysis(String baseDate) {
        AnalysisSearchParam param = new AnalysisSearchParam();
        param.setBaseDate(baseDate);

        log.info("[{} BATCH START] - baseDate: {}", BATCH_NAME, baseDate);
        long startTime = System.currentTimeMillis();
        try {
            int insertCount = analysisService.insertAnalysisResult(param);
            long elapsed = System.currentTimeMillis() - startTime;

            String status = insertCount > 0 ? "SUCCESS" : "WARNING";

            if (insertCount == 0) {
                log.warn("[{} BATCH WARNING] - baseDate: {}, 적재 건수 0건", BATCH_NAME, baseDate);
            }

            log.info("[{} BATCH {}] - baseDate: {}, 적재 건수: {}, 소요시간: {}ms", BATCH_NAME, status, baseDate, insertCount, elapsed);

            batchLogService.save(BATCH_NAME, baseDate, status, insertCount, elapsed, null);

        } catch (Exception e) {
            long elapsed = System.currentTimeMillis() - startTime;

            log.error("[{} BATCH ERROR] - baseDate: {}, 소요시간: {}ms", BATCH_NAME, baseDate, elapsed, e);

            batchLogService.save(BATCH_NAME, baseDate, "FAIL", 0, elapsed, e.getMessage());
        }
    }

    @Scheduled(cron = "0 0 5 * * *", zone = "Asia/Seoul")
    public void runDailyOmsNotification() {
        String baseDate = LocalDate.now().toString();

        if (!batchLogService.isCompleted(BATCH_NAME, baseDate)) {
            log.warn("[IAF_OMS_NOTIFICATION] baseDate: {} - ANALYSIS_RESULT 적재 미완료, OMS 발송 생략", baseDate);
            return;
        }

        omsNotificationService.sendAlerts(baseDate);
    }
}
