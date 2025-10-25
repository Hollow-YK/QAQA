Unicode true
#启用Unicode支持，文件须使用UTF-8 BOM编码
!include "MUI2.nsh";调用MUI2现代界面
!include "nsDialogs.nsh";调用nsDialogs以创建自定义页面

#名称
Name "QAQA V1.0 Installer"

OutFile "QAQA_V1.0_installer.exe";安装包输出
InstallDir "$PROGRAMFILES\Hollow\QAQA";默认安装路径

#常量定义
!define INSTALLATIONNAME "QAQA"
!define PROGRAMFROM "D:\OneDrive - MSFT\WZJ\河石大\BOF动漫社\2025迎新\QAQA\QAQA";未打包文件路径

#安装页面
#许可证页面
#!insertmacro MUI_PAGE_LICENSE "license.rtf"
#公告页面
Page custom ShowNotice
#安装路径选择页面
!insertmacro MUI_PAGE_DIRECTORY
#组件选择
!insertmacro MUI_PAGE_COMPONENTS
#安装进度页面
!insertmacro MUI_PAGE_INSTFILES

#卸载页面
#卸载路径确认页面
!insertmacro MUI_UNPAGE_CONFIRM
#卸载进度页面
!insertmacro MUI_UNPAGE_INSTFILES

#使用中文界面
!insertmacro MUI_LANGUAGE "SimpChinese"

Function ShowNotice
#自定义标题与描述
!insertmacro MUI_HEADER_TEXT "公告" "QAQA by 域空Hollow"

nsDialogs::Create 1018
Pop $0

# 创建标题文字
${NSD_CreateLabel} 0 10 100% 24u "公告"
Pop $1
SetCtlColors $1 0x000000 0xF0F0F0  ; 黑字灰底
CreateFont $2 "黑体" 14 700     ; 创建加粗字体
SendMessage $1 ${WM_SETFONT} $2 1   ; 应用字体

# 创建正文文字
${NSD_CreateLabel} 0 46 100% 80u "本工具用于BOF动漫社2025迎新晚会，因懒得写PPT而设计。$\r$\n作者：域空Hollow$\r$\n注意！$\r$\n本工具仅做辅助使用，不保证没有Bug。$\r$\n本工具完全免费。"
Pop $1
SetCtlColors $1 0x000000 0xF0F0F0  ; 黑字灰底
CreateFont $3 "楷体" 12 400     ; 创建常规字体
SendMessage $1 ${WM_SETFONT} $3 1   ; 应用字体

nsDialogs::Show
FunctionEnd
#主程序
Section "主程序（必选）" SEC_MAIN
	SectionIn RO
	SetOutPath $INSTDIR
	File "${PROGRAMFROM}\QAQA.exe"
	File "${PROGRAMFROM}\bitsdojo_window_windows_plugin.lib"
	File "${PROGRAMFROM}\qaqa.exp"
	File "${PROGRAMFROM}\qaqa.lib"
	File "${PROGRAMFROM}\flutter_windows.dll"
	File /r "${PROGRAMFROM}\data"
	WriteUninstaller "$INSTDIR\uninstall.exe"
	CreateDirectory "$SMPROGRAMS\QAQA"
SectionEnd
SectionGroup "数据文件" GRP_DATA
	Section "问题数据" SEC_QUESTIONSCSV
		SetOutPath "$APPDATA\Hollow\BOF"
		File /r "${PROGRAMFROM}\QAQA"
	SectionEnd
SectionGroupEnd
SectionGroup "创建快捷方式" GRP_SHORTCUT
	SectionGroup "开始菜单快捷方式" GRP_STARTMENUSHORTCUT
		Section "节点导出工具快捷方式" SEC_STARTMENUSHORTCUT
			CreateShortCut "$SMPROGRAMS\QAQA\QAQA.lnk" "$INSTDIR\QAQA.exe"
		SectionEnd
		Section "卸载程序快捷方式" SEC_STARTMENUUNINSTALLSHORTCUT
			CreateShortCut "$SMPROGRAMS\QAQA\卸载QAQA.lnk" "$INSTDIR\uninstall.exe"
		SectionEnd
	SectionGroupEnd
	Section "创建桌面快捷方式" SEC_DESKTOPSHORTCUT
		CreateShortCut "$DESKTOP\QAQA.lnk" "$INSTDIR\QAQA.exe"
	SectionEnd
SectionGroupEnd

#可选组件
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_MAIN} "安装程序的主文件，此选项必须安装。"
!insertmacro MUI_DESCRIPTION_TEXT ${GRP_DATA} "选择需要安装的数据文件，此选项必须安装至少一项。"
	!insertmacro MUI_DESCRIPTION_TEXT ${SEC_QUESTIONSCSV} "安装问题与答案数据（推荐）"
!insertmacro MUI_DESCRIPTION_TEXT ${GRP_SHORTCUT} "创建快捷方式，方便快速启动程序。"
	!insertmacro MUI_DESCRIPTION_TEXT ${GRP_STARTMENUSHORTCUT} "创建开始菜单快捷方式，方便快速启动和卸载程序。除非你知道你在做什么，否则务必勾选此选项。"
		!insertmacro MUI_DESCRIPTION_TEXT ${SEC_STARTMENUSHORTCUT} "在桌面创建快捷方式，方便快速启动程序。除非你知道你在做什么，否则务必勾选此选项。"
		!insertmacro MUI_DESCRIPTION_TEXT ${SEC_STARTMENUUNINSTALLSHORTCUT} "在桌面创建快捷方式，方便快速卸载程序。除非你知道你在做什么，否则务必勾选此选项。"
	!insertmacro MUI_DESCRIPTION_TEXT ${SEC_DESKTOPSHORTCUT} "在桌面创建快捷方式，方便快速启动程序。"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

#卸载页面
Section "Uninstall"
	Delete "$DESKTOP\QAQA.lnk"
	Delete "$SMPROGRAMS\QAQA\QAQA.lnk"
	Delete "$SMPROGRAMS\QAQA\QAQA.lnk"
	RMDir "$SMPROGRAMS\QAQA"
	Delete "$INSTDIR\uninstall.exe"
	RMDir /r "$INSTDIR"
SectionEnd