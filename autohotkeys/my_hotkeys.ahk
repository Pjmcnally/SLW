SendMode Input
#Include auto_upload.ahk
; The line below this one is literal (the ; does not count as a comment indicator)
#Hotstring EndChars -()[]{}:;'"/\,.?!`n `t

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

splitMatterNum(str) {
    ; Matter numbers exist is a format of CCCC.FFFIIN or rarely CCCC.FFFINN
    ; where CCCC = client number, FFF = family number, I or II = country code
    ; and N or NN = continuation number.

    ; test to ensure string has 11 digits cancel if not.
    if (StrLen(str) != 11) {
        MsgBox Invalid Matter Number
        Exit
    }

    ; extract client and family numbers
    client_num := SubStr(str, 1, 4)
    family_num := SubStr(str, 6, 3)

    ; extract c_temp and check for char "U"
    ; for this purpose US should always be the right answer
    c_temp := SubStr(str, 9, 2)
    if InStr(c_temp, "U") {
        c_code := "US"
    } else {
        MsgBox Invald country
        Exit
    }

    ; check if c_temp contains digits.  If no grab 1 digit.  If yes grab both
    if c_temp is alpha
        cont_num := SubStr(str, 11, 1)
    if c_temp is not alpha
        cont_num := SubStr(str, 10, 2)

    num := {"raw": str, "client_num": client_num, "family_num": family_num, "c_code": c_code, "cont_num": cont_num}
    return num
}


; Hotstrings Below
::wcomm::
    num := splitMatterNum(clipboard)
    Send % num["raw"]
    Send IDS Comm
    Send {tab}{tab}ids
    Send {tab}
    Send % num["client_num"]
    Send {tab}
    Send % num["family_num"]
    Send {tab}
    Send % num["c_code"]
    Send {tab}
    Send % num["cont_num"]
    Send {tab}{tab}{tab}{enter}
return
