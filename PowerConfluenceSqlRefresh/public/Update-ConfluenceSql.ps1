<#

.SYNOPSIS
	Update a Confluence SQL database with data from a Confluence Cloud instance

.DESCRIPTION
    Executes the necessary steps to update a SQL datastore of Confluence data from a Confluence Cloud instance
    A PowerConfluence Session must be opened with Open-ConfluenceSession before calling this method

.PARAMETER SpaceKeys
    Supply this parameter in order to limit the refresh to a specified set of spaces.
    Without this parameter, the method will update all spaces

.PARAMETER SqlInstance
	The connection string for the SQL instance where the data will be updated

.PARAMETER SqlDatabase
    The name of the database to perform updates in

.PARAMETER SyncOptions
    A hashtable of options to configure which data elements to synchronize
    
.EXAMPLE
    Open-ConfluenceSession @ConfluenceConnectionDetails
	Update-Confluence -RefreshType (Get-ConfluenceRefreshTypes).Full -SqlInstance localhost -SqlDatabase Confluence
    Close-ConfluenceSession

	Performs a full refresh of all Confluence projects on a local sql database

.EXAMPLE
    Open-ConfluenceSession @ConfluenceConnectionDetails
    $Params = @{
        RefreshType = (Get-ConfluenceRefreshTypes).Differential
        SpaceKeys = @("PROJKEY","MJPK","KEY3")
        SqlInstance = "my.remote.sql.server,1234"
        SqlDatabase = "Confluence"
    }
	Update-Confluence @Params
    Close-ConfluenceSession

	Performs a differential refresh of 3 Confluence projects on a remote Sql Server

#>
function Update-ConfluenceSql {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        # Keys of specific projects to pull
        [Parameter(Position=0)]
        [string[]]
        $SpaceKeys,

        # The sql instance to update data in
        [Parameter(Mandatory,Position=1)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=2)]
        [string]
        $SqlDatabase,

        # Synchronization options to override the defaults
        [Parameter()]
        [hashtable]
        $SyncOptions
    )
    
    begin {
        Write-Verbose "Beginning Confluence data update on $SqlInstance in database $SqlDatabase"
        ####################################################
        #  CONFIGURATION                                   #
        ####################################################

        #set the cmdlet to stop on error, but remember the original setting so we can put it back later
        $originalErrorAction = $ErrorActionPreference
        $ErrorActionPreference = "Stop"

        #set up some values to track occurance of errors
        $refreshSuccess = $true
        $refreshError = $null

        #configure the database targets
        $sqlSplat = @{
            SqlInstance = $SqlInstance
            SqlDatabase = $SqlDatabase
        }

        #setup the sync options
        $options = Get-DefaultConfluenceSyncOptions
        if ($SyncOptions) {
            $options = Merge-Hashtable -Source $SyncOptions -Target $options
        }

        #test the sql connection
        Write-Verbose "Testing connection to $SqlInstance"
        if (Test-SqlConnection $SqlInstance) {
            Write-Verbose "Connection test succeeded"
        } else {
            Write-Verbose "Connection test failed! Terminating refresh"
            $ErrorActionPreference = $originalErrorAction
            return $false
        }

        try {
            ####################################################
            #  GET PREVIOUS BATCH INFO / CLEAR PREVIOUS BATCH  #
            ####################################################
            
            $lastRefresh = Get-LastConfluenceRefresh @sqlSplat
            $lastRefreshStamp = $lastRefresh.Refresh_Start_Unix
            $lastRefreshDate = $lastRefresh.Refresh_Start

            ####################################################
            #  BEGIN THE REFRESH BATCH                         #
            ####################################################

            Clear-ConfluenceStaging @sqlSplat
            $refreshId = Start-ConfluenceRefresh @sqlSplat
        } catch {
            Write-Verbose "Error while initiating the batch! Terminating refresh"
            $ErrorActionPreference = $originalErrorAction
            Write-Error $_
            return $false
        }
        
    }
    
    process {
        try {
            ####################################################
            #  REFRESH STEP 0 - CONFIGURE                      #
            ####################################################

            # define a convenient hash for splatting the basic refresh arguments
            $refreshSplat = @{
                RefreshId = $refreshId
            } + $sqlSplat

            ####################################################
            #  REFRESH STEP 1 - USERS / GROUPS                 #
            ####################################################

            if ($options.ContainsKey("Users") -and $options.Users -ne $false) { Update-ConfluenceUsers @refreshSplat } else { Write-Verbose "Skipping Users" }
            if ($options.ContainsKey("Groups") -and $options.Groups -ne $false) {
                $groups = Update-ConfluenceGroups @refreshSplat | ForEach-Object { $_.Group_Name }
                if ($options.Groups.ContainsKey("Users") -and $options.Groups.Users -ne $false) { Update-ConfluenceGroupsUsers $groups @refreshSplat } else { Write-Verbose "Skipping Groups' Users" }
            } else { Write-Verbose "Skipping Groups" }

            ####################################################
            #  REFRESH STEP 2 - SPACES                         #
            ####################################################

            if ($options.ContainsKey("Spaces") -and $options.Spaces -ne $false) {
                $settings = IIF ($options.Spaces.GetType().Name -eq "Hashtable") $options.Spaces $null
                Update-ConfluenceSpaces $SpaceKeys $settings @refreshSplat
            } else { Write-Verbose "Skipping Users" }

            ####################################################
            #  REFRESH STEP X - SYNC STAGING TO LIVE TABLES    #
            ####################################################

            #perform the sync
            Sync-ConfluenceStaging @sqlSplat
        } catch {
            ####################################################
            #  HANDLE ERROR OCCURING DURING REFRESH            #
            ####################################################
            Write-Verbose "Error while executing the batch! Terminating refresh"
            $refreshSuccess = $false
            $refreshError = $_
        }
    }
    
    end {
        ####################################################
        #  RECORD BATCH END                                #
        ####################################################
        $batchTermError = $null
        try {
            Stop-ConfluenceRefresh @refreshSplat -Success $refreshSuccess
        } catch {
            Write-Verbose "Error while recording batch end! Exiting without recording"
            $refreshSuccess = $false
            $batchTermError = $_
        }

        ####################################################
        #  RETURN SUCCESS / FAILURE, OUTPUT ERRORS         #
        ####################################################
        $ErrorActionPreference = $originalErrorAction
        if ($refreshSuccess) {
            Write-Verbose "Confluence update completed successfully!"
            return $true
        } else {
            Write-Verbose "Confluence updated completed with errors :("
            if ($refreshError) {
                Write-Verbose "Terminating Error:"
                Write-Error $refreshError
            }
            if ($batchTermError) {
                Write-Verbose "Batch End Recording Error:"
                Write-Error $batchTermError
            }

            return $false
        }
    }
}