Remove-Module ScienceLogic_SL1 -ErrorAction Ignore
Import-Module "$PSScriptRoot\..\..\ScienceLogic_SL1.psd1"
$Global:JSONs = . "$($PSScriptRoot)\JsonTemplates.ps1"
InModuleScope 'ScienceLogic_SL1' {
    $TestFunction = 'Add-SL1Alert'
    Describe $TestFunction {
        BeforeAll {
            $ErrorActionPreference='Stop'
            $Url = 'https://www.someSL1url.com'
            $GoodCred = [pscredential]::new('goodcred', (ConvertTo-SecureString -AsPlainText -Force -String 'goodpwd') )

            # Mock Connect-SL1
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK 
                } 
            } -ParameterFilter { $Uri -match '/api/account/_self'}
            Connect-SL1 -URI $Url -Credential $GoodCred

            #Mock Invoke-SL1Request with POST
            Mock Invoke-SL1Request {
                return New-Object -TypeName psobject -Property @{
                    StatusCode= [System.Net.HttpStatusCode]::Created
                    Content = ($global:jsons['alertresponsewithdevice'])
                }
            } -ParameterFilter { $uri -eq "$($URL)/api/alert" -and $Body -eq ($global:jsons['alertrequestwithdevice'])}
            Mock Get-SL1Device {
                return [pscustomobject]@{pstypename='device';uri='/api/device/2';id='2'}
            }
            $GoodTypes = @{Type='device'},@{Type='organization'}
            $BadTypes = @{Type='device_group'},@{Type='device_template'}
        }
        
        Context 'Input Validation' {
            It 'Function Exists' {
                { Get-Command -Name $TestFunction -ErrorAction Stop} | should -Not -Throw
            }

            $MandatoryParams = @{param='Message'}
            $NonMandatoryParams = @{param='Passthru'},@{param='Entity'}
            It "Parameter <param> is mandatory" -TestCases $MandatoryParams {
                param($Param)
                (Get-Command $TestFunction).Parameters[$Param].Attributes.mandatory | Should -BeTrue
            }

            It "Parameter <param> parameter is not mandatory" -TestCases $NonMandatoryParams {
                param($Param)
                (get-command $TestFunction).Parameters[$Param].Attributes.mandatory | Should -BeFalse
            }
        }
        Context 'Function working' {
            It 'Type "<Type>" works ok' -TestCases $GoodTypes {
                param ($Type)
                { (([PSCustomObject]@{pstypename = $Type;URI='';ID=''}) | Add-SL1Alert -message "testmessage" ) } | should -Not -Throw
            }

            It 'Type "<Type>" results in an error' -TestCases $BadTypes {
                param ($Type)
                { (([PSCustomObject]@{pstypename = $Type;URI='';ID=''}) | Add-SL1Alert -Message 'testmessage') } | Should -Throw
            }

            It 'Returns a proper JSON' {
                (Get-SL1Device -Id 2 | Add-SL1Alert -Message 'testmessage').message_time | Should -Be '1555241658'
            }
        }
    }
}