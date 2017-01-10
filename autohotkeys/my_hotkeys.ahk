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

:o:wcomm::
    worldoxSave("IDS Comm", "ids")
return

:o:wccca::
    worldoxSave("IDS CCCA", "comm")
return

:o:wxmit::
    worldoxSave("IDS Xmit", "xmit")
return

:o:w1449::
    worldoxSave("IDS 1449", "ids")
return

; Document types
:o:aarf::Response to Final Office Action
:o:aarn::Response to Non Final Office Action
:o:adaf::Response to Advisory Action
:o:adar::Advisory Action
:o:apbr::Appeal Brief
:o:aprb::Appellant's Reply Brief
:o:eesr::Extended European Search Report
:o:exan::Examiner's Answer
:o:exin::Examiner Interview Summary
:o:foar::Final Office Action
:o:iper::International Preliminary Examination Report
:o:iprp::International Preliminary Report on Patentability
:o:oarn::Non Final Office Action

; misc text replace
:o:asap::If possible, please sign ASAP.
:o:asap3mo::If possible, please sign ASAP.  This must be filed soon for us to avoid paying a filing fee.
:o:asapaarn::If possible, please sign ASAP.  We recently filed a response to non-final office action and we could recieve an office action shortly.
:o:asaprce::If possible, please sign ASAP.  We recently filed an RCE and could recieve an office action shortly.
:o:asn::Application Serial No. `
:o:atty::attorney
:o:e1::1.97(e)(1)
:o:e2::1.97(e)(2)
:o:ifq::If there are any questions or there is anything more I can do to help please let me know.
:o:ifs::If this is satisfactory please sign the attached documents and return them to me.  If not please let me know what changes you would like made.

; Prosecution documents hotstrings
:o:m312::Application Serial No. ^v, Amendment after allowance under 37 CFR 1.312 mailed
:o:maarf::Application Serial No. %c, Response filed  to Final Office Action mailed{left 30}
:o:maarn::Application Serial No. %c, Response filed  to Non Final Office Action mailed{left 34}
:o:madar::Application Serial No. %c, Advisory Action mailed
:o:mapbr::Application Serial No. %c, Appeal Brief filed
:o:maprb::Application Serial No. %c, Reply Brief filed  to Examiner's Answer mailed{left 28}
:o:meesr::European Application Serial No. %c, Extended European Search Report mailed `



; Full email shortcuts
; -----------------------------------------------
; basic IDS email
:o:eids::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared an IDS for ^v.  I examined the specification, disclosure, and file.  I found no additional references.  I prepared the IDS to cite all currently unmarked references in FIP.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; Continuation IDS where not all references were cited in parent.
:o:eidsconn::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared an IDS for ^v.  Since it is a continuation/divisional I compared all of the unmarked references to those in its parent.  Some of the references unmarked in ^v have not been cited in the parent (see attached spreadsheet).  Despite this, I have prepared this IDS to cite all unmarked references (this includes those references not cited in the parent).  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; Continuation IDS where only citing references cited in parent
:o:eidsconp::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared an IDS for ^v.  I have prepared this IDS to cite all references previously cited in the parent.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; Continuation IDS where all references were cited in parent
:o:eidscony::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared an IDS for ^v.  Since it is a continuation/divisional I compared all of the unmarked references to those in its parent.  All references currently unmarked in ^v have been cited in its parent matter.  Therefore, I have prepared this IDS to cite all unmarked references.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; memo email for new IDS
:o:eidsmemo::^v - IDS memo for your review{Tab}{Enter}{Tab}I have prepared an IDS memo for ^v.  Please review the memo and other attached documents.  Let me know which references you would like cited in this matter.^{Home}

; reminder email
:o:eout:: Outstanding SIDS - Signature Reminder{Tab}{Enter}{Tab}I have attached all outstanding IDS/SIDS out for your signature.  Please disregard all previous requests for signature.  Please sign all the attached documents and return them to me.  ^{Home}

; email for SIDS and RCE
:o:erce::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared an SIDS and RCE for ^v.  I prepared the SIDS to cite all currently unmarked references in FIP.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; basic SIDS email
:o:esids::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared a SIDS for ^v.  I prepared the SIDS to cite all currently unmarked references in FIP.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

; basic foreign reference SIDS email
:o:esidsfor::^v - Documents for your signature{Tab}{Enter}{Tab}I have prepared a SIDS for ^v in response to a foreign office action received in a related matter. I prepared the SIDS to cite the received document and all currently unmarked references in FIP.  If this is satisfactory, please sign and return the attached document.  If not, please let me know what changes you would like made.^{Home}

