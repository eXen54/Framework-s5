@echo off
setlocal EnableDelayedExpansion

echo Building test.war...
del test.war 2>nul
set "TOMCAT_HOME=D:\MES DOCUMENTS\S5\apache-tomcat-10.1.28"
set "CLASSPATH=%CD%\WEB-INF\lib\framework.jar;%TOMCAT_HOME%\lib\jakarta.servlet-api.jar"

echo Compiling test project controllers...
mkdir "%CD%\build" 2>nul
set "SRC_FILES="
if exist "%CD%\src\com\example\test\controllers\*.java" (
    for %%F in ("%CD%\src\com\example\test\controllers\*.java") do (
        set "SRC_FILES=!SRC_FILES! "%%F""
    )
    javac -cp "!CLASSPATH!" -d "%CD%\build" !SRC_FILES!
    if !ERRORLEVEL! NEQ 0 (
        echo Controller compilation failed!
        exit /b !ERRORLEVEL!
    )
)

echo Creating test.war...
jar cvf test.war index.jsp WEB-INF
if !ERRORLEVEL! NEQ 0 (
    echo WAR creation failed!
    exit /b !ERRORLEVEL!
)
if exist "%CD%\build\com\example\test\controllers\*.class" (
    cd "%CD%\build"
    jar uf "%CD%\test.war" com\example\test\controllers\*.class
    cd "%CD%"
)

echo Setting up Tomcat...
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

echo Test application deployed. Access any URL ^(e.g., http://localhost:8080/test/home^) for controller or static resources.
endlocal