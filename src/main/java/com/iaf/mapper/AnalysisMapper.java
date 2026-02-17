package com.iaf.mapper;

import com.iaf.model.AnalysisResult;
import com.iaf.model.AnalysisSearchParam;
import com.iaf.model.Client;
import org.apache.ibatis.annotations.Mapper;

import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AnalysisMapper {
    List<Client> selectClientList();
    List<String> selectCategoryListByClientId(Long clientId);
    List<AnalysisResult> selectAlertsByClientAndBaseDate(AnalysisSearchParam param);
    List<AnalysisResult> selectAnalysisResult(AnalysisSearchParam param);
    void deleteAnalysisResultByBaseDate(AnalysisSearchParam param);
    int insertAnalysisResult(AnalysisSearchParam param);
}
