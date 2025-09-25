@echo off
echo Compiling framework...
mkdir build
javac -d build src\com\example\framework\FrontServlet.java
if %ERRORLEVEL% NEQ 0 (
    echo Compilation failed!
    exit /b %ERRORLEVEL%
)

echo Creating framework.jar...
cd build
jar cvf ..\framework.jar .
cd ..
if %ERRORLEVEL% NEQ 0 (
    echo JAR creation failed!
    exit /b %ERRORLEVEL%
)

echo Copying framework.jar to test project...
mkdir ..\test\WEB-INF\lib
copy framework.jar ..\test\WEB-INF\lib\framework.jar
if %ERRORLEVEL% NEQ 0 (
    echo Copy failed!
    exit /b %ERRORLEVEL%
)

echo Framework JAR created and copied to test/WEB-INF/lib