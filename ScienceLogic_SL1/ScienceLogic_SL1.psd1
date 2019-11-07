@{
	# Script module or binary module file associated with this manifest
	RootModule = 'ScienceLogic_SL1.psm1'
	
	# Version number of this module.
	ModuleVersion = '0.1.9'
	
	# ID used to uniquely identify this module
	GUID = 'be9aa474-0ee2-475a-a9c3-0d16220ed6c1'
	
	# Author of this module
	Author = 'Tom Robijns'
	
	# Company or vendor of this module
	CompanyName = ''
	
	# Copyright statement for this module
	Copyright = 'Copyright (c) 2019 Tom Robijns'
	
	# Description of the functionality provided by this module
	Description = 'This module is a wrapper for the ScienceLogic API and ScienceLogic GraphQL possibilities. Use this in your environment if you do not want to learn the ScienceLogic API or GraphQL yourself'
	
	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.0'
	
	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @(
		@{ ModuleName='PSFramework'; ModuleVersion='0.10.30.165' }
	)
	
	# Assemblies that must be loaded prior to importing this module
	# RequiredAssemblies = @('bin\ScienceLogic_SL1.dll')
	
	# Type files (.ps1xml) to be loaded when importing this module
	TypesToProcess = @('xml\ScienceLogic_SL1.Types.ps1xml')
	
	# Format files (.ps1xml) to be loaded when importing this module
	#FormatsToProcess = @('xml\ScienceLogic_SL1.Format.ps1xml')
	
	# Functions to export from this module
	FunctionsToExport = @(
		'Add-SL1Alert',
        'Connect-SL1',
        'Get-SL1Appliance', 
        'Get-SL1CollectorGroup', 'Get-SL1Credential',
        'Get-SL1Device', 'Get-SL1DeviceGroup', 'Get-SL1Discovery'
        'Get-SL1Organization',
        'Get-SL1Template'
)
	
	# Cmdlets to export from this module
	CmdletsToExport = ''
	
	# Variables to export from this module
	VariablesToExport = ''
	
	# Aliases to export from this module
	AliasesToExport = ''
	
	# List of all modules packaged with this module
	ModuleList = @()
	
	# List of all files packaged with this module
	FileList = @()
	
	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{
		
		#Support for PowerShellGet galleries.
		PSData = @{
			
			# Tags applied to this module. These help with module discovery in online galleries.
			Tags = @('Windows', 'PSEdition_Desktop')
			
			# A URL to the license for this module.
			LicenseUri = 'https://github.com/trir262/PowerShell_SL1/blob/master/LICENSE'
			
			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/trir262/PowerShell_SL1'
			
			# A URL to an icon representing this module.
			# IconUri = ''
			
			# Prerelease version, we are not ready yet.
			Prerelase = 'alpha'

			# ReleaseNotes of this module
			ReleaseNotes = '0.1 Initial version of the ScienceLogic API & GraphQL Module'
			
		} # End of PSData hashtable
		
	} # End of PrivateData hashtable
}








