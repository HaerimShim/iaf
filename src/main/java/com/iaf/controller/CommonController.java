package com.iaf.controller;

import org.springframework.web.bind.annotation.GetMapping;

@org.springframework.stereotype.Controller
public class CommonController {

    @GetMapping("/")
    public String home() {
        return "redirect:/analysis";
    }

    @GetMapping("/analysis")
    public String analysis() {
        return "iaf/analysis";
    }

    @GetMapping("/oms-history")
    public String omsHistory() {
        return "iaf/omsHistory";
    }

    @GetMapping("/report")
    public String report() {
        return "iaf/report";
    }
}