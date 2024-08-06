# Remote System Information Gathering Script

This PowerShell script is designed to gather comprehensive system information from a list of remote systems, facilitating remote monitoring and management. It sets up the parameters including a list of remote systems, user credentials, and an output directory for storing the collected information. The script ensures the output directory exists, creating it if necessary.

The core functionality is encapsulated in the Get-SystemInformation function, which takes a computer name and credentials as input. For each remote system, the function collects information on installed software, running processes, and network configuration using Invoke-Command to execute commands on the remote systems. The collected data is formatted and written to a text file named after the remote system in the output directory.

The script iterates over each remote system in the list, invoking the Get-SystemInformation function to gather and store the information, logging the success or failure of each operation. This script is useful for administrators needing to remotely audit and document the configuration and status of multiple systems in a network.
