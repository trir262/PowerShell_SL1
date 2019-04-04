Write-PSFMessage -Level Critical -Message "Reimporting ScienceLogic_SL1 module"
Remove-Module ScienceLogic_SL1 -ErrorAction Ignore
Import-Module "$PSScriptRoot\..\..\ScienceLogic_SL1.psd1"
InModuleScope 'ScienceLogic_SL1' {
    Describe 'Connect-SL1' {
        BeforeAll {
            $Uri = 'https://www.someSL1url.com'
            $BadCred = [pscredential]::new('Badcred', (ConvertTo-SecureString -AsPlainText -Force -String 'badpwd'))
            $GoodCred = [pscredential]::new('goodcred', (ConvertTo-SecureString -AsPlainText -Force -String 'goodpwd') )
            Mock Invoke-SL1Request {
                return New-Object -TypeName psobject -Property @{StatusCode = [System.Net.HttpStatusCode]::OK}
            }
        }

        Context 'Input Validation' {
            $MandatoryParams = @{param='Uri'},@{param='Credential'}
            $NonMandatoryParams = @{param='Passthru'}
            It "Parameter <param> is mandatory" -TestCases $MandatoryParams {
                param($Param)
                (Get-Command Connect-SL1).Parameters[$Param].Attributes.mandatory | Should -Be $True
            }

            It "Parameter <param> parameter is not mandatory" -TestCases $NonMandatoryParams {
                param($Param)
                (get-command Connect-SL1).Parameters[$Param].Attributes.mandatory | Should -BeFalse
            }
        }

        Context 'Testing with wrong credential' {
            BeforeAll {
                Mock Invoke-SL1Request {
                    return New-Object -TypeName psobject -Property @{StatusCode = [System.Net.HttpStatusCode]::Unauthorized}
                }
            }
            It 'Should throw' {
                { Connect-SL1 -Uri $uri -Credential $BadCred } | should -Throw
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 1 -Scope It
            }
        }

        Context 'Function Execution with Mandatory parameters' {
            It 'Does not output anything' {
                Connect-SL1 -Uri $uri -Credential $GoodCred | should -be $null
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 1 -Scope It
            }

            It "Calls Invoke-SL1Request 1 time" {
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 1
            }
        }

        Context 'Function Execution With Passthru parameter' {
            It 'Outputs the connection information with passthru' {
                Connect-SL1 -Uri $uri -Credential $GoodCred -Passthru | Should -Not -Be $Null
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 1 -Scope It # Choose this or the next
            }
            It "Calls Invoke-SL1Request 1 time" {
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 1 # choose this or the previous
            }
        }
    }
}
