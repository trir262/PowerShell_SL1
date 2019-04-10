Function Get-SL1CollectorGroup {
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
					$SL1CollectorGroup = Invoke-SL1Request GET "$($Script:SL1Defaults.APIROOT)/api/collector_group/$($Id)"
					switch ($SL1CollectorGroup.StatusCode) {
						{ $_ -eq [system.net.httpstatuscode]::OK } {
							$CollectorGroup = ConvertFrom-Json $SL1CollectorGroup.content
							ConvertTo-CollectorGroup -SL1CollectorGroup $CollectorGroup -ID $Id
						}
						{ $_ -eq [system.net.httpstatuscode]::Forbidden } { throw "You are not authorized to get information on the collector group with id $($Id)"}
						{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { throw "Collector group with id $($Id) is not found in the SL1 system" }
					}
				} else {
					Get-SL1CollectorGroup -Filter 'filter.0.name.contains=bru-in-sclo'
				}
			}
			'Filter' {
				if ($filter -ne "") {
					$SL1CollectorGroup = Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/collector_group?$($Filter)&limit=$($Limit)"
				} else {
					$SL1CollectorGroup = Invoke-SL1Request Get "$($Script:SL1Defaults.APIRoot)/api/collector_group?limit=$($Limit)"
				}
				switch ($SL1CollectorGroup.StatusCode) {
					{ $_ -eq [system.net.httpstatuscode]::OK} {
						$Json = ConvertFrom-Json $SL1CollectorGroup.content
						if ($Json.total_matched -eq 0) {
							throw "No collector group found with filter '$($Filter)'"
						} else {
							$CollectorGroups = ConvertFrom-Json ((Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/collector_group?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1").Content)
							foreach ($CollectorGroupURI in (($CollectorGroups | Get-Member -MemberType NoteProperty).name) ) {
								ConvertTo-CollectorGroup -SL1CollectorGroup $CollectorGroups.$CollectorGroupURI -ID "$( ($CollectorGroupURI -split '/')[-1])"
							}
						}
					}
					{ $_ -eq [system.net.httpstatuscode]::Forbidden }  { throw "You are not authorized to get information on CollectorGroups"}
					{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { throw "Template with id $($Id) is not found in the SL1 system" }
				}
			}
		}
	}
}