# Script to manage Azure SQL Database Firewall Rules
# Ensure Az PowerShell module is installed and user is logged in

# Prompt for input using Read-Host
$resourceGroupName = Read-Host "Enter the resource group name"
$serverName = Read-Host "Enter the SQL server name"
$ruleName = Read-Host "Enter the firewall rule name"
$action = Read-Host "Enter the action (create, update, delete)"

# If creating or updating, prompt for IP addresses
if ($action -eq "create" -or $action -eq "update") {
    $startIPAddress = Read-Host "Enter the starting IP address for the rule"
    $endIPAddress = Read-Host "Enter the ending IP address for the rule"
}

# Function to create or update a firewall rule
function Set-FirewallRule {
    param (
        [string]$resourceGroupName,
        [string]$serverName,
        [string]$ruleName,
        [string]$startIPAddress,
        [string]$endIPAddress
    )
    
    # Create or update firewall rule
    Write-Host "Setting firewall rule '$ruleName'..."
    New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName -ServerName $serverName `
        -FirewallRuleName $ruleName -StartIpAddress $startIPAddress -EndIpAddress $endIPAddress -Force
    Write-Host "Firewall rule '$ruleName' set successfully."
}

# Function to delete a firewall rule
function Remove-FirewallRule {
    param (
        [string]$resourceGroupName,
        [string]$serverName,
        [string]$ruleName
    )
    
    # Delete firewall rule
    Write-Host "Deleting firewall rule '$ruleName'..."
    Remove-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName -ServerName $serverName `
        -FirewallRuleName $ruleName -Force
    Write-Host "Firewall rule '$ruleName' deleted successfully."
}

# Main Script Logic
switch ($action) {
    "create" {
        Set-FirewallRule -resourceGroupName $resourceGroupName -serverName $serverName `
            -ruleName $ruleName -startIPAddress $startIPAddress -endIPAddress $endIPAddress
    }
    "update" {
        Set-FirewallRule -resourceGroupName $resourceGroupName -serverName $serverName `
            -ruleName $ruleName -startIPAddress $startIPAddress -endIPAddress $endIPAddress
    }
    "delete" {
        Remove-FirewallRule -resourceGroupName $resourceGroupName -serverName $serverName `
            -ruleName $ruleName
    }
    default {
        Write-Host "Invalid action specified. Use 'create', 'update', or 'delete'."
    }
}
