# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# Ensure the script is run with administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "This script must be run with administrator privileges!"
    exit
}

# Function to stop processes by name
function Stop-ProcessesByName {
    param (
        [string[]]$ProcessNames
    )
    foreach ($process in $ProcessNames)
    {
        Get-Process -Name $process -ErrorAction SilentlyContinue | ForEach-Object {
            try
            {
                Stop-Process -Id $_.Id -Force
                Write-Host "Stopped process: $($process)"
            }
            catch
            {
                Write-Warning "Failed to stop process: $($process). Error: $_"
            }
        }
    }
}

# Function to retry file deletion with permissions adjustment
function Remove-ItemWithRetryAndPermissions {
    param (
        [string]$Path,
        [int]$RetryCount = 3,
        [int]$SleepSeconds = 2
    )

    for ($i = 0; $i -lt $RetryCount; $i++) {
        try {
            # Try to adjust permissions
            $acl = Get-Acl -Path $Path
            $acl | Set-Acl
            Write-Host "Adjusted permissions for: $Path"

            # Try to delete the item
            Remove-Item -Path $Path -Recurse -Force -ErrorAction Stop
            Write-Host "Deleted directory: $Path"
            return
        }
        catch {
            Write-Warning "Failed to delete directory: $Path. Attempt $($i + 1) of $RetryCount. Error: $_"
            Start-Sleep -Seconds $SleepSeconds
        }
    }

    Write-Warning "Failed to delete directory after $RetryCount attempts: $Path"
}

# Stop all Edge and EdgeUpdate processes
$processes = @("msedge", "edgeupdate", "edgewebview2", "edgeinstaller")
Stop-ProcessesByName -ProcessNames $processes

# Pause for a moment to ensure all processes are stopped
Start-Sleep -Seconds 5

# Path to the directory
$basePath = "C:\Program Files (x86)\Microsoft"

# Get all directories that start with "Edge"
$edgeDirs = Get-ChildItem -Path $basePath -Directory | Where-Object { $_.Name -like "Edge*" }

foreach ($dir in $edgeDirs)
{
    Remove-ItemWithRetryAndPermissions -Path $dir.FullName
}

# Remove remaining registry entries
$RegistryPaths = @(
    "HKLM:\SOFTWARE\Microsoft\EdgeUpdate",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate",
    "HKCU:\Software\Microsoft\Edge"
)

foreach ($path in $RegistryPaths)
{
    if (Test-Path $path)
    {
        try
        {
            Remove-Item -Path $path -Recurse -Force
            Write-Host "Registry entry $path has been removed."
        }
        catch
        {
            Write-Warning "Failed to remove registry entry: $path. Error: $_"
        }
    }
}

Write-Host "Completed deletion of Edge processes, directories, and registry entries."
