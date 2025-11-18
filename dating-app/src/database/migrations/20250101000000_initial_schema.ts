import { Knex } from 'knex';

export async function up(knex: Knex): Promise<void> {
  // Users table
  await knex.schema.createTable('users', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.string('phone_number', 20).unique().notNullable();
    table.string('email', 255).unique();
    table.string('password_hash', 255);
    table.string('first_name', 100).notNullable();
    table.date('birth_date').notNullable();
    table.integer('age').notNullable();
    table.enum('gender', ['male', 'female', 'non_binary', 'other']).notNullable();
    table.enum('status', ['active', 'inactive', 'banned', 'deleted']).defaultTo('active');
    table.boolean('is_verified').defaultTo(false);
    table.boolean('is_premium').defaultTo(false);
    table.timestamp('premium_expires_at');
    table.timestamp('last_active_at');
    table.timestamps(true, true);
    table.index(['phone_number', 'email']);
    table.index('status');
  });

  // User profiles table
  await knex.schema.createTable('user_profiles', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.uuid('user_id').references('id').inTable('users').onDelete('CASCADE').notNullable();
    table.text('bio', 'mediumtext');
    table.string('occupation', 100);
    table.string('company', 100);
    table.string('school', 100);
    table.enum('education_level', ['high_school', 'some_college', 'bachelors', 'masters', 'phd']);
    table.integer('height_cm');
    table.enum('relationship_goal', ['casual', 'serious', 'unsure', 'friendship']).notNullable();
    table.specificType('interests', 'text[]');
    table.point('location');
    table.string('city', 100);
    table.string('state', 50);
    table.string('country', 50);
    table.integer('distance_preference_km').defaultTo(50);
    table.integer('min_age_preference').defaultTo(18);
    table.integer('max_age_preference').defaultTo(99);
    table.specificType('gender_preference', 'text[]');
    table.timestamps(true, true);
    table.unique('user_id');
    table.index('location', null, 'gist');
  });

  // User photos table
  await knex.schema.createTable('user_photos', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.uuid('user_id').references('id').inTable('users').onDelete('CASCADE').notNullable();
    table.string('url', 500).notNullable();
    table.string('thumbnail_url', 500);
    table.integer('position').notNullable().defaultTo(0);
    table.boolean('is_primary').defaultTo(false);
    table.integer('quality_score').defaultTo(0);
    table.timestamps(true, true);
    table.index(['user_id', 'position']);
  });

  // User prompts table
  await knex.schema.createTable('user_prompts', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.uuid('user_id').references('id').inTable('users').onDelete('CASCADE').notNullable();
    table.string('prompt_text', 500).notNullable();
    table.text('answer', 'mediumtext').notNullable();
    table.integer('position').notNullable().defaultTo(0);
    table.timestamps(true, true);
    table.index(['user_id', 'position']);
  });

  // Swipes/Likes table
  await knex.schema.createTable('swipes', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.uuid('swiper_id').references('id').inTable('users').onDelete('CASCADE').notNullable();
    table.uuid('swiped_id').references('id').inTable('users').onDelete('CASCADE').notNullable();
    table.enum('action', ['like', 'pass', 'super_like']).notNullable();
    table.timestamp('created_at').defaultTo(knex.fn.now());
    table.unique(['swiper_id', 'swiped_id']);
    table.index(['swiper_id', 'action']);
    table.index(['swiped_id', 'action']);
  });

  // Matches table
  await knex.schema.createTable('matches', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.uuid('user1_id').references('id').inTable('users').onDelete('CASCADE').notNullable();
    table.uuid('user2_id').references('id').inTable('users').onDelete('CASCADE').notNullable();
    table.boolean('is_active').defaultTo(true);
    table.timestamp('matched_at').defaultTo(knex.fn.now());
    table.timestamp('last_message_at');
    table.timestamps(true, true);
    table.unique(['user1_id', 'user2_id']);
    table.index('matched_at');
  });

  // Messages table
  await knex.schema.createTable('messages', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.uuid('match_id').references('id').inTable('matches').onDelete('CASCADE').notNullable();
    table.uuid('sender_id').references('id').inTable('users').onDelete('CASCADE').notNullable();
    table.uuid('receiver_id').references('id').inTable('users').onDelete('CASCADE').notNullable();
    table.text('content', 'mediumtext').notNullable();
    table.enum('type', ['text', 'image', 'video', 'audio', 'gif']).defaultTo('text');
    table.string('media_url', 500);
    table.boolean('is_read').defaultTo(false);
    table.timestamp('read_at');
    table.timestamp('created_at').defaultTo(knex.fn.now());
    table.index(['match_id', 'created_at']);
    table.index(['receiver_id', 'is_read']);
  });

  // Subscriptions table
  await knex.schema.createTable('subscriptions', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.uuid('user_id').references('id').inTable('users').onDelete('CASCADE').notNullable();
    table.enum('plan_type', ['premium', 'premium_plus']).notNullable();
    table.string('stripe_subscription_id', 255).unique();
    table.string('stripe_customer_id', 255);
    table.enum('status', ['active', 'canceled', 'past_due', 'unpaid']).notNullable();
    table.timestamp('current_period_start').notNullable();
    table.timestamp('current_period_end').notNullable();
    table.boolean('cancel_at_period_end').defaultTo(false);
    table.timestamps(true, true);
    table.index('user_id');
    table.index('stripe_subscription_id');
  });

  // Reported users table
  await knex.schema.createTable('reports', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.uuid('reporter_id').references('id').inTable('users').onDelete('CASCADE').notNullable();
    table.uuid('reported_id').references('id').inTable('users').onDelete('CASCADE').notNullable();
    table.enum('reason', [
      'inappropriate_content',
      'harassment',
      'fake_profile',
      'scam',
      'underage',
      'other',
    ]).notNullable();
    table.text('description');
    table.enum('status', ['pending', 'reviewed', 'actioned', 'dismissed']).defaultTo('pending');
    table.timestamps(true, true);
    table.index(['reported_id', 'status']);
  });

  // Blocked users table
  await knex.schema.createTable('blocked_users', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.uuid('blocker_id').references('id').inTable('users').onDelete('CASCADE').notNullable();
    table.uuid('blocked_id').references('id').inTable('users').onDelete('CASCADE').notNullable();
    table.timestamp('created_at').defaultTo(knex.fn.now());
    table.unique(['blocker_id', 'blocked_id']);
    table.index('blocker_id');
  });

  // Enable PostGIS extension for location queries
  await knex.raw('CREATE EXTENSION IF NOT EXISTS postgis;');
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists('blocked_users');
  await knex.schema.dropTableIfExists('reports');
  await knex.schema.dropTableIfExists('subscriptions');
  await knex.schema.dropTableIfExists('messages');
  await knex.schema.dropTableIfExists('matches');
  await knex.schema.dropTableIfExists('swipes');
  await knex.schema.dropTableIfExists('user_prompts');
  await knex.schema.dropTableIfExists('user_photos');
  await knex.schema.dropTableIfExists('user_profiles');
  await knex.schema.dropTableIfExists('users');
}
