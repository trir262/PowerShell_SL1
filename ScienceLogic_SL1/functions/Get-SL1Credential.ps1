Function Get-SL1Credential {
	[CmdletBinding(DefaultParameterSetName='Filter')]
	Param(

		[Parameter(Mandatory, Position=0)]
		[ValidateSet('SNMP','DB','SOAP','LDAP','BASIC','SSH','PowerShell')]
		[string]$Type,

		[Parameter(Position=1, ValueFromPipeline, ParameterSetName='ID')]
		[ValidateScript({$_ -gt 0})]
		[int64]$Id,

		[Parameter(Position=1, ValueFromPipeline, ParameterSetName='Filter')]
		[string]$Filter,

		[Parameter(Position=2)]
		[ValidateRange(0,([int64]::MaxValue))]
		[int64]$Limit
	)

	Begin {
		Test-SL1Connected
		if ($Limit -eq 0) {
			$Limit = $Script:SL1Defaults.DefaultLimit
		}

		$CredentialType = switch ($Type) {
			'SNMP' {'snmp' }
			'DB' { 'db'}
			'SOAP' { 'soap'}
			'LDAP' { 'ldap'}
			'BASIC' { 'basic'}
			'SSH' {'ssh'}
			'PowerShell' {'powershell'}
		}
	}

	Process {
		switch ($PSCmdlet.ParameterSetName) {
			'ID' {
				if ($id) {
					$SL1Credential = Invoke-SL1Request GET "$($Script:SL1Defaults.APIROOT)/api/credential/$($CredentialType)/$($Id)"
					switch ($SL1Credential.StatusCode) {
						{ $_ -eq [system.net.httpstatuscode]::OK } {
							$Credential = ConvertFrom-Json $SL1Credential.content
							ConvertTo-Credential -SL1Credential $Credential -ID $Id -Type $Type
						}
						{ $_ -eq [system.net.httpstatuscode]::Forbidden } { throw "You are not authorized to get information on credential with id $($Id)"}
						{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { throw "Credential with id $($Id) is not found in the SL1 system" }
					}
				} else {
					Get-SL1Credential -Filter 'filter.0.name.contains=bru-in-sclo'
				}
			}
			'Filter' {
				if ($filter -ne "") {
					$SL1CredentialQuery = Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/credential/$($Type)?$($Filter)&limit=$($Limit)"
				} else {
					$SL1CredentialQuery = Invoke-SL1Request Get "$($Script:SL1Defaults.APIRoot)/api/credential/$($Type)?limit=$($Limit)"
				}
				switch ($SL1Credentialquery.StatusCode) {
					{ $_ -eq [system.net.httpstatuscode]::OK} {
						$Json = ConvertFrom-Json $SL1CredentialQuery.content
						if ($Json.total_matched -eq 0) {
							throw "No credential found with filter '$($Filter)'"
						} else {
							$Content = (Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/credential/$($Type)?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1").Content
							$Credentials = ConvertFrom-Json $Content
							foreach ($CredentialURI in (($Credentials | Get-Member -MemberType NoteProperty).name) ) {
								ConvertTo-Credential -SL1Credential $Credentials.$CredentialURI -ID "$( ($CredentialURI -split '/')[-1])" -Type $Type
							}
						}
					}
					{ $_ -eq [system.net.httpstatuscode]::Forbidden }  { throw "You are not authorized to get information on credentials"}
					{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { throw "Credential with id $($Id) is not found in the SL1 system" }
				}
			}
		}
	}
}