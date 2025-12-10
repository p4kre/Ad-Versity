# Deployment Guide - AdVersity

## Quick Start: Railway (Recommended)

Railway is the easiest platform to deploy this Rails application.

### Why Railway?
- ✅ Simple setup (5 minutes)
- ✅ Automatic PostgreSQL and Redis
- ✅ Docker support
- ✅ Auto-deploy from GitHub
- ✅ $5/month free credit

### Steps:

1. **Sign up** at https://railway.app
2. **Create new project** → "Deploy from GitHub repo"
3. **Select** `p4kre/Ad-Versity` repository
4. **Add PostgreSQL**: Click "+ New" → "Database" → "Add PostgreSQL"
5. **Add Redis**: Click "+ New" → "Database" → "Add Redis"
6. **Set environment variables**:
   - `RAILS_ENV=production`
   - `RAILS_MASTER_KEY` (from your local `config/master.key`)
   - `DATABASE_URL` and `REDIS_URL` are auto-set by Railway
7. **Deploy**: Railway will automatically build and deploy
8. **Run migrations**: After first deploy, run `bin/rails db:migrate` in Railway's console

### Sidekiq Worker Setup

Create a second service for background jobs:
1. Click "+ New" → "Empty Service"
2. Connect to same GitHub repo
3. Set start command: `bundle exec sidekiq`
4. Add same environment variables

### Access Your App

- App URL: `https://your-app-name.up.railway.app`
- Sidekiq UI: `https://your-app-name.up.railway.app/sidekiq`

---

## Alternative Platforms

### Render
- Free tier available
- Rails-friendly
- Similar setup to Railway
- Visit: https://render.com

### Fly.io
- Great for Docker deployments
- Global edge network
- Visit: https://fly.io

### Heroku
- Classic Rails platform
- More expensive
- Visit: https://heroku.com

---

## Environment Variables

### Required
- `RAILS_ENV=production`
- `RAILS_MASTER_KEY` - Rails master key for encrypted credentials
- `DATABASE_URL` - PostgreSQL connection string (auto-set by platform)
- `REDIS_URL` - Redis connection string (auto-set by platform)

### Optional
- `META_ACCESS_TOKEN` - Meta/Facebook API token
- `META_API_VERSION` - Meta API version (default: v18.0)
- `RAILS_LOG_LEVEL` - Log level (default: info)

---

## Database Setup

The app supports both SQLite (development) and PostgreSQL (production).

For production:
- PostgreSQL is automatically configured when `DATABASE_URL` is set
- Migrations run automatically on first deploy
- Use `bin/rails db:migrate` for subsequent migrations

---

## Troubleshooting

### Build fails
- Check logs in Railway dashboard
- Ensure all gems are in Gemfile
- Verify Dockerfile is correct

### Database connection errors
- Verify PostgreSQL service is running
- Check `DATABASE_URL` is set correctly

### Redis connection errors
- Verify Redis service is running
- Check `REDIS_URL` is set correctly

### Sidekiq not working
- Ensure Redis service is running
- Verify `REDIS_URL` is set
- Check Sidekiq worker service is running

---

## Cost Estimate (Railway)

- **Free tier**: $5 credit/month
- **PostgreSQL**: ~$5/month
- **Redis**: ~$5/month
- **Web service**: ~$5/month
- **Sidekiq worker**: ~$5/month

**Total**: ~$20/month after free credits

---

For detailed Railway setup, see [RAILWAY_DEPLOY.md](./RAILWAY_DEPLOY.md)
