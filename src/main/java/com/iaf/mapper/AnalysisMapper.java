package com.iaf.mapper;

import com.iaf.model.AnalysisResult;
import com.iaf.model.AnalysisSearchParam;
import com.iaf.model.Client;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface AnalysisMapper {
    List<Client> selectClientList();
    List<AnalysisResult> selectAnalysisResult(AnalysisSearchParam param);
}
