# Lesson 17

This section documents exercise 1 from lesson 17

---

### 1.1 System Overview

The PostgreSQL database supports a critical business system responsible for storing and processing business transactions.

The database contains essential information such as:
- customer accounts,
- product catalog,
- orders,
- payment records.

Data loss or extended downtime may result in financial losses, customer dissatisfaction, and operational issues.

### 1.2 Recovery Point Objective (RPO)

**RPO: 5 minutes**

The system must allow recovery of data with a maximum data loss window of 5 minutes.

This value was selected because losing more than a few minutes of transactional data could result in:
- lost customer orders,
- inconsistencies between payment systems and order records,
- manual data recovery processes.

### 1.3 Recovery Time Objective (RTO)

**RTO: 10 minutes**

The system should be restored and fully operational within 10 minutes after a critical failure.

A short recovery time is required to minimize:
- business downtime,
- lost transactions,
- impact on customers.

### 1.4 Critical Data Identification

The following data requires the highest level of protection:

- Orders:
    Contains customer purchase information.
    Loss of order data may result in financial losses and customer complaints.

- Payments:
    Contains critical information for other business departments.
    Loss of payments may result in failed order processing.

- Users:
  Contains customer account information and authentication data.
  Loss of user data may prevent customers from accessing their accounts
  and may affect customer service operations.

### 1.5 Backup Retention Requirements

Full backups:
    - Once per day
        why:
            - Big set of data is heavy waste of storage.
            - Backup duration takes longer time untill backup file is saved.

WAL archives:
    - Continuous archiving
        why:
        - Minimizes possible data loss.
        - Allows point-in-time recovery.
        - Stores only transaction changes instead of full database copies.

Long-term retention:
    At first it depends from the policy of the company in witch sector are they into, some of the users data have to be stored for long term.

    Proposed retention strategy:
        (GFS) Grandfather-Father-Son backup rotation
            - Daily backups stored in week directories
            - Weekly directories stored in monthly directories
            - Monthly directories stored in yearly directories

    Older backups may be compressed to reduce storage costs.

    Long-term backups may provide additional business value, for example historical analysis of customer activity and transactions.