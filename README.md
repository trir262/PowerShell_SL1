# ScienceLogic_SL1

[![Build status](https://ci.appveyor.com/api/projects/status/ofohmkxfkqx4w5dh/branch/master?svg=true)](https://ci.appveyor.com/project/TomRobijns/powershell-sl1/branch/master) [![Board Status](https://dev.azure.com/trammeke/4f8725b2-7e8d-4c69-b5f6-f4e2da80651c/7938b5a6-3b0a-467c-8a05-e962bc44d445/_apis/work/boardbadge/5c03fff3-939b-4a82-9868-fce061fce08b)](https://dev.azure.com/trammeke/4f8725b2-7e8d-4c69-b5f6-f4e2da80651c/_boards/board/t/7938b5a6-3b0a-467c-8a05-e962bc44d445/Microsoft.RequirementCategory/)

PowerShell wrapper for ScienceLogic SL1 REST API and the GraphQL language.
SL1 is the new name of ScienceLogic's EM7. their API has been rewritten and is enhanced.

## Issue tracking

Issues are currently tracked in [azure devops](https://dev.azure.com/trammeke/ScienceLogic_SL1_test1/_workitems/recentlyupdated).

## Installation

```powershell
Install-Module ScienceLogic_SL1
```

## Usage

```powershell
Import-Module ScienceLogic-SL1 # Load the module
Connect-SL1 # Login to the SL1 Environment, URI and Credentials are required
```
