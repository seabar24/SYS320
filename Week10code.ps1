# Storyline: View the event logs, check for a valid log, and print the results

function select_log() {

    cls 

    # List all event logs
    $theLogs = Get-EventLog -list | select Log
    $theLogs | Out-Host

    # Initialize the array to store the logs
    $arrLog = @()

    foreach ($templog in $theLogs){

        # Add each log to the array
        # NOTE: These are stored in the array as a hashtable in the format:
        # @{Log=LOGNAME}
        $arrLog += $templog
    }
    # Test to be sure our array is being populated
    # write-host $arrLog[0]

    # Prompt the user for the log to view or quit.
    $readLog = read-host -Prompt "Please enter a log from the list above or 'q' to quit the program"

    # Check if the user wants to quit.
    if ($readLog -match "^[qQ]$") {
        
        # Stop executing the program and close the script
        break
    }

    log_check -logToSearch $readLog
}

function log_check() {

    # String the user types in within the select_log function
    Param([string]$logToSearch)
    # Format the user input.
    # Example: @{Log-Security}
    $theLog = "^@{Log=" + $logToSearch + "}$"

    # Search the array for the exact hashtable string
    if ($arrLog -match $theLog){

        write-host -BackgroundColor Green -ForegroundColor white "Please wait, it may take a few moments to retrieve the log entries."
        sleep 2

        # Call the function to view the log
        view_log -logToSearch $logToSearch

    } else {

        write-host -BackgroundColor red -ForegroundColor white "WRONG WRONG WRONG.`n NUH UH NUH UH."
        
        sleep 3

        select_log

    }

}

function view_log() {

    cls

    # Get the logs
    Get-EventLog -Log $logToSearch -Newest 10 -after "10/31/2023"

    # Pause the screen and wait until the user is ready to proceed.
    read-host -Prompt "Please enter when you are done."

    # Go back to select_log
    select_log

}

#Runs the select_log as the first function
select_log