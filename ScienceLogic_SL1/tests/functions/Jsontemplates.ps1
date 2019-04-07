$Entities = @{
    'applianceID' = (Get-Content "$($PSScriptRoot)\json\applianceID.json")
    'applianceQuery' = (Get-Content "$($PSScriptRoot)\json\applianceQuery.json")

    'collector_groupID' = (Get-Content "$($PSScriptRoot)\json\collector_groupID.json")
    'collector_groupQuery' = (Get-Content "$($PSScriptRoot)\json\collector_groupQuery.json")

    'credential_basicID' = (Get-Content "$($PSScriptRoot)\json\credential_basicID.json")
    'credential_basicQuery' = (Get-Content "$($PSScriptRoot)\json\credential_basicQuery.json")

    'credential_dbID' = (Get-Content "$($PSScriptRoot)\json\credential_dbID.json")
    'credential_dbQuery' = (Get-Content "$($PSScriptRoot)\json\credential_dbQuery.json")

    'credential_ldapID' = (Get-Content "$($PSScriptRoot)\json\credential_ldapID.json")
    'credential_ldapQuery' = (Get-Content "$($PSScriptRoot)\json\credential_ldapQuery.json")

    'credential_powershellID' = (Get-Content "$($PSScriptRoot)\json\credential_powershellID.json")
    'credential_powershellQuery' = (Get-Content "$($PSScriptRoot)\json\credential_powershellQuery.json")

    'credential_snmpID' = (Get-Content "$($PSScriptRoot)\json\credential_snmpID.json")
    'credential_snmpQuery' = (Get-Content "$($PSScriptRoot)\json\credential_snmpQuery.json")

    'credential_soapID' = (Get-Content "$($PSScriptRoot)\json\credential_soapID.json")
    'credential_soapQuery' = (Get-Content "$($PSScriptRoot)\json\credential_soapQuery.json")

    'credential_sshID' = (Get-Content "$($PSScriptRoot)\json\credential_sshID.json")
    'credential_sshQuery' = (Get-Content "$($PSScriptRoot)\json\credential_sshQuery.json")

    'device_groupID' = (Get-Content "$($PSScriptRoot)\json\device_groupID.json")
    'device_groupQuery' = (Get-Content "$($PSScriptRoot)\json\device_groupQuery.json")

    'device_templateID' = (Get-Content "$($PSScriptRoot)\json\device_templateID.json")
    'device_templateQuery' = (Get-Content "$($PSScriptRoot)\json\device_templateQuery.json")
    'device_templateXtend' = (Get-Content "$($PSScriptRoot)\json\device_templateXtend.json")

    'DeviceID'= (Get-Content "$($PSScriptRoot)\json\deviceid.json")
    'DeviceQuery' = (Get-Content "$($PSScriptRoot)\json\DeviceQuery.json")

    'discovery_sessionID' = (Get-Content "$($PSScriptRoot)\json\discovery_sessionID.json")
    'discovery_sessionQuery' = (Get-Content "$($PSScriptRoot)\json\discovery_sessionQuery.json")

    'Organization1ID' = (Get-Content "$($PSScriptRoot)\json\Organization1ID.json")
    'Organization1Query' = (Get-Content "$($PSScriptRoot)\json\organization1Query.json")
    'Organization1Xtend' = (Get-Content "$($PSScriptroot)\json\organization1xtend.json")

    'Organization2Query' = (Get-Content "$($PSScriptRoot)\json\organization2Query.json")
    'Organization2Xtend' = (Get-Content "$($PSScriptroot)\json\organization2xtend.json")
}

foreach ($EntityKey in $Entities.Keys) {
    try {
        convertfrom-json $Entities[$EntityKey] | out-null
    } catch {
        Write-Information $($EntityKey)
    }
}

$Entities
<#
cls
$Entity = 'device_template'
(Invoke-WebRequest -Method Get -Uri "https://monitoring.realdolmencloud.com/api/$($Entity)/1" -Credential $Cred).Content
(Invoke-WebRequest -Method Get -Uri "https://monitoring.realdolmencloud.com/api/$($Entity)?limit=1&filter._id.eq=1" -Credential $Cred).Content
(Invoke-WebRequest -Method Get -Uri "https://monitoring.realdolmencloud.com/api/$($Entity)?limit=1&filter._id.eq=1&extended_fetch=1&hide_filterinfo=1" -Credential $Cred).Content

#>