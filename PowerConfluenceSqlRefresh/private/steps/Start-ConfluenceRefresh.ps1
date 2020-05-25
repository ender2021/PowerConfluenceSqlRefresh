function Start-ConfluenceRefresh {
    [CmdletBinding()]
    param (
        # The sql instance to update data in
        [Parameter(Mandatory,Position=0)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=1)]
        [string]
        $SqlDatabase,

        # The schema to use when updating data
        [Parameter(Position=2)]
        [string]
        $SchemaName="dbo"
    )
    
    begin {
        Write-Verbose "Recording Confluence Refresh start"
    }
    
    process {
        #invoke the sproc to start a refresh and return the id it gives us
        (Invoke-SqlCmd -ServerInstance $SqlInstance -Database $SqlDatabase -Query "EXEC dbo.usp_Confluence_Refresh_Start").Refresh_Id
    }
    
    end {
    }
}