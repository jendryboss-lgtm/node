import knex, { Knex } from 'knex';
import { Model } from 'objection';
import config from '../knexfile';

const environment = process.env.NODE_ENV || 'development';
const knexConfig = config[environment];

// Initialize Knex
export const db: Knex = knex(knexConfig);

// Bind Objection models to the knex instance
Model.knex(db);

// Connection health check
export const checkDatabaseConnection = async (): Promise<boolean> => {
  try {
    await db.raw('SELECT 1');
    console.log('✅ Database connection established successfully');
    return true;
  } catch (error) {
    console.error('❌ Database connection failed:', error);
    return false;
  }
};

// Graceful shutdown
export const closeDatabaseConnection = async (): Promise<void> => {
  try {
    await db.destroy();
    console.log('Database connection closed');
  } catch (error) {
    console.error('Error closing database connection:', error);
  }
};

export default db;
