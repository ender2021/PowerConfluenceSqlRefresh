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
        $RefreshId
    )
    
    begin {
    }
    
    process {
        $hostUrl = "https://" + ([System.Uri]$Data._links.self).Host + "/wiki"
        [PSCustomObject]@{
            Space_Id = [string]$Data.id
            Space_Key = $Data.key
            Name = $Data.name
            Type = $Data.type
            Status = $Data.status
            Icon_Url = $hostUrl + $Data.icon.path
            Icon_Height = $Data.icon.height
            Icon_Width = $Data.icon.width
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}