package com.framework;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class FrontServlet extends HttpServlet {

    @Override
    protected void service(
            HttpServletRequest req,
            HttpServletResponse res) throws ServletException, IOException {
        String url = req.getRequestURL().toString();
        PrintWriter out = res.getWriter();
        out.println(url);
    }

}