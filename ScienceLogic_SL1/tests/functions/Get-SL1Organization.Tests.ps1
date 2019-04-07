Write-PSFMessage -Level Critical -Message "Reimporting ScienceLogic_SL1 module"
Remove-Module ScienceLogic_SL1 -ErrorAction Ignore
Import-Module "$PSScriptRoot\..\..\ScienceLogic_SL1.psd1"
$global:JSONs = . "$PSScriptRoot\JsonTemplates.ps1"
InModuleScope 'ScienceLogic_SL1' {
    Describe 'Get-SL1Organization' {
        BeforeAll {
            $Url = 'https://www.someSL1url.com'
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
                    Content = $global:JSONs['Organization1ID']
                } 
            } -ParameterFilter { $Uri -and $Uri -match '/api/organization/\d+$' }
            
            #Mock for /api/organization?limit
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = ($global:JSONs['Organization1Query'])
                }
            } -ParameterFilter { $Uri -and $Uri -eq "$($url)/api/organization?filter.0.name.contains=customer%20X&limit=100"}

            #Mock for /api/organization? contains=customerX&extended_fetch=1
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['Organization1Xtend']
                } # /api/organization?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1
            } -ParameterFilter { $Uri -and $Uri -eq "$($Url)/api/organization?filter.0.name.contains=customer%20X&limit=100&hide_filterinfo=1&extended_fetch=1"}

            #Mock for /api/organization?limit for two organizations
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['Organization2Query']
                }
            } -ParameterFilter { $Uri -and $Uri -eq "$($url)/api/organization?filter.0.name.contains=customer&limit=100"}

            #Mock for /api/organization? contains=customerX&extended_fetch=1 for two organizations
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['Organization2Xtend']
                } # /api/organization?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1
            } -ParameterFilter { $Uri -and $Uri -eq "$($Url)/api/organization?filter.0.name.contains=customer&limit=100&hide_filterinfo=1&extended_fetch=1"}

            Connect-SL1 -Uri $Url -Credential $GoodCred
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
                (Get-SL1Organization -Filter 'filter.0.name.contains=customer%20X').Company | Should -be 'customer X'
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 2 -Scope It
            }

            It 'Parameter Filter returns 2 Organizations' {
                (Get-SL1Organization -Filter 'filter.0.name.contains=customer').Count | Should -be 2
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 2 -Scope It
            }
            
        }
    }
}
