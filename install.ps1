. "$PSScriptRoot\DevilboxConfig\DevilboxConfigFunctions.ps1"

$installFolder = "$([Environment]::GetFolderPath("MyDocuments") )\WindowsPowerShell\Modules"

if (Test-Path (-Not$installFolder))
{
    Write-Host "Install-Folder ""$installFolder"" does not exist. Abort."
    Exit
}

if (Test-Path "$installFolder\DevilboxConfig")
{
    Write-Host "DevilboxConfig already installed in ""$installFolder"""

    $title = 'Reinstall?'
    $question = "Would you like to reinstall DevilboxConf into ""$installFolder""?"
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)

    if ($decision -eq 0)
    {
        Write-Host "Remove old Install from $installFolder"
        try
        {
            Remove-Item "$installFolder\DevilboxConfig" -Recurse -Force -ErrorAction Stop
        }
        catch
        {
            Write-Host "Could not remove Folder ""$installFolder\DevilboxConfig"". Abort"
            Exit
        }
    }
    else
    {
        Exit
    }
}
else
{
    $title = 'Confirm'
    $question = "Install DevilboxConfig into ""$installFolder""?"
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
}

if ($decision -eq 1)
{
    Write-Host "Installation aborted."
    Exit
}

Write-Host "Install dependencies..."
if (-Not(Test-Path "$PSScriptRoot/DevilboxConfig/vendor/editHosts"))
{
    Invoke-And-Print "git" "clone" "https://github.com/yyxcv/EditHosts.git" "$PSScriptRoot/DevilboxConfig/vendor/editHosts"
}
else
{
    Write-Host "Dependencies already installed. Nothing to do."
}

if (Get-Module -ListAvailable -Name DevilboxConfig)
{
    Write-Host "Remove-Module DevilboxConfig"
    Remove-Module DevilboxConfig
}

Write-Host "Copy DevilboxConfig to Install-Folder"
Copy-Item "$PSScriptRoot\DevilboxConfig" -Destination $installFolder -Recurse


Write-Host "Create inital config.txt"

$configTxt = @"
DevilboxPath = $("$env:userprofile\documents\devilbox".replace("\", "\\") )
Ip = 127.0.0.1
useDockerToolbox = False
"@

$configTxt | Out-File  -FilePath "$installFolder\DevilboxConfig\config.txt"

$title = 'Edit config.txt'
$question = "You have to set the path to devilbox in the global configuration file`n""$installFolder\DevilboxConfig\config.txt"".`nWould you like to do so now?"
$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)

if ($decision -eq 0)
{
    Write-Host "Please edit config.txt"
    Start-Process "$env:SystemRoot\notepad.exe" "$installFolder\DevilboxConfig\config.txt"

    Write-Host  "`n`nPress any key to continue...";
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}

Import-Module DevilboxConfig -Verbose

Write-Host "Success-Fully installed DevilboxConfig!"
Write-Host -ForegroundColor DarkGreen "`nPlease restart your PowerShell-Console in order to use the new Module`n"