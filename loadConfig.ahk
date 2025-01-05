loadConfig(configFile) ; 加载配置文件
{   ; 读取配置文件并更新变量
    configContent := FileRead(configFile)
    loop parse, configContent, "`n", "`r" {
        line := Trim(A_LoopField)
        if (line = "" || InStr(line, "=") = 0)
            continue ; 跳过空行和无效行
        key := Trim(SubStr(line, 1, InStr(line, "=") - 1))
        value := Trim(SubStr(line, InStr(line, "=") + 1))
        switch (key) {
            case "n":
                n := value
                break
            case "idleCheckInterval":
                idleCheckInterval := value
                break
            case "activeCheckInterval":
                activeCheckInterval := value
                break
            case "toleranceX":
                toleranceX := value
                break
            case "toleranceY":
                toleranceY := value
                break
            case "moveX":
                moveX := value
                break
            case "moveY":
                moveY := value
                break
            case "topX":
                topX := value
                break
            case "topY":
                topY := value
                break
        }
    }
}
