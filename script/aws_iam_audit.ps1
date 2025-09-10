<# 
AWS IAM Audit Script (Example)
Prereqs:
- AWS Tools for PowerShell: Install-Module AWS.Tools.IAM -Scope CurrentUser
- Configure credentials/profile beforehand (Set-AWSCredential / Set-DefaultAWSRegion)
Output:
- CSV reports in ./output
#>

param(
    [string]$ProfileName = "",
    [string]$Region = "us-east-1",
    [string]$OutputPath = ".\output"
)

Import-Module AWS.Tools.IAM -ErrorAction Stop

if (!(Test-Path $OutputPath)) { New-Item -ItemType Directory -Path $OutputPath | Out-Null }

if ($ProfileName) { Set-AWSCredential -ProfileName $ProfileName | Out-Null }
Set-DefaultAWSRegion -Region $Region | Out-Null

# 1. Users + MFA status + access keys age
$users = Get-IAMUser -NoAutoIteration

$mfaReport = foreach ($u in $users) {
    $mfas = Get-IAMMFADevice -UserName $u.UserName
    $keys = Get-IAMAccessKey -UserName $u.UserName -ErrorAction SilentlyContinue
    $keyAges = ($keys | ForEach-Object { ((Get-Date) - $_.CreateDate).Days }) -join ";"
    [pscustomobject]@{
        UserName   = $u.UserName
        Arn        = $u.Arn
        CreateDate = $u.CreateDate
        MFAEnabled = [bool]($mfas)
        AccessKeyIds = ($keys | Select-Object -ExpandProperty AccessKeyId) -join ";"
        AccessKeyAgesDays = $keyAges
    }
}
$mfaReport | Export-Csv -NoTypeInformation -Path (Join-Path $OutputPath "aws_users_mfa_keys.csv")

# 2. Attached policies per user + inline policies count
$policyReport = foreach ($u in $users) {
    $attached = Get-IAMAttachedUserPolicy -UserName $u.UserName -ErrorAction SilentlyContinue
    $inline   = Get-IAMUserPolicyList -UserName $u.UserName -ErrorAction SilentlyContinue
    [pscustomobject]@{
        UserName = $u.UserName
        AttachedPolicies = ($attached | Select-Object -ExpandProperty PolicyName) -join ";"
        InlinePoliciesCount = ($inline.PolicyNames | Measure-Object).Count
    }
}
$policyReport | Export-Csv -NoTypeInformation -Path (Join-Path $OutputPath "aws_user_policies.csv")

# 3. Account password policy
$pwd = Get-IAMAccountPasswordPolicy -ErrorAction SilentlyContinue
$pwd | Select-Object *
$pwd | ConvertTo-Json | Out-File (Join-Path $OutputPath "aws_password_policy.json")

Write-Host "AWS IAM audit complete. Files saved to $OutputPath"
