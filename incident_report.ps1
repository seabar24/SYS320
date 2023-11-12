# Storyline: Incident Response Toolkit that retrieves the following:
# Running processes and the paths for each processes
# All registered services and paths to the exe. controlling the service
# TCP network sockets
# User account information
# NetworkAdapterConfiguration Info
# Powershell cmdlets to save 4 artifacts that would be useful in an incident response

# Main menu for Incident Report
function incident_menu (){

    cls
    Write-Host "Incident Response Toolkit"
    Write-Host "1. Running Processes"
    Write-Host "2. All Services"
    Write-Host "3. TCP Network Sockets"
    Write-Host "4. User Information"
    Write-Host "5. Network Configuration Information"
    $choice = Read-Host "`nSelect a choice above or 'q' to quit"

    # Retrieves all Running Processes and executable path
    if ($choice -eq "1") {
     
        cls
        Write-Host "`nWait a few moments for the query to retrieve the services."
        sleep 3
        cls
        $processes = Get-Process
        
        foreach ($process in $processes) {
           
            $Name = $process.ProcessName
            $exePath = $process.Path
            Write-Host "Service Name: $Name"
            Write-Host "Executable Path: $exePath"
            Write-Host ""
        }
        
        Read-Host "Press 'Enter' when you are done"
        incident_menu

    }
    #Will Query all registered services and the executable path
    elseif ($choice -eq "2") {

        cls
        $wmiQuery = "SELECT * FROM Win32_Service"
        $services = Get-WmiObject -Query $wmiQuery

        Write-Host "`nWait a few moments for the query to retrieve the services."
        sleep 3
        cls

        foreach ($service in $services) {
           
            $Name = $service.Name
            $exePath = $service.PathName
            Write-Host "Service Name: $Name"
            Write-Host "Executable Path: $exePath"
            Write-Host ""
        }
        Read-Host "Press 'Enter' when you are done"
        incident_menu
    }
    # Retrieves all TCP Network Sockets
    elseif ($choice -eq "3") {
    
        cls
        Write-Host "Wait a few moments for the query to retrieve the TCP Information."
        sleep 3
        
        cls
        Get-NetTCPConnection
        Read-Host "`nPress 'Enter' when you are done"
        incident_menu
    }
    # Retrieves User Information
    elseif ($choice -eq "4") {

        cls
        Write-Host "Wait a few moments for the query to retrieve the TCP Information."
        sleep 3
        Get-WmiObject -Class Win32_UserAccount
        Read-Host "`nPress 'Enter' when you are done"
        incident_menu
    }
    # Retrieves Network information
    elseif ($choice -eq "5") {

        cls
        Write-Host "Wait a few moments for the query to retrieve the Network Configuration."
        sleep 3
        cls
        $IP = Get-WMIobject -Class Win32_NetworkAdapterConfiguration | Where { $_.IPAddress } | Select-Object -ExpandProperty IPAddress
        $Default = Get-WMIobject -Class Win32_NetworkAdapterConfiguration | Where { $_.DefaultIPGateway } | Select-Object -ExpandProperty DefaultIPGateway
        $DNS = Get-WMIobject -Class Win32_NetworkAdapterConfiguration | Where { $_.DNSServer } | Select-Object -ExpandProperty DNSDomain
        Write-Host "IP Address: $IP"
        Write-Host "Default Gateway: $Default"
        Write-Host "Domain Name Server: $DNS"
        Read-Host "`nPress 'Enter' when you are done"
        incident_menu
    }
    # Quit the program
    elseif ($choice -match "^[qQ]$") {

        break
    }
    # If choice is not equal to any of the above
    else {

        Write-Host -BackgroundColor red -ForegroundColor white "`nHOW MANY TIMES DO WE HAVE TO TEACH THIS LESSON OLD MAN?"
        sleep 10
        incident_menu
    }
}
incident_menu