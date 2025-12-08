@echo off
setlocal enabledelayedexpansion

@REM chemin de apache tomcat sous linux :  /home/faniry/Documents/apache-tomcat-10.1.48

:: Déclaration des variables
set "work_dir=D:\MES DOCUMENTS\S5\MRnaina\FrameworkS5\test_project_new"
set "web_apps=D:\MES DOCUMENTS\S5\apache-tomcat-10.1.28\webapps"
set "war_name=test_project"

:: Effacer le fichier .war dans [web_apps] s'il existe
if exist "%web_apps%\%war_name%.war" (
    del /f /q "%web_apps%\%war_name%.war"
)

:: Copier le fichier .war vers [web_apps]
copy /y "%work_dir%\target\%war_name%.war" "%web_apps%"

echo Déploiement terminé.
pause
