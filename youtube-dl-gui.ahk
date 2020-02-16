#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance force
MediaFormat :="Audio||Video"
Video := "flv|mkv|mp4||ogg|webm"
Audio :="aac|flac|mp3||opus|vorbis|m4a|wav"
;YtdlVersion := ComObjCreate("WScript.Shell").Exec("cmd.exe /q /c youtube-dl.exe --version").StdOut.ReadAll()

Gui, Add, Tab3,, Download|Convert|Update
Gui, Tab, 1
;Gui, Add, Text, w420 h30, Paste the YouTube URL below then click on the 'Download' button.
Gui, Add, Edit, section w300 vYouTubeURL,
Gui, Add, DropDownList, ys vMedia gDownloadSelection, %MediaFormat%
Gui, Add, DropDownList, ys vDownloadMediaFormat, %Audio%
Gui, Add, Button, ys, Download
Gui, Tab, 2
Gui, Add, Button, section, Convert
;Gui, Add, Button, ys, Convert
Gui, Tab, 3
;Gui, Add, Text, section, youtube-dl version: %YtdlVersion%
Gui, Add, Button, ys, Update
Gui, Show, AutoSize Center, youtube-dl GUI
GuiControl, Focus, YouTubeURL
Return

DownloadSelection:
	GuiControlGet, Selection , , Media
	GuiControl, , DownloadMediaFormat, |
	GuiControl, , DownloadMediaFormat, % %Selection%
Return

Guiclose:
exitapp

ButtonConvert:
;(*.aac; *.flac; *.mp3; *.opus; *.vorbis; *.m4a; *.wav
FileSelectFile, SelectedFiles, M123, , Open a file, Audio (*.m4a)
if SelectedFiles =
{
    Return
}
Loop, parse, SelectedFiles, `n
{
	If A_Index = 1
		Path := A_LoopField
    Else
    {
		RunWait, %comspec% /c ffmpeg.exe -i "%Path%\%A_LoopField%" -acodec libmp3lame -ab 256k "%A_LoopField%.mp3"
        ; MsgBox, 4, , ffmpeg.exe -i ""%A_LoopField%"" -acodec libmp3lame -ab 256k ""%A_LoopField%"".mp3 & PAUSE
        ; IfMsgBox, No, break
    }
}
Return

ButtonUpdate:
RunWait, %comspec% /c "youtube-dl.exe -U"
YtdlVersion := ComObjCreate("WScript.Shell").Exec("cmd.exe /q /c youtube-dl.exe --version").StdOut.ReadAll()
Return

ButtonDownload:
Gui, Submit, nohide
GuiControlGet, Ch , , DownloadMediaFormat
If YouTubeURL=
{
  MsgBox, No URL detected.
}
Else
{
  If(Media = "Video")
  {
    RunWait, %comspec% /c "youtube-dl.exe  %YouTubeURL% --recode-video %DownloadMediaFormat% -o `%(title)s.`%(ext)s"
  }
  Else If(Media = "Audio")
  {
    RunWait, %comspec% /c "youtube-dl.exe  %YouTubeURL% -x --audio-format %DownloadMediaFormat% -o `%(title)s.`%(ext)s"
  }
}
return
