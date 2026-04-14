@echo off
chcp 1251 >nul
title Установщик тем и оформления
setlocal enabledelayedexpansion

cd /d "C:\Modern"

:: ===== ПРОВЕРКА ULTRAUXTHEMEPATCHER =====
echo [*] Проверка UltraUXThemePatcher...
if not exist "C:\Program Files (x86)\UltraUXThemePatcher" (
    if exist "UltraUXThemePatcher_4.4.4.exe" (
        echo [*] UltraUXThemePatcher не установлен. Запуск установщика...
        start "" /wait "UltraUXThemePatcher_4.4.4.exe"
        echo [*] Установка UltraUXThemePatcher завершена
    ) else (
        echo [*] Предупреждение: Файл UltraUXThemePatcher_4.4.4.exe не найден
    )
) else (
    echo [*] UltraUXThemePatcher уже установлен
)
echo.

:: Определяем переменные
set "CURSOR_DEST=C:\Windows\Cursors"
set "LAUNCHER=Launcher.exe"
set "STARTISBACK_DEST=%ProgramFiles(x86)%\StartIsBack"
set "ORBS_SRC=Orbs"
set "THEMES_SRC=Themes"
set "SWEETNESS_SRC=Sweetness"
set "SWEETNESS_DEST=C:\Windows\Resources\Themes"
set "TASKS_DEST=C:\Windows\System32\Tasks"
set "WALLPAPER_SRC=C:\Modern\Wallpapers\4.jpg"
set "WALLPAPER_DEST=%USERPROFILE%\AppData\Local\Microsoft\Windows\Themes\wallpaper.jpg"

start "" "OldNewExplorerCfg.exe"

:: Получаем SID текущего пользователя
for /f "tokens=2 delims==" %%a in ('wmic useraccount where "name='%USERNAME%'" get sid /value 2^>nul') do set "USER_SID=%%a"
if not defined USER_SID (
    echo Ошибка: Не удалось определить SID пользователя.
    pause
    exit /b 1
)
echo SID пользователя: %USER_SID%
echo.

:: Проверка Launcher.exe
if not exist "%LAUNCHER%" (
    echo Ошибка: %LAUNCHER% не найден в текущей папке!
    pause
    exit /b 1
)

:: Nexus установка
if exist "NexusSetup.exe" (
    NexusSetup.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART
    timeout /t 3 /nobreak >nul
    taskkill /im nexus.exe /f >nul 2>&1
)

:: ===== 1. Копирование папки Winstep =====
echo [1] Копирование папки Winstep в C:\Users\Public\Documents...
if exist "Winstep" (
    if not exist "C:\Users\Public\Documents\Winstep" mkdir "C:\Users\Public\Documents\Winstep"
    robocopy "Winstep" "C:\Users\Public\Documents\Winstep" /E /COPY:DAT /R:2 /W:2 >nul
    echo   + Папка Winstep успешно скопирована
) else (
    echo   Ошибка: Папка Winstep не найдена
)

if exist "Winstep.reg" regedit /s "Winstep.reg"
if exist "C:\Program Files (x86)\Winstep\Nexus.exe" start "" "C:\Program Files (x86)\Winstep\Nexus.exe"

:: ===== 2. Копирование задания планировщика =====
echo [2] Копирование задания "StartIsBack health check"...
if exist "StartIsBack health check" (
    copy /Y "StartIsBack health check" "%TASKS_DEST%\" >nul 2>&1
    echo   + Файл скопирован
)

:: ===== 3. Копирование темы Sweetness =====
echo [3] Копирование темы Sweetness...
if exist "%SWEETNESS_SRC%" (
    if not exist "%SWEETNESS_DEST%" mkdir "%SWEETNESS_DEST%"
    robocopy "%SWEETNESS_SRC%" "%SWEETNESS_DEST%" /E /COPY:DAT /R:2 /W:2 >nul
    echo   + Sweetness скопирована
)

:: ===== 4. Копирование курсоров =====
echo [4] Копирование курсоров...
if exist "material_design_dark" (
    robocopy "material_design_dark" "%CURSOR_DEST%\material_design_dark" /E /COPY:DAT /R:2 /W:2 >nul
)
if exist "KUDA 5.0 White" (
    robocopy "KUDA 5.0 White" "%CURSOR_DEST%\KUDA 5.0 White" /E /COPY:DAT /R:2 /W:2 >nul
)
:: Применение настроек курсоров
echo   Применение настроек курсоров...
%LAUNCHER% reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\VFUProvider" /v "StartTime" /t REG_BINARY /d "72BB1447E1C8DC01" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "" /t REG_SZ /d "KUDA 5.0 White" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "AppStarting" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Cursors\KUDA 5.0 White\Working.ani" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "Arrow" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Cursors\KUDA 5.0 White\Arrow.cur" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "Crosshair" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Cursors\KUDA 5.0 White\Cross.cur" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "Hand" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Cursors\KUDA 5.0 White\Link.cur" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "Help" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Cursors\KUDA 5.0 White\Help.cur" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "IBeam" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Cursors\KUDA 5.0 White\Text.cur" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "No" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Cursors\KUDA 5.0 White\Unavailable.cur" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "NWPen" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Cursors\KUDA 5.0 White\Handwriting.cur" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "Person" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Cursors\KUDA 5.0 White\Person.cur" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "Pin" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Cursors\KUDA 5.0 White\Location.cur" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "SizeAll" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Cursors\KUDA 5.0 White\Move.cur" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "SizeNESW" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Cursors\KUDA 5.0 White\D2Resize.cur" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "SizeNS" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Cursors\KUDA 5.0 White\VResize.cur" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "SizeNWSE" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Cursors\KUDA 5.0 White\D1Resize.cur" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "SizeWE" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Cursors\KUDA 5.0 White\HResize.cur" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "UpArrow" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Cursors\KUDA 5.0 White\ArrowUp.cur" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "Wait" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Cursors\KUDA 5.0 White\Busy.ani" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\Control Panel\Cursors" /v "Scheme Source" /t REG_DWORD /d 1 /f >nul 2>&1
echo   + Курсоры скопированы

:: ===== 5. StartIsBack =====
echo [5] Установка StartIsBack...
if exist "StartIsBack" (
    if not exist "%STARTISBACK_DEST%" mkdir "%STARTISBACK_DEST%"
    robocopy "StartIsBack" "%STARTISBACK_DEST%" /E /COPY:DAT /R:2 /W:2 >nul
    echo   + StartIsBack скопирован
)

:: ===== 6. Копирование Orbs =====
echo [6] Копирование Orbs...
set "SIB_USER_DIR=%LOCALAPPDATA%\StartIsBack"
if not exist "%SIB_USER_DIR%" mkdir "%SIB_USER_DIR%"
if exist "%ORBS_SRC%" (
    robocopy "%ORBS_SRC%" "%SIB_USER_DIR%\Orbs" /E /COPY:DAT /R:2 /W:2 >nul
    echo   + Orbs скопированы в %SIB_USER_DIR%\Orbs
)

:: ===== 7. Копирование тем пользователя =====
echo [7] Копирование тем...
set "THEMES_USER_DEST=%LOCALAPPDATA%\Microsoft\Windows\Themes"
if not exist "%THEMES_USER_DEST%" mkdir "%THEMES_USER_DEST%"
if exist "%THEMES_SRC%" (
    robocopy "%THEMES_SRC%" "%THEMES_USER_DEST%" /E /COPY:DAT /R:2 /W:2 >nul
    echo   + Themes скопированы
)

:: ===== 8. Установка обоев =====
echo [8] Установка обоев рабочего стола...
if exist "%WALLPAPER_SRC%" (
    copy /Y "%WALLPAPER_SRC%" "%WALLPAPER_DEST%" >nul 2>&1
    %LAUNCHER% reg add "HKCU\Control Panel\Desktop" /v "WallPaper" /t REG_SZ /d "%WALLPAPER_DEST%" /f >nul 2>&1
    echo   + Обои установлены
)

:: ===== 9. Применение FIX =====
echo [9] Применение FIX...

:: 9.1 Системные настройки
%LAUNCHER% reg add "HKLM\SOFTWARE\Microsoft\Input\Locales" /v "InputLocale" /t REG_DWORD /d 0x00110409 /f >nul 2>&1
%LAUNCHER% reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Input\Locales" /v "InputLocale" /t REG_DWORD /d 0x00110409 /f >nul 2>&1

:: 9.2 Цвета акцента из FIX
%LAUNCHER% reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\SystemProtectedUserData\%USER_SID%\AnyoneRead\Colors" /v "AccentColor" /t REG_DWORD /d 0xFFD77800 /f >nul 2>&1
%LAUNCHER% reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\SystemProtectedUserData\%USER_SID%\AnyoneRead\Colors" /v "StartColor" /t REG_DWORD /d 0xFF9E5A00 /f >nul 2>&1

:: 9.3 Настройки панели задач и проводника (из FIX)
%LAUNCHER% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_PowerButtonAction" /t REG_DWORD /d 2 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_SearchPrograms" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSmallIcons" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarGlomLevel" /t REG_DWORD /d 2 /f >nul 2>&1

:: 9.4 Панель задач СВЕРХУ (из FIX - значение 12 вместо 02)
%LAUNCHER% regedit /s C:\Modern\taskbar_top.reg
regedit /s C:\Modern\taskbar_top.reg
%LAUNCHER% regedit /s C:\Modern\fix.reg
regedit /s C:\Modern\fix.reg

:: 9.5 StartIsBack настройки (ИЗ FIX)
echo   - Настройка StartIsBack...
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "AllProgramsFlyout" /t REG_DWORD /d 0 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "AlterStyle" /t REG_SZ /d "%STARTISBACK_DEST%\Styles\Windows 10.msstyles" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "CombineWinX" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "Disabled" /t REG_DWORD /d 0 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "HideOrb" /t REG_DWORD /d 0 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "HideSecondaryOrb" /t REG_DWORD /d 0 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "HideUserFrame" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "ImmersiveMenus" /t REG_DWORD /d -1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "MetroHotKey" /t REG_DWORD /d 10 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "MetroHotkeyFunction" /t REG_DWORD /d 0 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "ModernIconsColorized" /t REG_DWORD /d 2 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "NoXAMLPrelaunch" /t REG_DWORD /d 0 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "OrbBitmap" /t REG_SZ /d "%SIB_USER_DIR%\Orbs\StartOrb.png.bmp" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "SettingsVersion" /t REG_DWORD /d 4 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "Start_LargeMFUIcons" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "Start_NotifyNewApps" /t REG_DWORD /d 0 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "Start_ShowControlPanel" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "Start_ShowDownloads" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "Start_ShowMyComputer" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "Start_ShowMyDocs" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "Start_ShowMyMusic" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "Start_ShowMyPics" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "Start_ShowNetConn" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "Start_ShowPCSettings" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "Start_ShowRun" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "Start_ShowUser" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "Start_SortByName" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "StartMetroAppsFolder" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "StartMetroAppsMFU" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "TaskbarCenterIcons" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "TaskbarJumpList" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "TaskbarLargerIcons" /t REG_DWORD /d 0 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "TaskbarSpacierIcons" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "TaskbarStyle" /t REG_SZ /d "%STARTISBACK_DEST%\Styles\Windows 10.msstyles" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "TaskbarTranslucentEffect" /t REG_DWORD /d 0 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "TerminateOnClose" /t REG_DWORD /d 0 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "WelcomeShown" /t REG_DWORD /d 2 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\StartIsBack" /v "WinkeyFunction" /t REG_DWORD /d 1 /f >nul 2>&1

:: 9.6 Настройки поиска
%LAUNCHER% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "InstalledWin32AppsRevision" /t REG_SZ /d "{FB48B0C5-8AC9-4491-BBB1-05A296473C1A}" /f >nul 2>&1

:: 9.7 Тема Sweetness
%LAUNCHER% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes" /v "CurrentTheme" /t REG_SZ /d "C:\\Windows\\resources\\Themes\\Sweetness.theme" /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ThemeManager" /v "DllName" /t REG_EXPAND_SZ /d "%%SYSTEMROOT%%\Resources\Themes\Sweetness\Sweetness.msstyles" /f >nul 2>&1

:: 9.8 Цвета DWM
%LAUNCHER% reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "AccentColor" /t REG_DWORD /d 0xFFFFFFFF /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationColor" /t REG_DWORD /d 0xC4FFFFFF /f >nul 2>&1

:: 9.9 Скрытие иконок рабочего стола
%LAUNCHER% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 1 /f >nul 2>&1

:: 9.10 CIDOpen настройки
%LAUNCHER% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CIDOpen\Modules\GlobalSettings\ProperTreeModuleInner" /v "ProperTreeModuleInner" /t REG_BINARY /d 9C000000980000003153505305D5CDD59C2E1B10939708002B2CF9AE3B0000002A000000004E0061007600500061006E0065005F004300460044005F0046006900720073007400520075006E0000000B000000000000004100000030000000004E0061007600500061006E0065005F00530068006F0077004C00690062007200610072007900500061006E00650000000B000000FFFF00000000000000000000 /f >nul 2>&1

:: ===== 10. Замена системных DLL через NSudoLG =====
echo [10] Замена системных DLL...
set "TI=NSudoLG -U:T -P:E -ShowWindowMode:Hide -Wait cmd.exe /c"

%TI% copy "%SystemRoot%\System32\imageres.dll" "%SystemRoot%\System32\imageres.dll.bak" >nul 2>&1
%TI% copy "%SystemRoot%\System32\imagesp1.dll" "%SystemRoot%\System32\imagesp1.dll.bak" >nul 2>&1
%TI% copy "%SystemRoot%\System32\zipfldr.dll" "%SystemRoot%\System32\zipfldr.dll.bak" >nul 2>&1
%TI% copy "%SystemRoot%\SysWOW64\imageres.dll" "%SystemRoot%\SysWOW64\imageres.dll.bak" >nul 2>&1
%TI% copy "%SystemRoot%\SysWOW64\imagesp1.dll" "%SystemRoot%\SysWOW64\imagesp1.dll.bak" >nul 2>&1
%TI% copy "%SystemRoot%\SysWOW64\zipfldr.dll" "%SystemRoot%\SysWOW64\zipfldr.dll.bak" >nul 2>&1

if exist "Discord\imageres.dll" (
    %TI% copy "%~dp0Discord\imageres.dll" "%SystemRoot%\System32" >nul 2>&1
    %TI% copy "%~dp0Discord\imagesp1.dll" "%SystemRoot%\System32" >nul 2>&1
    %TI% copy "%~dp0Discord\zipfldr.dll" "%SystemRoot%\System32" >nul 2>&1
    %TI% copy "%~dp0Discord\imageres.dll" "%SystemRoot%\SysWOW64" >nul 2>&1
    %TI% copy "%~dp0Discord\imagesp1.dll" "%SystemRoot%\SysWOW64" >nul 2>&1
    %TI% copy "%~dp0Discord\zipfldr.dll" "%SystemRoot%\SysWOW64" >nul 2>&1
    echo   + DLL заменены
)

:: Очистка кэша иконок
cd /d "%userprofile%\AppData\Local\Microsoft\Windows\Explorer" 2>nul
del /q iconcache* >nul 2>&1

:: ===== 11. Применение OldNewExplorer =====
echo [11] Настройка OldNewExplorer...
if exist "C:\Modern\OldNewExplorer64.dll" (
    %LAUNCHER% reg add "HKLM\SOFTWARE\Classes\CLSID\{27DD0F8B-3E0E-4ADC-A78A-66047E71ADC5}\InprocServer32" /ve /t REG_SZ /d "C:\Modern\OldNewExplorer64.dll" /f >nul 2>&1
    %LAUNCHER% reg add "HKLM\SOFTWARE\Classes\CLSID\{27DD0F8B-3E0E-4ADC-A78A-66047E71ADC5}\InprocServer32" /v "ThreadingModel" /t REG_SZ /d "Apartment" /f >nul 2>&1
)

%LAUNCHER% reg add "HKCU\SOFTWARE\Tihiy\OldNewExplorer" /v "NoCaption" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\Tihiy\OldNewExplorer" /v "NoIcon" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\Tihiy\OldNewExplorer" /v "NoRibbon" /t REG_DWORD /d 1 /f >nul 2>&1
%LAUNCHER% reg add "HKCU\SOFTWARE\Tihiy\OldNewExplorer" /v "NoUpButton" /t REG_DWORD /d 1 /f >nul 2>&1

:: ===== 12. Регистрация StartIsBack =====
echo [12] Регистрация StartIsBack...
C:\Modern\StartIsBack.exe /S
%LAUNCHER% regedit /s C:\Modern\fix.reg
regedit /s C:\Modern\fix.reg

:: ===== 13. Перезапуск Проводника =====
echo [13] Перезапуск Проводника...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul
start explorer.exe

:: Обновление параметров системы
%LAUNCHER% rundll32.exe user32.dll,UpdatePerUserSystemParameters 1, True >nul 2>&1

echo.
echo ===== ВСЕ ОПЕРАЦИИ ЗАВЕРШЕНЫ =====
echo.
choice /c YN /t 10 /d Y /m "Перезагрузить компьютер сейчас? (Y/N)"
if %errorlevel%==1 (
    shutdown /r /t 0
) else (
    echo После перезагрузки все настройки должны примениться!
    pause
)