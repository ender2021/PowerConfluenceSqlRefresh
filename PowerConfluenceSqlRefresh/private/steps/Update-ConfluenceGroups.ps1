function Update-ConfluenceGroups {
    [CmdletBinding()]
    param (
        # The ID value of the refresh underway
        [Parameter(Mandatory,Position=0)]
        [int]
        $RefreshId,

        # The sql instance to update data in
        [Parameter(Mandatory,Position=1)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=2)]
        [string]
        $SqlDatabase,

        # The schema to use when updating data
        [Parameter(Position=3)]
        [string]
        $SchemaName="dbo"
    )
    
    begin {
        Write-Verbose "Updating Groups"
        $tableName = "tbl_stg_Confluence_Group"
        $groups = @()
    }
    
    process {
        Write-Verbose "Getting Groups"

        #set up to loop through results (there is a limit of 200 per call, so we have to loop to make sure we got them all)
        $limit = 200
        $start = 0
        $returnCount = 0
        do {
            #get a response
            $results = Invoke-ConfluenceGetGroups -MaxResults $limit -StartAt $start

            #map groups
            $mappedGroups = $results.results | Read-ConfluenceGroup -RefreshId $RefreshId

            #add to list, checking for duplicates
            $existingIds = @()
            $existingIds += $groups | ForEach-Object { $_.Group_Id }
            $groups += $mappedGroups | Where-Object { $existingIds -notcontains $_ }
            
            #check how many results came back
            $returnCount = $results.size

            #move the start marker forward
            $start += $limit

            #loop again if we got the max number of results (implying that we haven't go them all yet)
        } while ($returnCount -eq $limit)
    }
    
    end {
        Write-Verbose "Writing Groups to staging table"
        $groups | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $tableName
    }
}