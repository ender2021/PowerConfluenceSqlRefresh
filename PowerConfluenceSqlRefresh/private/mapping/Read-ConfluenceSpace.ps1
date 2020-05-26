function Read-ConfluenceSpace {
    [CmdletBinding()]
    param (
        # User object
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [pscustomobject]
        $Data,

        # Refresh ID
        [Parameter(Mandatory,Position=1)]
        [int]
        $RefreshId,

        # Set this switch to true to map permissions
        [Parameter()]
        [switch]
        $ReadPermissions
    )
    
    begin {
    }
    
    process {
        $hostUrl = "https://" + ([System.Uri]$Data._links.self).Host + "/wiki"
        $toReturn = [PSCustomObject]@{
            Space_Id = [int]$Data.id
            Space_Key = $Data.key
            Name = $Data.name
            Type = $Data.type
            Status = $Data.status
            Icon_Url = $hostUrl + $Data.icon.path
            Icon_Height = $Data.icon.height
            Icon_Width = $Data.icon.width
            Refresh_Id = $RefreshId
        }
        if ($ReadPermissions) {
            if (![bool]($Data.PSobject.Properties.name -match "permissions")) {
                throw "Permission mapping requested, but no permission property is present on the Space object"
            }
            $permissions = $data.permissions | Read-ConfluenceSpacePermission -SpaceId $toReturn.Space_Id -RefreshId $RefreshId
            $toReturn | Add-Member -NotePropertyName "Permissions" -NotePropertyValue $permissions
        }
        $toReturn
    }
    
    end {
    }
}