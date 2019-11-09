---
external help file: ScienceLogic_SL1-help.xml
Module Name: sciencelogic_sl1
online version:
schema: 2.0.0
---

# Get-SL1Credential

## SYNOPSIS

Get-SL1Credential gets a ScienceLogic SL1 Credential via REST API.

## SYNTAX

### Filter (Default)
```
Get-SL1Credential [-Type] <String> [[-Filter] <String>] [[-Limit] <Int64>] [<CommonParameters>]
```

### ID
```
Get-SL1Credential [-Type] <String> [[-Id] <Int64>] [[-Limit] <Int64>] [<CommonParameters>]
```

## DESCRIPTION

This function gets the ScienceLogic SL1 credentials that are accessible via the API.
Possible credential types are SNMP, DB, SOAP, LDAP, BASIC, SSH and PowerShell.

## EXAMPLES

### Example 1

```powershell
PS C:\> Connect-SL1 -URI 'https://support.sciencelogic.com' -Credential (Get-Credential)
PS C:\> Get-SL1Credential -Type SNMP -Id 1
```

```text
The first command creates a connection to the ScienceLogic SL1 Platform.
The second command retrieves SL1 Credential with ID 1 and type SNMP.
```

## PARAMETERS

### -Filter

Gets a couple of credentials, based on an SL1 Filter

```yaml
Type: String
Parameter Sets: Filter
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Id

Gets an SL1 Credential, based on an ID

```yaml
Type: Int64
Parameter Sets: ID
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Limit

Defines the number of credentials that should be retrieved.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type

Defines the type of credential that should be fetched.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: SNMP, DB, SOAP, LDAP, BASIC, SSH, PowerShell

Required: True
Position: 0
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
