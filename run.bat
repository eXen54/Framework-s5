@echo off
setlocal EnableDelayedExpansion

echo Building test.war...
cd WEB-INF
jar cvf ..\test.war .
cd ..
if !ERRORLEVEL! NEQ 0 (
    echo WAR creation failed!
    exit /b !ERRORLEVEL!
)

echo Setting up Tomcat...
set "TOMCAT_HOME=D:\MES DOCUMENTS\S5\MR naina\apache-tomcat-10.1.28"
set "CATALINA_HOME=%TOMCAT_HOME%"
echo TOMCAT_HOME is set to: %TOMCAT_HOME%
echo CATALINA_HOME is set to: %CATALINA_HOME%

if not exist "%TOMCAT_HOME%\bin\startup.bat" (
    echo Tomcat not found at %TOMCAT_HOME%. Please download and extract Tomcat to %TOMCAT_HOME%.
    echo Visit https://tomcat.apache.org/ to download Tomcat ^(e.g., version 10.1.28 ZIP^).
    exit /b 1
)

echo Stopping any running Tomcat instance...
call "%TOMCAT_HOME%\bin\shutdown.bat" 2>nul

echo Deploying test.war to Tomcat...
copy test.war "%TOMCAT_HOME%\webapps\"
if !ERRORLEVEL! NEQ 0 (
    echo Deployment failed!
    exit /b !ERRORLEVEL!
)

echo Starting Tomcat...
call "%TOMCAT_HOME%\bin\startup.bat"
if !ERRORLEVEL! NEQ 0 (
    echo Tomcat startup failed! Check %TOMCAT_HOME%\logs\catalina.out for details.
    exit /b !ERRORLEVEL!
)

echo Waiting for Tomcat to start...
timeout /t 10 /nobreak >nul

echo Opening browser...
start "" "http://localhost:8080/test"

echo Test application deployed. Access any URL ^(e.g., http://localhost:8080/test/home^) to see the requested URL.
endlocal