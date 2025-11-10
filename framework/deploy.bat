@echo off
setlocal EnableDelayedExpansion

echo Compiling framework...
set "LIB_DIR=%CD%\lib"
set "SERVLET_JAR=%LIB_DIR%\servlet-api.jar"
if not exist "!SERVLET_JAR!" (
    echo Error: jakarta.servlet-api.jar not found in %LIB_DIR%. Please copy it from your Tomcat installation ^(e.g., C:\tomcat\lib\jakarta.servlet-api.jar^).
    exit /b 1
)
set "CLASSPATH=!SERVLET_JAR!"
echo Using CLASSPATH: !CLASSPATH!

mkdir "%CD%\build" 2>nul
set "SRC_FILES="
for %%F in ("%CD%\src\com\framework\*.java") do (
    set "SRC_FILES=!SRC_FILES! "%%F""
)
if "!SRC_FILES!"=="" (
    echo Error: No .java files found in %CD%\src\com\framework\
    exit /b 1
)
javac -cp "!CLASSPATH!" -d "%CD%\build" !SRC_FILES!
if !ERRORLEVEL! NEQ 0 (
    echo Compilation failed!
    exit /b !ERRORLEVEL!
)

echo Creating framework.jar...
cd "%CD%\build"
jar cvf "%CD%\framework.jar" .
cd "%CD%"
if !ERRORLEVEL! NEQ 0 (
    echo JAR creation failed!
    exit /b !ERRORLEVEL!
)

echo Copying framework.jar to test project...
mkdir "%CD%\..\test\WEB-INF\lib" 2>nul
copy "%CD%\framework.jar" "%CD%\..\test\WEB-INF\lib\framework.jar"
if !ERRORLEVEL! NEQ 0 (
    echo Copy failed!
    exit /b !ERRORLEVEL!
)

echo Framework JAR created and copied to test/WEB-INF/lib
endlocal