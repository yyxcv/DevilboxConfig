param(
    [parameter(Mandatory = $true)]
    [string]$devilboxPath,

    [parameter(Mandatory = $true)]
    [string]$useDockerToolbox
)

Write-Host "> Set-Location $devilboxPath`n"
Set-Location $devilboxPath

if ($useDockerToolbox)
{
    if ((docker-machine status default) -eq "Stopped")
    {
        Write-Host "> docker-machine start default"
        & "docker-machine" start default
    }
    else
    {
        Write-Host "docker-machine ""default"" is already running. No need to start it.`n"
    }
}

Write-Host "`n> docker-compose stop`n"
& "docker-compose" stop

Write-Host "`n> docker-compose rm -f`n"
& "docker-compose" rm -f

Write-Host "`n> docker-compose up --detach httpd php bind`n"
& "docker-compose" up --detach httpd php bind

Write-Host "`n"