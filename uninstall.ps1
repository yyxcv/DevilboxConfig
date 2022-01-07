$installFolder = "$([Environment]::GetFolderPath("MyDocuments") )\WindowsPowerShell\Modules\DevilboxConfig"

if (Test-Path (-Not$installFolder))
{
    Write-Host "DevilboxConfig does not seem to be installed (""$installFolder"" does not exist). Abort."
    Exit
}

$title = 'Uninstall?'
$question = "Are you shure that you want to uninstall DevilboxConfig?"
$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
$decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)

if ($decision -eq 0)
{
    Remove-Item -Recurse -Force "$installFolder"
    Write-Host "Successfully uninstalled DevilboxConfig."
}
else
{
    Write-Host "Aborted without uninstalling."
}