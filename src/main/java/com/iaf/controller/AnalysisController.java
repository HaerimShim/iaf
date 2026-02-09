package com.iaf.controller;

import com.iaf.model.AnalysisSearchParam;
import com.iaf.service.AnalysisService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AnalysisController {

    private final AnalysisService analysisService;

    // Spring 4.3+ : 단일 생성자 = 자동 주입
    public AnalysisController(AnalysisService analysisService) {
        this.analysisService = analysisService;
    }

    @GetMapping("/analysis")
    public String analysis(@ModelAttribute AnalysisSearchParam searchParam,
                           @RequestParam(name = "search", required = false) String search,
                           Model model) {
        model.addAttribute("clientList", analysisService.getClientList());
        if (search != null) {
            model.addAttribute("analysisList", analysisService.getAnalysisResult(searchParam));
        }
        model.addAttribute("searchParam", searchParam);
        return "analysis";
    }
}
