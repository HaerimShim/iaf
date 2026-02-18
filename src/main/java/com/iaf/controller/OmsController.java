package com.iaf.controller;

import com.iaf.mapper.AnalysisMapper;
import com.iaf.mapper.OmsNotificationHistoryMapper;
import com.iaf.model.OmsNotificationHistory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class OmsController {

    private final OmsNotificationHistoryMapper omsNotificationHistoryMapper;
    private final AnalysisMapper analysisMapper;

    public OmsController(OmsNotificationHistoryMapper omsNotificationHistoryMapper, AnalysisMapper analysisMapper) {
        this.omsNotificationHistoryMapper = omsNotificationHistoryMapper;
        this.analysisMapper = analysisMapper;
    }

    @GetMapping("/oms-history")
    public String omsHistory(@RequestParam(required = false) String baseDate,
                             @RequestParam(required = false) Long clientId,
                             @RequestParam(required = false) String status,
                             @RequestParam(name = "search", required = false) String search,
                             Model model) {
        model.addAttribute("clientList", analysisMapper.selectClientList());
        model.addAttribute("baseDate", baseDate);
        model.addAttribute("clientId", clientId);
        model.addAttribute("status", status);
        if (search != null) {
            OmsNotificationHistory param = new OmsNotificationHistory();
            param.setBaseDate(baseDate);
            param.setClientId(clientId);
            param.setStatus(status);
            model.addAttribute("historyList", omsNotificationHistoryMapper.selectOmsNotificationHistory(param));
        }
        return "omsNotificationHistory";
    }
}
