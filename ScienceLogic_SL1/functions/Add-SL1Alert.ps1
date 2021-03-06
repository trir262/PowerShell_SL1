﻿Function Add-SL1Alert {
  [OutputType([System.Management.Automation.psobject[]])]
  [CmdletBinding()]
    Param (
      [Parameter(Mandatory,Position=0)]
      [string]
      $Message,

      [Parameter(Position=1, ValueFromPipeline)]
      [ValidateScript({($_.pstypenames | select-object -first 1) -in @('device')})]
      [PSCustomObject[]]
      $Entity,

      [Parameter(Position=2)]
      [switch]
      $Passthru
  )

  Begin {
      Assert-SL1Connected
      if ($Limit -eq 0) {
          $Limit = $Script:SL1Defaults.DefaultLimit
      }
  }

  Process {
      $Body = ConvertFrom-Json "{message:""$($Message)""}"
      Foreach ($OneEntity in $Entity) {
          $Body | Add-Member -NotePropertyName 'aligned_resource' -NotePropertyValue $OneEntity.URI
          $WebResult = Invoke-SL1Request -Method Post -Uri "$($Script:SL1Defaults.APIROOT)/api/alert" -Body ( $Body | ConvertTo-Json)
          if ($Passthru) {
              $Entity
          } else {
              ConvertTo-Alert -SL1Entity (convertfrom-json $WebResult.Content)
          }
      }
  }
}