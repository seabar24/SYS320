# Storyling: Writing a program that gets all Services. Filters services based on user's answer for: running, stopped, and all.

$validOptions = @('all', 'stopped', 'running', 'quit')

function List-ServicesByStatus {
    param ([string]$status)

    $services = Get-Service | Where-Object { $_.Status -eq $status }
    $services

}

while($true) {

    cls
    Write-Host "Service Status Viewer"
    Write-Host "1. View all services"
    Write-Host "2. View running services"
    Write-Host "3. View stopped services"
    Write-Host "Q|q. Quit"

    $choice = Read-Host "Enter your choice: "

    if ($choice -in 1..3) {
        $chosen = $validOptions[$choice - 1]
        $services = List-SevicesByStatus $chosen

        Write-Host $services

        if ($services.Count -eq 0) {
            Write-Host -BackgroundColor red -ForegroundColor white "No services with the status: $chosen"
        } else {
            Write-Host -BackgroundColor green -ForegroundColor white "Services with status: $chosen"
            $services | Format-Table -AutoSize
        }

    } elseif ($chosen -match "^[qQ]$") {
        
            # Stop executing the program and close the script
            break

    } else {
        write-host -BackgroundColor red -ForegroundColor white "`nWRONG WRONG WRONG.`n NUH UH NUH UH."
    }
    }