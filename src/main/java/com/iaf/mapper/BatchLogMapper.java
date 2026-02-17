package com.iaf.mapper;

import com.iaf.model.BatchLog;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface BatchLogMapper {
    void insertBatchLog(BatchLog batchLog);
    boolean existsSuccessBatchLog(@Param("batchName") String batchName, @Param("baseDate") String baseDate);
}
