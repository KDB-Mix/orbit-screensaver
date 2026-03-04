!include "MUI2.nsh"
!include "LogicLib.nsh"

Name "Orbit Screensaver"
OutFile "orbit-setup.exe"
InstallDir "$LOCALAPPDATA\orbit"
RequestExecutionLevel admin

Var MesaAnswer

!define MUI_ABORTWARNING

!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"





Section "Install"
    ; ask about mesa3d before installing
    MessageBox MB_YESNO|MB_ICONQUESTION "Is your PC a potato? (No dedicated GPU / very old integrated graphics)$\n$\nInclude Mesa3D software OpenGL renderer?$\n(Only needed if you get a black screen or missing graphics)" IDYES DoMesa IDNO SkipMesa
    DoMesa:
        StrCpy $MesaAnswer "yes"
    SkipMesa:

    SetOutPath "$LOCALAPPDATA\orbit"

    File "orbit_screensaver.exe"
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

    ${If} $MesaAnswer == "yes"
        DetailPrint "Downloading Mesa3D OpenGL..."
        inetc::get /CAPTION "Downloading Mesa3D..." /BANNER "Fetching OpenGL software renderer..." "https://github.com/MalikHw/orbit-screensaver-cpp/releases/download/mesa3d/opengl32.dll" "$LOCALAPPDATA\orbit\opengl32.dll" /END
        Pop $0
        ${If} $0 != "OK"
            MessageBox MB_OK|MB_ICONEXCLAMATION "Failed to download Mesa3D: $0$\nYou can manually download opengl32.dll and place it in $LOCALAPPDATA\orbit\"
        ${EndIf}
    ${EndIf}

    ; stub scr to system32
    File /oname=$SYSDIR\orbit_screensaver.scr "orbit_stub.scr"

    ; registry
    WriteRegStr HKCU "Software\Orbit" "InstallDir" "$LOCALAPPDATA\orbit"
    WriteRegStr HKCU "Control Panel\Desktop" "SCRNSAVE.EXE" "$SYSDIR\orbit_screensaver.scr"

    ; open windows screensaver dialog
    Exec "control.exe desk.cpl,,@screensaver"
SectionEnd
