function ConvertTo-Appliance {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		$SL1Appliance,

		[Parameter(Mandatory, Position=1)]
		[ValidateRange(0,([int64]::MaxValue))]
		[int64]$Id
	)

	Process {
		$SL1Appliance | Add-Member -TypeName 'appliance'
		$SL1Appliance | Add-Member -NotePropertyName 'URI' -NotePropertyValue "/api/appliance/$($Id)"
		$SL1Appliance | Add-Member -NotePropertyName 'ID' -NotePropertyValue $Id
		$SL1Appliance
	}
}