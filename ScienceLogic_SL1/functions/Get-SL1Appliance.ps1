Function Get-SL1Appliance {
	[CmdletBinding(DefaultParameterSetName='Filter')]
	Param(
		[Parameter(Position=0, ValueFromPipeline, ParameterSetName='ID')]
		[ValidateScript({$_ -gt 0})]
		[int64]$Id,

		[Parameter(Position=0, ValueFromPipeline, ParameterSetName='Filter')]
		[string]$Filter,

		[Parameter(Position=1)]
		[ValidateRange(0,([int64]::MaxValue))]
		[int64]$Limit
	)

	Begin {
		Assert-SL1Connected
		if ($Limit -eq 0) {
			$Limit = $Script:SL1Defaults.DefaultLimit
		}
	}

	Process {
		switch ($PSCmdlet.ParameterSetName) {
			'ID' {
				if ($id) {
					$SL1Appliance = Invoke-SL1Request GET "$($Script:SL1Defaults.APIROOT)/api/appliance/$($Id)"
					switch ($SL1Appliance.StatusCode) {
						{ $_ -eq [system.net.httpstatuscode]::OK } {
							$Appliance = ConvertFrom-Json $SL1Appliance.content
							ConvertTo-Appliance -SL1Appliance $Appliance -ID $Id
						}
						{ $_ -eq [system.net.httpstatuscode]::Forbidden } { throw "You are not authorized to getappliance information"}
						{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { throw "Device group with id $($Id) is not found in the SL1 system" }
					}
				} else {
					Get-SL1Appliance -Filter 'filter.0.name.contains=bru-in-sclo'
				}
			}
			'Filter' {
				if ($filter -ne "") {
					$SL1Appliance = Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/appliance?$($Filter)&limit=$($Limit)"
				} else {
					$SL1Appliance = Invoke-SL1Request Get "$($Script:SL1Defaults.APIRoot)/api/appliance?limit=$($Limit)"
				}
				switch ($SL1Appliance.StatusCode) {
					{ $_ -eq [system.net.httpstatuscode]::OK} {
						$Json = ConvertFrom-Json $SL1Appliance.content
						if ($Json.total_matched -eq 0) {
							throw "No device group found with filter '$($Filter)'"
						} else {
							$Appliances = ConvertFrom-Json ((Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/appliance?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1").Content)
							foreach ($ApplianceURI in (($Appliances | Get-Member -MemberType NoteProperty).name) ) {
								ConvertTo-Appliance -SL1Appliance $Appliances.$ApplianceURI -ID "$( ($ApplianceURI -split '/')[-1])"
							}
						}
					}
					{ $_ -eq [system.net.httpstatuscode]::Forbidden }  { throw "You are not authorized to get information on device groups"}
					{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { throw "Device group with id $($Id) is not found in the SL1 system" }
				}
			}
		}
	}
}