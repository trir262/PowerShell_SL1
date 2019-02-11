function ConvertTo-CollectorGroup {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		$SL1CollectorGroup,

		[Parameter(Mandatory, Position=1)]
		[ValidateRange(0,([int64]::MaxValue))]
		[int64]$Id
	)

	Process {
		$SL1CollectorGroup | Add-Member -TypeName 'collectorgroup'
		$SL1CollectorGroup | Add-Member -NotePropertyName 'URI' -NotePropertyValue "/api/collector_group/$($Id)"
		$SL1CollectorGroup | Add-Member -NotePropertyName 'ID' -NotePropertyValue $Id
		$SL1CollectorGroup
	}
}