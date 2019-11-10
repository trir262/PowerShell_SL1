#Write-PSFMessage -Level Critical -Message "Reimporting ScienceLogic_SL1 module"
#Remove-Module ScienceLogic_SL1 -ErrorAction Ignore
#Import-Module "$PSScriptRoot\..\..\ScienceLogic_SL1.psd1"
$global:JSONs = . "$PSScriptRoot\JsonTemplates.ps1"
InModuleScope 'ScienceLogic_SL1' {
    Describe 'Get-SL1DeviceGroup' {
        BeforeAll {
            $Url = 'https://www.someSL1url.com'
            $BadCred = [pscredential]::new('Badcred', (ConvertTo-SecureString -AsPlainText -Force -String 'badpwd'))
            $GoodCred = [pscredential]::new('goodcred', (ConvertTo-SecureString -AsPlainText -Force -String 'goodpwd') )
            $Filter = 'filter.0._id.eq=17'
            $Limit=100
            # Mock Connect-SL1
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK 
                } 
            } -ParameterFilter { $Uri -match '/api/account/_self'}

            #Mock for /api/appliance/<id>
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['device_groupID']
                } 
            } -ParameterFilter { $Uri -and $Uri -match '/api/device_group/\d+$' }
            
            #Mock for /api/appliance?limit
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = ($global:JSONs['device_groupquery'])
                }
            } -ParameterFilter { $Uri -and $Uri -eq "$($url)/api/device_group?$($Filter)&limit=$($Limit)"}

            #Mock for /api/organization? contains=customerX&extended_fetch=1
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['device_groupxtend']
                } # /api/organization?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1
            } -ParameterFilter { $Uri -and $Uri -eq "$($Url)/api/device_group?$($Filter)&limit=$($limit)&hide_filterinfo=1&extended_fetch=1"}

            Connect-SL1 -Uri $Url -Credential $GoodCred
            $Cmd = 'Get-SL1DeviceGroup'
        }

        Context 'Input Validation' {
            $NonMandatoryParams = @{param='Id'},@{param='Limit'},@{param='Filter'}

            It "Parameter <param> parameter is not mandatory" -TestCases $NonMandatoryParams {
                param($Param)
                (get-command $Cmd).Parameters[$Param].Attributes.mandatory | Should -Be $False
            }
        }

        Context 'Testing Id Parameter' {
            It 'Parameter Id is higher than 0 returns Device Group' {
                Get-SL1DeviceGroup -Id 1 | should -not -be $null
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 1 -Scope It
            }

            It 'Parameter Id is below 0 throws error' {
                { Get-SL1DeviceGroup -Id -5} | Should -Throw
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 0 -Scope It
            }
        }

        Context 'Testing Filter Parameter' {
            It 'Parameter Filter returns 1 Device Group' {
                (Get-SL1DeviceGroup -Filter $Filter).name | Should -be 'devicegroup'
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 2 -Scope It
            }
        }
    }
}
