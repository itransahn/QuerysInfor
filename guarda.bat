@echo off

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "AA=%dt:~2,2%"
set "AAAA=%dt:~0,4%"
set "MM=%dt:~4,2%"
set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%"
set "Min=%dt:~10,2%"
set "Seg=%dt:~12,2%"
set "dia_hora=%AAAA%_%MM%_%DD%_%HH%_%Min%_%Seg%"

:Menu
cls
echo 1. Cargar Actualizacion
echo 2. Actualizar Rama de orige
echo Q. Salir
set /P tarea=Ingrese Valor de tarea:

if %tarea%==1 set /P COMENTARIO=Ingrese un comentario:
git add .
git commit -m %COMENTARIO%_%dia_hora%
git push -u origin Dandino
pause
goto :Menu 

if %tarea%==2 git pull origin Dandino
pause
goto :Menu

if %tarea%==Q echo adios

if %tarea%==q echo adios
::CASEALL

::[DEFAULT]

pause