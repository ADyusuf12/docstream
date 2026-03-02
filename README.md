# DocStream - Digital Document Management & AI Auditing System

## System Overview

DocStream is a sophisticated Document Management and AI Auditing system built for the Taraba State Internal Revenue Service (TIRS). The system implements a secure Clerk-to-Approver workflow enhanced by AI-driven risk analysis, ensuring 100% auditability and transparency in document processing.

### Workflow Architecture

```
Clerk (Document Upload) → AI Intelligence Engine (Risk Analysis) → Approver (Final Decision)
```

1. **Clerk**: Uploads documents and initiates the workflow
2. **AI Intelligence Engine**: Performs automated risk analysis and generates executive briefs
3. **Approver**: Reviews AI findings and makes final approval/rejection decisions

## Technical Stack

- **Framework**: Rails 8.0.4
- **Database**: PostgreSQL with Active Record
- **Deployment**: Kamal (Docker-based)
- **Real-time Updates**: Turbo Streams (ActionCable)
- **Background Jobs**: Sidekiq with Solid Queue
- **Caching**: Redis with Solid Cache
- **Authentication**: Devise
- **Authorization**: Pundit
- **State Management**: AASM (Workflow State Machine)
- **Audit Trail**: Audited Gem
- **Frontend**: Tailwind CSS with Turbo & Stimulus
- **File Upload**: Active Storage
- **QR Code Generation**: RQRCode

## Core Features

### AI Intelligence Engine

The system features an advanced AI analysis capability through the `GenerateMemoJob`:

- **Automated Risk Assessment**: Analyzes documents for potential revenue discrepancies
- **Executive Brief Generation**: Creates comprehensive summaries with risk levels
- **AI Attribution**: All AI actions are explicitly attributed in the audit trail
- **Real-time Results**: AI findings are immediately broadcast to users

### Live Audit Trail

- **Real-time Updates**: Turbo Streams provide instant status updates across all connected browsers
- **Complete History**: Every action is logged with user attribution and timestamps
- **Change Tracking**: Full version history with metadata preservation

### Digital Verification

- **QR Code Certificates**: Approved documents receive verifiable digital certificates
- **Tamper-proof Records**: Blockchain-like audit trail ensures document integrity
- **Instant Verification**: QR codes can be scanned to verify document authenticity

## Database Schema

```
Users (role-based: Clerk, Approver, Admin)
├── Documents (file uploads with metadata)
│   ├── Versions (document revisions with AI attribution)
│   └── WorkflowInstances (approval state tracking)
└── Audits (complete action history)
```

### Key Relationships

- **Users**: Role-based access control (Clerk, Approver, Admin)
- **Documents**: Core document entity with file attachments
- **Versions**: Document revisions with AI-generated content
- **WorkflowInstances**: State machine for approval workflow
- **Audits**: Complete audit trail of all system actions

## Getting Started

### Prerequisites

- Ruby 3.2.8
- PostgreSQL
- Redis
- Node.js (for asset compilation)

### Installation

```bash
# Install dependencies
bundle install

# Database setup
rails db:prepare

# Start development server
rails dev:cache
rails server
```

### Running Tests

```bash
# Run the complete test suite
bin/rails test

# System tests
bin/rails test:system
```

### Deployment

```bash
# Build and deploy with Kamal
kamal deploy
```

## Testing Suite

- **100% Test Coverage**: Comprehensive unit and system tests
- **Model Tests**: All models thoroughly tested
- **Controller Tests**: Complete API coverage
- **System Tests**: End-to-end workflow validation
- **Job Tests**: Background job functionality verified

## Security Features

- **Role-based Access Control**: Granular permissions for Clerks, Approvers, and Admins
- **File Validation**: Size limits and type restrictions
- **Audit Trail**: Complete logging of all system activities
- **Data Encryption**: Secure storage of sensitive information
- **Session Management**: Secure authentication with Devise

## Performance Optimizations

- **Background Processing**: Sidekiq for AI analysis and heavy operations
- **Caching**: Redis for session and fragment caching
- **Asset Optimization**: Turbo Streams for real-time updates
- **Database Indexing**: Optimized queries for fast document retrieval

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

---

**Digital Transformation**: DocStream represents a paradigm shift in government document processing, combining human expertise with AI capabilities to ensure transparency, accountability, and efficiency in revenue management.
