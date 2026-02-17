package com.iaf.service;

import com.iaf.mapper.BatchLogMapper;
import com.iaf.model.BatchLog;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class BatchLogService {

    private static final Logger log = LoggerFactory.getLogger(BatchLogService.class);

    private final BatchLogMapper batchLogMapper;

    public BatchLogService(BatchLogMapper batchLogMapper) {
        this.batchLogMapper = batchLogMapper;
    }

    public boolean isCompleted(String batchName, String baseDate) {
        return batchLogMapper.existsSuccessBatchLog(batchName, baseDate);
    }

    public void save(String batchName, String baseDate, String status, int insertCount, long elapsedMs, String errorMessage) {
        try {
            BatchLog batchLog = new BatchLog();
            batchLog.setBatchName(batchName);
            batchLog.setBaseDate(baseDate);
            batchLog.setStatus(status);
            batchLog.setInsertCount(insertCount);
            batchLog.setElapsedMs(elapsedMs);
            batchLog.setErrorMessage(errorMessage);
            batchLogMapper.insertBatchLog(batchLog);
        } catch (Exception e) {
            log.error("[{} BATCH LOG INSERT ERROR]", batchName, e);
        }
    }
}
