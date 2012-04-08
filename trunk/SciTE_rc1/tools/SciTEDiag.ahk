;
; File encoding:  UTF-8
; Platform:  Windows XP/Vista/7
; Author:    A.N.Other <myemail@nowhere.com>
;
; Script description:
;	Template script
;

#NoEnv
SetWorkingDir, %A_ScriptDir%

SplitPath, A_AhkPath,, A_AhkDir
A_AhkDir := RegExReplace(A_AhkDir, "\\[^\\]+?$", "")

MsgBox, 36, SciTE Diagnostics Utility,
(
This program will list all the contents of the following folder and its subdirectories, which might contain sensitive information:

%A_AhkDir%

Additionally it will list all the active properties.
You will be able to edit the generated text file in order to remove such information.

Continue?
)

IfMsgBox, No
	ExitApp

oSciTE := ComObjActive("SciTE4AHK.Application")

SciTEDir := oSciTE.SciTEDir

diagtext := "SciTE Diagnostic Info`n=====================`n`nSciTE dir: " SciTEDir "`nDefault AHK version: "
. GetAhkVer(SciTEDir "\..\AutoHotkey.exe") "`nCurrent platform: " oSciTE.ActivePlatform "`n`n"

RunWait, %comspec% /c tree /F /A "%A_AhkDir%" >> "%A_Temp%\Diag.txt",, Hide
FileEncoding, % "CP" DllCall("GetOEMCP", "UInt")
FileRead, ov, %A_Temp%\Diag.txt
diagtext .= ov
FileDelete, %A_Temp%\Diag.txt
FileEncoding, UTF-8

proptypes = dyn|local|directory|user|base|embed|abbrev

Loop, Parse, proptypes, |
{
	props := oSciTE.SendDirectorMsgRetArray("enumproperties:" A_LoopField)
	for prop in props
		AddProp(diagtext, prop.value)
}

Menu, MenuBar, Add, Save to file, FileSave
Menu, MenuBar, Add, Copy to clipboard, ClipSave

Gui, +Resize
Gui, Menu, MenuBar
Gui, Font, s10, Courier New
Gui, Add, Edit, x0 y0 w640 h480 vdiagtext, % diagtext
Gui, Show, w640 h480, SciTE diagnostic info
return

GuiClose:
ExitApp

GuiSize:
GuiControl, Move, diagtext, w%A_GuiWidth% h%A_GuiHeight%
return

FileSave:
FileSelectFile, ov, S16,, Save file..., Text files (*.txt)
if ErrorLevel
	return

SplitPath, ov,, ovdir,, ovname
ov := ovdir "\" ovname ".txt"

Gui, Submit, NoHide
FileDelete, %ov%
FileAppend, % diagtext, %ov%
MsgBox, 64, SciTE diagnostic tool, Diagnostic info successfully saved!
return

ClipSave:
Gui, Submit, NoHide
StringReplace, Clipboard, diagtext, `n, `r`n, All
MsgBox, 64, SciTE diagnostic tool, Diagnostic info copied to clipboard!
return

GetAhkVer(ahk)
{
	RunWait, "%ahk%" "%A_ScriptDir%\__AhkVer.ahk"
	FileRead, ov, %A_Temp%\__AhkVer.txt
	return ov
}

AddProp(ByRef ov, ByRef prop)
{
	pos := InStr(prop, ":")
	type := SubStr(prop, 1, pos-1)
	prop := SubStr(prop, pos+1)
	pos := InStr(prop, "=")
	name := SubStr(prop, 1, pos-1)
	val := SubStr(prop, pos+1)
	ov .= "(" type ") " name "=" val "`n"
}
