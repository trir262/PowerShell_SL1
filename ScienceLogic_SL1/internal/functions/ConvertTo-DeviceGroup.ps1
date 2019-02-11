function ConvertTo-DeviceGroup {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		$SL1DeviceGroup,

		[Parameter(Mandatory, Position=1)]
		[ValidateRange(0,([int64]::MaxValue))]
		[int64]$Id
	)
	Process {
		$SL1DeviceGroup | Add-Member -TypeName 'devicegroup'

		$SL1DeviceGroup | Add-Member -NotePropertyName 'URI' -NotePropertyValue "/api/device_group/$($Id)"
		$SL1DeviceGroup | Add-Member -NotePropertyName 'ID' -NotePropertyValue $Id
		$SL1DeviceGroup
	}
}