function ConvertTo-Template {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[pscustomobject]$SL1Template,

		[Parameter(Mandatory, Position=1)]
		[ValidateRange(0,([int64]::MaxValue))]
		[int64]$Id
	)

	Process {
		$SL1Template | Add-Member -TypeName 'template'
		$SL1Template | Add-Member -NotePropertyName 'URI' -NotePropertyValue "/api/device_template/$($Id)"
		$SL1Template | Add-Member -NotePropertyName 'ID' -NotePropertyValue $Id
		$SL1Template
	}
}