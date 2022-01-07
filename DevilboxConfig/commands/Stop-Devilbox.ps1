function Stop-Devilbox
{
    $configFilePath = "$( Split-Path $PSScriptRoot -Parent )\config.txt"
    $config = parseFile $configFilePath
    validateGlobalDevilboxConfig $config $configFilePath

    $argument = @(
    "-NoExit"
    "-File $( $PSScriptRoot )\Stop-Devilbox-Execute.ps1"
    "-devilboxPath $( $config["devilboxPath"] )"
    )

    $ProcArgs = @{
        FilePath = 'powershell.exe'
        ArgumentList = $argument
        UseNewEnvironment = $false
    }

    Start-Process @ProcArgs

    Write-Host "Stopped Devilbox"
}