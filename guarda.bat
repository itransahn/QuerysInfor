@echo off
set /P Usuario=Ingrese su usario GitHub:
TITLE Bienvenid@ %Usuario% a Ransa
MODE con:cols=80 lines=40

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "AA=%dt:~2,2%"
set "AAAA=%dt:~0,4%"
set "MM=%dt:~4,2%"
set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%"
set "Min=%dt:~10,2%"
set "Seg=%dt:~12,2%"
set "dia_hora=%AAAA%_%MM%_%DD%_%HH%_%Min%_%Seg%"

:inicio
color 0F
cls
echo 1. Cargar Actualizacion
echo 2. Actualizar Rama de orige
echo 3. Comandos manuales
echo Q. Salir
set /P tarea=Ingrese Valor de tarea:
if "%tarea%"=="0" goto op0
if "%tarea%"=="1" goto op1
if "%tarea%"=="2" goto op2
if "%tarea%"=="3" goto op3
if "%tarea%"=="q" goto salir
if "%tarea%"=="Q" goto salir

::Mensaje de error, validación cuando se selecciona una opción fuera de rango
echo. El numero "%tarea%" no es una opcion valida, por favor intente de nuevo.
echo.
pause
echo.
goto:inicio

:op1
    echo.
    set /P COMENTARIO=Ingrese un comentario:
	git add .
	git commit -m %COMENTARIO%_%dia_hora%
	push -u origin %Usuario%
	::git push -u origin Dandino	
    pause
    goto:inicio

:op2
    echo.
    git pull origin %Usuario%
	::git pull origin Dandino
    echo.
    pause
    goto:inicio

:op3
    cls
    color 0A
    echo.
    echo. Se ejecutaran los comando manuales
    echo.
	    set /P comando=Ingrese Comando:
		if "%comando%"=="quit" goto inicio
		if  "%comando%" NEQ "q" goto op4
        ::Aquí van las líneas de comando de tu opción
  
:op4
    echo.
    echo. Se ejecuto "%comando%"
    echo.
	%comando%
    echo.
    pause
    goto:op3

:op5
    echo.
    echo. Has elegido la opcion No. 5
    echo.
        ::Aquí van las líneas de comando de tu opción
        color 0C
    echo.
    pause
    goto:inicio

:salir
    @cls&exit

pause