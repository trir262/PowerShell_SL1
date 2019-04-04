task . InstallDependencies, Clean , Analyze, Analyze_pester, Archive , Publish, UpdateVersion

task InstallDependencies {
    Install-Module Pester -Force
    Install-Module PSScriptAnalyzer -Force
}

task Analyze_pester {
    . .\tests\pester.ps1 -TestGeneral:$True
}
task Analyze {
#    write-host $BuildRoot
    $scriptAnalyzerParams = @{
        Path = "$BuildRoot\"
        Severity = @('Error', 'Warning')
        Recurse = $true
        Verbose = $false
        ExcludeRule = @('PSUseDeclaredVarsMoreThanAssignments', 'PSAvoidGlobalVars', 'PSAvoidUsingInvokeExpression','PSAvoidUsingConvertToSecureStringWithPlainText')
    }

    $saResults = Invoke-ScriptAnalyzer @scriptAnalyzerParams | Where-Object { $_.ScriptName -notmatch 'Build\.ps1'}

    if ($saResults) {
        $saResults | Format-Table
        throw "One or more PSScriptAnalyzer errors/warnings where found."
    }
}

task Clean {
    $Artifacts = "$BuildRoot\Artifacts\$((("$($BuildFile)" -split '\\')[-1] -split '\.')[0])"
    
    if (Test-Path -Path $Artifacts)
    {
        Remove-Item "$Artifacts/*" -Recurse -Force
    }

    New-Item -ItemType Directory -Path $Artifacts -Force |Out-Null
}

task Archive {
    $Artifacts = "$BuildRoot\Artifacts\$((("$($BuildFile)" -split '\\')[-1] -split '\.')[0])"
    ($buildroot -split '\\')[-1] | Out-Null
    Copy-Item -Path .\ScienceLogic_SL1.psd1 -Destination "$Artifacts"
    Copy-Item -Path .\ScienceLogic_SL1.psm1 -Destination "$Artifacts"
    Copy-Item -Path .\functions -Destination "$Artifacts" -Recurse
    Copy-Item -Path .\internal -Destination "$Artifacts" -Recurse
	Copy-Item -Path .\xml -Destination "$Artifacts" -Recurse
	Copy-Item -Path .\en-us -Destination "$Artifacts" -Recurse
}

task Publish {
	Publish-Module -Path "$BuildRoot\Artifacts\$((("$($BuildFile)" -split '\\')[-1] -split '\.')[0])" -NuGetApiKey (Get-Content "$($BuildRoot)\..\PrivateData\APIKey.txt")
}

task UpdateVersion {
    try
    {
        $moduleManifestFile = "$(((("$($BuildFile)" -split '\\')[-1] -split '\.')[0]+'.psd1'))"
        $manifestContent = Get-Content $moduleManifestFile -Raw
        [version]$version = [regex]::matches($manifestContent,"ModuleVersion\s=\s\'(?<version>(\d+\.)?(\d+\.)?(\*|\d+))") | ForEach-Object {$_.groups['version'].value}
        $newVersion = "{0}.{1}.{2}" -f $version.Major, $version.Minor, ($version.Build + 1)

        $replacements = @{
            "ModuleVersion = '.*'" = "ModuleVersion = '$newVersion'"
        }

        $replacements.GetEnumerator() | ForEach-Object {
            $manifestContent = $manifestContent -replace $_.Key,$_.Value
        }
        $manifestContent | Set-Content -Path "$BuildRoot\$moduleManifestFile"
    }
    catch
    {
        Write-Error -Message $_.Exception.Message
        $host.SetShouldExit($LastExitCode)
    }
}
