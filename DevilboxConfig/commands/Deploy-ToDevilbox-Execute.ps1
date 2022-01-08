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
    $deployBasePath = "$devilboxPath\data\www"

    if($deployConfig["wholeProjectIsPublic"] -eq $true)
    {
        $destination = "$deployBasePath\$projectName\htdocs"
    }else{     
        $destination = "$deployBasePath\$projectName"
    }

    $abortCopyProjectFiles = $false
    #test deployBasePath
    if (-Not(Test-Path $deployBasePath))
    {
        Write-Host "Folder ""$deployBasePath"" does not exist. Can not deploy project files. Abort."
        $abortCopyProjectFiles = $true
    }
    #remove old deployment
    if (-Not$abortCopyProjectFiles)
    {
        if (Test-Path "$destination")
        {
            Write-Host "Remove old project files from $destination"
            try
            {
                Remove-Item "$destination" -Recurse -Force -ErrorAction Stop
            }
            catch
            {
                Write-Host "Could not remove Folder ""$destination"". Abort"
                $abortCopyProjectFiles = $true
            }
        }
    }
    #copy files
    if (-Not$abortCopyProjectFiles)
    {
        try
        {
            
            if($deployConfig["wholeProjectIsPublic"] -eq $true){
                Write-Host "Copy ""$source\*"" => ""$destination"""
                New-Item "$destination" -ItemType Directory | Out-Null
                Copy-Item "$source\*" -Destination "$destination" -Recurse -ErrorAction Stop
            }else{
                Write-Host "Copy ""$source"" => ""$deployBasePath"""
                Copy-Item "$source" -Destination "$deployBasePath" -Recurse -ErrorAction Stop
            }
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