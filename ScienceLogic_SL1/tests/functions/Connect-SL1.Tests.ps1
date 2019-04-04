Write-PSFMessage -Level Critical -Message "Reimporting ScienceLogic_SL1 module"
Remove-Module ScienceLogic_SL1 -ErrorAction Ignore
Import-Module "$PSScriptRoot\..\..\ScienceLogic_SL1.psd1"
InModuleScope 'ScienceLogic_SL1' {
    Describe 'Connect-SL1' {
        BeforeAll {
            $Uri = 'https://www.google.be'
            $Cred = [pscredential]::new('user', (ConvertTo-SecureString -AsPlainText -Force -String 'pwd') )
            $uri | Out-Null
            $Cred | Out-Null
        }

        Context 'Input Validation' {
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
        Context 'Function Execution' {
            BeforeAll {
                Mock Invoke-SL1Request {
                    return New-Object -TypeName psobject -Property @{StatusCode = 200}
                }
            }
            It 'Does not output anything' {
                Connect-SL1 -Uri $uri -Credential $Cred | should -be $null
            }

            It "Calls Invoke-SL1Request 1 time" {
                Assert-MockCalled -CommandName Invoke-SL1Request -Exactly 1
            }

            It 'Outputs the connection information with passthru' {
                Connect-SL1 -Uri $uri -Credential $Cred -Passthru | Should -Not -Be $Null
            }
            It "Calls Invoke-SL1Request 2 times" {
                Assert-MockCalled -CommandName Invoke-SL1Request -Exactly 2
            }

    }
    }
}
