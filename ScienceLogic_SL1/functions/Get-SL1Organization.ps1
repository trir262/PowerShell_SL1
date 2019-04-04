﻿Function Get-SL1Organization {
	[CmdletBinding(DefaultParameterSetName='Filter')]
	Param(
		[Parameter(Mandatory,Position=0, ValueFromPipeline, ParameterSetName='ID')]
		[ValidateScript({$_ -ge 0})]
		[int64]$Id,

		[Parameter(Position=0, ValueFromPipeline, ParameterSetName='Filter')]
		[ValidateNotNullOrEmpty()]
		[string]$Filter,

		[Parameter(Position=1, ParameterSetName='Filter')]
		[ValidateRange(0,([int64]::MaxValue))]
		[int64]$Limit
	)

	Begin {
		Test-SL1Connected
		if ($PSCmdlet.ParameterSetName -eq 'Filter' -and $Limit -eq 0) {
			$Limit = $Script:SL1Defaults.DefaultLimit
		}
	}

	Process {
		switch ($PSCmdlet.ParameterSetName) {
			'ID' {
				$SL1Organization = Invoke-SL1Request GET "$($Script:SL1Defaults.APIROOT)/api/organization/$($Id)"
				switch ($SL1Organization.StatusCode) {
					{ $_ -eq [system.net.httpstatuscode]::OK } {
						$Organization = ConvertFrom-Json $SL1Organization.content
						ConvertTo-Organization -SL1Organization $Organization -ID $Id
					}
					{ $_ -eq [system.net.httpstatuscode]::Forbidden } { throw "You are not authorized to get information of organization with id $($Id)"}
					{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { throw "organization with id $($Id) is not found in the SL1 system" }
				}
			}
			'Filter' {
				if ($Filter -ne "") {
					$SL1OrganizationQuery = Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/organization?$($Filter)&limit=$($Limit)"
				} else {
					$SL1OrganizationQuery = Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/organization?limit=$($Limit)"
				}

				switch ($SL1Organizationquery.StatusCode) {
					{ $_ -eq [system.net.httpstatuscode]::OK} {
						$Json = ConvertFrom-Json $SL1OrganizationQuery.content
						if ($Json.total_matched -eq 0) {
							throw "No organizations found with filter '$($Filter)'"
						} else {
							$Organizations = ConvertFrom-Json ((Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/organization?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1").Content)
							foreach ($OrganizationURI in (($Organizations | Get-Member -MemberType NoteProperty).name) ) {
								ConvertTo-Organization -SL1Organization $Organizations.$OrganizationURI -ID "$( ($OrganizationURI -split '/')[-1])"
							}
						}
					}
					{ $_ -eq [system.net.httpstatuscode]::Forbidden }  { throw "You are not authorized to get information on organizations"}
					{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { throw "Organization with id $($Id) is not found in the SL1 system" }
				}
			}
		}
	}

}