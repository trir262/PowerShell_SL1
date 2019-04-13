Function Get-SL1Discovery {
	[CmdletBinding(DefaultParameterSetName='Filter')]
	Param(
		[Parameter(Position=0, ValueFromPipeline, ParameterSetName='ID')]
		[ValidateScript({$_ -gt 0})]
		[int64]$Id,

		[Parameter(Position=0, ValueFromPipeline, ParameterSetName='Filter')]
		[string]$Filter,

		[Parameter(Position=1, ParameterSetName='Filter')]
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
				$SL1Discovery = Invoke-SL1Request GET "$($Script:SL1Defaults.APIROOT)/api/discovery_session/$($Id)"
				switch ($SL1Discovery.StatusCode) {
					{ $_ -eq [system.net.httpstatuscode]::OK } {
						$DiscoverySession = ConvertFrom-Json $SL1Discovery.Content
						ConvertTo-Discovery -SL1Discovery $DiscoverySession -ID $Id
					}
					{ $_ -eq [system.net.httpstatuscode]::Forbidden } { throw "You are not authorized to get information on discovery session with id $($Id)"}
					{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { throw "Discovery Session with id $($Id) is not found in the SL1 system" }
				}
			}
			'Filter' {
				if ($filter -ne "") {
					$SL1DiscoveryQuery = Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/discovery_session?$($Filter)&limit=$($Limit)"
				} else {
					$SL1DiscoveryQuery = Invoke-SL1Request Get "$($Script:SL1Defaults.APIRoot)/api/discovery_session?limit=$($Limit)"
				}
				switch ($SL1Discoveryquery.StatusCode) {
					{ $_ -eq [system.net.httpstatuscode]::OK} {
						$Json = ConvertFrom-Json $SL1DiscoveryQuery.content
						if ($Json.total_matched -eq 0) {
							throw "No discovery session found with filter '$($Filter)'"
						} else {
							$Discovery = ConvertFrom-Json ((Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/discovery_session?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1").Content)
							foreach ($DiscoveryURI in (($Discovery | Get-Member -MemberType NoteProperty).name) ) {
								ConvertTo-Discovery -SL1Discovery ($Discovery.$DiscoveryURI) -ID "$( ($DeviceURI -split '/')[-1])"
							}
						}
					}
					{ $_ -eq [system.net.httpstatuscode]::Forbidden }  { throw "You are not authorized to get information on discovery session"}
					{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { throw "Discovery session with id $($Id) is not found in the SL1 system" }
				}
			}
		}
	}
}