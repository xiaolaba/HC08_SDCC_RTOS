::del *.S19 *.rst *.rel *.asm *.lst *.lk *.sym *.map

:: del folder obj & all files inside, no prompt
rmdir /s /q obj
::rmdir /s /q firmware
