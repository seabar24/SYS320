# Storyling: Writing a program that gets all Services. Filters services based on user's answer for: running, stopped, and all.

# $validOptions = @('all', 'stopped', 'running', 'quit')

# Function that checks for all service logs. All, running, or stopped.
function service_log() {

    cls

    #$services = @('all', 'stopped', 'running')

    Write-Host "1. All"

    Write-Host "2. Stopped"

    Write-Host "3. Running"

    # Accept the user input and determine whether they selected option 1,2,3 or to quit.
    $input = Read-Host -Prompt "Select an option to view, or enter q to quit"
    
    # All Services
    if ($input -eq "1" -or $input -eq "all" -or $input -eq "All") {

        Write-Host " "
        Get-Service
        read-host -Prompt "`n`nPress enter when finished."
        service_log
    }

    # Stopped Services
    elseif ($input -eq "2" -or $input -eq "stopped" -or $input -eq "Stopped") {

        Write-Host " "
        Get-Service | Where-Object { $_.Status -eq "stopped" }
        read-host -Prompt "`n`nPress enter when finished."
        service_log

    }

    # Running Services
    elseif ($input -eq "3" -or $input -eq "running" -or $input -eq "Running") {

        Write-Host " "
        Get-Service | Where-Object { $_.Status -eq "running" }
        read-host -Prompt "`n`nPress enter when finished."
        service_log
    }
    # Quit the program
    elseif ($input -match "^[qQ]$") {

        break
    }

    # When the input is not one of the above
    else {

        write-host -BackgroundColor red -ForegroundColor white "`nWRONG WRONG WRONG.`n NUH UH NUH UH."
        sleep 2
        service_log
    }

}
service_log