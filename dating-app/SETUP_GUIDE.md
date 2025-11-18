# Dating App - Quick Setup Guide

## 🎯 Overview

This guide will help you get the dating app backend up and running in minutes.

## ⚡ Quick Start (Recommended)

### Using Docker (Easiest)

1. **Copy environment file**
   ```bash
   cd dating-app
   cp .env.example .env
   ```

2. **Start all services**
   ```bash
   docker-compose up
   ```

3. **Access the services**
   - API: http://localhost:3000
   - API Health: http://localhost:3000/health
   - pgAdmin: http://localhost:5050 (admin@datingapp.com / admin)
   - Redis Commander: http://localhost:8081
   - Elasticsearch: http://localhost:9200

That's it! You're ready to develop.

## 🔧 Manual Setup (Advanced)

### Prerequisites

Ensure you have installed:
- Node.js 20+ (`node --version`)
- PostgreSQL 15+ (`psql --version`)
- Redis 7+ (`redis-cli --version`)

### Step-by-Step

1. **Install dependencies**
   ```bash
   cd dating-app
   npm install
   ```

2. **Set up PostgreSQL**
   ```bash
   # Create database
   createdb dating_app

   # Create test database
   createdb dating_app_test

   # Enable required extensions
   psql dating_app -c "CREATE EXTENSION IF NOT EXISTS postgis;"
   psql dating_app -c "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";"
   ```

3. **Configure environment**
   ```bash
   cp .env.example .env
   # Edit .env and update:
   # - Database credentials
   # - Redis connection
   # - JWT secrets
   ```

4. **Run migrations**
   ```bash
   npm run db:migrate
   ```

5. **Start development server**
   ```bash
   npm run dev
   ```

## 📝 Configuration Checklist

### Essential Variables to Update in `.env`

**Database**
- ✅ `DB_HOST` - Your PostgreSQL host
- ✅ `DB_PASSWORD` - Secure database password
- ✅ `DB_NAME` - Database name

**Security**
- ✅ `JWT_SECRET` - Generate with: `openssl rand -base64 32`
- ✅ `JWT_REFRESH_SECRET` - Generate with: `openssl rand -base64 32`

**Redis**
- ✅ `REDIS_HOST` - Your Redis host
- ✅ `REDIS_PASSWORD` - Redis password (if using authentication)

### Optional (For Full Functionality)

**AWS S3** (Photo/Video Storage)
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_S3_BUCKET`

**Twilio** (SMS Verification)
- `TWILIO_ACCOUNT_SID`
- `TWILIO_AUTH_TOKEN`
- `TWILIO_VERIFY_SERVICE_SID`

**Stripe** (Payments)
- `STRIPE_SECRET_KEY`
- `STRIPE_PUBLISHABLE_KEY`

**SendGrid** (Email)
- `SENDGRID_API_KEY`

**Firebase** (Push Notifications)
- `FIREBASE_PROJECT_ID`
- `FIREBASE_PRIVATE_KEY`

## 🧪 Testing Your Setup

1. **Health Check**
   ```bash
   curl http://localhost:3000/health
   ```

   Expected response:
   ```json
   {
     "status": "healthy",
     "database": "connected",
     "redis": "connected"
   }
   ```

2. **API Info**
   ```bash
   curl http://localhost:3000/api
   ```

3. **Run Tests**
   ```bash
   npm test
   ```

## 🐛 Troubleshooting

### Database Connection Failed

**Error**: `Failed to connect to database`

**Solutions**:
1. Check PostgreSQL is running: `pg_isready`
2. Verify credentials in `.env`
3. Check database exists: `psql -l | grep dating_app`
4. Ensure PostGIS extension: `psql dating_app -c "SELECT PostGIS_version();"`

### Redis Connection Failed

**Error**: `Failed to connect to Redis`

**Solutions**:
1. Check Redis is running: `redis-cli ping` (should return `PONG`)
2. Verify host/port in `.env`
3. Check Redis password if configured

### Port Already in Use

**Error**: `EADDRINUSE: address already in use :::3000`

**Solutions**:
1. Change port in `.env`: `PORT=3001`
2. Or kill process using port 3000:
   ```bash
   # Find process
   lsof -ti:3000
   # Kill it
   kill -9 $(lsof -ti:3000)
   ```

### Migration Errors

**Error**: `Migration failed`

**Solutions**:
1. Check database connection
2. Verify PostgreSQL extensions installed
3. Rollback and retry:
   ```bash
   npm run db:rollback
   npm run db:migrate
   ```

### Docker Issues

**Error**: `Cannot connect to Docker daemon`

**Solutions**:
1. Ensure Docker is running
2. Check Docker Compose version: `docker-compose --version`
3. Try with sudo (Linux): `sudo docker-compose up`

## 📦 What's Included?

Your dating app configuration includes:

### ✅ Backend Infrastructure
- Express.js server with TypeScript
- PostgreSQL database with PostGIS
- Redis caching layer
- Elasticsearch for search
- Socket.io for real-time features

### ✅ Development Tools
- Hot reload with nodemon
- ESLint + Prettier for code quality
- Jest for testing
- Winston for logging
- Swagger for API documentation

### ✅ Database Schema
- Users & profiles
- Photos & prompts
- Swipes & matches
- Messages
- Subscriptions
- Reports & blocks

### ✅ DevOps
- Docker & Docker Compose
- Database migrations
- Health checks
- Graceful shutdown
- Error handling

## 🚀 Next Steps

Now that your backend is configured:

1. **Explore the API**
   - Visit API documentation (will be at `/api-docs` once implemented)
   - Test endpoints with Postman or curl

2. **Build Features**
   - Implement authentication routes
   - Create discovery/matching logic
   - Build messaging system
   - Add premium features

3. **Connect Frontend**
   - Build iOS app (Swift/SwiftUI)
   - Create Android app (Kotlin/Compose)
   - Develop web interface

4. **Deploy**
   - Set up production database
   - Configure cloud storage (S3)
   - Deploy to AWS/GCP/Azure
   - Set up CI/CD pipeline

## 📚 Additional Resources

- [README.md](./README.md) - Complete project documentation
- [Database Migrations](./src/database/migrations/) - Database schema
- [API Documentation](http://localhost:3000/api-docs) - API reference
- [Docker Compose](./docker-compose.yml) - Service configuration

## 💡 Development Tips

1. **Use Docker** for consistent environment across team
2. **Keep .env secure** - never commit to version control
3. **Run tests** before committing code
4. **Use ESLint** to catch errors early
5. **Check logs** in `logs/` directory for debugging

## 🆘 Need Help?

If you encounter issues not covered here:

1. Check the main [README.md](./README.md)
2. Review error logs in `logs/error.log`
3. Search existing issues on GitHub
4. Contact support: support@datingapp.com

---

**Ready to build something amazing? Let's go! 🚀**
