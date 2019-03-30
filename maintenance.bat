@echo off 
echo.
echo.
echo.
echo *******************************************************************
echo *******************************************************************
echo **     Ferramenta de manutencao preventiva para Windows          **
echo **			  compatibilidade: 7, 8, 8.1 e 10                     **
echo **        Inicie este script em modo administrador.              **  
echo *******************************************************************
echo **          Ao finalizar o computador sera reiniciado            ** 
echo *******************************************************************
echo **           Pode levar varios minutos para finalizar            ** 
echo **                  Por Felipe Schorles                          ** 
echo *******************************************************************
echo.*******************************************************************
echo.
pause

cls

color f1
echo *******************************************************************
echo **                                                               ** 
echo **           Coletando informacoes sobre o sistema               **
echo **                                                               **
echo *******************************************************************
echo.
echo.

call :carrega 8 "********* LIMPANDO TEMPORARIOS DE INTERNET *******
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
echo.
echo.

call :carrega 8 "********* LIMPANDO COOKIES ***********"
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2
echo.
echo.

call :carrega 8 "******* LIMPANDO HISTORICO DE INTERNET *******
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 16 
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 32
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 4351
echo.
echo.

call :carrega 8 "********* LIMPANDO CACHE DE DNS **********"
ipconfig /flushdns
echo.
echo.
call :carrega 8 "iniciando..."

call :carrega 8 "********* RECRIANDO IP **********"
ipconfig /release
echo.
ipconfig /renew
echo.
echo.

:carrega
set ver=%2
set ver=%ver:"= %
Echo %ver%
echo.
Echo Carregando aguarde 

:BARRA
SET /A N+=1
tree %systemroot%\system32>nul
set /p=.<nul
IF %N%==%1 (SET N=0&set /p=OK<nul&ping -n 0,1 localhost >nul&Echo.&Echo.&GOTO:EOF) ELSE (GOTO BARRA)

@echo Off
Set /a Progres=0

:progres
Set /a Progres=%Progres%+1
Echo %Progres%%% Concluido
Title %Progres%%%
If %Progres% == 100 (Goto Concl)
If %Progres% == 99 (Ping -N 2 "Localhost" >nul)
Ping -N 1 "Localhost" >nul

Goto Progres

:concl

Title Concluido
Echo %Progres%%% Concluido
Ping -N 2 "Localhost" >nul

Echo Concluido!
Echo.

call :carrega 8 ***************** Limpa Temp usuario Presente *********************
echo.
echo.
color f4
cd C:\Windows\Temp
erase /f /q /s


call :carrega 8 *****************Limpa Temp do usuario Presente *********************
DEL /S /Q /F �%Userprofile%\Configura�oes locais\Temporary Internet Files\*.*�
FOR /D %%d IN (�%Userprofile%\Configura�oes locais\Temporary Internet Files\*.*�) DO RD /S /Q �%%d�

echo ***************** Limpa Recent Usuario *********************
DEL /S /Q /F �%userprofile%\Recent\*.*�
FOR /D %%d IN (�%Userprofile%\Recent\*.*�) DO RD /S /Q �%%d�

call :carrega 8 ***************** Limpa Temp Sistema *********************
DEL /F/S/Q %WINDIR%\*.TMP
DEL /F/S/Q %WINDIR%\TEMP\*.*
FOR /D %%d IN (�%WINDIR%\TEMP\*.*�) DO RD /S /Q �%%d�
DEL /F/S/Q %WINDIR%\Prefetch\*.*

echo ***************** Limpa Temp usuario Presente *********************
echo.
echo.
color f4
cd C:\Windows\Temp
erase /f /q /s


call :carrega 8 ***************** Removendo temporarios *********************
echo.
echo.
color f4
cd /
erase /f /q /s *.tmp


call :carrega 8 ********************** Verificar integridade do disco ****************
call :carrega 8 ******este processo pode demorar dependendo da situacao do disco *****
echo.
echo.
chkdsk /f /r
echo.
sfc/scannow
echo.
Dism /Online /Cleanup-Image /ScanHealth
echo.
Dism /Online /Cleanup-Image /RestoreHealth
echo.
echo.

echo.
echo ******************************************************************
echo ******************************************************************
echo **              Finalizado em %date% as %time%                  **
echo **             necessario reiniciar o computador                **
echo ******************************************************************
echo ******************************************************************
ECHO.
ECHO **************INFORMACOES ATUAIS SOBRE O SISTEMA******************
ECHO.
MEM
ECHO.
ECHO.
ECHO.

Call :VerHD c:

:VerHD
@SETLOCAL ENABLEEXTENSIONS
@SETLOCAL ENABLEDELAYEDEXPANSION
@FOR /F "tokens=1-3" %%n IN ('"WMIC /node:"%computername%" LOGICALDISK GET Name,Size,FreeSpace | find /i "%1""') DO @SET Bytes_Livre=%%n & @SET TotalBytes=%%p
@SET /A Espaco_Tot=!TotalBytes:~0,-9!
@SET /A Espaco_Livre=!Bytes_Livre:~0,-10!
@SET /A Total_Usado=%Espaco_Tot% - %Espaco_Livre%
@SET /A Porcent_Usado=(!Total_Usado!*100)/!Espaco_Tot!
@SET /A Porcent_Livre=100-!Porcent_Usado!
@ECHO Drive pesquisado : %1
@ECHO ------------------------------------
@ECHO Espa�o total    : %Espaco_Tot%GB
@ECHO Espa�o livre    : %Espaco_Livre%GB
@ECHO Espa�o Usados    : %Total_Usado%GB
@ECHO Ponentagem Usada : %Porcent_Usado%%%
@ECHO Ponentagem Livre : %Porcent_Livre%%%
@ECHO.
echo.
echo.
shutdown -r -t 03 -c Reiniciando Computador...
