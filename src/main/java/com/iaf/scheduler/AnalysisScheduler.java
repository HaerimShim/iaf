package com.iaf.scheduler;

import com.iaf.model.AnalysisSearchParam;
import com.iaf.service.AnalysisService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

@Component
public class AnalysisScheduler {

    private static final Logger log = LoggerFactory.getLogger(AnalysisScheduler.class);

    private final AnalysisService analysisService;

    public AnalysisScheduler(AnalysisService analysisService) {
        this.analysisService = analysisService;
    }

    @Scheduled(cron = "0 30 2 * * *", zone = "Asia/Seoul")
    public void runDailyAnalysis() {

        String baseDate = LocalDate.now().toString();
        AnalysisSearchParam param = new AnalysisSearchParam();
        param.setBaseDate(baseDate);

        log.info("[IAF_ANALYSIS_RESULT BATCH START] - baseDate: {}", baseDate);
        long startTime = System.currentTimeMillis();
        try {
            int insertCount = analysisService.insertAnalysisResult(param);
            long elapsed = System.currentTimeMillis() - startTime;

            if (insertCount == 0) {
                log.warn("[IAF_ANALYSIS_RESULT BATCH WARNING] - baseDate: {}, 적재 건수 0건", baseDate);
            }

            log.info("[IAF_ANALYSIS_RESULT BATCH SUCCESS] - baseDate: {}, 적재 건수: {}, 소요시간: {}ms", baseDate, insertCount, elapsed);
        } catch (Exception e) {
            long elapsed = System.currentTimeMillis() - startTime;

            log.error("[IAF_ANALYSIS_RESULT BATCH ERROR]  - baseDate: {}, 소요시간: {}ms", baseDate, elapsed, e);
        }
    }
}
