param(
    [Parameter()]
    [string]$GitHubDestinationPAT,

    [Parameter()]
    [string]$ADOSourcePAT

)

Write-Host "------------------"
Write-Host 'refelect Azure DevOps repo changes to Github repo'
Write-Host '-------------------------------'
$AzureRepoName = "test"
$ADOCloneURL = "dev.azure.com/manjumandal/test/_git/test"
$GitHubCloneURL = "github.com/arq-group-manju-mandal/test.git"
$stageDir = Get-Location | Split-Path
Write-Host "Stage Dir is  : $stageDir"
$githubDir = $stageDir + "\" + "gitHub"
Write-Host "github Dir : $githubDir"
$destination = $githubDir + "\" + $AzureRepoName+ ".git"
Write-Host "destination: $destination"
$sourceURL = "https://$($ADOSourcePAT)"+"@"+"$($ADOCloneURL)"
Write-Host "source URL : $sourceURL"
$destURL = "https://" + $($GitHubDestinationPAT)+"@"+"$($GitHubCloneURL)"
Write-Host "dest URL : $destURL"

if((Test-Path-path $githubDir))
{
    Remove-Item -Path $githubDir -Recurse -force

}
if(!(Test-Path -path $githubDir))
{
    New-Item -ItemType directory -Path $githubDir
    Set-Location $githubDir
    git clone --mirror $sourceURL
}
else
{
    Write-Host "The given folder path $githubDir already exists"
}

Set-Location $destination
Write-Output '****Git removing remote secondary******'
git remote rm secondary
Write-Output '****Git remote add*****'
git remote add --mirror=fetch secondary $destURL
Write-Output '******Git fetch origin'
git fetch $sourceURL
Write-Output '*********Git push secondary'

git push secondary --all -f
Write-Output '**Azure DevOps repo synced with Github repo'
Set-Location $stageDir
if((Test-Path -path $githubDir))
{
    Remove-Item -Path $githubDir -Recurse -force
}
Write-Host "Job completed"


