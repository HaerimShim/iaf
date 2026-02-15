package com.iaf.service;

import com.iaf.mapper.AnalysisMapper;
import com.iaf.model.AnalysisResult;
import com.iaf.model.AnalysisSearchParam;
import com.iaf.model.Client;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
public class AnalysisService {

    private final AnalysisMapper analysisMapper;

    public AnalysisService(AnalysisMapper analysisMapper) {
        this.analysisMapper = analysisMapper;
    }

    // Spring 4.3+ : 단일 생성자 = 자동 주입
    public List<Client> getClientList() {
        return analysisMapper.selectClientList();
    }

    public List<String> getCategoryListByClientId(Long clientId) {
        return analysisMapper.selectCategoryListByClientId(clientId);
    }

    public List<AnalysisResult> getAnalysisResult(AnalysisSearchParam param) {
        if (param.getBaseDate() == null || param.getBaseDate().isBlank()) {
            param.setBaseDate(LocalDate.now().toString());
        }
        return analysisMapper.selectAnalysisResult(param);
    }

    @Transactional
    public int insertAnalysisResult(AnalysisSearchParam param) {
        analysisMapper.deleteAnalysisResultByBaseDate(param);
        return analysisMapper.insertAnalysisResult(param);
    }
}
