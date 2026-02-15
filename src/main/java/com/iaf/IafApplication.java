package com.iaf;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class IafApplication {

    public static void main(String[] args) {
        SpringApplication.run(IafApplication.class, args);
    }

}
