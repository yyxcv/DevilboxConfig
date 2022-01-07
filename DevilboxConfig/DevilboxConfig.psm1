<#
 .Synopsis
  A PowerShell module to deploy multiple projects to devilbox.

 .Description
  Supports functions to manage devilbox as well as to deploy individual
  .env files and hosts-entries for mulitple projects.
 #>

 #>
#>

#source private utility functions
. "$PSScriptRoot\DevilboxConfigFunctions.ps1"

#source all commands
#   files that end with '-Execute.ps1' are not sourced,
#   as they represent scripts that are invoked by commands
$commands = Get-ChildItem -path "$PSScriptRoot\commands" -Exclude "*-Execute.ps1"
foreach ($command in $commands)
{
    . $command.FullName
}

Export-ModuleMember -Function $commands.BaseName