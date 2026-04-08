#Requires AutoHotkey v2.0
#SingleInstance Force

; Input probe for Moonlight / Apollo right-button behavior.
; It records:
; - right button down/up
; - alt / ctrl / shift down/up
; - mouse movement while right button is held
; - logical vs physical key states reported by AutoHotkey
; - active window/process at the time of each event

CoordMode "Mouse", "Screen"

probeActive := false
sampleCount := 0
lastX := 0
lastY := 0
logFile := A_ScriptDir "\moonlight-rbutton-probe.log"

^!q::
{
    Suspend -1
    Log("toggle suspend -> " (A_IsSuspended ? "on" : "off"))
    TrayTip "moonlight-rbutton-probe", A_IsSuspended ? "Probe suspended" : "Probe resumed", 1000
}

^!e::
{
    Log("exit hotkey")
    ExitApp
}

~*RButton::
{
    global probeActive, sampleCount, lastX, lastY
    probeActive := true
    sampleCount := 0
    MouseGetPos &lastX, &lastY, &winId
    Log("RButton down | " StateSummary() " | " WindowSummary(winId) " | pos=" lastX "," lastY)
    SetTimer ProbeWhileRButtonHeld, 20
}

~*RButton Up::
{
    global probeActive
    Log("RButton up | " StateSummary())
    probeActive := false
    SetTimer ProbeWhileRButtonHeld, 0
}

~*RAlt::
{
    Log("RAlt down | " StateSummary())
}

~*RAlt Up::
{
    Log("RAlt up | " StateSummary())
}

~*LAlt::
{
    Log("LAlt down | " StateSummary())
}

~*LAlt Up::
{
    Log("LAlt up | " StateSummary())
}

~*Alt::
{
    Log("Alt down | " StateSummary())
}

~*Alt Up::
{
    Log("Alt up | " StateSummary())
}

~*LCtrl::
{
    Log("LCtrl down | " StateSummary())
}

~*LCtrl Up::
{
    Log("LCtrl up | " StateSummary())
}

~*RCtrl::
{
    Log("RCtrl down | " StateSummary())
}

~*RCtrl Up::
{
    Log("RCtrl up | " StateSummary())
}

~*LShift::
{
    Log("LShift down | " StateSummary())
}

~*LShift Up::
{
    Log("LShift up | " StateSummary())
}

~*RShift::
{
    Log("RShift down | " StateSummary())
}

~*RShift Up::
{
    Log("RShift up | " StateSummary())
}

ProbeWhileRButtonHeld()
{
    global probeActive, sampleCount, lastX, lastY

    if !probeActive
        return

    sampleCount += 1
    MouseGetPos &x, &y, &winId

    moved := (x != lastX || y != lastY)
    shouldLog := moved || Mod(sampleCount, 10) = 0

    if shouldLog
    {
        Log("RButton hold | sample=" sampleCount " | moved=" moved " | pos=" x "," y " | delta=" (x - lastX) "," (y - lastY) " | " StateSummary() " | " WindowSummary(winId))
    }

    lastX := x
    lastY := y
}

StateSummary()
{
    summary := "R(logical)=" GetKeyState("RButton")
        . " R(physical)=" GetKeyState("RButton", "P")
        . " M(logical)=" GetKeyState("MButton")
        . " M(physical)=" GetKeyState("MButton", "P")
        . " Alt(logical)=" GetKeyState("Alt")
        . " Alt(physical)=" GetKeyState("Alt", "P")
        . " RAlt(logical)=" GetKeyState("RAlt")
        . " RAlt(physical)=" GetKeyState("RAlt", "P")
        . " LAlt(logical)=" GetKeyState("LAlt")
        . " LAlt(physical)=" GetKeyState("LAlt", "P")
        . " RCtrl(logical)=" GetKeyState("RCtrl")
        . " RCtrl(physical)=" GetKeyState("RCtrl", "P")
        . " LCtrl(logical)=" GetKeyState("LCtrl")
        . " LCtrl(physical)=" GetKeyState("LCtrl", "P")
    return summary
}

WindowSummary(winId)
{
    title := WinGetTitle("ahk_id " winId)
    proc := WinGetProcessName("ahk_id " winId)
    return "win=" proc " | title=" title
}

Log(message)
{
    global logFile
    timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss") "." SubStr(A_MSec + 1000, 2)
    FileAppend timestamp " | " message "`n", logFile, "UTF-8"
}
