# Resilience Testing Plan – DORA Compliance (Sample)

## Objective
Validate that AWS and Azure environments can withstand and recover from disruptions, meeting Digital Operational Resilience Act (DORA) requirements.

## Scope
- AWS IAM, CloudTrail, GuardDuty, AWS Backup
- Azure Active Directory, Sentinel, Site Recovery, Defender for Cloud
- Microsoft 365 conditional access and audit logging

## Testing Components

### 1. Backup & Restore
- Verify AWS Backup recovery points are configured and restorable.
- Test Azure Backup recovery of a sample VM and storage account.
- Confirm retention policies meet compliance requirements.

### 2. Incident Detection & Response
- Trigger a simulated unauthorized login attempt in AWS.
- Validate GuardDuty generates alerts and Security Hub aggregates findings.
- In Azure, test Sentinel alerts for anomalous sign-ins.

### 3. Failover & Continuity
- Test Azure Site Recovery by simulating failover of a critical VM.
- Validate application accessibility in the secondary region.
- Document Recovery Time Objective (RTO) and Recovery Point Objective (RPO).

### 4. Identity & Access
- Review MFA enforcement across AWS, Azure AD, and Microsoft 365 accounts.
- Simulate login attempts without MFA and confirm access is denied.
- Confirm conditional access policies function as expected.

## Reporting
- Record test results, outcomes, and any remediation actions required.
- Update Risk Register with residual risks identified during testing.

---
Author: Jessica Anderson | Cloud Security Engineer
