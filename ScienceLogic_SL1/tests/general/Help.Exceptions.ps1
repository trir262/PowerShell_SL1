# List of functions that should be ignored
$global:FunctionHelpTestExceptions = @(
  'Connect-SL1',
  'Get-SL1Appliance', 
  'Get-SL1CollectorGroup', 'Get-SL1Credential',
  'Get-SL1Device', 'Get-SL1DeviceGroup', 'Get-SL1Discovery'
  'Get-SL1Organization',
  'Get-SL1Template' ,
  'Add-SL1Alert'
  #internals
  'ConvertTo-Appliance', 'ConvertTo-CollectorGroup' , 'ConvertTo-Credential' , 'ConvertTo-Device' , 'ConvertTo-DeviceGroup' , 'ConvertTo-Discovery',
  'ConvertTo-Organization' , 'ConvertTo-Template' , 'Get-OrganizationForDevice', 'Invoke-SL1Request' , 'Assert-SL1Connected', 'ConvertTo-Alert'
  'Out-WebError'

)

<#
  List of arrayed enumerations. These need to be treated differently. Add full name.
  Example:

  "Sqlcollaborative.Dbatools.Connection.ManagementConnectionType[]"
#>
$global:HelpTestEnumeratedArrays = @(
	
)

<#
  Some types on parameters just fail their validation no matter what.
  For those it becomes possible to skip them, by adding them to this hashtable.
  Add by following this convention: <command name> = @(<list of parameter names>)
  Example:

  "Get-DbaCmObject"       = @("DoNotUse")
#>
$global:HelpTestSkipParameterType = @{
    
}
