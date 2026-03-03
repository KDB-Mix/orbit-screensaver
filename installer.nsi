!include "MUI2.nsh"

Name "Orbit Screensaver"
OutFile "orbit-setup.exe"
InstallDir "$LOCALAPPDATA\orbit"
RequestExecutionLevel user

!define MUI_ABORTWARNING
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

Section "Install"
    SetOutPath "$LOCALAPPDATA\orbit"
    
    ; assets + dlls
    File "orbit_screensaver.scr"
    File "SDL2.dll"
    File "SDL2_image.dll"
    File /nonfatal "libgcc_s_seh-1.dll"
    File /nonfatal "libstdc++-6.dll"
    File /nonfatal "libwinpthread-1.dll"
    File "orb1.png"
    File "orb2.png"
    File "orb3.png"
    File "orb4.png"
    File "orb5.png"
    File "orb6.png"
    File "orb7.png"
    File "orb8.png"
    File "orb9.png"
    File "orb10.png"
    File "cube.png"

    ; copy scr to system32 so windows sees it
    CopyFiles "$LOCALAPPDATA\orbit\orbit_screensaver.scr" "$SYSDIR\orbit_screensaver.scr"

    ; write install path to registry so scr finds assets
    WriteRegStr HKCU "Software\Orbit" "InstallDir" "$LOCALAPPDATA\orbit"

    ; open settings ui
    Exec '"$SYSDIR\orbit_screensaver.scr" /c'
SectionEnd
