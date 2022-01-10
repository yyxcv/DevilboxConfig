function Enter-DevilboxDir
{
    $configFilePath = "$( Split-Path $PSScriptRoot -Parent )\config.txt"
    $config = parseFile $configFilePath
    validateGlobalDevilboxConfig $config $configFilePath

    Start-Process powershell -WorkingDirectory "$($config["DevilboxPath"])"

    Write-Host "Started new shell in devilbox dir"
}