#Requires AutoHotkey v2.0
#SingleInstance Force

; 初始化配置变量
n := 5 ; 空闲->持续检测的秒数
idleCheckInterval := 1000 ; 空闲检测间隔（毫秒）
activeCheckInterval := 100 ; 持续检测间隔（毫秒）
toleranceX := 10 ; 允许的X轴误差范围（像素）
toleranceY := 10 ; 允许的Y轴误差范围（像素）
moveX := A_ScreenWidth / 2 ; 鼠标移动的目标X坐标
moveY := A_ScreenHeight / 2 ; 鼠标移动的目标Y坐标
topX := 0 ; 左上角的X坐标
topY := 0 ; 左上角的Y坐标

logPath := A_ScriptDir "\lastlog.txt"
try {
    FileDelete logPath
}

#Include testConfig.ahk

testConfig()

CoordMode("Mouse", "Screen") ; 坐标模式为屏幕坐标

; 初始化变量
isDetecting := false
detectionCount := 0
lastCheckTime := 0

#Include checkFullScreen.ahk

; 主循环
loop {
    ; 根据检测状态选择检测间隔
    if (!isDetecting) {
        Sleep idleCheckInterval ; 空闲时检测间隔
    } else {
        Sleep activeCheckInterval ; 持续检测时检测间隔
    }

    ; 获取鼠标位置
    MouseGetPos(&mouseX, &mouseY)
    ; ToolTip(mouseX "," mouseY) ; 显示当前鼠标位置

    ; 检查鼠标位置是否在左上角附近
    if (mouseX < topX + toleranceX && mouseY < topY + toleranceY && CheckFullScreen() == 0) {
        ; 鼠标位置在左上角附近且窗口不是全屏
        if (!isDetecting) {
            ; 若未在持续检测状态，开始持续检测
            isDetecting := true
            detectionCount := 0
            detectionStartTime := A_TickCount
        } else {
            ; 持续检测中
            if (A_TickCount - detectionStartTime >= n * 1000) {
                ; 触发休眠
                MouseMove(moveX, moveY) ; 移动鼠标到指定位置
                ; 重置检测状态
                isDetecting := false
                detectionCount := 0
                DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 0, "Int", 0) ; 触发休眠
                continue
            }
        }
    } else {
        ; 重置检测状态
        isDetecting := false
        detectionCount := 0
    }
}

^!Esc:: Pause ; 按下Ctrl+Alt+Esc键暂停脚本
