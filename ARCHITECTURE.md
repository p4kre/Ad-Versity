# AdVersity - Architecture Documentation

## Overview
**AdVersity** is a comprehensive advertising campaign management platform that enables businesses to manage contacts, build targeted audiences, create and track advertising campaigns across multiple channels (Meta, Google, LinkedIn), and analyze campaign performance through integrated analytics.

## Technology Stack

### Backend
- **Framework**: Ruby on Rails 8.1.1
- **Database**: SQLite3 (development), PostgreSQL-ready (production)
- **Background Jobs**: Sidekiq with Redis
- **API Integration**: HTTParty for external API calls
- **Server**: Puma

### Frontend
- **View Layer**: ERB templates
- **JavaScript**: Stimulus.js (Hotwire)
- **CSS**: Custom CSS with CSS Variables
- **UI Framework**: Modern, responsive design with card-based layouts
- **Form Handling**: Turbo (Hotwire) for seamless form submissions

### Infrastructure
- **Caching**: Solid Cache
- **Job Queue**: Solid Queue / Sidekiq
- **WebSockets**: Solid Cable
- **Deployment**: Kamal (Docker-based)

## Application Architecture

### MVC Structure

#### Models (Domain Layer)
1. **Contact**
   - Core entity representing individuals
   - Demographic attributes (age, gender, income, education, occupation, marital/family status)
   - Associations: `has_many :audience_contacts`, `has_many :audiences, through: :audience_contacts`
   - Scopes for demographic filtering and search

2. **Audience**
   - Target groups for campaigns
   - Status tracking (draft, syncing, synced, failed)
   - Associations: `has_many :audience_contacts`, `has_many :contacts`, `has_many :campaign_audiences`, `has_many :campaigns`
   - Sync capability with Meta platform

3. **Campaign**
   - Advertising campaigns across channels
   - Channel enum (meta, google, linkedin)
   - Associations: `has_many :insights`, `has_many :campaign_audiences`, `has_many :audiences`
   - External ID for platform integration

4. **Insight**
   - Performance metrics for campaigns
   - Stores impressions, clicks, conversions, spend
   - Belongs to Campaign

5. **Join Models**
   - `AudienceContact`: Many-to-many between Audience and Contact
   - `CampaignAudience`: Many-to-many between Campaign and Audience

#### Controllers (Application Layer)
1. **DashboardController**
   - Aggregates analytics and metrics
   - Calculates KPIs (CTR, conversion rate, CPC)
   - Top performing campaigns analysis

2. **ContactsController**
   - Full CRUD operations
   - Search and filtering by demographics
   - Company-based filtering

3. **AudiencesController**
   - CRUD operations
   - Contact management (add/remove)
   - Demographic filtering for contact selection
   - Meta platform sync

4. **CampaignsController**
   - CRUD operations
   - Insights fetching
   - Audience association

#### Services (Business Logic Layer)
1. **DemographicMatcher::Service**
   - Analyzes audience demographics
   - Suggests matching contacts based on common demographics
   - Keyword extraction for occupation matching

2. **Integrations::MetaService**
   - Handles Meta (Facebook) API integration
   - Audience sync operations
   - Campaign insights fetching
   - Error handling and validation

#### Workers (Background Processing)
1. **AudienceSyncWorker**
   - Asynchronous audience synchronization with Meta
   - Status updates (syncing → synced/failed)

2. **FetchInsightsWorker**
   - Background job for fetching campaign insights
   - Handles API rate limiting
   - Error recovery

### Key Features

#### 1. Demographic-Based Contact Management
- **Rich Contact Profiles**: Age, gender, income, education, occupation, marital/family status
- **Smart Suggestions**: AI-like matching based on audience demographics
- **Filtering**: Multi-criteria demographic filtering

#### 2. Audience Building
- **Manual Selection**: Add contacts individually
- **Demographic Filtering**: Filter contacts by demographics before adding
- **Smart Suggestions**: Automatic suggestions based on existing audience profile
- **Platform Sync**: Sync audiences to Meta advertising platform

#### 3. Campaign Management
- **Multi-Channel Support**: Meta, Google, LinkedIn
- **Audience Association**: Link multiple audiences to campaigns
- **Performance Tracking**: Integrated insights and metrics
- **External Integration**: Connect with external campaign IDs

#### 4. Analytics Dashboard
- **Overview Metrics**: Total campaigns, audiences, contacts, budget
- **Performance Metrics**: Impressions, clicks, conversions, spend
- **Calculated KPIs**: CTR, conversion rate, CPC
- **Visualizations**: Campaigns by channel, audiences by status
- **Top Performers**: Best performing campaigns ranked by metrics

#### 5. Search & Filtering
- **Global Search**: Search across contacts, campaigns, audiences
- **Demographic Filtering**: Filter contacts by multiple demographic criteria
- **Status Filtering**: Filter audiences by sync status
- **Channel Filtering**: Filter campaigns by advertising channel

## Data Flow

### Contact Creation Flow
```
User Input → ContactsController#create → Contact Model → Database
         ↓
    Demographic Data Stored
         ↓
    Available for Audience Building
```

### Audience Building Flow
```
Select Contacts → Filter by Demographics → DemographicMatcher Service
         ↓
    Analyze Existing Audience → Suggest Matching Contacts
         ↓
    Add Selected Contacts → Audience Model → Database
         ↓
    Sync to Meta (Optional) → AudienceSyncWorker → MetaService → Meta API
```

### Campaign Creation Flow
```
Create Campaign → Select Audiences → Link Campaign-Audience
         ↓
    Set External ID → Fetch Insights → FetchInsightsWorker
         ↓
    MetaService → Meta API → Store Insights → Display Analytics
```

### Analytics Flow
```
Dashboard Request → DashboardController → Aggregate Data
         ↓
    Calculate Metrics (CTR, CPC, Conversion Rate)
         ↓
    Display Visualizations → User Dashboard
```

## Database Schema

### Core Tables
- `contacts`: Personal and demographic information
- `audiences`: Target groups with status tracking
- `campaigns`: Advertising campaigns with channel and external IDs
- `insights`: Performance metrics linked to campaigns

### Join Tables
- `audience_contacts`: Many-to-many relationship
- `campaign_audiences`: Many-to-many relationship

## API Integration

### Meta (Facebook) Integration
- **Endpoint**: Configured via MetaService
- **Authentication**: API tokens (configured in environment)
- **Operations**:
  - Audience sync
  - Campaign insights fetching
- **Error Handling**: Comprehensive validation and retry logic

## Background Processing

### Sidekiq Workers
- **Queue Management**: Redis-backed job queue
- **Async Operations**: 
  - Audience synchronization
  - Campaign insights fetching
- **Status Tracking**: Real-time status updates

## Security Considerations
- **CSRF Protection**: Rails built-in CSRF tokens
- **Parameter Sanitization**: Strong parameters in controllers
- **SQL Injection Prevention**: ActiveRecord ORM with parameterized queries
- **XSS Protection**: ERB auto-escaping

## Scalability Considerations
- **Background Jobs**: Heavy operations moved to Sidekiq
- **Database Indexing**: Optimized queries with proper indexes
- **Caching**: Solid Cache for frequently accessed data
- **Stateless Design**: RESTful architecture for horizontal scaling

## Testing Strategy
- **Model Tests**: Unit tests for business logic
- **Controller Tests**: Integration tests for API endpoints
- **Service Tests**: Service layer validation
- **Worker Tests**: Background job testing

## Deployment
- **Containerization**: Docker-ready with Kamal
- **Environment Variables**: Sensitive data via ENV vars
- **Health Checks**: `/up` endpoint for monitoring
- **Background Workers**: Separate Sidekiq process

## Future Enhancements
- Multi-user authentication
- Advanced analytics with charts
- Google and LinkedIn API integrations
- Export/import functionality
- Email notifications
- Real-time updates via Action Cable

