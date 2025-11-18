import type { Knex } from 'knex';
import dotenv from 'dotenv';
import path from 'path';

dotenv.config();

const config: { [key: string]: Knex.Config } = {
  development: {
    client: 'postgresql',
    connection: {
      host: process.env.DB_HOST || 'localhost',
      port: Number(process.env.DB_PORT) || 5432,
      database: process.env.DB_NAME || 'dating_app',
      user: process.env.DB_USER || 'postgres',
      password: process.env.DB_PASSWORD || 'postgres',
    },
    pool: {
      min: Number(process.env.DB_POOL_MIN) || 2,
      max: Number(process.env.DB_POOL_MAX) || 10,
    },
    migrations: {
      tableName: 'knex_migrations',
      directory: path.join(__dirname, 'src/database/migrations'),
      extension: 'ts',
    },
    seeds: {
      directory: path.join(__dirname, 'src/database/seeds'),
      extension: 'ts',
    },
  },

  test: {
    client: 'postgresql',
    connection: {
      host: process.env.DB_HOST || 'localhost',
      port: Number(process.env.DB_PORT) || 5432,
      database: process.env.TEST_DB_NAME || 'dating_app_test',
      user: process.env.DB_USER || 'postgres',
      password: process.env.DB_PASSWORD || 'postgres',
    },
    pool: {
      min: 1,
      max: 5,
    },
    migrations: {
      tableName: 'knex_migrations',
      directory: path.join(__dirname, 'src/database/migrations'),
      extension: 'ts',
    },
    seeds: {
      directory: path.join(__dirname, 'src/database/seeds'),
      extension: 'ts',
    },
  },

  production: {
    client: 'postgresql',
    connection: {
      host: process.env.DB_HOST,
      port: Number(process.env.DB_PORT) || 5432,
      database: process.env.DB_NAME,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
    },
    pool: {
      min: Number(process.env.DB_POOL_MIN) || 2,
      max: Number(process.env.DB_POOL_MAX) || 10,
    },
    migrations: {
      tableName: 'knex_migrations',
      directory: path.join(__dirname, 'dist/database/migrations'),
      extension: 'js',
    },
    seeds: {
      directory: path.join(__dirname, 'dist/database/seeds'),
      extension: 'js',
    },
  },
};

export default config;
