@echo off
setlocal EnableDelayedExpansion

echo Compiling framework...
set "LIB_DIR=lib"
set "SERVLET_JAR=D:\MES DOCUMENTS\S5\MRnaina\FrameworkS5\framework\lib\servlet-api.jar"

echo eto oh
@REM if not exist "!SERVLET_JAR!" (
@REM     echo Error: servlet-api.jar not found in %LIB_DIR%. Please copy it from your Tomcat installation (e.g., C:\tomcat\lib\servlet-api.jar).
@REM     exit /b 1
@REM )
@REM echo eto oh
set "CLASSPATH=!SERVLET_JAR!"
echo Using CLASSPATH: !CLASSPATH!

mkdir build
javac -cp "!CLASSPATH!" -d build src\com\framework\FrontServlet.java
if !ERRORLEVEL! NEQ 0 (
    echo Compilation failed!
    exit /b !ERRORLEVEL!
)

echo Creating framework.jar...
cd build
jar cvf ..\framework.jar .
cd ..
if !ERRORLEVEL! NEQ 0 (
    echo JAR creation failed!
    exit /b !ERRORLEVEL!
)

echo Copying framework.jar to test project...
mkdir ..\test\WEB-INF\lib
copy framework.jar ..\test\WEB-INF\lib\framework.jar
if !ERRORLEVEL! NEQ 0 (
    echo Copy failed!
    exit /b !ERRORLEVEL!
)

echo Framework JAR created and copied to test/WEB-INF/lib
endlocal