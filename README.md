# ControlColor.ahk-v2
Set background color for buttons and other controls in AHKv2 Gui's. 

Credit to u/anonymous1184 for doing the heavy lifting on this one. https://www.reddit.com/r/AutoHotkey/comments/158ngog/need_help_converting_ahkv1_object_between_0x312/

```autohotkey
    @example
        btn := GuiObj.Add("Button",,"OK")
        ControlColor(btn, g, 0xFF0000)
    @example
        btn := GuiObj.Add("Button",,"OK")
        ControlColor(btn, g, "red")
```
![Screenshot 2023-07-24 212909](https://github.com/samfisherirl/ControlColor.ahk-v2/assets/98753696/8d03c6e8-77a1-45ce-8909-945394f57f02)
