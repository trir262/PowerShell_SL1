---
external help file: ScienceLogic_SL1-help.xml
Module Name: sciencelogic_sl1
online version:
schema: 2.0.0
---

# Add-SL1Alert

## SYNOPSIS

Send an alert message to a device.

## SYNTAX

```
Add-SL1Alert [-Message] <String> [[-Entity] <PSObject[]>] [-Passthru] [<CommonParameters>]
```

## DESCRIPTION

Add-SL1Alert send a message to a device as an alert that can become an event via an event policy.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-SL1Device -Id 5 | Add-SL1Alert -Message "This is a test"
```

```text
The command gets Device with ID 5 and sends an alert message "This is a test" to the device.
```

## PARAMETERS

### -Entity

A device

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Message

A string containing the message that should be sent.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Passthru

Returns the full json returned by the SL1 platform, containing the received timestamp of the alert.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject[]
## OUTPUTS

### System.Management.Automation.PSObject[]
## NOTES

## RELATED LINKS
