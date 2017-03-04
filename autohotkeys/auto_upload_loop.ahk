; Scripts below mass upload documents to USPTO
; Version 3.0 (loop)
; last updated 03-03-17
; Created by Patrick McNally 

; This is my new attempt at a master upload script to work on any browser (It currently supports IE and Chrome).
; I am very close to getting this to work in Firefox but for some reason the upload window behaves inconsistently.

#z::
main() ; Runs entire script 
Return

main() {
    ; These are the hard-coded variables.  If anything changes this is where you will need to change stuff.
    submitDelay := 100 ; 100 is default. Increase this number to slow down the submission process if it is breaking.  Do not set below 100 or errors may occur.
    user := "pmcnally" ; This is the name of the user directory in windows.  It is used for file paths.

    ; Get name of open window
    WinGet, window, ProcessName, A

    ; Check if open window is a supported browser
    verifyBrowser(window)

    ; Setup and get info for specific browser.
    browserInfo := setupBrowser(window)
    uploadWindow := browserInfo["upload"]
    normalWindow := browserInfo["normal"]

    ; Get directory holding files to update.
    directory := getDirectory(user)

    ; Get number of foreign refs.
    num_foreign := getForNum()

    ; Loop through references to upload to FIP.
    Loop, Files, %directory%
        {
            if (A_index >= 2 and Mod(A_index, 21) != 0) { ; Automatically open upload window except for 1st and every 20th (1 indexed)
                openUploadWindow(submitDelay, browser)
            }
            submitRef(A_LoopFileFullPath, A_index, num_foreign, uploadWindow, normalWindow, submitDelay)
        }
    MsgBox % "AutoHotkey has attempted to select all references."
}

getDirectory(user) {
    InputBox, directory, Directory, Please enter the directory containg the references.
    checkCancel(ErrorLevel)

    file_default := "\*.*"

    if (directory) {
        directory := directory file_default
    } else {
        directory := "C:\Users\" user "\Desktop\bulk flatten" file_default
    }
    return directory


    ; directory := "C:\upload\*.*" ; Hard-coded.  All references should be put in this folder before beginning.
}

verifyBrowser(window) {
    ; Function to check if working browser window is open.
    if (window = "chrome.exe" or window = "iexplore.exe") { ; or window = "firefox.exe"
    } else {
        MsgBox % "Please make sure to your Chrome or Internet Explorer window is active before using hotkey."
        Exit
    }
}

setupBrowser(browser) {
    ; set input mode per browser
    if (browswer = "firefox.exe") { ; Firefox works better (but not completely) with Send mode
        SetKeyDelay, 100
    } else {
        SendMode, Input ; SendInput is better and Chrome and IE both work with it.
    }

    ; get proper window references per browser.
    ; dict of supported browsers and the names of the window where the files to be uploaded are selected.
    browserDict := {"chrome.exe": {"upload": "Open", "normal": "Chrome_WidgetWin_1"}
        , "firefox.exe": {"upload": "File Upload", "normal": "MozillaWindowClass"} ; doesn't actually work.
        , "IEXPLORE.EXE": {"upload": "Choose File to Upload", "normal": "IEFrame"}} 

    return {"upload": browserDict[browser]["upload"], "normal": browserDict[browser]["normal"]}
}

checkCancel(Val) {
    ; Function to check if cancel has been clicked and, if yes, terminate the currently running thread of this script
    if (Val) {
        Exit
    }
}

getForNum() {
    While (forValid != true) {
        ; While loop to request and check foreign ref number for validity
        num_foreign := promptForNum()
        forValid := checkFor(num_foreign)
    }
    return num_foreign
}

promptForNum() {
    ; function to display input box and request the number of foreign references from user.
    InputBox, temp, Foreign References, How many of the references being submitted are foreign references?
    checkCancel(ErrorLevel)
    return temp
}

isNotInt( str ) {
    ; function to check if value is integer.
    if str is not integer
        return true
    return false
}

checkFor(num_for) {
    ; function to check in value given for foreign references is valid.
    if (num_for < 0) {
        MsgBox % "Number of Foreign references cannot be negative.  Please only enter either 0 or positive numbers."
        return false
    } else if isNotInt(num_for) {
        MsgBox % "Please only enter either 0 or positive numbers."
        return false
    } else {
        return true
    }
}

submitRef(file, num, maxFor, uploadWindow, normalWindow, submitDelay) {
    ; function to manipulate web browser to submit select and upload references.

    IfWinNotActive, %uploadWindow%, , WinActivate, %wuploadWindow%,
    WinWaitActive, %uploadWindow%,
    Send, %file%
    Sleep, %submitDelay%
    Send, {ENTER}
    Sleep, %submitDelay%

    IfWinNotActive, ahk_class %normalWindow%, , WinActivate, ahk_class %normalWindow%,
    WinWaitActive, ahk_class %normalWindow% 
    Send, {TAB}i
    if (num <= maxFor) {
        Send, {TAB}f
    } else {
        Send, {TAB}n
    }
    Sleep, %submitDelay%
}

openUploadWindow(submitDelay, browser) {
    ; Function to enter keyboard commands to open upload window to prep for next reference.
    if (browser != "firefox.exe") {
        Send, {TAB 3}{SPACE}
        Sleep %submitDelay%,
        Send, {SHIFTDOWN}{TAB 5}{SHIFTUP}{SPACE}
        Sleep %submitDelay%,
    } else {
        Send, {TAB 3}{SPACE}{SHIFTDOWN}{TAB 5}{SHIFTUP}{SPACE}
    }
}
