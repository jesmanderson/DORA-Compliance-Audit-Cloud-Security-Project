<# 
Azure AD / Entra ID IAM Audit Script (Example)
Prereqs:
- Install-Module AzureAD -Scope CurrentUser
- Install-Module Microsoft.Graph -Scope CurrentUser
Login:
- Connect-AzureAD
- Connect-MgGraph -Scopes "Policy.Read.All","Directory.Read.All"
Output:
- CSV reports in ./output
#>

param(
    [string]$OutputPath = ".\output"
)

if (!(Test-Path $OutputPath)) { New-Item -ItemType Directory -Path $OutputPath | Out-Null }

Import-Module AzureAD -ErrorAction SilentlyContinue
Import-Module Microsoft.Graph -ErrorAction SilentlyContinue

# 1. Users + MFA (per-user) status via MSOnline/AzureAD props (fallback approach)
try {
    Import-Module MSOnline -ErrorAction SilentlyContinue
    Connect-MsolService -ErrorAction Stop
    $users = Get-MsolUser -All
    $mfaReport = $users | Select-Object DisplayName, UserPrincipalName, BlockCredential,
        @{n="MFAEnabled"; e = { $_.StrongAuthenticationMethods.Count -gt 0 }}
    $mfaReport | Export-Csv -NoTypeInformation -Path (Join-Path $OutputPath "azuread_users_mfa.csv")
} catch {
    Write-Warning "MSOnline module not available or not connected. Skipping per-user MFA check."
}

# 2. Conditional Access Policies (Graph)
try {
    Connect-MgGraph -Scopes "Policy.Read.All","Directory.Read.All"
    Select-MgProfile -Name "beta"
    $cap = Get-MgIdentityConditionalAccessPolicy -All
    $cap | Select-Object Id,DisplayName,State,CreatedDateTime | Export-Csv -NoTypeInformation -Path (Join-Path $OutputPath "conditional_access_policies.csv")
} catch {
    Write-Warning "Graph connection failed for Conditional Access policies."
}

# 3. Directory roles & members
$roles = Get-AzureADDirectoryRole -ErrorAction SilentlyContinue
$roleReport = foreach ($r in $roles) {
    $members = Get-AzureADDirectoryRoleMember -ObjectId $r.ObjectId -All $true -ErrorAction SilentlyContinue
    [pscustomobject]@{
        RoleDisplayName = $r.DisplayName
        MemberUPNs = ($members | ForEach-Object { $_.UserPrincipalName }) -join ";"
        MemberCount = ($members | Measure-Object).Count
    }
}
$roleReport | Export-Csv -NoTypeInformation -Path (Join-Path $OutputPath "azuread_directory_roles.csv")

Write-Host "Azure AD audit complete. Files saved to $OutputPath"
