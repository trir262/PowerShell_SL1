Function Invoke-SL1Request {
	[Cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true, Position=0)]
		[ValidateSet('Get','Post','Put','Delete')]
		[String]$Method,

		[Parameter(Mandatory=$true, Position=1)]
		[URI]$Uri,

		[Parameter(Position=2)]
		[ValidateScript( {
			try {
					if ($_ -ne "") {
						ConvertTo-Json (ConvertFrom-Json $_) | Out-Null
					}
					$true
			} Catch [system.Exception] {
				$false
			}
		})]
		[string]$Body,

		[Parameter(Position=3)]
		[ValidateSet('application/json; charset=utf-8','application/xml; charset=utf-8')]
		[string]$ContentType = 'application/json; charset=utf-8'
	)

	Process {
		<# To prevent progress bars, showed by Invoke-WebRequest, we set ProgressPreference to SilentlyContinue for this function. #>
		$ProgressPreference = 'SilentlyContinue'

		Remove-Variable IWRError -ErrorAction SilentlyContinue

		switch ($Method) {
			"Get" {
				# Variable BODY can not (yet) be used in this mode!
				#If we want to use body and support form-based filters, we need to use a dotnet webbrowser.
				Write-Verbose "In Get Mode"
				try {
					$IWRResponse = Invoke-WebRequest -Method $Method -Uri $Uri -MaximumRedirection 0 -Credential $Cred -ContentType $ContentType -ErrorAction SilentlyContinue -Verbose:$false
					switch ([System.Net.HttpStatusCode]($IWRResponse.StatusCode)) {
						( [System.Net.HttpStatusCode]::OK ) { $IWRResponse }
						( [System.Net.HttpStatusCode]::Redirect ) { Invoke-SL1Request -Method $Method -Uri "$($Script:SL1Defaults.APIRoot)$($IWRResponse.Headers['Location'])" }
					}
				} Catch [System.Net.WebException] {
					Out-WebError -WebError $_.Exception
				} Catch [System.Exception] {
					throw $_
				}
			}
			"Post" {
				Write-Verbose "In Post Mode"
				try {
					if ($body) {
						$IWRResponse = Invoke-WebRequest -Method $Method -Uri $Uri -MaximumRedirection 0 -Credential $Cred -ContentType $ContentType -Body $Body -ErrorAction Stop -errorvariable IWRError -Verbose:$false
						switch ([System.Net.HttpStatusCode]($IWRResponse.StatusCode)) {
							( [System.Net.HttpStatusCode]::OK )       { $IWRResponse }
							( [System.Net.HttpStatusCode]::Created )  { $IWRResponse }
							( [System.Net.HttpStatusCode]::Accepted ) { $IWRResponse }
							( [System.Net.HttpStatusCode]::Redirect ) { Invoke-SL1Request -Method $Method -Uri "$($Script:SL1Defaults.APIRoot)$($IWRResponse.Headers['Location'])" }
						}
					}
				} Catch [System.Net.WebException] {
					Out-WebError -WebError $_.Exception
				} Catch [System.Exception] {
					throw $_
				}
			}
			"Delete" {
				Write-Verbose "In Delete Mode"
				throw "Not yet implemented"
			}
			"Put" {
				Write-Verbose "In Put Mode"
				throw "Not yet implemented"
			}
		}
	}
}
