function Read-ConfluenceSpacePermission {
    [CmdletBinding()]
    param (
        # User object
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [pscustomobject]
        $Data,

        # The Id of the associated space
        [Parameter(Mandatory,Position=1)]
        [int]
        $SpaceId,

        # Refresh ID
        [Parameter(Mandatory,Position=2)]
        [int]
        $RefreshId
    )
    
    begin {
    }
    
    process {
        $Data.subjects | Read-ConfluenceSpacePermissionSubjects | ForEach-Object { 
            [PSCustomObject]@{
                Permission_Id = [string]$Data.id
                Space_Id = $SpaceId
                Subject_Type = $_.Type
                Subject_Id = $_.Id
                Operation = $Data.operation.operation
                Target_Type = $Data.operation.targetType
                Anonymous_Access = $Data.anonymousAccess
                Unlicensed_Access = $Data.unlicensedAccess
                Refresh_Id = $RefreshId
            }
        }
    }
    
    end {
    }
}