function ConvertTo-Discovery {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[pscustomobject]$SL1Discovery,

		[Parameter(Mandatory, Position=1)]
		[int64]$Id
	)

	Process {
		$SL1Discovery | Add-Member -TypeName 'discovery'
		$SL1Discovery | Add-Member -NotePropertyName 'URI' -NotePropertyValue "/api/discovery_session/$($Id)"
		$SL1Discovery | Add-Member -NotePropertyName 'ID' -NotePropertyValue $Id
		$SL1Discovery
	}
}