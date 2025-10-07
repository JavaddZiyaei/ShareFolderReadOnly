# ==============================
# PowerShell Script: SHARE + TAKLIF via Advanced Sharing
# Author: Tadbir Network
# ==============================

# ------------------------------
# Paths
# ------------------------------
$sharePath = "D:\SHARE"
$taklifPath = "D:\TAKLIF"

# ------------------------------
# Create base folders
# ------------------------------
if (!(Test-Path $sharePath)) { New-Item -Path $sharePath -ItemType Directory | Out-Null }
if (!(Test-Path $taklifPath)) { New-Item -Path $taklifPath -ItemType Directory | Out-Null }
Write-Host "Base folders ready." -ForegroundColor Green

# ------------------------------
# PART 1: SHARE folder → Advanced Share, Everyone Read
# ------------------------------
$shareName = "SHARE"

# Remove old share if exists
if (Get-SmbShare -Name $shareName -ErrorAction SilentlyContinue) {
    Remove-SmbShare -Name $shareName -Force
    Write-Host "Old SHARE removed." -ForegroundColor Yellow
}

# Create Advanced Share with Everyone → Read
New-SmbShare -Name $shareName -Path $sharePath -ReadAccess "Everyone" -FullAccess "Administrators" | Out-Null
Write-Host "SHARE folder shared via Advanced Sharing (Read for Everyone)." -ForegroundColor Cyan

# Set NTFS permissions: Everyone → Read
$acl = Get-Acl $sharePath
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.SetAccessRuleProtection($true, $false)
$acl.ResetAccessRule($rule)
Set-Acl -Path $sharePath -AclObject $acl
Write-Host "NTFS permissions for SHARE set: Everyone → Read" -ForegroundColor Cyan

# ------------------------------
# PART 2: TAKLIF user folders
# ------------------------------
$users = Get-LocalUser | Where-Object { $_.Name -match '^pc\d+$' }

foreach ($user in $users) {
    $username = $user.Name
    $userFolder = Join-Path $taklifPath $username

    # Create user folder if not exist
    if (!(Test-Path $userFolder)) {
        New-Item -Path $userFolder -ItemType Directory | Out-Null
        Write-Host "Folder created: $username" -ForegroundColor Green
    }

    # Remove old share if exists
    if (Get-SmbShare -Name $username -ErrorAction SilentlyContinue) {
        Remove-SmbShare -Name $username -Force
        Write-Host "Old share for $username removed." -ForegroundColor Yellow
    }

    # Create Advanced Share for this user → Read/Change (ReadWrite)
    New-SmbShare -Name $username -Path $userFolder -ChangeAccess $username -FullAccess "Administrators" | Out-Null
    Write-Host "Shared folder $username for user $username (Read/Write)." -ForegroundColor Cyan

    # NTFS permissions → only this user
    $acl = New-Object System.Security.AccessControl.DirectorySecurity
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($username, "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)
    Set-Acl -Path $userFolder -AclObject $acl
    Write-Host "NTFS permissions set for $username folder (Read/Write for $username)." -ForegroundColor Cyan
}

Write-Host "`nAll operations completed successfully!" -ForegroundColor Green
