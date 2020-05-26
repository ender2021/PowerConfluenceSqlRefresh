function Read-ConfluenceUser {
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
        $hostUrl = "https://" + ([System.Uri]$Data._links.self).Host
        [PSCustomObject]@{
            Account_Id = [string]$Data.accountId
            Account_Type = $Data.accountType
            Display_Name = $Data.displayName
            Public_Name = if($Data.publicName) {$Data.publicName} else {$null}
            Profile_Picture_Url = $hostUrl + $Data.profilePicture.path
            Profile_Picture_Height = $Data.profilePicture.height
            Profile_Picture_Width = $Data.profilePicture.width
            Email = $Data.email
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}