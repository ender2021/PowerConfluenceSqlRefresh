function Read-ConfluenceGroupUser {
    [CmdletBinding()]
    param (
        # The name of the group being mapped
        [Parameter(Mandatory,Position=0)]
        [string]
        $Group,

        # User object (should be pre-converted by Read-ConfluenceUser)
        [Parameter(Mandatory,Position=1,ValueFromPipeline)]
        [pscustomobject]
        $Data,

        # Refresh ID
        [Parameter(Mandatory,Position=2)]
        [int]
        $RefreshId
    )
    
    begin {
    }
    
    process {
        [PSCustomObject]@{
            Account_Id = $Data.Account_Id
            Group_Name = $Group
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}