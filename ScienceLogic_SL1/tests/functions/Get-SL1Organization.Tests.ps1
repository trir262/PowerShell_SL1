Write-PSFMessage -Level Critical -Message "Reimporting ScienceLogic_SL1 module"
Remove-Module ScienceLogic_SL1 -ErrorAction Ignore
Import-Module "$PSScriptRoot\..\..\ScienceLogic_SL1.psd1"
InModuleScope 'ScienceLogic_SL1' {
    Describe 'Get-SL1Organization' {
        BeforeAll {
            $Uri = 'https://www.someSL1url.com'
            $BadCred = [pscredential]::new('Badcred', (ConvertTo-SecureString -AsPlainText -Force -String 'badpwd'))
            $GoodCred = [pscredential]::new('goodcred', (ConvertTo-SecureString -AsPlainText -Force -String 'goodpwd') )
            # Mock Connect-SL1
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK 
                } 
            } -ParameterFilter { $Uri -match '/api/account/_self'}

            #Mock for /api/organization/<id>
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = '{"some":"else"}' 
                } 
            } -ParameterFilter { $Uri -and $Uri -match '/api/organization/\d+$' }
            
            #Mock for /api/organization?limit
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = '{"total_matched":"1"}' 
                }
            } -ParameterFilter { $Uri -and $Uri -match '/api/organization\?'}

            #Mock for /api/organization? contains=customerX&extended_fetch=1
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = (ConvertTo-Json @{'/api/organization/1'=[pscustomobject]@{name='customerX'}}) 
                } 
            } -ParameterFilter { $Uri -and $Uri -match '/api/organization\?.+contains=customerX&?.+?\&extended_fetch=1'}

            #Mock for /api/organization? contains=customer&extended_fetch=1
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = (
                        @{'/api/organization/1'=[pscustomobject]@{name='customerX'}
                        '/api/organization/2'=[pscustomobject]@{name='customerY'} } | ConvertTo-Json
                    ) 
                } 
            } -ParameterFilter { $Uri -and $Uri -match '/api/organization\?.+contains=customer&.+?\&extended_fetch=1'}

            Connect-SL1 -Uri $Uri -Credential $GoodCred
            $Cmd = 'Get-SL1Organization'
        }

        Context 'Input Validation' {
            $MandatoryParams = @{param='Id'}
            $NonMandatoryParams = @{param='Limit'},@{param='Filter'}
            It "Parameter <param> is mandatory" -TestCases $MandatoryParams {
                param($Param)
                (Get-Command $Cmd).Parameters[$Param].Attributes.mandatory | Should -Be $True
            }

            It "Parameter <param> parameter is not mandatory" -TestCases $NonMandatoryParams {
                param($Param)
                (get-command $Cmd).Parameters[$Param].Attributes.mandatory | Should -Be $False
            }
        }

        Context 'Testing Id Parameter' {
            It 'Parameter Id is higher than 0 returns Organization' {
                Get-SL1Organization -Id 1 | should -not -be $null
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 1 -Scope It
            }

            It 'Parameter Id is below 0 throws error' {
                { Get-SL1Organization -Id -5} | Should -Throw
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 0 -Scope It
            }
        }

        Context 'Testing Filter Parameter' {
            It 'Parameter Filter is blank throws error' {
                { Get-SL1Organization -Filter '' } | Should -Throw
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 0 -Scope It
            }

            It 'Parameter Filter returns 1 Organization' {
                (Get-SL1Organization -Filter 'filter.0.name.contains=customerX').name | Should -be 'customerX'
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 2 -Scope It
            }

            It 'Parameter Filter returns 2 Organizations' {
                (Get-SL1Organization -Filter 'filter.0.name.contains=customer').Count | Should -be 2
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 2 -Scope It
            }
            
        }
    }
}
