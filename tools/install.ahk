HasValue(array, searchValue)
{
    if !(IsObject(array)) || (array.Length() = 0)
    {
        return 0
    }

    for index, value in array
    {
        if (value = searchValue)
        {
            return index
        }
    }

    return 0
}

#NoEnv
#NoTrayIcon
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

LanguageComboBox = ComboBox1
for index, value in A_Args
{
    ArgumentPrefix := "/language:"
    FoundPos := InStr(value, ArgumentPrefix)
    if (FoundPos != 0)
    {
        LanguageSelection := SubStr(value, 1 + StrLen(ArgumentPrefix))
        Control, ChooseString, %LanguageSelection%, %LanguageComboBox%, %WindowTitle%
        break
    }
}

InstallButton = Button1
ControlClick, %InstallButton%, %WindowTitle%,,,, NA

FinishButton = Button1
IsFinished = 0
while (IsFinished = 0)
{
    Sleep 250
    ControlGet, IsFinished, Visible,, %FinishButton%, %WindowTitle%
}

WinWait, %WindowTitle%

if (HasValue(A_Args, "/start") == 0)
{
    ;Launch Dashboard "CheckBox" (button) is "checked" by default
    ;"Uncheck" it to prevent software from launching
    LaunchDashboardCheckBox = Button3
    ControlClick, %LaunchDashboardCheckBox%, %WindowTitle%,,,, NA
}

ControlClick, %FinishButton%, %WindowTitle%,,,, NA
ExitApp
