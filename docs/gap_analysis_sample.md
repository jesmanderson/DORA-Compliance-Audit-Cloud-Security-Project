# Gap Analysis – DORA Compliance (Sample)

## Scope
AWS, Azure, Microsoft 365 environments for a financial services client.

## Findings

| Control Area     | Requirement                               | Current State                       | Gap                                 | Recommendation                                   |
|------------------|-------------------------------------------|-------------------------------------|-------------------------------------|--------------------------------------------------|
| Access Control   | MFA required for all accounts              | Only admins have MFA enabled         | Users without MFA                   | Enforce MFA for all IAM, Azure AD, and M365 users |
| Backup & Restore | Regular backups and tested restores        | Azure backup not configured          | Risk of data loss                   | Configure Azure Backup and test restore procedures |
| Monitoring       | Centralized logging & continuous monitoring| CloudTrail enabled but no GuardDuty  | Limited threat detection            | Enable GuardDuty, Security Hub, and Azure Sentinel|
| Policies         | Documented incident response and resilience| No formal IR policy documented       | Gaps in resilience planning         | Create Incident Response & Resilience Policy       |
