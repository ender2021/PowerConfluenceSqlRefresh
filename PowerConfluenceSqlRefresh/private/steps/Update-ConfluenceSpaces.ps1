function Update-ConfluenceSpaces {
    [CmdletBinding()]
    param (
        # Keys of specific spaces to pull (if null/empty, will get all spaces)
        [Parameter(Position=0)]
        [string[]]
        $SpaceKeys = @(),

        # Synchronization options for spaces
        [Parameter(Position=1)]
        [AllowNull()]
        [hashtable]
        $SyncOptions,

        # The ID value of the refresh underway
        [Parameter(Mandatory,Position=2)]
        [int]
        $RefreshId,

        # The sql instance to update data in
        [Parameter(Mandatory,Position=3)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=4)]
        [string]
        $SqlDatabase,

        # The schema to use when updating data
        [Parameter(Position=5)]
        [string]
        $SchemaName="dbo"
    )
    
    begin {
        Write-Verbose "Updating Spaces"
        $spaceTableName = "tbl_stg_Confluence_Space"
        $spaces = @()

        $permissionTableName = "tbl_stg_Confluence_Space_Permission"
        $permissions = @()
        $getPermissions = $null -ne $SyncOptions -and $SyncOptions.ContainsKey("Permissions") -and $SyncOptions.Permissions -ne $false
        if (!$getPermissions) { Write-Verbose "Skipping Space Permissions" }
    }
    
    process {
        #set up to loop through results (there is a limit of 25 per call, so we have to loop to make sure we got them all)
        $limit = 25
        $currentPage = 1
        $returnCount = 0
        do {
            Write-Verbose "Fetching Page $currentPage of spaces"
            #get a response
            $restParams = @{
                MaxResults = $limit
                StartAt = $limit * ($currentPage - 1)
                Expand = @("icon")
            }
            if ($null -ne $SpaceKeys -and $SpaceKeys.Count -gt 0) { $restParams.Add("SpaceKeys", $SpaceKeys) }
            if ($getPermissions) { $restParams.Expand += "permissions" }
            $results = Invoke-ConfluenceGetSpaces @restParams

            #map spaces
            $mappedSpaces = $results.results | Read-ConfluenceSpace -RefreshId $RefreshId -ReadPermissions:$getPermissions

            #look for and remove duplicates
            $existingKeys = @()
            $existingKeys += $spaces | ForEach-Object { $_.Space_Key }
            $newSpaces = $mappedSpaces | Where-Object { $existingKeys -notcontains $_.Space_Key }

            #handle permissions storage, if configured
            if ($getPermissions) {
                #get the permissions objects, then remove the property from the space objects so it's not written to the db
                $permissions += $newSpaces | ForEach-Object { $_.Permissions }
                $newSpaces = $newSpaces | Select-Object -ExcludeProperty Permissions -Property '*'
            }

            #add space results to master list, checking for duplicates
            $spaces += $newSpaces

            #check how many results came back
            $returnCount = $results.size

            #move the start marker forward
            $currentPage += 1

            #loop again if we got the max number of results (implying that we haven't go them all yet)
        } while ($returnCount -eq $limit)
    }
    
    end {
        $spacesCount = $spaces.Count
        Write-Verbose "Writing $spacesCount Space record(s) to staging table"
        $spaces | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $spaceTableName
        
        if ($getPermissions) {
            $permissionsCount = $permissions.Count
            Write-Verbose "Writing $permissionsCount Space Permission record(s) to staging table"
            $permissions | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $permissionTableName
        }
    }
}