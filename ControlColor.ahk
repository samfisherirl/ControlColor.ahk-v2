/*
; original creator:
; http://www.autohotkey.com/board/topic/104539-controlcol-set-background-and-text-color-gui-controls/
; u/anonymous1184 for ahkv2 translation

    @method ControlColor.SetAll(myGuiObj,"Black")
        ; handles myGuiObj.BackColor := "Black"
        ; sets all button background, sets gui background
    @method ControlColor(buttonObj,GuiObj,0xFF0000)
    @method ControlColor(btn,GuiObj,"red")
        ; https://www.autohotkey.com/docs/v2/misc/Colors.htm
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
        } }
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
        Colors := Map("Black", 0x000000, "Silver", 0xC0C0C0, "Gray", 0x808080, "White", 0xFFFFFF, "Maroon", 0x800000, "Red", 0xFF0000, 
                    "Purple", 0x800080, "Fuchsia", 0xFF00FF, "Green", 0x008000, "Lime", 0x00FF00, "Olive", 0x808000, "Yellow", 0xFFFF00, 
                    "Navy", 0x000080, "Blue", 0x0000FF, "Teal", 0x008080, "Aqua", 0x00FFFF)
        for color, code in Colors {
            if InStr(color, userColor) {
                return code
            }
        }
        return false
    }
    static SetAll(g, color){
        for index, guiItem in g {
            if guiItem.Type = "Button" {
            ControlColor(guiItem, g, color)
            }
        }
        g.BackColor := color
        sleep(1)
    }
}

