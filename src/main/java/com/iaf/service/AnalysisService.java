package com.iaf.service;

import com.iaf.mapper.AnalysisMapper;
import com.iaf.model.AnalysisResult;
import com.iaf.model.AnalysisSearchParam;
import com.iaf.model.Client;
import org.springframework.stereotype.Service;

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

    public List<AnalysisResult> getAnalysisResult(AnalysisSearchParam param) {
        if (param.getBaseDate() == null || param.getBaseDate().isBlank()) {
            param.setBaseDate(LocalDate.now().toString());
        }
        if (param.getRecentDays() == null) {
            param.setRecentDays(7);
        }
        return analysisMapper.selectAnalysisResult(param);
    }
}
