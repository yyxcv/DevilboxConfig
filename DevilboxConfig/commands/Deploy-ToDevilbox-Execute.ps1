param(
    [parameter(Mandatory = $true)]
    [string]$devilboxPath,

    [parameter(Mandatory = $true)]
    [string]$deployConfigPath,

    [parameter(Mandatory = $true)]
    [string]$modulePath,

    [parameter(Mandatory = $true)]
    [string]$ip
)



#source common functions
. "$modulePath\DevilboxConfigFunctions.ps1"

$deployConfig = parseFile "$deployConfigPath\config.txt"
$projectName = (Split-Path $deployConfigPath -Parent) -split "\\" | Select-Object -Last 1

if ($deployConfig["onDeployCopyEnvFile"] -eq $true)
{
    Write-Host "---- Copy "".env-file"" ----`n"
    Write-Host "$( $deployConfigPath )\.env ==>`n$( $devilboxPath )"
    Copy-Item "$( $deployConfigPath )\.env" -Destination $devilboxPath
    Write-Host "`n"
}

#scrpt must run with administrator privilages if onDeployAddHostsEntry is true
if ($deployConfig["onDeployAddHostsEntry"] -eq $true)
{
    #hostname is based on project-folder-name
    $hostname = "$( $projectName ).loc"

    Write-Host "------ Add Host-Entry ------`n"
    Write-Host "Hostname: $hostname"
    Write-Host "Ip: $ip`n"

    #add (or renew) host entry for our project
    & "$( $modulePath )\vendor\editHosts\RemoveFromHosts.ps1" -Hostname $hostname
    Write-Host "`n"
    & "$( $modulePath )\vendor\editHosts\AddToHosts.ps1" -Hostname $hostname -DesiredIP $ip
    Write-Host "`n"
}

if ($deployConfig["onDeployCopyProjectFiles"] -eq $true)
{
    Write-Host "------ Copy Project Files ------`n"
    $source = (Split-Path $deployConfigPath -Parent)
    $dest = "$devilboxPath\data\www"

    $abortCopyProjectFiles = $false
    if (-Not(Test-Path "$dest"))
    {
        Write-Host "Folder ""$dest"" does not exist. Can not deploy project files. Abort."
        $abortCopyProjectFiles = $true
    }
    if (-Not$abortCopyProjectFiles)
    {
        if (Test-Path "$dest\$projectName")
        {
            Write-Host "Remove old project files  from $dest"
            try
            {
                Remove-Item "$dest\$projectName" -Recurse -Force -ErrorAction Stop
            }
            catch
            {
                Write-Host "Could not remove Folder ""$dest\$projectName"". Abort"
                $abortCopyProjectFiles = $true
            }
        }
    }
    if (-Not$abortCopyProjectFiles)
    {
        try
        {
            Write-Host "Copy ""$source"" => ""$dest"""
            Copy-Item "$source" -Destination "$dest" -Recurse -ErrorAction Stop
        }
        catch
        {
            Write-Host "Could not copy Folder ""$source"" to ""$dest"". Abort"
            $abortCopyProjectFiles = $true
        }
    }
}



#prevent console window from closing
Write-Host "`n`n"
Write-Host  "`n`nPress any key to exit...";
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');