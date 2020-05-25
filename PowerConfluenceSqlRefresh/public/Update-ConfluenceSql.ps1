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

        #configure the database targets
        $sqlSplat = @{
            SqlInstance = $SqlInstance
            SqlDatabase = $SqlDatabase
        }

        #setup the sync options
        $options = Get-DefaultSyncOptions
        if ($SyncOptions) {
            $options = Merge-Hashtable -Source $SyncOptions -Target $options
        }

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
        $refreshId = Start-ConfluenceRefresh -RefreshType @sqlSplat
    }
    
    process {
        ####################################################
        #  REFRESH STEP 0 - CONFIGURE                      #
        ####################################################

        # define a convenient hash for splatting the basic refresh arguments
        $refreshSplat = @{
            RefreshId = $refreshId
        } + $sqlSplat

        ####################################################
        #  REFRESH STEP 1 - NO CONTEXT DATA                #
        ####################################################

        # these are mostly lookup tables
        # if ($options.ProjectCategories) { Update-JiraProjectCategories @refreshSplat } else { Write-Verbose "Skipping Project Categories" }
        # if ($options.StatusCategories) { Update-JiraStatusCategories @refreshSplat } else { Write-Verbose "Skipping Status Categories" }
        # if ($options.Statuses) { Update-JiraStatuses @refreshSplat } else { Write-Verbose "Skipping Statuses" }
        # if ($options.Resolutions) { Update-JiraResolutions @refreshSplat } else { Write-Verbose "Skipping Resolutions" }
        # if ($options.Priorities) { Update-JiraPriorities @refreshSplat } else { Write-Verbose "Skipping Priorities" }
        # if ($options.IssueLinkTypes) { Update-JiraIssueLinkTypes @refreshSplat } else { Write-Verbose "Skipping Issue Link Types" }
        # if ($options.Users) { Update-JiraUsers @refreshSplat } else { Write-Verbose "Skipping Users" }

        
        

        ####################################################
        #  REFRESH STEP X - SYNC STAGING TO LIVE TABLES    #
        ####################################################

        #perform the sync
        Sync-ConfluenceStaging -SyncDeleted $syncDelete @sqlSplat
    }
    
    end {
        ####################################################
        #  RECORD BATCH END                                #
        ####################################################

        Stop-ConfluenceRefresh @refreshSplat

        Write-Verbose "Confluence update completed!"
    }
}