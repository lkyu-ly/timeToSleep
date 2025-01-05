; #Requires AutoHotkey v2.0

; Persistent
; SetTimer(CheckFullScreen, 1000)  ; 每秒检查一次全屏状态
; DetectHiddenWindows true  ; 隐藏窗口也能获取到坐标

; scriptDir := A_ScriptDir
; logPath := scriptDir "\lastlog.txt"
; try {
;     FileDelete logPath
; }
; 以上内容单独运行时启用

CheckFullScreen() {
    ; 获取当前窗口的尺寸和位置

    try {
        ; WinGetClientPos(&X, &Y, &Width, &Height, title := WinGetTitle("A"))

        WinGetPos(&X, &Y, &Width, &Height, title := WinGetTitle("A"))
        FileAppend("[" FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss") "] 检测：" title " `n", logPath)
        if (title == "Program Manager") {
            FileAppend("[" FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss") "] 忽略：当前窗口为 桌面`n", logPath)
            return 0  ; 忽略桌面
        }
    }
    catch {
        FileAppend("[" FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss") "] 忽略：获取窗口 " title " 信息失败`n", logPath)
        return 0  ; 忽略错误
    }
    else {
        ; ToolTip(Width "," Height)
        ; 判断窗口是否全屏
        if (X == 0 && Y == 0 && Width == A_ScreenWidth && Height == A_ScreenHeight) {
            ; ToolTip "全屏"
            FileAppend("[" FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss") "] 判断：" title " 为全屏`n", logPath)
            return 1
        } else {

            ; ToolTip "非全屏"
            FileAppend("[" FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss") "] 判断：" title " 为非全屏`n", logPath)
            return 0
        }
    }

}
