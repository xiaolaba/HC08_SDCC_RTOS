
::@echo off
prompt xiaolaba $g$s
@echo.
@echo Compiling main.c for mc68hc908gp32 using SDCC-M08...
@echo by xiaolaba 2025-JAN-26, testing done, win10/win11 SDCC



:: Set the path to SDCC (if not already in system PATH)
:: ### SDCC download
:: https://sdcc.sourceforge.net/index.php#Download  
:: sdcc-4.4.0-setup.exe  
:: installed path,  
:: C:\Program Files (x86)\SDCC
set SDCC_PATH="C:\Program Files (x86)\SDCC"
set PATH=%SDCC_PATH%;%PATH%

:::: example
:::: compile multiple C files
::sdcc -c -mhc08 --data-loc 0x80 --code-loc %ROM% --stack-loc 0xFF sub1.c
::sdcc -c -mhc08 --data-loc 0x80 --code-loc %ROM% --stack-loc 0xFF sub2.c
::sdcc    -mhc08 --data-loc 0x80 --code-loc %ROM% --stack-loc 0xFF main.c sub1.rel sub2.rel

:::: then link them 
::sdcc    -mhc08 --data-loc 0x80 --code-loc %ROM% --stack-loc 0xFF -o main.s19 main.rel sub1.rel sub2.rel 




::# Source directory, *.c & *.h
set SRC=src
::Intermediate files directory (object files and other build artifacts)
set OBJ=obj
mkdir obj

::Firmware output directory (final .S19 file)
mkdir firmware
set FIRMWARE_FILE=firmware/hc908rtos_win11_build.S19

::mc68hc908gp32
set STACK=0x1BF
set RAM=0x40
set ROM=0xEE00



:::: compile multiple C files, and assembly, outout to obj folder
sdcc -mhc08 --data-loc %RAM% --stack-loc %STACK% --code-loc %ROM% -Isrc -c %SRC%\app.c -o %OBJ%\app.rel
sdcc -mhc08 --data-loc %RAM% --stack-loc %STACK% --code-loc %ROM% -Isrc -c %SRC%\console.c -o %OBJ%\console.rel
sdcc -mhc08 --data-loc %RAM% --stack-loc %STACK% --code-loc %ROM% -Isrc -c %SRC%\ipc.c -o %OBJ%\ipc.rel
sdcc -mhc08 --data-loc %RAM% --stack-loc %STACK% --code-loc %ROM% -Isrc -c %SRC%\main.c -o %OBJ%\main.rel
sdcc -mhc08 --data-loc %RAM% --stack-loc %STACK% --code-loc %ROM% -Isrc -c %SRC%\rtc.c -o %OBJ%\rtc.rel
sdcc -mhc08 --data-loc %RAM% --stack-loc %STACK% --code-loc %ROM% -Isrc -c %SRC%\sci.c -o %OBJ%\sci.rel
sdcc -mhc08 --data-loc %RAM% --stack-loc %STACK% --code-loc %ROM% -Isrc -c %SRC%\stdio.c -o %OBJ%\stdio.rel
sdcc -mhc08 --data-loc %RAM% --stack-loc %STACK% --code-loc %ROM% -Isrc -c %SRC%\strings.c -o %OBJ%\strings.rel


:::: then link them, save S19 file to firmware folder
sdcc -mhc08 --data-loc %RAM% --stack-loc %STACK% --code-loc %ROM% -o %FIRMWARE_FILE% ^
%OBJ%\app.rel ^
%OBJ%\console.rel ^
%OBJ%\ipc.rel ^
%OBJ%\main.rel ^
%OBJ%\rtc.rel ^
%OBJ%\sci.rel ^
%OBJ%\stdio.rel ^
%OBJ%\strings.rel







:: Check if the HEX file was generated
if exist %FIRMWARE_FILE% (
    @echo Compilation successful!!! HEX file: %FIRMWARE_FILE%
) else (
    @echo Compilation failed! Check for errors.
)

@echo off

::clean.bat

pause