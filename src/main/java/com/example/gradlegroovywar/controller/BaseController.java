package com.example.gradlegroovywar.controller;


import com.example.gradlegroovywar.domain.BaseReq;
import com.example.gradlegroovywar.service.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


@RestController
public class BaseController {

    @Autowired
    private BaseService baseService;

    @RequestMapping(value = "/api/v1/get_count", method = RequestMethod.GET)
    public int get_count(@RequestParam int num1, @RequestParam int num2) {
        return baseService.GetCount(num1, num2);
    }

    @RequestMapping(value = "/api/v1/post_count", method = RequestMethod.POST)
    public int post_count(@RequestBody BaseReq baseReq) {
        return baseService.GetCount(baseReq.getNum1(),  baseReq.getNum2());
    }
}
