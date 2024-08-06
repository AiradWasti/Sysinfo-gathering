# Parameters
$remoteSystems = @("RemoteSystem1", "RemoteSystem2")
$username = "YourUsername"
$password = "YourPassword"
$credential = New-Object System.Management.Automation.PSCredential ($username, (ConvertTo-SecureString $password -AsPlainText -Force))
$outputDir = "C:\RemoteSystemInfo"

# Ensure the output directory exists
if (-not (Test-Path -Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir
}

# Function to gather system information
function Get-SystemInformation {
    param (
        [string]$computerName,
        [System.Management.Automation.PSCredential]$cred
    )

    # Output file
    $outputFile = Join-Path -Path $outputDir -ChildPath "$computerName.txt"
    
    try {
        # Installed software
        $installedSoftware = Invoke-Command -ComputerName $computerName -Credential $cred -ScriptBlock {
            Get-WmiObject -Class Win32_Product | Select-Object -Property Name, Version
        }
        Add-Content -Path $outputFile -Value "Installed Software:`n"
        $installedSoftware | Format-Table | Out-String | Add-Content -Path $outputFile

        # Running processes
        $runningProcesses = Invoke-Command -ComputerName $computerName -Credential $cred -ScriptBlock {
            Get-Process | Select-Object -Property Name, Id, CPU, Memory
        }
        Add-Content -Path $outputFile -Value "`nRunning Processes:`n"
        $runningProcesses | Format-Table | Out-String | Add-Content -Path $outputFile

        # Network configuration
        $networkConfig = Invoke-Command -ComputerName $computerName -Credential $cred -ScriptBlock {
            Get-NetIPConfiguration | Select-Object -Property InterfaceAlias, IPv4Address, IPv6Address, InterfaceDescription
        }
        Add-Content -Path $outputFile -Value "`nNetwork Configuration:`n"
        $networkConfig | Format-Table | Out-String | Add-Content -Path $outputFile

        Write-Output "Information gathered for $computerName."
    } catch {
        Write-Output "Failed to gather information for $computerName. Error: $_"
    }
}

# Iterate over each remote system and gather information
foreach ($system in $remoteSystems) {
    Get-SystemInformation -computerName $system -cred $credential
}
