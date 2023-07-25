# ControlColor.ahk-v2
Set background color for buttons and other controls in AHKv2 Gui's. 

Credit to u/anonymous1184 for doing the heavy lifting on this one. https://www.reddit.com/r/AutoHotkey/comments/158ngog/need_help_converting_ahkv1_object_between_0x312/

original creator: http://www.autohotkey.com/board/topic/104539-controlcol-set-background-and-text-color-gui-controls/

```autohotkey
    @example
        btn := GuiObj.Add("Button",,"OK")
        ControlColor(btn, g, 0xFF0000)
    @example
        btn := GuiObj.Add("Button",,"OK")
        ControlColor(btn, g, "red")
```
![Screenshot 2023-07-24 212909](https://github.com/samfisherirl/ControlColor.ahk-v2/assets/98753696/beced863-99aa-4779-8b07-4a2df8989507)
