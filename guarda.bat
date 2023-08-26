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

git add .

::git pull origin Dandino

git commit -m %dia_hora%

git push -u origin Dandino

pause