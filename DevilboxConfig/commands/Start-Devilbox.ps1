function Start-Devilbox
{
    $configFilePath = "$( Split-Path $PSScriptRoot -Parent )\config.txt"
    $config = parseFile $configFilePath
    validateGlobalDevilboxConfig $config $configFilePath

    $argument = @(
    "-NoExit"
    "-File $( $PSScriptRoot )\Start-Devilbox-Execute.ps1"
    "-devilboxPath $( $config["devilboxPath"] )"
    "-useDockerToolbox $( $config["useDockerToolbox"] )"
    )

    $ProcArgs = @{
        FilePath = 'powershell.exe'
        ArgumentList = $argument
        UseNewEnvironment = $false
    }

    Start-Process @ProcArgs

    Write-Host "Started new Devilbox"
}