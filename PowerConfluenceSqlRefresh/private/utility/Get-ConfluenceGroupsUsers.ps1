function Get-ConfluenceGroupsUsers {
    [CmdletBinding()]
    param (
        # the name of the group to get users for
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("Group_Name")]
        [string]
        $Group
    )
    
    begin {
        $users = @()
    }
    
    process {
        #set up to loop through results (there is a limit of 200 per call, so we have to loop to make sure we got them all)
        $limit = 200
        $currentPage = 1
        $returnCount = 0
        do {
            Write-Verbose "Fetching Page $currentPage of users for $Group"
            #get a response
            $results = Invoke-ConfluenceGetGroupMembers $Group -MaxResults $limit -StartAt ($limit * ($currentPage - 1))

            #map users
            $mappedUsers = $results.results | Read-ConfluenceUser -RefreshId $RefreshId

            #add to list, checking for duplicates
            $existingIds = @()
            $existingIds += $users | ForEach-Object { $_.Account_Id }
            $users += $mappedUsers | Where-Object { $existingIds -notcontains $_ }
            
            #check how many results came back
            $returnCount = $results.size

            #move the start marker forward
            $currentPage += 1

            #loop again if we got the max number of results (implying that we haven't go them all yet)
        } while ($returnCount -eq $limit)
    }
    
    end {
        $users
    }
}