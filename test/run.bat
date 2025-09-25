@echo off
setLocal EnableDelayedExpansion
echo Building test.war...
del tes.war 2>nul

jar cvf test.war index.jsp WEB-INF

if !ERRORLEVEL NEQ 0(
    echo WAR creation failed!
    exit /b !ERRORLEVEL
)

echo Setting up Tomcat...
set "TOMCAT_HOME=D:\MES DOCUMENTS\S5\MR naina\apache-tomcat-10.1.28"
set "CATALINA_HOME=%TOMCAT_HOME%"

echo TOMCAT_HOME is set to: %TOMCAT_HOME%
echo CATALINA_HOME is set to: %CATALINA_HOME%

if not exist TOMCAT_HOME (
    echo diso ilay path tomcat dans %TOMCAT_HOME%
)

echo atao shutdown tomcat...
call "%TOMCAT_HOME%\bin\shutdown.bat" 2>nul

echo deploiement...
echo deploiement de test.war...
copy test.war "%TOMCAT_HOME%\webapps"

if !ERRORLEVEL NEQ 0(
    echo deploiement  failed!
    exit /b !ERRORLEVEL
)

echo Starting le serveur
call "%TOMCAT_HOME%\bin\startup.bat"

if !ERRORLEVEL NEQ 0(
    echo startup failed!
    exit /b !ERRORLEVEL
)

echo Waiting for Tomcat to start...
timeout /t 10 /nobreak >nul
:: Wait 10 seconds to give Tomcat time to deploy the WAR

echo Opening browser...
start "" "http://localhost:8080/test"
:: Open the default browser to the deployed app

echo Test application deployed. Access any URL ^(e.g., http://localhost:8080/test/home^) to see the requested URL in index.jsp.

endlocal
:: End local scope of variables