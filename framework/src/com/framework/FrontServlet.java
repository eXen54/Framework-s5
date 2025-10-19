package com.framework;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * This is the servlet that takes all incoming requests targeting the app.
 * - If the requested resource exists, it delegates to the default dispatcher.
 * - Else, it checks for annotated mappings (@GetMapping, @PostMapping).
 * - If no mapping, it shows the requested URL in a not-found page.
 */
public class FrontServlet extends HttpServlet {

    private RequestDispatcher defaultDispatcher;
    private Map<String, Handler> mappings = new HashMap<>();

    private static class Handler {
        Object target;
        Method method;

        Handler(Object target, Method method) {
            this.target = target;
            this.method = method;
        }
    }

    @Override
    public void init() {
        defaultDispatcher = getServletContext().getNamedDispatcher("default");
        String basePackage = getInitParameter("base-package");
        if (basePackage != null) {
            scanAndMap(basePackage);
        }
    }

    private void scanAndMap(String packageName) {
        Set<Class<?>> classes = findAllClassesUsingClassLoader(packageName);
        for (Class<?> clazz : classes) {
            if (clazz.isAnnotationPresent(Controller.class)) {
                try {
                    Object instance = clazz.newInstance();
                    for (Method method : clazz.getDeclaredMethods()) {
                        if (method.isAnnotationPresent(GetMapping.class)) {
                            String value = method.getAnnotation(GetMapping.class).value();
                            mappings.put("GET" + value, new Handler(instance, method));
                        } else if (method.isAnnotationPresent(PostMapping.class)) {
                            String value = method.getAnnotation(PostMapping.class).value();
                            mappings.put("POST" + value, new Handler(instance, method));
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private Set<Class<?>> findAllClassesUsingClassLoader(String packageName) {
        Set<Class<?>> classes = new HashSet<>();
        try {
            InputStream stream = ClassLoader.getSystemClassLoader()
                    .getResourceAsStream(packageName.replaceAll("[.]", "/"));
            if (stream == null)
                return classes;
            BufferedReader reader = new BufferedReader(new InputStreamReader(stream));
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.endsWith(".class")) {
                    Class<?> clazz = getClassFromFileName(line, packageName);
                    if (clazz != null) {
                        classes.add(clazz);
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return classes;
    }

    private Class<?> getClassFromFileName(String fileName, String packageName) {
        try {
            String className = packageName + "." + fileName.substring(0, fileName.lastIndexOf('.'));
            return Class.forName(className);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String path = req.getRequestURI().substring(req.getContextPath().length());
        boolean resourceExists = getServletContext().getResource(path) != null;

        if (resourceExists) {
            defaultDispatcher.forward(req, res);
        } else {
            String key = req.getMethod() + path;
            Handler handler = mappings.get(key);
            if (handler != null) {
                try {
                    handler.method.invoke(handler.target, req, res);
                } catch (Exception e) {
                    e.printStackTrace();
                    res.setStatus(500);
                }
            } else {
                try (PrintWriter out = res.getWriter()) {
                    String url = req.getRequestURL().toString();
                    String responseBody = """
                            <html>
                                <head><title>Resource Not Found</title></head>
                                <body>
                                    <h1>Unknown resource</h1>
                                    <p>The requested URL was not found: <strong>%s</strong></p>
                                </body>
                            </html>
                            """.formatted(url);
                    res.setContentType("text/html;charset=UTF-8");
                    out.println(responseBody);
                }
            }
        }
    }
}