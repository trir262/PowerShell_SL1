Describe "Testing Connect-SL1" {
    $moduleRoot = (Resolve-Path "$PSScriptRoot\..\..").Path
    $manifest = ((Get-Content "$moduleRoot\ScienceLogic_SL1.psd1") -join "`n") | Invoke-Expression
        
    InModuleScope ScienceLogic_SL1 {
        function Invoke-SL1Request {
            return New-Object -TypeName psobject -Property @{StatusCode = 200}
        }
    }
    Context "Function working" {
        BeforeAll {
            $Uri = 'https://www.google.be'
            $Cred = [pscredential]::new('user', (ConvertTo-SecureString -AsPlainText -Force -String 'pwd') )
        }

        it 'should return $null' {
            Connect-SL1 -Uri $Uri -Credential $Cred -Passthru | should be Empty
        }

    }
}
