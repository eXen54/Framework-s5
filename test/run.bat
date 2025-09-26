@echo off
setlocal EnableDelayedExpansion

echo Building test.war...
del test.war 2>nul

jar cvf test.war index.jsp WEB-INF

if !ERRORLEVEL! NEQ 0 (
    echo WAR creation failed!
    exit /b !ERRORLEVEL!
)

echo Setting up Tomcat...
set "TOMCAT_HOME=D:\MES DOCUMENTS\S5\MRnaina\apache-tomcat-10.1.28"
set "CATALINA_HOME=%TOMCAT_HOME%"

echo TOMCAT_HOME is set to: %TOMCAT_HOME%
echo CATALINA_HOME is set to: %CATALINA_HOME%

if not exist "%TOMCAT_HOME%" (
    echo Tomcat path does not exist: %TOMCAT_HOME%
    exit /b 1
)

echo Stopping Tomcat...
call "%TOMCAT_HOME%\bin\shutdown.bat" 2>nul

echo Deploying test.war...
copy /Y test.war "%TOMCAT_HOME%\webapps" >nul

if !ERRORLEVEL! NEQ 0 (
    echo Deployment failed!
    exit /b !ERRORLEVEL!
)

echo Starting Tomcat...
call "%TOMCAT_HOME%\bin\startup.bat"

if !ERRORLEVEL! NEQ 0 (
    echo Startup failed!
    exit /b !ERRORLEVEL!
)

echo Waiting for Tomcat to start...
timeout /t 10 /nobreak >nul

echo Opening browser...
start "" "http://localhost:8080/test"

echo.
echo Test application deployed successfully.
echo Access it via: http://localhost:8080/test or other URLs such as /test/home

endlocal
