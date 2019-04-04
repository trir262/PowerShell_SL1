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
            $MandatoryParams = @{param='Uri'},@{param='Credential'}
            $NonMandatoryParams = @{param='Passthru'}
            $MandatoryParams | Out-Null
            $NonMandatoryParams | Out-Null
            It "Parameter <param> is mandatory" -TestCases $MandatoryParams {
                param($Param)
                (Get-Command Connect-SL1).Parameters[$Param].Attributes.mandatory | Should -Be $True
            }

            It "Parameter <param> parameter is not mandatory" -TestCases $NonMandatoryParams {
                param($Param)
                (get-command Connect-SL1).Parameters[$Param].Attributes.mandatory | Should -BeFalse
            }
        }
        Context 'Function Execution with Mandatory parameters' {
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
        }
        Context 'Function Execution With Passthru parameter' {
            BeforeAll {
                Mock Invoke-SL1Request {
                    return New-Object -TypeName psobject -Property @{StatusCode = 200}
                }
            }
            It 'Outputs the connection information with passthru' {
                Connect-SL1 -Uri $uri -Credential $Cred -Passthru | Should -Not -Be $Null
            }
            It "Calls Invoke-SL1Request 1 time" {
                Assert-MockCalled -CommandName Invoke-SL1Request -Exactly 1
            }

    }
    }
}
