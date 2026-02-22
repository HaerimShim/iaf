package com.iaf.mapper;

import com.iaf.model.BatchLog;
import com.iaf.model.SearchParam;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BatchLogMapper {
    void insertBatchLog(BatchLog batchLog);
    boolean existsSuccessBatchLog(@Param("batchName") String batchName, @Param("baseDate") String baseDate);
    int countBatchLog(SearchParam param);
    List<BatchLog> selectBatchLog(SearchParam param);
}
