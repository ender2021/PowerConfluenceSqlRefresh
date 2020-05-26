function Read-ConfluenceGroup {
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
        [PSCustomObject]@{
            Group_Name = [string]$Data.name
            Group_Id = $Data.id
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}