import express, { Application, Request, Response } from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import morgan from 'morgan';
import { Server as SocketIOServer } from 'socket.io';
import { createServer } from 'http';

// Load environment variables
dotenv.config();

// Import configurations
import { checkDatabaseConnection, closeDatabaseConnection } from '../config/database';
import { checkRedisConnection, closeRedisConnection } from '../config/redis';
import logger from '../config/logger';

// Initialize Express app
const app: Application = express();
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || 'development';

// Create HTTP server for Socket.io
const httpServer = createServer(app);
const io = new SocketIOServer(httpServer, {
  cors: {
    origin: process.env.CORS_ORIGIN?.split(',') || '*',
    credentials: true,
  },
});

// Middleware
app.use(helmet()); // Security headers
app.use(cors({
  origin: process.env.CORS_ORIGIN?.split(',') || '*',
  credentials: process.env.CORS_CREDENTIALS === 'true',
}));
app.use(compression()); // Compress responses
app.use(express.json({ limit: '10mb' })); // Parse JSON bodies
app.use(express.urlencoded({ extended: true, limit: '10mb' })); // Parse URL-encoded bodies

// Logging
if (NODE_ENV === 'development') {
  app.use(morgan('dev'));
} else {
  app.use(morgan('combined', {
    stream: {
      write: (message: string) => logger.info(message.trim()),
    },
  }));
}

// Health check endpoint
app.get('/health', async (_req: Request, res: Response) => {
  const dbHealthy = await checkDatabaseConnection();
  const redisHealthy = await checkRedisConnection();

  const health = {
    status: dbHealthy && redisHealthy ? 'healthy' : 'unhealthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: NODE_ENV,
    database: dbHealthy ? 'connected' : 'disconnected',
    redis: redisHealthy ? 'connected' : 'disconnected',
  };

  const statusCode = health.status === 'healthy' ? 200 : 503;
  res.status(statusCode).json(health);
});

// API version endpoint
app.get('/api', (_req: Request, res: Response) => {
  res.json({
    name: 'Dating App API',
    version: process.env.API_VERSION || 'v1',
    description: 'Social dating app backend - Inspired by Tinder, Bumble, and Hinge',
    documentation: '/api-docs',
  });
});

// Socket.io connection handling
io.on('connection', (socket) => {
  logger.info(`Socket connected: ${socket.id}`);

  socket.on('disconnect', () => {
    logger.info(`Socket disconnected: ${socket.id}`);
  });

  // Add more socket event handlers here
});

// 404 handler
app.use((_req: Request, res: Response) => {
  res.status(404).json({
    success: false,
    message: 'Route not found',
  });
});

// Global error handler
app.use((err: Error, _req: Request, res: Response, _next: any) => {
  logger.error('Unhandled error:', err);

  res.status(500).json({
    success: false,
    message: NODE_ENV === 'development' ? err.message : 'Internal server error',
    ...(NODE_ENV === 'development' && { stack: err.stack }),
  });
});

// Graceful shutdown
const gracefulShutdown = async (signal: string) => {
  logger.info(`${signal} received. Starting graceful shutdown...`);

  // Stop accepting new connections
  httpServer.close(async () => {
    logger.info('HTTP server closed');

    // Close database connections
    await closeDatabaseConnection();
    await closeRedisConnection();

    logger.info('Graceful shutdown completed');
    process.exit(0);
  });

  // Force shutdown after 10 seconds
  setTimeout(() => {
    logger.error('Forced shutdown after timeout');
    process.exit(1);
  }, 10000);
};

// Listen for termination signals
process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

// Unhandled rejection handler
process.on('unhandledRejection', (reason: any, promise: Promise<any>) => {
  logger.error('Unhandled Promise Rejection:', { reason, promise });
});

// Uncaught exception handler
process.on('uncaughtException', (error: Error) => {
  logger.error('Uncaught Exception:', error);
  gracefulShutdown('UNCAUGHT_EXCEPTION');
});

// Start server
const startServer = async () => {
  try {
    // Check database connection
    const dbConnected = await checkDatabaseConnection();
    if (!dbConnected) {
      throw new Error('Failed to connect to database');
    }

    // Check Redis connection
    const redisConnected = await checkRedisConnection();
    if (!redisConnected) {
      throw new Error('Failed to connect to Redis');
    }

    // Start listening
    httpServer.listen(PORT, () => {
      logger.info(`🚀 Dating App API server running on port ${PORT}`);
      logger.info(`📝 Environment: ${NODE_ENV}`);
      logger.info(`🏥 Health check: http://localhost:${PORT}/health`);
      logger.info(`📚 API info: http://localhost:${PORT}/api`);
    });
  } catch (error) {
    logger.error('Failed to start server:', error);
    process.exit(1);
  }
};

// Start the server
startServer();

export { app, io, httpServer };
