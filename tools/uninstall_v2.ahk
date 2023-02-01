#NoTrayIcon
#SingleInstance Force
#Warn
DetectHiddenWindows "On"
SetWinDelay 100
SetTitleMatchMode 3 ;Exact
SetControlDelay -1
DetectHiddenText "Off"
SendMode "Input"

WindowTitleText := "Dashboard Installer" ;Title text should not change, regardless of language selection
WindowClass := "TESTSETUP"
WindowTitle := WindowTitleText " ahk_class " WindowClass

WinWait WindowTitle
WinMinimize WindowTitle

ControlClick "Button1", WindowTitle,,,, "NA"

IsFinished := 0
while (IsFinished = 0)
{
    Sleep 250
    IsFinished := ControlGetVisible("Button1", WindowTitle)
}

WinWait WindowTitle
ControlClick "Button1", WindowTitle,,,, "NA"
ExitApp
