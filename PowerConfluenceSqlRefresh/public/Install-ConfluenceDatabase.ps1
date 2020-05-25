<#

.SYNOPSIS
	Install the Confluence database objects used by the PowerConfluenceSqlRefresh module

.DESCRIPTION
    Runs SQL scripts embedded in the PowerConfluenceSqlRefresh module to create objects and data
    First creates all schema objects, then populates lookup tables with data

.PARAMETER SqlInstance
	The connection string for the SQL instance to install the Confluence database on

.PARAMETER SqlDatabase
	The name of the database to install the Confluence objects and data in

.PARAMETER Username
    The username of the account that will be executing the module
    
.PARAMETER CreateUser
    Set this switch to create the user in the database before adding it to the ConfluenceRefreshRole

.EXAMPLE
	Install-ConfluenceDatabase -SqlInstance localhost -SqlDatabase Confluence -Username "DOMAIN\MyConfluenceUser"

	Installs objects and data on the local machine in a database called "Confluence"

.EXAMPLE
	Install-ConfluenceDatabase -SqlInstance "my.remote.sql.server,1234" -SqlDatabase Confluence -Username "DOMAIN\MyConfluenceUser" -CreateUser

	Installs objects and data on a remote Sql Server in a database called "Confluence", and creates the user in the database
#>
function Install-ConfluenceDatabase {
    [CmdletBinding()]
    param (
        # The sql instance of the install database
        [Parameter(Mandatory,Position=0)]
        [string]
        $SqlInstance,

        # The name of the install sql database
        [Parameter(Mandatory,Position=1)]
        [string]
        $SqlDatabase,

        # The user that will execute the Confluence Refresh
        [Parameter(Mandatory,Position=2)]
        [string]
        $Username,

        # Set this switch to create the user in the database before adding it to the role
        [Parameter()]
        [switch]
        $CreateUser
    )
    
    begin {
        Write-Verbose "Installing Confluence database on $SqlInstance in database $SqlDatabase"
    }
    
    process {
        Write-Verbose "Creating database objects"
        $objectsResult = Invoke-SqlCmd -ServerInstance $SqlInstance -Database $SqlDatabase -InputFile $global:PowerConfluenceSqlRefresh.SqlObjectsPath

        if ($CreateUser) {
            Write-Verbose "Creating user $Username"
            $createUserResult = Invoke-SqlCmd -ServerInstance $SqlInstance -Database $SqlDatabase -Query "CREATE USER [$Username]"
        }

        Write-Verbose "Adding user $Username to ConfluenceRefreshRole role"
        $addUserResult = Invoke-SqlCmd -ServerInstance $SqlInstance -Database $SqlDatabase -Query "ALTER ROLE [ConfluenceRefreshRole] ADD MEMBER [$Username]"

        Write-Verbose "Creating lookup table data"
        $lookupResult = Invoke-SqlCmd -ServerInstance $SqlInstance -Database $SqlDatabase -InputFile $global:PowerConfluenceSqlRefresh.SqlLookupsPath
    }
    
    end {
        Write-Verbose "Confluence database installation completed"
    }
}