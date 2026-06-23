@echo off
REM Build BetterSpades for WebAssembly using Emscripten
REM
REM Prerequisites:
REM   - Emscripten SDK (emsdk) installed and activated
REM   - Run: emsdk_env.bat
REM
REM Installation (if emsdk not installed):
REM   git clone https://github.com/emscripten-core/emsdk.git
REM   cd emsdk
REM   emsdk install latest
REM   emsdk activate latest
REM   emsdk_env.bat

echo === BetterSpades WebAssembly Build ===

REM Check for emcc
where emcc >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: emcc not found. Please install and activate Emscripten SDK first.
    echo.
    echo Quick install:
    echo   git clone https://github.com/emscripten-core/emsdk.git
    echo   cd emsdk
    echo   emsdk install latest
    echo   emsdk activate latest
    echo   emsdk_env.bat
    exit /b 1
)

set BUILD_DIR=%~dp0build-wasm

mkdir "%BUILD_DIR%" 2>nul
cd /d "%BUILD_DIR%"

REM Clean previous build
del /q CMakeCache.txt 2>nul

REM Configure with Emscripten toolchain
echo === Configuring ===
emcmake cmake "%~dp0" ^
    -DENABLE_GLFW=ON ^
    -DENABLE_SDL=OFF ^
    -DENABLE_SOUND=ON ^
    -DENABLE_RPC=OFF ^
    -DENABLE_OPENGLES=OFF ^
    -DENABLE_TOUCH=OFF ^
    -DCMAKE_BUILD_TYPE=Release

if %ERRORLEVEL% neq 0 (
    echo CMake configuration failed!
    exit /b 1
)

REM Build
echo.
echo === Building ===
emmake make -j4

if %ERRORLEVEL% neq 0 (
    echo Build failed!
    exit /b 1
)

echo.
echo === Build complete ===
echo Output: %BUILD_DIR%\BetterSpades\
dir /b "%BUILD_DIR%\BetterSpades\*.html" "%BUILD_DIR%\BetterSpades\*.js" "%BUILD_DIR%\BetterSpades\*.wasm" 2>nul
echo.
echo To serve locally:
echo   cd %BUILD_DIR%\BetterSpades ^&^& python -m http.server 8080
echo   Open http://localhost:8080/client.html
