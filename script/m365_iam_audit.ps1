<# 
Microsoft 365 Audit Script (Example)
Prereqs:
- Install-Module ExchangeOnlineManagement -Scope CurrentUser
Login:
- Connect-ExchangeOnline
Output:
- CSV reports in ./output
#>

param(
    [string]$OutputPath = ".\output"
)

if (!(Test-Path $OutputPath)) { New-Item -ItemType Directory -Path $OutputPath | Out-Null }

Import-Module ExchangeOnlineManagement -ErrorAction SilentlyContinue

# 1. Unified Audit Log ingestion setting
try {
    $cfg = Get-AdminAuditLogConfig
    $cfg | Select-Object UnifiedAuditLogIngestionEnabled | Export-Csv -NoTypeInformation -Path (Join-Path $OutputPath "m365_audit_log_config.csv")
} catch {
    Write-Warning "Unable to query Admin Audit Log Config. Ensure proper roles and connection."
}

# 2. Mailbox audit status
try {
    $mbx = Get-ExoMailbox -ResultSize Unlimited | Select-Object DisplayName,UserPrincipalName,AuditEnabled
    $mbx | Export-Csv -NoTypeInformation -Path (Join-Path $OutputPath "m365_mailbox_audit.csv")
} catch {
    Write-Warning "Unable to query mailbox audit. Ensure proper roles and connection."
}

# 3. Transport rules (basic overview)
try {
    $rules = Get-TransportRule | Select-Object Name,Mode,State,Comments
    $rules | Export-Csv -NoTypeInformation -Path (Join-Path $OutputPath "m365_transport_rules.csv")
} catch {
    Write-Warning "Unable to query transport rules. Ensure proper roles and connection."
}

Write-Host "Microsoft 365 audit complete. Files saved to $OutputPath"
