function Update-ConfluenceUsers {
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
        Write-Verbose "Updating Users"
        $tableName = "tbl_stg_Confluence_User"
        $users = @()
    }
    
    process {
        Write-Verbose "Getting Users"

        #set up to loop through results (there is a limit of 200 per call, so we have to loop to make sure we got them all)
        $limit = 200
        $start = 0
        $returnCount = 0
        do {
            #get a response
            $results = Invoke-ConfluenceGetGroupMembers confluence-users -MaxResults $limit -StartAt $start

            #map users
            $mappedUsers = $results.results | Read-ConfluenceUser -RefreshId $RefreshId

            #add to list, checking for duplicates
            $existingIds = @()
            $existingIds += $users | ForEach-Object { $_.Account_Id }
            $users += $mappedUsers | Where-Object { $existingIds -notcontains $_ }
            
            #check how many results came back
            $returnCount = $results.size

            #move the start marker forward
            $start += $limit

            #loop again if we got the max number of results (implying that we haven't go them all yet)
        } while ($returnCount -eq $limit)
    }
    
    end {
        Write-Verbose "Writing Users to staging table"
        $users | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $tableName
    }
}