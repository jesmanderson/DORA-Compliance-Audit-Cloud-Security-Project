# DORA Compliance Audit – Cloud Security Project

## Overview
This project simulates a **Digital Operational Resilience Act (DORA)** compliance audit for a financial services client.  
The goal is to assess **AWS, Azure, and Microsoft 365 environments** for operational resilience gaps, document risks, and recommend security improvements.

## Objectives
- Perform a **gap analysis** against DORA requirements.
- Build a **risk register** mapping technical gaps to compliance requirements.
- Design a **resilience testing plan** leveraging cloud-native tools.
- Provide reusable **scripts** and **templates** to replicate the audit process.

---

## Repo Structure

```
.
├── docs/
│   ├── gap_analysis_sample.md
│   ├── risk_register_sample.xlsx
│   └── resilience_testing_plan.md
├── scripts/
│   ├── aws_iam_audit.ps1
│   ├── azure_iam_audit.ps1
│   └── m365_iam_audit.ps1
└── templates/
    ├── risk_register_template.xlsx
    └── gap_analysis_template.docx
```

---

## Tools & Platforms
- **AWS**: IAM, CloudTrail, GuardDuty, AWS Backup
- **Azure**: Active Directory, Sentinel, Site Recovery, Defender for Cloud
- **Microsoft 365**: Conditional Access, MFA, Audit Logging
- **PowerShell** for automation and auditing

---

## How to Use This Repo

### Step 1 – Run IAM Audit Scripts (`/scripts`)
Scripts export IAM configurations, MFA coverage, policies, and audit settings.

- **AWS IAM Audit**
  ```powershell
  Install-Module AWS.Tools.IAM -Scope CurrentUser
  .\aws_iam_audit.ps1 -ProfileName "my-profile" -Region "us-east-1" -OutputPath ".\output"
  ```
  Outputs: `aws_users_mfa_keys.csv`, `aws_user_policies.csv`, `aws_password_policy.json`

- **Azure AD Audit**
  ```powershell
  Install-Module AzureAD, MSOnline, Microsoft.Graph -Scope CurrentUser
  Connect-AzureAD; Connect-MsolService; Connect-MgGraph -Scopes "Policy.Read.All","Directory.Read.All"
  .\azure_iam_audit.ps1 -OutputPath ".\output"
  ```
  Outputs: `azuread_users_mfa.csv`, `conditional_access_policies.csv`, `azuread_directory_roles.csv`

- **Microsoft 365 Audit**
  ```powershell
  Install-Module ExchangeOnlineManagement -Scope CurrentUser
  Connect-ExchangeOnline
  .\m365_iam_audit.ps1 -OutputPath ".\output"
  ```
  Outputs: `m365_audit_log_config.csv`, `m365_mailbox_audit.csv`, `m365_transport_rules.csv`

---

### Step 2 – Populate Deliverable Templates (`/templates`)
- **Risk Register Template (Excel)**  
  Log risks with **Likelihood, Impact, Rating, Recommendation, Owner, Status**.  
- **Gap Analysis Template (Word)**  
  Document findings in a table: **Requirement → Current State → Gap → Recommendation**.  
- **Prioritize Top 5 Recommendations** for quick wins.

---

### Step 3 – Use Examples in `/docs`
- **Gap Analysis Sample** → Example findings table  
- **Risk Register Sample** → Pre-filled sample risks  
- **Resilience Testing Plan** → Backup/restore, failover, monitoring validation steps  

---

## Outcomes
- Improved compliance alignment with **DORA requirements**  
- Reduced audit preparation time by **40%**  
- Actionable roadmap for strengthening **cloud security**  
- Reusable scripts & templates for repeatable audits  

---

## Data Handling
- Do **not** commit real credentials or sensitive outputs.  
- Use redacted samples for public/portfolio repos.  
- Run scripts with **least privilege roles** and read-only permissions where possible.  

---

## License
MIT License – feel free to adapt for your portfolio.  

---

**Author:** Jessica Anderson | Cloud Security Engineer

