# Railway Deployment Guide

This guide will help you deploy AdVersity to Railway.

## Prerequisites

1. A Railway account (sign up at https://railway.app)
2. GitHub account (your code is already on GitHub)

## Step-by-Step Deployment

### 1. Connect Railway to GitHub

1. Go to https://railway.app and sign in
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Authorize Railway to access your GitHub account
5. Select the `p4kre/Ad-Versity` repository

### 2. Add PostgreSQL Database

1. In your Railway project, click "+ New"
2. Select "Database" → "Add PostgreSQL"
3. Railway will automatically create a PostgreSQL database
4. Note the connection details (they'll be in environment variables)

### 3. Add Redis Service

1. In your Railway project, click "+ New"
2. Select "Database" → "Add Redis"
3. Railway will automatically create a Redis instance
4. The `REDIS_URL` will be automatically set as an environment variable

### 4. Configure Environment Variables

In your Railway service settings, add these environment variables:

**Required:**
- `RAILS_ENV=production`
- `RAILS_MASTER_KEY` - Get this from your local `config/master.key` file
- `DATABASE_URL` - Automatically set by Railway when you add PostgreSQL
- `REDIS_URL` - Automatically set by Railway when you add Redis

**Optional (for Meta API integration):**
- `META_ACCESS_TOKEN` - Your Meta/Facebook API access token
- `META_API_VERSION` - Meta API version (e.g., `v18.0`)

### 5. Update Database Configuration

The app currently uses SQLite. For production on Railway, you'll need to:

1. Add PostgreSQL gem to Gemfile (if not already there)
2. Update `config/database.yml` to use PostgreSQL in production
3. Railway will automatically set `DATABASE_URL` which Rails will use

### 6. Deploy

1. Railway will automatically detect your Dockerfile and deploy
2. The first deployment will:
   - Build your Docker image
   - Run database migrations
   - Start your Rails server

### 7. Run Database Migrations

After the first deployment:

1. Go to your service in Railway
2. Click on the service → "Variables" tab
3. Click "Deploy" → "Run Command"
4. Run: `bin/rails db:migrate`

### 8. Set Up Custom Domain (Optional)

1. In your Railway service, go to "Settings"
2. Click "Generate Domain" or add your custom domain
3. Update your `config/environments/production.rb` to allow your domain

## Post-Deployment

### Start Sidekiq Worker

You'll need a separate service for Sidekiq:

1. In Railway, click "+ New" → "Empty Service"
2. Connect it to the same GitHub repo
3. Set the start command to: `bundle exec sidekiq`
4. Add the same environment variables (especially `REDIS_URL` and `DATABASE_URL`)

### Access Your App

- Your app will be available at: `https://your-app-name.up.railway.app`
- Sidekiq Web UI: `https://your-app-name.up.railway.app/sidekiq`

## Troubleshooting

### Database Connection Issues
- Ensure PostgreSQL service is running
- Check that `DATABASE_URL` is set correctly

### Redis Connection Issues
- Ensure Redis service is running
- Verify `REDIS_URL` is set correctly

### Build Failures
- Check Railway logs for specific errors
- Ensure all gems are in your Gemfile
- Verify Dockerfile is correct

## Cost Estimate

- **Free Tier**: $5 credit/month
- **PostgreSQL**: ~$5/month (after free tier)
- **Redis**: ~$5/month (after free tier)
- **Web Service**: ~$5/month (after free tier)
- **Sidekiq Worker**: ~$5/month (after free tier)

**Total**: ~$20/month after free tier credits

## Next Steps

1. Set up monitoring and alerts
2. Configure backups for PostgreSQL
3. Set up CI/CD for automatic deployments
4. Add custom domain with SSL
