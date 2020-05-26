function Sync-ConfluenceStaging {
    [CmdletBinding()]
    param (
        # The sql instance to update data in
        [Parameter(Mandatory,Position=0)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=1)]
        [string]
        $SqlDatabase
    )
    
    begin {
        Write-Verbose "Synchronizing staging tables to production tables"
    }
    
    process {
        Invoke-SqlCmd -ServerInstance $SqlInstance -Database $SqlDatabase -Query "EXEC dbo.usp_Confluence_Staging_Synchronize"
    }
    
    end {
    }
}