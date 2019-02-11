function ConvertTo-Credential {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[pscustomobject]$SL1Credential,

		[Parameter(Mandatory, Position=1)]
		[ValidateRange(0,([int64]::MaxValue))]
		[int64]$Id,

		[Parameter(ParameterSetName='Type')]
		[ValidateSet('SNMP','DB','SOAP','LDAP','BASIC','SSH','PowerShell')]
		[string]$Type
	)

	Process {
		$SL1Credential | Add-Member -TypeName "$($type.ToLower())credential"
		$SL1Credential | Add-Member -NotePropertyName 'URI' -NotePropertyValue "/api/credential/$($Type.tolower())/$($Id)"
		$SL1Credential | Add-Member -NotePropertyName 'ID' -NotePropertyValue $Id
		$SL1Credential | Add-Member -NotePropertyName 'cred_type' -NotePropertyValue 0

		switch ($Type) {
			'SNMP' { $SL1Credential.cred_type = 1 }
			'DB' { $SL1Credential.cred_type = 2 }
			'SOAP' { $SL1Credential.cred_type = 3 }
			'LDAP' { $SL1Credential.cred_type = 4 }
			'BASIC' { $SL1Credential.cred_type = 5 }
			'SSH' { $SL1Credential.cred_type = 6 }
			'PowerShell' { $SL1Credential.cred_type = 7 }

		}
		$SL1Credential
	}
}