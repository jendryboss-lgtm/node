// Jest setup file
import dotenv from 'dotenv';

// Load test environment variables
dotenv.config({ path: '.env.test' });

// Set test environment
process.env.NODE_ENV = 'test';
process.env.LOG_LEVEL = 'error'; // Reduce log noise in tests

// Global test timeout
jest.setTimeout(10000);

// Mock console methods to reduce noise
global.console = {
  ...console,
  log: jest.fn(),
  info: jest.fn(),
  debug: jest.fn(),
  // Keep error and warn for debugging
};

// Setup runs before all tests
beforeAll(async () => {
  // Add global test setup here
  // e.g., initialize test database, clear Redis cache, etc.
});

// Teardown runs after all tests
afterAll(async () => {
  // Add global test teardown here
  // e.g., close database connections, cleanup test data
});

// Reset mocks between tests
afterEach(() => {
  jest.clearAllMocks();
});
