function Edit-DevilboxConfig
{
    Start-Process "$env:SystemRoot\notepad.exe" "$(Split-Path $PSScriptRoot -Parent)\config.txt"
    Write-Host "Edit config.txt to your needs"
}