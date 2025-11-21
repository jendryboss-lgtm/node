import winston from 'winston';
import path from 'path';

const logLevel = process.env.LOG_LEVEL || 'info';
const logFilePath = process.env.LOG_FILE_PATH || './logs/app.log';

// Custom format for console output
const consoleFormat = winston.format.combine(
  winston.format.colorize(),
  winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  winston.format.printf(({ level, message, timestamp, ...meta }) => {
    let metaString = '';
    if (Object.keys(meta).length > 0) {
      metaString = `\n${JSON.stringify(meta, null, 2)}`;
    }
    return `${timestamp} [${level}]: ${message}${metaString}`;
  }),
);

// JSON format for file output
const fileFormat = winston.format.combine(
  winston.format.timestamp(),
  winston.format.errors({ stack: true }),
  winston.format.json(),
);

// Create logger instance
export const logger = winston.createLogger({
  level: logLevel,
  format: fileFormat,
  defaultMeta: { service: 'dating-app' },
  transports: [
    // Console transport
    new winston.transports.Console({
      format: consoleFormat,
    }),
    // Error log file
    new winston.transports.File({
      filename: path.join(path.dirname(logFilePath), 'error.log'),
      level: 'error',
      format: fileFormat,
    }),
    // Combined log file
    new winston.transports.File({
      filename: logFilePath,
      format: fileFormat,
    }),
  ],
  exceptionHandlers: [
    new winston.transports.File({
      filename: path.join(path.dirname(logFilePath), 'exceptions.log'),
    }),
  ],
  rejectionHandlers: [
    new winston.transports.File({
      filename: path.join(path.dirname(logFilePath), 'rejections.log'),
    }),
  ],
});

// Don't log to file in test environment
if (process.env.NODE_ENV === 'test') {
  logger.clear();
  logger.add(
    new winston.transports.Console({
      format: consoleFormat,
      silent: true,
    }),
  );
}

export default logger;
