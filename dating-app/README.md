# Dating App Backend

A modern, feature-rich social dating application backend inspired by Tinder, Bumble, and Hinge. Built with Node.js, TypeScript, PostgreSQL, Redis, and Elasticsearch.

## 🚀 Features

- **User Authentication**: Multi-method auth (phone, email, social login)
- **Advanced Matching Algorithm**: ML-based compatibility scoring
- **Real-time Messaging**: Socket.io powered chat
- **Photo & Video Profiles**: Rich media support with AWS S3
- **Premium Subscriptions**: Stripe payment integration
- **Geolocation**: PostGIS-based location matching
- **Safety Features**: AI moderation, verification, reporting
- **Video Calling**: WebRTC integration (Twilio/Agora)
- **RESTful & GraphQL APIs**: Hybrid API architecture
- **Comprehensive Testing**: Jest with 70%+ coverage target

## 📋 Prerequisites

- Node.js >= 20.0.0
- PostgreSQL >= 15
- Redis >= 7
- Docker & Docker Compose (optional)
- npm >= 10.0.0

## 🛠️ Technology Stack

### Backend
- **Runtime**: Node.js 20+
- **Language**: TypeScript 5.3+
- **Framework**: Express.js
- **Real-time**: Socket.io
- **API**: REST + GraphQL (Apollo Server)

### Database
- **Primary DB**: PostgreSQL 15+ with PostGIS
- **Cache**: Redis 7+
- **Search**: Elasticsearch 8+
- **ORM**: Knex + Objection.js

### Cloud Services
- **File Storage**: AWS S3
- **CDN**: CloudFront
- **SMS/Phone**: Twilio
- **Email**: SendGrid
- **Push Notifications**: Firebase
- **Payments**: Stripe
- **Video Calls**: Twilio Video / Agora

### DevOps
- **Containerization**: Docker
- **Code Quality**: ESLint, Prettier
- **Testing**: Jest, Supertest
- **Logging**: Winston
- **Documentation**: Swagger/OpenAPI

## 📦 Installation

### Option 1: Local Development

1. **Clone the repository**
   ```bash
   cd dating-app
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Start PostgreSQL and Redis** (if not using Docker)
   ```bash
   # Install and start PostgreSQL
   # Install and start Redis
   ```

5. **Run database migrations**
   ```bash
   npm run db:migrate
   ```

6. **Start the development server**
   ```bash
   npm run dev
   ```

### Option 2: Docker Development

1. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

2. **Start all services**
   ```bash
   npm run docker:dev
   ```

This will start:
- Dating App API (port 3000)
- PostgreSQL (port 5432)
- Redis (port 6379)
- Elasticsearch (port 9200)
- pgAdmin (port 5050)
- Redis Commander (port 8081)

## 🗂️ Project Structure

```
dating-app/
├── config/                 # Configuration files
│   ├── database.ts        # Database connection
│   ├── redis.ts           # Redis connection
│   ├── logger.ts          # Winston logger
│   └── swagger.ts         # API documentation
├── src/
│   ├── api/               # API routes and controllers
│   │   ├── routes/
│   │   ├── controllers/
│   │   └── validators/
│   ├── services/          # Business logic
│   ├── models/            # Database models (Objection.js)
│   ├── middleware/        # Express middleware
│   ├── utils/             # Utility functions
│   ├── types/             # TypeScript type definitions
│   ├── database/
│   │   ├── migrations/    # Database migrations
│   │   └── seeds/         # Seed data
│   └── server.ts          # Application entry point
├── tests/                 # Test files
├── scripts/               # Utility scripts
├── logs/                  # Application logs
├── .env.example           # Environment variables template
├── .gitignore
├── docker-compose.yml
├── Dockerfile
├── knexfile.ts            # Database migration config
├── tsconfig.json          # TypeScript configuration
├── jest.config.js         # Jest testing configuration
├── .eslintrc.json         # ESLint configuration
├── .prettierrc            # Prettier configuration
└── package.json
```

## 🔧 Available Scripts

```bash
# Development
npm run dev              # Start development server with hot reload

# Building
npm run build            # Compile TypeScript to JavaScript
npm start                # Start production server

# Testing
npm test                 # Run tests with coverage
npm run test:watch       # Run tests in watch mode

# Code Quality
npm run lint             # Run ESLint
npm run lint:fix         # Fix ESLint errors
npm run format           # Format code with Prettier

# Database
npm run db:migrate       # Run database migrations
npm run db:rollback      # Rollback last migration
npm run db:seed          # Seed database with test data

# Docker
npm run docker:dev       # Start Docker development environment
npm run docker:prod      # Start Docker production environment
```

## 🔐 Environment Variables

Key environment variables to configure (see `.env.example` for complete list):

### Application
- `NODE_ENV` - Environment (development/production/test)
- `PORT` - Server port (default: 3000)
- `API_VERSION` - API version prefix

### Database
- `DB_HOST` - PostgreSQL host
- `DB_PORT` - PostgreSQL port
- `DB_NAME` - Database name
- `DB_USER` - Database user
- `DB_PASSWORD` - Database password

### Redis
- `REDIS_HOST` - Redis host
- `REDIS_PORT` - Redis port
- `REDIS_PASSWORD` - Redis password (optional)

### JWT
- `JWT_SECRET` - Secret key for JWT signing
- `JWT_EXPIRES_IN` - Token expiration time

### AWS
- `AWS_ACCESS_KEY_ID` - AWS access key
- `AWS_SECRET_ACCESS_KEY` - AWS secret key
- `AWS_S3_BUCKET` - S3 bucket name

### External Services
- `TWILIO_ACCOUNT_SID` - Twilio account SID
- `SENDGRID_API_KEY` - SendGrid API key
- `STRIPE_SECRET_KEY` - Stripe secret key
- `FIREBASE_PROJECT_ID` - Firebase project ID

## 🗄️ Database Schema

The application uses PostgreSQL with the following main tables:

- `users` - User accounts and authentication
- `user_profiles` - Detailed user profiles and preferences
- `user_photos` - Profile photos and media
- `user_prompts` - Profile prompts and answers
- `swipes` - Like/pass/super like actions
- `matches` - Matched users
- `messages` - Chat messages between matches
- `subscriptions` - Premium subscription data
- `reports` - User reports and moderation
- `blocked_users` - Blocked user relationships

See `src/database/migrations/` for detailed schema definitions.

## 🔌 API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login with phone/email
- `POST /api/v1/auth/verify` - Verify phone/email
- `POST /api/v1/auth/refresh` - Refresh JWT token
- `POST /api/v1/auth/logout` - Logout user

### Users & Profiles
- `GET /api/v1/users/me` - Get current user
- `PUT /api/v1/users/me` - Update current user
- `GET /api/v1/profiles/:id` - Get user profile
- `PUT /api/v1/profiles` - Update profile
- `POST /api/v1/profiles/photos` - Upload photos

### Discovery
- `GET /api/v1/discovery` - Get potential matches
- `POST /api/v1/swipes` - Swipe (like/pass/super like)
- `GET /api/v1/swipes/likes` - Get users who liked you

### Matches & Messages
- `GET /api/v1/matches` - Get all matches
- `GET /api/v1/matches/:id` - Get match details
- `POST /api/v1/matches/:id/messages` - Send message
- `GET /api/v1/matches/:id/messages` - Get messages

### Subscriptions
- `GET /api/v1/subscriptions` - Get subscription status
- `POST /api/v1/subscriptions/create` - Create subscription
- `POST /api/v1/subscriptions/cancel` - Cancel subscription

For complete API documentation, visit `/api-docs` when the server is running.

## 🧪 Testing

```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Generate coverage report
npm test -- --coverage
```

## 🚢 Deployment

### Production Build

```bash
# Build the application
npm run build

# Start production server
NODE_ENV=production npm start
```

### Docker Production

```bash
# Build production image
docker build -t dating-app:latest .

# Run with docker-compose
docker-compose -f docker-compose.prod.yml up -d
```

## 📊 Monitoring & Logging

- Logs are stored in `logs/` directory
- Winston logger configured with multiple transports
- Error logs: `logs/error.log`
- Combined logs: `logs/app.log`
- Exceptions: `logs/exceptions.log`

## 🔒 Security

- JWT-based authentication
- Bcrypt password hashing (12 rounds)
- Rate limiting on all endpoints
- Helmet.js security headers
- Input validation with Joi
- SQL injection prevention (parameterized queries)
- XSS protection
- CORS configuration

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 📞 Support

For support, email support@datingapp.com or join our Slack channel.

## 🎯 Roadmap

- [ ] Implement video calling feature
- [ ] Add Stories functionality
- [ ] Build Events & Meetups module
- [ ] Create mobile app (iOS/Android)
- [ ] Implement AI-powered conversation starters
- [ ] Add advanced analytics dashboard
- [ ] Build admin panel
- [ ] Multi-language support

## 📝 Notes

This is the backend API for the dating app. The iOS and Android mobile applications are in separate repositories.
