package com.example.test.controllers;

import com.framework.Controller;
import com.framework.GetMapping;
import com.framework.PostMapping;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@Controller
public class HomeController {

    @GetMapping("/home")
    public void home(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.getWriter().println("Welcome to home page! Requested URL: " + req.getRequestURL());
    }

    @PostMapping("/submit")
    public void submit(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.getWriter().println("POST request received at /submit! Requested URL: " + req.getRequestURL());
    }
}