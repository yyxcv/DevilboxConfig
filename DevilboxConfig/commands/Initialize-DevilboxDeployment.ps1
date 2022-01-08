function Initialize-DevilboxDeployment
{
    $configFilePath = "$( Split-Path $PSScriptRoot -Parent )\config.txt"
    $config = parseFile $configFilePath
    validateGlobalDevilboxConfig $config $configFilePath

    if (findDeployConfigPath)
    {
        Write-Host "Deploy configuration already present in current folder ""$( findDeployConfigPath )"". Abort."
        Exit
    }

    $title = 'Confirm'
    $question = "Are you sure that you want to create the deploy configuration in `n""$( $pwd )""?"
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)

    if ($decision -eq 1)
    {
        Write-Host "Cancelled. No Changes Performed.`n"
        Exit
    }

    #create new one deploy configuration
    $deployFolder = "$pwd\.devilboxDeploy"

    Write-Host "`n1. Create ""$deployFolder""`n"
    $null = New-Item -Path $pwd -Name ".devilboxDeploy" -ItemType "directory"

    #get new copy of .env form devilbox folder
    $source = "$( $config["devilboxPath"] )\env-example"
    $dest = "$deployFolder\.env"

    if (Test-Path $source)
    {
        Write-Host "2. Get new copy of "".env-file""`n    $source ==> $dest`n"
        Copy-Item  $source -Destination $dest
    }
    else
    {
        Write-Host "Could not find $source. sciping creation of .env-file. Please copy a devilbox '.env'-file yourself into the deploy folder (.devilboxDeploy) "
    }

    Write-Host "Create inital config.txt"
    $configTxt = @"
onDeployCopyEnvFile = True
onDeployAddHostsEntry = True
onDeployCopyProjectFiles = False

#if the wholeProject is public, it will be deployed to %devilbox-dir%\data\www\%projectname%\htdocs (HTTPD_DOCROOT_DIR must be set to 'htdocs' too (that's the default value)).
#Otherwise it will be deployed to %devilbox-dir%\data\www\%projectname%. 
wholeProjectIsPublic = False
"@
    $configTxt | Out-File  -FilePath "$deployFolder\config.txt"

    Write-Host "Please edit config.txt to your needs"
    Start-Process "$env:SystemRoot\notepad.exe" "$deployFolder\config.txt"

}