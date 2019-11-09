---
external help file: ScienceLogic_SL1-help.xml
Module Name: sciencelogic_sl1
online version:
schema: 2.0.0
---

# Get-SL1Template

## SYNOPSIS
Get a ScienceLogic SL1 Template

## SYNTAX

### Filter (Default)
```
Get-SL1Template [[-Filter] <String>] [[-Limit] <Int64>] [<CommonParameters>]
```

### ID
```
Get-SL1Template [[-Id] <Int64>] [[-Limit] <Int64>] [<CommonParameters>]
```

## DESCRIPTION
This function gets a ScienceLogic SL1 Template via the REST API.

## EXAMPLES

### Example 1
```
PS C:\> Connect-SL1 -URI 'https://support.sciencelogic.com' -Credential (Get-Credential)
PS C:\> Get-SL1Template -Id 1

The first command creates a connection to the ScienceLogic SL1 Environment.
The second command gets the template with id 1
```

## PARAMETERS

### -Filter
The filter can be used to return several templates, based on an SL1 Filter

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
The ID parameter ensures only a single template can be returned.

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
Limits the number of templates to be returned.

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

### System.Object
## NOTES

## RELATED LINKS
