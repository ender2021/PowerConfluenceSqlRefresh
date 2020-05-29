<#

.SYNOPSIS
	Get an object containing the default options for which Confluence data elements will be synced

.DESCRIPTION
    Returns a hash with properties for each individually retrieved data object
    Each property contains either $true or $false to indicate whether it is synced by default
    Retrieve this object and modify the values, then supply it to Update-ConfluenceSql to modify the default settings

#>
function Get-DefaultConfluenceSyncOptions {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        @{
            Users = $true
            Groups = @{
                Users = $true
            }
            Spaces = @{
                Permissions = $true
            }
        }
    }
    
    end {
        
    }
}