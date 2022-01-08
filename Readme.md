# DevilboxConfig

A PowerShell module to deploy multiple projects to devilbox.

## Installation

Run `powershell ./install.ps1` and follow the instructions. The module will be only installed for the current user.

## Usage

### Global Commands

`Start-Devilbox`<br>

* starts docker-machine (if you use docker-toolbox)
* stops and removes all devilbox containers
* starts all configured devilbox containers (at the moment the containers *httpd* *php* and *bind* are hard-coded in
  Start-Devilbox-Execute.ps1 )
  
`Stop-Devilbox`

* stops and removes all devilbox containers

`Enter-DevilboxDir`

* opens a new powershell console in the devilbox folder

### Deployment Commands

before using this commands, `cd` to your project folder.

`Initialize-DevilboxDeployment`

* Creates a new deployment configuration in subdirectory *.devilboxConfig* of the current working directory
    * creates a new *.env* file as a copy of *env_example*
    * creates a deployment configuration file *config.txt*

`Deploy-ToDevilbox`

* Based on the deployment configuration file does several of the following actions:
    * copies *.env* from *.devilboxConfig* to the devilbox dir
    * creates a *hosts* entry for the project
    * copies the project files to the devilbox dir

## Configuration

### Global Configuration

The following properties can be set in the global configuration in
%userprofile%\documents\WindowsPowerShell\Modules\DevilboxConfig\config.txt*:

| Property           | Description                                                                                                              |
|--------------------|--------------------------------------------------------------------------------------------------------------------------|
| DevilboxPath       | Path to your devilbox installation                                                                                       |
| Ip                 | IP address that is used by devilbox. Should be set to 192.168.99.100 if you use docker-toolbox or to 127.0.0.1 otherwise |
| useDockerToolbox   | Whether or not you use docker-toolbox                                                                                    |

### Deployment Configuration

The following properties can be set in the deployment configuration in %projectfolder%\.devilboxConfig\config.txt*:

| Property                 | Description                                                                                                                                     |
|--------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| onDeployCopyEnvFile      | Copy *.env* to the devilbox dir                                                                                                                 |
| onDeployAddHostsEntry    | Add or update an entry in *hosts* for the project. The domain name is %projectfolder%.loc, the IP can be configurated in the global config file |
| onDeployCopyProjectFiles | copy all project files to devilbox dir                                                                                                          |
| wholeProjectIsPublic | if the wholeProject is public, it will be deployed to %devilbox-dir%\data\www\%projectname%\htdocs otherwise it will be deployed to devilbox-dir%\data\www\%projectname%                                                                                                        |
