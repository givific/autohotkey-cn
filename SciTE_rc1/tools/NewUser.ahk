;
; File encoding:  UTF-8
; Platform:  Windows XP/Vista/7
; Author:    A.N.Other <myemail@nowhere.com>
;
; Script description:
;	Template script
;

#NoEnv
#NoTrayIcon
#SingleInstance Ignore
SendMode Input
SetWorkingDir, %A_ScriptDir%

Progress, m2 b zh0, Preparing SciTE4AutoHotkey to run for the first time...

FileCreateDir, %A_MyDocuments%\AutoHotkey
FileCreateDir, %A_MyDocuments%\AutoHotkey\Lib
IfExist, %A_MyDocuments%\AutoHotkey\SciTE
	FileMoveDir, %A_MyDocuments%\AutoHotkey\SciTE, %A_MyDocuments%\AutoHotkey\SciTE%A_TickCount%

FileCreateDir, %A_MyDocuments%\AutoHotkey\SciTE
FileCopyDir, %A_ScriptDir%\..\newuser, %A_MyDocuments%\AutoHotkey\SciTE, 1

; Mainly to avoid an annoying flashing window:
Sleep, 1000
