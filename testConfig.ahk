#Include loadConfig.ahk

testConfig() {
    ; 读取配置文件
    configFile := A_ScriptDir "\config.txt"
    if !FileExist(configFile) {
        Result := MsgBox("配置文件不存在！", , "ARI IconX Default3")
        if (Result = "Abort")
            ExitApp
        else if (Result = "Ignore")
            return ; 跳过配置文件读取
        else
            testConfig()
    }
    else {
        loadConfig(configFile)
    }
}
