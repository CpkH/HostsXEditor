#NoEnv
#KeyHistory 0
#Persistent
#SingleInstance off

IfExist %A_ScriptFullPath%.dat\*
	ConfigFoundHere = true

IfExist %A_AppData%\orzTech\HostsX\*
	ConfigFoundAppData = true

ConfigHereWriteProtect=false

Random, rand1, 10000, 99999
Random, rand2, 10000, 99999
Random, rand3, 10000, 99999
Loop, %A_Temp%,2
{
	FullTemp = %A_LoopFileLongPath%
}
Loop, %A_ScriptDir%,2
{
	FullScriptDir = %A_LoopFileLongPath%
}
StringLower Lower_A_ScriptDir, FullScriptDir
StringLower Lower_A_Temp, FullTemp
StringLen Len_A_Temp, A_Temp
StringLeft Cutted_A_ScriptDir, Lower_A_ScriptDir, Len_A_Temp
If (Cutted_A_ScriptDir=Lower_A_Temp)
{
	ConfigHereWriteProtect=true
}
Else IfInString, Lower_A_ScriptDir, locals~1\temp
{
	ConfigHereWriteProtect=true
}

If ConfigHereWriteProtect=true
{ }
Else
{
	If ConfigFoundHere = true
		testFile = %A_ScriptFullPath%.dat\HostsX%rand1%%rand2%%rand3%.orz
	Else
		testFile = %A_ScriptDir%\HostsX%rand1%%rand2%%rand3%.orz
	FileAppend, a, %testFile%
	If ErrorLevel
		ConfigHereWriteProtect = true
	Else
		FileDelete %testFile%
}
ConfigUseAppData = false
ConfigPath=
If ConfigFoundHere=true
{
	if ConfigHereWriteProtect=true
	{
		if ConfigFoundAppData=true
		{ }
		else
		{
			FileCopyDir, %A_ScriptFullPath%.dat, %A_AppData%\orzTech\HostsX
		}
		ConfigPath = %A_AppData%\orzTech\HostsX
		ConfigUseAppData = true
	}
	else
	{
		ConfigPath = %A_ScriptFullPath%.dat
		ConfigUseAppData = false
	}
}
else
{
	if ConfigHereWriteProtect=true
	{
		if ConfigFoundAppData=true
		{}
		else
		{
			FileCreateDir, %A_AppData%\orzTech\HostsX
		}
		ConfigPath = %A_AppData%\orzTech\HostsX
		ConfigUseAppData = true
	}
	else
	{
		if ConfigFoundAppData=true
		{
			FileMoveDir, %A_AppData%\orzTech\HostsX, %A_ScriptFullPath%.dat
		}
		else
		{
			FileCreateDir, %A_ScriptFullPath%.dat
		}
		ConfigPath = %A_ScriptFullPath%.dat
		ConfigUseAppData = false
	}
}
If ConfigUseAppData = true
	TrayTip, HostsX �����ļ��о���, HostsX �޷��ڵ�ǰ�����ļ���д�����ݣ����Ѿ��л����û������ļ���ģʽ���볢�Խ������Ƶ�����Ӳ�̿�д����ļ������У������Զ����û������ļ����д������ļ��ƶ�����ǰ�ļ��С�, 30, 3
	
IfNotExist,%ConfigPath%\HostsX.orzconfig
	GoSub FirstRun

FileInstall orzTech.com.png, %ConfigPath%\orzTech.com.png
applicationname=HostsX
applicationfunction=��һ�����±����� Hosts �ļ��༭���ߡ�
applicationtip=
applicationversion=0.4.0.1024 dev

Gosub ReloadSettings

BuildMenu:
;#debug
;Menu, Tray, NoStandard
Menu, Tray, Add, ���� HostsX(&A), HelpAbout
Menu, Tray, Add
Menu, Tray, Add, �˳� HostsX(&X), FileExit

Menu, MyMenuBar,Add
Menu, MyMenuBar,DeleteAll

Menu, FileMenu, Add, �½�(&N)`tCtrl+N, FileNew
Menu, FileMenu, Add, ��(&O)...`tCtrl+O, FileOpen
Menu, FileMenu, Add, ����(&S)`tCtrl+S, FileSave
Menu, FileMenu, Add, ���Ϊ(&A)..., FileSaveAs
Menu, FileMenu, Add  ; Separator line.
Gosub FillPopularFiles
Menu, FileMenu, Add  ; Separator line.
Menu, FileMenu, Add, �˳�(&X), FileExit

Menu, EditMenu, Add, ����(&U)`tCtrl+Z, EditUndo
Menu, EditMenu, Add
Menu, EditMenu, Add, ����(&T)`tCtrl+X, EditCut
Menu, EditMenu, Add, ����(&C)`tCtrl+C, EditCopy
Menu, EditMenu, Add, ճ��(&P)`tCtrl+V, EditPaste
Menu, EditMenu, Add, ɾ��(&D)`tDelete, EditDelete
Menu, EditMenu, Add, ɾ��ȫ��(&E), EditDeleteAll
Menu, EditMenu, Add
Menu, EditMenu, Add, ����(&F)`tCtrl+F, EditFind
Menu, EditMenu, Add, ������һ��(&N)`tF3, EditFindNext
Menu, EditMenu, Add, �滻(&R)`tCtrl+H, EditReplace
Menu, EditMenu, Add
Menu, EditMenu, Add, ȫѡ(&A)`tCtrl+A, EditSelectAll

Menu, FormatMenu, Add, ����(&F)..., FormatFont
Menu, FormatMenu, Add
Menu, FormatMenu, Add, �������з��Ŵ���ɾ������(&R), HostsWrap
Menu, FormatMenu, Add, ��ɾ��ע��(&G), HostsDelComments
Menu, FormatMenu, Add, ɾ��ע�͡��ظ������(&H), HostsSort
Menu, FormatMenu, Add
Menu, FormatMenu, Add, ����ת��ͳһʹ�� 0.0.0.0(&0), HostsReplace0000
Menu, FormatMenu, Add, ����ת��ͳһʹ�� 127.0.0.1(&1), HostsReplace127001
Menu, FormatMenu, Add, ����ת��ͳһʹ�� 127.1������ Windows Vista ֮ǰ�汾��(&2), HostsReplace1271


GoSub BuildInsertMenu
GoSub BuildBackupMenu
Menu, ToolsMenu, Add, ���� HostsX ����������(&E)`tF10, CheckWhitelist
Menu, ToolsMenu, Add
Menu, ToolsMenu, Add, ˢ�� DNS ����(&D)`tF7, ToolsCleanDNS
Menu, ToolsMenu, Add, ��� Internet Explorer ����(&I)`tF8, ToolsCleanIE
Menu, ToolsMenu, Add, ��� Windows Media Player ������(&W), ToolsCleanWMP
Menu, ToolsMenu, Add
Menu, ToolsMenu, Add, �� Hosts �ļ�����(&L)`tF5, ToolsLockHosts
Menu, ToolsMenu, Add, �� Hosts �ļ�����(&U)`tF6, ToolsUnlockHosts
Menu, ToolsMenu, Add
Menu, ToolsMenu, Add, ִ�� Ping ����(&P), ToolsPing
Menu, ToolsMenu, Add, ִ�� NSLookup ����(&N), ToolsNSLookup
Gosub BuildUpdateMenu

Menu, HelpMenu, Add, HostsX ����(&H), orzTechHelpPage
Menu, HelpMenu, Add, HostsX ����ҳ��(&P), orzTechPubPage
Menu, HelpMenu, Add, HostsX ��л�б�(&A), orzTechAcknowledgementsPage
Menu, HelpMenu, Add
Menu, HelpMenu, Add, ��Ƽ�(&O), orzTech
Menu, HelpMenu, Add, ��Ƽ�����֧��ϵͳ(&S), orzTechSupport
Menu, HelpMenu, Add
Menu, HelpMenu, Add, ���� HostsX(&A), HelpAbout
	
Menu, OptionsMenu, Add, ���� HostsX ����������ʱʹ�þ�Ĭģʽ(&S), OptionsCheckWhitelistSilentMode
If (CheckWhitelistSilentMode = "orzYes")
	Menu, OptionsMenu, Check, ���� HostsX ����������ʱʹ�þ�Ĭģʽ(&S)

Menu, OptionsMenu, Add, ���ļ����Զ����� HostsX ����������(&O), OptionsCheckWhitelistAfterOpen
If (CheckWhitelistAfterOpen = "orzYes")
	Menu, OptionsMenu, Check, ���ļ����Զ����� HostsX ����������(&O)

; Create the menu bar by attaching the sub-menus to it:
Menu, MyMenuBar, Add, �ļ�(&F), :FileMenu
Menu, MyMenuBar, Add, �༭(&E), :EditMenu
Menu, MyMenuBar, Add, ��ʽ(&O), :FormatMenu
Menu, MyMenuBar, Add, ����(&I), :InsertMenu
Menu, MyMenuBar, Add, ����(&T), :ToolsMenu
Menu, MyMenuBar, Add, ����(&B), :BackupMenu
Menu, MyMenuBar, Add, ����(&U), :UpdateMenu
Menu, MyMenuBar, Add, ѡ��(&P), :OptionsMenu
Menu, MyMenuBar, Add, ����(&H), :HelpMenu
Gui, 1:Menu, MyMenuBar

; Attach the menu bar to the window:
Gui, 1:Menu, MyMenuBar

; Create the main Edit control and display the window:
Gui, +Resize  ; Make the window resizable.
Gui, Margin, 0, 0
Gui Font, %Style% c%Color%, %Font%
Gui, Add, Edit, vMainEdit WantTab WantReturn WantCtrlA HSCROLL -Wrap W800 R30
Gui, Show,, HostsX
Gui +LastFound
hGui := WinExist()
CurrentFileName =  ; Indicate that there is no current file.
Unchanged=
_checkWhitelistAfterOpen = %CheckWhitelistAfterOpen%
CheckWhitelistAfterOpen = orzNo
IfExist,%SystemHosts%
{
	SelectedFileName =%SystemHosts%
	Gosub FileRead
}
Else
{
	Gui +OwnDialogs
	MsgBox, 35,,��%SystemHosts%�������ڣ��Ƿ񴴽���
	IfMsgBox, Yes
	{
		FileAppend, ,%SystemHosts%
		SelectedFileName =%SystemHosts%
		Gosub FileRead
	}
}
CheckWhitelistAfterOpen = %_checkWhitelistAfterOpen%

NeedUpdate = false
if (UpdateWhenMissing = "orzYes")
{
	IfNotExist,%ConfigPath%\HostsX.orzhosts
		NeedUpdate = true
	IfNotExist,%ConfigPath%\HostsX.orzsource
		NeedUpdate = true
	IfNotExist,%ConfigPath%\HostsXWhitelist.orzhosts
		NeedUpdate = true
}
If (UpdateAtStartup = "orzYes")
	NeedUpdate = true

If NeedUpdate = true
	Gosub UpdateAll
Gosub ParseWhitelist

Loop, %0%  ; For each parameter:
{
    param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
    StringUpper, param, param
    if param=auto
    	Gosub AutoParam
}

If CheckWhitelistAfterOpen = orzYes
	Gosub CheckWhitelist
return

#IfWinActive HostsX ahk_class AutoHotkeyGUI
^N::
FileNew:
GoSub CheckSave
if ErrorLevel
	Return
GuiControl,, MainEdit  ; Clear the Edit control.
Unchanged=
CurrentFileName =
Gui, Show,, HostsX
return

^O::
FileOpen:
Gui +OwnDialogs  ; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
FileSelectFile, SelectedFileName, 3,, �� Hosts �ļ�
if SelectedFileName =  ; No file selected.
    return
Gosub FileRead
return

FileRead:  ; Caller has set the variable SelectedFileName for us.
FileRead, MainEdit, %SelectedFileName%  ; Read the file's contents into the variable.
if ErrorLevel
{
	Gui +OwnDialogs
    MsgBox �޷��򿪡�%SelectedFileName%��.
    return
}
GuiControl,, MainEdit, %MainEdit%  ; Put the text into the control.
GuiControlGet, MainEdit
Unchanged=%MainEdit%
CurrentFileName = %SelectedFileName%
Gui, Show,, HostsX - %CurrentFileName%   ; Show file name in title bar.
If CheckWhitelistAfterOpen = orzYes
	Gosub CheckWhitelist
return

^S::
FileSave:
if CurrentFileName =   ; No filename selected yet, so do Save-As instead.
    Goto FileSaveAs
Gosub SaveCurrentFile
return

FileSaveAs:
Gui +OwnDialogs  ; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
FileSelectFile, SelectedFileName, S16,, ���� Hosts �ļ�
if SelectedFileName =  ; No file selected.
{
	ErrorLevel=1
    return
}
CurrentFileName = %SelectedFileName%
Gosub SaveCurrentFile
ErrorLevel=0
return

SaveCurrentFile:
GuiControlGet, MainEdit  ; Retrieve the contents of the Edit control.
EnvGet, Temp, Temp
Random, rand, 10000, 99999
FileAppend, %MainEdit%, %temp%\HostsX%rand%.orz

FileGetAttrib, Attributes, %CurrentFileName%
IfInString, Attributes, R
	FileSetAttrib, -R, %CurrentFileName%
IfInString, Attributes, H
	FileSetAttrib, -H, %CurrentFileName%
IfInString, Attributes, S
	FileSetAttrib, -S, %CurrentFileName%
FileCopy, %temp%\HostsX%rand%.orz, %CurrentFileName%, 1
If ErrorLevel
{
	FileDelete, %temp%\HostsX%rand%.orz
	Gui +OwnDialogs
	MsgBox 16,,���桰%CurrentFileName%��ʧ�ܣ������Ƿ���Ȩ��д���ļ���`n`n�볢��ʹ�ù���ԱȨ�����б��������ԣ�����ʱ���Ϊ������λ�á�`n����������� Hosts �ļ������������Ƚ�����
	ErrorLevel=1
	Return
}
IfInString, Attributes, R
	FileSetAttrib, +R, %CurrentFileName%
IfInString, Attributes, H
	FileSetAttrib, +H, %CurrentFileName%
IfInString, Attributes, S
	FileSetAttrib, +S, %CurrentFileName%

FileDelete, %temp%\HostsX%rand%.orz
Gui, Show,, HostsX - %CurrentFileName%
TrayTip, HostsX ��ʾ, %CurrentFileName% ����ɹ���, 30, 1
ErrorLevel=0
Unchanged=%MainEdit%
return

HelpAbout:
Gui,99:+owner1  ; Make the main window (Gui #1) the owner of the "about box" (Gui #2).
Gui +Disabled  ; Disable main window.
Gui,99:Destroy
Gui,99:Margin,15,15
Gui,99:Add,Picture,xm, orzTech.com.png
Gui,99:Font,Bold
Gui,99:Add,Text,xm y+20,%applicationname% %applicationversion%
Gui,99:Font
Gui,99:Add,Text,x25 y+10,%applicationfunction%
Gui,99:Add,Text,x25 y+5,%applicationtip%

Gui,99:Font,Bold
Gui,99:Add,Text,xm y+20,by Yeechan Lu && Jock Kwok of ��Ƽ� | orzTech
Gui,99:Font
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,x25 y+5 gorzTech,http://orztech.com/
Gui,99:Font
Gui,99:Font,Bold
Gui,99:Add,Text,xm y+20,��Ƽ�����֧��
Gui,99:Font
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,x25 y+5 gorzTechSupport,http://orztech.com/support
Gui,99:Add,Text,x25 y+5 gorzTechSupportMail,support@orztech.com
Gui,99:Font

Gui,99:Show,,���� %applicationname% %applicationversion%
hCurs:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
 OnMessage(0x200,"WM_MOUSEMOVE")

Return

orzTechHelpPage:
  Run, http://orztech.com/softwares/hostsx/help
Return

orzTechPubPage:
  Run, http://orztech.com/softwares/hostsx
Return

orzTech:
  Run,http://orztech.com/
Return

orzTechSupport:
  Run,http://orztech.com/support
Return

orzTechAcknowledgementsPage:
  Run,http://orztech.com/softwares/hostsx/acknowledgements
Return

orzTechSupportMail:
  Run,% "mailto:support@orztech.com?subject=HostsX%20%E5%8F%8D%E9%A6%88%E8%A1%A8%E5%8D%95%20%5B%23NULL%5D%20from%20E-mail%20Supporting"
  ;HostsX ������ [#NULL] from E-mail Supporting
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static6,Static8,Static9
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return

99ButtonOK:  ; This section is used by the "about box" above.
99GuiClose:
99GuiEscape:
Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
Gui Destroy  ; Destroy the about box.
return


GuiDropFiles:
GoSub CheckSave
if ErrorLevel
	Return
Loop, parse, A_GuiEvent, `n
{
    SelectedFileName = %A_LoopField%  ; Get the first file only (in case there's more than one).
    break
}
Gosub FileRead
return

GuiSize:
if ErrorLevel = 1  ; The window has been minimized.  No action needed.
    return
; Otherwise, the window has been resized or maximized. Resize the Edit control to match.
NewWidth := A_GuiWidth
NewHeight := A_GuiHeight
GuiControl, Move, MainEdit, W%NewWidth% H%NewHeight%
return

FileExit:
GuiClose:
GoSub CheckSave
if ErrorLevel
	Return
Gosub SaveSettings
ExitApp

CheckSave:
GuiControlGet, MainEdit
if Unchanged<>%MainEdit%
{
	Gui +OwnDialogs
	MsgBox,35, , ��%SelectedFileName%�����޸ģ��Ƿ񱣴棿
	IfMsgBox Yes
	{
		Gosub FileSave
		If ErrorLevel
		{
			ErrorLevel=1
			Return
		}
		Else
		{
			ErrorLevel=0
			return
		}
	}
	IfMsgBox No
	{
		ErrorLevel=0
		Return
	}
	ErrorLevel=1
	Return
}
Else
ErrorLevel=0
Return

FillPopularFiles:
PopularFiles=
DriveGet, drives, List
Loop, parse, drives,,
{
	PopularFile=%A_LoopField%:\Windows\HOSTS.SAM
	Gosub FillPopularFile
	
	PopularFile=%A_LoopField%:\Windows\System32\drivers\etc\hosts
	Gosub FillPopularFile
	
	PopularFile=%A_LoopField%:\Windows\Sysnative\drivers\etc\hosts
	Gosub FillPopularFile
	
	PopularFile=%A_LoopField%:\Windows\SysWOW64\drivers\etc\hosts
	Gosub FillPopularFile

	PopularFile=%A_LoopField%:\WinNT\System32\drivers\etc\hosts
	Gosub FillPopularFile

	PopularFile=%A_LoopField%:\WinNT\Sysnative\drivers\etc\hosts
	Gosub FillPopularFile
	
	PopularFile=%A_LoopField%:\WinNT\SysWOW64\drivers\etc\hosts
	Gosub FillPopularFile

	PopularFile=%A_LoopField%:\WinNT\hosts
	Gosub FillPopularFile

	PopularFile=%A_LoopField%:\Windows\hosts
	Gosub FillPopularFile

	PopularFile=%A_LoopField%:\system\data\hosts
	Gosub FillPopularFile

	PopularFile=%A_LoopField%:\private\10000882\hosts
	Gosub FillPopularFile

	PopularFile=%A_LoopField%:\hosts
	Gosub FillPopularFile

	PopularFile=%A_LoopField%:\dns\AcrylicHosts.txt
	Gosub FillPopularFile
}
PopularFile=%A_WinDir%\System32\drivers\etc\hosts
SystemHosts = %PopularFile%
Gosub FillPopularFile

PopularFile=%A_WinDir%\Sysnative\drivers\etc\hosts
Gosub FillPopularFile

PopularFile=%A_WinDir%\SysWOW64\drivers\etc\hosts
Gosub FillPopularFile


PopularFile=%A_ScriptDir%\hosts
Gosub FillPopularFile

RegRead, TcpipDatabasePath, HKLM, SYSTEM\CurrentControlSet\Services\Tcpip\Parameters, DataBasePath
if ErrorLevel
{
	TcpipDatabasePath = %A_WinDir%\System32\drivers\etc
}
else
{
	StringReplace, TcpipDatabasePath, TcpipDatabasePath, `%Systemroot`%, %A_WinDir%
	PopularFile=%TcpipDatabasePath%\hosts
	SystemHosts = %PopularFile%
	Gosub FillPopularFile
	
	Loop %TcpipDatabasePath%\hosts*  ; For each file dropped onto the script (or passed as a parameter).
	{
	    PopularFile = %A_LoopFileLongPath%
		Gosub FillPopularFile
	}
}

RegRead, AcrylicPath, HKLM, SYSTEM\CurrentControlSet\services\AcrylicController, ImagePath
if ErrorLevel
{}
else
{
	StringReplace PopularFile, AcrylicPath, AcrylicService.exe, AcrylicHosts.txt, All
	Gosub FillPopularFile
}

PopularFiles=%PopularFiles%`n%A_ScriptDir%\hosts.txt

Sort, PopularFiles, U
Loop, parse, PopularFiles, `n,
{
	if A_LoopField<>
		Menu, FileMenu, Add, %A_LoopField%, FileOpenPopular
}

Return

FillPopularFile:
IfExist, %PopularFile%
{
	Loop, %PopularFile%
	{
		PopularFile = %A_LoopFileLongPath%
	}
	PopularFiles=%PopularFiles%`n%PopularFile%
}
Return

FileOpenPopular:
GoSub CheckSave
if ErrorLevel
	Return
IfExist,%A_ThisMenuItem%
{
	SelectedFileName =%A_ThisMenuItem%
	Gosub FileRead
}
Else
{
	Gui +OwnDialogs
	MsgBox, 35,,��%A_ThisMenuItem%�������ڣ��Ƿ񴴽���
	IfMsgBox, Yes
	{
		FileAppend, ,%A_ThisMenuItem%
		SelectedFileName =%A_ThisMenuItem%
		Goto FileRead
	}
	IfMsgBox, No
	{
		Return
	}
	Return
}
Return

HostsReplaceWith2000:
Hosts =
(
# Copyright (c) 1993-2006 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
#      102.54.94.97     rhino.acme.com          # source server
#       38.25.63.10     x.acme.com              # x client host

127.0.0.1       localhost
)
GuiControl,, MainEdit, %Hosts%
Return

HostsReplaceWithVista:
Hosts =
(
# Copyright (c) 1993-2006 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
#      102.54.94.97     rhino.acme.com          # source server
#       38.25.63.10     x.acme.com              # x client host

127.0.0.1       localhost
::1             localhost

)
GuiControl,, MainEdit, %Hosts%
Return

HostsReplaceWith7:
Hosts =
(
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
#      102.54.94.97     rhino.acme.com          # source server
#       38.25.63.10     x.acme.com              # x client host

# localhost name resolution is handled within DNS itself.
#	127.0.0.1       localhost
#	::1             localhost
)
GuiControl,, MainEdit, %Hosts%
Return

HostsReplaceWithAcrylicHosts:
Hosts =
(
#############################################################################
#                                                                           #
# This is the AcrylicHosts.txt file.                                        #
#                                                                           #
# It contains predefined mappings between names and addresses exactly the   #
# same way the native HOSTS file does.                                      #
#                                                                           #
# Every line corresponds to a single record (mapping).                      #
# The format is: IPADDRESS HOSTNAME                                         #
#                                                                           #
# Where IPADDRESS is in quadded dot notation and HOSTNAME is a string.      #
# The separator between IPADDRESS and HOSTNAME can be any number of spaces  #
# or tabs or both. The HOSTNAME can also contain the special characters     #
# '*' and '?' in which case a (slow) "dir" like pattern matching algorithm  #
# is used instead of a (fast) binary search within the list of host names:  #
#                                                                           #
# 127.0.0.1 ad.*                                                            #
# 127.0.0.1 ads.*                                                           #
#                                                                           #
# Note: Patterns are evaluated in the same order in which they are written. #
#                                                                           #
# It is also possible to specify exceptions when pattern based matching is  #
# used. If for example we would like to filter out all ads.* like domains   #
# except for the ads.mydomain1 and the ads.mydomain2 we should write:       #
#                                                                           #
# 127.0.0.1 ads.* ads.mydomain1,ads.mydomain2                               #
#                                                                           #
# Multiple exceptions must be on a single line and separated by commas.     #
#                                                                           #
# Note: A line starting with the '#' character is considered a comment and  #
# therefore ignored.                                                        #
#                                                                           #
#############################################################################

127.0.0.1       localhost
)
GuiControl,, MainEdit, %Hosts%
Return

EditUndo:
GuiControl, Focus, MainEdit
Send ^Z
Return

EditCut:
GuiControl, Focus, MainEdit
Send ^X
Return

EditCopy:
GuiControl, Focus, MainEdit
Send ^C
Return

EditPaste:
GuiControl, Focus, MainEdit
Send ^V
Return

EditDelete:
GuiControl, Focus, MainEdit
Send {Del}
Return

EditDeleteAll:
GuiControlGet, MainEdit
MainEdit=
GuiControl,, MainEdit, %MainEdit%
Return

EditSelectAll:
GuiControl, Focus, MainEdit
Send ^A
Return

BuildInsertMenu:
Gui 1:Menu
GoSub BuildInsertMenuItems
Menu, InsertMenu, Add
Menu, InsertMenu, DeleteAll
Menu, InsertMenu, Add, ������������(&L), InsertLookupIPLocal
Menu, InsertMenu, Add, localhost ���ؽ�������(&O), InsertLocalhost
Menu, InsertMenu, Add
Menu, InsertMenu, Add, HostsX �����������(&X), :InsertMenuItems
SourceIndex=0
Loop, Read, %ConfigPath%\HostsX.orzsource
{
	Length := StrLen(A_LoopReadLine)
	if Length > 0
	{
		fch:=SubStr(A_LoopReadLine, 1, 1)
		if fch=-
		{
			Menu, InsertMenu, Add
		}
		else if fch=;
		{
			commentsource:=SubStr(A_LoopReadLine, InStr(SubStr(A_LoopReadLine, 2), "=")+2)
			commentsourcename:=SubStr(SubStr(A_LoopReadLine, 1, InStr(A_LoopReadLine, "=")-1),2)
			Commentsource%commentsourcename%:=commentsource
		}
		else
		{
			SourceIndex += 1
			if InStr(A_LoopReadLine, "*")
			{
				StringSplit, SourceItem, A_LoopReadLine, *
				source%SourceIndex%Caption=%SourceItem1%
				source%SourceIndex%URL=%SourceItem2%
				source%SourceIndex%Action=ShellExecute
				sc:=source%SourceIndex%Caption
				Menu, InsertMenu, Add, %sc%, InsertOtherAction
			}
			else
			{
				StringSplit, SourceItem, A_LoopReadLine, ``
				source%SourceIndex%Caption=%SourceItem1%
				source%SourceIndex%URL=%SourceItem2%
				source%SourceIndex%Action=Insert
				sc:=source%SourceIndex%Caption
				Menu, InsertMenu, Add, %sc%, InsertOtherAction
				if (source%SourceIndex%URL ==)
				{
					Menu, InsertMenu, Disable, %sc%
				}
			}
		}
	}
}
Gui, 1:Menu, MyMenuBar
Return

BuildInsertMenuItems:
Menu, InsertMenuItems, Add
Menu, InsertMenuItems, DeleteAll
Menu, InsertMenuItems, Add, ���뱾��������������(&I), InsertHostsItemsAction
Menu, InsertMenuItems, Add
ArrayCount=0
Loop, Read, %ConfigPath%\HostsX.orzhosts
{
	Length := StrLen(A_LoopReadLine)
	if Length > 1
	{
		fch:=SubStr(A_LoopReadLine, 1, 1)
		if fch=@
		{
			caption:=SubStr(A_LoopReadLine, 2)
			fullcaption=%caption%
			subsub:=InStr(caption, "/")
			if subsub=0
				capparent=Items
			else
			{
				caption:=SubStr(A_LoopReadLine, InStr(SubStr(A_LoopReadLine, 2), "/")+2)
				capparent:="Items" . SubStr(SubStr(A_LoopReadLine, 1, InStr(A_LoopReadLine, "/")-1),2)
			}
			Menu, InsertMenuItems%caption%, Add
			Menu, InsertMenu%capparent%, Add, %caption%, :InsertMenuItems%caption%
			Menu, InsertMenuItems%caption%, DeleteAll
			Menu, InsertMenuItems%caption%, Add, ���뱾��������������(&I), InsertHostsItemsAction
			Menu, InsertMenuItems%caption%, Add
		}
		else if fch=#
		{
			ArrayCount += 1
			caption2:=SubStr(A_LoopReadLine, 2)
			StringReplace, captionmenu2, caption2, &, &&, All
			ArrayName%ArrayCount%=%caption%/%caption2%
			ArrayFullName%ArrayCount%=%fullcaption%/%caption2%
			ArrayContent%ArrayCount%=
			Menu, InsertMenuItems%caption%, Add, %captionmenu2%, InsertMenuAction
		}
		else if fch=;
		{
			comment:=SubStr(A_LoopReadLine, InStr(SubStr(A_LoopReadLine, 2), "=")+2)
			commentname:=SubStr(SubStr(A_LoopReadLine, 1, InStr(A_LoopReadLine, "=")-1),2)
			Comment%commentname%:=comment
		}
		else
		{
			ArrayContent%ArrayCount%:=ArrayContent%ArrayCount% . "`n" . A_LoopReadLine
		}
	}
}
Menu, InsertMenuItems, Add
Menu, InsertMenuItems, Add, �汾��%Commentversion%, InsertMenuAction
Menu, InsertMenuItems, Disable, �汾��%Commentversion%
Menu, InsertMenuItems, Add, ���ߣ�%Commentauthor%, InsertMenuAction
Menu, InsertMenuItems, Disable, ���ߣ�%Commentauthor%
Return

BuildUpdateMenu:
Gui 1:Menu
Menu, UpdateMenu, Add,
Menu, UpdateMenu, DeleteAll
Menu, UpdateMenu, Add, һ������ ��lpha(&O), OneKeyUpdate
Menu, UpdateMenu, Add
Menu, UpdateMenu, Add, ��������ʱ�Զ����������ļ�(&S), OptionsUpdateAtStartup
If (UpdateAtStartup = "orzYes")
	Menu, UpdateMenu, Check, ��������ʱ�Զ����������ļ�(&S)
Menu, UpdateMenu, Add, �����ļ�������ʱ�Զ����������ļ�(&M), OptionsUpdateWhenMissing
If (UpdateWhenMissing = "orzYes")
	Menu, UpdateMenu, Check, �����ļ�������ʱ�Զ����������ļ�(&M)
Menu, UpdateMenu, Add
Menu, UpdateMenu, Add, ����������������(&A), UpdateAll
Menu, UpdateMenu, Add
Menu, UpdateMenu, Add, ���� HostsX �����������(&U), UpdateHostsFile
Menu, UpdateMenu, Add, HostsX.orzHosts ��ǰ�汾��%Commentversion%, UpdateHostsFile
Menu, UpdateMenu, Disable, HostsX.orzHosts ��ǰ�汾��%Commentversion%
Menu, UpdateMenu, Add
Menu, UpdateMenu, Add, ���� HostsX ����������������(&W), UpdateWhitelist
Menu, UpdateMenu, Add, HostsXWhitelist.orzHosts ��ǰ�汾��%commentwhitelistversion%, UpdateHostsFile
Menu, UpdateMenu, Disable, HostsXWhitelist.orzHosts ��ǰ�汾��%commentwhitelistversion%
Menu, UpdateMenu, Add
Menu, UpdateMenu, Add, ���� HostsX �Ƽ������б�(&P), UpdateOtherHosts
Menu, UpdateMenu, Add, HostsX.orzSource ��ǰ�汾��%Commentsourceversion%, UpdateHostsFile
Menu, UpdateMenu, Disable, HostsX.orzSource ��ǰ�汾��%Commentsourceversion%
Menu, UpdateMenu, Add
Menu, UpdateMenu, Add, ���� HostsX ���°汾 %commenthostsxversion%(&H), orzTechPubPage
Menu, UpdateMenu, Add, HostsX ��ǰ�汾��%applicationversion%, UpdateHostsFile
Menu, UpdateMenu, Disable, HostsX ��ǰ�汾��%applicationversion%
IfNotInstring, applicationversion, dev
{
	If (applicationversion!=commenthostsxversion)
		TrayTip, HostsX ��⵽�°汾, orzTech | ��Ƽ��ѷ����°� HostsX��`r`n`r`n���°汾��%commenthostsxversion%`r`n��ǰ�汾��%applicationversion%`r`n`r`n���ڡ����¡��˵������ء�,,1
}
Gui, 1:Menu, MyMenuBar

BuildBackupMenu:
Gui 1:Menu
Menu, BackupMenu, Add,
Menu, BackupMenu, DeleteAll
Menu, BackupMenu, Add, ���ݵ�ǰ�ļ�����(&B), BackupHosts
Menu, BackupMenu, Add, ���ݵ�ǰ�༭������(&C), BackupEdit
Menu, BackupMenu, Add,
IfExist, %ConfigPath%\*.orzBackup
{
	Menu, RestoreWithBackups, Add
	Menu, RestoreWithBackups, DeleteAll
	Loop, %ConfigPath%\*.orzBackup, 0, 0
	{
		StringLen, A_LoopFileNameLength, A_LoopFileName
		A_LoopFileNameLength -= 10
		StringLeft, B_LoopFileName, A_LoopFileName, %A_LoopFileNameLength%
		Menu, RestoreWithBackups, Add, %B_LoopFileName%, RestoreWithBackupFile
	}
    Menu, BackupMenu, Add, ��ԭ�༭��Ϊ���ݵ� Hosts �ļ�(&R), :RestoreWithBackups
}
Else
{
	Menu, BackupMenu, Add, ��ԭ�༭��Ϊ���ݵ� Hosts �ļ�(&R), RestoreWithBackupFile
	Menu, BackupMenu, Disable, ��ԭ�༭��Ϊ���ݵ� Hosts �ļ�(&R)
}
Menu, ReplaceWithDefaultContents, Add
Menu, ReplaceWithDefaultContents, DeleteAll
Menu, ReplaceWithDefaultContents, Add, Windows 98`, Me`, NT`, 2000`, &XP`, 2003, HostsReplaceWith2000
Menu, ReplaceWithDefaultContents, Add, Windows &Vista, HostsReplaceWithVista
Menu, ReplaceWithDefaultContents, Add, Window&s 7, HostsReplaceWith7
Menu, ReplaceWithDefaultContents, Add, &Acrylic DNS Proxy, HostsReplaceWithAcrylicHosts
Menu, BackupMenu, Add, ��ԭ�༭��ΪĬ�� Hosts �ļ�(&D), :ReplaceWithDefaultContents
Menu, BackupMenu, Add, 
Menu, BackupMenu, Add, �����ݵ� Hosts �ļ�(&M), ManageHostsBackups
Gui, 1:Menu, MyMenuBar
Return 

CreateBackup:
StringReplace, BackupName, BackupName, \, _, All
StringReplace, BackupName, BackupName, /, _, All
StringReplace, BackupName, BackupName, :, _, All
StringReplace, BackupName, BackupName, *, _, All
StringReplace, BackupName, BackupName, ?, _, All
StringReplace, BackupName, BackupName, `", _, All
StringReplace, BackupName, BackupName, ``, _, All
StringReplace, BackupName, BackupName, <, _, All
StringReplace, BackupName, BackupName, >, _, All
StringReplace, BackupName, BackupName, |, _, All
StringReplace, BackupName, BackupName, ., _, All
BackupFullPath = %ConfigPath%\%BackupName%.orzBackup
IfExist, %BackupFullPath%
{
	Gui +OwnDialogs
	MsgBox, 35,, %BackupName% �Ѿ����ڣ��Ƿ񸲸ǣ�
	IfMsgBox No
		return
	else IfMsgBox Cancel
		return
}
FileAppend, %BackupContents%, %BackupFullPath%
Gui +OwnDialogs
If ErrorLevel
	Msgbox, 16, �޷�д���ļ� %BackupFullPath%������δ�ܳɹ�������
Else
	TrayTip, HostsX ��ʾ, ���� %BackupName% �����ɹ���,,1
Return

BackupHosts:
FileRead, BackupContents, %SelectedFileName%
FormatTime, TimeStamp, , yyMMdd_HHmm
BackupName = %TimeStamp%orig_%SelectedFileName%
StringReplace, BackupName, BackupName, \, _, All
StringReplace, BackupName, BackupName, /, _, All
StringReplace, BackupName, BackupName, :, _, All
StringReplace, BackupName, BackupName, *, _, All
StringReplace, BackupName, BackupName, ?, _, All
StringReplace, BackupName, BackupName, `", _, All
StringReplace, BackupName, BackupName, ``, _, All
StringReplace, BackupName, BackupName, <, _, All
StringReplace, BackupName, BackupName, >, _, All
StringReplace, BackupName, BackupName, |, _, All
StringReplace, BackupName, BackupName, ., _, All
Gui +OwnDialogs
InputBox, BackupName, , �����뱸�ݵ��ļ����ơ�, , , , , , , , %BackupName%
if ErrorLevel
{
	;�����ݡ�
}
else
{
	Gosub CreateBackup
	Gosub BuildBackupMenu
}
Return

BackupEdit:
GuiControlGet, MainEdit
BackupContents = %MainEdit%
FormatTime, TimeStamp, , yyMMdd_HHmm
BackupName = %TimeStamp%edit_%SelectedFileName%
StringReplace, BackupName, BackupName, \, _, All
StringReplace, BackupName, BackupName, /, _, All
StringReplace, BackupName, BackupName, :, _, All
StringReplace, BackupName, BackupName, *, _, All
StringReplace, BackupName, BackupName, ?, _, All
StringReplace, BackupName, BackupName, `", _, All
StringReplace, BackupName, BackupName, ``, _, All
StringReplace, BackupName, BackupName, <, _, All
StringReplace, BackupName, BackupName, >, _, All
StringReplace, BackupName, BackupName, |, _, All
StringReplace, BackupName, BackupName, ., _, All
Gui +OwnDialogs
InputBox, BackupName, , �����뱸�ݵ��ļ����ơ�, , , , , , , , %BackupName%
if ErrorLevel
{
	;�����ݡ�
}
else
{
	Gosub CreateBackup
	Gosub BuildBackupMenu
}
Return

RestoreWithBackupFile:
IfExist %ConfigPath%\%A_ThisMenuItem%.orzBackup
{
	FileRead, Hosts, %ConfigPath%\%A_ThisMenuItem%.orzBackup
	if not ErrorLevel  ; Successfully loaded.
	{
	    GuiControl,, MainEdit, %Hosts%
	    Hosts=
		TrayTip, HostsX ��ʾ, �ѳɹ������� %A_ThisMenuItem% ��ԭ���༭������Ҫʹ��ԭ��� Hosts ��Ч�������ڱ����ļ���,,1
	}
	else
	{
		Gui +OwnDialogs
		Msgbox, 16, ���� %BackupFullPath% �޷���ȡ�������Ѿ���ʧ���𻵡�
	}
}
else
{
	Gui +OwnDialogs
	Msgbox, 16, ���� %BackupFullPath% �޷���ȡ�������Ѿ���ʧ���𻵡�
}
Return

ManageHostsBackups:
Gui, 3:+owner1  ; Make the main window (Gui #1) the owner of the "about box" (Gui #2).
Gui +Disabled  ; Disable main window.
Gui, 3:Margin, 5, 5
Gui, 3:Add, ListBox, vFileBox g3FileBox Sort Multi 0x100 R20 W500 section
Gui, 3:Add, Button, vButtonRename g3ButtonRename Disabled ys, ������(&R)
Gui, 3:Add, Button, vButtonDelete g3ButtonDelete Disabled wp, ɾ��(&D)
Gui, 3:Add, Button, vButtonExport g3ButtonExport Disabled wp, ����(&E)
Gui, 3:Add, Button, vButtonImport g3ButtonImport wp, ����(&I)
Gui, 3:Add, Button, vButtonSelectAll g3ButtonSelectAll wp y+10, ȫѡ(&A)
Gui, 3:Add, Button, vButtonClose g3ButtonClose wp y+10 Default Cancel, �ر�(&C)
Gosub 3RebuildFileBox
Gui,3:Show,,�����ݵ� Hosts �ļ�
return

3ButtonSelectAll:
Gui 3:+LastFound  ; Avoids the need to specify WinTitle below.
PostMessage, 0x185, 1, -1, ListBox1  ; Select all items. 0x185 is LB_SETSEL.
If FileBoxCount=0
	Gosub 3SetButtonStatusNone
Else
{
	If FileBoxCount = 1
		Gosub 3SetButtonStatusSingle
	Else
		Gosub 3SetButtonStatusMulti
}
Return

3FileBox:
GuiControlGet, FileBoxItem, 3:, FileBox
If FileBoxItem=
	Gosub 3SetButtonStatusNone
Else
{
	StringSplit, FileBoxItem, FileBoxItem, |
	If FileBoxItem0 = 1
		Gosub 3SetButtonStatusSingle
	Else
		Gosub 3SetButtonStatusMulti
}
return

3SetButtonStatusNone:
GuiControl, 3:Disable, ButtonRename
GuiControl, 3:Disable, ButtonDelete
GuiControl, 3:Disable, ButtonExport
Return

3SetButtonStatusSingle:
GuiControl, 3:Enable, ButtonRename
GuiControl, 3:Enable, ButtonDelete
GuiControl, 3:Enable, ButtonExport
Return

3SetButtonStatusMulti:
GuiControl, 3:Disable, ButtonRename
GuiControl, 3:Enable, ButtonDelete
GuiControl, 3:Enable, ButtonExport
Return

3ButtonRename:
GuiControlGet, FileBoxItem, 3:, FileBox
StringSplit, FileBoxItem, FileBoxItem, |
Loop, %FileBoxItem0%
{
    this_FileBoxItem := FileBoxItem%a_index%
    Gui +OwnDialogs
    InputBox, BackupName, , �� %this_FileBoxItem% ������Ϊ��, , , , , , , , %this_FileBoxItem%
    if ErrorLevel
    {}
	else
	{
	   	StringReplace, BackupName, BackupName, \, _, All
		StringReplace, BackupName, BackupName, /, _, All
		StringReplace, BackupName, BackupName, :, _, All
		StringReplace, BackupName, BackupName, *, _, All
		StringReplace, BackupName, BackupName, ?, _, All
		StringReplace, BackupName, BackupName, `", _, All
		StringReplace, BackupName, BackupName, ``, _, All
		StringReplace, BackupName, BackupName, <, _, All
		StringReplace, BackupName, BackupName, >, _, All
		StringReplace, BackupName, BackupName, |, _, All
		StringReplace, BackupName, BackupName, ., _, All
		
		3ButtonRename_InnerStack:
		if BackupName=
		{
			Gui +OwnDialogs
			MsgBox 16,,��������ļ�����
		}
		Else
		{
			ifExist %ConfigPath%\%BackupName%.orzBackup
			{
				Gui +OwnDialogs
				MsgBox 19,,��%BackupName%�� �Ѵ��ڣ��Ƿ�ʹ�� ��%BackupName%_2����
				IfMsgBox Yes
				{
					BackupName = %BackupName%_2
					Goto 3ButtonRename_InnerStack
				}
			}
			Else
			{
				FileMove, %ConfigPath%\%this_FileBoxItem%.orzBackup, %ConfigPath%\%BackupName%.orzBackup
			}
		}
	}
}
Gosub 3RebuildFileBox
Return

3ButtonDelete:
GuiControlGet, FileBoxItem, 3:, FileBox
StringSplit, FileBoxItem, FileBoxItem, |
BackupDeletePrompt=
If FileBoxItem0 = 1
{
	BackupDeletePrompt=���Ҫɾ����%FileBoxItem1%����
}
Else
{
	BackupDeletePrompt=���Ҫɾ����%FileBoxItem1%���� %FileBoxItem0% ��������
}
Gui +OwnDialogs
Msgbox 291,,%BackupDeletePrompt%
IfMsgBox Yes
{
	Loop, %FileBoxItem0%
	{
	    this_FileBoxItem := FileBoxItem%a_index%
	    FileDelete, %ConfigPath%\%this_FileBoxItem%.orzBackup
	}
}
BackupDeletePrompt=
Gosub 3RebuildFileBox
Return

3ButtonExport:
GuiControlGet, FileBoxItem, 3:, FileBox
StringSplit, FileBoxItem, FileBoxItem, |
If FileBoxItem0 = 1
{
	Gui +OwnDialogs
	FileSelectFile, BackupExportFileName, S16, %FileBoxItem1%.orzBackup, �������ݡ�%FileBoxItem1%��, HostsX ���� (*.orzBackup)
	if BackupExportFileName=
	{
	}
	else
	{
		FileCopy, %ConfigPath%\%FileBoxItem1%.orzBackup, %BackupExportFileName%
	}
}
Else
{
	Gui +OwnDialogs
	FileSelectFolder, BackupExportFileName,,3, ���� %FileBoxItem0% �����ݡ�
	BackupExportFileName := RegExReplace(BackupExportFileName, "\\$")
	if BackupExportFileName =
	{
	}
	else
	{
		Loop, %FileBoxItem0%
		{
		    this_FileBoxItem := FileBoxItem%a_index%
		    FileCopy, %ConfigPath%\%this_FileBoxItem%.orzBackup, %BackupExportFileName%\%this_FileBoxItem%.orzBackup
		}
	}
}
Gosub 3RebuildFileBox
Return

3ButtonImport:
Gui +OwnDialogs
FileSelectFile, BackupImportFileNames, M35, , ���뱸��, HostsX ���� (*.orzBackup)
if BackupImportFileNames =
{
}
else
{
	Gui +OwnDialogs
	Loop, parse, BackupImportFileNames, `n
	{
	    if a_index = 1
	    {
	        BackupImportFileBasedPath = %A_LoopField%
			BackupImportFileBasedPath := RegExReplace(BackupImportFileBasedPath, "\\$")
		}
	    else
	    {
	    	StringRight, B_LoopField, A_LoopField, 10
	    	StringLower, B_LoopField, B_LoopField, 10
	    	If B_LoopField = .orzbackup
	    		C_LoopField = %A_LoopField%
	    	Else
	    		C_LoopField = %A_LoopField%.orzBackup
	        FileCopy %BackupImportFileBasedPath%\%A_LoopField%, %ConfigPath%\%C_LoopField%
	    }
	}
}
Gosub 3RebuildFileBox
Return

3RebuildFileBox:
FileBoxList=
FileBoxCount=0
IfExist, %ConfigPath%\*.orzBackup
{
	Loop, %ConfigPath%\*.orzBackup, 0, 0
	{
		StringLen, A_LoopFileNameLength, A_LoopFileName
		A_LoopFileNameLength -= 10
		StringLeft, B_LoopFileName, A_LoopFileName, %A_LoopFileNameLength%
		FileBoxList = %FileBoxList%%B_LoopFileName%|
		FileBoxCount++
	}
}
GuiControl, 3:Disable, ButtonRename
GuiControl, 3:Disable, ButtonDelete
GuiControl, 3:Disable, ButtonExport
GuiControl, 3:,FileBox,|
GuiControl, 3:,FileBox,%FileBoxList%
Return

3ButtonClose:
3GuiClose:
3GuiEscape:
Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
Gui Destroy  ; Destroy the about box.
Gosub BuildBackupMenu
return


InsertOtherAction:
action=%A_ThisMenuItem%
Loop, %SourceIndex%
{
	action2:=source%A_Index%Caption
	if (action=action2)
	{
		myname:=source%A_Index%Caption
		myurl:=source%A_Index%URL
		myaction:=source%A_Index%Action
		if myaction=ShellExecute
		{
			Run, %myurl%
		}
		else if myaction = Insert
		{
			TrayTip, ���롰%myname%����, �������ء�%myurl%��. . ., 30, 1
			Gui, 1:+Disabled
			EnvGet, Temp, Temp
			Random, rand, 10000, 99999
			UrlDownloadToFile,%myurl%, %temp%\HostsX%rand%.orz
			If ErrorLevel
			{
				FileDelete, %temp%\HostsX%rand%.orz
				TrayTip,
				
				Gui, 1:-Disabled
				Gui +OwnDialogs
				MsgBox,16,,���롰%myname%��ʧ�ܣ��޷����ӡ�%myurl%�������������Ƿ������Ⲣ�Ժ����ԡ�
				Return
			}
			FileRead, mycontent, %temp%\HostsX%rand%.orz
			FileDelete, %temp%\HostsX%rand%.orz
			TrayTip,
			mycontent := RegExReplace(mycontent, "\n\n", "`n")
			mycontent := RegExReplace(mycontent, "^\n", "")
			mycontent := RegExReplace(mycontent, "\n$", "")
			mycontent := mycontent
			SectionName=%myname%
			SectionContent=%mycontent%
			GuiControlGet, MainEdit
			Gosub AddOrReplaceSection
			GuiControl,, MainEdit, %MainEdit%
			Gui, 1:-Disabled
			GuiControl, Focus, MainEdit
			Send ^{END}
		}
	}
}
Return

InsertMenuAction:
action=%A_ThisMenu%/%A_ThisMenuItem%
StringMid action, action, 16
Loop, %ArrayCount%
{
	action2:=ArrayName%A_Index%
	if (action=action2)
	{
		myname:=ArrayFullName%A_Index%
		mycontent:=ArrayContent%A_Index%
	}
}
mycontent := RegExReplace(mycontent, "\n\n", "`n")
mycontent := RegExReplace(mycontent, "^\n", "")
mycontent := RegExReplace(mycontent, "\n$", "")
mycontent := mycontent
SectionName=%myname%
SectionContent=%mycontent%
GuiControlGet, MainEdit
Gosub AddOrReplaceSection
GuiControl,, MainEdit, %MainEdit%
GuiControl, Focus, MainEdit
Send ^{END}
Return

AddOrReplaceSection:
SectionBeginLine=#B#HostsX: %SectionName%
SectionEndLine=#E#HostsX: %SectionName%
SectionBegin:=RegExMatch(MainEdit, "im)(*ANYCRLF)^" . SectionBeginLine . "$")
SectionEnd:=RegExMatch(MainEdit, "im)(*ANYCRLF)^" . SectionEndLine . "$")
SpecialHosts:=RegExMatch(SectionContent, "m)\$FUNCTION:([A-Za-z0-9]*)", SpecialHostsPart)
If SpecialHosts
{
	If (SpecialHosts != 0)
	{
		if IsFunc("SpecialHosts" . SpecialHostsPart1)
		{
			SectionContent := SpecialHosts%SpecialHostsPart1%()
		}
	}
}
If (SectionBegin = 0 and SectionEnd = 0)
{
	if InsertHostsItemsNoAdd<>true
		Gosub AddSection
}
Else
{
Gosub ReplaceSection
}
Return

AddSection:
MainEdit=%MainEdit%`n%SectionBeginLine%`n%SectionContent%`n%SectionEndLine%`n
Return

ReplaceSection:
MainEditBefore:=SubStr(MainEdit, 1, SectionBegin - 1)
MainEditAfter:=SubStr(MainEdit, SectionEnd + StrLen(SectionEndLine))
MainEditNew=%SectionBeginLine%`n%SectionContent%`n%SectionEndLine%
MainEdit=%MainEditBefore%%MainEditNew%%MainEditAfter%
Return

ParseWhitelist:
WhitelistValid = false
IfNotExist, %ConfigPath%\HostsXWhitelist.orzhosts
{
	Return
}
WhitelistValid = true
ArrayWhitelistCount = 0
ArrayWhitelistFR = F
Loop, Read, %ConfigPath%\HostsXWhitelist.orzhosts
{
	Length := StrLen(A_LoopReadLine)
	if Length > 1
	{
		fch:=SubStr(A_LoopReadLine, 1, 1)
		if fch=#
		{
			ArrayWhitelistCount += 1
			caption2:=SubStr(A_LoopReadLine, 2)
			StringReplace, captionmenu2, caption2, &, &&, All
			ArrayWhiteListTitle%ArrayWhitelistCount%=%caption2%
			ArrayWhiteListFind%ArrayWhitelistCount%=
			ArrayWhiteListReplace%ArrayWhitelistCount%=
			ArrayWhitelistFR = F
		}
		else if fch=;
		{
			comment:=SubStr(A_LoopReadLine, InStr(SubStr(A_LoopReadLine, 2), "=")+2)
			commentname:=SubStr(SubStr(A_LoopReadLine, 1, InStr(A_LoopReadLine, "=")-1),2)
			CommentWhiteList%commentname%:=comment
		}
		else if fch=$
		{
			ArrayWhitelistFR = R
			ArrayWhiteListReplace%ArrayWhitelistCount%:=ArrayWhiteListReplace%ArrayWhitelistCount% . A_LoopReadLine . "`n"
		}
		else
		{
			If ArrayWhitelistFR = F
			{
				ArrayWhiteListFind%ArrayWhitelistCount%:=ArrayWhiteListFind%ArrayWhitelistCount% . A_LoopReadLine . "`n"
			}
			Else If ArrayWhitelistFR = R
			{
				ArrayWhiteListReplace%ArrayWhitelistCount%:=ArrayWhiteListReplace%ArrayWhitelistCount% . A_LoopReadLine . "`n"
			}
		}
	}
}
Gosub BuildUpdateMenu
;Msgbox % ArrayWhitelistCount
;Msgbox % ArrayWhiteListTitle1
;Msgbox % ArrayWhiteListFind1
;Msgbox % ArrayWhiteListReplace1
Return

F10::
CheckWhitelist:
Loop, %ArrayWhitelistCount%
{
	wTitle := ArrayWhiteListTitle%A_Index%
	wFind := ArrayWhiteListFind%A_Index%
	wReplace := ArrayWhiteListReplace%A_Index%
	wResult := CheckWhiteListItem(wTitle, wFind, wReplace, CheckWhitelistSilentMode)
	if wResult = exit
	{
		return
	}
}
If CheckWhitelistInappMode = true
{
	CheckWhitelistInappMode = false
}
Else
{
	TrayTip, HostsX ��ʾ, �ɹ�ִ�г�������, 30, 1
}
Return

CheckWhiteListItem(wTitle, wFind, wReplace, CheckWhitelistSilentMode)
{
	wFoundItem=
	Loop, parse, wFind, `n, `r
	{
		GuiControlGet, MainEdit
		If (Asc(A_LoopField) = 0)
		{ }
		Else
		{
			wRegExp = %A_LoopField%
			StringReplace wRegExp, wRegExp, ., \., All
			wRegExp=m)(*ANYCRLF)^([0-9a-f:.]+)([�� 	]*)([a-z0-9.	 ��]*)(%wRegExp%)[�� 	]*([a-z0-9.	 ��]*)$
	    	wFound:=RegExMatch(MainEdit,wRegExp)
	    	if ErrorLevel
	    	{}
	    	else if wFound>0
	    		wFoundItem=%wFoundItem%%A_LoopField%`n
	    }
	}
	if wFoundItem=
	{}
	Else
	{
		wFoundItem :=RegExReplace(wFoundItem, "`n$", "")
		if (substr(wTitle,1,1) = "!")
		{
			wTitle := substr(wtitle,2)
			wDefaultCancel = true
		}
		wPrompt = 
(
��⵽��������� Hosts �
%wFoundItem%

������Ϣ��
%wTitle%

�Ƿ�Դ�������޸���
)
		wPromptResult =
		if CheckWhitelistSilentMode = orzYes
		{
			if wDefaultCancel = true
				wPromptResult = No
			Else
				wPromptResult = Yes
		}
		Else
		{
			if wDefaultCancel = true
				Msgbox 291,, %wPrompt%
			Else
				Msgbox 35,, %wPrompt%
			
			ifMsgBox Cancel
				wPromptResult = Cancel
			Else ifmsgbox yes
				wPromptResult = Yes
		}

		If wPromptResult = Cancel
			return "exit"
		Else If wPromptResult = Yes
		{
			w_ActionName=
			w_ActionParam=
			Loop, parse, wReplace, `n, `r
			{
				w_LoopFCH :=substr(A_LoopField,1,1)
				if w_LoopFCH = $
				{
					if (w_ActionName!="")
					{
						if IsFunc("CheckWhitelistAction" . w_ActionName)
						{
							CheckWhitelistAction%w_ActionName%(wFind, wFoundItem, w_ActionParam)
						}
						w_ActionName=
						w_ActionParam=
					}
					w_ActionName:=substr(A_LoopField,2)
					w_ActionParam=
				}
				else
				{
					w_ActionParam=%w_ActionParam%%A_LoopField%`n
				}
			}
			if IsFunc("CheckWhitelistAction" . w_ActionName)
			{
				CheckWhitelistAction%w_ActionName%(wFind, wFoundItem, w_ActionParam)
			}
		}
	}
	return ""
}

CheckWhitelistActionDelete(wFind, wFoundItem, w_ActionParam)
{
	Loop, parse, wFoundItem, `n, `r
	{
		GuiControlGet, MainEdit
		If (Asc(A_LoopField) = 0)
		{ }
		Else
		{
			wRegExp = %A_LoopField%
			StringReplace wRegExp, wRegExp, ., \., All
			wRegExp=m)(*ANYCRLF)^([0-9a-f:.]+)([�� 	]*)([a-z0-9.	 ��]*)(%wRegExp%)[�� 	]*([a-z0-9.	 ��]*)$
	    	wFound:=RegExMatch(MainEdit,wRegExp,wSubpart)
	    	if ErrorLevel
	    	{}
	    	else if wFound>0
	    	{
		    	if ((wSubpart3 . wSubpart5)="")
		    	{
		    		MainEdit := RegExReplace(MainEdit, wRegExp, "")
		    	}
		    	Else
		    	{
		    		MainEdit := RegExReplace(MainEdit, wRegExp, wSubPart1 . wSubpart2 . wSubpart3 . " " . wSubpart5)
		    	}
		    	GuiControl,, MainEdit, %MainEdit%
	    	}
	    }
	}
}

CheckWhitelistActionReplace(wFind, wFoundItem, w_ActionParam)
{
	wFirstTime = true
	Loop, parse, wFoundItem, `n, `r
	{
		GuiControlGet, MainEdit
		If (Asc(A_LoopField) = 0)
		{ }
		Else
		{
			wRegExp = %A_LoopField%
			StringReplace wRegExp, wRegExp, ., \., All
			wRegExp=m)(*ANYCRLF)^([0-9a-f:.]+)([�� 	]*)([a-z0-9.	 ��]*)(%wRegExp%)[�� 	]*([a-z0-9.	 ��]*)$
	    	wFound:=RegExMatch(MainEdit,wRegExp,wSubpart)
	    	if ErrorLevel
	    	{}
	    	else if wFound>0
	    	{
	    		if wFirstTime = true
	    		{
	    			StringReplace wParam, w_ActionParam, `n, %A_Space%, All
	    			StringReplace wParam, wParam, `r, %A_Space%, All
	    			MainEdit := RegExReplace(MainEdit, wRegExp, "$1$2$3" . RegExReplace(wParam, " $","") . "$5")
	    			wFirstTime=false
	    		}
	    		else
	    		{
			    	if ((wSubpart3 . wSubpart5)="")
			    	{
			    		MainEdit := RegExReplace(MainEdit, wRegExp, "")
			    	}
			    	Else
			    	{
			    		MainEdit := RegExReplace(MainEdit, wRegExp, "$1$2$3 $5")
			    	}
		    	}
		    	GuiControl,, MainEdit, %MainEdit%
	    	}
	    }
	}
}

UpdateWhitelist:
TrayTip, HostsX ���������������ݸ�����, ���ڷ��� orzTech.com ���µ��б�. . ., 30, 1
updateList:=UrlDownloadToVar("http://orztech.com/labs/HostsX.lh/autoupdate.txt?type=HostsXWhitelist.orzhosts&ver=" . RegExReplace(applicationversion, " ", "+"))
If ErrorLevel
{
	TrayTip, HostsX ���������������ݸ���ʧ��, �޷����� orzTech.com ���µ��б����������Ƿ������Ⲣ�Ժ����ԡ�, 30, 3
	Return
}
updateListCount=0
Loop, parse, updateList, `n, `r  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
{
	updateListCount+=1
}
TrayTip, HostsX ���������������ݸ�����, �����Ӹ��µ��б�`n�õ� %updateListCount% �����µ㡣`n`n��Ϣ 1s ��ʼ����. . ., 30, 1
Sleep, 1000
updateListIndex=0
Loop, parse, updateList, `n, `r  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
{
	updateListIndex+=1
	TrayTip, HostsX ���������������ݸ�����, �������ӵ� %updateListIndex% �����µ�. . ., 30, 1
    UrlDownloadToFile, %A_LoopField%HostsXWhitelist.orzhosts, %ConfigPath%\HostsXWhitelist.orzhosts
	If ErrorLevel
	{
		TrayTip, HostsX ���������������ݸ�����, �޷����ӵ� %updateListIndex% �����µ㣬`n`n��Ϣ 2s ʹ���¸����µ�. . ., 30, 2
		Sleep, 2000
	}
	Else
	{
		Gosub ParseWhitelist
		TrayTip, HostsX ���������������ݸ������, ���°汾�ţ�%Commentversion%��`n��ͨ�������ߡ��˵����а�������顣, 30, 1
		return
	}
}
TrayTip, HostsX ���������������ݸ���ʧ��, �޷������κθ��µ㣬���������Ƿ������Ⲣ�Ժ����ԡ�, 30, 3
return

UpdateHostsFile:
TrayTip, HostsX ���ݸ�����, ���ڷ��� orzTech.com ���µ��б�. . ., 30, 1
updateList:=UrlDownloadToVar("http://orztech.com/labs/HostsX.lh/autoupdate.txt?type=HostsX.orzhosts&ver=" . RegExReplace(applicationversion, " ", "+"))
If ErrorLevel
{
	TrayTip, HostsX ���ݸ���ʧ��, �޷����� orzTech.com ���µ��б����������Ƿ������Ⲣ�Ժ����ԡ�, 30, 3
	Return
}
updateListCount=0
Loop, parse, updateList, `n, `r  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
{
	updateListCount+=1
}
TrayTip, HostsX ���ݸ�����, �����Ӹ��µ��б�`n�õ� %updateListCount% �����µ㡣`n`n��Ϣ 1s ��ʼ����. . ., 30, 1
Sleep, 1000
updateListIndex=0
Loop, parse, updateList, `n, `r  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
{
	updateListIndex+=1
	TrayTip, HostsX ���ݸ�����, �������ӵ� %updateListIndex% �����µ�. . ., 30, 1
    UrlDownloadToFile, %A_LoopField%HostsX.orzhosts, %ConfigPath%\HostsX.orzhosts
	If ErrorLevel
	{
		TrayTip, HostsX ���ݸ�����, �޷����ӵ� %updateListIndex% �����µ㣬`n`n��Ϣ 2s ʹ���¸����µ�. . ., 30, 2
		Sleep, 2000
	}
	Else
	{
		GoSub BuildInsertMenu
		TrayTip, HostsX ���ݸ������, ���°汾�ţ�%Commentversion%��`n��ͨ�������롱�˵��������°汾�����ˡ�, 30, 1
		Gosub BuildUpdateMenu
		return
	}
}
TrayTip, HostsX ���ݸ���ʧ��, �޷������κθ��µ㣬���������Ƿ������Ⲣ�Ժ����ԡ�, 30, 3
Return

UpdateAll:
GoSub UpdateHostsFile
Gosub UpdateOtherHosts
GoSub UpdateWhitelist
Return

OneKeyUpdate:
ToolTip, һ�������� . . .
Gui +Disabled
GoSub UpdateHostsFile
Gosub UpdateOtherHosts
GoSub UpdateWhitelist
InsertHostsItems=
InsertHostsItemsNoAdd=true
Gosub InsertHostsItems
ToolTip, һ�������� . . .
Gui +Disabled
Loop, %SourceIndex%
{
	SectionName:=source%A_Index%Caption
	SectionBeginLine=#B#HostsX: %SectionName%
	SectionEndLine=#E#HostsX: %SectionName%
	SectionBegin:=RegExMatch(MainEdit, "im)(*ANYCRLF)^" . SectionBeginLine . "$")
	SectionEnd:=RegExMatch(MainEdit, "im)(*ANYCRLF)^" . SectionEndLine . "$")
	If (SectionBegin = 0 and SectionEnd = 0)
	{}
	else
	{
		myname:=source%A_Index%Caption
		myurl:=source%A_Index%URL
		TrayTip, ���롰%myname%����, �������ء�%myurl%��. . ., 30, 1
		Gui, 1:+Disabled
		EnvGet, Temp, Temp
		Random, rand, 10000, 99999
		UrlDownloadToFile,%myurl%, %temp%\HostsX%rand%.orz
		If ErrorLevel
		{
			FileDelete, %temp%\HostsX%rand%.orz
		}
		else
		{
			FileRead, mycontent, %temp%\HostsX%rand%.orz
			FileDelete, %temp%\HostsX%rand%.orz
			mycontent := RegExReplace(mycontent, "\n\n", "`n")
			mycontent := RegExReplace(mycontent, "^\n", "")
			mycontent := RegExReplace(mycontent, "\n$", "")
			mycontent := mycontent
			SectionName=%myname%
			SectionContent=%mycontent%
			Gosub AddOrReplaceSection
		}
	}
}
GuiControl,, MainEdit, %MainEdit%

CheckWhitelistInappMode = true
_CheckWhitelistSilentMode = %CheckWhitelistSilentMode%
CheckWhitelistSilentMode = orzYes
Gosub CheckWhitelist
CheckWhitelistInappMode = false
CheckWhitelistSilentMode = %_CheckWhitelistSilentMode%

Gui -Disabled
GuiControl, Focus, MainEdit
Send ^{END}
ToolTip
TrayTip, HostsX ��ʾ, һ������ִ�гɹ���������½����,30,1
Return

UpdateOtherHosts:
TrayTip, HostsX �Ƽ������б������, ���ڷ��� orzTech.com ���µ��б�. . ., 30, 1
updateList:=UrlDownloadToVar("http://orztech.com/labs/HostsX.lh/autoupdate.txt?type=HostsX.orzsource&ver=" . RegExReplace(applicationversion, " ", "+"))
If ErrorLevel
{
	TrayTip, HostsX �Ƽ������б����ʧ��, �޷����� orzTech.com ���µ��б����������Ƿ������Ⲣ�Ժ����ԡ�, 30, 3
	Return
}
updateListCount=0
Loop, parse, updateList, `n, `r  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
{
	updateListCount+=1
}
TrayTip, HostsX �Ƽ������б������, �����Ӹ��µ��б�`n�õ� %updateListCount% �����µ㡣`n`n��Ϣ 1s ��ʼ����. . ., 30, 1
Sleep, 1000
updateListIndex=0
Loop, parse, updateList, `n, `r  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
{
	updateListIndex+=1
	TrayTip, HostsX �Ƽ������б������, �������ӵ� %updateListIndex% �����µ�. . ., 30, 1
    UrlDownloadToFile, %A_LoopField%HostsX.orzsource, %ConfigPath%\HostsX.orzsource
	If ErrorLevel
	{
		TrayTip, HostsX �Ƽ������б����ݸ�����, �޷����ӵ� %updateListIndex% �����µ㣬`n`n��Ϣ 2s ʹ���¸����µ�. . ., 30, 2
		Sleep, 2000
	}
	Else
	{
		GoSub BuildInsertMenu
		TrayTip, HostsX �Ƽ������б�������, ���°汾�ţ�%Commentsourceversion%��`n��ͨ�������롱�˵��������°汾�����ˡ�, 30, 1
		Gosub BuildUpdateMenu
		return
	}
}
TrayTip, HostsX �Ƽ������б����ʧ��, �޷������κθ��µ㣬���������Ƿ������Ⲣ�Ժ����ԡ�, 30, 3
Return


UrlDownloadToVar(URL, Proxy="", ProxyBypass="") {
	AutoTrim, Off
	hModule := DllCall("LoadLibrary", "str", "wininet.dll")

	AccessType = 0
	;INTERNET_OPEN_TYPE_PRECONFIG                    0   // use registry configuration
	;INTERNET_OPEN_TYPE_DIRECT                       1   // direct to net
	;INTERNET_OPEN_TYPE_PROXY                        3   // via named proxy
	;INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY  4   // prevent using java/script/INS

	io_hInternet := DllCall("wininet\InternetOpenA"
	, "str", "" ;lpszAgent
	, "uint", AccessType
	, "str", Proxy
	, "str", ProxyBypass
	, "uint", 0) ;dwFlags

	iou := DllCall("wininet\InternetOpenUrlA"
	, "uint", io_hInternet
	, "str", url
	, "str", "" ;lpszHeaders
	, "uint", 0 ;dwHeadersLength
	, "uint", 0x80000000 ;dwFlags: INTERNET_FLAG_RELOAD = 0x80000000 // retrieve the original item
	, "uint", 0) ;dwContext

	If (ErrorLevel != 0 or iou = 0) {
	DllCall("FreeLibrary", "uint", hModule)
	return 0
	}

	VarSetCapacity(buffer, 512, 0)
	VarSetCapacity(NumberOfBytesRead, 4, 0)
	Loop
	{
	  irf := DllCall("wininet\InternetReadFile", "uint", iou, "uint", &buffer, "uint", 512, "uint", &NumberOfBytesRead)
	  NOBR = 0
	  Loop 4  ; Build the integer by adding up its bytes. - ExtractInteger
		NOBR += *(&NumberOfBytesRead + A_Index-1) << 8*(A_Index-1)
	  IfEqual, NOBR, 0, break
	  ;BytesReadTotal += NOBR
	  DllCall("lstrcpy", "str", buffer, "uint", &buffer)
	  res = %res%%buffer%
	}
	StringTrimRight, res, res, 1

	DllCall("wininet\InternetCloseHandle",  "uint", iou)
	DllCall("wininet\InternetCloseHandle",  "uint", io_hInternet)
	DllCall("FreeLibrary", "uint", hModule)
	AutoTrim, on
	return, res
}

HostsDelComments:
Gui +Disabled
GuiControlGet, MainEdit
MainEdit:=RegExReplace(MainEdit, "im)(*ANYCRLF)^[^0-9a-f.:].*$", "")
MainEdit:=RegExReplace(MainEdit, "`n+", "`n")
MainEdit:=RegExReplace(MainEdit, "^`n", "")
MainEdit:=RegExReplace(MainEdit, "`n$", "")
GuiControl,, MainEdit, %MainEdit%
Gui -Disabled
TrayTip, HostsX ��ʾ, ɾ��ע������ɣ�, 30, 1
Return

HostsSort:
Gui +Disabled
GuiControlGet, MainEdit
MainEdit:=RegExReplace(MainEdit, "im)(*ANYCRLF)^[^0-9a-f.:].*$", "")
MainEdit:=RegExReplace(MainEdit, "im)(*ANYCRLF)#.*$", "`n")
MainEdit:=RegExReplace(MainEdit, "im)(*ANYCRLF)\s*$", "`n")
MainEdit:=RegExReplace(MainEdit, "im)(*ANYCRLF)^\s*", "`n")
MainEdit:=RegExReplace(MainEdit, "`n+", "`n")
MainEdit:=RegExReplace(MainEdit, "^`n", "")
MainEdit:=RegExReplace(MainEdit, "`n$", "")
MainEdit:=RegExReplace(MainEdit, "[ 	]+", "`t")
Tooltip, ������...
Sort, MainEdit, F HostsSort U
Tooltip
GuiControl,, MainEdit, %MainEdit%
Gui -Disabled
TrayTip, HostsX ��ʾ, ����ɾ���ظ�������ɣ�, 30, 1
Return
HostsSort(a1, a2)
{
	b1:=RegExReplace(a1, "^(.*)`t(.*)$", "$2")
	b2:=RegExReplace(a2, "^(.*)`t(.*)$", "$2")
	return b1 > b2 ? 1 : b1 < b2 ? -1 : 0
}


HostsSortDie(a1, a2)
{

	a21:=RegExReplace(a1, "^(.*)`t(.*)$", "$1")
	a22:=RegExReplace(a2, "^(.*)`t(.*)$", "$1")
	b1:=RegExReplace(a1, "^(.*)`t(.*)$", "$2")
	b2:=RegExReplace(a2, "^(.*)`t(.*)$", "$2")
	StringSplit, c1, b1,.
	c1:=c10-1
	if c1<>-1
	{
		if c1=0
			c1=1
		c1:="c1" . c1
		c1:=%c1%
	}
	Else
		c1:=b1

	StringSplit, c2, b2,.
	c2:=c20-1
	if c2<>-1
	{
		if c2=0
			c2=1
		c2:="c2" . c2
		c2:=%c2%
	}
	Else
		c2:=b2

	If c1=c2
	{
		return 0
	}
	Else if c1 > c2
		return 1
	Else
		return -1
}

HostsReplace0000:
GuiControlGet, MainEdit
StringReplace MainEdit, MainEdit, 127.0.0.1, 0.0.0.0, All
StringReplace MainEdit, MainEdit, 127.1, 0.0.0.0, All
GuiControl,, MainEdit, %MainEdit%
Return

HostsReplace1271:
GuiControlGet, MainEdit
StringReplace MainEdit, MainEdit, 0.0.0.0, 127.1, All
StringReplace MainEdit, MainEdit, 127.0.0.1, 127.1, All
GuiControl,, MainEdit, %MainEdit%
Return

HostsReplace127001:
GuiControlGet, MainEdit
StringReplace MainEdit, MainEdit, 0.0.0.0, 127.0.0.1, All
StringReplace MainEdit, MainEdit, 127.1, 127.0.0.1, All
GuiControl,, MainEdit, %MainEdit%
Return

InsertHostsItemsAction:
StringMid, InsertHostsItems, A_ThisMenu, 16
Gosub InsertHostsItems
Return

InsertHostsItems:
Tooltip, ������. . .
Gui +Disabled
GuiControlGet, MainEdit
Loop, %ArrayCount%
{
	action2:=ArrayFullName%A_Index%
	inserthostsfound:=InStr(action2, InsertHostsItems, false, 1)
	if inserthostsfound >=1
	{
		myname:=ArrayFullName%A_Index%
		mycontent:=ArrayContent%A_Index%
		mycontent := RegExReplace(mycontent, "`n`n", "`n")
		mycontent := RegExReplace(mycontent, "^`n", "")
		mycontent := RegExReplace(mycontent, "`n$", "")
		mycontent := mycontent
		SectionName=%myname%
		SectionContent=%mycontent%
		Gosub AddOrReplaceSection
	}
}
GuiControl,, MainEdit, %MainEdit%
Gui -Disabled
GuiControl, Focus, MainEdit
Tooltip
Send ^{END}
InsertHostsItemsNoAdd=
Return

HostsWrap:
GuiControlGet, MainEdit
StringReplace MainEdit, MainEdit, `r, `n`n, All
StringReplace MainEdit, MainEdit, `n, `n`n, All
MainEdit:=RegExReplace(MainEdit, "`n+", "`n")
GuiControl,, MainEdit, %MainEdit%
Return


^F::
EditFind:
if Found<>true
{
	WinGet ControlID, ID
	Dlg_Find(hGui, "OnFindReplace", "-d-w-c")
	hFind:=WinActive("A")
	Found=true
}
Else
{
	WinActivate ahk_id %hFind%
}
Return

^H::
EditReplace:
if Found<>true
{
	WinGet ControlID, ID
	Dlg_Replace(hGui, "OnFindReplace", "-d-w-c")
	hFind:=WinActive("A")
	Found=true
}
Else
{
	WinActivate ahk_id %hFind%
}
Return

OnFindReplace(Event, Flags, FindText, ReplaceText){
	if Event contains C
	{
		global Found=false
		return
	}
	if Event contains F
	{
		global find:=FindText
		global replace:=
		Gosub EditFindNext
	}
	if Event contains R
	{
		global find:=FindText
		global replace:=ReplaceText
		Gosub EditFindNext
	}
	if Event contains A
	{
		global find:=FindText
		global replace:=ReplaceText
		GuiControlGet, MainEdit
		StringReplace MainEdit,MainEdit,%FindText%,%ReplaceText%,UseErrorLevel
		hitcount=%Errorlevel%
		ToolTip �滻��ɣ����滻 %hitcount% ����
		SetTimer, RemoveToolTip, 5000
		GuiControl,, MainEdit, %MainEdit%
	}
}

F3::
GoSub EditFindNext
Return

EditFindNext:
if find=
	Return
if (find != lastFind) {
	offset = 0
	hits = 0
	addToPos=0
}
GuiControl 1:Focus, MainEdit                           ; focus on main help window to show selection
;SendMessage 0xB6, 0, -999, Edit1, ahk_id %ControlID%  ; Scroll to top
GuiControlGet, MainEdit
StringGetPos pos, MainEdit, %find% ,,offset-addToPos            ; find the position of the search string
if (pos = -1) {
	if (offset = 0) {
	  ToolTip �Ҳ�����%find%����
	  SetTimer, RemoveToolTip, 5000
	}
	else {
	  ToolTip �޷��ٴ��ҵ���%find%����
	  SetTimer, RemoveToolTip, 5000
	  offset = 0
	  hits = 0
	}
	return
}
StringLeft __s, MainEdit, %pos%                        ; cut off end to count lines
StringReplace __s,__s,`n,`n,UseErrorLevel             ; Errorlevel <- line number
addToPos=%Errorlevel%
SendMessage 0xB6, 0, ErrorLevel, Edit1, ahk_id %ControlID% ; Scroll to visible
SendMessage 0xB1, pos + addToPos, pos + addToPos + Strlen(find), Edit1, ahk_id %ControlID% ; Select search text
if replace
{
	if Found=true
	{
		ClipSaved := ClipboardAll   ; Save the entire clipboard to a variable of your choice.
		Clipboard=%replace%
		Send ^V
		SendMessage 0xB1, pos + addToPos, pos + addToPos + Strlen(replace), Edit1, ahk_id %ControlID% ; Select search text
		Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
	}
}
; http://msdn.microsoft.com/en-us/library/bb761637(VS.85).aspx
; Scroll the caret into view in an edit control:
SendMessage, EM_SCROLLCARET := 0xB7, 0, 0, Edit1, ahk_id %ControlID%
offset := pos + addToPos + Strlen(find)
lastFind = %find%
hits++
myhits:=addToPos + 1
StringReplace MainEdit,MainEdit,%find%,%find%,UseErrorLevel
hitcount=%Errorlevel%
ToolTip �ڵ� %myhits% ���ҵ���%find%��`n�� %hits% ������ %hitcount% ����
SetTimer, RemoveToolTip, 5000
Return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return

ToolsCleanWMP:
ToolTip ������� Windows Media Player ������. . .
RegDelete, HKCU, Software\Microsoft\MediaPlayer\Services\FaroLatino_CN
RegDelete, HKCU, Software\Microsoft\MediaPlayer\Subscriptions
RegDelete, HKLM, SOFTWARE\Microsoft\MediaPlayer\services\FaroLatino_CN
ToolTip
TrayTip, HostsX ��ʾ, ��� Windows Media Player ������ɹ���, 30, 1
Return

F7::
ToolsCleanDNS:
ToolTip �������� DNS ����. . .
RunWait, ipconfig.exe /flushdns, , Hide
ToolTip
TrayTip, HostsX ��ʾ, ���� DNS ����ɹ���, 30, 1
Return

F8::
ToolsCleanIE:
ToolTip �������� Internet Explorer ����. . .
EnvGet, UserProfile, UserProfile
FileRemoveDir, %userprofile%\local Settings\Temporary Internet Files\, true
If ErrorLevel
{
	Gui +OwnDialogs
	MsgBox, 16,,����ʧ�ܡ���ǰ�û�����û��Ȩ�ޣ���ʹ�ù���Աģʽ���У�
	Return
}
FileCreateDir %userprofile%\local Settings\Temporary Internet Files\
ToolTip
TrayTip, HostsX ��ʾ, ���� Internet Explorer ����ɹ���, 30, 1
Return

F5::
ToolsLockHosts:
ToolTip ���ڸ� Hosts �ļ�����. . .
RunWait, %comspec% /c "echo y|cacls %A_WinDir%\System32\drivers\etc\hosts /g everyone:r",, Hide
FileSetAttrib +ASRH,%A_WinDir%\System32\drivers\etc\hosts
ToolTip
TrayTip, HostsX ��ʾ, Hosts �ļ������ɹ���, 30, 1
Return

F6::
ToolsUnlockHosts:
ToolTip ���ڸ� Hosts �ļ�����. . .
RunWait, %comspec% /c "echo y|cacls %A_WinDir%\System32\drivers\etc\hosts /g everyone:f >nul",, Hide
FileSetAttrib -ASRH, %A_WinDir%\System32\drivers\etc\hosts
ToolTip
TrayTip, HostsX ��ʾ, Hosts �ļ������ɹ���, 30, 1
Return

FormatFont:
Gui +Disabled  ; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
Dlg_Font( font := Font, style := Style, color:=Color)
Gui -Disabled
GuiControl, Focus, MainEdit
Gui Font, %Style% c%Color%, %Font%
GuiControl, Font, MainEdit
Return

ToolsPing:
Gui +OwnDialogs
InputBox, Ping , Ping ����, ������Ҫ Ping ���������� IP��
If Ping<>
	Run, %comspec% /c "title HostsX - Ping&%A_WinDir%\System32\ping.exe %Ping% & pause"
Return


ToolsNSLookup:
Gui +OwnDialogs
InputBox, NSLookup , NSLookup ����, ������Ҫ NSLookup ����������
Gui +Disabled
ToolTip, NsLookuping..,
If NSLookup<>
{
	EnvGet, Temp, Temp
	Random, rand, 10000, 99999
	RunWait, %comspec% /c "echo exit|%A_WinDir%\System32\nslookup.exe -type=all %NSLookup%>`"%temp%\HostsX%rand%.orz`"",,	Hide
	IfExist %temp%\HostsX%rand%.orz
	{
		FileRead, NSLookup, %temp%\HostsX%rand%.orz
		InsertContent:=RegExReplace(NSLookup, "im)(*ANYCRLF)^", "# ")
		Gosub InsertContent
		FileDelete, %temp%\HostsX%rand%.orz
	}
}
Gui -Disabled
ToolTip,
Return

ReloadSettings:
setting=%ConfigPath%\HostsX.orzconfig
IfNotExist, %setting%
{
	FileAppend,[orzTech/HostsX], %setting%
}
IniRead, Font, %setting%, orzTech/HostsX, Font
IniRead, Style, %setting%, orzTech/HostsX, FontStyle
IniRead, Color, %setting%, orzTech/HostsX, FontColor
IniRead, UpdateAtStartup, %setting%, orzTech/HostsX, UpdateAtStartup
IniRead, UpdateWhenMissing, %setting%, orzTech/HostsX, UpdateWhenMissing
IniRead, CheckWhitelistSilentMode, %setting%, orzTech/HostsX, CheckWhitelistSilentMode
IniRead, CheckWhitelistAfterOpen, %setting%, orzTech/HostsX, CheckWhitelistAfterOpen
If Font=ERROR
	Font=Fixedsys
If FontStyle=ERROR
	FontStyle=s12
If FontColor=ERROR
	FontColor=0x000000
If UpdateAtStartup=ERROR
	UpdateAtStartup=orzNo
If UpdateWhenMissing=ERROR
	UpdateWhenMissing=orzYes
If CheckWhitelistSilentMode=ERROR
	CheckWhitelistSilentMode=orzNo
If CheckWhitelistAfterOpen=ERROR
	CheckWhitelistAfterOpen=orzYes
Return

SaveSettings:
IniWrite, %Font%, %setting%, orzTech/HostsX, Font
IniWrite, %Style%, %setting%, orzTech/HostsX, FontStyle
IniWrite, %Color%, %setting%, orzTech/HostsX, FontColor
IniWrite, %UpdateAtStartup%, %setting%, orzTech/HostsX, UpdateAtStartup
IniWrite, %UpdateWhenMissing%, %setting%, orzTech/HostsX, UpdateWhenMissing
IniWrite, %CheckWhitelistSilentMode%, %setting%, orzTech/HostsX, CheckWhitelistSilentMode
IniWrite, %CheckWhitelistAfterOpen%, %setting%, orzTech/HostsX, CheckWhitelistAfterOpen
Return

InsertContent:
GuiControl, Focus, MainEdit
ClipSaved := ClipboardAll   ; Save the entire clipboard to a variable of your choice.
Clipboard=%InsertContent%
Send ^V
Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).

Return

InsertLookupIPLocal:
Gui +OwnDialogs
InputBox, HostNames , �ڱ��ؽ���������������, ������Ҫ��������������`n`n��ʾ��������ʹ�ö��ŷָ������������
ToolTip, ������. . .
InsertContent=
Loop, parse, HostNames, `,
{
	ToolTip, ������%A_LoopField%����. . .
	IP:=Host2IP(A_LoopField)
	If ErrorLevel
	{
		IP:=GetErrorHost2IP(IP)
		InsertContent=%InsertContent%#HostsX: ������%A_LoopField%�����ִ���%IP%`r`n
	}
	Else
	{
		InsertContent=%InsertContent%%IP%`t%A_LoopField%`r`n
	}
}
ToolTip
Gosub InsertContent
Return

/* Title:	Dlg
			*Common Operating System Dialogs*
 */

/*
 Function:		Color
				(See Dlg_color.png)

 Parameters:
				Color	- Initial color and output in RGB format.
				hGui	- Optional handle to parents Gui. Affects dialog position.

 Returns:
				False if user canceled the dialog or if error occurred
 */
Dlg_Color(ByRef Color, hGui=0){
  ;covert from rgb
    clr := ((Color & 0xFF) << 16) + (Color & 0xFF00) + ((Color >> 16) & 0xFF)

    VarSetCapacity(CHOOSECOLOR, 0x24, 0), VarSetCapacity(CUSTOM, 64, 0)
     ,NumPut(0x24,		CHOOSECOLOR, 0)      ; DWORD lStructSize
     ,NumPut(hGui,		CHOOSECOLOR, 4)      ; HWND hwndOwner (makes dialog "modal").
     ,NumPut(clr,		CHOOSECOLOR, 12)     ; clr.rgbResult
     ,NumPut(&CUSTOM,	CHOOSECOLOR, 16)     ; COLORREF *lpCustColors
     ,NumPut(0x00000103,CHOOSECOLOR, 20)     ; Flag: CC_ANYCOLOR || CC_RGBINIT

    nRC := DllCall("comdlg32\ChooseColorA", str, CHOOSECOLOR)  ; Display the dialog.
    if (errorlevel <> 0) || (nRC = 0)
       return  false

    clr := NumGet(CHOOSECOLOR, 12)

    oldFormat := A_FormatInteger
    SetFormat, integer, hex  ; Show RGB color extracted below in hex format.

 ;convert to rgb
    Color := (clr & 0xff00) + ((clr & 0xff0000) >> 16) + ((clr & 0xff) << 16)
    StringTrimLeft, Color, Color, 2
    loop, % 6-strlen(Color)
		Color=0%Color%
    Color=0x%Color%
    SetFormat, integer, %oldFormat%
	return true
}

/*

 Function:     Find / Replace
				(See Dlg_find.png)
				(See Dlg_replace.png)

 Parameters:
               hGui    - Handle to the parent.
               Handler - Notification handler, see below.
               Flags   - Creation flags, see below.
               FindText - Default text to be displayed at the start of the dialog box in find edit box.
               ReplaceText - Default text to be displayed at the start of the dialog box in replace edit box.

 Flags:
				String containing list of creation flags. You can use "-" prefix to hide that GUI field.

                d - down radio button selected in Find dialog.
                w - whole word selected.
                c - match case selected.

 Handler:
				Dialog box is not modal, so it communicates with the script while it is active. Both Find & Replace use
				the same prototype of notification function.

 >				Handler(Event, Flags, FindText, ReplaceText)

                   Event    - C (Close), F (Find), R (Replace), A (replace All)
                   Flags    - String containing flags about user selection; each letter means user has selected that particular GUI element.
                   FindText - Current find text.
                ReplaceText - Current replace text.

 Returns:
				Handle of the dialog or 0 if the dialog can't be created. Returns error code on invalid handler.
 */
Dlg_Find( hGui, Handler, Flags="d", FindText="") {
	static FINDMSGSTRING = "commdlg_FindReplace"
	static FR_DOWN=1, FR_MATCHCASE=4, FR_WHOLEWORD=2, FR_HIDEMATCHCASE=0x8000, FR_HIDEWHOLEWORD=0x10000, FR_HIDEUPDOWN=0x4000
	static buf, FR, len

	if len =
		VarSetCapacity(FR, 40, 0), VarSetCapacity(buf, len := 256)

	ifNotEqual, FindText, , SetEnv, buf, %FindText%

	f := 0
	 ,InStr(flags, "d")  ? f |= FR_DOWN			 : ""
	 ,InStr(flags, "c")  ? f |= FR_MATCHCASE	 : ""
	 ,InStr(flags, "w")  ? f |= FR_WHOLEWORD	 : ""
	 ,InStr(flags, "-d") ? f |= FR_HIDEUPDOWN	 : ""
	 ,InStr(flags, "-w") ? f |= FR_HIDEWHOLEWORD : ""
	 ,InStr(flags, "-c") ? f |= FR_HIDEMATCHCASE : ""

	NumPut(40,		FR, 0)	;size
	 ,NumPut( hGui,	FR, 4)	;hwndOwner
	 ,NumPut( f,	FR, 12)	;Flags
	 ,NumPut( &buf,	FR, 16)	;lpstrFindWhat
	 ,NumPut( len,	FR, 24) ;wFindWhatLen

	if !IsFunc(Handler)
		return A_ThisFunc ">Invalid handler: " Handler

	Dlg_callback(Handler,"","","")
	OnMessage( DllCall("RegisterWindowMessage", "str", FINDMSGSTRING), "Dlg_callback" )

	return DllCall("comdlg32\FindTextA", "str", FR)
}

Dlg_Replace( hGui, Handler, Flags="", FindText="", ReplaceText="") {
	static FINDMSGSTRING = "commdlg_FindReplace"
	static FR_MATCHCASE=4, FR_WHOLEWORD=2, FR_HIDEMATCHCASE=0x8000, FR_HIDEWHOLEWORD=0x10000, FR_HIDEUPDOWN=0x4000
	static buf_f, buf_r, FR, len

	if len =
		len := 256, VarSetCapacity(FR, 40, 0), VarSetCapacity(buf_f, len), VarSetCapacity(buf_r, len)

	f := 0
	f |= InStr(flags, "c")  ? FR_MATCHCASE : 0
	f |= InStr(flags, "w")  ? FR_WHOLEWORD : 0
	f |= InStr(flags, "-w") ? FR_HIDEWHOLEWORD :0
	f |= InStr(flags, "-c") ? FR_HIDEMATCHCASE :0


	ifNotEqual, FindText, ,SetEnv, buf_f, %FindText%
	ifNotEqual, ReplaceText, ,SetEnv, buf_r, %ReplaceText%


	NumPut( 40,		  FR, 0)	;size
	 ,NumPut( hGui,	  FR, 4)	;hwndOwner
	 ,NumPut( f,	  FR, 12)	;Flags
	 ,NumPut( &buf_f, FR, 16)	;lpstrFindWhat
	 ,NumPut( &buf_r, FR, 20)	;lpstrReplaceWith
	 ,NumPut( len,	  FR, 24)	;wFindWhatLen
	 ,NumPut( len,	  FR, 26)	;wReplaceWithLen


	Dlg_callback(Handler,"","","")
	OnMessage( DllCall("RegisterWindowMessage", "str", FINDMSGSTRING), "Dlg_callback" )
	return DllCall("comdlg32\ReplaceTextA", "str", FR)
}

/*
 Function:  Font
			 (See Dlg_font.png)

 Parameters:
            Name	- Initial font,  output.
            Style	- Initial style, output.
            Color	- Initial text color, output.
			Effects	- Set to false to disable effects (strikeout, underline, color).
            hGui	- Parent's handle, affects position.

  Returns:
            False if user canceled the dialog or if error occurred.
 */
Dlg_Font(ByRef Name, ByRef Style, ByRef Color, Effects=true, hGui=0) {

   LogPixels := DllCall("GetDeviceCaps", "uint", DllCall("GetDC", "uint", hGui), "uint", 90)	;LOGPIXELSY
   VarSetCapacity(LOGFONT, 128, 0)

   Effects := 0x041 + (Effects ? 0x100 : 0)  ;CF_EFFECTS = 0x100, CF_SCREENFONTS=1, CF_INITTOLOGFONTSTRUCT = 0x40

   ;set initial name
   DllCall("RtlMoveMemory", "uint", &LOGFONT+28, "Uint", &Name, "Uint", 32)

   ;convert from rgb
   clr := ((Color & 0xFF) << 16) + (Color & 0xFF00) + ((Color >> 16) & 0xFF)

   ;set intial data
   if InStr(Style, "bold")
      NumPut(700, LOGFONT, 16)

   if InStr(Style, "italic")
      NumPut(255, LOGFONT, 20, 1)

   if InStr(Style, "underline")
      NumPut(1, LOGFONT, 21, 1)

   if InStr(Style, "strikeout")
      NumPut(1, LOGFONT, 22, 1)

   if RegExMatch(Style, "s[1-9][0-9]*", s){
      StringTrimLeft, s, s, 1
      s := -DllCall("MulDiv", "int", s, "int", LogPixels, "int", 72)
      NumPut(s, LOGFONT, 0, "Int")			; set size
   }
   else  NumPut(16, LOGFONT, 0)         ; set default size

   VarSetCapacity(CHOOSEFONT, 60, 0)
    ,NumPut(60,		 CHOOSEFONT, 0)		; DWORD lStructSize
    ,NumPut(hGui,    CHOOSEFONT, 4)		; HWND hwndOwner (makes dialog "modal").
    ,NumPut(&LOGFONT,CHOOSEFONT, 12)	; LPLOGFONT lpLogFont
    ,NumPut(Effects, CHOOSEFONT, 20)
    ,NumPut(clr,	 CHOOSEFONT, 24)	; rgbColors

   r := DllCall("comdlg32\ChooseFontA", "uint", &CHOOSEFONT)  ; Display the dialog.
   if !r
      return false

  ;font name
	VarSetCapacity(Name, 32)
	DllCall("RtlMoveMemory", "str", Name, "Uint", &LOGFONT + 28, "Uint", 32)
	Style := "s" NumGet(CHOOSEFONT, 16) // 10

  ;color
	old := A_FormatInteger
	SetFormat, integer, hex                      ; Show RGB color extracted below in hex format.
	Color := NumGet(CHOOSEFONT, 24)
	SetFormat, integer, %old%

  ;styles
	Style =
	VarSetCapacity(s, 3)
	DllCall("RtlMoveMemory", "str", s, "Uint", &LOGFONT + 20, "Uint", 3)

	if NumGet(LOGFONT, 16) >= 700
	  Style .= "bold "

	if NumGet(LOGFONT, 20, "UChar")
      Style .= "italic "

	if NumGet(LOGFONT, 21, "UChar")
      Style .= "underline "

	if NumGet(LOGFONT, 22, "UChar")
      Style .= "strikeout "

	s := NumGet(LOGFONT, 0, "Int")
	Style .= "s" Abs(DllCall("MulDiv", "int", abs(s), "int", 72, "int", LogPixels))

 ;convert to rgb
	oldFormat := A_FormatInteger
    SetFormat, integer, hex  ; Show RGB color extracted below in hex format.

    Color := (Color & 0xff00) + ((Color & 0xff0000) >> 16) + ((Color & 0xff) << 16)
    StringTrimLeft, Color, Color, 2
    loop, % 6-strlen(Color)
		Color=0%Color%
    Color=0x%Color%
    SetFormat, integer, %oldFormat%

   return 1
}

/*
 Function:	Icon
			(See Dlg_icon.png)

 Parameters:
			Icon	- Default icon resource, output.
			Index	- Default index within resource, output.
			hGui	- Optional handle of the parent GUI.

 Returns:
			False if user canceled the dialog or if error occurred

 Remarks:
			This is simple and non-flexible dialog. If you need more features, use <IconEx> instead.
 */
Dlg_Icon(ByRef Icon, ByRef Index, hGui=0) {
    VarSetCapacity(wIcon, 1025, 0)
    If (Icon) && !DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, "Str", Icon, "Int", StrLen(Icon), "UInt", &wIcon, "Int", 1025)
		return false

	r := DllCall(DllCall("GetProcAddress", "Uint", DllCall("LoadLibrary", "str", "shell32.dll"), "Uint", 62), "uint", hGui, "uint", &wIcon, "uint", 1025, "intp", --Index)
	Index++
	IfEqual, r, 0, return false

	VarSetCapacity(Icon, len := DllCall("lstrlenW", "UInt", &wIcon) )
	r := DllCall("WideCharToMultiByte" , "UInt", 0, "UInt", 0, "UInt", &wIcon, "Int", len, "Str", Icon, "Int", len, "UInt", 0, "UInt", 0)
	IfEqual, r, 0, return false
    Return True
}

/*
 Function:  Open / Save
			 (See Dlg_open.png)

 Parameters:
            hGui            - Parent's handle, positive number by default 0 (influences dialog position).
            Title			- Dialog title.
            Filter          - Specify filter as with FileSelectFile. Separate multiple filters with "|". For instance "All Files (*.*)|Audio (*.wav; *.mp2; *.mp3)|Documents (*.txt)"
            DefaultFilter   - Index of default filter (1 based), by default 1.
            Root			- Specifies startup directory and initial content of "File Name" edit.
							  Directory must have trailing "\".
            DefaultExt      - Extension to append when none given .
            Flags           - White space separated list of flags, by default "FILEMUSTEXIST HIDEREADONLY".

  Flags:
			allowmultiselect	- Specifies that the File Name list box allows multiple selections
			createprompt		- If the user specifies a file that does not exist, this flag causes the dialog box to prompt the user for permission to create the file
			dontaddtorecent		- Prevents the system from adding a link to the selected file in the file system directory that contains the user's most recently used documents.
			extensiondifferent	- Specifies that the user typed a file name extension that differs from the extension specified by defaultExt
			filemustexist		- Specifies that the user can type only names of existing files in the File Name entry field
			forceshowhidden		- Forces the showing of system and hidden files, thus overriding the user setting to show or not show hidden files. However, a file that is marked both system and hidden is not shown.
			hidereadonly		- Hides the Read Only check box.
			nochangedir			- Restores the current directory to its original value if the user changed the directory while searching for files.
			nodereferencelinks	- Directs the dialog box to return the path and file name of the selected shortcut (.LNK) file. If this value is not specified, the dialog box returns the path and file name of the file referenced by the shortcut.
			novalidate			- Specifies that the common dialog boxes allow invalid characters in the returned file name
			overwriteprompt		- Causes the Save As dialog box to generate a message box if the selected file already exists. The user must confirm whether to overwrite the file.
			pathmustexist		- Specifies that the user can type only valid paths and file names.
			readonly			- Causes the Read Only check box to be selected initially when the dialog box is created
			showhelp			- Causes the dialog box to display the Help button. The hGui receives the HELPMSGSTRING registered messages that the dialog box sends when the user clicks the Help button.
			noreadonlyreturn	- Specifies that the returned file does not have the Read Only check box selected and is not in a write-protected directory.
			notestfilecreate	- Specifies that the file is not created before the dialog box is closed. This flag should be specified if the application saves the file on a create-nonmodify network share.

  Returns:
            Selected FileName or nothing if cancelled. If more then one file is selected they are separated by new line character.


  Remarks:
		    Those functions will change the working directory of the script. Use SetWorkingDir afterwards to restore working directory if needed.
 */
Dlg_Open( hGui=0, Title="", Filter="", DefaultFilter="", Root="", DefaultExt="", Flags="FILEMUSTEXIST HIDEREADONLY" ) {
	static OFN_S:=0, OFN_ALLOWMULTISELECT:=0x200, OFN_CREATEPROMPT:=0x2000, OFN_DONTADDTORECENT:=0x2000000, OFN_EXTENSIONDIFFERENT:=0x400, OFN_FILEMUSTEXIST:=0x1000, OFN_FORCESHOWHIDDEN:=0x10000000, OFN_HIDEREADONLY:=0x4, OFN_NOCHANGEDIR:=0x8, OFN_NODEREFERENCELINKS:=0x100000, OFN_NOVALIDATE:=0x100, OFN_OVERWRITEPROMPT:=0x2, OFN_PATHMUSTEXIST:=0x800, OFN_READONLY:=0x1, OFN_SHOWHELP:=0x10, OFN_NOREADONLYRETURN:=0x8000, OFN_NOTESTFILECREATE:=0x10000

	IfEqual, Filter, ,SetEnv, Filter, All Files (*.*)
	SplitPath, Root, rootFN, rootDir

	hFlags := 0x80000								;OFN_ENABLEXPLORER always set
	loop, parse, Flags,%A_TAB%%A_SPACE%,%A_TAB%%A_SPACE%
		if A_LoopField !=
			hFlags |= OFN_%A_LoopField%

	ifEqual, hFlags, , return A_ThisFunc "> Some of the flags are invalid: " Flags
	VarSetCapacity( FN, 0xffff ), VarSetCapacity( lpstrFilter, 2*StrLen(filter))

	if rootFN !=
		  DllCall("lstrcpyn", "str", FN, "str", rootFN, "int", StrLen(rootFN)+1)

	; Contruct FilterText seperate by \0
	delta := 0										;Used by Loop as Offset
	loop, Parse, Filter, |
	{
		desc := A_LoopField,  ext := SubStr(A_LoopField, InStr( A_LoopField,"(" )+1, -1)
		lenD := StrLen(A_LoopField)+1,	lenE := StrLen(ext)+1				;including /0

		DllCall("lstrcpyn", "uint", &lpstrFilter + delta, "uint", &desc, "int", lenD)
		DllCall("lstrcpyn", "uint", &lpstrFilter + delta + lenD, "uint", &ext, "int", lenE)
		delta += lenD + lenE
	}
	NumPut(0, lpstrFilter, delta, "UChar" )		  ; Double Zero Termination

	; Contruct OPENFILENAME Structure
	VarSetCapacity( OFN ,90, 0)
	 ,NumPut( 76,			 OFN, 0,  "UInt" )    ; Length of Structure
	 ,NumPut( hGui,			 OFN, 4,  "UInt" )    ; HWND
	 ,NumPut( &lpstrFilter,	 OFN, 12, "UInt" )    ; Pointer to FilterStruc
	 ,NumPut( DefaultFilter, OFN, 24, "UInt" )    ; DefaultFilter Pair
	 ,NumPut( &FN,			 OFN, 28, "UInt" )    ; lpstrFile / InitialisationFileName
	 ,NumPut( 0xffff,		 OFN, 32, "UInt" )    ; MaxFile / lpstrFile length
	 ,NumPut( &rootDir,		 OFN, 44, "UInt" )    ; StartDir
	 ,NumPut( &Title,		 OFN, 48, "UInt" )	  ; DlgTitle
	 ,NumPut( hFlags,		 OFN, 52, "UInt" )    ; Flags
	 ,NumPut( &DefaultExt,	 OFN, 60, "UInt" )    ; DefaultExt

	res := SubStr(Flags, 1, 1)="S" ? DllCall("comdlg32\GetSaveFileNameA", "Uint", &OFN ) : DllCall("comdlg32\GetOpenFileNameA", "Uint", &OFN )
	IfEqual, res, 0, return

	adr := &FN,  f := d := DllCall("MulDiv", "Int", adr, "Int",1, "Int",1, "str"), res := ""
	if StrLen(d) != 3			;windows adds \ when in root of the drive and doesn't do that otherwise
		d.="\"
	if ms := InStr(Flags, "ALLOWMULTISELECT")
		loop
			if f := DllCall("MulDiv", "Int", adr += StrLen(f)+1, "Int",1, "Int",1, "str")
				res .= d f "`n"
			else {
				 IfEqual, A_Index, 1, SetEnv, res, %d%		;if user selects only 1 file with multiselect flag, windows ignores this flag....
				 break
			}

	return ms ? SubStr(res, 1, -1) : SubStr(d, 1, -1)
}


Dlg_Save( hGui=0, Title="", Filter="", DefaultFilter="", Root="", DefaultExt="", Flags="" ) {
	return Dlg_Open( hGui, Title, Filter, DefaultFilter, Root, DefaultExt, "S " Flags )
}


Dlg_callback(wparam, lparam, msg, hwnd) {
	static FR_DIALOGTERM = 0x40, FR_DOWN=1, FR_MATCHCASE=4, FR_WHOLEWORD=2, FR_HIDEMATCHCASE=0x8000, FR_HIDEWHOLEWORD=0x10000, FR_HIDEUPDOWN=0x4000, FR_REPLACE=0x10, FR_REPLACEALL=0x20, FR_FINDNEXT=8
	static handler
	ifEqual, hwnd, ,return handler := wparam

	hFlags := NumGet(lparam+12)
	if (hFlags & FR_DIALOGTERM)
		return %handler%("C", "", "", "")

 	flags .= (hFlags & FR_MATCHCASE) && !(hFlags & FR_HIDEMATCHCASE)? "c" :
	flags .= (hFlags & FR_WHOLEWORD) && !(hFlags & FR_HIDEWHOLEWORD)? "w" :
	findText := DllCall("MulDiv", "Int", NumGet(lparam+16), "Int",1, "Int",1, "str")

	if (hFlags & FR_FINDNEXT) {
		flags .= (hFlags & FR_DOWN) && !(hFlags & FR_HIDEUPDOWN) ? "d" :
		return %handler%("F", flags, findText, "")
	}

	if (hFlags & FR_REPLACE) || (hFlags & FR_REPLACEALL) {
		event := (hFlags & FR_REPLACEALL) ? "A" : "R"
		replaceText := DllCall("MulDiv", "Int", NumGet(lparam+20), "Int",1, "Int",1, "str")
		return %handler%(event, flags, findText, replaceText)
	}
}

Host2IP(name){

ErrorLevel = 0
type := SubStr(name, 1, 1)
if type is alpha
   {
		VarSetCapacity(WSADATA, 12+257+129, 0)   ; WSADATA structure initialization
err := DllCall("wsock32\WSAStartup", Short, 0x101, UInt, &WSADATA, UInt)

   hostent := DllCall("ws2_32\gethostbyname", UInt, &name, UInt) ; http://msdn.microsoft.com/en-us/library/ms738524(VS.85).aspx
   if !hostent
      {
      err := DllCall("ws2_32\WSAGetLastError")
      ErrorLevel = 1
      return err
      }
   ; string containing protocol types (mainly for debug purposes)
   str := "local to host (pipes, portals)|internetwork: UDP, TCP, etc.|arpanet imp addresses|pup protocols: e.g. BSP|mit CHAOS protocols|XEROX NS protocols or IPX protocols: IPX, SPX, etc.|ISO protocols or OSI is ISO|european computer manufacturers|datakit protocols|CCITT protocols, X.25 etc|IBM SNA|DECnet|Direct data link interface|LAT|NSC Hyperchannel|AppleTalk|NetBios-style addresses|VoiceView|Protocols from Firefox|Unknown - Somebody is using this!|Banyan|Native ATM Services|Internetwork Version 6|Microsoft Wolfpack|IEEE 1284.4 WG AF"
   ptrName := NumGet(hostent+0, 0, "UInt")
   pt := NumGet(hostent+0, 8, "UShort")
   Loop, Parse, str, |
      if (A_Index = pt)
         type := A_LoopField
   len := NumGet(hostent+0, 10, "UShort")
   ptrAddress := NumGet(hostent+0, 12, "UInt")
   ptrIPAddress := NumGet(ptrAddress+0, 0, "UInt")
   strAddress := NumGet(ptrIPAddress+0, 0, "UInt")
   VarSetCapacity(adr, 16, 32)
   DllCall("lstrcpy", UInt, &adr, UInt, DllCall("ws2_32\inet_ntoa", UInt, strAddress))
   VarSetCapacity(adr, -1)
   VarSetCapacity(pname, 260, 32)
   DllCall("lstrcpy", UInt, &pname, UInt, ptrName)
   VarSetCapacity(pname, -1)
   DllCall("wsock32\WSACleanup")
   return adr
   }
else
{
	ErrorLevel = 1
   return name
   }
}


GetErrorHost2IP(code) {
str := "Success|Reply buffer too small|Destination network unreachable|Destination host unreachable|Destination protocol unreachable|Destination port unreachable|Insufficient IP resources|Bad IP option specified|Hardware error|Packet too big|Request timed out|Bad request|Bad route|TTL expired in transit|TTL expired during fragment reassembly|Parameter problem|Datagrams are arriving too fast to be processed and datagrams may have been discarded|IP option too big|Bad destination|General failure (possible malformed ICMP packets)"
Loop, Parse, str, |
   {
   if (code = 11000 + A_Index - 1) || (A_Index = 20 && code = 11050)
      return err := code " [" A_LoopField "]"
   }
return err := code
}

AutoParam:
Gui, Hide
Gosub, OneKeyUpdate
Gui, Show
Gosub, FileSave
ExitApp

^#!+Z::
Egg1=�ʵ���
Egg2=�ʵ����ѡ�
if Egg=2
{
	Menu, IAMEgg, Show
	Return
}
if Egg=
	Egg=0
Egg += 1
Egggg:=Egg%Egg%
Menu, IAMEgg, Add, %Egggg%, None
Menu, IAMEgg, Show
Return

None:
Return

InsertLocalhost:
InsertContent=`r`n127.0.0.1 localhost`r`n127.0.0.1 localhost.localdomain`r`n::1 localhost`r`n::1 localhost.localdomain`r`n
Gosub InsertContent
Return

FirstRun:
MsgBox, 36,, ���ã���л��ѡ�� orzTech | ��Ƽ� ��Ʒ�� HostsX��`r`n`r`n��������һ��ʹ�ñ�����������Ķ������ļ���
IfMsgBox Yes
    Run, http://orztech.com/softwares/hostsx/help

IfExist,%A_WinDir%\System32\drivers\etc\hosts
{
	FileRead, BackupContents, %A_WinDir%\System32\drivers\etc\hosts
	FormatTime, TimeStamp, , yyMMdd_HHmm
	BackupName = %TimeStamp%auto_%A_WinDir%\System32\drivers\etc\hosts
	StringReplace, BackupName, BackupName, \, _, All
	StringReplace, BackupName, BackupName, /, _, All
	StringReplace, BackupName, BackupName, :, _, All
	StringReplace, BackupName, BackupName, *, _, All
	StringReplace, BackupName, BackupName, ?, _, All
	StringReplace, BackupName, BackupName, `", _, All
	StringReplace, BackupName, BackupName, ``, _, All
	StringReplace, BackupName, BackupName, <, _, All
	StringReplace, BackupName, BackupName, >, _, All
	StringReplace, BackupName, BackupName, |, _, All
	StringReplace, BackupName, BackupName, ., _, All
	Gosub CreateBackup
}
Return

OptionsUpdateAtStartup:
If (UpdateAtStartup = "orzYes")
{
	UpdateAtStartup = orzNo
	Menu, UpdateMenu, Uncheck, ��������ʱ�Զ����������ļ�(&S)
}
Else
{
	UpdateAtStartup = orzYes
	Menu, UpdateMenu, Check, ��������ʱ�Զ����������ļ�(&S)
}
Return

OptionsUpdateWhenMissing:
If (UpdateWhenMissing = "orzYes")
{
	UpdateWhenMissing = orzNo
	Menu, UpdateMenu, Uncheck, �����ļ�������ʱ�Զ����������ļ�(&M)
}
Else
{
	UpdateWhenMissing = orzYes
	Menu, UpdateMenu, Check, �����ļ�������ʱ�Զ����������ļ�(&M)
}
Return


OptionsCheckWhitelistSilentMode:
If (CheckWhitelistSilentMode = "orzYes")
{
	CheckWhitelistSilentMode = orzNo
	Menu, OptionsMenu, Uncheck, ���� HostsX ����������ʱʹ�þ�Ĭģʽ(&S)
}
Else
{
	CheckWhitelistSilentMode = orzYes
	Menu, OptionsMenu, Check, ���� HostsX ����������ʱʹ�þ�Ĭģʽ(&S)
}
Return

OptionsCheckWhitelistAfterOpen:
If (CheckWhitelistAfterOpen = "orzYes")
{
	CheckWhitelistAfterOpen = orzNo
	Menu, OptionsMenu, Uncheck, ���ļ����Զ����� HostsX ����������(&O)
}
Else
{
	CheckWhitelistAfterOpen = orzYes
	Menu, OptionsMenu, Check, ���ļ����Զ����� HostsX ����������(&O)
}
Return

SpecialHostsTHUNDERAD()
{
	dateStart = %A_Now%
	dateEnd = %dateStart%
	dateEnd += 30, days
	FormatTime, dateStartFormat, %dateStart%, LongDate
	FormatTime, dateEndFormat, %dateEnd%, LongDate
	dateNow = %dateStart%
	data=
	Loop, 31
	{
		FormatTime, dateNowFormat, %dateNow%, yyyyMMdd
		data = %data%0.0.0.0`t%dateNowFormat%.biz5.sandai.net`r`n
		dateNow += 1, days
	}
	result = 
(
;
;��ʾ������Ѹ��ʹ��������ķ�������棬����ÿ��Ĺ����������һ����
;������������� HostsX ����ӵĴ����ݽ��ܴӱ���������� %dateStartFormat% ��
;�������� %dateEndFormat% ��Ч 31 �졣
;
%data%
)
	return result
}