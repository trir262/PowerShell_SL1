---
external help file: ScienceLogic_SL1-help.xml
Module Name: sciencelogic_sl1
online version:
schema: 2.0.0
---

# Get-SL1DeviceGroup

## SYNOPSIS
Gets a device group from the sciencelogic sl1 platform.

## SYNTAX

### Filter (Default)
```
Get-SL1DeviceGroup [[-Filter] <String>] [[-Limit] <Int64>] [<CommonParameters>]
```

### ID
```
Get-SL1DeviceGroup [[-Id] <Int64>] [[-Limit] <Int64>] [<CommonParameters>]
```

## DESCRIPTION
This function gets a device group by ID or by a query.

## EXAMPLES

### Example 1
```
PS C:\>Connect-SL1 -URI 'https://support.sciencelogic.com' -Credential ( Get-Credential )
PS C:\>Get-SL1DeviceGroup -ID 1

The first command established a connection to a Sciencelogic Platform.
The second command retrieves a device group with id 1.
```

## PARAMETERS

### -Filter
SL1 Filter that can be used to find a device group

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
The ID of the device group

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
Specifies the amount of device groups to be returned.

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

### devicegroup
## NOTES

## RELATED LINKS
