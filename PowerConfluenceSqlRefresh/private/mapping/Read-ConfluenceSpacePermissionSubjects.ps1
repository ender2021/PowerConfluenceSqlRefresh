function Read-ConfluenceSpacePermissionSubjects {
    [CmdletBinding()]
    param (
        # User object
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [AllowNull()]
        [pscustomobject]
        $Data
    )
    
    begin {
        $toReturn = @()
    }
    
    process {
        if ($null -eq $Data) { 
            $toReturn += @{
                Type = $null
                Id = $null
            }
        } else {
            if ([bool]($data.PSobject.Properties.name -match "user")) {
                $toReturn += $data.user.results | ForEach-Object { [PSCustomObject]@{
                       Type = "user"
                       Id = $_.accountId
                    }
                }
            }
            if ([bool]($data.PSobject.Properties.name -match "group")) {
                $toReturn += $data.group.results | ForEach-Object { [PSCustomObject]@{
                       Type = "group"
                       Id = $_.name
                    }
                }
            }
        }
    }
    
    end {
        $toReturn
    }
}