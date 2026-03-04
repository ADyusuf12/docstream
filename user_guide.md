# TIRS Oversight - User Guide

## Table of Contents

1. [Administrator Guide](#administrator-guide)
2. [Inventory Manager Guide](#inventory-manager-guide)
3. [Clerk Guide](#clerk-guide)

---

## Administrator Guide

### Navigating the Intelligence Tab

The "Intelligence" tab serves as the central command center for system monitoring and oversight.

#### System Status Dashboard

- **System Status**: Real-time monitoring of system health (Optimal/Warning/Critical)
- **KPI Metrics**:
  - Pending Workflows
  - Pending Requisitions
  - Total Documents
  - Low Stock Alerts
- **Authentication Profile**: Session details and access tier verification

#### Security Intelligence

- **Daily Issuance Summary**: Total documents issued today with breakdown by document class
- **Activity Feed**: Real-time monitoring of document movements and status changes
- **Forensic Trail Access**: Direct link to audit logs for complete transaction history

### Monitoring System Health

#### Key Performance Indicators

- **Workflow Efficiency**: Monitor pending workflow instances
- **Inventory Levels**: Track low stock items and automated alerts
- **Document Throughput**: Daily issuance volumes and trends
- **System Availability**: Real-time status monitoring

#### Alert Management

- **Low Stock Notifications**: Automated alerts when inventory falls below threshold
- **Workflow Backlogs**: Identification of pending approvals requiring attention
- **Security Events**: Monitoring of unusual activity patterns

### Viewing the Forensic Trail (Audits)

#### Audit Trail Access

- Navigate to `/admin/audits` for complete system audit history
- Filter by date range, user, or action type
- Export audit logs for compliance reporting

#### Audit Categories

- **Document Actions**: Uploads, modifications, approvals
- **Inventory Movements**: Stock changes, requisitions, restocks
- **System Events**: Configuration changes, user management
- **Security Events**: Authentication attempts, access violations

---

## Inventory Manager Guide

### Using the Logistics Tab

The "Logistics" tab provides comprehensive inventory management and issuance intelligence.

#### Issuance Intelligence

- **Daily Throughput Summary**: Real-time document issuance tracking
- **Document Class Breakdown**: Volume analysis by document type
- **Trend Analysis**: Historical issuance patterns and forecasting

#### Inventory Management

- **Stock Level Monitoring**: Real-time inventory status
- **Low Stock Alerts**: Automated notifications for critical items
- **Restock Management**: Quick access to inventory replenishment

### Tracking Issuance Intelligence

#### Daily Reporting

- **Total Issued Today**: Real-time count of documents issued
- **Document Classification**: Breakdown by document type and purpose
- **Volume Trends**: Historical comparison and anomaly detection

#### Performance Metrics

- **Processing Time**: Average time from requisition to issuance
- **Approval Rates**: Success rate of document requests
- **Stock Turnover**: Inventory utilization and replenishment cycles

### Restocking the Vault

#### Inventory Management Process

1. **Access Inventory**: Navigate to `/inventory_items`
2. **Identify Needs**: Review low stock alerts and usage trends
3. **Create Restock**: Use "New Restock" functionality for bulk updates
4. **Process Restock**: Submit and update inventory quantities

#### Stock Threshold Management

- **Configure Thresholds**: Set appropriate low-stock levels per item
- **Automated Alerts**: System notifications when thresholds are breached
- **Reorder Points**: Intelligent stock level recommendations

---

## Clerk Guide

### Submitting Document Requisitions

#### Requisition Process

1. **Access Requisitions**: Navigate to `/requisitions/new`
2. **Select Document**: Choose from available inventory items
3. **Specify Quantity**: Enter required number of documents
4. **Provide Purpose**: Document the intended use
5. **Submit Request**: Send for approver review

#### Requisition Details

- **Document Selection**: Browse available inventory items
- **Quantity Limits**: System-enforced based on availability
- **Purpose Documentation**: Required justification for requests
- **Serial Number Tracking**: Optional start/end range specification

### Viewing Request History

#### My Requisitions

- **Status Tracking**: View current status of all requests
- **History Timeline**: Complete history of past requests
- **Approval Details**: Information on approvals/rejections
- **Document Status**: Current location and availability

#### Request Management

- **Pending Requests**: View and manage active requisitions
- **Completed History**: Archive of fulfilled requests
- **Rejection Reasons**: Feedback on denied requests
- **Follow-up Actions**: Next steps for pending items

---

## System Navigation

### Quick Access Links

- **Dashboard**: `/` - Main command center
- **Inventory Management**: `/inventory_items` - Stock tracking
- **Requisitions**: `/requisitions` - Document requests
- **Audit Trail**: `/admin/audits` - Complete history
- **Document Management**: `/documents` - Document workflow

### Role-Based Access

- **Administrators**: Full system access with audit capabilities
- **Inventory Managers**: Stock management and issuance monitoring
- **Clerks**: Document requisition and request tracking

---

## Best Practices

### Security Protocols

- **Document Verification**: Always verify document authenticity before issuance
- **Audit Compliance**: Maintain complete documentation of all movements
- **Access Control**: Follow role-based permissions strictly
- **Data Integrity**: Ensure accurate record-keeping at all times

### Efficiency Guidelines

- **Proactive Management**: Monitor inventory levels regularly
- **Timely Processing**: Address requisitions promptly
- **Documentation**: Maintain complete records of all transactions
- **Communication**: Keep stakeholders informed of status changes

---

**Note**: All actions within TIRS Oversight are logged and auditable. Maintain professional conduct and follow established protocols at all times.
