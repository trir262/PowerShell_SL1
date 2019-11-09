---
external help file: ScienceLogic_SL1-help.xml
Module Name: sciencelogic_sl1
online version:
schema: 2.0.0
---

# Get-SL1Appliance

## SYNOPSIS

Gets an appliance from the Sciencelogic SL1 environment.

## SYNTAX

### Filter (Default)
```
Get-SL1Appliance [[-Filter] <String>] [[-Limit] <Int64>] [<CommonParameters>]
```

### ID
```
Get-SL1Appliance [[-Id] <Int64>] [[-Limit] <Int64>] [<CommonParameters>]
```

## DESCRIPTION

An appliance is an SL1 device that is part of the platform. It can be a database, a data or message collector or a web server.
This function gets an appliance from the SL1 environment that can be used to create a discovery via API.

## EXAMPLES

### Example 1

```powershell
PS C:\>Connect-SL1 -URI 'https://support.sciencelogic.com' -Credential ( Get-Credential )
PS C:\>Get-SL1Appliance -ID 1
```

```text
The first command establishes a connection to a Sciencelogic platform.
The second command retrieves an appliance with ID 1
```

## PARAMETERS

### -Filter

A SL1 filter that can be used to get multiple appliances.

```yaml
Type: String
Parameter Sets: Filter
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Id

The ID of an appliance.

```yaml
Type: Int64
Parameter Sets: ID
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Limit

The amount of appliances to return.
If this is not specified, the default of 50 is used.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int64
### System.String

## OUTPUTS

### appliance

## NOTES

## RELATED LINKS
