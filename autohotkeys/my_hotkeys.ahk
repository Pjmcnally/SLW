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

worldoxSave(desc, doc_type) {
    num := splitMatterNum(clipboard)
    Send % num["raw"] " " desc
    Send {tab}{tab}
    Send % doc_type
    Send {tab}
    Send % num["client_num"]
    Send {tab}
    Send % num["family_num"]
    Send {tab}
    Send % num["c_code"]
    Send {tab}
    Send % num["cont_num"]
    ; Send {tab}{tab}{tab}{enter}
}


; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; Functions used in hotstrings

splitMatterNum(str) {
    ; Matter numbers exist is a format of CCCC.FFFIIN or CCC.FFFIIN
    ; They infrequently appear as CCCC.FFFINN, CCC.FFFINN
    ; where CCCC or CCC = client number, FFF = family number, I or II = country code
    ; and N or NN = continuation number.

    ; test to ensure string has 11 digits cancel if not.
    len := StrLen(str)
    if (len != 11 and len != 10) {
        MsgBox Invalid Matter Number
        Exit
    }

    ; break string into client number and remainder.
    num_array := StrSplit(str, ".")
    client_num := num_array[1]

    reminder = num_array[2]
    family_num := SubStr(reminder, 1, 3)

    ; extract c_temp and check for char "U"
    ; for this purpose US should always be the right answer
    c_temp := SubStr(reminder, 4, 2)
    if InStr(c_temp, "U") {
        c_code := "US"
    } else {
        MsgBox Invald country
        Exit
    }

    ; check if c_temp contains digits.  If no grab 1 digit.  If yes grab both
    if c_temp is alpha
        cont_num := SubStr(reminder, 6, 1)
    if c_temp is not alpha
        cont_num := SubStr(reminder, 5, 2)

    num := {"raw": str, "client_num": client_num, "family_num": family_num, "c_code": c_code, "cont_num": cont_num}
    return num
}


; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; Hotstrings

::wcomm::
    worldoxSave("IDS Comm", "ids")
return

::wccca::
    worldoxSave("IDS CCCA", "comm")
return

::wxmit::
    worldoxSave("IDS Xmit", "xmit")
return

::w1449::
    worldoxSave("IDS 1449", "ids")
return

; Document types
::aarf::Response to Final Office Action
::aarn::Response to Non Final Office Action
::adaf::Response to Advisory Action
::adar::Advisory Action
::apbr::Appeal Brief
::aprb::Appellant's Reply Brief
::eesr::Extended European Search Report


; misc text replace
::asap::If possible, please sign ASAP.
::asap3mo::If possible, please sign ASAP.  This must be filed soon for us to avoid paying a filing fee.
::asapaarn::If possible, please sign ASAP.  We recently filed a response to non-final office action and we could recieve an office action shortly.
::asaprce::If possible, please sign ASAP.  We recently filed an RCE and could recieve an office action shortly.
::asn::Application Serial No.
::atty::attorney
::e1::1.97(e)(1)
::e2::1.97(e)(2)

; emial shortcuts

; basic IDS email
::eids::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared an IDS for ^v.  I examined the specification, disclosure, and file.  I found no additional references.  I prepared the IDS to cite all currently unmarked references in FIP.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; Continuation IDS where not all references were cited in parent.
::eidsconn::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared an IDS for ^v.  Since it is a continuation/divisional I compared all of the unmarked references to those in its parent.  Some of the references unmarked in ^v have not been cited in the parent (see attached spreadsheet).  Despite this, I have prepared this IDS to cite all unmarked references (this includes those references not cited in the parent).  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; Continuation IDS where only citing references cited in parent
::eidsconp::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared an IDS for ^v.  I have prepared this IDS to cite all references previously cited in the parent.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; Continuation IDS where all references were cited in parent
::eidscony::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared an IDS for ^v.  Since it is a continuation/divisional I compared all of the unmarked references to those in its parent.  All references currently unmarked in ^v have been cited in its parent matter.  Therefore, I have prepared this IDS to cite all unmarked references.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; memo email for new IDS
::eidsmemo::^v - IDS memo for your review{Tab}{Enter}{Tab}I have prepared an IDS memo for ^v.  Please review the memo and other attached documents.  Let me know which references you would like cited in this matter.^{Home}

; reminder email
::eout:: Outstanding SIDS - Signature Reminder{Tab}{Enter}{Tab}I have attached all outstanding IDS/SIDS out for your signature.  Please disregard all previous requests for signature.  Please sign all the attached documents and return them to me.  ^{Home}

; email for SIDS and RCE
::erce::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared an SIDS and RCE for ^v.  I prepared the SIDS to cite all currently unmarked references in FIP.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; basic SIDS email
::esids::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared a SIDS for ^v.  I prepared the SIDS to cite all currently unmarked references in FIP.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; basic foreign reference SIDS email
::esidsfor::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared a SIDS for ^v in response to a foreign office action received in a related matter. I prepared the SIDS to cite the received document and all currently unmarked references in FIP.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}
