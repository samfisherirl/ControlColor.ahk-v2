﻿; original creator:
; http://www.autohotkey.com/board/topic/104539-controlcol-set-background-and-text-color-gui-controls/
; u/anonymous1184 for ahkv2 translation

#Requires AutoHotkey v2.0
Persistent(true)
g := Gui(, "Window " A_AhkVersion)
btn := g.Add("Button", "w80 h23", "&OK")
g.BackColor := "Black"
ControlColor(btn, g, 0x000000)
g.Show("x1000 y700 w100 ")

g2 := Gui(, "Window " A_AhkVersion)
btn2 := g2.Add("Button", "w80 h23", "&OK")
ControlColor(btn2, g2, "Red")
g2.BackColor := "Red"
g2.Show("x1100 y700 w100 ")


g1 := Gui(, "Window " A_AhkVersion)
btn2 := g1.Add("Button", "w80 h23", "&OK")
g1.BackColor := "Black"
g1.Show("x1000 y800 w100 ")

g3 := Gui(, "Window " A_AhkVersion)
btn3 := g3.Add("Button", "w80 h23", "&OK")
g3.BackColor := "FF0000"
g3.Show("x1100 y800 w100 ")
Exit()
/*
    @example
        btn := GuiObj.Add("Button",,"OK")
        ControlColor(btn.hWnd, g.hWnd, 0xFF0000)
*/
class ControlColor {
    static Call(Control, Window, bc := "", tc := "", Redraw := true) 
    {
        Control := Control.hwnd, Window := Window.hwnd
        if IsAlpha(Trim(bc)) && not (bc = "") {
            bc := ControlColor.HColors(bc)
        }
        a := {
            c: Control,
            g: Window,
            bc: (bc = "") ? "" : (((bc & 255) << 16) + (((bc >> 8) & 255) << 8) + (bc >> 16)),
            tc: (tc = "") ? "" : (((tc & 255) << 16) + (((tc >> 8) & 255) << 8) + (tc >> 16))
        }
        this.CC_WindowProc("Set", a, "", "")
        if (Redraw) {
            WinRedraw(, , "ahk_id " Control)
    } }
    static CC_WindowProc(hWnd, uMsg, wParam, lParam) 
    {
        static Win := Map()
        if (IsNumber(uMsg) && uMsg >= 306 && uMsg <= 312) { ; WM_CTLCOLOR(MSGBOX|EDIT|LISTBOX|BTN|DLG|SCROLLBAR|STATIC)
            if (Win[hWnd].Has(lParam)) {
                if (tc := Win[hWnd][lParam].tc) {
                    DllCall("gdi32\SetTextColor", "Ptr", wParam, "UInt", tc)
                }
                if (bc := Win[hWnd][lParam].bc) {
                    DllCall("gdi32\SetBkColor", "Ptr", wParam, "UInt", bc)
                }
                return Win[hWnd][lParam].Brush ; return the HBRUSH to notify the OS that we altered the HDC.
        }}
        if (hWnd = "Set") {
            a := uMsg
            Win[a.g] := Map(a.c, a)
            if ((Win[a.g][a.c].tc = "") && (Win[a.g][a.c].bc = "")) {
                Win[a.g].Remove(a.c, "")
            }
            if (!Win[a.g].Has("WindowProcOld")) {
                method := ObjBindMethod(this, "CC_WindowProc")
                cb := CallbackCreate(method, , 4)
                retval := DllCall("SetWindowLong" . (A_PtrSize = 8 ? "Ptr" : ""), "Ptr", a.g, "Int", -4, "Ptr", cb, "Ptr")
                Win[a.g]["WindowProcOld"] := retval
            }
            if (Win[a.g][a.c].bc != "") {
                Win[a.g][a.c].Brush := DllCall("gdi32\CreateSolidBrush", "UInt", a.bc, "Ptr")
            }
            return
        }
        oldProc := IsSet(Win) && IsObject(Win) ? Win[hWnd]["WindowProcOld"] : 0
        return DllCall("CallWindowProc", "Ptr", oldProc, "Ptr", hWnd, "UInt", uMsg, "Ptr", wParam, "Ptr", lParam, "Ptr")
    }
    static HColors(userColor)
    {
        Colors := Map("Black", 0x000000, "Silver", 0xC0C0C0, "Gray", 0x808080, "White", 0xFFFFFF, "Maroon", 0x800000, "Red", 0xFF0000, "Purple", 0x800080, "Fuchsia", 0xFF00FF, "Green", 0x008000, "Lime", 0x00FF00, "Olive", 0x808000, "Yellow", 0xFFFF00, "Navy", 0x000080, "Blue", 0x0000FF, "Teal", 0x008080, "Aqua", 0x00FFFF)
        for color, code in Colors {
            if InStr(color, userColor) {
                return code
            }
        }
        return false
}   }

