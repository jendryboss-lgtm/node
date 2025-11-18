export const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Dating App API',
      version: '1.0.0',
      description: 'Social dating app backend API - Inspired by Tinder, Bumble, and Hinge',
      contact: {
        name: 'API Support',
        email: 'support@datingapp.com',
      },
      license: {
        name: 'MIT',
        url: 'https://opensource.org/licenses/MIT',
      },
    },
    servers: [
      {
        url: 'http://localhost:3000',
        description: 'Development server',
      },
      {
        url: 'https://api.datingapp.com',
        description: 'Production server',
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
          description: 'Enter your JWT token',
        },
      },
      schemas: {
        User: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            phone_number: { type: 'string' },
            email: { type: 'string', format: 'email' },
            first_name: { type: 'string' },
            birth_date: { type: 'string', format: 'date' },
            age: { type: 'integer' },
            gender: { type: 'string', enum: ['male', 'female', 'non_binary', 'other'] },
            status: { type: 'string', enum: ['active', 'inactive', 'banned', 'deleted'] },
            is_verified: { type: 'boolean' },
            is_premium: { type: 'boolean' },
            created_at: { type: 'string', format: 'date-time' },
          },
        },
        UserProfile: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            user_id: { type: 'string', format: 'uuid' },
            bio: { type: 'string' },
            occupation: { type: 'string' },
            company: { type: 'string' },
            school: { type: 'string' },
            education_level: {
              type: 'string',
              enum: ['high_school', 'some_college', 'bachelors', 'masters', 'phd'],
            },
            height_cm: { type: 'integer' },
            relationship_goal: { type: 'string', enum: ['casual', 'serious', 'unsure', 'friendship'] },
            interests: { type: 'array', items: { type: 'string' } },
            city: { type: 'string' },
            distance_preference_km: { type: 'integer' },
          },
        },
        Match: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            user1_id: { type: 'string', format: 'uuid' },
            user2_id: { type: 'string', format: 'uuid' },
            is_active: { type: 'boolean' },
            matched_at: { type: 'string', format: 'date-time' },
          },
        },
        Message: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            match_id: { type: 'string', format: 'uuid' },
            sender_id: { type: 'string', format: 'uuid' },
            content: { type: 'string' },
            type: { type: 'string', enum: ['text', 'image', 'video', 'audio', 'gif'] },
            is_read: { type: 'boolean' },
            created_at: { type: 'string', format: 'date-time' },
          },
        },
        Error: {
          type: 'object',
          properties: {
            success: { type: 'boolean', example: false },
            message: { type: 'string' },
            errors: { type: 'array', items: { type: 'object' } },
          },
        },
      },
      responses: {
        UnauthorizedError: {
          description: 'Authentication token is missing or invalid',
          content: {
            'application/json': {
              schema: {
                $ref: '#/components/schemas/Error',
              },
            },
          },
        },
        BadRequestError: {
          description: 'Invalid request data',
          content: {
            'application/json': {
              schema: {
                $ref: '#/components/schemas/Error',
              },
            },
          },
        },
        NotFoundError: {
          description: 'Resource not found',
          content: {
            'application/json': {
              schema: {
                $ref: '#/components/schemas/Error',
              },
            },
          },
        },
      },
    },
    security: [
      {
        bearerAuth: [],
      },
    ],
    tags: [
      {
        name: 'Authentication',
        description: 'User authentication and authorization endpoints',
      },
      {
        name: 'Users',
        description: 'User management endpoints',
      },
      {
        name: 'Profiles',
        description: 'User profile management',
      },
      {
        name: 'Discovery',
        description: 'Browse and discover potential matches',
      },
      {
        name: 'Swipes',
        description: 'Like, pass, and super like actions',
      },
      {
        name: 'Matches',
        description: 'Match management',
      },
      {
        name: 'Messages',
        description: 'Messaging between matched users',
      },
      {
        name: 'Subscriptions',
        description: 'Premium subscription management',
      },
    ],
  },
  apis: ['./src/api/routes/*.ts', './src/api/controllers/*.ts'],
};

export default swaggerOptions;
