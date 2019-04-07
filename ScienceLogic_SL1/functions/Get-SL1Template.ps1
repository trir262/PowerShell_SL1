Function Get-SL1Template {
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
					$SL1Template = Invoke-SL1Request GET "$($Script:SL1Defaults.APIROOT)/api/device_template/$($Id)"
					switch ($SL1Template.StatusCode) {
						{ $_ -eq [system.net.httpstatuscode]::OK } {
							$Template = ConvertFrom-Json $SL1Template.content
							ConvertTo-Template -SL1Template $Template -ID $Id
						}
						{ $_ -eq [system.net.httpstatuscode]::Forbidden } { throw "You are not authorized to get information on the device template with id $($Id)"}
						{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { throw "Device template with id $($Id) is not found in the SL1 system" }
					}
				} else {
					Get-SL1Template -Filter 'filter.0.name.contains=bru-in-sclo'
				}
			}
			'Filter' {
				if ($filter -ne "") {
					$SL1TemplateQuery = Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/device_template?$($Filter)&limit=$($Limit)"
				} else {
					$SL1TemplateQuery = Invoke-SL1Request Get "$($Script:SL1Defaults.APIRoot)/api/device_template?limit=$($Limit)"
				}
				switch ($SL1TemplateQuery.StatusCode) {
					{ $_ -eq [system.net.httpstatuscode]::OK} {
						$Json = ConvertFrom-Json $SL1TemplateQuery.content
						if ($Json.total_matched -eq 0) {
							throw "No template found with filter '$($Filter)'"
						} else {
							$Templates = ConvertFrom-Json ((Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/device_template?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1").Content)
							foreach ($TemplateURI in (($Templates | Get-Member -MemberType NoteProperty).name) ) {
								ConvertTo-Template -SL1Template $Templates.$TemplateURI -ID "$( ($TemplateURI -split '/')[-1])"
							}
						}
					}
					{ $_ -eq [system.net.httpstatuscode]::Forbidden }  { throw "You are not authorized to get information on templates"}
					{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { throw "Template with id $($Id) is not found in the SL1 system" }
				}
			}
		}
	}
}