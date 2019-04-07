$Entities = @{
    'applianceID' = (Get-Content .\json\applianceID.json)
    'applianceQuery' = (Get-Content .\json\applianceQuery.json)

    'collector_groupID' = (Get-Content .\json\collector_groupID.json)
    'collector_groupQuery' = (Get-Content .\json\collector_groupQuery.json)

    'credential_basicID' = (Get-Content .\json\credential_basicID.json)
    'credential_basicQuery' = (Get-Content .\json\credential_basicQuery.json)

    'credential_dbID' = (Get-Content .\json\credential_dbID.json)
    'credential_dbQuery' = (Get-Content .\json\credential_dbQuery.json)

    'credential_ldapID' = (Get-Content .\json\credential_ldapID.json)
    'credential_ldapQuery' = (Get-Content .\json\credential_ldapQuery.json)

    'credential_powershellID' = (Get-Content .\json\credential_powershellID.json)
    'credential_powershellQuery' = (Get-Content .\json\credential_powershellQuery.json)

    'credential_snmpID' = (Get-Content .\json\credential_snmpID.json)
    'credential_snmpQuery' = (Get-Content .\json\credential_snmpQuery.json)

    'credential_soapID' = (Get-Content .\json\credential_soapID.json)
    'credential_soapQuery' = (Get-Content .\json\credential_soapQuery.json)

    'credential_sshID' = (Get-Content .\json\credential_sshID.json)
    'credential_sshQuery' = (Get-Content .\json\credential_sshQuery.json)

    'device_groupID' = (Get-Content .\json\device_groupID.json)
    'device_groupQuery' = (Get-Content .\json\device_groupQuery.json)

    'device_templateID' = (Get-Content .\json\device_templateID.json)
    'device_templateQuery' = (Get-Content .\json\device_templateQuery.json)

    'DeviceID'= (Get-Content .\JSON\deviceid.json)
    'DeviceQuery' = (Get-Content .\json\DeviceQuery.json)

    'discovery_sessionID' = (Get-Content .\json\discovery_sessionID.json)
    'discovery_sessionQuery' = (Get-Content .\json\discovery_sessionQuery.json)

    'OrganizationID' = (Get-Content .\json\OrganizationID.json)
    'organization_Query' = (Get-Content .\json\organizationQuery.json)
}

foreach ($EntityKey in $Entities.Keys) {
    try {
        $Entities[$EntityKey] | ConvertFrom-Json | out-null
    } catch {
        Write-Verbose $($EntityKey)
    }
}

<#
cls
$Entity = 'discovery_session'
#"'$($Entity)_ID' = '$(Invoke-RestMethod -Method Get -Uri "https://monitoring.realdolmencloud.com/api/$($Entity)/492" -Credential $Cred | ConvertTo-Json -Compress)'"
#"'$($Entity)_Query' = '$(Invoke-RestMethod -Method Get -Uri "https://monitoring.realdolmencloud.com/api/$($Entity)?limit=2&filter._id.eq=492" -Credential $Cred | ConvertTo-Json -Compress)'"

#>