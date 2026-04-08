#Requires AutoHotkey v2.0
#SingleInstance Force

A_MaxHotkeysPerInterval := 500

; SolidWorks only:
; - short right click => scripted right click on release
; - hold right button + Q => middle button drag
;
; Debugging goal:
; - suppress the native right click so SolidWorks should not open its context menu
; - record every state transition to verify what Moonlight is actually delivering

CoordMode "Mouse", "Screen"

rHeld := false
qSeen := false
middleHeld := false
ignoreRightHotkeysUntil := 0
pendingRightClick := false
rightClickDelayMs := 180
gestureUsedQ := false
logFile := A_ScriptDir "\sw-ralt-pan.log"

^!q::
{
    Suspend -1
    Log("toggle suspend -> " (A_IsSuspended ? "on" : "off"))
    TrayTip "sw.ahk", A_IsSuspended ? "Script suspended" : "Script resumed", 1000
}

^!e::
{
    Log("exit hotkey")
    ReleaseMouseButtons()
    ExitApp
}

#HotIf WinActive("ahk_exe SLDWORKS.exe") && !A_IsSuspended
*RButton::
{
    global rHeld, qSeen, middleHeld, ignoreRightHotkeysUntil, pendingRightClick, gestureUsedQ

    if A_TickCount < ignoreRightHotkeysUntil
    {
        Log("RButton down ignored: scripted click window")
        return
    }

    if rHeld
    {
        Log("RButton down ignored: already held")
        return
    }

    pendingRightClick := false
    SetTimer SendDeferredRightClick, 0
    rHeld := true
    qSeen := false
    middleHeld := false
    gestureUsedQ := false
    Log("RButton down -> native suppressed")
    SetTimer WatchCombo, 10
}

*RButton Up::
{
    global rHeld, qSeen, middleHeld, ignoreRightHotkeysUntil, pendingRightClick, rightClickDelayMs, gestureUsedQ

    if A_TickCount < ignoreRightHotkeysUntil
    {
        Log("RButton up ignored: scripted click window")
        return
    }

    Log("RButton up")
    SetTimer WatchCombo, 0
    rHeld := false

    if middleHeld
    {
        FinishMiddleDrag("RButton up")
        return
    }

    if gestureUsedQ || qSeen
    {
        Log("RButton up -> q-used gesture, skip normal context click")
        qSeen := false
        gestureUsedQ := false
        return
    }

    pendingRightClick := true
    Log("RButton up -> schedule scripted right click after " rightClickDelayMs "ms")
    SetTimer SendDeferredRightClick, -rightClickDelayMs
}

^+m::
{
    global middleHeld

    if middleHeld
        return

    Log("^+m down -> direct middle drag start")
    MiddleButtonDown()
    middleHeld := true
}

^+m Up::
{
    FinishMiddleDrag("^+m up")
}
#HotIf

WatchCombo()
{
    global rHeld, qSeen, middleHeld, pendingRightClick, gestureUsedQ

    if !rHeld
        return

    qDown := GetKeyState("q")

    if qDown && !qSeen && !middleHeld
    {
        pendingRightClick := false
        qSeen := true
        gestureUsedQ := true
        Log("Q detected by polling")
        StartMiddleDrag()
        return
    }

    if !qDown && qSeen
    {
        Log("Q released by polling")
        qSeen := false

        if middleHeld
            FinishMiddleDrag("Q released")
    }
}

StartMiddleDrag()
{
    global middleHeld

    if middleHeld
    {
        Log("StartMiddleDrag ignored: already active")
        return
    }

    Log("middle drag start")
    Sleep 10
    MiddleButtonDown()
    middleHeld := true
}

FinishMiddleDrag(reason := "")
{
    global middleHeld, qSeen

    qSeen := false

    if !middleHeld
    {
        Log("FinishMiddleDrag ignored" (reason != "" ? ": " reason : ""))
        return
    }

    Log("middle drag stop" (reason != "" ? ": " reason : ""))
    MiddleButtonUp()
    middleHeld := false
}

ReleaseMouseButtons()
{
    MiddleButtonUp()
    RightButtonUp()
}

MiddleButtonDown()
{
    DllCall("user32.dll\mouse_event", "UInt", 0x0020, "UInt", 0, "UInt", 0, "UInt", 0, "UPtr", 0)
}

MiddleButtonUp()
{
    DllCall("user32.dll\mouse_event", "UInt", 0x0040, "UInt", 0, "UInt", 0, "UInt", 0, "UPtr", 0)
}

SendDeferredRightClick()
{
    global pendingRightClick, rHeld, middleHeld

    if !pendingRightClick
    {
        Log("deferred right click canceled")
        return
    }

    if rHeld || middleHeld
    {
        Log("deferred right click skipped: rHeld=" rHeld " middleHeld=" middleHeld)
        pendingRightClick := false
        return
    }

    pendingRightClick := false
    Log("deferred right click fired")
    RightClick()
}

RightClick()
{
    global ignoreRightHotkeysUntil

    ignoreRightHotkeysUntil := A_TickCount + 150
    Click "Right"
}

RightButtonUp()
{
    DllCall("user32.dll\mouse_event", "UInt", 0x0010, "UInt", 0, "UInt", 0, "UInt", 0, "UPtr", 0)
}

Log(message)
{
    global logFile
    timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss") "." SubStr(A_MSec + 1000, 2)
    FileAppend timestamp " | " message "`n", logFile, "UTF-8"
}
