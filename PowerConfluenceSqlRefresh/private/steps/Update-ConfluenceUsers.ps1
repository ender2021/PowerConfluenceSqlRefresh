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

        $users = Get-ConfluenceGroupsUsers confluence-users
    }
    
    end {
        Write-Verbose "Writing Users to staging table"
        $users | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $tableName
    }
}