
@echo off

setlocal EnableDelayedExpansion

set CWD=%~dp0
set ABS_PATH=

rem // Save current directory and change to target directory
pushd %CWD%

rem // Save value of CD variable (current directory)
FOR /F "delims=" %%A in ("%CD%\..") do set "ABS_PATH=%%~fA"

rem // Restore original directory
popd

set SOURCE=%ABS_PATH%\js\source
set BUILD=%ABS_PATH%\js\build
echo %SOURCE%

REM call babel --presets react,es2015 ../js/source -d ../js/build

call babel --presets react,es2015 %SOURCE% -d %BUILD%
REM call browserify ../js/build/app.js -o ../bundle.js
call browserify %BUILD%\app.js -o %ABS_PATH%\bundle.js

copy /b /y %ABS_PATH%\css\*.css+%ABS_PATH%\css\components\*.css %ABS_PATH%\bundle.css
powershell -Command "& {(Get-Content %ABS_PATH%\bundle.css) | ForEach-Object { $_ -replace '../../images','images' } | Set-Content %ABS_PATH%\bundle.css;}"

REM call (Get-Content ../bundle.css) | ForEach-Object { $_ -replace '../../images','images' } | Set-Content ../bundle.css