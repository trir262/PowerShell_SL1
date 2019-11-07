function ConvertTo-Alert {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[pscustomobject]$SL1Entity
	)

	Process {
		$SL1Entity | Add-Member -TypeName 'alert'
		$SL1Entity
	}
}