param( 
	[Parameter(Mandatory=$true)][object]$bump,
	[Parameter(Mandatory=$true)][object]$distribute
	);

$bump = $bump -eq "1";
$distribute = $distribute -eq "1";

. "$PSScriptRoot/Common.ps1" -bump:$bump;

# clean solution
& $msbuild "$solutionDir" /p:Configuration=Release /t:Clean;
$noclean = $true;

# publish server
Remove-Item "$packagesRootDir/ReleaseNote.txt" -ErrorAction Ignore;
Remove-Item $packagesServerDir -ErrorAction Ignore -Recurse;

& "$solutionDir/VpnHood.Server.App.Net/_publish.ps1";

# upload
if ($distribute)
{
	& "$PSScriptRoot/PublishToGitHub.ps1";
}
