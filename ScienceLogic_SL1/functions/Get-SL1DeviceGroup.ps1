Function Get-SL1DeviceGroup {
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
		Test-SL1Connected
		if ($Limit -eq 0) {
			$Limit = $Script:SL1Defaults.DefaultLimit
		}
	}

	Process {
		switch ($PSCmdlet.ParameterSetName) {
			'ID' {
				if ($id) {
					$SL1DeviceGroup = Invoke-SL1Request GET "$($Script:SL1Defaults.APIROOT)/api/device_group/$($Id)"
					switch ($SL1DeviceGroup.StatusCode) {
						{ $_ -eq [system.net.httpstatuscode]::OK } {
							$DeviceGroup = ConvertFrom-Json $SL1DeviceGroup.content
							ConvertTo-DeviceGroup -SL1DeviceGroup $DeviceGroup -ID $Id
						}
						{ $_ -eq [system.net.httpstatuscode]::Forbidden } { throw "You are not authorized to get information on the device group with id $($Id)"}
						{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { throw "Device group with id $($Id) is not found in the SL1 system" }
					}
				} else {
					Get-SL1DeviceGroup -Filter 'filter.0.name.contains=bru-in-sclo'
				}
			}
			'Filter' {
				if ($filter -ne "") {
					$SL1DeviceGroup = Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/device_group?$($Filter)&limit=$($Limit)"
				} else {
					$SL1DeviceGroup = Invoke-SL1Request Get "$($Script:SL1Defaults.APIRoot)/api/device_group?limit=$($Limit)"
				}
				switch ($SL1DeviceGroup.StatusCode) {
					{ $_ -eq [system.net.httpstatuscode]::OK} {
						$Json = ConvertFrom-Json $SL1DeviceGroup.content
						if ($Json.total_matched -eq 0) {
							throw "No device group found with filter '$($Filter)'"
						} else {
							$DGroup = (Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/device_group?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1")
							$DeviceGroups = ConvertFrom-Json ($dgroup.Content)
							foreach ($DeviceGroupURI in (($DeviceGroups | Get-Member -MemberType NoteProperty).name) ) {
								ConvertTo-DeviceGroup -SL1DeviceGroup $DeviceGroups.$DeviceGroupURI -ID "$( ($DeviceGroupURI -split '/')[-1])"
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