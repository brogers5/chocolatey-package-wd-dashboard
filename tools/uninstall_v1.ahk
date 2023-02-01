#NoEnv
#NoTrayIcon
#SingleInstance Force
#Warn
DetectHiddenWindows, off
SetWinDelay, 100
SetTitleMatchMode, 3 ;Exact
SetControlDelay, -1
DetectHiddenText, off
SendMode Input

WindowTitleText = Dashboard Installer ;Title text should not change, regardless of language selection
WindowClass = TESTSETUP
WindowTitle = %WindowTitleText% ahk_class %WindowClass%

WinWait, %WindowTitle%
WinMinimize, %WindowTitle%

UninstallButton = Button1
ControlClick, %UninstallButton%, %WindowTitle%,,,, NA

FinishButton = Button1
IsFinished = 0
while (IsFinished = 0)
{
    Sleep 250
    ControlGet, IsFinished, Visible,, %FinishButton%, %WindowTitle%
}

WinWait, %WindowTitle%
ControlClick, %FinishButton%, %WindowTitle%,,,, NA
ExitApp
