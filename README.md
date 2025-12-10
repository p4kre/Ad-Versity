# AdVersity - Advertising Campaign Management Platform

A comprehensive Ruby on Rails application for managing advertising campaigns, building targeted audiences, and tracking performance across multiple advertising platforms.

## Features

- **Contact Management**: Rich contact profiles with demographic data (age, gender, income, education, occupation, marital/family status)
- **Smart Audience Building**: Demographic-based filtering and AI-powered contact suggestions
- **Campaign Management**: Multi-channel campaign support (Meta, Google, LinkedIn)
- **Analytics Dashboard**: Real-time performance metrics, KPIs, and visualizations
- **Search & Filtering**: Advanced search and demographic filtering across all entities
- **Platform Integration**: Meta (Facebook) API integration for audience sync and insights
- **Background Processing**: Asynchronous job processing with Sidekiq

## Technology Stack

- **Framework**: Ruby on Rails 8.1.1
- **Database**: SQLite3 (development)
- **Background Jobs**: Sidekiq with Redis
- **Frontend**: ERB templates, Stimulus.js, Custom CSS
- **API Integration**: HTTParty

## Getting Started

### Prerequisites

- Ruby 3.4.7 or higher
- Redis (for Sidekiq)
- SQLite3

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   bundle install
   ```

3. Set up the database:
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   ```

4. Start Redis (required for Sidekiq):
   ```bash
   redis-server
   ```

5. Start the Rails server:
   ```bash
   bin/rails server
   ```

6. Start Sidekiq (in a separate terminal):
   ```bash
   bundle exec sidekiq
   ```

7. Visit `http://localhost:3000`

### Sidekiq Web UI

Access the Sidekiq dashboard at `http://localhost:3000/sidekiq` to monitor background jobs.

## Project Structure

- `app/models/` - Domain models (Contact, Audience, Campaign, Insight)
- `app/controllers/` - HTTP request handlers
- `app/services/` - Business logic services (DemographicMatcher, MetaService)
- `app/workers/` - Background job workers
- `app/views/` - ERB templates
- `config/routes.rb` - Application routes

## Key Features Explained

### Demographic-Based Contact Suggestions

The application analyzes existing audience demographics and suggests matching contacts using the `DemographicMatcher::Service`. This service:
- Identifies common demographic patterns
- Matches contacts based on multiple criteria
- Provides intelligent suggestions for audience building

### Campaign Analytics

The dashboard calculates key performance indicators:
- Click-Through Rate (CTR)
- Conversion Rate
- Cost Per Click (CPC)
- Total impressions, clicks, conversions, and spend

### Platform Integration

Meta (Facebook) integration allows:
- Audience synchronization to Meta platform
- Campaign insights fetching
- Status tracking (draft, syncing, synced, failed)

## Architecture

See [ARCHITECTURE.md](./ARCHITECTURE.md) for detailed architecture documentation.

## Demo Script

See [DEMO_SCRIPT.md](./DEMO_SCRIPT.md) for a comprehensive interview demo script.

## License

This project is part of a portfolio demonstration.
