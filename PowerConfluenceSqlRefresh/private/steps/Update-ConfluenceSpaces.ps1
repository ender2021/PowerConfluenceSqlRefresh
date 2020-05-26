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
        $getPermissions = $null -ne $SyncOptions -and $SyncOptions.ContainsKey("Permissions") -and $SyncOptions.Permissions -ne $false
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
            if ($getPermissions) { $restParams.Expand.Add("permissions") }
            $results = Invoke-ConfluenceGetSpaces @restParams

            #map spaces
            $mappedSpaces = $results.results | Read-ConfluenceSpace -RefreshId $RefreshId

            #add to list, checking for duplicates
            $existingKeys = @()
            $existingKeys += $spaces | ForEach-Object { $_.Space_Key }
            $newSpaces = $mappedSpaces | Where-Object { $existingKeys -notcontains $_.Space_Key }
            $spaces += $newSpaces

            #handle permissions storage, if configured
            if ($getPermissions) {
                #TODO: add permission storage handling
            }
            
            #check how many results came back
            $returnCount = $results.size

            #move the start marker forward
            $currentPage += 1

            #loop again if we got the max number of results (implying that we haven't go them all yet)
        } while ($returnCount -eq $limit)
    }
    
    end {
        Write-Verbose "Writing Spaces to staging table"
        $spaces | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $spaceTableName -Force
    }
}