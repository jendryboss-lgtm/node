import Redis from 'ioredis';

const redisConfig = {
  host: process.env.REDIS_HOST || 'localhost',
  port: Number(process.env.REDIS_PORT) || 6379,
  password: process.env.REDIS_PASSWORD || undefined,
  db: Number(process.env.REDIS_DB) || 0,
  retryStrategy: (times: number) => {
    const delay = Math.min(times * 50, 2000);
    return delay;
  },
  maxRetriesPerRequest: 3,
};

// Main Redis client for caching
export const redisClient = new Redis(redisConfig);

// Separate client for pub/sub (required for Socket.io)
export const redisPubClient = new Redis(redisConfig);
export const redisSubClient = new Redis(redisConfig);

// Connection event handlers
redisClient.on('connect', () => {
  console.log('✅ Redis client connected');
});

redisClient.on('error', (err) => {
  console.error('❌ Redis client error:', err);
});

redisClient.on('ready', () => {
  console.log('✅ Redis client ready');
});

// Health check
export const checkRedisConnection = async (): Promise<boolean> => {
  try {
    const result = await redisClient.ping();
    return result === 'PONG';
  } catch (error) {
    console.error('Redis health check failed:', error);
    return false;
  }
};

// Graceful shutdown
export const closeRedisConnection = async (): Promise<void> => {
  try {
    await redisClient.quit();
    await redisPubClient.quit();
    await redisSubClient.quit();
    console.log('Redis connections closed');
  } catch (error) {
    console.error('Error closing Redis connections:', error);
  }
};

// Cache helper functions
export const cacheSet = async (key: string, value: any, ttl?: number): Promise<void> => {
  const serialized = JSON.stringify(value);
  if (ttl) {
    await redisClient.setex(key, ttl, serialized);
  } else {
    await redisClient.set(key, serialized);
  }
};

export const cacheGet = async <T>(key: string): Promise<T | null> => {
  const data = await redisClient.get(key);
  return data ? JSON.parse(data) : null;
};

export const cacheDel = async (key: string): Promise<void> => {
  await redisClient.del(key);
};

export const cacheDelPattern = async (pattern: string): Promise<void> => {
  const keys = await redisClient.keys(pattern);
  if (keys.length > 0) {
    await redisClient.del(...keys);
  }
};

export default redisClient;
