function Enter-DevilboxDir
{
    $configFilePath = "$( Split-Path $PSScriptRoot -Parent )\config.txt"
    $config = parseFile $configFilePath
    validateGlobalDevilboxConfig $config $configFilePath

    $argument = @(
    "-NoExit"
    "-Command  `"Set-Location $( $config["DevilboxPath"] ) `""
    )

    $ProcArgs = @{
        FilePath = 'powershell.exe'
        ArgumentList = $argument
        UseNewEnvironment = $false
    }


    Start-Process @ProcArgs

    Write-Host "Started new shell in devilbox dir"
}