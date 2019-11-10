#Write-PSFMessage -Level Critical -Message "Reimporting ScienceLogic_SL1 module"
#Remove-Module ScienceLogic_SL1 -ErrorAction Ignore
#Import-Module "$PSScriptRoot\..\..\ScienceLogic_SL1.psd1"
$global:JSONs = . "$PSScriptRoot\JsonTemplates.ps1"
InModuleScope 'ScienceLogic_SL1' {
    Describe 'Get-SL1Device' {
        BeforeAll {
            $Url = 'https://www.someSL1url.com'
            $BadCred = [pscredential]::new('Badcred', (ConvertTo-SecureString -AsPlainText -Force -String 'badpwd'))
            $GoodCred = [pscredential]::new('goodcred', (ConvertTo-SecureString -AsPlainText -Force -String 'goodpwd') )
            $Filter = 'filter.0._id.eq=1'
            $Limit=100
            # Mock Connect-SL1
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK 
                } 
            } -ParameterFilter { $Uri -match '/api/account/_self'}

            #Mock for /api/device/<id>
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['deviceID']
                } 
            } -ParameterFilter { $Uri -and $Uri -match '/api/device/\d+$' }
            
            #Mock for /api/device?limit
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = ($global:JSONs['deviceQuery'])
                }
            } -ParameterFilter { $Uri -and $Uri -eq "$($url)/api/device?$($Filter)&limit=$($Limit)"}

            #Mock for /api/device? contains=customerX&extended_fetch=1
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['devicextend']
                } # /api/organization?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1
            } -ParameterFilter { $Uri -and $Uri -eq "$($Url)/api/device?$($Filter)&limit=$($limit)&hide_filterinfo=1&extended_fetch=1"}

            #Mock for /api/device? contains=customerX&extended_fetch=1
            Mock Get-SL1Organization { 
                return ( $global:JSONs['organization1ID'] | convertfrom-json )
            }

            Mock Get-OrganizationForDevice {
                return ( '{"URI":"\/api\/organization\/1","company":"ScienceLogic"}' | ConvertFrom-Json )
            }

            Connect-SL1 -Uri $Url -Credential $GoodCred
            $Cmd = 'Get-SL1Device'
        }

        Context 'Input Validation' {
            $NonMandatoryParams = @{param='Id'},@{param='Limit'},@{param='Filter'}

            It "Parameter <param> parameter is not mandatory" -TestCases $NonMandatoryParams {
                param($Param)
                (get-command $Cmd).Parameters[$Param].Attributes.mandatory | Should -Be $False
            }
        }

        Context 'Testing Id Parameter' {
            It 'Parameter Id is higher than 0 returns device' {
                Get-SL1Device -Id 2 | should -not -be $null
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 1 -Scope It
            }

            It 'Parameter Id is below 0 throws error' {
                { Get-SL1Device -Id -5} | Should -Throw
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 0 -Scope It
            }
        }

        Context 'Testing Filter Parameter' {
            It 'Parameter Filter returns 1 Device' {
                (Get-SL1Device -Filter $Filter).name | Should -be 'device'
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 2 -Scope It
            }
        }
    }
}
