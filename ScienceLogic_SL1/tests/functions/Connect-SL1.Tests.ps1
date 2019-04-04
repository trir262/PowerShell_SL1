Remove-Module ScienceLogic_SL1 -ErrorAction Ignore
Import-Module "$PSScriptRoot\..\..\ScienceLogic_SL1.psd1"
InModuleScope 'ScienceLogic_SL1' {
    Describe 'Connect-SL1' {
        BeforeAll {
            $Uri = 'https://www.google.be'
            $Cred = [pscredential]::new('user', (ConvertTo-SecureString -AsPlainText -Force -String 'pwd') )
            mock Invoke-SL1Request {
                return New-Object -TypeName psobject -Property @{StatusCode = 200}
            }
        }

        Context 'Input' {
            $MandatoryParams = @('Uri', 'Credential')
            $NonMandatoryParams = @('Passthru')

            foreach ($MandatoryParam in $MandatoryParams) {
                It "$($MandatoryParam) is mandatory" {
                    (Get-Command Connect-SL1).Parameters[$MandatoryParam].Attributes.mandatory | Should -BeTrue
                }
            }

            foreach ($NonMandatoryParam in $NonMandatoryParams) {
                It "$($NonMandatoryParam) parameter is mandatory" {
                    (get-command Connect-SL1).Parameters[$NonMandatoryParam].Attributes.mandatory | Should -BeFalse
                }
            }
        }
        Context 'Execution' {
            It 'does not output anything' {
                Connect-SL1 -Uri $uri -Credential $Cred | should be $null
            }
            It 'outputs the connection information with passthru' {
                Connect-SL1 -Uri $uri -Credential $Cred -Passthru | should not be $null
            }
        }
    }
}
<#
$moduleRoot = (Resolve-Path "$PSScriptRoot\..\..").Path
$manifest = ((Get-Content "$moduleRoot\ScienceLogic_SL1.psd1") -join "`n") | Invoke-Expression
Describe "Testing Connect-SL1" {
    InModuleScope ScienceLogic_SL1 {
        mock function Invoke-SL1Request {
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
#>