# ControlColor.ahk-v2
Set background color for buttons and other controls in AHKv2 Gui's. 

```autohotkey
    @example
        btn := GuiObj.Add("Button",,"OK")
        ControlColor(btn.hWnd, g.hWnd, 0xFF0000)
    @example
        btn := GuiObj.Add("Button",,"OK")
        ControlColor(btn.hWnd, g.hWnd, "red")
```
