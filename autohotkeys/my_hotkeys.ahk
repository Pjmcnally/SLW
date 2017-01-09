#Include auto_upload.ahk

; Hotkey to reload script as I frequently save and edit it.
^!r::Reload  ; Assign Ctrl-Alt-R as a hotkey to restart the script.

; script to log me into to various work sites.
; Passwords stored in external file (Not in Git).
; Passwords changed to invalidate passwords uploaded to Git.
^!l::
    #Include passwords.ahk ; Passwords stored in file not tracked by Git
    ; Wait for the key to be released.  Use one KeyWait for each of the hotkey's modifiers.
    KeyWait Control
    KeyWait Alt

    ; Get title of window.  To select the right password.
    WinGetTitle, Title, A

    ; Log into FIP (All browsers)
    if InStr(Title, "FoundationIP") {
        send %FIP%
    } else if InStr(Title, "USPTO User Authentication") {
        send %EFS%
    } else if InStr(Title, "Sign in | USPTO") {
        send %USPTO%
    } else if InStr(Title, "PTFM") {
        send %PTFM%
    }

Return

; Script to enter "United States of America
^!u::
    ; Wait for the key to be released.  Use one KeyWait for each of the hotkey's modifiers.
    KeyWait Control
    KeyWait Alt
    send United States of America{tab}{enter}

Return
