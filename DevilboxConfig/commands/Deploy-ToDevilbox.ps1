#start Deploy-ToDevilbox-Execute
# run as admin if  onDeployAddHostsEntry is true
function Deploy-ToDevilbox
{
    $configFilePath = "$( Split-Path $PSScriptRoot -Parent )\config.txt"
    $deployConfigPath = findDeployConfigPath
    $globalConfig = parseFile $configFilePath
    validateGlobalDevilboxConfig $globalConfig $configFilePath

    if (-Not($deployConfigPath))
    {
        Write-Host "Error: Path ""$pwd\.devilboxDeploy"" not found. Run ""Initialize-DevilboxDeployment"" to create a Deployment Configuration in the current working directory."
        return
    }

    if (-Not(Test-Path "$( $deployConfigPath )\config.txt"))
    {
        Write-Host "Error: ""config.txt""-file does not exist in DeployConfigPath ""$( deployConfigPath )"""
        return
    }

    if (-Not(Test-Path "$( $deployConfigPath )\.env"))
    {
        Write-Host "Error: "".env""-file does not exist in DeployConfigPath ""$( deployConfigPath )"""
        return
    }

    $deployConfig = parseFile "$deployConfigPath\config.txt"
    validateDeployConfig $deployConfig $deployConfigPath



    $argument = @(
    #"-NoExit" #uncomment for debugging
    "-File $( $PSScriptRoot )\Deploy-ToDevilbox-Execute.ps1"
    "-ip $( $globalConfig["Ip"] )"
    "-devilboxPath $( $globalConfig["devilboxPath"] )"
    "-deployConfigPath $( $deployConfigPath )"
    "-modulePath $( Split-Path $PSScriptRoot -Parent )"
    )

    $ProcArgs = @{
        FilePath = 'powershell.exe'
        ArgumentList = $argument
    }

    if ($deployConfig["onDeployAddHostsEntry"] -eq $true)
    {
        $ProcArgs["Verb"] = 'RunAs'
        Write-Host "Started Deploy-Process in new Window. Please authorize administrator privileges." -ForegroundColor DarkGreen
    }else{
        Write-Host "Started Deploy-Process in new Window." -ForegroundColor DarkGreen
    }

    Start-Process @ProcArgs
}