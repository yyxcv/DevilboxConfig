#invoke a command and print it with its parameters
function Invoke-And-Print
{
    Write-Host "`n> $Args `n"

    if ($Args.Count -eq 1)
    {
        & $Args[0]
    }
    elseif($Args.Count -gt 1)
    {
        & $Args[0] $Args[1..($Args.Length - 1)]
    }

    Write-Host "`n"
}

function parseFile
{
    param([string]$path)
    return Get-Content -Path $path -Raw | ConvertFrom-StringData
}


#termine if the working directory or a direct sub-directory contains a devilbox deployment configurartion
#@returns the directory if present, $false otherwise
function findDeployConfigPath
{
    $parent = $pwd -split "\\" | Select-Object -Last 1

    #current path is deployConfigPath
    if ($parent -eq ".devilboxDeploy")
    {
        return $pwd
    }
    #child path is deployConfigPath
    elseif(Test-Path "$( $pwd )\.devilboxDeploy")
    {
        return "$( $pwd )\.devilboxDeploy"
    }

    return $false

}


function validateGlobalDevilboxConfig
{
    param(
        [Hashtable]$config,
        [String]$configFilePath
    )

    $requiredParam = @("DevilboxPath", "Ip", "useDockerToolbox")

    foreach ($parm in $requiredParam)
    {
        if (-Not $config.ContainsKey($parm))
        {
            Write-Host "Required Parameter '$parm' is not present in global config-File ($configFilePath). Abort."
            Exit
        }
    }

    if (-Not(Test-Path $config["DevilboxPath"]))
    {
        Write-Host "Parameter 'DevilboxPath' in global config-File ($configFilePath) is not a valid path. Abort."
        Exit
    }

}

function validateDeployConfig
{
    param(
        [Hashtable]$config,
        [String]$configFilePath
    )

    $requiredParam = @("onDeployCopyEnvFile", "onDeployAddHostsEntry", "onDeployCopyProjectFiles")

    foreach ($parm in $requiredParam)
    {
        if (-Not $config.ContainsKey($parm))
        {
            Write-Host "Required Parameter '$parm' is not present in global config-File ($configFilePath\config.txt). Abort."
            return
        }
    }

}