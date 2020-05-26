function Update-ConfluenceGroupsUsers {
    [CmdletBinding()]
    param (
        # The names of the groups to retrieve users for
        [Parameter(Mandatory,Position=0)]
        [string[]]
        $Groups,

        # The ID value of the refresh underway
        [Parameter(Mandatory,Position=1)]
        [int]
        $RefreshId,

        # The sql instance to update data in
        [Parameter(Mandatory,Position=2)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=3)]
        [string]
        $SqlDatabase,

        # The schema to use when updating data
        [Parameter(Position=4)]
        [string]
        $SchemaName="dbo"
    )
    
    begin {
        Write-Verbose "Updating Group Users"
        $tableName = "tbl_stg_Confluence_User_Group"
        $userGroups = @()
    }
    
    process {
        Write-Verbose "Getting Groups' Users"

        foreach ($g in $Groups) {
            $userGroups += Get-ConfluenceGroupsUsers $g | Read-ConfluenceGroupUser -Group $g -RefreshId $RefreshId
        }
    }
    
    end {
        Write-Verbose "Writing Groups' Users to staging table"
        $userGroups | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $tableName
    }
}