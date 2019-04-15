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
					$IWRResponse = Invoke-WebRequest -Method $Method -Uri $Uri -MaximumRedirection 0 -Credential $Cred -ContentType $ContentType -ErrorAction SilentlyContinue -ErrorVariable IWRError -Verbose:$false
					switch ($IWRResponse.StatusCode) {
						{ $_ -eq [System.Net.HttpStatusCode]::OK } { $IWRResponse }
						{ $_ -eq [System.Net.HttpStatusCode]::Redirect} { Invoke-SL1Request -Method $Method -Uri "$($Script:SL1Defaults.APIRoot)$($IWRResponse.Headers['Location'])" }
					}
				} Catch [System.Exception] {
					$ThisError = $Error[0]
					switch ($IWRError.InnerException.Response.StatusCode) {
						{ $_ -eq [System.Net.HttpStatusCode]::Unauthorized} { $_.Exception.Response }
						{ $_ -eq [System.Net.HttpStatusCode]::NotFound} { $_.Exception.Response }
						{ $_ -eq [system.net.httpstatuscode]::Forbidden} { $_.Exception.Response }
						{ $_ -eq [System.Net.HttpStatusCode]::BadRequest} { throw $ThisError }
						{ $_ -eq [System.Net.HttpStatusCode]::NotImplemented } { $_.Exception.Response }
						default { $_ }
					}
				}
			}
			"Post" {
				Write-Verbose "In Post Mode"
				try {
					if ($body) {
						$IWRResponse = Invoke-WebRequest -Method $Method -Uri $Uri -MaximumRedirection 0 -Credential $Cred -ContentType $ContentType -Body $Body -ErrorAction Stop -Verbose:$false
						switch ($IWRResponse.StatusCode) {
							{ $_ -eq [System.Net.HttpStatusCode]::OK -or $_ -eq [System.Net.HttpStatusCode]::Created -or $_ -eq [System.Net.HttpStatusCode]::Accepted } { $IWRResponse }
							{ $_ -eq [System.Net.HttpStatusCode]::Redirect} { Invoke-SL1Request -Method $Method -Uri "$($Script:SL1Defaults.APIRoot)$($IWRResponse.Headers['Location'])" }
						}
					}
				} Catch [System.Exception] {
					Write-Verbose "An exception occurred during the post: $($_.Exception)"
					$ThisError = $Error[0]
					switch ($IWRError.InnerException.Response.StatusCode) {
						{ $_ -eq [System.Net.HttpStatusCode]::Unauthorized} { $_.Exception.Response }
						{ $_ -eq [System.Net.HttpStatusCode]::NotFound} { $_.Exception.Response }
						{ $_ -eq [system.net.httpstatuscode]::Forbidden} { $_.Exception.Response }
						{ $_ -eq [System.Net.HttpStatusCode]::BadRequest} { throw $ThisError }
						{ $_ -eq [System.Net.HttpStatusCode]::NotImplemented } { $_.Exception.Response }
						default { $_ }
					}
				}
			}
		}
	}
}
