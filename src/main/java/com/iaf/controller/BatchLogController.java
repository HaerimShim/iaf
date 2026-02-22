package com.iaf.controller;

import com.iaf.model.SearchParam;
import com.iaf.service.BatchLogService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;

@Controller
public class BatchLogController {

    private final BatchLogService batchLogService;

    public BatchLogController(BatchLogService batchLogService) {
        this.batchLogService = batchLogService;
    }

    @GetMapping("/batchLog")
    public String batchLog(@ModelAttribute SearchParam searchParam, Model model) {
        if (searchParam.getSearch() != null) {
            int page = searchParam.getPage();
            int totalCount = batchLogService.countBatchLog(searchParam);
            int totalPages = (int) Math.ceil((double) totalCount / searchParam.getPageSize());
            int startPage = Math.max(1, page - 2);
            int endPage = Math.min(totalPages, startPage + 4);
            startPage = Math.max(1, endPage - 4);
            model.addAttribute("batchLogList", batchLogService.getBatchLog(searchParam));
            model.addAttribute("totalCount", totalCount);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("currentPage", page);
            model.addAttribute("startPage", startPage);
            model.addAttribute("endPage", endPage);
        }
        model.addAttribute("searchParam", searchParam);
        return "batchLog";
    }
}
