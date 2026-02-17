package com.iaf.controller;

import com.iaf.model.AnalysisSearchParam;
import com.iaf.scheduler.AnalysisScheduler;
import com.iaf.service.AnalysisService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class AnalysisController {

    private final AnalysisService analysisService;
    private final AnalysisScheduler analysisScheduler;

    public AnalysisController(AnalysisService analysisService, AnalysisScheduler analysisScheduler) {
        this.analysisService = analysisService;
        this.analysisScheduler = analysisScheduler;
    }

    @GetMapping("/analysis")
    public String analysis(@ModelAttribute AnalysisSearchParam searchParam,
                           @RequestParam(name = "search", required = false) String search,
                           Model model) {
        model.addAttribute("clientList", analysisService.getClientList());
        if (searchParam.getClientId() != null) {
            model.addAttribute("categoryList", analysisService.getCategoryListByClientId(searchParam.getClientId()));
        }
        if (search != null) {
            model.addAttribute("analysisList", analysisService.getAnalysisResult(searchParam));
        }
        model.addAttribute("searchParam", searchParam);
        return "analysis";
    }

    @GetMapping("/analysis/categories")
    @ResponseBody
    public List<String> getCategoriesByClient(@RequestParam Long clientId) {
        return analysisService.getCategoryListByClientId(clientId);
    }

    @GetMapping("/analysis/test")
    @ResponseBody
    public String testAnalysis(@RequestParam String baseDate) {
        analysisScheduler.runAnalysis(baseDate);
        return "OK";
    }
}
