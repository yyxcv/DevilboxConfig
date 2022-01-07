param(
    [parameter(Mandatory = $true)]
    [string]$devilboxPath
)

Write-Host "> cd $devilboxPath`n"
Set-Location $devilboxPath

Write-Host "`n> docker-compose stop`n"
& "docker-compose" stop

Write-Host "`n> docker-compose rm -f`n"
& "docker-compose" rm -f

Write-Host "`n"