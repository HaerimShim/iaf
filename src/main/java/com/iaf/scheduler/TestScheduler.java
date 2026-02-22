package com.iaf.scheduler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

@Component
@ConditionalOnProperty(name = "scheduler.test.enabled", havingValue = "true")
public class TestScheduler {

    private static final Logger log = LoggerFactory.getLogger(TestScheduler.class);

    private final AnalysisScheduler analysisScheduler;
    private final OmsScheduler omsScheduler;

    public TestScheduler(AnalysisScheduler analysisScheduler, OmsScheduler omsScheduler) {
        this.analysisScheduler = analysisScheduler;
        this.omsScheduler = omsScheduler;
    }

    @Scheduled(initialDelay = 60_000, fixedDelay = Long.MAX_VALUE)
    public void runAnalysisTest() {
        String baseDate = LocalDate.now().toString();
        log.info("[TEST] 재고 분석 배치 실행 - baseDate: {}", baseDate);
        analysisScheduler.runAnalysis(baseDate);
    }

    @Scheduled(initialDelay = 120_000, fixedDelay = Long.MAX_VALUE)
    public void runOmsTest() {
        log.info("[TEST] OMS 발송 배치 실행");
        omsScheduler.runDailyOmsNotification();
    }
}