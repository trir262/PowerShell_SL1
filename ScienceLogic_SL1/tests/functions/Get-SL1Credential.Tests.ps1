Write-PSFMessage -Level Critical -Message "Reimporting ScienceLogic_SL1 module"
Remove-Module ScienceLogic_SL1 -ErrorAction Ignore
Import-Module "$PSScriptRoot\..\..\ScienceLogic_SL1.psd1"
$global:JSONs = . "$PSScriptRoot\JsonTemplates.ps1"
InModuleScope 'ScienceLogic_SL1' {
    Describe 'Get-SL1Credential' {
        BeforeAll {
            $Url = 'https://www.someSL1url.com'
            $BadCred = [pscredential]::new('Badcred', (ConvertTo-SecureString -AsPlainText -Force -String 'badpwd'))
            $GoodCred = [pscredential]::new('goodcred', (ConvertTo-SecureString -AsPlainText -Force -String 'goodpwd') )
            $CredentialFilter = 'filter.0._id.eq='
            $CredIDs = @{basic=40;db=16;ldap=90;powershell=42;snmp=29;soap=3;ssh=229}
            $Limit=100
            # Mock Connect-SL1
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK 
                }
            } -ParameterFilter { $Uri -match '/api/account/_self'}

            #Mock for /api/credential/basic/<id>
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['credential_basicID']
                } 
            } -ParameterFilter { $Uri -and $Uri -match '/api/credential/basic/\d+$' }
            
            #Mock for /api/credential/db/<id>
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['credential_dbID']
                } 
            } -ParameterFilter { $Uri -and $Uri -match '/api/credential/db/\d+$' }
            
            #Mock for /api/credential/ldap/<id>
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['credential_ldapID']
                } 
            } -ParameterFilter { $Uri -and $Uri -match '/api/credential/ldap/\d+$' }
            
            #Mock for /api/credential/powershell/<id>
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['credential_powershellID']
                } 
            } -ParameterFilter { $Uri -and $Uri -match '/api/credential/powershell/\d+$' }
            
            #Mock for /api/credential/snmp/<id>
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['credential_snmpID']
                } 
            } -ParameterFilter { $Uri -and $Uri -match '/api/credential/snmp/\d+$' }
            
            #Mock for /api/credential/soap/<id>
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['credential_soapID']
                } 
            } -ParameterFilter { $Uri -and $Uri -match '/api/credential/soap/\d+$' }
            
            #Mock for /api/credential/ssh/<id>
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['credential_sshID']
                } 
            } -ParameterFilter { $Uri -and $Uri -match '/api/credential/ssh/\d+$' }
            
            #Mock for /api/credential/basic?limit
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = ($global:JSONs['credential_basicQuery'])
                }
            } -ParameterFilter { $Uri -and $Uri -ieq "$($url)/api/credential/basic?$($CredentialFilter)$($CredIDs['basic'])&limit=$($Limit)"}

            #Mock for /api/credential/db?limit
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = ($global:JSONs['credential_dbQuery'])
                }
            } -ParameterFilter { $Uri -and $Uri -ieq "$($url)/api/credential/db?$($CredentialFilter)$($CredIDs['db'])&limit=$($Limit)"}

            #Mock for /api/credential/ldap?limit
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = ($global:JSONs['credential_ldapQuery'])
                }
            } -ParameterFilter { $Uri -and $Uri -ieq "$($url)/api/credential/ldap?$($CredentialFilter)$($CredIDs['ldap'])&limit=$($Limit)"}

            #Mock for /api/credential/powershell?limit
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = ($global:JSONs['credential_powershellQuery'])
                }
            } -ParameterFilter { $Uri -and $Uri -ieq "$($url)/api/credential/powershell?$($CredentialFilter)$($CredIDs['powershell'])&limit=$($Limit)"}

            #Mock for /api/credential/snmp?limit
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = ($global:JSONs['credential_snmpQuery'])
                }
            } -ParameterFilter { $Uri -and $Uri -ieq "$($url)/api/credential/snmp?$($CredentialFilter)$($CredIDs['snmp'])&limit=$($Limit)"}

            #Mock for /api/credential/soap?limit
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = ($global:JSONs['credential_soapQuery'])
                }
            } -ParameterFilter { $Uri -and $Uri -ieq "$($url)/api/credential/soap?$($CredentialFilter)$($CredIDs['soap'])&limit=$($Limit)"}

            #Mock for /api/credential/ssh?limit
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = ($global:JSONs['credential_sshQuery'])
                }
            } -ParameterFilter { $Uri -and $Uri -ieq "$($url)/api/credential/ssh?$($CredentialFilter)$($CredIDs['ssh'])&limit=$($Limit)"}

            #Mock for /api/credential/basic? contains=customerX&extended_fetch=1
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['credential_basicxtend']
                } # /api/organization?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1
            } -ParameterFilter { $Uri -and $Uri -ieq "$($Url)/api/credential/basic?$($CredentialFilter)$($CredIDs['basic'])&limit=$($limit)&hide_filterinfo=1&extended_fetch=1"}

            #Mock for /api/credential/db? contains=customerX&extended_fetch=1
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['credential_dbxtend']
                } 
            } -ParameterFilter { $Uri -and $Uri -ieq "$($Url)/api/credential/db?$($CredentialFilter)$($CredIDs['db'])&limit=$($limit)&hide_filterinfo=1&extended_fetch=1"}

            #Mock for /api/credential/ldap? contains=customerX&extended_fetch=1
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['credential_ldapxtend']
                } # /api/organization?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1
            } -ParameterFilter { $Uri -and $Uri -ieq "$($Url)/api/credential/ldap?$($CredentialFilter)$($CredIDs['ldap'])&limit=$($limit)&hide_filterinfo=1&extended_fetch=1"}

            #Mock for /api/credential/powershell? contains=customerX&extended_fetch=1
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['credential_powershellxtend']
                } # /api/organization?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1
            } -ParameterFilter { $Uri -and $Uri -ieq "$($Url)/api/credential/powershell?$($CredentialFilter)$($CredIDs['powershell'])&limit=$($limit)&hide_filterinfo=1&extended_fetch=1"}

            #Mock for /api/credential/snmp? contains=customerX&extended_fetch=1
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['credential_snmpxtend']
                } # /api/organization?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1
            } -ParameterFilter { $Uri -and $Uri -ieq "$($Url)/api/credential/snmp?$($CredentialFilter)$($CredIDs['snmp'])&limit=$($limit)&hide_filterinfo=1&extended_fetch=1"}

            #Mock for /api/credential/soap? contains=customerX&extended_fetch=1
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['credential_soapxtend']
                } # /api/organization?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1
            } -ParameterFilter { $Uri -and $Uri -ieq "$($Url)/api/credential/soap?$($CredentialFilter)$($CredIDs['soap'])&limit=$($limit)&hide_filterinfo=1&extended_fetch=1"}

            #Mock for /api/credential/ssh? contains=customerX&extended_fetch=1
            Mock Invoke-SL1Request { 
                return New-Object -TypeName psobject -Property @{ 
                    StatusCode = [System.Net.HttpStatusCode]::OK
                    Content = $global:JSONs['credential_sshxtend']
                } # /api/organization?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1
            } -ParameterFilter { $Uri -and $Uri -ieq "$($Url)/api/credential/ssh?$($CredentialFilter)$($CredIDs['ssh'])&limit=$($limit)&hide_filterinfo=1&extended_fetch=1"}

            Connect-SL1 -Uri $Url -Credential $GoodCred
            $Cmd = 'Get-SL1Credential'
        }

        Context 'Input Validation' {
            $MandatoryParams = @{param='Type'}
            $NonMandatoryParams = @{param='Id'},@{param='Limit'},@{param='Filter'}

            It "Parameter <param> parameter is not mandatory" -TestCases $MandatoryParams {
                param($Param)
                (get-command $Cmd).Parameters[$Param].Attributes.mandatory | Should -Be $true
            }

            It "Parameter <param> parameter is not mandatory" -TestCases $NonMandatoryParams {
                param($Param)
                (get-command $Cmd).Parameters[$Param].Attributes.mandatory | Should -Be $False
            }
        }

        Context 'Testing basic credential type with Id Parameter' {
            It 'Parameter Id is higher than 0 returns Credential' {
                Get-SL1Credential -Type basic -Id $CredIDs['basic'] | should -not -be $null
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 1 -Scope It
            }

            It 'Parameter Id is below 0 throws error' {
                { Get-SL1Credential -Type basic -Id (-$CredIDs['basic']) } | Should -Throw
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 0 -Scope It
            }
        }

        Context 'Testing basic credential type with Filter Parameter' {
            It 'Parameter Filter returns 1 Credential' {
                (Get-SL1Credential -Type basic -Filter "$($CredentialFilter)$($CredIDs['basic'])").cred_name | Should -be 'Windows WMI - Example'
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 2 -Scope It
            }
        } 

        Context 'Testing db credential type with Id Parameter' {
            It 'Parameter Id is higher than 0 returns Credential' {
                Get-SL1Credential -Type db -Id $CredIDs['db'] | should -not -be $null
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 1 -Scope It
            }

            It 'Parameter Id is below 0 throws error' {
                { Get-SL1Credential -Type db -Id (-$CredIDs['db'])} | Should -Throw
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 0 -Scope It
            }
        }

        Context 'Testing db credential type with Filter Parameter' {
            It 'Parameter Filter returns 1 Credential' {
                (Get-SL1Credential -Type db -Filter "$($CredentialFilter)$($CredIDs['db'])").cred_name | Should -be 'EM7 Central Database'
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 2 -Scope It
            }
        } 

        Context 'Testing ldap credential type with Id Parameter' {
            It 'Parameter Id is higher than 0 returns Credential' {
                Get-SL1Credential -Type ldap -Id $CredIDs['ldap'] | should -not -be $null
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 1 -Scope It
            }

            It 'Parameter Id is below 0 throws error' {
                { Get-SL1Credential -Type basic -Id -$CredIDs['ldap']} | Should -Throw
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 0 -Scope It
            }
        }

        Context 'Testing ldap credential type with Filter Parameter' {
            It 'Parameter Filter returns 1 Credential' {
                (Get-SL1Credential -Type ldap -Filter "$($CredentialFilter)$($CredIDs['ldap'])").cred_name | Should -be 'LDAP Bind Example'
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 2 -Scope It
            }
        } 

        Context 'Testing powershell credential type with Id Parameter' {
            It 'Parameter Id is higher than 0 returns Credential' {
                Get-SL1Credential -Type powershell -Id $CredIDs['powershell'] | should -not -be $null
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 1 -Scope It
            }

            It 'Parameter Id is below 0 throws error' {
                { Get-SL1Credential -Type powershell -Id -$CredIDs['powershell']} | Should -Throw
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 0 -Scope It
            }
        }

        Context 'Testing powershell credential type with Filter Parameter' {
            It 'Parameter Filter returns 1 Credential' {
                (Get-SL1Credential -Type powershell -Filter "$($CredentialFilter)$($CredIDs['powershell'])").cred_name | Should -be 'Windows PowerShell - Example'
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 2 -Scope It
            }
        } 

        Context 'Testing snmp credential type with Id Parameter' {
            It 'Parameter Id is higher than 0 returns Credential' {
                Get-SL1Credential -Type snmp -Id $CredIDs['snmp'] | should -not -be $null
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 1 -Scope It
            }

            It 'Parameter Id is below 0 throws error' {
                { Get-SL1Credential -Type snmp -Id -$CredIDs['snmp']} | Should -Throw
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 0 -Scope It
            }
        }

        Context 'Testing snmp credential type with Filter Parameter' {
            It 'Parameter Filter returns 1 Credential' {
                (Get-SL1Credential -Type snmp -Filter "$($CredentialFilter)$($CredIDs['snmp'])").cred_name | Should -be 'Cisco SNMPv3 - Example'
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 2 -Scope It
            }
        } 

        Context 'Testing soap credential type with Id Parameter' {
            It 'Parameter Id is higher than 0 returns Credential' {
                Get-SL1Credential -Type soap -Id $CredIDs['soap'] | should -not -be $null
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 1 -Scope It
            }

            It 'Parameter Id is below 0 throws error' {
                { Get-SL1Credential -Type soap -Id -$CredIDs['soap']} | Should -Throw
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 0 -Scope It
            }
        }

         Context 'Testing soap credential type with Filter Parameter' {
            It 'Parameter Filter returns 1 Credential' {
                (Get-SL1Credential -Type soap -Filter "$($CredentialFilter)$($CredIDs['soap'])").cred_name | Should -be 'VMware Server Example'
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 2 -Scope It
            }
        } 

        Context 'Testing ssh credential type with Id Parameter' {
            It 'Parameter Id is higher than 0 returns Credential' {
                Get-SL1Credential -Type ssh -Id $CredIDs['ssh'] | should -not -be $null
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 1 -Scope It
            }

            It 'Parameter Id is below 0 throws error' {
                { Get-SL1Credential -Type ssh -Id -$CredIDs['ssh']} | Should -Throw
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 0 -Scope It
            }
        }

         Context 'Testing ssh credential type with Filter Parameter' {
            It 'Parameter Filter returns 1 Credential' {
                (Get-SL1Credential -Type ssh -Filter "$($CredentialFilter)$($CredIDs['ssh'])").cred_name | Should -be 'Linux SSH'
                Assert-MockCalled -CommandName Invoke-SL1Request -Times 2 -Scope It
            }
        } 

    }
}
