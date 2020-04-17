Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#this is introduced to ajust the multiline text data during export comes as new line , part of the request, this will replace new line character and return character with space

Function FSErrorLogginStart()
{
param(
        [string] $Directory,
        [string] $FileName,
        [string] $Environment
)
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
$date=Get-Date -format "yyyy_MM-dd-hh-mm-ss"
$fname=$Filename+"_"+$Environment+"_"+$date
$OutputFileLocation = "$Directory\$fname.log"
Start-Transcript -path $OutputFileLocation -append
}

Function FSErrorLogginStop()
{
robocopy.exe C:\ D:\ readme.txt 2>&1 | out-host
Stop-Transcript
}


Export-ModuleMember -Function 'FSErrorLogginStart'
Export-ModuleMember -Function 'FSErrorLogginStop'